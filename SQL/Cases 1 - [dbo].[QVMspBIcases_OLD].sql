USE [QVM_DEV]
GO

/****** Object:  StoredProcedure [dbo].[QVMspBIcases_OLD]    Script Date: 6/7/2023 3:59:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













--USE AR_GSLO_OLTP
CREATE PROC [dbo].[QVMspBIcases_OLD] AS 
BEGIN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
/************************************************************************************************************/
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcases1', getdate())
/************************************************************************************************************/




IF OBJECT_ID('TempDB..#COS_CAMP_QVMtBIcases') IS NOT NULL DROP TABLE #COS_CAMP_QVMtBIcases
select crmCAMP.crmCAMP_ID,
	   case crmOFF.crmBP_ID
	   when 'BP_COSMOTE' then isnull(crmPARV.crmPARV_StringValue,'COS_PRE_LEGAL')
	   when 'BP_OTE' then isnull(crmPARV.crmPARV_StringValue,'OTE_LEGAL')
	   else crmPARV.crmPARV_StringValue
	   end as CampGroup
	   INTO #COS_CAMP_QVMtBIcases
  from AR_GSLO_OLTP_REPLICA.[dbo].crmCAMP inner join AR_GSLO_OLTP_REPLICA.[dbo].crmOFF on crmOFF.crmOFF_ID = crmCAMP.crmCAMP_Offering
				left join AR_GSLO_OLTP_REPLICA.[dbo].crmPARV on crmPARV.crmPARV_RowID = crmCAMP.crmCAMP_ID
								and crmOBJP_ID = 'SYS_CAMP_GROUP'
WHERE (case crmOFF.crmBP_ID
	   when 'BP_COSMOTE' then isnull(crmPARV.crmPARV_StringValue,'COS_PRE_LEGAL')
	   when 'BP_OTE' then isnull(crmPARV.crmPARV_StringValue,'OTE_LEGAL')
	   else crmPARV.crmPARV_StringValue
	   end ) is not null

update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcases1'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcases1'
	order by [SP Start] desc
)
/************************************************************************************************************/
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcases2', getdate())

