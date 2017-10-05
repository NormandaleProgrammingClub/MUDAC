# DDL for MUDAC schema
# Warning: executing this script will delete and replace all tables and delete all data

USE MUDAC;

DROP TABLE IF EXISTS MEMBER_INFORMATION_ST;
DROP TABLE IF EXISTS MEDICAL_TRN_ST;
DROP TABLE IF EXISTS MEDICAL_TAR_ST;
DROP TABLE IF EXISTS CONFINEMENT_TRN_ST;
DROP TABLE IF EXISTS CONFINEMENT_TAR_ST;
DROP TABLE IF EXISTS RX_TRN_ST;
DROP TABLE IF EXISTS RX_TAR_ST;
DROP TABLE IF EXISTS LABRESULT_TRN_ST;
DROP TABLE IF EXISTS LABRESULT_TAR_ST;
DROP TABLE IF EXISTS LU_DIAGNOSIS_ST;
DROP TABLE IF EXISTS LU_PROCEDURE_ST;
DROP TABLE IF EXISTS ABNL_CD_ST;
DROP TABLE IF EXISTS AHFSCLSS;
DROP TABLE IF EXISTS DRG_ST;
DROP TABLE IF EXISTS POS_ST;
DROP TABLE IF EXISTS STATE_ST;
DROP TABLE IF EXISTS PROVAT_ST;
DROP TABLE IF EXISTS RVNU_CD_ST;


-- --------------------------------------------------------

--
-- Table structure for table `ABNL_CD_ST`
--

