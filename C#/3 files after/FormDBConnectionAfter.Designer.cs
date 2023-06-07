namespace Risko
{
    partial class FormDBConnection
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.labelServerName = new System.Windows.Forms.Label();
            this.textBoxServerName = new System.Windows.Forms.TextBox();
            this.buttonConnect = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.comboBoxDatabases = new System.Windows.Forms.ComboBox();
            this.buttonDBRefresh = new System.Windows.Forms.Button();
            this.buttonTestConnection = new System.Windows.Forms.Button();
            this.textBoxConnectionString = new System.Windows.Forms.TextBox();
            this.buttonTestConnectionFromConString = new System.Windows.Forms.Button();
            this.radioButtonWindowsAuthentication = new System.Windows.Forms.RadioButton();
            this.radioButtonSQLServerAuthentication = new System.Windows.Forms.RadioButton();
            this.textBoxUserName = new System.Windows.Forms.TextBox();
            this.textBoxPassword = new System.Windows.Forms.TextBox();
            this.labelUserName = new System.Windows.Forms.Label();
            this.labelPassword = new System.Windows.Forms.Label();
            this.groupBoxConnectionString = new System.Windows.Forms.GroupBox();
            this.buttonConnectionFromConString = new System.Windows.Forms.Button();
            this.groupBoxAuthentication = new System.Windows.Forms.GroupBox();
            this.radioButton_RiskAvert_UAT = new System.Windows.Forms.RadioButton();
            this.button_NoDbConnection = new System.Windows.Forms.Button();
            this.comboBoxDatabases_Sys = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.checkBoxAzure = new System.Windows.Forms.CheckBox();
            this.tabControlDbConnections = new System.Windows.Forms.TabControl();
            this.tabPageSqlServer = new System.Windows.Forms.TabPage();
            this.tabPageAnalysisServices = new System.Windows.Forms.TabPage();
            this.label7 = new System.Windows.Forms.Label();
            this.textBoxSaasDbLastModified = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.listViewCubes = new System.Windows.Forms.ListView();
            this.label5 = new System.Windows.Forms.Label();
            this.textBoxSaasConnectionString = new System.Windows.Forms.TextBox();
            this.buttonSaasConnect = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.textBoxSaasServerName = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.comboBoxSaasDB = new System.Windows.Forms.ComboBox();
            this.buttonSaasDbRefresh = new System.Windows.Forms.Button();
            this.radioButton_RiskAvert_Prod = new System.Windows.Forms.RadioButton();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.radioButton_DEV = new System.Windows.Forms.RadioButton();
            this.radioButton_MySQLServer = new System.Windows.Forms.RadioButton();
            this.textBox_PORT = new System.Windows.Forms.TextBox();
            this.textBox_VERSION = new System.Windows.Forms.TextBox();
            this.textBox_Last_Restart = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.groupBoxConnectionString.SuspendLayout();
            this.groupBoxAuthentication.SuspendLayout();
            this.tabControlDbConnections.SuspendLayout();
            this.tabPageSqlServer.SuspendLayout();
            this.tabPageAnalysisServices.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // labelServerName
            // 
            this.labelServerName.AutoSize = true;
            this.labelServerName.Location = new System.Drawing.Point(8, 38);
            this.labelServerName.Name = "labelServerName";
            this.labelServerName.Size = new System.Drawing.Size(70, 13);
            this.labelServerName.TabIndex = 0;
            this.labelServerName.Text = "Server name:";
            // 
            // textBoxServerName
            // 
            this.textBoxServerName.Location = new System.Drawing.Point(89, 36);
            this.textBoxServerName.Name = "textBoxServerName";
            this.textBoxServerName.Size = new System.Drawing.Size(282, 20);
            this.textBoxServerName.TabIndex = 1;
            this.textBoxServerName.TextChanged += new System.EventHandler(this.textBoxServerName_TextChanged);
            // 
            // buttonConnect
            // 
            this.buttonConnect.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.buttonConnect.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(161)));
            this.buttonConnect.Location = new System.Drawing.Point(103, 216);
            this.buttonConnect.Name = "buttonConnect";
            this.buttonConnect.Size = new System.Drawing.Size(97, 23);
            this.buttonConnect.TabIndex = 2;
            this.buttonConnect.Text = "Connect";
            this.buttonConnect.UseVisualStyleBackColor = true;
            this.buttonConnect.Click += new System.EventHandler(this.buttonConnect_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(8, 66);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(56, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Database:";
            // 
            // comboBoxDatabases
            // 
            this.comboBoxDatabases.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxDatabases.FormattingEnabled = true;
            this.comboBoxDatabases.Location = new System.Drawing.Point(89, 64);
            this.comboBoxDatabases.Margin = new System.Windows.Forms.Padding(2);
            this.comboBoxDatabases.Name = "comboBoxDatabases";
            this.comboBoxDatabases.Size = new System.Drawing.Size(181, 21);
            this.comboBoxDatabases.TabIndex = 9;
            this.comboBoxDatabases.SelectedIndexChanged += new System.EventHandler(this.comboBoxDatabases_SelectedIndexChanged);
            // 
            // buttonDBRefresh
            // 
            this.buttonDBRefresh.Location = new System.Drawing.Point(283, 62);
            this.buttonDBRefresh.Name = "buttonDBRefresh";
            this.buttonDBRefresh.Size = new System.Drawing.Size(88, 23);
            this.buttonDBRefresh.TabIndex = 10;
            this.buttonDBRefresh.Text = "DBs Refresh";
            this.buttonDBRefresh.UseVisualStyleBackColor = true;
            this.buttonDBRefresh.Click += new System.EventHandler(this.buttonDBRefresh_Click);
            // 
            // buttonTestConnection
            // 
            this.buttonTestConnection.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.buttonTestConnection.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(161)));
            this.buttonTestConnection.Location = new System.Drawing.Point(205, 216);
            this.buttonTestConnection.Name = "buttonTestConnection";
            this.buttonTestConnection.Size = new System.Drawing.Size(97, 23);
            this.buttonTestConnection.TabIndex = 11;
            this.buttonTestConnection.Text = "Test Connection";
            this.buttonTestConnection.UseVisualStyleBackColor = true;
            this.buttonTestConnection.Click += new System.EventHandler(this.buttonTestConnection_Click);
            // 
            // textBoxConnectionString
            // 
            this.textBoxConnectionString.Location = new System.Drawing.Point(15, 21);
            this.textBoxConnectionString.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxConnectionString.Multiline = true;
            this.textBoxConnectionString.Name = "textBoxConnectionString";
            this.textBoxConnectionString.Size = new System.Drawing.Size(245, 52);
            this.textBoxConnectionString.TabIndex = 12;
            // 
            // buttonTestConnectionFromConString
            // 
            this.buttonTestConnectionFromConString.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.buttonTestConnectionFromConString.Location = new System.Drawing.Point(273, 49);
            this.buttonTestConnectionFromConString.Name = "buttonTestConnectionFromConString";
            this.buttonTestConnectionFromConString.Size = new System.Drawing.Size(85, 22);
            this.buttonTestConnectionFromConString.TabIndex = 14;
            this.buttonTestConnectionFromConString.Text = "Test Connection";
            this.buttonTestConnectionFromConString.UseVisualStyleBackColor = true;
            this.buttonTestConnectionFromConString.Click += new System.EventHandler(this.buttonTestConnectionFromConString_Click);
            // 
            // radioButtonWindowsAuthentication
            // 
            this.radioButtonWindowsAuthentication.AutoSize = true;
            this.radioButtonWindowsAuthentication.Checked = true;
            this.radioButtonWindowsAuthentication.Location = new System.Drawing.Point(15, 18);
            this.radioButtonWindowsAuthentication.Margin = new System.Windows.Forms.Padding(2);
            this.radioButtonWindowsAuthentication.Name = "radioButtonWindowsAuthentication";
            this.radioButtonWindowsAuthentication.Size = new System.Drawing.Size(140, 17);
            this.radioButtonWindowsAuthentication.TabIndex = 15;
            this.radioButtonWindowsAuthentication.TabStop = true;
            this.radioButtonWindowsAuthentication.Text = "Windows Authentication";
            this.radioButtonWindowsAuthentication.UseVisualStyleBackColor = true;
            this.radioButtonWindowsAuthentication.CheckedChanged += new System.EventHandler(this.radioButtonWindowsAuthentication_CheckedChanged);
            // 
            // radioButtonSQLServerAuthentication
            // 
            this.radioButtonSQLServerAuthentication.AutoSize = true;
            this.radioButtonSQLServerAuthentication.Location = new System.Drawing.Point(15, 42);
            this.radioButtonSQLServerAuthentication.Margin = new System.Windows.Forms.Padding(2);
            this.radioButtonSQLServerAuthentication.Name = "radioButtonSQLServerAuthentication";
            this.radioButtonSQLServerAuthentication.Size = new System.Drawing.Size(151, 17);
            this.radioButtonSQLServerAuthentication.TabIndex = 16;
            this.radioButtonSQLServerAuthentication.Text = "SQL Server Authentication";
            this.radioButtonSQLServerAuthentication.UseVisualStyleBackColor = true;
            this.radioButtonSQLServerAuthentication.CheckedChanged += new System.EventHandler(this.radioButtonSQLServerAuthentication_CheckedChanged);
            // 
            // textBoxUserName
            // 
            this.textBoxUserName.Enabled = false;
            this.textBoxUserName.Location = new System.Drawing.Point(173, 42);
            this.textBoxUserName.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxUserName.Name = "textBoxUserName";
            this.textBoxUserName.Size = new System.Drawing.Size(87, 20);
            this.textBoxUserName.TabIndex = 17;
            // 
            // textBoxPassword
            // 
            this.textBoxPassword.AccessibleDescription = "";
            this.textBoxPassword.AccessibleName = "";
            this.textBoxPassword.Enabled = false;
            this.textBoxPassword.Location = new System.Drawing.Point(273, 42);
            this.textBoxPassword.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxPassword.Name = "textBoxPassword";
            this.textBoxPassword.Size = new System.Drawing.Size(87, 20);
            this.textBoxPassword.TabIndex = 18;
            this.textBoxPassword.UseSystemPasswordChar = true;
            // 
            // labelUserName
            // 
            this.labelUserName.AutoSize = true;
            this.labelUserName.Location = new System.Drawing.Point(173, 26);
            this.labelUserName.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.labelUserName.Name = "labelUserName";
            this.labelUserName.Size = new System.Drawing.Size(60, 13);
            this.labelUserName.TabIndex = 19;
            this.labelUserName.Text = "User Name";
            // 
            // labelPassword
            // 
            this.labelPassword.AutoSize = true;
            this.labelPassword.Location = new System.Drawing.Point(273, 26);
            this.labelPassword.Margin = new System.Windows.Forms.Padding(2, 0, 2, 0);
            this.labelPassword.Name = "labelPassword";
            this.labelPassword.Size = new System.Drawing.Size(53, 13);
            this.labelPassword.TabIndex = 20;
            this.labelPassword.Text = "Password";
            // 
            // groupBoxConnectionString
            // 
            this.groupBoxConnectionString.BackColor = System.Drawing.Color.Silver;
            this.groupBoxConnectionString.Controls.Add(this.buttonConnectionFromConString);
            this.groupBoxConnectionString.Controls.Add(this.buttonTestConnectionFromConString);
            this.groupBoxConnectionString.Controls.Add(this.textBoxConnectionString);
            this.groupBoxConnectionString.Location = new System.Drawing.Point(10, 275);
            this.groupBoxConnectionString.Margin = new System.Windows.Forms.Padding(2);
            this.groupBoxConnectionString.Name = "groupBoxConnectionString";
            this.groupBoxConnectionString.Padding = new System.Windows.Forms.Padding(2);
            this.groupBoxConnectionString.Size = new System.Drawing.Size(372, 88);
            this.groupBoxConnectionString.TabIndex = 21;
            this.groupBoxConnectionString.TabStop = false;
            this.groupBoxConnectionString.Text = "Connection String";
            // 
            // buttonConnectionFromConString
            // 
            this.buttonConnectionFromConString.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.buttonConnectionFromConString.Location = new System.Drawing.Point(273, 23);
            this.buttonConnectionFromConString.Name = "buttonConnectionFromConString";
            this.buttonConnectionFromConString.Size = new System.Drawing.Size(85, 22);
            this.buttonConnectionFromConString.TabIndex = 24;
            this.buttonConnectionFromConString.Text = "Connect";
            this.buttonConnectionFromConString.UseVisualStyleBackColor = true;
            this.buttonConnectionFromConString.Click += new System.EventHandler(this.buttonConnectionFromConString_Click);
            // 
            // groupBoxAuthentication
            // 
            this.groupBoxAuthentication.Controls.Add(this.labelPassword);
            this.groupBoxAuthentication.Controls.Add(this.labelUserName);
            this.groupBoxAuthentication.Controls.Add(this.textBoxPassword);
            this.groupBoxAuthentication.Controls.Add(this.textBoxUserName);
            this.groupBoxAuthentication.Controls.Add(this.radioButtonSQLServerAuthentication);
            this.groupBoxAuthentication.Controls.Add(this.radioButtonWindowsAuthentication);
            this.groupBoxAuthentication.Location = new System.Drawing.Point(10, 126);
            this.groupBoxAuthentication.Margin = new System.Windows.Forms.Padding(2);
            this.groupBoxAuthentication.Name = "groupBoxAuthentication";
            this.groupBoxAuthentication.Padding = new System.Windows.Forms.Padding(2);
            this.groupBoxAuthentication.Size = new System.Drawing.Size(372, 80);
            this.groupBoxAuthentication.TabIndex = 22;
            this.groupBoxAuthentication.TabStop = false;
            this.groupBoxAuthentication.Text = "Authentication";
            // 
            // radioButton_RiskAvert_UAT
            // 
            this.radioButton_RiskAvert_UAT.AutoSize = true;
            this.radioButton_RiskAvert_UAT.BackColor = System.Drawing.Color.Silver;
            this.radioButton_RiskAvert_UAT.Location = new System.Drawing.Point(20, 44);
            this.radioButton_RiskAvert_UAT.Name = "radioButton_RiskAvert_UAT";
            this.radioButton_RiskAvert_UAT.Size = new System.Drawing.Size(68, 17);
            this.radioButton_RiskAvert_UAT.TabIndex = 27;
            this.radioButton_RiskAvert_UAT.Text = "DBSRV2";
            this.radioButton_RiskAvert_UAT.UseVisualStyleBackColor = false;
            this.radioButton_RiskAvert_UAT.CheckedChanged += new System.EventHandler(this.radioButton_RiskAvert_UAT_CheckedChanged);
            // 
            // button_NoDbConnection
            // 
            this.button_NoDbConnection.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.button_NoDbConnection.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(161)));
            this.button_NoDbConnection.Location = new System.Drawing.Point(103, 242);
            this.button_NoDbConnection.Name = "button_NoDbConnection";
            this.button_NoDbConnection.Size = new System.Drawing.Size(200, 23);
            this.button_NoDbConnection.TabIndex = 28;
            this.button_NoDbConnection.Text = "No DB Connection";
            this.button_NoDbConnection.UseVisualStyleBackColor = true;
            this.button_NoDbConnection.Click += new System.EventHandler(this.button_NoDbConnection_Click);
            // 
            // comboBoxDatabases_Sys
            // 
            this.comboBoxDatabases_Sys.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxDatabases_Sys.FormattingEnabled = true;
            this.comboBoxDatabases_Sys.Location = new System.Drawing.Point(89, 92);
            this.comboBoxDatabases_Sys.Margin = new System.Windows.Forms.Padding(2);
            this.comboBoxDatabases_Sys.Name = "comboBoxDatabases_Sys";
            this.comboBoxDatabases_Sys.Size = new System.Drawing.Size(181, 21);
            this.comboBoxDatabases_Sys.TabIndex = 31;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(8, 94);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(78, 13);
            this.label2.TabIndex = 30;
            this.label2.Text = "Sec Database:";
            // 
            // checkBoxAzure
            // 
            this.checkBoxAzure.AutoSize = true;
            this.checkBoxAzure.Location = new System.Drawing.Point(89, 10);
            this.checkBoxAzure.Margin = new System.Windows.Forms.Padding(2);
            this.checkBoxAzure.Name = "checkBoxAzure";
            this.checkBoxAzure.Size = new System.Drawing.Size(53, 17);
            this.checkBoxAzure.TabIndex = 35;
            this.checkBoxAzure.Text = "Azure";
            this.checkBoxAzure.UseVisualStyleBackColor = true;
            this.checkBoxAzure.CheckedChanged += new System.EventHandler(this.checkBoxAzure_CheckedChanged);
            // 
            // tabControlDbConnections
            // 
            this.tabControlDbConnections.Controls.Add(this.tabPageSqlServer);
            this.tabControlDbConnections.Controls.Add(this.tabPageAnalysisServices);
            this.tabControlDbConnections.Location = new System.Drawing.Point(8, 8);
            this.tabControlDbConnections.Margin = new System.Windows.Forms.Padding(2);
            this.tabControlDbConnections.Name = "tabControlDbConnections";
            this.tabControlDbConnections.SelectedIndex = 0;
            this.tabControlDbConnections.Size = new System.Drawing.Size(405, 395);
            this.tabControlDbConnections.TabIndex = 36;
            // 
            // tabPageSqlServer
            // 
            this.tabPageSqlServer.BackColor = System.Drawing.Color.LightSteelBlue;
            this.tabPageSqlServer.Controls.Add(this.checkBoxAzure);
            this.tabPageSqlServer.Controls.Add(this.labelServerName);
            this.tabPageSqlServer.Controls.Add(this.textBoxServerName);
            this.tabPageSqlServer.Controls.Add(this.buttonConnect);
            this.tabPageSqlServer.Controls.Add(this.label1);
            this.tabPageSqlServer.Controls.Add(this.comboBoxDatabases_Sys);
            this.tabPageSqlServer.Controls.Add(this.comboBoxDatabases);
            this.tabPageSqlServer.Controls.Add(this.label2);
            this.tabPageSqlServer.Controls.Add(this.buttonDBRefresh);
            this.tabPageSqlServer.Controls.Add(this.groupBoxConnectionString);
            this.tabPageSqlServer.Controls.Add(this.buttonTestConnection);
            this.tabPageSqlServer.Controls.Add(this.button_NoDbConnection);
            this.tabPageSqlServer.Controls.Add(this.groupBoxAuthentication);
            this.tabPageSqlServer.Location = new System.Drawing.Point(4, 22);
            this.tabPageSqlServer.Margin = new System.Windows.Forms.Padding(2);
            this.tabPageSqlServer.Name = "tabPageSqlServer";
            this.tabPageSqlServer.Padding = new System.Windows.Forms.Padding(2);
            this.tabPageSqlServer.Size = new System.Drawing.Size(397, 369);
            this.tabPageSqlServer.TabIndex = 0;
            this.tabPageSqlServer.Tag = "1";
            this.tabPageSqlServer.Text = "Sql Server";
            // 
            // tabPageAnalysisServices
            // 
            this.tabPageAnalysisServices.BackColor = System.Drawing.Color.DarkKhaki;
            this.tabPageAnalysisServices.Controls.Add(this.label7);
            this.tabPageAnalysisServices.Controls.Add(this.textBoxSaasDbLastModified);
            this.tabPageAnalysisServices.Controls.Add(this.label6);
            this.tabPageAnalysisServices.Controls.Add(this.listViewCubes);
            this.tabPageAnalysisServices.Controls.Add(this.label5);
            this.tabPageAnalysisServices.Controls.Add(this.textBoxSaasConnectionString);
            this.tabPageAnalysisServices.Controls.Add(this.buttonSaasConnect);
            this.tabPageAnalysisServices.Controls.Add(this.label3);
            this.tabPageAnalysisServices.Controls.Add(this.textBoxSaasServerName);
            this.tabPageAnalysisServices.Controls.Add(this.label4);
            this.tabPageAnalysisServices.Controls.Add(this.comboBoxSaasDB);
            this.tabPageAnalysisServices.Controls.Add(this.buttonSaasDbRefresh);
            this.tabPageAnalysisServices.Location = new System.Drawing.Point(4, 22);
            this.tabPageAnalysisServices.Margin = new System.Windows.Forms.Padding(2);
            this.tabPageAnalysisServices.Name = "tabPageAnalysisServices";
            this.tabPageAnalysisServices.Padding = new System.Windows.Forms.Padding(2);
            this.tabPageAnalysisServices.Size = new System.Drawing.Size(397, 369);
            this.tabPageAnalysisServices.TabIndex = 1;
            this.tabPageAnalysisServices.Tag = "2";
            this.tabPageAnalysisServices.Text = "Analysis Services";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(243, 36);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(73, 13);
            this.label7.TabIndex = 54;
            this.label7.Text = "Last Modified:";
            // 
            // textBoxSaasDbLastModified
            // 
            this.textBoxSaasDbLastModified.Enabled = false;
            this.textBoxSaasDbLastModified.Location = new System.Drawing.Point(242, 51);
            this.textBoxSaasDbLastModified.Name = "textBoxSaasDbLastModified";
            this.textBoxSaasDbLastModified.Size = new System.Drawing.Size(133, 20);
            this.textBoxSaasDbLastModified.TabIndex = 53;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(12, 179);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(103, 13);
            this.label6.TabIndex = 52;
            this.label6.Text = "Dimensions && Cubes";
            // 
            // listViewCubes
            // 
            this.listViewCubes.BackColor = System.Drawing.Color.WhiteSmoke;
            this.listViewCubes.HideSelection = false;
            this.listViewCubes.Location = new System.Drawing.Point(15, 196);
            this.listViewCubes.MultiSelect = false;
            this.listViewCubes.Name = "listViewCubes";
            this.listViewCubes.Size = new System.Drawing.Size(361, 165);
            this.listViewCubes.TabIndex = 48;
            this.listViewCubes.UseCompatibleStateImageBehavior = false;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(12, 109);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(94, 13);
            this.label5.TabIndex = 18;
            this.label5.Text = "Connection String:";
            // 
            // textBoxSaasConnectionString
            // 
            this.textBoxSaasConnectionString.Location = new System.Drawing.Point(15, 127);
            this.textBoxSaasConnectionString.Margin = new System.Windows.Forms.Padding(2);
            this.textBoxSaasConnectionString.Multiline = true;
            this.textBoxSaasConnectionString.Name = "textBoxSaasConnectionString";
            this.textBoxSaasConnectionString.Size = new System.Drawing.Size(361, 46);
            this.textBoxSaasConnectionString.TabIndex = 17;
            // 
            // buttonSaasConnect
            // 
            this.buttonSaasConnect.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.buttonSaasConnect.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(161)));
            this.buttonSaasConnect.Location = new System.Drawing.Point(15, 83);
            this.buttonSaasConnect.Name = "buttonSaasConnect";
            this.buttonSaasConnect.Size = new System.Drawing.Size(359, 22);
            this.buttonSaasConnect.TabIndex = 16;
            this.buttonSaasConnect.Text = "Connect";
            this.buttonSaasConnect.UseVisualStyleBackColor = true;
            this.buttonSaasConnect.Click += new System.EventHandler(this.buttonSaasConnect_Click);
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 13);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(70, 13);
            this.label3.TabIndex = 11;
            this.label3.Text = "Server name:";
            // 
            // textBoxSaasServerName
            // 
            this.textBoxSaasServerName.Location = new System.Drawing.Point(93, 9);
            this.textBoxSaasServerName.Name = "textBoxSaasServerName";
            this.textBoxSaasServerName.Size = new System.Drawing.Size(145, 20);
            this.textBoxSaasServerName.TabIndex = 12;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(90, 36);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(56, 13);
            this.label4.TabIndex = 13;
            this.label4.Text = "Database:";
            // 
            // comboBoxSaasDB
            // 
            this.comboBoxSaasDB.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxSaasDB.FormattingEnabled = true;
            this.comboBoxSaasDB.Location = new System.Drawing.Point(93, 51);
            this.comboBoxSaasDB.Margin = new System.Windows.Forms.Padding(2);
            this.comboBoxSaasDB.Name = "comboBoxSaasDB";
            this.comboBoxSaasDB.Size = new System.Drawing.Size(145, 21);
            this.comboBoxSaasDB.TabIndex = 14;
            this.comboBoxSaasDB.SelectedIndexChanged += new System.EventHandler(this.comboBoxSaasDB_SelectedIndexChanged);
            // 
            // buttonSaasDbRefresh
            // 
            this.buttonSaasDbRefresh.Location = new System.Drawing.Point(242, 8);
            this.buttonSaasDbRefresh.Name = "buttonSaasDbRefresh";
            this.buttonSaasDbRefresh.Size = new System.Drawing.Size(133, 22);
            this.buttonSaasDbRefresh.TabIndex = 15;
            this.buttonSaasDbRefresh.Text = "DBs Refresh";
            this.buttonSaasDbRefresh.UseVisualStyleBackColor = true;
            this.buttonSaasDbRefresh.Click += new System.EventHandler(this.buttonSaasDbRefresh_Click);
            // 
            // radioButton_RiskAvert_Prod
            // 
            this.radioButton_RiskAvert_Prod.AutoSize = true;
            this.radioButton_RiskAvert_Prod.BackColor = System.Drawing.Color.Silver;
            this.radioButton_RiskAvert_Prod.Location = new System.Drawing.Point(20, 23);
            this.radioButton_RiskAvert_Prod.Name = "radioButton_RiskAvert_Prod";
            this.radioButton_RiskAvert_Prod.Size = new System.Drawing.Size(68, 17);
            this.radioButton_RiskAvert_Prod.TabIndex = 37;
            this.radioButton_RiskAvert_Prod.Text = "DBSRV1";
            this.radioButton_RiskAvert_Prod.UseVisualStyleBackColor = false;
            this.radioButton_RiskAvert_Prod.CheckedChanged += new System.EventHandler(this.radioButton_RiskAvert_Prod_CheckedChanged);
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.radioButton_DEV);
            this.groupBox1.Controls.Add(this.radioButton_MySQLServer);
            this.groupBox1.Controls.Add(this.radioButton_RiskAvert_Prod);
            this.groupBox1.Controls.Add(this.radioButton_RiskAvert_UAT);
            this.groupBox1.Location = new System.Drawing.Point(416, 26);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(110, 111);
            this.groupBox1.TabIndex = 38;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "SQL Connections";
            // 
            // radioButton_DEV
            // 
            this.radioButton_DEV.AutoSize = true;
            this.radioButton_DEV.BackColor = System.Drawing.Color.Silver;
            this.radioButton_DEV.Location = new System.Drawing.Point(20, 65);
            this.radioButton_DEV.Name = "radioButton_DEV";
            this.radioButton_DEV.Size = new System.Drawing.Size(80, 17);
            this.radioButton_DEV.TabIndex = 39;
            this.radioButton_DEV.Text = "MAINTDB2";
            this.radioButton_DEV.UseVisualStyleBackColor = false;
            this.radioButton_DEV.CheckedChanged += new System.EventHandler(this.radioButton_DEV_CheckedChanged);
            // 
            // radioButton_MySQLServer
            // 
            this.radioButton_MySQLServer.AutoSize = true;
            this.radioButton_MySQLServer.BackColor = System.Drawing.Color.Silver;
            this.radioButton_MySQLServer.Location = new System.Drawing.Point(20, 87);
            this.radioButton_MySQLServer.Name = "radioButton_MySQLServer";
            this.radioButton_MySQLServer.Size = new System.Drawing.Size(59, 17);
            this.radioButton_MySQLServer.TabIndex = 38;
            this.radioButton_MySQLServer.Text = "LOCAL";
            this.radioButton_MySQLServer.UseVisualStyleBackColor = false;
            this.radioButton_MySQLServer.CheckedChanged += new System.EventHandler(this.radioButton_MySQLServer_CheckedChanged);
            // 
            // textBox_PORT
            // 
            this.textBox_PORT.BackColor = System.Drawing.Color.Gainsboro;
            this.textBox_PORT.Location = new System.Drawing.Point(417, 171);
            this.textBox_PORT.Name = "textBox_PORT";
            this.textBox_PORT.Size = new System.Drawing.Size(109, 20);
            this.textBox_PORT.TabIndex = 39;
            // 
            // textBox_VERSION
            // 
            this.textBox_VERSION.BackColor = System.Drawing.Color.Gainsboro;
            this.textBox_VERSION.Location = new System.Drawing.Point(417, 212);
            this.textBox_VERSION.Name = "textBox_VERSION";
            this.textBox_VERSION.Size = new System.Drawing.Size(109, 20);
            this.textBox_VERSION.TabIndex = 40;
            // 
            // textBox_Last_Restart
            // 
            this.textBox_Last_Restart.BackColor = System.Drawing.Color.Gainsboro;
            this.textBox_Last_Restart.Location = new System.Drawing.Point(417, 253);
            this.textBox_Last_Restart.Name = "textBox_Last_Restart";
            this.textBox_Last_Restart.Size = new System.Drawing.Size(109, 20);
            this.textBox_Last_Restart.TabIndex = 41;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(419, 156);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(26, 13);
            this.label8.TabIndex = 42;
            this.label8.Text = "Port";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(419, 197);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(42, 13);
            this.label9.TabIndex = 43;
            this.label9.Text = "Version";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(419, 238);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(52, 13);
            this.label10.TabIndex = 44;
            this.label10.Text = "Last Start";
            // 
            // FormDBConnection
            // 
            this.AcceptButton = this.buttonConnect;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.WhiteSmoke;
            this.ClientSize = new System.Drawing.Size(533, 407);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.textBox_Last_Restart);
            this.Controls.Add(this.textBox_VERSION);
            this.Controls.Add(this.textBox_PORT);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.tabControlDbConnections);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FormDBConnection";
            this.ShowIcon = false;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "GK Tool v. 11-Apr-2023 - SQL Server Connection";
            this.Load += new System.EventHandler(this.FormDBConnection_Load);
            this.groupBoxConnectionString.ResumeLayout(false);
            this.groupBoxConnectionString.PerformLayout();
            this.groupBoxAuthentication.ResumeLayout(false);
            this.groupBoxAuthentication.PerformLayout();
            this.tabControlDbConnections.ResumeLayout(false);
            this.tabPageSqlServer.ResumeLayout(false);
            this.tabPageSqlServer.PerformLayout();
            this.tabPageAnalysisServices.ResumeLayout(false);
            this.tabPageAnalysisServices.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelServerName;
        private System.Windows.Forms.TextBox textBoxServerName;
        private System.Windows.Forms.Button buttonConnect;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox comboBoxDatabases;
        private System.Windows.Forms.Button buttonDBRefresh;
        private System.Windows.Forms.Button buttonTestConnection;
        private System.Windows.Forms.TextBox textBoxConnectionString;
        private System.Windows.Forms.Button buttonTestConnectionFromConString;
        private System.Windows.Forms.RadioButton radioButtonWindowsAuthentication;
        private System.Windows.Forms.RadioButton radioButtonSQLServerAuthentication;
        private System.Windows.Forms.TextBox textBoxUserName;
        private System.Windows.Forms.TextBox textBoxPassword;
        private System.Windows.Forms.Label labelUserName;
        private System.Windows.Forms.Label labelPassword;
        private System.Windows.Forms.GroupBox groupBoxConnectionString;
        private System.Windows.Forms.GroupBox groupBoxAuthentication;
        private System.Windows.Forms.Button buttonConnectionFromConString;
        private System.Windows.Forms.RadioButton radioButton_RiskAvert_UAT;
        private System.Windows.Forms.Button button_NoDbConnection;
        private System.Windows.Forms.ComboBox comboBoxDatabases_Sys;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox checkBoxAzure;
        private System.Windows.Forms.TabControl tabControlDbConnections;
        private System.Windows.Forms.TabPage tabPageSqlServer;
        private System.Windows.Forms.TabPage tabPageAnalysisServices;
        private System.Windows.Forms.Button buttonSaasConnect;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox textBoxSaasServerName;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox comboBoxSaasDB;
        private System.Windows.Forms.Button buttonSaasDbRefresh;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox textBoxSaasConnectionString;
        private System.Windows.Forms.ListView listViewCubes;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox textBoxSaasDbLastModified;
        private System.Windows.Forms.RadioButton radioButton_RiskAvert_Prod;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.RadioButton radioButton_MySQLServer;
        private System.Windows.Forms.RadioButton radioButton_DEV;
        private System.Windows.Forms.TextBox textBox_PORT;
        private System.Windows.Forms.TextBox textBox_VERSION;
        private System.Windows.Forms.TextBox textBox_Last_Restart;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label10;
    }
}