IF OBJECT_ID('TempDB..#PQH_Segment_QVMtBIcases') IS NOT NULL DROP TABLE #PQH_Segment_QVMtBIcases
Select
x.*
into #PQH_Segment_QVMtBIcases
from (
Select CONVERT(varchar(100),'Agri_Phase_I')  as admin_code,CONVERT(varchar(100),'FLOW I')  as Kampania
union
select CONVERT(varchar(100),'Retail_Woff_Phase_I') as admin_code ,CONVERT(varchar(100),'FLOW I') as Kampania
union
select CONVERT(varchar(100),'Retail_Phase_I') as admin_code ,CONVERT(varchar(100),'FLOW I') as Kampania
union
select CONVERT(varchar(100),'Agri_Phase_II') as admin_code ,CONVERT(varchar(100),'FLOW II') as Kampania
union
select CONVERT(varchar(100),'Retail_Woff_Phase_IΙ') as admin_code ,CONVERT(varchar(100),'FLOW II') as Kampania
union
select CONVERT(varchar(100),'Retail_Phase_II') as admin_code ,CONVERT(varchar(100),'FLOW II') as Kampania
union
select CONVERT(varchar(100),'Agri_Phase_IIΙ') as admin_code ,CONVERT(varchar(100),'FLOW III') as Kampania
union
select CONVERT(varchar(100),'Retail_Woff_Phase_IIΙ') as admin_code ,CONVERT(varchar(100),'FLOW III') as Kampania
union
select CONVERT(varchar(100),'Retail_Phase_IIΙ') as admin_code ,CONVERT(varchar(100),'FLOW III') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_Attr_Legal_Assign') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_Attracted') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_WaveI_Διαταγή_Πληρωμής') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_WaveI_Καταψηφιστική_Αγωγή') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_WaveIII') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_250_WaveIV') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_Attracted') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveI_Διαταγή_Πληρωμής') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveI_Καταψηφιστική_Αγωγή') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveII_Διαταγή_Πληρωμής') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveII_Καταψηφιστική_Αγωγή') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveIII') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'Legal_Escal_WaveIV') as admin_code ,CONVERT(varchar(100),'Legal Escalation') as Kampania
union
select CONVERT(varchar(100),'New Legal_escal__Attracted') as admin_code ,CONVERT(varchar(100),'Legal Escal 2019_A') as Kampania
union
select CONVERT(varchar(100),'New Legal_escal__Καταγγελία') as admin_code ,CONVERT(varchar(100),'Legal Escal 2019_A') as Kampania
union
select CONVERT(varchar(100),'New Legal_escal_Καταγγελία_Επιδίκαση') as admin_code ,CONVERT(varchar(100),'Legal Escal 2019_A') as Kampania
union
select CONVERT(varchar(100),'New_Gen_Policy_Secured') as admin_code ,CONVERT(varchar(100),'ΝΕΑ ΓΕΝΙΚΗ ΠΟΛΙΤΙΚΗ') as Kampania
union
select CONVERT(varchar(100),'New_Gen_Policy_UnSecured') as admin_code ,CONVERT(varchar(100),'ΝΕΑ ΓΕΝΙΚΗ ΠΟΛΙΤΙΚΗ') as Kampania
union
select CONVERT(varchar(100),'€20k - €250k_ Καταγγελία_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'Legal Initiative below 250k') as Kampania
union
select CONVERT(varchar(100),'€20k - €250k_Καταγγελία') as admin_code ,CONVERT(varchar(100),'Legal Initiative below 250k') as Kampania
union
select CONVERT(varchar(100),'€20k - €250k_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'Legal Initiative below 250k') as Kampania
union
select CONVERT(varchar(100),'€20k - €250k_ attracted') as admin_code ,CONVERT(varchar(100),'Legal Initiative below 250k') as Kampania
union
select CONVERT(varchar(100),'€20k - €250k_ Plain') as admin_code ,CONVERT(varchar(100),'Legal Initiative below 250k') as Kampania
union
select CONVERT(varchar(100),'Restr_cvd19_B4+') as admin_code ,CONVERT(varchar(100),'Restr_cvd19_B4+') as Kampania
union
select CONVERT(varchar(100),'20-250k_Legal 2020_Καταγγελία_ Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'20-250k_Legal 2020') as Kampania
union
select CONVERT(varchar(100),'20-250k_Legal 2020_Καταγγελία') as admin_code ,CONVERT(varchar(100),'20-250k_Legal 2020') as Kampania
union
select CONVERT(varchar(100),'20-250k_Legal 2020_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'20-250k_Legal 2020') as Kampania
union
select CONVERT(varchar(100),'20-250k_Legal 2020_Attracted') as admin_code ,CONVERT(varchar(100),'20-250k_Legal 2020') as Kampania
union
select CONVERT(varchar(100),'250-500k_Legal20_No Mass_Legal_Action') as admin_code ,CONVERT(varchar(100),'20-250k_Legal 2020') as Kampania
union
select CONVERT(varchar(100),'250-500k_ Legal20_Καταγγελία') as admin_code ,CONVERT(varchar(100),'250k -500k_Legal_2020') as Kampania
union
select CONVERT(varchar(100),'250-500k_Legal20_Καταγγελία_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'250k -500k_Legal_2020') as Kampania
union
select CONVERT(varchar(100),'250-500k_Legal20_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'250k -500k_Legal_2020') as Kampania
union
select CONVERT(varchar(100),'250-500k_Legal20_Attracted') as admin_code ,CONVERT(varchar(100),'250k -500k_Legal_2020') as Kampania
union
select CONVERT(varchar(100),'20-250k_Legal 2020_No_Mass_Legal_Action') as admin_code ,CONVERT(varchar(100),'250k -500k_Legal_2020') as Kampania
union
select CONVERT(varchar(100),'Legal up to 250k_2021_Καταγγελία') as admin_code ,CONVERT(varchar(100),'Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Legal up to 250k_2021_Καταγγελία_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Legal up to 250k_2021_Καταγγελία_Κλιμάκωση') as admin_code ,CONVERT(varchar(100),'Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Legal up to 250k_2021_Attracted') as admin_code ,CONVERT(varchar(100),'Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Up to 250k_2021_Debtor below 20K') as admin_code ,CONVERT(varchar(100),'Non-Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Up to 250k_2021_Debtor with LTV<=100%') as admin_code ,CONVERT(varchar(100),'Non-Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Up to 250k_2021_Debtor with LTV>100%') as admin_code ,CONVERT(varchar(100),'Non-Legal up to 250k_2021') as Kampania
union
select CONVERT(varchar(100),'Up to 250k_2021_Unsecured Debtor') as admin_code ,CONVERT(varchar(100),'Non-Legal up to 250k_2021') as Kampania
) x


update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcases2'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcases2'
	order by [SP Start] desc
)
/************************************************************************************************************/
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcases3', getdate())


IF OBJECT_ID('TempDB..#NBG_CALC_QVMtBIcases') IS NOT NULL DROP TABLE #NBG_CALC_QVMtBIcases
Select 
*
into #NBG_CALC_QVMtBIcases
from AR_GSLO_OLTP_REPLICA.dbo.Z_V_NBG_Calc_Ofeili
/************************************************************************************************************/


/************************************************************************************************************/
--DECLARE @T TABLE(crmBE_ID VARCHAR(32))
IF OBJECT_ID('TempDB..#BE_QVMtBIcases') IS NOT NULL DROP TABLE #BE_QVMtBIcases
--INSERT INTO @T
SELECT
DISTINCT
 crwBEXH.crmBE_ID
INTO #BE_QVMtBIcases
FROM AR_GSLO_OLTP_REPLICA.[dbo].crwBEXH --WITH (INDEX(AK_Contact_rowguid))
WHERE 0<3
AND crwBEXH.crwBEXH_SnapshotDT	>	GETDATE()-365
/************************************************************************************************************/
CREATE UNIQUE CLUSTERED INDEX ID ON #BE_QVMtBIcases(crmBE_ID)
/************************************************************************************************************/
INSERT INTO #BE_QVMtBIcases
SELECT
DISTINCT
 crwBEX.crmBE_ID
FROM AR_GSLO_OLTP_REPLICA.[dbo].crwBEX
LEFT  JOIN #BE_QVMtBIcases	ON #BE_QVMtBIcases.crmBE_ID	= crwBEX.crmBE_ID
WHERE 0<3
AND #BE_QVMtBIcases.crmBE_ID IS NULL
AND ISNULL(crwBEX.crwBEX_ActiveStatus,'SYS_LOVD_BE_STATUS_ACTIVE') = 'SYS_LOVD_BE_STATUS_ACTIVE'
/************************************************************************************************************/
ALTER INDEX ID ON #BE_QVMtBIcases REBUILD
/************************************************************************************************************/
IF OBJECT_ID('[dbo].QVMtBIcases') IS NOT NULL DROP TABLE dbo.QVMtBIcases
SELECT
 crwBEX.crmBE_ID
,crmBE.crmCOFF_ID
,crwBEX.crwBEX_CustomerID
,REPLACE(
 ISNULL(crwBEX.crwBEX_ActiveStatus
	  ,'SYS_LOVD_BE_STATUS_ACTIVE'),'SYS_LOVD_BE_STATUS_','')					 [ActiveStatus]
,MLT_STS.crmMLT_TextInLanguage													 [AccountStatus]
,crwBEX.crwBEX_COFFCustCode														 [CustomerCode]
,crwBEX.crwBEX_COFFRefNo														 [AccountNumber]
,ISNULL(crwBEX.crwBEX_ContractNo,'(Blank)')										 [ContactNumber]
,BP_Vendor.crmBP_Alias															 [Vendor]
,crmOFF.crmOFF_Name																 [Product]
,CONVERT(DATE,crmBE.crmBE_InDateTime)											 [AssignmentDate]
,crmCAMP.crmCAMP_ID																 [CampaignID]
,crmCAMP.crmCAMP_CodeName														 [CampaignCodeName]
,ISNULL(BP_Owner.crmBP_Alias,'(Blank)')											 [CaseOwner]
,TRIM(ISNULL(crwBEX.crwBEX_In_House_Group,'(Blank)'))							 [InHouseGroup]
,TRIM(ISNULL(crwBEX.crwBEX_In_House_Group_2,'(Blank)'))							 [InHouseGroup_2]
,TRIM(ISNULL(crwBEX.crwBEX_MisKind,'(Blank)'))									 [MIS_Kind]
,TRIM(ISNULL(crwBEX.crwBEX_PD_MisKind,'(Blank)'))								 [PD_MIS_Kind]
,TRIM(ISNULL(crwBEX.crwBEX_AdministrationCode,'(Blank)'))						 [AdministrationCode]
,TRIM(ISNULL(crwBEX.crwBEX_BlackListCode,'(Blank)'))							 [BlackListCode]
,TRIM(ISNULL(crwBEX.crwBEX_ApplNo,'(Blank)'))									 [ApplicationNumber]
,CONVERT(INT,ISNULL(crwBEX.crwBEX_CurBucket,-10))								 [CurrentBucketNumber]
,TRIM(ISNULL(crwBEX.crwBEX_LegalProcessStatus,'(Blank)'))						 [LegalProcessStatus]
,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LegalProcessStatusDate						 
		,ISNULL(crwBEX.crwBEX_LegalProcessStatusDate,'1903-03-03')))			 [LegalProcessStatusDate]
,TRIM(ISNULL(crwBEX.crwBEX_ProductCategory,'(Blank)'))							 [ProductCategory]
,TRIM(ISNULL(crwBEX.crwBEX_ProductSubCategory,'(Blank)'))						 [ProductSubCategory]
,TRIM(ISNULL(crwBEX.crwBEX_ProductDescription,'(Blank)'))						 [ProductDescription]
,TRIM(ISNULL(crwBEX.crwBEX_ProductSubDescription,'(Blank)'))					 [ProductSubDescription]
,TRIM(ISNULL(crwBEX.crwBEX_BusinessUnitCode,'(Blank)'))							 [BusinessUnitCode]
,TRIM(ISNULL(crwBEX.crwBEX_Agency_Code,'(Blank)'))								 [AgencyCode]
,TRIM(ISNULL(crwBEX.crwBEX_Account_Branch_Name,'(Blank)'))						 [BranchName]
,TRIM(ISNULL(crwBEX.crwBEX_Denounce_Status,'(Blank)'))							 [DenounceStatus]
,CONVERT(INT,ISNULL(REPLACE(crwBEX.crwBEX_Billing_Day,'N/A',-10),-10))			 [BillingDay]
,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LastBillingDate,'1903-03-03'))				 [LastBillingDate]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_LastPmtAmount,0))							 [LastPaymentAmount]
,CONVERT(DATE,ISNULL(crwBEX.crwBEX_LastPmtDT,'1903-03-03'))						 [LastPaymentDate]
,TRIM(ISNULL(crwBEX_Asset_Class,'(Blank)'))										 [AssetClass]
,CONVERT(INT,ISNULL(crwBEX.crwBEX_DEL_DAYS,-10))								 [DelayDays]
,CONVERT(DATE,ISNULL(crwBEX_DeliqLetter1Date,'1903-03-03'))						 [Issue_Date]
,CONVERT(DATE,ISNULL(crwBEX_DeliqLetter2Date,'1903-03-03'))						 [Transaction_Date]
,TRIM(ISNULL(crwBEX.crwBEX_Strategy_Step
	   ,ISNULL(crwBEX.crwBEX_StrategyStepDescr,'')))							 [StrategyStep]