CREATE TABLE `ABNL_CD_ST` (
  `ABNL_CD` varchar(5) NOT NULL,
  `ABNL_DESC` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `AHFSCLSS_ST`
--

CREATE TABLE `AHFSCLSS_ST` (
  `AHFSCLSS` varchar(10) NOT NULL,
  `AHFSCLSS_DESC` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `CONFINEMENT_TAR_ST`
--

CREATE TABLE `CONFINEMENT_TAR_ST` (
  `ID` int(11) NOT NULL,
  `PATID` int(8) NOT NULL,
  `CONF_ID` varchar(8) NOT NULL,
  `STD_COST` decimal(10,8) NOT NULL,
  `DRG` int(8) NOT NULL,
  `POS` varchar(5) DEFAULT NULL,
  `DIAG1` varchar(7) DEFAULT NULL,
  `DIAG2` varchar(7) DEFAULT NULL,
  `DIAG3` varchar(7) DEFAULT NULL,
  `DIAG4` varchar(7) DEFAULT NULL,
  `DIAG5` varchar(7) DEFAULT NULL,
  `PROC1` varchar(7) DEFAULT NULL,
  `PROC2` varchar(7) DEFAULT NULL,
  `PROC3` varchar(7) DEFAULT NULL,
  `PROC4` varchar(7) DEFAULT NULL,
  `PROC5` varchar(7) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL,
  `DISHARGE_DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `CONFINEMENT_TRN_ST`
--

CREATE TABLE `CONFINEMENT_TRN_ST` (
  `ID` int(11) NOT NULL,
  `PATID` int(8) NOT NULL,
  `CONF_ID` varchar(8) NOT NULL,
  `STD_COST` decimal(10,8) NOT NULL,
  `DRG` int(8) NOT NULL,
  `POS` varchar(5) DEFAULT NULL,
  `DIAG1` varchar(7) DEFAULT NULL,
  `DIAG2` varchar(7) DEFAULT NULL,
  `DIAG3` varchar(7) DEFAULT NULL,
  `DIAG4` varchar(7) DEFAULT NULL,
  `DIAG5` varchar(7) DEFAULT NULL,
  `PROC1` varchar(7) DEFAULT NULL,
  `PROC2` varchar(7) DEFAULT NULL,
  `PROC3` varchar(7) DEFAULT NULL,
  `PROC4` varchar(7) DEFAULT NULL,
  `PROC5` varchar(7) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL,
  `DISCHARGE_DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `DRG_ST`
--

CREATE TABLE `DRG_ST` (
  `DRG` varchar(10) NOT NULL,
  `DRG_DESC` varchar(120) NOT NULL,
  `EFF_DATE` datetime DEFAULT NULL,
  `END_DATE` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `LABRESULT_TAR_ST`
--

CREATE TABLE `LABRESULT_TAR_ST` (
  `ID` int(11) NOT NULL,
  `PAT_ID` int(8) NOT NULL,
  `ABNL_CD` varchar(2) NOT NULL,
  `ANALYTICSEQ` varchar(2) NOT NULL,
  `HI_NRML` decimal(10,8) DEFAULT NULL,
  `LABCLMID` varchar(19) DEFAULT NULL,
  `LOINC_CD` varchar(7) DEFAULT NULL,
  `LOW_NRML` decimal(10,8) DEFAULT NULL,
  `PROC_CD` varchar(7) DEFAULT NULL,
  `RSLT_NBR` decimal(10,8) DEFAULT NULL,
  `RSLT_TXT` varchar(18) DEFAULT NULL,
  `RSLT_UNIT_NM` varchar(18) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `LABRESULT_TRN_ST`
--

CREATE TABLE `LABRESULT_TRN_ST` (
  `ID` int(11) NOT NULL,
  `PAT_ID` int(8) NOT NULL,
  `ABNL_CD` varchar(2) NOT NULL,
  `ANALYTICSEQ` varchar(2) NOT NULL,
  `HI_NRML` decimal(10,8) DEFAULT NULL,
  `LABCLMID` varchar(19) DEFAULT NULL,
  `LOINC_CD` varchar(7) DEFAULT NULL,
  `LOW_NRML` decimal(10,8) DEFAULT NULL,
  `PROC_CD` varchar(7) DEFAULT NULL,
  `RSLT_NBR` decimal(10,8) DEFAULT NULL,
  `RSLT_TXT` varchar(18) DEFAULT NULL,
  `RSLT_UNIT_NM` varchar(18) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `LU_DIAGNOSIS_ST`
--

CREATE TABLE `LU_DIAGNOSIS_ST` (
  `DIAG_ID` varchar(10) NOT NULL,
  `DIAG_DESC` varchar(100) NOT NULL,
  `DIAG_FST3_CD` varchar(3) NOT NULL,
  `DIAG_FST3_DESC` varchar(35) DEFAULT NULL,
  `DIAG_FST4_CD` varchar(3) DEFAULT NULL,
  `DIAG_FST4_DESC` varchar(35) DEFAULT NULL,
  `GDR_SPEC_CD` varchar(5) DEFAULT NULL,
  `MDC_CD_DESC` varchar(75) DEFAULT NULL,
  `MDC_CODE` varchar(10) DEFAULT NULL,
  `ICD_VER_CD` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `LU_PROCEDURE_ST`
--

CREATE TABLE `LU_PROCEDURE_ST` (
  `CATEGORY_DTL_CD` varchar(5) NOT NULL,
  `CATEGORY_DTL_CODE_DESC` varchar(50) NOT NULL,
  `CATEGORY_GENL_CD` varchar(5) NOT NULL,
  `CATEGORY_GENL_CODE_DESC` varchar(5) NOT NULL,
  `PROC_CD` varchar(10) DEFAULT NULL,
  `PROC_DESC` varchar(100) DEFAULT NULL,
  `PROC_END_DATE` decimal(10,5) DEFAULT NULL,
  `PROC_TYP_CD` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `MEDICAL_TAR_ST`
--

CREATE TABLE `MEDICAL_TAR_ST` (
  `ID` int(11) NOT NULL,
  `PATID` int(11) NOT NULL,
  `CLMID` varchar(19) NOT NULL,
  `CONF_ID` varchar(21) DEFAULT NULL,
  `POS` varchar(5) DEFAULT NULL,
  `DRG` varchar(5) DEFAULT NULL,
  `PROVCAT` varchar(5) DEFAULT NULL,
  `RVNU_CD` varchar(4) DEFAULT NULL,
  `PROC_CD` varchar(21) DEFAULT NULL,
  `DIAG1` varchar(7) DEFAULT NULL,
  `DIAG2` varchar(7) DEFAULT NULL,
  `DIAG3` varchar(7) DEFAULT NULL,
  `DIAG4` varchar(7) DEFAULT NULL,
  `DIAG5` varchar(7) DEFAULT NULL,
  `PROC1` varchar(7) DEFAULT NULL,
  `PROC2` varchar(7) DEFAULT NULL,
  `PROC3` varchar(7) DEFAULT NULL,
  `PROC4` varchar(7) DEFAULT NULL,
  `PROC5` varchar(7) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `MEDICAL_TRN_ST`
--

CREATE TABLE `MEDICAL_TRN_ST` (
  `ID` int(11) NOT NULL,
  `PATID` int(11) NOT NULL,
  `CLMID` varchar(19) NOT NULL,
  `CONF_ID` varchar(21) DEFAULT NULL,
  `POS` varchar(5) DEFAULT NULL,
  `DRG` varchar(5) DEFAULT NULL,
  `PROVCAT` varchar(5) DEFAULT NULL,
  `RVNU_CD` varchar(4) DEFAULT NULL,
  `PROC_CD` varchar(21) DEFAULT NULL,
  `DIAG1` varchar(7) DEFAULT NULL,
  `DIAG2` varchar(7) DEFAULT NULL,
  `DIAG3` varchar(7) DEFAULT NULL,
  `DIAG4` varchar(7) DEFAULT NULL,
  `DIAG5` varchar(7) DEFAULT NULL,
  `PROC1` varchar(7) DEFAULT NULL,
  `PROC2` varchar(7) DEFAULT NULL,
  `PROC3` varchar(7) DEFAULT NULL,
  `PROC4` varchar(7) DEFAULT NULL,
  `PROC5` varchar(7) DEFAULT NULL,
  `DAYS_FROM_DIAG` int(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `MEMBER_INFORMATION_ST`
--

CREATE TABLE `MEMBER_INFORMATION_ST` (
  `PATID` int(9) NOT NULL,
  `GENDER` varchar(10) DEFAULT NULL,
  `YEAR_OF_BIRTH` int(4) DEFAULT NULL,
  `STATE` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `POS_ST`
--

CREATE TABLE `POS_ST` (
  `POS` varchar(10) NOT NULL,
  `POS_DESC` varchar(120) NOT NULL,
  `POS_CAT` varchar(120) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `PROVCAT_ST`
--

CREATE TABLE `PROVCAT_ST` (
  `PROVCAT` varchar(10) NOT NULL,
  `PROVCAT_DESC` varchar(120) NOT NULL,
  `CATGY_ROL_UP_1_DESC` varchar(120) DEFAULT NULL,
  `CATGY_ROL_UP_2_DESC` varchar(120) DEFAULT NULL,
  `CATGY_ROL_UP_3_DESC` varchar(120) DEFAULT NULL,
  `CATGY_ROL_UP_4_DESC` varchar(120) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
