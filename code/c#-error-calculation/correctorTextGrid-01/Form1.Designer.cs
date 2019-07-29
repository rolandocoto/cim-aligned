namespace correctorTextGrid_01
{
    partial class Form1
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.txt_textGrid = new System.Windows.Forms.TextBox();
            this.btn_fileTextGrid = new System.Windows.Forms.Button();
            this.btn_convert = new System.Windows.Forms.Button();
            this.btn_fileDict = new System.Windows.Forms.Button();
            this.txt_dict = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.openFileTextGrid = new System.Windows.Forms.OpenFileDialog();
            this.openFileDict = new System.Windows.Forms.OpenFileDialog();
            this.saveTextGrid = new System.Windows.Forms.SaveFileDialog();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.label4 = new System.Windows.Forms.Label();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.btn_openHandCorrectedTextGrid = new System.Windows.Forms.Button();
            this.btn_openUncorrectedTextGrid = new System.Windows.Forms.Button();
            this.btn_RMSCalc = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.txt_TextGridUncorrected = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.txt_textGridHandCorrected = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.SuspendLayout();
            // 
            // txt_textGrid
            // 
            this.txt_textGrid.Location = new System.Drawing.Point(9, 102);
            this.txt_textGrid.Name = "txt_textGrid";
            this.txt_textGrid.Size = new System.Drawing.Size(578, 20);
            this.txt_textGrid.TabIndex = 0;
            this.txt_textGrid.TextChanged += new System.EventHandler(this.txt_textGrid_TextChanged);
            // 
            // btn_fileTextGrid
            // 
            this.btn_fileTextGrid.Location = new System.Drawing.Point(600, 96);
            this.btn_fileTextGrid.Name = "btn_fileTextGrid";
            this.btn_fileTextGrid.Size = new System.Drawing.Size(100, 30);
            this.btn_fileTextGrid.TabIndex = 1;
            this.btn_fileTextGrid.Text = "Abrir";
            this.btn_fileTextGrid.UseVisualStyleBackColor = true;
            this.btn_fileTextGrid.Click += new System.EventHandler(this.btn_fileTextGrid_Click);
            // 
            // btn_convert
            // 
            this.btn_convert.Location = new System.Drawing.Point(9, 187);
            this.btn_convert.Name = "btn_convert";
            this.btn_convert.Size = new System.Drawing.Size(105, 39);
            this.btn_convert.TabIndex = 2;
            this.btn_convert.Text = "Convertir";
            this.btn_convert.UseVisualStyleBackColor = true;
            this.btn_convert.Click += new System.EventHandler(this.btn_convert_Click);
            // 
            // btn_fileDict
            // 
            this.btn_fileDict.Location = new System.Drawing.Point(600, 146);
            this.btn_fileDict.Name = "btn_fileDict";
            this.btn_fileDict.Size = new System.Drawing.Size(100, 30);
            this.btn_fileDict.TabIndex = 4;
            this.btn_fileDict.Text = "Abrir";
            this.btn_fileDict.UseVisualStyleBackColor = true;
            this.btn_fileDict.Click += new System.EventHandler(this.btn_fileDict_Click);
            // 
            // txt_dict
            // 
            this.txt_dict.Location = new System.Drawing.Point(9, 152);
            this.txt_dict.Name = "txt_dict";
            this.txt_dict.Size = new System.Drawing.Size(578, 20);
            this.txt_dict.TabIndex = 3;
            this.txt_dict.TextChanged += new System.EventHandler(this.txt_dict_TextChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 86);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(47, 13);
            this.label1.TabIndex = 5;
            this.label1.Text = "TextGrid";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 136);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(143, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Diccionario de tres columnas";
            this.label2.Click += new System.EventHandler(this.label2_Click);
            // 
            // openFileTextGrid
            // 
            this.openFileTextGrid.FileName = "openFileDialog1";
            // 
            // openFileDict
            // 
            this.openFileDict.FileName = "openFileDialog1";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(15, 13);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(714, 271);
            this.tabControl1.TabIndex = 9;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Controls.Add(this.txt_textGrid);
            this.tabPage1.Controls.Add(this.btn_fileTextGrid);
            this.tabPage1.Controls.Add(this.btn_convert);
            this.tabPage1.Controls.Add(this.btn_fileDict);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.txt_dict);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(706, 245);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Cambiar Arpabet en un TextGrid";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(3, 12);
            this.label4.MaximumSize = new System.Drawing.Size(578, 68);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(569, 52);
            this.label4.TabIndex = 9;
            this.label4.Text = resources.GetString("label4.Text");
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.btn_openHandCorrectedTextGrid);
            this.tabPage2.Controls.Add(this.btn_openUncorrectedTextGrid);
            this.tabPage2.Controls.Add(this.btn_RMSCalc);
            this.tabPage2.Controls.Add(this.label5);
            this.tabPage2.Controls.Add(this.txt_TextGridUncorrected);
            this.tabPage2.Controls.Add(this.label6);
            this.tabPage2.Controls.Add(this.txt_textGridHandCorrected);
            this.tabPage2.Controls.Add(this.label3);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(706, 245);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Calcular RMS";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // btn_openHandCorrectedTextGrid
            // 
            this.btn_openHandCorrectedTextGrid.Location = new System.Drawing.Point(600, 140);
            this.btn_openHandCorrectedTextGrid.Name = "btn_openHandCorrectedTextGrid";
            this.btn_openHandCorrectedTextGrid.Size = new System.Drawing.Size(100, 30);
            this.btn_openHandCorrectedTextGrid.TabIndex = 17;
            this.btn_openHandCorrectedTextGrid.Text = "Abrir";
            this.btn_openHandCorrectedTextGrid.UseVisualStyleBackColor = true;
            this.btn_openHandCorrectedTextGrid.Click += new System.EventHandler(this.btn_openHandCorrectedTextGrid_Click);
            // 
            // btn_openUncorrectedTextGrid
            // 
            this.btn_openUncorrectedTextGrid.Location = new System.Drawing.Point(600, 90);
            this.btn_openUncorrectedTextGrid.Name = "btn_openUncorrectedTextGrid";
            this.btn_openUncorrectedTextGrid.Size = new System.Drawing.Size(100, 30);
            this.btn_openUncorrectedTextGrid.TabIndex = 16;
            this.btn_openUncorrectedTextGrid.Text = "Abrir";
            this.btn_openUncorrectedTextGrid.UseVisualStyleBackColor = true;
            this.btn_openUncorrectedTextGrid.Click += new System.EventHandler(this.btn_openUncorrectedTextGrid_Click);
            // 
            // btn_RMSCalc
            // 
            this.btn_RMSCalc.Location = new System.Drawing.Point(9, 189);
            this.btn_RMSCalc.Name = "btn_RMSCalc";
            this.btn_RMSCalc.Size = new System.Drawing.Size(207, 35);
            this.btn_RMSCalc.TabIndex = 15;
            this.btn_RMSCalc.Text = "Calcular diferencias entre los datagrids";
            this.btn_RMSCalc.UseVisualStyleBackColor = true;
            this.btn_RMSCalc.Click += new System.EventHandler(this.btn_RMSCalc_Click);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(6, 80);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(236, 13);
            this.label5.TabIndex = 13;
            this.label5.Text = "TextGrid generado automáticamente, sin corregir";
            // 
            // txt_TextGridUncorrected
            // 
            this.txt_TextGridUncorrected.Location = new System.Drawing.Point(9, 96);
            this.txt_TextGridUncorrected.Name = "txt_TextGridUncorrected";
            this.txt_TextGridUncorrected.Size = new System.Drawing.Size(574, 20);
            this.txt_TextGridUncorrected.TabIndex = 11;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(6, 130);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(132, 13);
            this.label6.TabIndex = 14;
            this.label6.Text = "TextGrid corregido a mano";
            // 
            // txt_textGridHandCorrected
            // 
            this.txt_textGridHandCorrected.Location = new System.Drawing.Point(9, 146);
            this.txt_textGridHandCorrected.Name = "txt_textGridHandCorrected";
            this.txt_textGridHandCorrected.Size = new System.Drawing.Size(574, 20);
            this.txt_textGridHandCorrected.TabIndex = 12;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(3, 12);
            this.label3.MaximumSize = new System.Drawing.Size(578, 68);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(575, 52);
            this.label3.TabIndex = 10;
            this.label3.Text = resources.GetString("label3.Text");
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(608, 287);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(117, 13);
            this.label7.TabIndex = 10;
            this.label7.Text = "Versión: β02 20151004";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(741, 304);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.tabControl1);
            this.Name = "Form1";
            this.Text = "Manipular TextGrids";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txt_textGrid;
        private System.Windows.Forms.Button btn_fileTextGrid;
        private System.Windows.Forms.Button btn_convert;
        private System.Windows.Forms.Button btn_fileDict;
        private System.Windows.Forms.TextBox txt_dict;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.OpenFileDialog openFileTextGrid;
        private System.Windows.Forms.OpenFileDialog openFileDict;
        private System.Windows.Forms.SaveFileDialog saveTextGrid;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btn_openHandCorrectedTextGrid;
        private System.Windows.Forms.Button btn_openUncorrectedTextGrid;
        private System.Windows.Forms.Button btn_RMSCalc;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txt_TextGridUncorrected;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox txt_textGridHandCorrected;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label7;
    }
}