,TRIM(ISNULL(crwBEX.crwBEX_Strategy_Description
	   ,ISNULL(crwBEX.crwBEX_StrategyDescr,'')))								 [StrategyDescription]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OSBalance,0))								 [OSBalance]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OsAsset,0))									 [OSAsset]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OsBalanceAssign,0))							 [Ass_OS_Balance]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_Overdue_Other_Amount,0))					 [OverdueAmount]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_FrozenIntAmount,0))							 [FrozenAmount]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_AccountingBalance,0))						 [AccountingBalance]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_DelinqAmount,0))							 [DelinqAmount]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalBalanceMLT,0))							 [TotalBalanceMLT]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_WriteOffAmount,0))							 [WriteOffAmount]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_DebtAmount_FCY,0))							 [DebtAmount]
,CONVERT(MONEY,ISNULL(/*OA_TRN.BLNC*/NULL,0))									 [LT_Balance]	
,CONVERT(MONEY,ISNULL(/*OA_TRN_Plus.BLNC*/NULL,0))								 [LT_BalancePlus]	
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_OSBalance,0))								 [Balance]
,CONVERT(BIT,0)																	 [LastAssignment]
,CONVERT(INT,0)																	 [Relatives]
,CONVERT(TINYINT,1)																 [CaseCounter]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_AccountingBalance,0))
-CONVERT(MONEY,ISNULL(crwBEX.crwBEX_FrozenIntAmount,0))							 [NBG_Amount]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalBalance,0))							 [TotalBalance]
,TRIM(ISNULL(crwBEX.crwBEX_FinancialStatus,'(Blank)'))							 [FinancialStatus]
,TRIM(ISNULL(crwCOFFX.crwBEX_SPV,'(Blank)'))									 [SPV]
,TRIM(ISNULL(crwCOFFX.crwBEX_SPV_Category,'(Blank)'))							 [SPV_Category]
,TRIM(ISNULL(crwBEX_SubProdCategory,'(Blank)'))									 [SubProductCategory]
,ISNULL(crwBEX.crwBEX_ServAccNumber,'(Blank)')									 [ServiceAccountNumber]
,ISNULL(crwCOFFX.crwbex_Covid19,'(Blank)')										 [Covid19]
,ISNULL(COSCAMP.CampGroup,'(Blank)') 											 [COS_Campaigns]
,CONVERT(MONEY,ISNULL(crwBEX.crwBEX_TotalCaseAccountBalance,0))					 [TotalCaseAccountBalance]
,CONVERT(MONEY,ISNULL(crwcoffx.crwBEX_AccBalanceCase,0))						 [AccBalanceCase]       
,CONVERT(MONEY,ISNULL(crwcoffx.crwBEX_CASE_LINK_ACC_AMT,0))						 [CASE_LINK_ACC_AMT]
,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalAction,'(Blank)')                        [LastLegalAction]
,CONVERT(DATE,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalActionDate,'1903-03-03'))   [LastLegalActionDate]
,CONVERT(MONEY,ISNULL(crwcoffx.GSLO_Pmt_Confirm_Amnt,0))                         [Confirm_Amnt]
,CONVERT(DATE,ISNULL(crwcoffx.GSLO_Pmt_Confirm_DT,'1903-03-03'))                 [Confirm_DT]
,CONVERT(VARCHAR(100),'(Blank)')												 [PQH_Segment]
,CONVERT(DATETIME,crwcoffx.GSLO_Pmt_Update_DT)		                             [Confirm_DTUpdate]
,CONVERT(VARCHAR(100),'(Blank)')												 [Μέγιστη_Ηλ_Υπολ]
,ISNULL(crwBEX.crwBEX_Debtor_Generic_Text_1,'(Blank)')                           [Debtor_Generic_Text_1]
,ISNULL(crwBEX.crwBEX_DEL_DAYS,'(Blank)')                                        [Delay_days]
,crwBEX.crwBEX_Allocation_Code                                                   [AllocationUniqueCode]
,crwBEX.crwBEX_DebtID                                                            [DebtID]
,ISNULL(crwBEX_CustomerStatus,'(Blank)')                                         [Customer_Status]
,ISNULL(crwBEX.crwBEX_VendorBranchID,'(Blank)')                                  [Vendor_BranchID]
,CONVERT(MONEY,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Decimal_7,0))                 [Debt_Generic_Decimal_7]
,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_5,'(Blank)')                           [Debt_Generic_Date_5]
,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_6,'(Blank)')                           [Debt_Generic_Date_6]
,CONVERT(MONEY,ISNULL(NULL,0))							                         [COS_PastDueAmount]
,ISNULL(crwBEX_SubProdCategory,'(Blank)')                                        [SubProduct_Category]
,ISNULL(crwBEX_LegalStatus,'(Blank)')                                            [Legal_Status]
,ISNULL(crwBEX_Stlm_Status,'(Blank)')                                            [Settlement_Status]
,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_NE_SCHED,'(Blank)')                           [ΔΕΗ_Προγραμ_Νομ_Ενέργεια] 
,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_AE_DETAILED,'(Blank)')                        [ΔΕΗ_Αποτέλεσμα_Επίδοσης_Detailed]
,CONVERT(DATE,ISNULL(crwcoffx.crwCOFFX_GSLO_DEH_NE_SCHED_DT,'1903-03-03'))       [ΔΕΗ_Ημερ_Προγραμ_Νομ_Ενέργειας]
,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_1,'(Blank)')                              [Inhouse_Strategy_1]
,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_2,'(Blank)')								 [Inhouse_Strategy_2]
,ISNULL(crwCOFFX_GSLO_Vendor_Strategy,'(Blank)')								 [Vendor_Strategy]
,ISNULL(NBG_CALC.[Υπολογιστική_οφειλή_NBG],0)									 [NBG_Υπολογιστική_οφειλή]
,ISNULL(NBG_CALC.[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],0)			 [NBG_Πλήθος_βεβ_δόσεων]
,ISNULL(NBG_CALC.[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],0)					 [NBG_Ανεξόφλητο_βεβ_υπόλοιπο]
,ISNULL(NBG_CALC.crwBEX_AccountCloseDT,'1903-03-03')							 [NBG_AccountCloseDT]
,ISNULL(NBG_CALC.crwBEX_SumExpenses_FCY,0)										 [NBG_Sum_Expences]
,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_All,'')								 [CustomerMultipleIds (All)]
,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_Act,'')								 [CustomerMultipleIds (Active)]
,CONVERT(DATE,NULL)																 [TRN_Last_Pay_DT]
,CONVERT(MONEY,NULL)															 [TRN_Last_Pay_Amount]
,CONVERT(VARCHAR(100),'(Blank)')												 [ΔΕΗ Consecutive Payers]
,CONVERT(VARCHAR(30),'(Blank)')												     [Alert ConsecutivePayers]

