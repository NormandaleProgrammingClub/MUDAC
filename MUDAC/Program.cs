using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.IO;
using MySql.Data.MySqlClient;

namespace MUDAC
{
    class Program
    {
        static MySqlConnection conn;
        static string myConnectionString;

        //static string ServerURL = "73.164.14.207"; // Ben's Pi
        //static string TableName = "MUDAC.confinement_target";
        static string ServerURL = "ncccpc.elysianisle.us"; // Ben's Pi
        static string TableName = "MUDAC_TEST.confinement_target";
        static string DataFile = @"D:\Data\target_(1)\confinement_target.csv";

        static void Main(string[] args)
        {
            Console.WriteLine("Please enter your MySQL server credentials:");
            Console.Write("Username: ");
            string u = Console.ReadLine();
            Console.Write("Password: ");
            myConnectionString = "server=" + ServerURL + ";uid=" + u + ";pwd=" + ReadPassword() + ";";

            try
            {
                Console.WriteLine("Connecting to server...");
                conn = new MySqlConnection(myConnectionString);
                conn.Open();
                Console.WriteLine("Connected");
            }
            catch (MySqlException ex)
            {
                Console.WriteLine("Error connecting:");
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

            int RowCounter = 1;
            while (reader.Peek() >= 0)
            {
                Console.WriteLine("Data Row " + RowCounter);
                String[] LineData = reader.ReadLine().Replace("\r", "").Replace("\n", "").Split(',');

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
                }
                catch(MySqlException ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.WriteLine();
                    Console.WriteLine("Press {ENTER} to continue");
                    Console.ReadLine();
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
