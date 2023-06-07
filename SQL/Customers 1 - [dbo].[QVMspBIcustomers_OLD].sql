USE [QVM_DEV]
GO

/****** Object:  StoredProcedure [dbo].[QVMspBIcustomers_OLD]    Script Date: 6/7/2023 3:59:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[QVMspBIcustomers_OLD] AS
BEGIN 
------------------------------------------------------------------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
------------------------------------------------------------------------------------------------------------------------
insert into [QVM].[dbo].qvm_qlik_sp_logs ([SP Name], [SP Start])
values ('QVMspBIcustomers', getdate())
------------------------------------------------------------------------------------------------------------------------
IF OBJECT_ID('dbo.QVMtBIcustomers') IS NOT NULL DROP TABLE dbo.QVMtBIcustomers
------------------------------------------------------------------------------------------------------------------------
SELECT
DISTINCT
 CONVERT(VARCHAR(32),QVMtBIcases.crwBEX_CustomerID)											[crwBEX_CustomerID]
,TRIM(ISNULL(BP_Cust.crmBP_Alias,'(Blank)'))												[CustomerFullName]
,TRIM(ISNULL(crmIND.crmIND_LastName,crmORG.crmORG_Name))									[CustomerLastName]
,TRIM(ISNULL(crmIND.crmIND_FirstName,'(Blank)'))											[CustomerFirstName]
,TRIM(ISNULL(crmIND.crmIND_MiddleName,ISNULL([Πατρώνυμο].crmPARV_StringValue,'')))			[CustomerFathersName]
,TRIM(ISNULL(crmIND.crmIND_MotherFirstName,ISNULL([Μητρώνυμο].crmPARV_StringValue,'')))		[CustomerMothersName]
,CASE
 WHEN crmORG.crmBP_ID IS NOT NULL
 THEN 'Organization'
 ELSE 'Individual'
 END																						[CustomerCategory]
,CASE
 WHEN crmIND.crmIND_Gender IN('M','Male','1','SYS_IND_SEX_1','Α','ΑΝΔΡΑΣ')
 THEN 'Male'
 WHEN crmIND.crmIND_Gender IN('F','Female','2','SYS_IND_SEX_2','Γ','ΓΥΝΑΙΚΑ')
 THEN 'Female'
 WHEN crmORG.crmBP_ID IS NOT NULL
 THEN 'Organization'
 ELSE '(Blank)'
 END																						[CustomerGender]
,1																							[CustomerCounter]
,CONVERT(VARCHAR(100),'Without Progress')													[CustomerPipeline]
,BP_Cust.crmBPC_ID
,CONVERT(VARCHAR(3),'No')																	[CustomerAuction]
,ISNULL(crmMLT.crmMLT_TextInLanguage ,crmIND.crmIND_OccupationDescr)						[CustomerOccupation]
,ISNULL(CONVERT(CHAR(10),X.UPD_Date),ISNULL(crmIND.crmIND_BirthDate,''))					[CustomerBirthDate]

,TRIM(ISNULL(crwBPX.crwBPX_CSF_Settlement_Status,'(Blank)'))								AS CSF_Settlement_Status
,CONVERT(INT,crwBPX.crwBPX_CSF_Num_of_Installments)											AS CSF_Num_of_Installments
,CONVERT(MONEY,crwBPX.crwBPX_CSF_Settlement_Amount)											AS CSF_Settlement_Amount
,CONVERT(DATE,crwBPX.crwBPX_CSF_Activation_Date)											AS CSF_Activation_Date
,TRIM(ISNULL(crwBPXX.crwBPX_DIAS_Payment_Reference,'(Blank)'))								AS [CustomerDIAS Payment Reference]
,CONVERT(MONEY,crwBPXX.crwBPX_CSF_Remaining_Amount)											AS [CustomerHost Settlement Remaining Amount]
,CONVERT(INT,crwBPXX.crwBPX_CSF_Num_of_Installments)										AS [CustomerNumber of installments]
,CONVERT(MONEY,crwBPXX.crwBPX_CSF_UnpaidMaturing_Amount)									AS [CustomerUnpaid Maturing Amount]
,CONVERT(INT,crwBPXX.crwBPX_CSF_Settlement_Bucket)											AS [CustomerSettlement Bucket]
,CONVERT(MONEY,crwBPXX.crwBPX_CSF_Amount_Already_Paid)										AS [CustomerAmount Already Paid]
,CONVERT(DATE,crwBPXX.crwBPX_CSF_Activation_Date)											AS [CustomerHost Settlement Activation Date]
,TRIM(ISNULL(crwBPXX.crwBPX_CSF_Settlement_Status,'(Blank)'))								AS [CustomerHost Settlement Status]
,CONVERT(INT,crwBPXX.crwBPX_CSF_Num_past_installments)										AS [CustomerNumber of past installments]
,TRIM(ISNULL(crwBPXX.crwBPX_CustSgmnt,'(Blank)'))											AS [CustomerCustomer Segment]
,TRIM(ISNULL(crwBPXX.crwBPX_CIFActionTicketCL,'(Blank)'))									AS [CustomerCIF Action Ticket CL]
,crwBPXX.crwBPX_DeceasedFlag																AS [CustomerDeceased Indication]
,CONVERT(MONEY,crwBPXX.crwBPX_CSF_Settlement_Amount)										AS [CustomerHost Settlement Amount]
,TRIM(ISNULL(crwBPXX.crwBPX_CSF_Settlement_Type,'(Blank)'))									AS [CustomerHost Settlement Type]
,CONVERT(MONEY,crwBPXX.crwBPX_CSF_Past_Install_Amount)										AS [CustomerPast Installments Amount]
,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_N3869_STATUS,'(Blank)'))					AS [CustomerN3869 Status]
,DynamicP_FPS_Cust.DynamicP_FPS_Cust_N3869_DATE												AS [CustomerN3869 Date]
,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_OCW_STATUS,'(Blank)'))						AS [CustomerOCW Status]
,DynamicP_FPS_Cust.DynamicP_FPS_Cust_OCW_DATE												AS [CustomerOCW Date]
,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_N4605_STATUS,'(Blank)'))					AS [CustomerN4605 Status]
,DynamicP_FPS_Cust.DynamicP_FPS_Cust_N4605_DATE												AS [CustomerN4605 Date]
,ISNULL(mlt_occ_gslo.crmMLT_TextInLanguage,'(Blank)')										AS [CustomerOccupation_GSLO]
,isnull(crmIND.crmIND_AFM,crmORG.crmORG_AFM)												AS [Α.Φ.Μ]

INTO dbo.QVMtBIcustomers
FROM dbo.QVMtBIcases
INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP		BP_Cust			ON BP_Cust.crmBP_ID					= QVMtBIcases.crwBEX_CustomerID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmORG						ON crmORG.crmBP_ID					= BP_Cust.crmBP_ID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmIND						ON crmIND.crmBP_ID					= BP_Cust.crmBP_ID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT						ON crmMLT.crmMLT_ID					= crmIND.crmIND_OccupationDescr
																AND crmMLT.crmMLT_LanguageID		= 'SYS_LANG_GR'

LEFT  JOIN DBSRV1.MIS_COMMON.dbo.Z_V_Dates_6789 X				ON X.InitialDate					= ISNULL(crmIND.crmIND_BirthDate,'')
													   AND X.UPD_Date					   != '1902-02-02'
OUTER APPLY(SELECT 
		  TOP 1 
		  crmPARV.crmPARV_StringValue 
		  FROM AR_GSLO_OLTP_REPLICA.dbo.crmPARV 
		  WHERE 0<3
		  AND crmPARV.crmPARV_RowID	= QVMtBIcases.crwBEX_CustomerID
		  AND crmPARV.crmOBJP_ID		= 'SYS_CRM_IND_GENITIVEFATHERNAME')		[Πατρώνυμο]
OUTER APPLY(SELECT 
		  TOP 1 
		  crmPARV.crmPARV_StringValue 
		  FROM AR_GSLO_OLTP_REPLICA.dbo.crmPARV 
		  WHERE 0<3
		  AND crmPARV.crmPARV_RowID	= QVMtBIcases.crwBEX_CustomerID
		  AND crmPARV.crmOBJP_ID		= 'SYS_CRM_IND_MOTHERNAME')				[Μητρώνυμο]
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crwBPX				ON crwBPX.crmBP_ID					= QVMtBIcases.crwBEX_CustomerID
													   AND crwBPX_CSF_Settlement_Status		= 'Running'
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crwBPX	crwBPXX		ON crwBPXX.crmBP_ID					= QVMtBIcases.crwBEX_CustomerID
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT mlt_occ_gslo			ON mlt_occ_gslo.crmMLT_ID			= crwBPXX.crwBPX_GSLO_Job_Inhouse
																and mlt_occ_gslo.crmMLT_LanguageID	= 'SYS_LANG_GR'
LEFT  JOIN AR_GSLO_OLTP_REPLICA.dbo.DynamicP_FPS_Cust	ON DynamicP_FPS_Cust.crmBP_ID		= crwBPX.crmBP_ID

WHERE 0<3
------------------------------------------------------------------------------------------------------------------------
--ALTER TABLE AR_GSLO_OLTP.dbo.QVMtBIcustomers   
--			ALTER COLUMN crwBEX_CustomerID VARCHAR(32) NOT NULL
--ALTER TABLE AR_GSLO_OLTP.dbo.QVMtBIcustomers   
--			ADD CONSTRAINT PK_QVMtBIcustomers_crwBEX_CustomerID PRIMARY KEY CLUSTERED (crwBEX_CustomerID)

------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
update [QVM].[dbo].qvm_qlik_sp_logs
set [SP End] = getdate()
where [SP Name] = 'QVMspBIcustomers'
and [SP Start] = (
	select top 1 [SP Start]
	from [QVM].[dbo].qvm_qlik_sp_logs
	where [SP Name] = 'QVMspBIcustomers'
	order by [SP Start] desc
)
------------------------------------------------------------------------------------------------------------------------
END
GO