INTO dbo.QVMtBIcases
FROM AR_GSLO_OLTP_REPLICA.dbo.crwBEX
INNER JOIN #BE_QVMtBIcases																			ON #BE_QVMtBIcases.crmBE_ID						= crwBEX.crmBE_ID
INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBE												ON crmBE.crmBE_ID					= crwBEX.crmBE_ID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP			BP_Owner							ON BP_Owner.crmBP_ID				= crmBE.crmBE_Owner
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT			MLT_STS								ON MLT_STS.crmMLT_ID				= crmBE.crmBE_Status
																						AND MLT_STS.crmMLT_LanguageID		= 'SYS_LANG_GR'
INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmOFF												ON crmOFF.crmOFF_ID					= crwBEX.crwBEX_OffID	
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP			BP_Vendor /*WITH(INDEX(crmPK_BP))*/	ON BP_Vendor.crmBP_ID				= crwBEX.crwBEX_VendorID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.QVMtBIproducts										ON QVMtBIproducts.ProductID			= crwBEX.crwBEX_OffID
																					   AND QVMtBIproducts.ProductIsActive	= 1
INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCAMP			crmCAMP								ON crmCAMP.crmCAMP_ID				= crmBE.crmCAMP_ID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crwCOFFX											ON crwCOFFX.crmBE_ID				= crwBEX.crmBE_ID
LEFT  JOIN #COS_CAMP_QVMtBIcases  COSCAMP                                                            ON COSCAMP.crmCAMP_ID               = crmBE.crmCAMP_ID
LEFT  JOIN #NBG_CALC_QVMtBIcases	NBG_CALC														ON NBG_CALC.crmBE_ID				= crmBE.crmBE_ID
			
