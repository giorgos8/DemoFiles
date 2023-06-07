using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Security.Cryptography;
using Microsoft.AnalysisServices.AdomdClient;
using Microsoft.AnalysisServices;

namespace Risko
{
    public partial class FormDBConnection : Form
    {
        //private System.Windows.Forms.Timer tmr;

        public static SqlConnection cnn_global;
        public static string strServerName_global;
        public static string strDatabase_global;
        public static string strSysDatabase_global;


        public static bool bBasel4_global = false;
        public static string  strTblProcesses_global = "dbo.RMC_PROCESSES";
        public static string  strTblProcParams_global = "dbo.RMC_PROCESS_PARAMS";
        public static string  strTblScenario_global = "dbo.RML_SCENARIO";
        public static string  strTblCurrency_global = "dbo.RML_CURRENCY";
        public static string  strTblRegulation_global = "dbo.RML_REGULATION";
        public static string  strTblProcSteps_global = "dbo.RMC_PROCESS_STEPS";
        public static string  strTblProcStepDetails_global = "dbo.RMC_PROCESS_STEP_DETAILS";
        public static string  strTblProcGroups_global = "dbo.RMC_PROCESS_GROUPS";
        public static string strTblReportingProfile_global = "dbo.RMC_REPORTINGPROFILE";
        public static string strTblCountry_global = "dbo.RML_COUNTRY";
        public static string strTblGroupEntity_global = "dbo.RMC_GROUPENTITY";
        public static string strTblGroupEntityType_global = "dbo.RML_GROUPENTITYTYPE";
        public static string strTblReportingProfileEntities_global = "RMC_REPORTINGPROFILE_ENTITIES";
        public static string strTblProcessLog_global = "dbo.RMP_PROCESSLOG";
        public static string strTblLoggedMessages_global = "dbo.RMP_LOGGEDMESSAGES";
        public static string strTblRegulatoryCounterpartyGroup_global = "dbo.RML_REGULATORYCOUNTERPARTYGROUP";
        public static string strTblCounterpartyType_global = "dbo.RML_COUNTERPARTYTYPE";

        public static string strTblLiqCounterparty_global = "dbo.RMF_LIQUIDITY_COUNTERPARTIES";
        public static string strTblLiqAdditionals_global = "dbo.RMF_LIQUIDITY_ADDITIONALS";
        public static string strTblLiqAssets_global = "dbo.RMF_LIQUIDITY_ASSETS";
        public static string strTblLiqDepositsLoans_global = "dbo.RMF_LIQUIDITY_DEPOSITS_LOANS";
        public static string strTblLiqSLSB_global = "dbo.RMF_LIQUIDITY_SLSB";
        public static string strTblLiqLoanCollaterals_global = "dbo.RMF_LIQUIDITY_LOAN_COLLATERALS";
        public static string strTblExchangeRates_global = "dbo.RMF_EXCHANGERATES";
        public static string strTblApproaches_global = "dbo.RML_APPROACH";


        public FormDBConnection()
        {
            InitializeComponent();
        }

        private void buttonConnect_Click(object sender, EventArgs e)
        {
            Connect(false, BuildConnectionString(this.textBoxServerName.Text, ((ComboListItem)comboBoxDatabases.SelectedItem).Name, (this.radioButtonWindowsAuthentication.Checked == true ? true : false)));
        }

