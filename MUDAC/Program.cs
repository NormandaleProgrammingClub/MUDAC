using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.IO;
using MySql.Data.MySqlClient;
using Renci.SshNet;
using System.Text.RegularExpressions;

namespace MUDAC
{
    class Program
    {
        static MySqlConnection conn;
        static SshClient client;
        static string myConnectionString;

        static string ServerURL = "73.164.14.207"; // Ben's Pi
        static string TableName = "MUDAC_RAW.LABRESULTS_TAR_ST";
        static string DataFile = @"D:\Data\target_(1)\labresults_target.csv";

        static void Main(string[] args)
        {
            // MySQL over SSH for C#: https://stackoverflow.com/questions/10806799/how-to-connect-to-mysql-from-c-sharp-over-ssh
            // Using SSH.NET library: https://github.com/sshnet/SSH.NET

            Console.WriteLine("Server: " + ServerURL);
            Console.WriteLine();
            Console.WriteLine("Please enter your SSH user credentials:");
            Console.Write("Username: ");
            string SSH_User = Console.ReadLine();
            Console.Write("Password: ");
            string SSH_Pass = ReadPassword();
            Console.WriteLine();

            try
            {
                Console.WriteLine("Connecting to " + ServerURL + ":22...");
                PasswordConnectionInfo connectionInfo = new PasswordConnectionInfo(ServerURL, SSH_User, SSH_Pass);
                connectionInfo.Timeout = TimeSpan.FromSeconds(30);
                client = new SshClient(connectionInfo);
                client.Connect();
                ForwardedPortLocal portFwld = new ForwardedPortLocal("127.0.0.1", 3306, "127.0.0.1", 3306);
                client.AddForwardedPort(portFwld);
                portFwld.Start();
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Connected");
                Console.ResetColor();
            }
            catch(Exception ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Error connecting:");
                Console.ResetColor();
                Console.WriteLine(ex.Message);
                Console.WriteLine();
                Console.WriteLine("Press {ENTER} to halt and catch fire");
                Console.ReadLine();
                return;
            }
            Console.WriteLine();
            
            Console.WriteLine("Please enter your MySQL user credentials:");
            Console.Write("Username: ");
            string MySQLUser = Console.ReadLine();
            Console.Write("Password: ");
            string MySQLPass = ReadPassword();
            myConnectionString = "server=127.0.0.1;uid=" + MySQLUser + ";pwd=" + MySQLPass + ";";

            try
            {
                Console.WriteLine("Connecting to " + ServerURL + "...");
                conn = new MySqlConnection(myConnectionString);
                conn.Open();
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Connected");
                Console.ResetColor();
            }
            catch (MySqlException ex)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine("Error connecting:");
                Console.ResetColor();
                Console.WriteLine(ex.Message);
                Console.WriteLine();
                Console.WriteLine("Press {ENTER} to halt and catch fire");
                Console.ReadLine();
                return;
            }
            Console.WriteLine();

            Console.WriteLine("Importing '" + Path.GetFileName(DataFile) + "' from " + Path.GetDirectoryName(DataFile) + "\\");
            Console.WriteLine();
            FileStream newStream = File.OpenRead(DataFile);
            StreamReader reader = new StreamReader(newStream);

            Console.WriteLine("Columns:");
            String Columns = reader.ReadLine().Replace("\r", "").Replace("\n", "");
            String Values = "";
            String[] Column = Columns.Split(',');
            for(int i=0; i<Column.Length; i++)
            {
                Console.WriteLine("    [" + i + "]: " + Column[i]);
                Values += "@col" + i;
                if (i != Column.Length - 1) Values += ",";
            }
            String Command = "INSERT INTO " + TableName + "(" + Columns + ") VALUES(" + Values + ")";
            Console.WriteLine("    Command: " + Command);
            Console.WriteLine();

            int StartPoint = 1;
            int TryStart = 1;
            Console.WriteLine("Start importing at what line? ({ENTER} for default: 1)");
            string Input = Console.ReadLine();
            while(Input != "" && !Int32.TryParse(Input, out TryStart)) // If we have something, and that something doesn't work...
            {
                Console.WriteLine("What? Please try again");
                Input = Console.ReadLine();
            }
            if (TryStart != 0) StartPoint = TryStart;
            int RowCounter = 1;

            for(int i=1; i<StartPoint; i++)
            {
                reader.ReadLine();
                RowCounter++;
            }

            while (reader.Peek() >= 0)
            {
                Console.WriteLine("Data Row " + RowCounter);
                // Regex from here: https://stackoverflow.com/questions/3776458/split-a-comma-separated-string-with-both-quoted-and-unquoted-strings
                String[] LineData = Regex.Matches(reader.ReadLine().Replace("\r", "").Replace("\n", ""), "(?:^|,)(\"(?:[^\"]+|\"\")*\"|[^,]*)")
                    .Cast<Match>()
                    .Select(m => m.Groups[1].Value)
                    .ToArray();

                try
                {
                    MySqlCommand comm = conn.CreateCommand();
                    comm.CommandText = Command;

                    for (int i = 0; i < LineData.Length; i++)
                    {
                        Console.WriteLine("    [" + Column[i] + "]: " + LineData[i]);
                        comm.Parameters.AddWithValue("@col" + i, LineData[i]);
                    }

                    comm.ExecuteNonQuery();

                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Row " + RowCounter + " successfully imported");
                    Console.ResetColor();
                }
                catch(MySqlException ex)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("Failed to import row " + RowCounter + "!");
                    Console.ResetColor();
                    Console.WriteLine(ex.Message);
                    Console.WriteLine();
                    Console.WriteLine("Press {ENTER} to halt and catch fire");
                    Console.ReadLine();
                    return;
                }
                
                RowCounter++;
            }
            
            reader.Close();
            newStream.Close();
            conn.Close();

            Console.WriteLine();
            Console.WriteLine("Finished importing");
            Console.ReadLine();
        }

        public static string ReadPassword()
        { // http://rajeshbailwal.blogspot.com/2012/03/password-in-c-console-application.html
            string password = "";
            ConsoleKeyInfo info = Console.ReadKey(true);
            while (info.Key != ConsoleKey.Enter)
            {
                if (info.Key != ConsoleKey.Backspace)
                {
                    Console.Write("*");
                    password += info.KeyChar;
                }
                else if (info.Key == ConsoleKey.Backspace)
                {
                    if (!string.IsNullOrEmpty(password))
                    {
                        password = password.Substring(0, password.Length - 1); // remove one character from the list of password characters
                        int pos = Console.CursorLeft; // get the location of the cursor
                        Console.SetCursorPosition(pos - 1, Console.CursorTop); // move the cursor to the left by one character
                        Console.Write(" "); // replace it with space
                        Console.SetCursorPosition(pos - 1, Console.CursorTop); // move the cursor to the left by one character again
                    }
                }
                info = Console.ReadKey(true);
            }
            Console.WriteLine(); // add a new line because user pressed enter at the end of their password
            return password;
        }
    }
}