WHERE 0<3
AND QVMtBIproducts.ProductID	IS NULL

update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcases3'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcases3'
	order by [SP Start] desc
)

/************************************************************************************************************/
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcases4', getdate())

--CREATE UNIQUE CLUSTERED INDEX BE	ON QVMtBIcases (crmBE_ID)
ALTER TABLE dbo.QVMtBIcases   
ADD CONSTRAINT PK_QVMtBIcases_crmBE_ID PRIMARY KEY CLUSTERED (crmBE_ID)
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
/************************************************************************************************************/
update QVMtBIcases
set [COS_PastDueAmount] = CONVERT(MONEY,ISNULL(DYNAMICP_COS.DP_COS_PAST_DUE_AMT,0))
FROM QVMtBIcases
inner join [AR_GSLO_OLTP_REPLICA].[dbo].DYNAMICP_COS  on DYNAMICP_COS.crmBE_ID = QVMtBIcases.crmBE_ID 
/************************************************************************************************************/
UPDATE QVMtBIcases
SET [Μέγιστη_Ηλ_Υπολ] = CONVERT(VARCHAR(100),x.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol)
FROM QVMtBIcases
CROSS APPLY(SELECT
		    TOP 1
		     v.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol
		    FROM AR_GSLO_OLTP_REPLICA.dbo.DYNAMICP_VOLTERA_TAB1 v
		    WHERE 0<3
		    AND v.crmBE_ID = QVMtBIcases.crmBE_ID
			)x