        private void buttonTestConnection_Click(object sender, EventArgs e)
        {
            if (((ComboListItem)comboBoxDatabases.SelectedItem).ID == "0")
            {
                MessageBox.Show("Choose a Database...", "SQL Server Connection", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            string strConnectionString = string.Empty;
            strConnectionString = BuildConnectionString(this.textBoxServerName.Text, ((ComboListItem)comboBoxDatabases.SelectedItem).Name, (this.radioButtonWindowsAuthentication.Checked == true ? true : false));
            Connect(true, strConnectionString);
            
            
            if (this.radioButtonSQLServerAuthentication.Checked)
            {
                strConnectionString = strConnectionString.Substring(0, strConnectionString.IndexOf(";Password=") + 10);
                this.textBoxConnectionString.Text = strConnectionString;
            }
            else
            {
                this.textBoxConnectionString.Text = strConnectionString;
            }            
        }

        private void buttonTestConnectionFromConString_Click(object sender, EventArgs e)
        {            
            Connect(true, this.textBoxConnectionString.Text);
        }


        private void buttonConnectionFromConString_Click(object sender, EventArgs e)
        {
            Connect(false, this.textBoxConnectionString.Text);
        }

        public string BuildConnectionString(string strServerName, string strDatabase, bool bWsAuth)
        {
            string strConnectionString = string.Empty;            

            // Azure            
            if(this.checkBoxAzure.Checked)
            {
                strConnectionString = "Server=tcp:" + strServerName + ",1433;Initial Catalog=" + strDatabase + ";Persist Security Info=False;User ID=" + this.textBoxUserName.Text + ";Password=" + this.textBoxPassword.Text + ";MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=10;";
            }
            else
            {
                if (bWsAuth)
                    strConnectionString = "Server=" + strServerName + ";Database=" + strDatabase + ";Integrated Security = SSPI;";
                else
                    strConnectionString = "Data Source=" + strServerName + ";Initial Catalog = " + strDatabase + ";User ID=" + this.textBoxUserName.Text + ";Password=" + this.textBoxPassword.Text;
            }

            return strConnectionString;
        }

        public void Connect(bool bTestConnection, string strConnectionString)
        {
            // try open db connection
            SqlConnection cnn;

            if (!bTestConnection)
            {
                if (((ComboListItem)comboBoxDatabases.SelectedItem).ID == "0")
                {
                    MessageBox.Show("Choose a Database...", "SQL Server Connection", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return;
                }
            }

            cnn = new SqlConnection(strConnectionString);
            try
            {

                cnn.Open();

                if (!bTestConnection)
                { 
                    this.Hide();

                    cnn_global = cnn;
                    strServerName_global = this.textBoxServerName.Text;
                    strDatabase_global = ((ComboListItem)comboBoxDatabases.SelectedItem).Name;
                    strSysDatabase_global = ((ComboListItem)comboBoxDatabases_Sys.SelectedItem).Name;


                    
                    // open main dialog list
                    FormMainDialog dlgMain = new FormMainDialog();
                    dlgMain.ShowDialog();
                }
                else
                {
                    MessageBox.Show("DB Connection - Success!", "DB Connection", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);                    
                }

                cnn.Close();

                if (bTestConnection)
                    return;
            }
            catch (Exception)
            {
                MessageBox.Show("Can not connect!", "DB Connection", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            this.Close();

            return;
        }

       private void DefaultConnection()
        {
            // try open db connection
            SqlConnection cnn_try;
            string connetionString = null;            

            string strServerName = this.textBoxServerName.Text;
            string strDatabase = "master";      

            connetionString = BuildConnectionString(strServerName, strDatabase, (this.radioButtonWindowsAuthentication.Checked == true ? true : false));

            cnn_try = new SqlConnection(connetionString);
            try
            {
                cnn_try.Open();

                FillComboDatabases(cnn_try);
                FillComboDatabases_Sys(cnn_try);

                // Fill SQL Server Characteristics
                
                string sql = String.Format
                (
                  @"
                    set nocount on
                    SELECT
                     @@servername AS [ServerName],
                     isnull(cast((select distinct top 1 local_tcp_port from sys.dm_exec_connections where local_tcp_port is not null) as varchar(20)), '') as Port,
                       CASE 
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '8%' THEN 'SQL2000'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '9%' THEN 'SQL2005'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.0%' THEN 'SQL2008'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '10.5%' THEN 'SQL2008 R2'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '11%' THEN 'SQL2012'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '12%' THEN 'SQL2014'
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '13%' THEN 'SQL2016'    
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '14%' THEN 'SQL2017' 
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '15%' THEN 'SQL2019' 
                         WHEN CONVERT(VARCHAR(128), SERVERPROPERTY ('productversion')) like '16%' THEN 'SQL2022' 
                         ELSE 'unknown'
                      END AS MajorVersion,
                    convert(varchar(50), sqlserver_start_time, 120)  as sqlserver_start_time
                    FROM sys.dm_os_sys_info
                ");

                SqlCommand command;
                SqlDataReader rdr;
                command = new SqlCommand(sql, cnn_try);
                rdr = command.ExecuteReader();            


                if (rdr != null)
                {
                    if (rdr.HasRows)
                        while (rdr.Read())
                        {
                            this.textBox_PORT.Text = rdr.GetString(1);
                            this.textBox_VERSION.Text = rdr.GetString(2);
                            this.textBox_Last_Restart.Text = rdr.GetString(3);
                        }
                    rdr.Close();
                    rdr.Dispose();
                }
                

                cnn_try.Close();
            }
            catch (Exception)
            {
                MessageBox.Show("Can not open connection! ");
                return;
            }            
        }

        private void SysDBConnection()
        {
            // try open db connection
            SqlConnection cnn_try;
            string connetionString = null;

            string strServerName = this.textBoxServerName.Text;
            string strDatabase = "master";

            connetionString = "Server=" + strServerName + "; Database=" + strDatabase + ";Integrated Security = SSPI;";
            connetionString = BuildConnectionString(strServerName, strDatabase, (this.radioButtonWindowsAuthentication.Checked == true ? true : false));

            cnn_try = new SqlConnection(connetionString);
            try
            {
                cnn_try.Open();

                FillComboDatabases_Sys(cnn_try);

                cnn_try.Close();
            }
            catch (Exception)
            {
                MessageBox.Show("Can not open connection ! ");
                return;
            }
        }

        private void FormDBConnection_Load(object sender, EventArgs e)
        {            
            //this.textBoxServerName.Text = "192.168.0.168";
            //DefaultConnection();
        }

        void FillComboDatabases(SqlConnection cnn_try)
        {
            this.comboBoxDatabases.Items.Clear();

            ComboListItem form = new ComboListItem("0", "<Choose Database...>");
            this.comboBoxDatabases.Items.Add(form);
            this.comboBoxDatabases.DisplayMember = "Name";
            this.comboBoxDatabases.ValueMember = "ID";

            //================ γεμίζω τα ιδρύματα ================
            string sql = String.Format("select cast(database_id as nvarchar(10)), name from sys.databases order by database_id");

            SqlCommand command;
            SqlDataReader rdr;
            command = new SqlCommand(sql, cnn_try);
            rdr = command.ExecuteReader();

            string strRiskAvertDB_Name = "";
            int iRiskAvertDB_Index_Count = 0;


            if (rdr != null)
            {
                if (rdr.HasRows)
                    while (rdr.Read())
                    {
                        ComboListItem item = new ComboListItem(rdr.GetString(0), rdr.GetString(1));
                        this.comboBoxDatabases.Items.Add(item);
                        this.comboBoxDatabases.DisplayMember = "Name";
                        this.comboBoxDatabases.ValueMember = "ID";                                              
                    }
                rdr.Close();
                rdr.Dispose();
            }

            if (iRiskAvertDB_Index_Count >= 1)
            {                
                for (int i = 0; i < this.comboBoxDatabases.Items.Count; i++)
                {
                    if (((ComboListItem)comboBoxDatabases.Items[i]).Name == strRiskAvertDB_Name)
                        comboBoxDatabases.SelectedIndex = i;
                }
            }
            else
                this.comboBoxDatabases.SelectedIndex = 0;
        }

        void FillComboDatabases_Sys(SqlConnection cnn_try)
        {
            this.comboBoxDatabases_Sys.Items.Clear();

            ComboListItem form = new ComboListItem("0", "<Choose Sys Database...>");
            this.comboBoxDatabases_Sys.Items.Add(form);
            this.comboBoxDatabases_Sys.DisplayMember = "Name";
            this.comboBoxDatabases_Sys.ValueMember = "ID";


            string sql = String.Format("select cast(database_id as nvarchar(10)), name from sys.databases order by database_id");

            SqlCommand command;
            SqlDataReader rdr;
            command = new SqlCommand(sql, cnn_try);
            rdr = command.ExecuteReader();


            string strRiskAvertDB_Sys_Name = "";
            int iRiskAvertDB_Sys_Index_Count = 0;

            if (rdr != null)
            {
                if (rdr.HasRows)
                    while (rdr.Read())
                    {
                        ComboListItem item = new ComboListItem(rdr.GetString(0), rdr.GetString(1));
                        this.comboBoxDatabases_Sys.Items.Add(item);
                        this.comboBoxDatabases_Sys.DisplayMember = "Name";
                        this.comboBoxDatabases_Sys.ValueMember = "ID";

                        if (rdr.GetString(1) == "RiskAvert_sysDB")
                        {
                            iRiskAvertDB_Sys_Index_Count++;
                            strRiskAvertDB_Sys_Name = rdr.GetString(1);
                        }
                    }
                rdr.Close();
                rdr.Dispose();
            }

            if (iRiskAvertDB_Sys_Index_Count == 1)
            {
                for (int i = 0; i < this.comboBoxDatabases_Sys.Items.Count; i++)
                {
                    if (((ComboListItem)comboBoxDatabases_Sys.Items[i]).Name == strRiskAvertDB_Sys_Name)
                        comboBoxDatabases_Sys.SelectedIndex = i;
                }
            }
            else
                this.comboBoxDatabases_Sys.SelectedIndex = 0;
        }

        private void textBoxServerName_TextChanged(object sender, EventArgs e)
        {
            this.comboBoxDatabases.Items.Clear();
        }

        private void buttonDBRefresh_Click(object sender, EventArgs e)
        {
            DefaultConnection();
        }

        private void radioButtonSQLServerAuthentication_CheckedChanged(object sender, EventArgs e)
        {
            if (this.radioButtonSQLServerAuthentication.Checked)
            {
                this.radioButtonWindowsAuthentication.Checked = false;

                this.textBoxUserName.Enabled = true;                
                this.textBoxPassword.Enabled = true;
            }
        }

        private void radioButtonWindowsAuthentication_CheckedChanged(object sender, EventArgs e)
        {
            if (this.radioButtonWindowsAuthentication.Checked)
            {
                this.radioButtonSQLServerAuthentication.Checked = false;
                this.textBoxPassword.Enabled = false;
                this.textBoxUserName.Enabled = false;
            }
        }

       
       

        private void radioButton_RiskAvert_UAT_CheckedChanged(object sender, EventArgs e)
        {
            string strSelectedTab = this.tabControlDbConnections.SelectedTab.Tag.ToString();
            string strIP = "DBSRV2";

            if (this.radioButton_RiskAvert_UAT.Checked)
            {
                if (strSelectedTab == "1")
                {
                    this.textBoxServerName.Text = strIP;
                    DefaultConnection();
                }

                if (strSelectedTab == "2")
                {
                    this.textBoxSaasServerName.Text = strIP;
                    FillSssaDatabases();
                }
            }
        }

        private void button_NoDbConnection_Click(object sender, EventArgs e)
        {
            this.Hide();
            FormMainDialog dlgMain = new FormMainDialog();
            dlgMain.ShowDialog();
            this.Close();                
            return;
        }

        

       

     
     

       

    

        private void checkBoxAzure_CheckedChanged(object sender, EventArgs e)
        {
            if (this.checkBoxAzure.Checked)
            {
                this.textBoxServerName.Text = "{Server Name}.database.windows.net";
                this.radioButtonSQLServerAuthentication.Checked = true;
            }
            else
            {
                this.textBoxServerName.Text = string.Empty;
                this.radioButtonWindowsAuthentication.Checked = true;
            }
        }

        private void buttonSaasDbRefresh_Click(object sender, EventArgs e)
        {
            FillSssaDatabases();
        }

        private void FillSssaDatabases()
        {
            List<Tuple<string, string>> ssasDatabases = new List<Tuple<string, string>>();
            ssasDatabases = RetrieveSaasDatabases(this.textBoxSaasServerName.Text);

            this.comboBoxSaasDB.Items.Clear();

            ComboListItem form = new ComboListItem("", "<Choose Database...>");
            this.comboBoxSaasDB.Items.Add(form);
            this.comboBoxSaasDB.DisplayMember = "Name";
            this.comboBoxSaasDB.ValueMember = "ID";

            for (int i = 0; i < ssasDatabases.Count; i++)
            {    
                FillSaasComboDatabases(ssasDatabases[i].Item1, ssasDatabases[i].Item2);
            }

            this.comboBoxSaasDB.SelectedIndex = 0;
        }

        public static List<Tuple<string, string>> RetrieveSaasDatabases(string strSsasServerName) // List<Tuple<string, string, string>>()
        {
            var retList = new List<Tuple<string, string>>();

            // Run MDX Query with C#
            string commandText = @"SELECT [catalog_name] as [Database Name], [Date_Modified] FROM $SYSTEM.DBSCHEMA_CATALOGS";

            AdomdConnection cnConn = null;
            string cubeConnectionString = "";            

            cubeConnectionString = @"Provider=MSOLAP.8;Integrated Security=SSPI;Persist Security Info=True;Data Source=" + strSsasServerName + ";MDX Compatibility=1;Safety Options=2;MDX Missing Member Mode=Error;Update Isolation Level=2";
            cnConn = new AdomdConnection(cubeConnectionString);
            cnConn.Open();

            if (cnConn.State == ConnectionState.Open)
            {
                AdomdCommand cmd = new AdomdCommand(commandText, cnConn);
                AdomdDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    retList.Add(new Tuple<string, string>( Convert.ToString(dr[0]), Convert.ToString(dr[1])));
                }
            }

            return retList;
        }


        void FillSaasComboDatabases(string ssasDb, string ssasLastDateModified)
        {                                          
            ComboListItem item = new ComboListItem(ssasLastDateModified, ssasDb);
            this.comboBoxSaasDB.Items.Add(item);
            this.comboBoxSaasDB.DisplayMember = "Name";
            this.comboBoxSaasDB.ValueMember = "ID";
        }

        private void buttonSaasConnect_Click(object sender, EventArgs e)
        {
            if (((ComboListItem)comboBoxSaasDB.SelectedItem).ID == "")
            {
                MessageBox.Show("Choose a Database...", "SSAS Connection", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return;
            }

            string strSaasServerName = this.textBoxSaasServerName.Text;
            string strSaasDb = ((ComboListItem)this.comboBoxSaasDB.SelectedItem).Name;
            string strSaasConString = string.Empty;

            strSaasConString = BuildSsasConnectionString(strSaasServerName, strSaasDb);

            this.textBoxSaasConnectionString.Text = strSaasConString;


            //==========================================================
            //==========================================================
            //==========================================================

            AdomdConnection cnConn = null;

            cnConn = new AdomdConnection(strSaasConString);
            cnConn.Open();

            if (cnConn.State == ConnectionState.Open)
            {
                var lstDimensions = new List<Tuple<string, string, string>>();
                var lstCubes = new List<Tuple<string, string, string>>();

                for (int i = 0; i < cnConn.Cubes.Count; i++)
                {

                    if (cnConn.Cubes[i].Type == CubeType.Dimension)
                    {
                        lstDimensions.Add(new Tuple<string, string, string>(cnConn.Cubes[i].Name, cnConn.Cubes[i].LastProcessed.ToString(), "Dim"));
                    }


                    if (cnConn.Cubes[i].Type == CubeType.Cube)
                    {
                        lstCubes.Add(new Tuple<string, string, string>(cnConn.Cubes[i].Name, cnConn.Cubes[i].LastProcessed.ToString(), "Cube"));                        
                    }

                    if (cnConn.Cubes[i].Type == CubeType.Unknown)
                    {
                        MessageBox.Show("Unknown Type");
                    }
                   
                }
                
                this.listViewCubes.CheckBoxes = true;
                this.listViewCubes.Columns.Clear();
                this.listViewCubes.Items.Clear();
                this.listViewCubes.View = View.Details;
                this.listViewCubes.GridLines = true;
                this.listViewCubes.FullRowSelect = true;
                this.listViewCubes.MultiSelect = false;
                this.listViewCubes.ForeColor = System.Drawing.Color.Black;

                this.listViewCubes.Columns.Add("Cube", 150, HorizontalAlignment.Left);
                this.listViewCubes.Columns.Add("Last Process", 140, HorizontalAlignment.Left);
                this.listViewCubes.Columns.Add("Type", 50, HorizontalAlignment.Left);

                for (int i = 0; i < lstDimensions.Count(); i++)
                {                   

                    ListViewItem item = this.listViewCubes.Items.Add(lstDimensions[i].Item1, lstDimensions[i].Item1);
                    item.SubItems.Add(lstDimensions[i].Item2);
                    item.SubItems.Add(lstDimensions[i].Item3);
                }

                for (int i = 0; i < lstCubes.Count(); i++)
                {

                    ListViewItem item = this.listViewCubes.Items.Add(lstCubes[i].Item1, lstCubes[i].Item1);
                    item.SubItems.Add(lstCubes[i].Item2);
                    item.SubItems.Add(lstCubes[i].Item3);
                }

                //****************
                //if (bShowMessage)
                //MessageBox.Show("Connected!", "Cube Connection Check", MessageBoxButtons.OK, MessageBoxIcon.Asterisk);
                //****************

                //****************
                cnConn.Close();
                //****************
            }
            else
            {
                //this.buttonSaasConnect.BackColor = Color.Red;
                MessageBox.Show("Not Open!");
            }
        }

        private string BuildSsasConnectionString(string strSsasServerName, string strSsasDbName)
        {
            string strSaasConnectionString = string.Empty;
            //connectionString = @"Provider=MSOLAP.8;Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=LiquidityRisk;Data Source=10.0.11.180;MDX Compatibility=1;Safety Options=2;MDX Missing Member Mode=Error;Update Isolation Level=2";
            strSaasConnectionString = "Provider=MSOLAP.8;Integrated Security=SSPI;Persist Security Info=True;Initial Catalog=" + strSsasDbName + ";Data Source=" + strSsasServerName + "; MDX Compatibility = 1; Safety Options = 2; MDX Missing Member Mode = Error; Update Isolation Level = 2";
            return strSaasConnectionString;
        }

        private void comboBoxSaasDB_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strSelCubeLastDateMod = ((ComboListItem)this.comboBoxSaasDB.SelectedItem).ID;
            this.textBoxSaasDbLastModified.Text = strSelCubeLastDateMod;

            // Clear the fields
            this.textBoxSaasConnectionString.Text = string.Empty;
            this.listViewCubes.Columns.Clear();
            this.listViewCubes.Items.Clear();
        }

        private void comboBoxDatabases_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void buttonSsasProcessCube_Click(object sender, EventArgs e)
        {
            
        }

        private void radioButton_RiskAvert_Prod_CheckedChanged(object sender, EventArgs e)
        {
            string strSelectedTab = this.tabControlDbConnections.SelectedTab.Tag.ToString();
            string strIP = @"DBSRV1";

            if (this.radioButton_RiskAvert_Prod.Checked)
            {
                if (strSelectedTab == "1")
                {
                    this.textBoxServerName.Text = strIP;
                    DefaultConnection();
                }

                if (strSelectedTab == "2")
                {
                    this.textBoxSaasServerName.Text = strIP;
                    FillSssaDatabases();
                }
            }
        }

        private void radioButton_MySQLServer_CheckedChanged(object sender, EventArgs e)
        {
            string strSelectedTab = this.tabControlDbConnections.SelectedTab.Tag.ToString();
            string strIP = ".";

            if (this.radioButton_MySQLServer.Checked)
            {
                if (strSelectedTab == "1")
                {
                    this.textBoxServerName.Text = strIP;
                    DefaultConnection();
                }

                if (strSelectedTab == "2")
                {
                    this.textBoxSaasServerName.Text = strIP;
                    FillSssaDatabases();
                }
            }
        }

        private void radioButton_DEV_CheckedChanged(object sender, EventArgs e)
        {
            string strSelectedTab = this.tabControlDbConnections.SelectedTab.Tag.ToString();
            string strIP = "maintenancedb2";

            if (this.radioButton_DEV.Checked)
            {
                if (strSelectedTab == "1")
                {
                    this.textBoxServerName.Text = strIP;
                    DefaultConnection();
                }

                if (strSelectedTab == "2")
                {
                    this.textBoxSaasServerName.Text = strIP;
                    FillSssaDatabases();
                }
            }
        }
    }
}
