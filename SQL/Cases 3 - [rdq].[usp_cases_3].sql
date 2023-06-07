USE [ANALYTICS_DB_UAT]
GO

/****** Object:  StoredProcedure [rdq].[usp_cases]    Script Date: 6/7/2023 3:54:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- ============================================================================
-- Author:		Vasilis Zarvalias (VZ), Giorgos Kokkinos (GK)
-- Create date: GK 13-05-2023
-- Alter date:  GK 10-04-2023	=> RD for QV
--				GK 10-04-2023	=> FIX SumPaymentAmount 2023-04-10 => 
--				VZ 25-04-2023	=> AIT-12742 ADD [Hartofilakio_Protofileti]
--				VZ 15-05-2023	=> AIT-12810 ADD Mutiple collumns
--				GK 18-05-2023	=> RD for PBI

-- Description: Fill a cases report table for Analytics
-- ============================================================================

CREATE PROC [rdq].[usp_cases]
	@RUN_ID INT = NULL,
	@PARENT_PROC_NAME VARCHAR(250) = NULL
--WITH RECOMPILE
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
		SET @RUN_ID = (SELECT [rdq].[ufn_get_next_run_id]())
		SET @PARENT_PROC_NAME = @PROC_NAME
	END

	BEGIN TRY

		--=======================
		--=== START PROCEDURE ===
		--=======================

		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, @LOG_TYPE = 1


		--========================
		--======== TRACE 1 =======
		--========================
		
		SET @TRACE = 'Trace #1'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE

		DROP TABLE IF EXISTS #tmp_cos_camp_cases;

		SELECT
			crmCAMP_ID,
			CASE crmBP_ID
				WHEN 'BP_COSMOTE' THEN ISNULL(crmPARV_StringValue,'COS_PRE_LEGAL')
				WHEN 'BP_OTE' THEN ISNULL(crmPARV_StringValue,'OTE_LEGAL')
				ELSE crmPARV_StringValue
			END AS CampGroup
		INTO #tmp_cos_camp_cases
		FROM
			AR_GSLO_OLTP_REPLICA.dbo.crmCAMP -- gen.syn_oltp_tbl_crm_camp 
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmOFF -- gen.syn_oltp_tbl_crm_off
				ON crmOFF_ID = crmCAMP_Offering
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmPARV  --gen.syn_oltp_tbl_crm_parv
				ON crmPARV_RowID = crmCAMP_ID
				AND crmOBJP_ID = 'SYS_CAMP_GROUP'
		WHERE
			(
				CASE crmBP_ID
					WHEN 'BP_COSMOTE' then isnull(crmPARV_StringValue,'COS_PRE_LEGAL')
					WHEN 'BP_OTE' then isnull(crmPARV_StringValue,'OTE_LEGAL')
					ELSE crmPARV_StringValue
				END
			) IS NOT NULL

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO



		--========================
		--======== TRACE 3 =======
		--========================
		
		SET @TRACE = 'Trace #3'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		DROP TABLE IF EXISTS #tmp_nbg_calc_ofeiles
		
		SELECT
			crmBE_ID,
			[Υπολογιστική_οφειλή_NBG],		
			[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],
			[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],
			crwBEX_AccountCloseDT,
			crwBEX_SumExpenses_FCY
		INTO
			#tmp_nbg_calc_ofeiles
		FROM
			gen.syn_oltp_vw_z_nbg_calc_ofeili

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO




		--========================
		--======== TRACE 4 =======
		--========================
		
		SET @TRACE = 'Trace #4'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE

		DROP TABLE IF EXISTS #tmp_be_history_cases

		SELECT
			DISTINCT crmBE_ID
		INTO
			#tmp_be_history_cases
		FROM
			AR_GSLO_OLTP_REPLICA.[dbo].crwBEXH -- [gen].[syn_oltp_tbl_crw_bexh] -- --WITH (INDEX(AK_Contact_rowguid))
		WHERE 
			crwBEXH_SnapshotDT > GETDATE() - 365  

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO
		


		--========================
		--======== TRACE 5 =======
		--========================
		
		SET @TRACE = 'Trace #5'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		CREATE UNIQUE CLUSTERED INDEX ID ON #tmp_be_history_cases(crmBE_ID)

		SET @TRACE_INFO = 'CREATE CLUSTERED INDEX'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO



		--========================
		--======== TRACE 6 =======
		--========================
		
		SET @TRACE = 'Trace #6'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		INSERT INTO #tmp_be_history_cases
		SELECT
			DISTINCT crwBEX.crmBE_ID
		FROM
			AR_GSLO_OLTP_REPLICA.[dbo].crwBEX -- [gen].[syn_oltp_tbl_crw_bex] as crwBEX --
			LEFT JOIN #tmp_be_history_cases
				ON #tmp_be_history_cases.crmBE_ID	= crwBEX.crmBE_ID
		WHERE
			0 < 3
			AND #tmp_be_history_cases.crmBE_ID IS NULL
			AND ISNULL(crwBEX.crwBEX_ActiveStatus,'SYS_LOVD_BE_STATUS_ACTIVE') = 'SYS_LOVD_BE_STATUS_ACTIVE'

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO



		--========================
		--======== TRACE 7 =======
		--========================
		

		SET @TRACE = 'Trace #7'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 
		
		ALTER INDEX ID ON #tmp_be_history_cases REBUILD

		SET @TRACE_INFO = 'REBUILD INDEX for #tmp_be_history_cases'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO


		--========================
		--======== TRACE 8 =======
		--========================
		
		SET @TRACE = 'Trace #8 - Basic Insert'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		TRUNCATE TABLE rdq.utb_cases_cas
		
		INSERT INTO rdq.utb_cases_cas
		(
			 [cas_crm_be_id]
			,[cas_crm_coff_id]
			,[cas_crw_bex_customer_id]
			,[cas_active_status]
			,[cas_account_status]
			,[cas_customer_code]
			,[cas_account_number]
			,[cas_contact_number]
			,[cas_vendor]
			,[cas_product]
			,[cas_assignment_date]
			,[cas_campaign_id]
			,[cas_campaign_code_name]
			,[cas_case_owner]
			,[cas_in_house_group]
			,[cas_in_house_group_2]
			,[cas_hartofilakio_protofileti]
			,[cas_mis_kind]
			,[cas_pd_mis_kind]
			,[cas_administration_code]
			,[cas_black_list_code]
			,[cas_application_number]
			,[cas_current_bucket_number] 
			,[cas_legal_process_status] 
			,[cas_legal_process_status_date] 
			,[cas_product_category]
			,[cas_product_sub_category]
			,[cas_product_description]
			,[cas_product_sub_description]
			,[cas_business_unit_code]
			,[cas_agency_code]
			,[cas_branch_name]
			,[cas_denounce_status]			
			,[cas_billing_day]
			,[cas_last_billing_date]
			,[cas_last_payment_amount]
			,[cas_last_payment_date]			
			,[cas_asset_class]			
			,[cas_delay_days]
			,[cas_issue_date]
			,[cas_transaction_date]			
			,[cas_strategy_step]
			,[cas_strategy_description]
			,[cas_os_balance]
			,[cas_os_asset]
			,[cas_ass_os_balance]
			,[cas_overdue_amount]
			,[cas_frozen_amount]
			,[cas_accounting_balance]
			,[cas_delinq_amount]
			,[cas_total_balance_mlt]
			,[cas_write_off_amount]
			,[cas_debt_amount]
			,[cas_lt_balance]
			,[cas_lt_balance_plus]
			,[cas_balance]
			--,[cas_last_assignment]
			--,[cas_relatives]
			--,[cas_case_counter]
			,[cas_nbg_amount]
			,[cas_total_balance]
			,[cas_financial_status]
			,[cas_spv]
			,[cas_spv_category]
			,[cas_sub_product_category]
			,[cas_service_account_number]
			,[cas_covid_19]
			,[cas_cos_campaigns]
			,[cas_total_case_account_balance]
			,[cas_acc_balance_case]
			,[cas_case_link_acc_amt]
			,[cas_last_legal_action]
			,[cas_last_legal_action_date]
			,[cas_confirm_amnt]
			,[cas_confirm_dt]
			--,[cas_pqh_segment]
			,[cas_confirm_dt_update]
			--,[cas_megisti_hl_ypol]
			,[cas_debtor_generic_text_1]
			,[cas_delay_days_2]
			,[cas_allocation_unique_code]
			,[cas_debt_id]
			,[cas_customer_status]
			,[cas_vendor_branch_id]
			,[cas_debt_generic_decimal_7]
			,[cas_debt_generic_date_5]
			,[cas_debt_generic_date_6]
			--,[cas_cos_past_due_amount]
			,[cas_sub_product_category_2]
			,[cas_legal_status]
			,[cas_settlement_status]
			,[cas_deh_program_nom_energeia]
			,[cas_deh_apotelesma_epidosis_detailed]
			,[cas_deh_Imer_program_nom_energeias]
			,[cas_inhouse_strategy_1]
			,[cas_inhouse_strategy_2]
			,[cas_vendor_strategy]
			/*
			,[cas_nbg_ypologistiki_ofeili]
			,[cas_nbg_plithos_vev_doseon]
			,[cas_nbg_anexoflito_vev_ypoloipo]
			,[cas_nbg_account_close_dt]
			,[cas_nbg_sum_expences]
			*/
			,[cas_customer_multiple_ids_all]
			,[cas_customer_multiple_ids_active]
			--,[cas_trn_last_pay_dt]
			--,[cas_trn_last_pay_amount]
			--,[cas_deh_consecutive_payers]
			--,[cas_alert_consecutive_payers]
			--,[cas_gemi_imerominia_anazitisis]
			--,[cas_ypes_date_ins]
			--,[cas_last_insert_ktimatologio]
		)
		SELECT
			 crwBEX.crmBE_ID																										[cas_crm_be_id]
			,crmBE.crmCOFF_ID																										[cas_crm_coff_id]
			,crwBEX.crwBEX_CustomerID																								[cas_crw_bex_customer_id]
			,REPLACE(ISNULL(crwBEX.crwBEX_ActiveStatus,'SYS_LOVD_BE_STATUS_ACTIVE'),'SYS_LOVD_BE_STATUS_','')						[cas_active_status]
			,MLT_STS.crmMLT_TextInLanguage																							[cas_account_status]
			,crwBEX.crwBEX_COFFCustCode																								[cas_customer_code]
			,crwBEX.crwBEX_COFFRefNo																								[cas_account_number]
			,ISNULL(crwBEX.crwBEX_ContractNo,'(Blank)')																				[cas_contact_number]
			,BP_Vendor.crmBP_Alias																									[cas_vendor]
			,crmOFF_Name																											[cas_product]
			,crmBE.crmBE_InDateTime																									[cas_assignment_date]
			,camp.crmCAMP_ID																										[cas_campaign_id]
			,crmCAMP_CodeName																										[cas_campaign_code_name]
			,ISNULL(BP_Owner.crmBP_Alias,'(Blank)')																					[cas_case_owner]
			,ISNULL(crwBEX.crwBEX_In_House_Group,'(Blank)')																			[cas_in_house_group]
			,ISNULL(crwBEX.crwBEX_In_House_Group_2,'(Blank)')																		[cas_in_house_group_2]
			,ISNULL(crwBEX_Debtors_Portfolio,'(Blank)')																				[cas_hartofilakio_protofileti] -- ZB 25-04-2023 AIT-12742
			,ISNULL(crwBEX.crwBEX_MisKind,'(Blank)')																				[cas_mis_kind]
			,ISNULL(crwBEX.crwBEX_PD_MisKind,'(Blank)')																				[cas_pd_mis_kind]
			,ISNULL(crwBEX.crwBEX_AdministrationCode,'(Blank)')																		[cas_administration_code]
			,ISNULL(crwBEX.crwBEX_BlackListCode,'(Blank)')																			[cas_black_list_code]
			,TRIM(ISNULL(crwBEX.crwBEX_ApplNo,'(Blank)'))																			[cas_application_number]
			,ISNULL(crwBEX.crwBEX_CurBucket,-10)																					[cas_current_bucket_number]
			,ISNULL(crwBEX.crwBEX_LegalProcessStatus,'(Blank)')																		[cas_legal_process_status] 
			,ISNULL(crwBEX.crwBEX_LegalProcessStatusDate, ISNULL(crwBEX.crwBEX_LegalProcessStatusDate,'1903-03-03'))				[cas_legal_process_status_date]			
			,ISNULL(crwBEX.crwBEX_ProductCategory,'(Blank)')																		[cas_product_category]
			,TRIM(ISNULL(crwBEX.crwBEX_ProductSubCategory,'(Blank)'))																[cas_product_sub_category]
			,ISNULL(crwBEX.crwBEX_ProductDescription,'(Blank)')																		[cas_product_description]
			,ISNULL(crwBEX.crwBEX_ProductSubDescription,'(Blank)')																	[cas_product_sub_description]
			,ISNULL(crwBEX.crwBEX_BusinessUnitCode,'(Blank)')																		[cas_business_unit_code]
			,ISNULL(crwBEX.crwBEX_Agency_Code,'(Blank)')																			[cas_agency_code]
			,ISNULL(crwBEX.crwBEX_Account_Branch_Name,'(Blank)')																	[cas_branch_name]
			,ISNULL(crwBEX.crwBEX_Denounce_Status,'(Blank)')																		[cas_denounce_status]
			,ISNULL(REPLACE(crwBEX.crwBEX_Billing_Day,'N/A',-10),-10)																[cas_billing_day]
			,ISNULL(crwBEX.crwBEX_LastBillingDate,'1903-03-03')																		[cas_last_billing_date]
			,ISNULL(crwBEX.crwBEX_LastPmtAmount,0)																					[cas_last_payment_amount]
			,ISNULL(crwBEX.crwBEX_LastPmtDT,'1903-03-03')																			[cas_last_payment_date]
			,ISNULL(crwBEX_Asset_Class,'(Blank)')																					[cas_asset_class]
			,ISNULL(crwBEX.crwBEX_DEL_DAYS,-10)																						[cas_delay_days]
			,ISNULL(crwBEX_DeliqLetter1Date,'1903-03-03')																			[cas_issue_date]
			,ISNULL(crwBEX_DeliqLetter2Date,'1903-03-03')																			[cas_transaction_date]
			,ISNULL(crwBEX.crwBEX_Strategy_Step, ISNULL(crwBEX.crwBEX_StrategyStepDescr,''))										[cas_strategy_step]
			,ISNULL(crwBEX.crwBEX_Strategy_Description, ISNULL(crwBEX.crwBEX_StrategyDescr,''))										[cas_strategy_description]
			,ISNULL(crwBEX.crwBEX_OSBalance,0)																						[cas_os_balance]
			,ISNULL(crwBEX.crwBEX_OsAsset,0)																						[cas_os_asset]
			,ISNULL(crwBEX.crwBEX_OsBalanceAssign,0)																				[cas_ass_os_balance]
			,ISNULL(crwBEX.crwBEX_Overdue_Other_Amount,0)																			[cas_overdue_amount]
			,ISNULL(crwBEX.crwBEX_FrozenIntAmount,0)																				[cas_frozen_amount]
			,ISNULL(crwBEX.crwBEX_AccountingBalance,0)																				[cas_accounting_balance]
			,ISNULL(crwBEX.crwBEX_DelinqAmount,0)																					[cas_delinq_amount]
			,ISNULL(crwBEX.crwBEX_TotalBalanceMLT,0)																				[cas_total_balance_mlt]
			,ISNULL(crwBEX.crwBEX_WriteOffAmount,0)																					[cas_write_off_amount]
			,ISNULL(crwBEX.crwBEX_DebtAmount_FCY,0)																					[cas_debt_amount]
			,ISNULL(/*OA_TRN.BLNC*/NULL,0)																							[cas_lt_balance]			
			,ISNULL(/*OA_TRN_Plus.BLNC*/NULL,0)																						[cas_lt_balance_plus]			
			,ISNULL(crwBEX.crwBEX_OSBalance,0)																						[cas_balance]
			--,CONVERT(BIT,0)																										[cas_last_assignment]
			--,CONVERT(INT,0)																										[cas_relatives]
			--,CONVERT(TINYINT,1)																									[cas_case_counter] -- ΛΟΓΙΚ’ ΟΛΑ 1 ΕΙΝΑΙ
			,ISNULL(crwBEX.crwBEX_AccountingBalance,0) - ISNULL(crwBEX.crwBEX_FrozenIntAmount,0)									[cas_nbg_amount]
			,ISNULL(crwBEX.crwBEX_TotalBalance,0)																					[cas_total_balance]
			,ISNULL(crwBEX.crwBEX_FinancialStatus,'(Blank)')																		[cas_financial_status]
			,ISNULL(crwCOFFX.crwBEX_SPV,'(Blank)')																					[cas_spv]
			,ISNULL(crwCOFFX.crwBEX_SPV_Category,'(Blank)')																			[cas_spv_category]
			,TRIM(ISNULL(crwBEX_SubProdCategory,'(Blank)'))																			[cas_sub_product_category]
			,ISNULL(crwBEX.crwBEX_ServAccNumber,'(Blank)')																			[cas_service_account_number]
			,ISNULL(crwCOFFX.crwbex_Covid19,'(Blank)')																				[cas_covid_19]
			,ISNULL(COSCAMP.CampGroup,'(Blank)') 																					[cas_cos_campaigns]
			,ISNULL(crwBEX.crwBEX_TotalCaseAccountBalance,0)																		[cas_total_case_account_balance]
			,ISNULL(crwcoffx.crwBEX_AccBalanceCase,0)																				[cas_acc_balance_case]			
			,ISNULL(crwcoffx.crwBEX_CASE_LINK_ACC_AMT,0)																			[cas_case_link_acc_amt]
			,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalAction,'(Blank)')																[cas_last_legal_action]
			,ISNULL(crwcoffx.GSLO_AIT_2281_LastLegalActionDate,'1903-03-03')														[cas_last_legal_action_date]
			,ISNULL(crwcoffx.GSLO_Pmt_Confirm_Amnt,0)																				[cas_confirm_amnt]
			,ISNULL(crwcoffx.GSLO_Pmt_Confirm_DT,'1903-03-03')																		[cas_confirm_dt]
			--,CONVERT(VARCHAR(100),'(Blank)')																						[cas_pqh_segment]
			,crwcoffx.GSLO_Pmt_Update_DT																							[cas_confirm_dt_update]
			--,CONVERT(VARCHAR(100),'(Blank)')																						[cas_megisti_hl_ypol]
			,ISNULL(crwBEX.crwBEX_Debtor_Generic_Text_1,'(Blank)')																	[cas_debtor_generic_text_1]
			,ISNULL(crwBEX.crwBEX_DEL_DAYS,'(Blank)')																				[cas_delay_days_2]					-- dual
			,crwBEX.crwBEX_Allocation_Code																							[cas_allocation_unique_code]
			,crwBEX.crwBEX_DebtID																									[cas_debt_id]
			,ISNULL(crwBEX_CustomerStatus,'(Blank)')																				[cas_customer_status]
			,ISNULL(crwBEX.crwBEX_VendorBranchID,'(Blank)')																			[cas_vendor_branch_id]
			,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Decimal_7,0)																		[cas_debt_generic_decimal_7]
			,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_5,'(Blank)')																	[cas_debt_generic_date_5]
			,ISNULL(crwCOFFX.crwBEX_Debt_Generic_Date_6,'(Blank)')																	[cas_debt_generic_date_6]
			--,0																													[cas_cos_past_due_amount]
			,TRIM(ISNULL(crwBEX_SubProdCategory,'(Blank)'))																			[cas_sub_product_category_2]		-- dual
			,ISNULL(crwBEX_LegalStatus,'(Blank)')																					[cas_legal_status]
			,ISNULL(crwBEX_Stlm_Status,'(Blank)')																					[cas_settlement_status]
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_NE_SCHED,'(Blank)')																	[cas_deh_program_nom_energeia]			
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_DEH_AE_DETAILED,'(Blank)')																[cas_deh_apotelesma_epidosis_detailed]
			,ISNULL(crwcoffx.crwCOFFX_GSLO_DEH_NE_SCHED_DT,'1903-03-03')															[cas_deh_Imer_program_nom_energeias]
			,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_1,'(Blank)')																		[cas_inhouse_strategy_1]
			,ISNULL(crwCOFFX_GSLO_Inhouse_Strategy_2,'(Blank)')																		[cas_inhouse_strategy_2]
			,ISNULL(crwCOFFX_GSLO_Vendor_Strategy,'(Blank)')																		[cas_vendor_strategy]
			/*
			,ISNULL(NBG_CALC.[Υπολογιστική_οφειλή_NBG],0)																			[cas_nbg_ypologistiki_ofeili]
			,ISNULL(NBG_CALC.[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],0)													[cas_nbg_plithos_vev_doseon]
			,ISNULL(NBG_CALC.[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],0)															[cas_nbg_anexoflito_vev_ypoloipo]
			,ISNULL(NBG_CALC.crwBEX_AccountCloseDT,'1903-03-03')																	[cas_nbg_account_close_dt]
			,ISNULL(NBG_CALC.crwBEX_SumExpenses_FCY,0)																				[cas_nbg_sum_expences]
			*/
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_All,'')																		[cas_customer_multiple_ids_all]
			,ISNULL(crwCOFFX.crwCOFFX_GSLO_Mult_Cust_Act,'')																		[cas_customer_multiple_ids_active]

			--,CONVERT(DATE,NULL)																									[cas_trn_last_pay_dt]				-- ενημερώνονται στην sp payments
			--,CONVERT(MONEY,NULL)																									[cas_trn_last_pay_amount]			-- ενημερώνονται στην sp payments
			--,CONVERT(VARCHAR(100),'(Blank)')																						[cas_deh_consecutive_payers]		-- ενημερώνονται στην sp payments
			--,CONVERT(VARCHAR(30),'(Blank)')																						[cas_alert_consecutive_payers]		-- ενημερώνονται στην sp payments
			--,CONVERT(DATE,NULL)																									[cas_gemi_imerominia_anazitisis]	--Z.B. 15-05-2023	AIT-12810
			--,CONVERT(DATE,NULL)																									[cas_ypes_date_ins]					--Z.B. 15-05-2023	AIT-12810
			--,CONVERT(DATE,NULL)																									[cas_last_insert_ktimatologio]		--Z.B. 15-05-2023	AIT-12810
		FROM
			AR_GSLO_OLTP_REPLICA.dbo.crwBEX as crwBEX--[gen].[syn_oltp_tbl_crw_bex]
			--INNER JOIN #tmp_be_history_cases
				--ON #tmp_be_history_cases.crmBE_ID = crwBEX.crmBE_ID
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBE as crmBE -- [gen].[syn_oltp_tbl_crm_be]
				ON crmBE.crmBE_ID = crwBEX.crmBE_ID
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmOFF -- [gen].[syn_oltp_tbl_crm_off]
				ON crmOFF_ID = crwBEX.crwBEX_OffID
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCAMP camp --	gen.syn_oltp_tbl_crm_camp crmCAMP
				ON camp.crmCAMP_ID = crmBE.crmCAMP_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP BP_Owner -- [gen].[syn_oltp_tbl_crm_bp]
				ON BP_Owner.crmBP_ID = crmBE.crmBE_Owner
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmMLT AS MLT_STS -- [gen].[syn_oltp_tbl_crm_mlt]
				ON MLT_STS.crmMLT_ID = crmBE.crmBE_Status
				AND MLT_STS.crmMLT_LanguageID = 'SYS_LANG_GR'			
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBP AS BP_Vendor--[gen].[syn_oltp_tbl_crm_bp] /*WITH(INDEX(crmPK_BP))*/
				ON BP_Vendor.crmBP_ID = crwBEX.crwBEX_VendorID
			/*
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.QVMtBIproducts AS PR -- [gen].[syn_oltp_tbl_qvm_products]
				ON PR.ProductID	= crwBEX.crwBEX_OffID
				AND PR.ProductIsActive = 1			
			*/
			LEFT JOIN rdq.mtb_products_prd -- [gen].[syn_oltp_tbl_qvm_products]
				ON prd_id = crwBEX.crwBEX_OffID
				AND prd_is_active = 1			
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crwCOFFX AS crwCOFFX --[gen].[syn_oltp_tbl_crw_coffx] 
				ON crwCOFFX.crmBE_ID = crwBEX.crmBE_ID
			LEFT JOIN #tmp_cos_camp_cases  COSCAMP
				ON COSCAMP.crmCAMP_ID = crmBE.crmCAMP_ID
			--LEFT JOIN #tmp_nbg_calc_ofeiles as NBG_CALC
				--ON NBG_CALC.crmBE_ID = crmBE.crmBE_ID
		WHERE
			0 < 3
			AND prd_id IS NULL
			AND crwBEX.crmBE_ID IN (SELECT #tmp_be_history_cases.crmBE_ID FROM #tmp_be_history_cases)

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO

		

		--========================
		--======== TRACE 9 =======
		--========================
		
		SET @TRACE = 'Trace #9'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 


		UPDATE rdq.utb_cases_cas
		SET
			[cas_nbg_ypologistiki_ofeili] = ISNULL(nbg.[Υπολογιστική_οφειλή_NBG],0),
			[cas_nbg_plithos_vev_doseon] = ISNULL(nbg.[Πλήθος ανεξόφλητων συστεμικά βεβαιωμένων δόσεων],0),
			[cas_nbg_anexoflito_vev_ypoloipo] = ISNULL(nbg.[Ανεξόφλητο βεβαιωμένο υπόλοιπο (Συν. ΣΒΟ)],0),
			[cas_nbg_account_close_dt] = ISNULL(nbg.crwBEX_AccountCloseDT,'1903-03-03'),
			[cas_nbg_sum_expences] = ISNULL(nbg.crwBEX_SumExpenses_FCY,0)
		FROM 
			rdq.utb_cases_cas cas
			INNER JOIN #tmp_nbg_calc_ofeiles nbg
				ON nbg.crmBE_ID = cas_crm_be_id


		DROP TABLE IF EXISTS #tmp_cos_camp_cases
		DROP TABLE IF EXISTS #tmp_nbg_calc_ofeiles
		DROP TABLE IF EXISTS #tmp_be_history_cases

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO	


		





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
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE rdq.utb_cases_cas
		SET
			cas_cos_past_due_amount = ISNULL(DYNAMICP_COS.DP_COS_PAST_DUE_AMT,0)
		FROM
			rdq.utb_cases_cas
			INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.DYNAMICP_COS as DYNAMICP_COS --[gen].[syn_oltp_tbl_dynamic_cop]
				ON DYNAMICP_COS.crmBE_ID = rdq.utb_cases_cas.cas_crm_be_id

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 10





		--=========================
		--======== TRACE 11 =======
		--=========================
		
		SET @TRACE = 'Trace #11'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE rdq.utb_cases_cas
		SET
			cas_megisti_hl_ypol = x.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol
		FROM 
			rdq.utb_cases_cas
			CROSS APPLY
			(
				SELECT TOP 1
					v.DP_VOLTERA_TAB1_Meg_Ilikia_Ypol
				FROM 
					AR_GSLO_OLTP_REPLICA.dbo.DYNAMICP_VOLTERA_TAB1 v
				WHERE 
					v.crmBE_ID = rdq.utb_cases_cas.[cas_crm_be_id]
			) x

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 11





		--=========================
		--======== TRACE 12 =======
		--=========================
		
		SET @TRACE = 'Trace #12'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE rdq.utb_cases_cas
		SET			
			cas_lt_balance_plus = ISNULL(OA_TRN_Plus.BLNC,0)
		FROM 
			rdq.utb_cases_cas
		INNER JOIN
		(
			SELECT
				TRN_OA.crmTRN_Balance BLNC
				,TRN_OA.crmBE_ID
				,DENSE_RANK() OVER(PARTITION BY TRN_OA.crmBE_ID ORDER BY crmTRN_RegDate DESC, crmTRN_SN DESC) RNK
			FROM
				AR_GSLO_OLTP_REPLICA.dbo.crmTRN AS TRN_OA
				INNER JOIN rdq.utb_cases_cas X
					ON x.cas_crm_be_id = TRN_OA.crmBE_ID
			WHERE 
				X.cas_vendor IN ('Kotsovolos', 'Kotsovolos CIS','Kotsovolos Franc.')
		) AS OA_TRN_Plus --> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE
			ON OA_TRN_Plus.crmBE_ID = cas_crm_be_id
			AND RNK = 1

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO

		

		--=========================
		--======== TRACE 13 =======
		--=========================
		
		SET @TRACE = 'Trace #13'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE
			rdq.utb_cases_cas
		SET
			cas_balance = cas_lt_balance_plus
		WHERE
			cas_vendor IN ('Kotsovolos', 'Kotsovolos CIS', 'Kotsovolos Franc.')	--> ΚΩΤΣΟΒΟΛΟΣ FRANCHISE

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 13



		--=========================
		--======== TRACE 14 =======
		--=========================

		SET @TRACE = 'Trace #14'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE 
			rdq.utb_cases_cas
		SET
			cas_balance = cas_os_asset
		WHERE 
			cas_vendor IN ('Intrum Pireaus', 'ΤΡΑΠΕΖΑ ΠΕΙΡΑΙΩΣ PRELEGAL')

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 14



		--=========================
		--======== TRACE 15 =======
		--=========================

		SET @TRACE = 'Trace #15'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 
		
		UPDATE 
			rdq.utb_cases_cas
		SET 
			cas_balance = cas_accounting_balance
		WHERE 
			cas_vendor IN ('NBG')	 --'ΕΘΝΙΚΗ ΤΡΑΠΕΖΑ'
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 15
		
		

		--=========================
		--======== TRACE 16 =======
		--=========================

		SET @TRACE = 'Trace #16'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE
			rdq.utb_cases_cas
		SET
			cas_balance = cas_delinq_amount
		WHERE
			cas_vendor IN
					(
						'Do Value Venus'	-- 'VENUS'
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
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 16


		



		--=========================
		--======== TRACE 17 =======
		--=========================

		SET @TRACE = 'Trace #17'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE 
			rdq.utb_cases_cas
		SET 
			cas_balance = cas_total_balance_mlt
		WHERE 
			cas_vendor = 'Alpha Bank' -- 'ALPHA BANK'
			AND cas_denounce_status = 'WRITE OFF'
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 17



		--=========================
		--======== TRACE 18 =======
		--=========================

		--SET @TRACE = 'Trace #18 - disable'
		--EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		-- G.K.
		/*
		CREATE INDEX NCLIX_utb_cases_cas_crmCOFF_ID ON rdq.utb_cases_cas(cas_crm_coff_id)
		*/

		--SET @TRACE_INFO = 'CREATE NON CLUSTERED INDEX'
		--EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 18




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



		--=========================
		--======== TRACE 19 =======
		--=========================

		SET @TRACE = 'Trace #19'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		DROP TABLE IF EXISTS #tmp_be_loc
		
		-- G.K.
		SELECT
			BE_LOC.crmCOFF_ID
			,BE_LOC.crmBE_ID
			,DENSE_RANK() OVER(PARTITION BY BE_LOC.crmCOFF_ID ORDER BY BE_LOC.crmBE_InDateTime DESC, BE_LOC.crmBE_CreateDT DESC, BE_LOC.crmBE_ID ASC) as RNK
		INTO #tmp_be_loc
		FROM 
			AR_GSLO_OLTP_REPLICA.dbo.crmBE AS BE_LOC
			INNER JOIN rdq.utb_cases_cas X			 
				ON X.cas_crm_coff_id = BE_LOC.crmCOFF_ID
		WHERE 
			1 = 1


		UPDATE 
			rdq.utb_cases_cas
		SET 
			cas_last_assignment = 1
		FROM 
			rdq.utb_cases_cas
			INNER JOIN #tmp_be_loc
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
			AS LAST_BE
				ON LAST_BE.crmCOFF_ID = rdq.utb_cases_cas.cas_crm_coff_id
				AND LAST_BE.crmBE_ID = rdq.utb_cases_cas.cas_crm_be_id
				AND RNK	= 1
		WHERE
			1 = 1

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 19




		--=========================
		--======== TRACE 20 =======
		--=========================

		--SET @TRACE = 'Trace #20 - disable'
		--EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		/*
		CREATE INDEX NCLIX_utb_cases_cas_crwBEX_CustomerID ON rdq.utb_cases_cas([cas_crw_bex_customer_id])
		*/

		--SET @TRACE_INFO = 'CREATE NON CLUSTERED INDEX'
		--EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 20
		
		
		
		

		--=========================
		--======== TRACE 21 =======
		--=========================

		SET @TRACE = 'Trace #21'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 


		UPDATE 
			rdq.utb_cases_cas
		SET 
			cas_relatives = X.CNT
		FROM 
			rdq.utb_cases_cas
			INNER JOIN
			(
				SELECT DISTINCT 
					crmBE.crmBE_ID
					,COUNT(DISTINCT crmBPR.crmBP_SR_ID) CNT
				FROM 
					AR_GSLO_OLTP_REPLICA.dbo.crmBE crmBE			 
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmCOFF		ON crmCOFF.crmCOFF_ID	= crmBE.crmCOFF_ID
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPRCOFF	ON crmCOFF.crmCOFF_ID	= crmBPRCOFF.crmCOFF_ID
					INNER JOIN AR_GSLO_OLTP_REPLICA.dbo.crmBPR		ON crmBPR.crmBPR_ID		= crmBPRCOFF.crmBPR_ID
				WHERE
					crmBPR.crmBPRC_ID  IN 
								(
									'BPRC_COCREDITOR'
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
									,'BPRC_LEGAL_REP'
								)
					AND crmBPR.crmBPR_IsValid = 1
					AND crmBPR.crmBP_SR_ID IS NOT NULL
					AND crmBPR.crmBP_SR_ID != ''
				GROUP BY crmBE.crmBE_ID
			) AS X
				ON X.crmBE_ID = rdq.utb_cases_cas.cas_crm_be_id

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 21



		--=========================
		--======== TRACE 22 =======
		--=========================

		SET @TRACE = 'Trace #22 - PQH only'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 

		UPDATE
			rdq.utb_cases_cas
		SET
			cas_pqh_segment = ISNULL(pqh_kampania,'Rest')
		FROM
			rdq.utb_cases_cas
			LEFT JOIN rdq.utb_segments_pqh
				ON pqh_admin_code = cas_administration_code
		WHERE
			rdq.utb_cases_cas.cas_vendor = 'PQH'

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 22



		--========================
		--======== TRACE 27 =======
		--========================
		
		--ZB 15-05-2023 AIT-12810
		SET @TRACE = 'Trace #27'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE


		SELECT DISTINCT
			c.crmBE_ID
			,DES2Dynamics.Searching_Date	AS [Gemi_imerominia_anazitisis]		--ΓΕΜΗ Ημερομηνία αναζήτησης													
			,YPES_Results_DateIns			AS [Ypes_DateIns]					--ΥΠΕΣ DateIns
			,crmPARV_DTValue				AS [Last_Insert_Ktimatologio]		--Last Insert Ktimatologio
			,ROW_NUMBER() OVER(PARTITION BY c.crmBE_ID order by DES2Dynamics.Searching_Date desc, YPES_Results_DateIns desc, crmPARV_DTValue desc) as RNK
		INTO #tmp_x
		FROM 
			QVM.dbo.QVMtBIcases as c
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_GEMI_Dynamics AS DES2Dynamics		
				ON DES2Dynamics.crmBE_ID = c.crmBE_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_YPES_Results  AS DES2YpesResults	
				ON DES2YpesResults.crmBE_ID = c.crmBE_ID
			LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmparv --gen.syn_oltp_tbl_crm_parv
				ON crmPARV_ROWID = c.crmBE_ID 
				AND crmobjp_id = 'GSLO_Dynamic_Ktimatologio_DT'

		UPDATE 
			rdq.utb_cases_cas
		SET 
			cas_gemi_imerominia_anazitisis = DES2_Dinamikes_Arotron.[Gemi_imerominia_anazitisis],
			cas_ypes_date_ins =	DES2_Dinamikes_Arotron.[Ypes_DateIns],
			cas_last_insert_ktimatologio =	DES2_Dinamikes_Arotron.[Last_Insert_Ktimatologio]
		FROM 
			rdq.utb_cases_cas
			INNER JOIN
			/*
			(
				SELECT DISTINCT
					c.crmBE_ID
					,DES2Dynamics.Searching_Date	AS [Gemi_imerominia_anazitisis]		--ΓΕΜΗ Ημερομηνία αναζήτησης													
					,YPES_Results_DateIns			AS [Ypes_DateIns]					--ΥΠΕΣ DateIns
					,crmPARV_DTValue				AS [Last_Insert_Ktimatologio]		--Last Insert Ktimatologio
					,ROW_NUMBER() OVER(PARTITION BY c.crmBE_ID order by DES2Dynamics.Searching_Date desc, YPES_Results_DateIns desc, crmPARV_DTValue desc) as RNK
				FROM 
					QVM.dbo.QVMtBIcases as c
					LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_GEMI_Dynamics AS DES2Dynamics		
						ON DES2Dynamics.crmBE_ID = c.crmBE_ID
					LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.z_vw_YPES_Results  AS DES2YpesResults	
						ON DES2YpesResults.crmBE_ID = c.crmBE_ID
					LEFT JOIN AR_GSLO_OLTP_REPLICA.dbo.crmparv									
						ON crmparv.crmPARV_ROWID = c.crmBE_ID 
						AND crmobjp_id = 'GSLO_Dynamic_Ktimatologio_DT'
			) 
			*/
			#tmp_x AS DES2_Dinamikes_Arotron 
				ON DES2_Dinamikes_Arotron.crmBE_ID = rdq.utb_cases_cas.cas_crm_be_id
		where 
			RNK = 1
		
		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 27



		--========================
		--======== TRACE 28 =======
		--========================
		
		--Z.B. 15-05-2023	AIT-12810

		SET @TRACE = 'Trace #28 - not ready yet becase of actions'
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 4, @TRACE 
		;		
		
		UPDATE rdq.utb_cases_cas
        SET 
            cas_last_skip_date = [Max_Last_Skip_Date]
        FROM
			rdq.utb_cases_cas
        	INNER JOIN 
        	(
           		SELECT 
               		act_crm_be_id
               		,MAX(act_action_result_date) AS [Max_Last_Skip_Date]
           		FROM 
					rdq.utb_cases_cas AS c
           			LEFT JOIN rdq.utb_actions_act 
						ON act_crm_be_id = c.cas_crm_be_id 
           		WHERE 
					1 = 1
           			AND act_action_result = 'Σύντομη Αναζήτηση Στοιχείων Οφειλέτη' 
           		GROUP BY 
					act_crm_be_id
        	) AS x
            	ON cas_crm_be_id = act_crm_be_id
		

		SET @TRACE_INFO = 'ROWCOUNT: ' + CAST(@@ROWCOUNT AS VARCHAR(500))
		EXEC [rdq].[usp_set_log] @RUN_ID, @PARENT_PROC_NAME, @PROC_NAME, 5, @TRACE, @TRACE_INFO -- end trace 28



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