/************************************************************************************************************/

UPDATE QVMtBIcases
SET [LT_BalancePlus] = CONVERT(MONEY,ISNULL(OA_TRN_Plus.BLNC,0))
FROM QVMtBIcases
INNER JOIN (SELECT 
		     TRN_OA.crmTRN_Balance BLNC
			,TRN_OA.crmBE_ID 
			,DENSE_RANK() OVER(PARTITION BY TRN_OA.crmBE_ID
								ORDER BY crmTRN_RegDate DESC
										,crmTRN_SN DESC) RNK
		    FROM AR_GSLO_OLTP_REPLICA.dbo.crmTRN TRN_OA
			INNER JOIN dbo.QVMtBIcases X ON x.crmBE_ID  = TRN_OA.crmBE_ID
		    WHERE 0<3
			AND X .Vendor IN('Kotsovolos'						--> ΚΩΤΣΟΒΟΛΟΣ
							,'Kotsovolos CIS'					--> ΚΩΤΣΟΒΟΛΟΣ CIS
							,'Kotsovolos Franc.')) OA_TRN_Plus	--> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE
																ON OA_TRN_Plus.crmBE_ID = QVMtBIcases.crmBE_ID 
																		   AND RNK = 1
/************************************************************************************************************/
UPDATE QVMtBIcases
SET Balance = LT_BalancePlus
WHERE Vendor IN ('Kotsovolos'			--> ΚΩΤΣΟΒΟΛΟΣ
				,'Kotsovolos CIS'		--> ΚΩΤΣΟΒΟΛΟΣ CIS
				,'Kotsovolos Franc.')	--> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE
