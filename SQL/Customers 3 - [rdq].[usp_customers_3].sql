USE [ANALYTICS_DB_UAT]
GO

/****** Object:  StoredProcedure [rdq].[usp_customers]    Script Date: 6/7/2023 3:56:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:
-- Create date:
-- Alter date: Redesigned => G.K. April 2023
--			   Tuning => G.K. 25-04-2023
-- Description:
-- =============================================

CREATE PROCEDURE [rdq].[usp_customers] 
	@RUN_ID INT = NULL,
	@PARENT_PROC_NAME VARCHAR(250) = NULL
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED		
	SET NOCOUNT ON
	
	DECLARE @PROC_NAME VARCHAR(250) = OBJECT_NAME(@@PROCID)
	DECLARE @TRACE NVARCHAR(250) = ''
	DECLARE @TRACE_INFO VARCHAR(500)

	-- If Proc Run Alone
	IF @RUN_ID IS NULL
	BEGIN
		SET @RUN_ID = (SELECT rdq.ufn_get_next_run_id())
		SET @PARENT_PROC_NAME = @PROC_NAME
	END

	BEGIN TRY

		--=======================
		--=== START PROCEDURE ===
		--=======================

		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 1

		
		-- G.K. 25-04-2023
		DROP TABLE IF EXISTS #X

		SELECT
			InitialDate,
			UPD_Date
		INTO #X
		FROM /*DBOLTP.*/DBSRV1.MIS_COMMON.dbo.Z_V_Dates_6789 
		
		
		--========================
		--======== TRACE 1 =======
		--========================
		
		SET @TRACE = 'Trace #1'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE
		
		TRUNCATE TABLE [rdq].[utb_customers_cst]

		INSERT INTO [rdq].[utb_customers_cst]
		(
			[cst_id], 
			[cst_full_name], 
			[cst_last_name], 
			[cst_first_name], 
			[cst_fathers_name], 
			[cst_mothers_name], 
			[cst_category], 
			[cst_gender], 
			[cst_counter], 
			[cst_pipeline], 
			[cst_crm_bpc_id], 
			[cst_auction], 
			[cst_occupation], 
			[cst_birth_date], 
			[cst_csf_settlement_status], 
			[cst_csf_num_of_installments], 
			[cst_csf_settlement_amount], 
			[cst_csf_activation_date], 
			[cst_dias_payment_reference], 
			[cst_host_settlement_remaining_amount], 
			[cst_number_of_installments], 
			[cst_unpaid_maturing_amount], 
			[cst_settlement_bucket],
			[cst_amount_already_paid], 
			[cst_host_settlement_activation_date], 
			[cst_host_settlement_status], 
			[cst_number_of_past_installments], 
			[cst_segment], 
			[cst_cif_action_ticket_cl],
			[cst_deceased_indication], 
			[cst_host_settlement_amount], 
			[cst_host_settlement_type], 
			[cst_past_installments_amount], 
			[cst_n3869_status], 
			[cst_n3869_date], 
			[cst_ocw_status], 
			[cst_ocw_date],			
			[cst_n4605_status], 
			[cst_n4605_date], 
			[cst_occupation_gslo], 
			[cst_afm],
			[cst_phone_comment]
		)
		SELECT DISTINCT
			 rdq.utb_cases_cas.cas_crw_bex_customer_id													AS [cst_id]
			,TRIM(ISNULL(BP_Cust.crmBP_Alias,'(Blank)'))												AS [cst_full_name]
			,TRIM(ISNULL(crmIND.crmIND_LastName,crmORG.crmORG_Name))									AS [cst_last_name]
			,TRIM(ISNULL(crmIND.crmIND_FirstName,'(Blank)'))											AS [cst_first_name]
			,TRIM(ISNULL(crmIND.crmIND_MiddleName,ISNULL([Πατρώνυμο].crmPARV_StringValue,'')))			AS [cst_fathers_name]
			,TRIM(ISNULL(crmIND.crmIND_MotherFirstName,ISNULL([Μητρώνυμο].crmPARV_StringValue,'')))		AS [cst_mothers_name]
			,CASE
				WHEN crmORG.crmBP_ID IS NOT NULL THEN 'Organization'
				ELSE 'Individual'
			 END																						AS [cst_category]
			,CASE
				WHEN crmIND.crmIND_Gender IN('M','Male','1','SYS_IND_SEX_1','Α','ΑΝΔΡΑΣ') THEN 'Male'
				WHEN crmIND.crmIND_Gender IN('F','Female','2','SYS_IND_SEX_2','Γ','ΓΥΝΑΙΚΑ') THEN 'Female'
				WHEN crmORG.crmBP_ID IS NOT NULL THEN 'Organization'
				ELSE '(Blank)'
			 END																						AS [cst_gender]
			,1																							AS [cst_counter]
			,'Without Progress'																			AS [cst_pipeline]
			,BP_Cust.crmBPC_ID																			AS [cst_crm_bpc_id]
			,'No'																						AS [cst_auction]
			,ISNULL(crmMLT.crmMLT_TextInLanguage ,crmIND.crmIND_OccupationDescr)						AS [cst_occupation]
			,ISNULL(CONVERT(CHAR(10),X.UPD_Date),ISNULL(crmIND.crmIND_BirthDate,''))					AS [cst_birth_date]
			,TRIM(ISNULL(crwBPX.crwBPX_CSF_Settlement_Status,'(Blank)'))								AS [cst_csf_settlement_status]
			,crwBPX.crwBPX_CSF_Num_of_Installments														AS [cst_csf_num_of_installments]
			,crwBPX.crwBPX_CSF_Settlement_Amount														AS [cst_csf_settlement_amount]
			,crwBPX.crwBPX_CSF_Activation_Date															AS [cst_csf_activation_date]
			,TRIM(ISNULL(crwBPXX.crwBPX_DIAS_Payment_Reference,'(Blank)'))								AS [cst_dias_payment_reference]
			,crwBPXX.crwBPX_CSF_Remaining_Amount														AS [cst_host_settlement_remaining_amount]
			,crwBPXX.crwBPX_CSF_Num_of_Installments														AS [cst_number_of_installments]
			,crwBPXX.crwBPX_CSF_UnpaidMaturing_Amount													AS [cst_unpaid_maturing_amount]
			,crwBPXX.crwBPX_CSF_Settlement_Bucket											AS [cst_settlement_bucket]
			,crwBPXX.crwBPX_CSF_Amount_Already_Paid										AS [cst_amount_already_paid]
			,crwBPXX.crwBPX_CSF_Activation_Date											AS [cst_host_settlement_activation_date]
			,TRIM(ISNULL(crwBPXX.crwBPX_CSF_Settlement_Status,'(Blank)'))								AS [cst_host_settlement_status]
			,crwBPXX.crwBPX_CSF_Num_past_installments										AS [cst_number_of_past_installments]
			,TRIM(ISNULL(crwBPXX.crwBPX_CustSgmnt,'(Blank)'))											AS [cst_segment]
			,TRIM(ISNULL(crwBPXX.crwBPX_CIFActionTicketCL,'(Blank)'))									AS [cst_cif_action_ticket_cl]
			,crwBPXX.crwBPX_DeceasedFlag																AS [cst_deceased_indication]
			,crwBPXX.crwBPX_CSF_Settlement_Amount										AS [cst_host_settlement_amount]
			,TRIM(ISNULL(crwBPXX.crwBPX_CSF_Settlement_Type,'(Blank)'))									AS [cst_host_settlement_type]
			,crwBPXX.crwBPX_CSF_Past_Install_Amount										AS [cst_past_installments_amount]
			,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_N3869_STATUS,'(Blank)'))					AS [cst_n3869_status]
			,DynamicP_FPS_Cust.DynamicP_FPS_Cust_N3869_DATE												AS [cst_n3869_date]
			,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_OCW_STATUS,'(Blank)'))						AS [cst_ocw_status]
			,DynamicP_FPS_Cust.DynamicP_FPS_Cust_OCW_DATE												AS [cst_ocw_date]
			,TRIM(ISNULL(DynamicP_FPS_Cust.DynamicP_FPS_Cust_N4605_STATUS,'(Blank)'))					AS [cst_n4605_status]
			,DynamicP_FPS_Cust.DynamicP_FPS_Cust_N4605_DATE												AS [cst_n4605_date]
			,ISNULL(mlt_occ_gslo.crmMLT_TextInLanguage,'(Blank)')										AS [cst_occupation_gslo]
			,ISNULL(crmIND.crmIND_AFM,crmORG.crmORG_AFM)												AS [cst_afm]
			,NULL																						AS [cst_phone_comment]
		FROM
			rdq.utb_cases_cas
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP AS BP_Cust
				ON BP_Cust.crmBP_ID	= rdq.utb_cases_cas.cas_crw_bex_customer_id
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmORG 
				ON crmORG.crmBP_ID = BP_Cust.crmBP_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmIND						
				ON crmIND.crmBP_ID = BP_Cust.crmBP_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT
				ON crmMLT.crmMLT_ID	= crmIND.crmIND_OccupationDescr 
				AND crmMLT.crmMLT_LanguageID = 'SYS_LANG_GR'
			LEFT JOIN /*DBSRV1.MIS_COMMON.dbo.Z_V_Dates_6789 -- G.K. 25-04-2023 */ #X AS  X			
				ON X.InitialDate = ISNULL(crmIND.crmIND_BirthDate,'')
				AND X.UPD_Date != '1902-02-02'
			OUTER APPLY
				(
					SELECT TOP 1
						crmPARV.crmPARV_StringValue
					FROM
						AR_GSLO_OLTP_REPLICA.dbo.crmPARV
					WHERE
						0 < 3
						AND crmPARV.crmPARV_RowID = rdq.utb_cases_cas.cas_crw_bex_customer_id
						AND crmPARV.crmOBJP_ID = 'SYS_CRM_IND_GENITIVEFATHERNAME'
				) AS [Πατρώνυμο]
			OUTER APPLY
				(
					SELECT TOP 1 
						crmPARV.crmPARV_StringValue 
					FROM 
						AR_GSLO_OLTP_REPLICA.dbo.crmPARV 
					WHERE 
						0<3
						AND crmPARV.crmPARV_RowID	= rdq.utb_cases_cas.cas_crw_bex_customer_id
						AND crmPARV.crmOBJP_ID		= 'SYS_CRM_IND_MOTHERNAME'
				) AS [Μητρώνυμο]
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crwBPX 
				ON crwBPX.crmBP_ID = rdq.utb_cases_cas.cas_crw_bex_customer_id
				AND crwBPX_CSF_Settlement_Status = 'Running'
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crwBPX AS crwBPXX
				ON crwBPXX.crmBP_ID	= rdq.utb_cases_cas.cas_crw_bex_customer_id
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT AS mlt_occ_gslo			
				ON mlt_occ_gslo.crmMLT_ID = crwBPXX.crwBPX_GSLO_Job_Inhouse
				AND mlt_occ_gslo.crmMLT_LanguageID	= 'SYS_LANG_GR'
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.DynamicP_FPS_Cust
				ON DynamicP_FPS_Cust.crmBP_ID = crwBPX.crmBP_ID
		WHERE
			0 < 3


		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace #1




		--====================================================
		--=============== UPDATE PHONE COMMENT ===============
		--====================================================


		--========================
		--======== TRACE 1 =======
		--========================
		
		SET @TRACE = 'Trace #1 - INSERT PHONE COMMENTS'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE

		--TRUNCATE TABLE [rdq].[utb_phone_comments_phc]

		--DECLARE @dtb_phone_comments_phc TABLE
		CREATE TABLE #tmp_phone_comments_phc
		(
			[phc_customer_id] varchar(32), 
			[phc_comments] varchar(30)
		)

		INSERT INTO #tmp_phone_comments_phc
		(
			[phc_customer_id], 
			[phc_comments]
		)	
		
		SELECT DISTINCT
			 X.cst_id
			,'Καμία Καταχώρηση' AS PhoneComments		
		FROM
			rdq.utb_customers_cst X
			LEFT JOIN
			(
				AR_GSLO_OLTP_REPLICA.dbo.crmPoC
				INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmTELF	
					ON crmTELF.crmPoC_ID = crmPoC.crmPoC_ID
			)
			ON crmPoC.crmBP_ID = X.cst_id
		WHERE 
			0 < 3
			AND crmPoC.crmBP_ID IS NULL		
	
		UNION

		SELECT DISTINCT
			 X.cst_id
			,'Κανένα Έγκυρο' AS PhoneComments
		FROM
			rdq.utb_customers_cst X
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmPoC
				ON crmPoC.crmBP_ID = X.cst_id
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmTELF	
				ON crmTELF.crmPoC_ID = crmPoC.crmPoC_ID			
		WHERE
			0 < 3
			AND X.cst_id NOT IN 
				(
					SELECT DISTINCT
						Y.cst_id
					FROM 
						rdq.utb_customers_cst Y
						INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmPoC P 
							ON P.crmBP_ID = Y.cst_id
						INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmTELF T 
							ON T.crmPoC_ID  = P.crmPoC_ID	
					WHERE
						0 < 3
						AND
						(
							ISNULL(P.crmPoC_IsValid,0) = 1 
							OR 
							ISNULL(P.crmPoC_IsDefault,0) = 1
						)
				)

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace #1

		

		SET @TRACE = 'Trace #1 - UPDATE PHONE COMMENTS'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE


		UPDATE rdq.utb_customers_cst
		SET cst_phone_comment = COALESCE(phc_comments, 'Με ενεργά τηλέφωνα')
		FROM rdq.utb_customers_cst
		LEFT JOIN #tmp_phone_comments_phc
			ON cst_id = phc_customer_id


		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace #1


		--=====================
		--=== END PROCEDURE ===
		--=====================		

		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 2

	END TRY
	BEGIN CATCH

		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 3
		RETURN -1

	END CATCH
END
GO


