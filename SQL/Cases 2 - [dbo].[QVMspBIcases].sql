USE [QVM]
GO

/****** Object:  StoredProcedure [dbo].[QVMspBIcases]    Script Date: 6/7/2023 3:56:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:
-- Create date:
-- Alter date: Redesigned => G.K. April 2023
--			   FIX SumPaymentAmount 2023-04-10 => G.K. 2023-04-10
--			   ADD [Hartofilakio_Protofileti]  => ZB 25-04-2023		AIT-12742
--			   ADD Mutiple collumns			   => Z.B. 15-05-2023	AIT-12810

-- Description:
-- =============================================

CREATE PROC [dbo].[QVMspBIcases]
	@RUN_ID INT = NULL,
	@PARENT_PROC_NAME VARCHAR(250) = NULL
AS 
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	SET NOCOUNT ON

	--================== G.K. ====================
	DECLARE @PROC_NAME VARCHAR(250) = OBJECT_NAME(@@PROCID)
	DECLARE @TRACE NVARCHAR(250) = ''
	DECLARE @TRACE_INFO VARCHAR(500)

	-- If Proc Run Alone
	IF @RUN_ID IS NULL
	BEGIN
		SET @RUN_ID = (SELECT [dbo].[QVMfnBIgetNextRunID]())
		SET @PARENT_PROC_NAME = @PROC_NAME
	END


	BEGIN TRY

		--=======================
		--=== START PROCEDURE ===
		--=======================

		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 1


		--========================
		--======== TRACE 1 =======
		--========================
		
		SET @TRACE = 'Trace #1'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE

		DROP TABLE IF EXISTS #COS_CAMP_QVMtBIcases;

		SELECT
			crmCAMP.crmCAMP_ID,
			CASE crmOFF.crmBP_ID
				WHEN 'BP_COSMOTE' then isnull(crmPARV.crmPARV_StringValue,'COS_PRE_LEGAL')
				WHEN 'BP_OTE' then isnull(crmPARV.crmPARV_StringValue,'OTE_LEGAL')
				ELSE crmPARV.crmPARV_StringValue
			END AS CampGroup
		INTO #COS_CAMP_QVMtBIcases
		FROM 
			AR_GSLO_OLTP_REPLICA.[dbo].crmCAMP 
			INNER JOIN AR_GSLO_OLTP_REPLICA.[dbo].crmOFF 
				ON crmOFF.crmOFF_ID = crmCAMP.crmCAMP_Offering
			LEFT JOIN AR_GSLO_OLTP_REPLICA.[dbo].crmPARV 
				ON crmPARV.crmPARV_RowID = crmCAMP.crmCAMP_ID
				AND crmOBJP_ID = 'SYS_CAMP_GROUP'
		WHERE 
			(
			CASE crmOFF.crmBP_ID
				WHEN 'BP_COSMOTE' then isnull(crmPARV.crmPARV_StringValue,'COS_PRE_LEGAL')
				WHEN 'BP_OTE' then isnull(crmPARV.crmPARV_StringValue,'OTE_LEGAL')
				ELSE crmPARV.crmPARV_StringValue
				END
			) IS NOT NULL

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace #1


		--========================
		--======== TRACE 2 =======
		--========================
		
		SET @TRACE = 'Trace #2'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE


		DROP TABLE IF EXISTS #PQH_Segment_QVMtBIcases;

		CREATE TABLE #PQH_Segment_QVMtBIcases
		(
			admin_code VARCHAR(100) NOT NULL,
			kampania VARCHAR(100) NOT NULL
		)

		--ALTER TABLE #PQH_Segment_QVMtBIcases
		--ADD CONSTRAINT UQ_TMP_PQH__ADMIN_CODE UNIQUE(admin_code)

		INSERT INTO #PQH_Segment_QVMtBIcases VALUES
			('Agri_Phase_I', 'FLOW I'),
			('Retail_Woff_Phase_I', 'FLOW I'),
			('Retail_Phase_I', 'FLOW I'),
			('Agri_Phase_II','FLOW II'),
			('Retail_Woff_Phase_IΙ','FLOW II'),
			('Retail_Phase_II','FLOW II'),		
			('Agri_Phase_IIΙ','FLOW III'),
			('Retail_Woff_Phase_IIΙ','FLOW III'),
			('Retail_Phase_IIΙ','FLOW III'),
			('Legal_Escal_250_Attr_Legal_Assign','Legal Escalation'),
			('Legal_Escal_250_Attracted','Legal Escalation'),
			('Legal_Escal_250_WaveI_Διαταγή_Πληρωμής','Legal Escalation'),
			('Legal_Escal_250_WaveI_Καταψηφιστική_Αγωγή','Legal Escalation'),
			('Legal_Escal_250_WaveIII','Legal Escalation'),
			('Legal_Escal_250_WaveIV','Legal Escalation'),
			('Legal_Escal_Attracted','Legal Escalation'),
			('Legal_Escal_WaveI_Διαταγή_Πληρωμής','Legal Escalation'),
			('Legal_Escal_WaveI_Καταψηφιστική_Αγωγή','Legal Escalation'),
			('Legal_Escal_WaveII_Διαταγή_Πληρωμής','Legal Escalation'),
			('Legal_Escal_WaveII_Καταψηφιστική_Αγωγή','Legal Escalation'),
			('Legal_Escal_WaveIII','Legal Escalation'),
			('Legal_Escal_WaveIV','Legal Escalation'),
			('New Legal_escal__Attracted','Legal Escal 2019_A'),
			('New Legal_escal__Καταγγελία','Legal Escal 2019_A'),
			('New Legal_escal_Καταγγελία_Επιδίκαση','Legal Escal 2019_A'),
			('New_Gen_Policy_Secured','ΝΕΑ ΓΕΝΙΚΗ ΠΟΛΙΤΙΚΗ'),
			('New_Gen_Policy_UnSecured','ΝΕΑ ΓΕΝΙΚΗ ΠΟΛΙΤΙΚΗ'),
			('€20k - €250k_ Καταγγελία_Κλιμάκωση','Legal Initiative below 250k'),
			('€20k - €250k_Καταγγελία','Legal Initiative below 250k'),
			('€20k - €250k_Κλιμάκωση','Legal Initiative below 250k'),
			('€20k - €250k_ attracted','Legal Initiative below 250k'),
			('€20k - €250k_ Plain','Legal Initiative below 250k'),
			('Restr_cvd19_B4+','Restr_cvd19_B4+'),
			('20-250k_Legal 2020_Καταγγελία_ Κλιμάκωση','20-250k_Legal 2020'),
			('20-250k_Legal 2020_Καταγγελία','20-250k_Legal 2020'),
			('20-250k_Legal 2020_Κλιμάκωση','20-250k_Legal 2020'),
			('20-250k_Legal 2020_Attracted','20-250k_Legal 2020'),
			('250-500k_Legal20_No Mass_Legal_Action','20-250k_Legal 2020'),
			('250-500k_ Legal20_Καταγγελία','250k -500k_Legal_2020'),
			('250-500k_Legal20_Καταγγελία_Κλιμάκωση','250k -500k_Legal_2020'),
			('250-500k_Legal20_Κλιμάκωση','250k -500k_Legal_2020'),
			('250-500k_Legal20_Attracted','250k -500k_Legal_2020'),
			('20-250k_Legal 2020_No_Mass_Legal_Action','250k -500k_Legal_2020'),
			('Legal up to 250k_2021_Καταγγελία','Legal up to 250k_2021'),
			('Legal up to 250k_2021_Καταγγελία_Κλιμάκωση','Legal up to 250k_2021'),
			('Legal up to 250k_2021_Attracted','Legal up to 250k_2021'),
			('Up to 250k_2021_Debtor below 20K','Non-Legal up to 250k_2021'),
			('Up to 250k_2021_Debtor with LTV<=100%','Non-Legal up to 250k_2021'),
			('Up to 250k_2021_Debtor with LTV>100%','Non-Legal up to 250k_2021'),
			('Up to 250k_2021_Unsecured Debtor','Non-Legal up to 250k_2021')


		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 2

		
		









		--========================
		--======== TRACE 3 =======
		--========================
		
		SET @TRACE = 'Trace #3'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

	
		DROP TABLE IF EXISTS #NBG_CALC_QVMtBIcases
		
		SELECT
			crmBE_ID,
			[Υπολογιστική_οφειλή_NBG],		
			[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],
			[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],
			crwBEX_AccountCloseDT,
			crwBEX_SumExpenses_FCY
		INTO 
			#NBG_CALC_QVMtBIcases
		FROM 
			AR_GSLO_OLTP_REPLICA.dbo.Z_V_NBG_Calc_Ofeili

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 3






		--========================
		--======== TRACE 4 =======
		--========================
		
		SET @TRACE = 'Trace #4'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		--DECLARE @T TABLE(crmBE_ID VARCHAR(32))
		--IF OBJECT_ID('TempDB..#BE_QVMtBIcases') IS NOT NULL DROP TABLE #BE_QVMtBIcases
		--INSERT INTO @T

		DROP TABLE IF EXISTS #BE_QVMtBIcases

		SELECT
			DISTINCT crwBEXH.crmBE_ID
		INTO 
			#BE_QVMtBIcases
		FROM 
			AR_GSLO_OLTP_REPLICA.[dbo].crwBEXH --WITH (INDEX(AK_Contact_rowguid))
		WHERE 
			0 < 3
			AND crwBEXH.crwBEXH_SnapshotDT > GETDATE() - 365  

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 4
		
		
		






		--========================
		--======== TRACE 5 =======
		--========================
		
		SET @TRACE = 'Trace #5'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		CREATE UNIQUE CLUSTERED INDEX ID ON #BE_QVMtBIcases(crmBE_ID)

		SET @TRACE_INFO = 'CREATE CLUSTERED INDEX'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 5




		



		--========================
		--======== TRACE 6 =======
		--========================
		
		SET @TRACE = 'Trace #6'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		INSERT INTO #BE_QVMtBIcases
		SELECT
			DISTINCT crwBEX.crmBE_ID
		FROM
			AR_GSLO_OLTP_REPLICA.[dbo].crwBEX
			LEFT JOIN #BE_QVMtBIcases
				ON #BE_QVMtBIcases.crmBE_ID	= crwBEX.crmBE_ID
		WHERE
			0 < 3
			AND #BE_QVMtBIcases.crmBE_ID IS NULL
			AND ISNULL(crwBEX.crwBEX_ActiveStatus,'SYS_LOVD_BE_STATUS_ACTIVE') = 'SYS_LOVD_BE_STATUS_ACTIVE'

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 6








		
		--========================
		--======== TRACE 7 =======
		--========================
		
		SET @TRACE = 'Trace #7'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		
		ALTER INDEX ID ON #BE_QVMtBIcases REBUILD

		SET @TRACE_INFO = 'REBUILD INDEX'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 7









		--========================
		--======== TRACE 8 =======
		--========================
		
		SET @TRACE = 'Trace #8'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		DROP TABLE IF EXISTS dbo.QVMtBIcases

		SELECT
			 crwBEX.crmBE_ID
			,crmBE.crmCOFF_ID
			,crwBEX.crwBEX_CustomerID
			,REPLACE(ISNULL(crwBEX.crwBEX_ActiveStatus,'SYS_LOVD_BE_STATUS_ACTIVE'),'SYS_LOVD_BE_STATUS_','')						[ActiveStatus]
			,MLT_STS.crmMLT_TextInLanguage																							[AccountStatus]
			,crwBEX.crwBEX_COFFCustCode																								[CustomerCode]
			,crwBEX.crwBEX_COFFRefNo																								[AccountNumber]
			,ISNULL(crwBEX.crwBEX_ContractNo,'(Blank)')																				[ContactNumber]
			,BP_Vendor.crmBP_Alias																									[Vendor]
			,crmOFF.crmOFF_Name																										[Product]
			,CONVERT(DATE,crmBE.crmBE_InDateTime)																					[AssignmentDate]
			,crmCAMP.crmCAMP_ID																										[CampaignID]
			,crmCAMP.crmCAMP_CodeName																								[CampaignCodeName]
			,ISNULL(BP_Owner.crmBP_Alias,'(Blank)')																					[CaseOwner]
			,TRIM(ISNULL(crwBEX.crwBEX_In_House_Group,'(Blank)'))																	[InHouseGroup]
			,TRIM(ISNULL(crwBEX.crwBEX_In_House_Group_2,'(Blank)'))																	[InHouseGroup_2]
			,TRIM(ISNULL(crwBEX_Debtors_Portfolio,'(Blank)'))																	    [Hartofilakio_Protofileti] -- ZB 25-04-2023 AIT-12742
			,TRIM(ISNULL(crwBEX.crwBEX_MisKind,'(Blank)'))																			[MIS_Kind]
			,TRIM(ISNULL(crwBEX.crwBEX_PD_MisKind,'(Blank)'))																		[PD_MIS_Kind]
			,TRIM(ISNULL(crwBEX.crwBEX_AdministrationCode,'(Blank)'))																[AdministrationCode]
			,TRIM(ISNULL(crwBEX.crwBEX_BlackListCode,'(Blank)'))																	[BlackListCode]
			,TRIM(ISNULL(crwBEX.crwBEX_ApplNo,'(Blank)'))																			[ApplicationNumber]
			,CONVERT(INT,ISNULL(crwBEX.crwBEX_CurBucket,-10))																		[CurrentBucketNumber]
			,TRIM(ISNULL(crwBEX.crwBEX_LegalProcessStatus,'(Blank)'))																[LegalProcessStatus]
			,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LegalProcessStatusDate, ISNULL(crwBEX.crwBEX_LegalProcessStatusDate,'1903-03-03')))	[LegalProcessStatusDate]
			,TRIM(ISNULL(crwBEX.crwBEX_ProductCategory,'(Blank)'))																	[ProductCategory]
			,TRIM(ISNULL(crwBEX.crwBEX_ProductSubCategory,'(Blank)'))																[ProductSubCategory]
			,TRIM(ISNULL(crwBEX.crwBEX_ProductDescription,'(Blank)'))																[ProductDescription]
			,TRIM(ISNULL(crwBEX.crwBEX_ProductSubDescription,'(Blank)'))															[ProductSubDescription]
			,TRIM(ISNULL(crwBEX.crwBEX_BusinessUnitCode,'(Blank)'))																	[BusinessUnitCode]
			,TRIM(ISNULL(crwBEX.crwBEX_Agency_Code,'(Blank)'))																		[AgencyCode]
			,TRIM(ISNULL(crwBEX.crwBEX_Account_Branch_Name,'(Blank)'))																[BranchName]
			,TRIM(ISNULL(crwBEX.crwBEX_Denounce_Status,'(Blank)'))																	[DenounceStatus]
			,CONVERT(INT,ISNULL(REPLACE(crwBEX.crwBEX_Billing_Day,'N/A',-10),-10))													[BillingDay]
			,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LastBillingDate,'1903-03-03'))														[LastBillingDate]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_LastPmtAmount,0))																	[LastPaymentAmount]
			,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LastPmtDT,'1903-03-03'))																[LastPaymentDate]
			,TRIM(ISNULL(crwBEX_Asset_Class,'(Blank)'))																				[AssetClass]
			,CONVERT(INT,ISNULL(crwBEX.crwBEX_DEL_DAYS,-10))																		[DelayDays]
			,CONVERT(DATE,ISNULL(crwBEX_DeliqLetter1Date,'1903-03-03'))																[Issue_Date]
			,CONVERT(DATE,ISNULL(crwBEX_DeliqLetter2Date,'1903-03-03'))																[Transaction_Date]
			,TRIM(ISNULL(crwBEX.crwBEX_Strategy_Step, ISNULL(crwBEX.crwBEX_StrategyStepDescr,'')))									[StrategyStep]
			,TRIM(ISNULL(crwBEX.crwBEX_Strategy_Description, ISNULL(crwBEX.crwBEX_StrategyDescr,'')))								[StrategyDescription]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OSBalance,0))																		[OSBalance]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OsAsset,0))																			[OSAsset]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OsBalanceAssign,0))																	[Ass_OS_Balance]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_Overdue_Other_Amount,0))															[OverdueAmount]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_FrozenIntAmount,0))																	[FrozenAmount]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_AccountingBalance,0))																[AccountingBalance]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_DelinqAmount,0))																	[DelinqAmount]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalBalanceMLT,0))																	[TotalBalanceMLT]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_WriteOffAmount,0))																	[WriteOffAmount]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_DebtAmount_FCY,0))																	[DebtAmount]
			,CONVERT(MONEY,ISNULL(/*OA_TRN.BLNC*/NULL,0))																			[LT_Balance]	
			,CONVERT(MONEY,ISNULL(/*OA_TRN_Plus.BLNC*/NULL,0))																		[LT_BalancePlus]	
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OSBalance,0))																		[Balance]
			,CONVERT(BIT,0)																											[LastAssignment]
			,CONVERT(INT,0)																											[Relatives]
			,CONVERT(TINYINT,1)																										[CaseCounter]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_AccountingBalance,0)) - CONVERT(MONEY,ISNULL(crwBEX.crwBEX_FrozenIntAmount,0))		[NBG_Amount]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalBalance,0))																	[TotalBalance]
			,TRIM(ISNULL(crwBEX.crwBEX_FinancialStatus,'(Blank)'))																	[FinancialStatus]
			,TRIM(ISNULL(crwCOFFX.crwBEX_SPV,'(Blank)'))																			[SPV]
			,TRIM(ISNULL(crwCOFFX.crwBEX_SPV_Category,'(Blank)'))																	[SPV_Category]
			,TRIM(ISNULL(crwBEX_SubProdCategory,'(Blank)'))																			[SubProductCategory]
			,ISNULL(crwBEX.crwBEX_ServAccNumber,'(Blank)')																			[ServiceAccountNumber]
			,ISNULL(crwCOFFX.crwbex_Covid19,'(Blank)')																				[Covid19]
			,ISNULL(COSCAMP.CampGroup,'(Blank)') 																					[COS_Campaigns]
			,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalCaseAccountBalance,0))															[TotalCaseAccountBalance]
			,CONVERT(MONEY,ISNULL(crwcoffx.crwBEX_AccBalanceCase,0))																[AccBalanceCase]       
			,CONVERT(MONEY,ISNULL(crwcoffx.crwBEX_CASE_LINK_ACC_AMT,0))																[CASE_LINK_ACC_AMT]
			,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalAction,'(Blank)')																[LastLegalAction]
			,CONVERT(DATE,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalActionDate,'1903-03-03'))											[LastLegalActionDate]
			,CONVERT(MONEY,ISNULL(crwcoffx.GSLO_Pmt_Confirm_Amnt,0))																[Confirm_Amnt]
			,CONVERT(DATE,ISNULL(crwcoffx.GSLO_Pmt_Confirm_DT,'1903-03-03'))														[Confirm_DT]
			,CONVERT(VARCHAR(100),'(Blank)')																						[PQH_Segment]
			,CONVERT(DATETIME,crwcoffx.GSLO_Pmt_Update_DT)																			[Confirm_DTUpdate]
			,CONVERT(VARCHAR(100),'(Blank)')																						[Μέγιστη_Ηλ_Υπολ]
			,ISNULL(crwBEX.crwBEX_Debtor_Generic_Text_1,'(Blank)')																	[Debtor_Generic_Text_1]
			,ISNULL(crwBEX.crwBEX_DEL_DAYS,'(Blank)')																				[Delay_days]
			,crwBEX.crwBEX_Allocation_Code																							[AllocationUniqueCode]
			,crwBEX.crwBEX_DebtID																									[DebtID]
			,ISNULL(crwBEX_CustomerStatus,'(Blank)')																				[Customer_Status]
			,ISNULL(crwBEX.crwBEX_VendorBranchID,'(Blank)')																			[Vendor_BranchID]
			,CONVERT(MONEY,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Decimal_7,0))														[Debt_Generic_Decimal_7]
			,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_5,'(Blank)')																	[Debt_Generic_Date_5]
			,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_6,'(Blank)')																	[Debt_Generic_Date_6]
			,CONVERT(MONEY,ISNULL(NULL,0))																							[COS_PastDueAmount]
			,TRIM(ISNULL(crwBEX_SubProdCategory,'(Blank)'))																			[SubProduct_Category]
			,ISNULL(crwBEX_LegalStatus,'(Blank)')																					[Legal_Status]
			,ISNULL(crwBEX_Stlm_Status,'(Blank)')																					[Settlement_Status]
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_NE_SCHED,'(Blank)')																	[ΔΕΗ_Προγραμ_Νομ_Ενέργεια] 
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_AE_DETAILED,'(Blank)')																[ΔΕΗ_Αποτέλεσμα_Επίδοσης_Detailed]
			,CONVERT(DATE,ISNULL(crwcoffx.crwCOFFX_GSLO_DEH_NE_SCHED_DT,'1903-03-03'))												[ΔΕΗ_Ημερ_Προγραμ_Νομ_Ενέργειας]
			,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_1,'(Blank)')																		[Inhouse_Strategy_1]
			,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_2,'(Blank)')																		[Inhouse_Strategy_2]
			,ISNULL(crwCOFFX_GSLO_Vendor_Strategy,'(Blank)')																		[Vendor_Strategy]
			,ISNULL(NBG_CALC.[Υπολογιστική_οφειλή_NBG],0)																			[NBG_Υπολογιστική_οφειλή]
			,ISNULL(NBG_CALC.[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],0)													[NBG_Πλήθος_βεβ_δόσεων]
			,ISNULL(NBG_CALC.[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],0)															[NBG_Ανεξόφλητο_βεβ_υπόλοιπο]
			,ISNULL(NBG_CALC.crwBEX_AccountCloseDT,'1903-03-03')																	[NBG_AccountCloseDT]
			,ISNULL(NBG_CALC.crwBEX_SumExpenses_FCY,0)																				[NBG_Sum_Expences]
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_All,'')																		[CustomerMultipleIds (All)]
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_Act,'')																		[CustomerMultipleIds (Active)]
			,CONVERT(DATE,NULL)																										[TRN_Last_Pay_DT]
			,CONVERT(MONEY,NULL)																									[TRN_Last_Pay_Amount]
			,CONVERT(VARCHAR(100),'(Blank)')																						[ΔΕΗ Consecutive Payers]
			,CONVERT(VARCHAR(30),'(Blank)')																							[Alert ConsecutivePayers]
			,CONVERT(DATE,NULL)																										[Gemi_imerominia_anazitisis]	--Z.B. 15-05-2023	AIT-12810
			,CONVERT(DATE,NULL)																										[Ypes_DateIns]					--Z.B. 15-05-2023	AIT-12810
			,CONVERT(DATE,NULL)																										[Last_Insert_Ktimatologio]		--Z.B. 15-05-2023	AIT-12810
			,CONVERT(DATE,NULL)																										[Last Skip Date]				--Z.B. 15-05-2023	AIT-12810
																																	

		INTO dbo.QVMtBIcases
		FROM
			AR_GSLO_OLTP_REPLICA.dbo.crwBEX
			INNER JOIN #BE_QVMtBIcases
				ON #BE_QVMtBIcases.crmBE_ID = crwBEX.crmBE_ID
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBE
				ON crmBE.crmBE_ID = crwBEX.crmBE_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP BP_Owner						
				ON BP_Owner.crmBP_ID = crmBE.crmBE_Owner
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT MLT_STS
				ON MLT_STS.crmMLT_ID = crmBE.crmBE_Status
				AND MLT_STS.crmMLT_LanguageID = 'SYS_LANG_GR'
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmOFF
				ON crmOFF.crmOFF_ID	= crwBEX.crwBEX_OffID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP BP_Vendor /*WITH(INDEX(crmPK_BP))*/
				ON BP_Vendor.crmBP_ID = crwBEX.crwBEX_VendorID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.QVMtBIproducts
				ON QVMtBIproducts.ProductID	= crwBEX.crwBEX_OffID
				AND QVMtBIproducts.ProductIsActive = 1
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCAMP	crmCAMP
				ON crmCAMP.crmCAMP_ID = crmBE.crmCAMP_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crwCOFFX
				ON crwCOFFX.crmBE_ID = crwBEX.crmBE_ID
			LEFT JOIN #COS_CAMP_QVMtBIcases  COSCAMP
				ON COSCAMP.crmCAMP_ID = crmBE.crmCAMP_ID
			LEFT JOIN #NBG_CALC_QVMtBIcases	NBG_CALC
				ON NBG_CALC.crmBE_ID = crmBE.crmBE_ID
		WHERE
			0 < 3
			AND QVMtBIproducts.ProductID IS NULL

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 8

		






		--========================
		--======== TRACE 9 =======
		--========================
		
		--SET @TRACE = 'Trace #9'
		--EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		
			--CREATE UNIQUE CLUSTERED INDEX BE ON QVMtBIcases (crmBE_ID)
		
		--ALTER TABLE dbo.QVMtBIcases
		--ADD CONSTRAINT PK_QVMtBIcases_crmBE_ID PRIMARY KEY CLUSTERED (crmBE_ID)

		--SET @TRACE_INFO = 'CREATE PRIMARY KEY'
		--EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- start trace 9






		/************************************************************************************************************/
		--UPDATE QVMtBIcases
		--SET [LT_Balance] = CONVERT(MONEY,ISNULL(OA_TRN.BLNC,0))
		--FROM QVMtBIcases
		--CROSS APPLY(SELECT 
		--		    TOP 1 
		--		     TRN_OA.crmTRN_Balance BLNC
		--		    FROM AR_GSLO_OLTP.dbo.crmTRN TRN_OA 
		--		    WHERE 0<3
		--		    AND TRN_OA.crmTRN_RegDate  <= GETDATE()
		--		    AND TRN_OA.crmBE_ID = QVMtBIcases.crmBE_ID 
		--		    ORDER BY 
		--			 crmTRN_RegDate DESC
		--			,crmTRN_SN DESC	) OA_TRN
		/************************************************************************************************************/
		/*
		UPDATE QVMtBIcases
		SET [LT_Balance] = CONVERT(MONEY,ISNULL(OA_TRN.BLNC,0))
		FROM QVMtBIcases
		INNER JOIN (SELECT 
					 TRN_OA.crmTRN_Balance BLNC
					,TRN_OA.crmBE_ID 
					,DENSE_RANK() OVER(PARTITION BY TRN_OA.crmBE_ID
										ORDER BY crmTRN_RegDate DESC
												,crmTRN_SN DESC) RNK
					FROM AR_GSLO_OLTP.dbo.crmTRN TRN_OA
					INNER JOIN AR_GSLO_OLTP.dbo.QVMtBIcases X ON x.crmBE_ID  = TRN_OA.crmBE_ID
					WHERE 0<3
					AND TRN_OA.crmTRN_RegDate  <= GETDATE()) OA_TRN ON OA_TRN.crmBE_ID = QVMtBIcases.crmBE_ID 
																   AND RNK = 1
		*/




		--=========================
		--======== TRACE 10 =======
		--=========================
		
		SET @TRACE = 'Trace #10'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET 
			[COS_PastDueAmount] = CONVERT(MONEY,ISNULL(DYNAMICP_COS.DP_COS_PAST_DUE_AMT,0))
		FROM
			QVMtBIcases
			INNER JOIN [AR_GSLO_OLTP_REPLICA].[dbo].DYNAMICP_COS
				ON DYNAMICP_COS.crmBE_ID = QVMtBIcases.crmBE_ID

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 10





		--=========================
		--======== TRACE 11 =======
		--=========================
		
		SET @TRACE = 'Trace #11'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET 
			[Μέγιστη_Ηλ_Υπολ] = CONVERT(VARCHAR(100),x.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol)
		FROM 
			QVMtBIcases
			CROSS APPLY
			(
				SELECT
				TOP 1
					v.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol
				FROM AR_GSLO_OLTP_REPLICA.dbo.DYNAMICP_VOLTERA_TAB1 v
				WHERE 0<3
				AND v.crmBE_ID = QVMtBIcases.crmBE_ID
			) x

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 11





		--=========================
		--======== TRACE 12 =======
		--=========================
		
		SET @TRACE = 'Trace #12'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET 
			[LT_BalancePlus] = CONVERT(MONEY,ISNULL(OA_TRN_Plus.BLNC,0))
		FROM 
			QVMtBIcases
		INNER JOIN 
		(
			SELECT 
				TRN_OA.crmTRN_Balance BLNC
				,TRN_OA.crmBE_ID 
				,DENSE_RANK() OVER(PARTITION BY TRN_OA.crmBE_ID ORDER BY crmTRN_RegDate DESC, crmTRN_SN DESC) RNK
			FROM AR_GSLO_OLTP_REPLICA.dbo.crmTRN TRN_OA
			INNER JOIN dbo.QVMtBIcases X 
				ON x.crmBE_ID = TRN_OA.crmBE_ID
			WHERE 0 < 3
				AND X .Vendor IN('Kotsovolos'						--> ΚΩΤΣΟΒΟΛΟΣ
								,'Kotsovolos CIS'					--> ΚΩΤΣΟΒΟΛΟΣ CIS
								,'Kotsovolos Franc.')
		) OA_TRN_Plus	--> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE
			ON OA_TRN_Plus.crmBE_ID = QVMtBIcases.crmBE_ID 
			AND RNK = 1

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 12

		




		--=========================
		--======== TRACE 13 =======
		--=========================
		
		SET @TRACE = 'Trace #13'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET Balance = LT_BalancePlus
		WHERE Vendor IN ('Kotsovolos'			--> ΚΩΤΣΟΒΟΛΟΣ
						,'Kotsovolos CIS'		--> ΚΩΤΣΟΒΟΛΟΣ CIS
						,'Kotsovolos Franc.')	--> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 13




		--=========================
		--======== TRACE 14 =======
		--=========================

		SET @TRACE = 'Trace #14'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET Balance = OSAsset
		WHERE Vendor IN ('Intrum Pireaus'--'ΤΡΑΠΕΖΑ ΠΕΙΡΑΙΩΣ'
						,'ΤΡΑΠΕΖΑ ΠΕΙΡΑΙΩΣ PRELEGAL')

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 14



		--=========================
		--======== TRACE 15 =======
		--=========================

		SET @TRACE = 'Trace #15'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		
		UPDATE QVMtBIcases
		SET Balance = AccountingBalance
		WHERE Vendor IN ('NBG')	 --'ΕΘΝΙΚΗ ΤΡΑΠΕΖΑ'
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 15
		
		

		--=========================
		--======== TRACE 16 =======
		--=========================

		SET @TRACE = 'Trace #16'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET Balance = DelinqAmount
		WHERE Vendor IN ('Do Value Venus'	-- 'VENUS'
						,'Do Value Eclipse'	-- 'INTRUM'
						,'Do Value EFG'		-- 'EUROBANK'
						,'Do Value Cairo 1'	-- 'FPS CAIRO 1'
						,'Do Value Cairo 2' -- 'FPS CAIRO 2'
						,'Do Value Pillar'	-- 'FPS PILLAR'
						,'Do Value Zenith'	-- 'FPS ZENITH'
						,'Do Value Flagship'
						,'EUROBANK'
						,'INTRUM'
						,'Do Value ERB Recovery DAC S13'
						,'Do Value Mexico M03'
						,'DO VALUE SOUQ' -- AIT-12318
						)

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 16


		



		--=========================
		--======== TRACE 17 =======
		--=========================

		SET @TRACE = 'Trace #17'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET Balance = TotalBalanceMLT
		WHERE 
			0 < 3
			AND Vendor = 'Alpha Bank' -- 'ALPHA BANK'
			AND DenounceStatus = 'WRITE OFF'
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 17

		
		/************************************************************************************************************/


		--=========================
		--======== TRACE 18 =======
		--=========================

		SET @TRACE = 'Trace #18'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		-- G.K.
		CREATE INDEX NCLIX_QVMtBIcases_crmCOFF_ID ON QVMtBIcases(crmCOFF_ID)

		SET @TRACE_INFO = 'CREATE NON CLUSTERED INDEX'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 18




		/************************************************************************************************************/
		--UPDATE QVMtBIcases
		--SET [LastAssignment] = 1
		--FROM QVMtBIcases
		--CROSS APPLY (SELECT    
		--             TOP 1 
		--              BE_LOC.crmBE_ID
		--             FROM AR_GSLO_OLTP.dbo.crmBE BE_LOC
		--             WHERE QVMtBIcases.crmCOFF_ID = BE_LOC.crmCOFF_ID
		--             ORDER BY 
		--              BE_LOC.crmBE_InDateTime	DESC
		--             ,BE_LOC.crmBE_CreateDT		DESC
		--			 ,BE_LOC.crmBE_ID			ASC) LAST_BE
		--WHERE LAST_BE.crmBE_ID = QVMtBIcases.crmBE_ID



		/************************************************************************************************************/


		--=========================
		--======== TRACE 19 =======
		--=========================

		SET @TRACE = 'Trace #19'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace


		DROP TABLE IF EXISTS #BE_LOC
		
		-- G.K.
		SELECT
			BE_LOC.crmCOFF_ID
			,BE_LOC.crmBE_ID
			,DENSE_RANK() OVER(PARTITION BY BE_LOC.crmCOFF_ID ORDER BY BE_LOC.crmBE_InDateTime	DESC ,BE_LOC.crmBE_CreateDT	DESC, BE_LOC.crmBE_ID ASC) RNK
		INTO #BE_LOC
		FROM 
			AR_GSLO_OLTP_REPLICA.dbo.crmBE BE_LOC
			INNER JOIN QVMtBIcases		X			 
				ON X.crmCOFF_ID = BE_LOC.crmCOFF_ID
		WHERE 0 < 3 

		UPDATE QVMtBIcases
		SET [LastAssignment] = 1
		FROM QVMtBIcases
		INNER JOIN #BE_LOC
			/*
			(			
				SELECT
						BE_LOC.crmCOFF_ID
						,BE_LOC.crmBE_ID
						,DENSE_RANK() OVER(PARTITION BY BE_LOC.crmCOFF_ID
											ORDER BY BE_LOC.crmBE_InDateTime	DESC
													,BE_LOC.crmBE_CreateDT		DESC
													,BE_LOC.crmBE_ID			ASC) RNK
						FROM AR_GSLO_OLTP_REPLICA.dbo.crmBE BE_LOC
						INNER JOIN QVMtBIcases		X			 
						ON X.crmCOFF_ID = BE_LOC.crmCOFF_ID
						WHERE 0<3 
			
			) */ 
				LAST_BE
				ON LAST_BE.crmCOFF_ID	= QVMtBIcases.crmCOFF_ID
				AND LAST_BE.crmBE_ID	= QVMtBIcases.crmBE_ID
				AND RNK					= 1
		WHERE
			0 < 3

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 19






		--=========================
		--======== TRACE 20 =======
		--=========================

		SET @TRACE = 'Trace #20'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		CREATE INDEX NCLIX_QVMtBIcases_crwBEX_CustomerID ON QVMtBIcases(crwBEX_CustomerID)
		
		SET @TRACE_INFO = 'CREATE NON CLUSTERED INDEX'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 20
		
		
		
		

		--=========================
		--======== TRACE 21 =======
		--=========================

		SET @TRACE = 'Trace #21'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace


		UPDATE QVMtBIcases
		SET Relatives = xXx.CNT
		FROM 
			QVMtBIcases
			INNER JOIN
			(
				SELECT
					DISTINCT 
					crmBE.crmBE_ID
					,COUNT(DISTINCT crmBPR.crmBP_SR_ID) CNT
				FROM AR_GSLO_OLTP_REPLICA.dbo.crmBE crmBE			 
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCOFF		ON crmCOFF.crmCOFF_ID	= crmBE.crmCOFF_ID
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPRCOFF	ON crmCOFF.crmCOFF_ID	= crmBPRCOFF.crmCOFF_ID
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPR		ON crmBPR.crmBPR_ID		= crmBPRCOFF.crmBPR_ID
				WHERE 1 = 1
					AND crmBPR.crmBPRC_ID  IN ('BPRC_COCREDITOR'
												,'BPRC_COCREDITOR_B'
												,'BPRC_WARRANTOR'
												,'BPRC_WARRANTOR_B'
												,'BPRC_ADDMEMBER_A'
												,'BPRC_ADDMEMBER_B'
												,'BPRC_ADDMEMBER_C'
												,'BPRC_BENEFICIARIES'
												,'BPRC_CO_DEBTOR'
												,'BPRC_BOARD_MEMBER'
												,'BPRC_3RD_MAJOR_MORT_LOAN'
												,'BPRC_ORG_MEMBER'
												,'BPRC_REPRESENTATIVE'
												,'BPRC_ADMINISTRATOR'
												,'BPRC_BOARD_DC'
												,'BPRC_COMPANY_MEMBER'
												,'BPRC_GENERAL_PARTNER'
												,'BPRC_LEGAL_REP')
					AND crmBPR.crmBPR_IsValid = 1
					AND crmBPR.crmBP_SR_ID	IS NOT NULL
					AND crmBPR.crmBP_SR_ID	!= ''
				GROUP BY crmBE.crmBE_ID
			) xXx
				ON xXx.crmBE_ID = QVMtBIcases.crmBE_ID

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 21



		--=========================
		--======== TRACE 22 =======
		--=========================

		SET @TRACE = 'Trace #22'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace

		UPDATE QVMtBIcases
		SET
			PQH_Segment = ISNULL(#PQH_Segment_QVMtBIcases.Kampania,'Rest')
		FROM 
			QVMtBIcases
			LEFT JOIN #PQH_Segment_QVMtBIcases 
				ON #PQH_Segment_QVMtBIcases.admin_code = QVMtBIcases.AdministrationCode
		WHERE 
			QVMtBIcases.Vendor = 'PQH'

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 22





		--======================= UPDATE CASES FROM PAYMENTS ===============================
		-- These codes must be on Payments Procedure => there is a delay..

		--========================
		--======== TRACE 23 ======
		--========================

		-- G.K. This Trace Transfered from Cases Procedure

		SET @TRACE = 'Trace #23'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace


		-- +1 Minute AIT-10088
		UPDATE QVMtBIcases
		SET 
			[TRN_Last_Pay_DT] = x.PaymentDate,
			--[TRN_Last_Pay_Amount] = PaymentAmount -- G.K. 2023-04-10
			[TRN_Last_Pay_Amount] = SumPaymentAmount -- G.K. 2023-04-10
		FROM QVMtBIcases
		INNER JOIN 	
		(
			SELECT
				QVMtBIpayments.crmBE_ID,
				QVMtBIpayments.PaymentDate,
				--QVMtBIpayments.PaymentAmount, -- G.K. 2023-04-10
				ROW_NUMBER() OVER(PARTITION BY QVMtBIpayments.crmBE_ID order by QVMtBIpayments.PaymentDate DESC, QVMtBIpayments.PaymentID ) RNK,				
				SUM(QVMtBIpayments.PaymentAmount) OVER(PARTITION BY QVMtBIpayments.crmBE_ID, QVMtBIpayments.PaymentDate) AS SumPaymentAmount -- G.K. 2023-04-10
			FROM 
				QVMtBIpayments
		) x
			ON x.crmBE_ID = QVMtBIcases.crmBE_ID
			AND x.RNK = 1

				
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 23
				



		--========================
		--======== TRACE 24 =======		-- UPDATE CASES TABLE FOR THREE COLUMNS OF PAYMENTS
		--========================

		-- G.K. This Trace Transfered from Cases Procedure
		
				
		SET @TRACE = 'Trace #24'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
				
		-- ait 10090 runtime 4sec --last checked 06/07/22
		DROP TABLE IF EXISTS #consecutive_QVMtBIcases

		SELECT DISTINCT
			QVMtBIcases.crmBE_ID
			,[ΔΕΗ Consecutive Payers]
			,count(flag) flag
		INTO #consecutive_QVMtBIcases
		FROM 
			QVMtBIcases
			INNER JOIN 	
			(
				SELECT DISTINCT
					COUNT(a.CustomerCode +' '+ year(QVMtBIpayments.PaymentDate)+' '+month(QVMtBIpayments.PaymentDate)) flag,
					QVMtBIpayments.crmBE_ID,
					MONTH(QVMtBIpayments.PaymentDate) as PayDay,
					a.CustomerCode
				FROM
					QVMtBIpayments
					INNER JOIN QVMtBIcases a on a.crmBE_ID = QVMtBIpayments.crmBE_ID
				WHERE 
					QVMtBIpayments.PaymentDate > (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0))
					AND QVMtBIpayments.PaymentDate < (SELECT EOMONTH(DATEADD(month, -1, Current_timestamp)))
					AND a.Vendor = 'ΔΕΗ'
				GROUP BY
					QVMtBIpayments.crmBE_ID,
					month(QVMtBIpayments.PaymentDate)
					,a.CustomerCode
		
			) x ON x.crmBE_ID = QVMtBIcases.crmBE_ID
		GROUP BY 
			QVMtBIcases.crmBE_ID,
			[ΔΕΗ Consecutive Payers]

				
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 24
				

		--========================
		--======== TRACE 25 =======
		--========================

				
		SET @TRACE = 'Trace #25'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
				

		UPDATE QVMtBIcases
		SET	
			QVMtBIcases.[ΔΕΗ Consecutive Payers] = 'Consecutive'
		FROM
			#consecutive_QVMtBIcases
		WHERE 
			#consecutive_QVMtBIcases.flag = 3
			AND QVMtBIcases.crmBE_ID = #consecutive_QVMtBIcases.crmBE_ID
		
				
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 25




		--========================
		--======== TRACE 26 =======
		--========================

		-- G.K. This Trace Transfered from Cases Procedure		
				
		SET @TRACE = 'Trace #26'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		;
		
		WITH MinPaymentDaysConsecutive AS (
			SELECT 
				c.crmBE_ID, 
				MIN(DAY(PaymentDate)) as MinPaymentDay
			FROM 
				QVMtBIpayments as p
			INNER JOIN QVMtBIcases as c
				ON c.crmBE_ID = p.crmBE_ID
			WHERE
				c.[ΔΕΗ Consecutive Payers] = 'Consecutive'
				AND	p.PaymentDate > (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0))
				AND p.PaymentDate < (SELECT EOMONTH(DATEADD(month, -1, Current_timestamp)))
			GROUP BY 
				c.crmBE_ID
		)
		UPDATE QVMtBIcases
		SET
			[Alert ConsecutivePayers] = 
			CASE
				WHEN [ΔΕΗ Consecutive Payers] = 'Consecutive' AND DAY(GETDATE()) > MinPaymentDay THEN 'Alert'
				ELSE NULL
			END
		FROM 
			QVMtBIcases
			INNER JOIN MinPaymentDaysConsecutive 
				ON QVMtBIcases.crmBE_ID = MinPaymentDaysConsecutive.crmBE_ID;

				
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 26



		--========================
		--======== TRACE 27 =======
		--========================
		
		--Z.B. 15-05-2023	AIT-12810

		SET @TRACE = 'Trace #27'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		;

		UPDATE QVMtBIcases
		SET 
			[Gemi_imerominia_anazitisis]	=	DES2_Dinamikes_Arotron.[Gemi_imerominia_anazitisis],
			[Ypes_DateIns]					=	DES2_Dinamikes_Arotron.[Ypes_DateIns],
			[Last_Insert_Ktimatologio]		=	DES2_Dinamikes_Arotron.[Last_Insert_Ktimatologio]

		FROM QVMtBIcases
		INNER JOIN

		(
			SELECT DISTINCT
				c.crmBE_ID
				,DES2Dynamics.Searching_Date					AS [Gemi_imerominia_anazitisis]		--ΓΕΜΗ Ημερομηνία αναζήτησης													
				,YPES_Results_DateIns							AS [Ypes_DateIns]					--ΥΠΕΣ DateIns
				,crmPARV_DTValue								AS [Last_Insert_Ktimatologio]		--Last Insert Ktimatologio
				,ROW_NUMBER() OVER(PARTITION BY c.crmBE_ID order by DES2Dynamics.Searching_Date desc,
																	YPES_Results_DateIns desc,
																	crmPARV_DTValue desc) as RNK
			FROM QVM.dbo.QVMtBIcases as c
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_GEMI_Dynamics AS DES2Dynamics		ON DES2Dynamics.crmBE_ID	= c.crmBE_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_YPES_Results  AS DES2YpesResults	ON DES2YpesResults.crmBE_ID = c.crmBE_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmparv									ON crmparv.crmPARV_ROWID	= c.crmBE_ID and crmobjp_id = 'GSLO_Dynamic_Ktimatologio_DT'
		) AS DES2_Dinamikes_Arotron 
			ON DES2_Dinamikes_Arotron.crmBE_ID = QVMtBIcases.crmBE_ID

		where RNK = 1
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 27


		
		--========================
		--======== TRACE 28 =======
		--========================
		
		--Z.B. 15-05-2023	AIT-12810

		SET @TRACE = 'Trace #28'
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE -- start trace
		;

		
		UPDATE QVMtBIcases
        SET 
            [Last Skip Date] = [Max_Last_Skip_Date]

        FROM QVMtBIcases
        INNER JOIN 

        (
            SELECT 
                a.crmBE_ID
                ,MAX(ActionResultDate) AS [Max_Last_Skip_Date] 

            FROM QVMtBIcases AS c
            LEFT JOIN QVMtBIactions AS a ON a.crmBE_ID = c.crmBE_ID 

            WHERE 1=1
            AND a.ActionResult = 'Σύντομη Αναζήτηση Στοιχείων Οφειλέτη' 

            GROUP BY a.crmBE_ID
        ) AS x
            ON QVMtBIcases.crmBE_ID = x.crmBE_ID


		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 28



		--=====================
		--=== END PROCEDURE ===
		--=====================		

		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 2

	END TRY
	BEGIN CATCH

		EXEC [dbo].[QVMspBIsetLog] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 3
		RETURN -1

	END CATCH

END



GO