/************************************************************************************************************/
UPDATE QVMtBIcases
SET Balance = OSAsset
WHERE Vendor IN ('Intrum Pireaus'--'ΤΡΑΠΕΖΑ ΠΕΙΡΑΙΩΣ'
				,'ΤΡΑΠΕΖΑ ΠΕΙΡΑΙΩΣ PRELEGAL')
/************************************************************************************************************/
UPDATE QVMtBIcases
SET Balance = AccountingBalance
WHERE Vendor IN ('NBG')	 --'ΕΘΝΙΚΗ ΤΡΑΠΕΖΑ'
/************************************************************************************************************/
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
/************************************************************************************************************/
UPDATE QVMtBIcases
SET Balance = TotalBalanceMLT
WHERE 0<3
AND Vendor = 'Alpha Bank' -- 'ALPHA BANK'
AND DenounceStatus = 'WRITE OFF'
/************************************************************************************************************/
CREATE INDEX NCLIX_QVMtBIcases_crmCOFF_ID ON QVMtBIcases(crmCOFF_ID)
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
UPDATE QVMtBIcases
SET [LastAssignment] = 1
FROM QVMtBIcases
INNER JOIN  (SELECT    
              BE_LOC.crmCOFF_ID
             ,BE_LOC.crmBE_ID
			 ,DENSE_RANK() OVER(PARTITION BY BE_LOC.crmCOFF_ID
									ORDER BY BE_LOC.crmBE_InDateTime	DESC
											,BE_LOC.crmBE_CreateDT		DESC
											,BE_LOC.crmBE_ID			ASC) RNK
             FROM AR_GSLO_OLTP_REPLICA.dbo.crmBE BE_LOC
			 INNER JOIN QVMtBIcases		X			 ON X.crmCOFF_ID = BE_LOC.crmCOFF_ID
             WHERE 0<3 ) LAST_BE					 ON LAST_BE.crmCOFF_ID	= QVMtBIcases.crmCOFF_ID
													AND LAST_BE.crmBE_ID	= QVMtBIcases.crmBE_ID
													AND RNK					= 1
WHERE 0<3
/************************************************************************************************************/
CREATE INDEX NCLIX_QVMtBIcases_crwBEX_CustomerID ON QVMtBIcases(crwBEX_CustomerID)
/************************************************************************************************************/
UPDATE QVMtBIcases
SET Relatives = xXx.CNT
FROM QVMtBIcases
INNER JOIN(SELECT
		   DISTINCT 
		    crmBE.crmBE_ID
		   ,COUNT(DISTINCT crmBPR.crmBP_SR_ID) CNT
		   FROM AR_GSLO_OLTP_REPLICA.dbo.crmBE crmBE			 
		   INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCOFF		ON crmCOFF.crmCOFF_ID	= crmBE.crmCOFF_ID
		   INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPRCOFF	ON crmCOFF.crmCOFF_ID	= crmBPRCOFF.crmCOFF_ID
		   INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPR		ON crmBPR.crmBPR_ID		= crmBPRCOFF.crmBPR_ID
		   WHERE 1=1
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
		   GROUP BY
		    crmBE.crmBE_ID) xXx ON xXx.crmBE_ID = QVMtBIcases.crmBE_ID
/************************************************************************************************************/
UPDATE QVMtBIcases
SET PQH_Segment = ISNULL(#PQH_Segment_QVMtBIcases.Kampania,'Rest')
FROM QVMtBIcases
left join #PQH_Segment_QVMtBIcases on #PQH_Segment_QVMtBIcases.admin_code = QVMtBIcases.AdministrationCode
WHERE QVMtBIcases.Vendor = 'PQH'

/************************************************************************************************************/

-- +1 Minute AIT-10088
UPDATE QVMtBIcases
SET [TRN_Last_Pay_DT] = x.PaymentDate,
	[TRN_Last_Pay_Amount] = x.PaymentAmount
FROM QVMtBIcases
inner join 	(Select 
			QVMtBIpayments.crmBE_ID,
			QVMtBIpayments.PaymentDate,
			QVMtBIpayments.PaymentAmount,
			ROW_NUMBER() OVER(PARTITION BY QVMtBIpayments.crmBE_ID order by QVMtBIpayments.PaymentDate DESC, QVMtBIpayments.PaymentID ) RNK
			from QVMtBIpayments
			) x on x.crmBE_ID = QVMtBIcases.crmBE_ID
			and x.RNK = 1


update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcases4'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcases4'
	order by [SP Start] desc
)
/************************************************************************************************************/
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcases5', getdate())

-- ait 10090 runtime 4sec --last checked 06/07/22
IF OBJECT_ID ('tempdb..#consecutive_QVMtBIcases') IS NOT NULL DROP TABLE #consecutive_QVMtBIcases
Select distinct
QVMtBIcases.crmBE_ID
, [ΔΕΗ Consecutive Payers]
,count(flag) flag
into #consecutive_QVMtBIcases
FROM QVMtBIcases
inner join 	(Select distinct
			count (a.CustomerCode +' '+ year(QVMtBIpayments.PaymentDate)+' '+month(QVMtBIpayments.PaymentDate)) flag,
			QVMtBIpayments.crmBE_ID,
			month(QVMtBIpayments.PaymentDate) as PayDay,
			a.CustomerCode
			from QVMtBIpayments
			inner join QVMtBIcases a on a.crmBE_ID = QVMtBIpayments.crmBE_ID
			where QVMtBIpayments.PaymentDate > (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0))
			and QVMtBIpayments.PaymentDate < (SELECT EOMONTH(DATEADD(month, -1, Current_timestamp)))
			and a.Vendor = 'ΔΕΗ'
group by QVMtBIpayments.crmBE_ID,
month(QVMtBIpayments.PaymentDate)
			,a.CustomerCode
		
			) x on x.crmBE_ID = QVMtBIcases.crmBE_ID
group by QVMtBIcases.crmBE_ID
, [ΔΕΗ Consecutive Payers]

update QVMtBIcases
set	 QVMtBIcases.[ΔΕΗ Consecutive Payers] = 'Consecutive'
from #consecutive_QVMtBIcases
where #consecutive_QVMtBIcases.flag = 3
and QVMtBIcases.crmBE_ID = #consecutive_QVMtBIcases.crmBE_ID;



WITH MinPaymentDaysConsecutive AS (
    SELECT c.crmBE_ID, MIN(DAY(PaymentDate)) as MinPaymentDay
    FROM QVMtBIpayments as p
	inner join QVMtBIcases as c on c.crmBE_ID = p.crmBE_ID
	where c.[ΔΕΗ Consecutive Payers] = 'Consecutive'
	and	p.PaymentDate > (select DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-3, 0))
	and p.PaymentDate < (SELECT EOMONTH(DATEADD(month, -1, Current_timestamp)))
    GROUP BY c.crmBE_ID
)

UPDATE QVMtBIcases
SET [Alert ConsecutivePayers] = CASE
                WHEN [ΔΕΗ Consecutive Payers] = 'Consecutive' AND DAY(GETDATE()) > MinPaymentDay 
                THEN 'Alert'
                ELSE NULL
            END
FROM QVMtBIcases
JOIN MinPaymentDaysConsecutive ON QVMtBIcases.crmBE_ID = MinPaymentDaysConsecutive.crmBE_ID;



update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcases5'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcases5'
	order by [SP Start] desc
)


END

GO


