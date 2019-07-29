using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace correctorTextGrid_01
{



    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

            //this.lst_langs.SelectedIndex = 0;

        }

        private void btn_fileTextGrid_Click(object sender, EventArgs e)
        {

            openFileTextGrid.Filter = "TextGrids (*.TextGrid)|*.TextGrid|Todos los archivos (*.*)|*.*";
            DialogResult result = openFileTextGrid.ShowDialog();

            if (result == DialogResult.OK)
            {

                txt_textGrid.Text = openFileTextGrid.FileName;

            }
        }

        private string calculateRMS( interval[] uncorrected, interval[] corrected, string tagType, string tagTypeNum ) {

            

            string outputLine = "";

            double[] diffStartPhonemes = new double[uncorrected.Length];
            double[] rmsDiffStartPhonemes = new double[uncorrected.Length];
            double[] diffEndPhonemes = new double[uncorrected.Length];
            double[] rmsDiffEndPhonemes = new double[uncorrected.Length];

            double tempDiffStart = 0;
            double tempRMSDiffStart = 0;
            double tempDiffEnd = 0;
            double tempRMSDiffEnd = 0;

            double uncorrLen = 0;
            double corrLen = 0;
            double diffLen = 0;
            double RMSdiffLen = 0;

            Console.WriteLine("comencé a calcular un RMS");
            Console.WriteLine(uncorrected.Length.ToString());
            Console.WriteLine(corrected.Length.ToString());

            for (int i = 0; i < uncorrected.Length; i++) {

                Console.WriteLine(uncorrected[i].text);

                if (uncorrected[i].text.Equals("sp") == false) {

                    tempDiffStart = corrected[i].xmin - uncorrected[i].xmin;
                    tempRMSDiffStart = Math.Sqrt(Math.Pow(tempDiffStart, 2));
                    diffStartPhonemes[i] = tempDiffStart;
                    rmsDiffStartPhonemes[i] = tempRMSDiffStart;

                    tempDiffEnd = corrected[i].xmax - uncorrected[i].xmax;
                    tempRMSDiffEnd = Math.Sqrt(Math.Pow(tempDiffEnd, 2));
                    diffEndPhonemes[i] = tempDiffEnd;
                    rmsDiffEndPhonemes[i] = tempRMSDiffEnd;

                    uncorrLen = uncorrected[i].xmax - uncorrected[i].xmin;
                    corrLen = corrected[i].xmax - corrected[i].xmin;
                    diffLen = uncorrLen - corrLen;
                    RMSdiffLen = Math.Sqrt(Math.Pow(diffLen, 2));

                    outputLine += uncorrected[i].text + "\t";
                    outputLine += tagType + "\t";
                    outputLine += tagTypeNum + "\t";
                    outputLine += (i+1).ToString() + "\t";

                    outputLine += uncorrected[i].xmin.ToString() + "\t";
                    outputLine += corrected[i].xmin.ToString() + "\t";
                    outputLine += tempDiffStart.ToString() + "\t";
                    outputLine += tempRMSDiffStart.ToString() + "\t";
                    outputLine += tempRMSDiffStart / uncorrLen + "\t";

                    outputLine += uncorrected[i].xmax.ToString() + "\t";
                    outputLine += corrected[i].xmax.ToString() + "\t";
                    outputLine += tempDiffEnd.ToString() + "\t";
                    outputLine += tempRMSDiffEnd.ToString() + "\t";
                    outputLine += tempRMSDiffEnd / uncorrLen + "\t";

                    outputLine += uncorrLen.ToString() + "\t";
                    outputLine += corrLen.ToString() + "\t";

                    outputLine += diffLen.ToString() + "\t";
                    outputLine += RMSdiffLen.ToString() + "\t";
                    outputLine += RMSdiffLen / uncorrLen + "\r\n";

                }
            }

            Console.WriteLine("ya terminé de calcular uno de los RMS");

            return outputLine;

        }

        private string processRMS(string uncorrectedGrid, string correctedGrid) {

            Console.WriteLine("entré a procesar RMS");

            string res = "";
            int iterador = 0;
            string intervalString = "intervals: size = ";

            string text = File.ReadAllText(uncorrectedGrid);
            string[] lines = text.Split('\n');

            //------------------------------------------------------------
            // Voy a construir dos listas, una que contenga
            // la información de los intervalos que contienen fonemas,
            // y otra que contenga la información de los intervalos
            // que contienen palabras
            //------------------------------------------------------------

            while (lines[iterador].Contains(intervalString) == false) {
                iterador++;
            }

            Console.WriteLine("voy a ver cuántos fonos hay en el textgrid");

            // Ver cuántos fonos hay en el textGrid
            string stringNumberGridsInFirstRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            int numberGridsInFirstRow = Convert.ToInt16(stringNumberGridsInFirstRow);

            // Construir la lista de intervalos para los fonemas
            interval[] uncorrectedPhonemes = new interval[numberGridsInFirstRow];
            iterador = iterador + 1;
            uncorrectedPhonemes = readTextGridIntervals(lines, iterador, numberGridsInFirstRow);

            // Construir la lista de intervalos para las palabras
            iterador = iterador + numberGridsInFirstRow * 4;
            while (lines[iterador].Contains(intervalString) == false) {
                iterador++;
            }

            // Ver cuántos fonos hay en el textGrid
            string stringNumberGridsInSecondRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            int numberGridsInSecondRow = Convert.ToInt16(stringNumberGridsInSecondRow);

            // Leer el TextGrid para extraer las palabras
            interval[] uncorrectedWords = new interval[numberGridsInSecondRow];
            iterador = iterador + 1;
            uncorrectedWords = readTextGridIntervals(lines, iterador, numberGridsInSecondRow);

            //------------------------------------------------------------
            // Leer la lista de palabras corregidas
            //------------------------------------------------------------

            iterador = 0;
            text = File.ReadAllText(correctedGrid);
            lines = text.Split('\n');

            while (lines[iterador].Contains(intervalString) == false) {
                iterador++;
            }

            // Ver cuántos fonos hay en el textGrid
            stringNumberGridsInFirstRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            numberGridsInFirstRow = Convert.ToInt16(stringNumberGridsInFirstRow);

            // Construir la lista de intervalos para los fonemas
            interval[] correctedPhonemes = new interval[numberGridsInFirstRow];
            iterador = iterador + 1;
            correctedPhonemes = readTextGridIntervals(lines, iterador, numberGridsInFirstRow);

            // Construir la lista de intervalos para las palabras
            iterador = iterador + numberGridsInFirstRow * 4;
            while (lines[iterador].Contains(intervalString) == false) {
                iterador++;
            }

            // Ver cuántos fonos hay en el textGrid
            stringNumberGridsInSecondRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            numberGridsInSecondRow = Convert.ToInt16(stringNumberGridsInSecondRow);

            // Leer el TextGrid para extraer las palabras
            interval[] correctedWords = new interval[numberGridsInSecondRow];
            iterador = iterador + 1;
            correctedWords = readTextGridIntervals(lines, iterador, numberGridsInSecondRow);

            if (uncorrectedPhonemes.Length == correctedPhonemes.Length && uncorrectedWords.Length == correctedWords.Length) {

                Console.WriteLine("todos los vectores son del mismo tamaño");

                string header = "";
                header += "textoIntervalo\t";
                header += "tipoIntervalo\t";
                header += "tipoIntervaloNum\t";
                header += "numIntervalo\t";
                header += "inicioAuto\t";
                header += "inicioCorr\t";
                header += "difInicio\t";
                header += "difInicioRMS\t";
                header += "difInicioPorciento\t";

                header += "finalAuto\t";
                header += "finalCorr\t";
                header += "difFinal\t";
                header += "difFinalRMS\t";
                header += "difFinalPorciento\t";

                header += "tamañoAuto\t";
                header += "tamañoCorr\t";

                header += "difTamaño\t";
                header += "difTamañoRMS\t";
                header += "difTamañoPorciento\r\n";

                res += header;
                res += calculateRMS(uncorrectedPhonemes, correctedPhonemes, "fonema", "1");
                res += calculateRMS(uncorrectedWords, correctedWords, "palabra", "2");

            }
            else {
                MessageBox.Show("Los dos TextGrids no tienen el mismo contenido. No se puede calcular la comparación.");
            }

            return res;

        }

        private void btn_fileDict_Click(object sender, EventArgs e)
        {
            openFileDict.Filter = "Archivos de texto (*.txt)|*.txt|Todos los archivos (*.*)|*.*";
            DialogResult result = openFileDict.ShowDialog();

            if (result == DialogResult.OK)
            {

                txt_dict.Text = openFileDict.FileName;

            }
        }

        private void btn_convert_Click(object sender, EventArgs e)
        {

            if (txt_textGrid.Text.Equals("") || txt_dict.Text.Equals("") == true)
            {

                MessageBox.Show("Por favor seleccione un TextGrid y un archivo diccionario de TRES columnas para continuar");

            }
            else
            {

                string output = convertDataGrid(txt_textGrid.Text, txt_dict.Text);

                string nameOutputFile = Path.GetFileNameWithoutExtension(txt_textGrid.Text);
                nameOutputFile += "-convertido.TextGrid";

                saveTextGrid.FileName = nameOutputFile;
                saveTextGrid.InitialDirectory = Path.GetDirectoryName(txt_textGrid.Text);

                DialogResult result = saveTextGrid.ShowDialog();

                if (saveTextGrid.FileName != "" && result == DialogResult.OK)
                {
                    File.WriteAllText(saveTextGrid.FileName, output);
                    MessageBox.Show("Archivo guardado");
                }

            }

        }

        private interval[] readTextGridIntervals(string[] lines, int iterador, int numberGrids)
        {

            interval[] res = new interval[numberGrids];
            double xmin = 0;
            double xmax = 0;

            string xminString = "xmin = ";
            string xmaxString = "xmax = ";
            string intervalTextString = "text = \"";

            string intervalText = "";

            for (int i = 0; i < numberGrids; i++) {

                xmin = Convert.ToDouble((lines[iterador + ((i * 4) + 1)].Substring((lines[iterador + ((i * 4) + 1)].IndexOf(xminString) + xminString.Length)).Replace('.', ',')));
                xmax = Convert.ToDouble((lines[iterador + ((i * 4) + 2)].Substring((lines[iterador + ((i * 4) + 2)].IndexOf(xmaxString) + xmaxString.Length)).Replace('.', ',')));

                intervalText = lines[iterador + ((i * 4) + 3)].Substring((lines[iterador + ((i * 4) + 3)].IndexOf(intervalTextString) + intervalTextString.Length));
                intervalText = intervalText.Substring(0, intervalText.Length - 1);

                res[i] = new interval(xmin, xmax, intervalText);

            }

            return res;

        }

        private string convertDataGrid(string fileTextGrid, string fileDictionary)
        {

            string res = "";
            int iterador = 0;
            string intervalString = "intervals: size = ";

            string textGridPhonemesHeader = "";
            string textGridWordsHeader = "";

            // Codificaciones: https://msdn.microsoft.com/en-us/library/windows/desktop/dd317756(v=vs.85).aspx
            int fileEncodingDictionary = 1252;

            string text = File.ReadAllText(fileTextGrid);
            string[] lines = text.Split('\n');

            //------------------------------------------------------------
            // Primero, voy a construir el diccionario. Este contiene
            // las palabras en ortografía normal, en arpabet, y en 
            // los fonos que queremos en el textGrid
            //------------------------------------------------------------

            string dictText = File.ReadAllText(fileDictionary, Encoding.GetEncoding(fileEncodingDictionary));
            string[] dictLines = dictText.Split('\n');
            string[] dictTabElements;
            dictWord[] dictionary = new dictWord[dictLines.Length];

            for (int i = 0; i < dictLines.Length; i++)
            {
                dictTabElements = dictLines[i].Split('\t');
                dictionary[i] = new dictWord(dictTabElements[0], dictTabElements[1], dictTabElements[2].Trim('\n', '\r'));
            }

            //------------------------------------------------------------
            // Luego, voy a construir dos listas, una que contenga
            // la información de los intervalos que contienen fonemas,
            // y otra que contenga la información de los intervalos
            // que contienen palabras
            //------------------------------------------------------------

            while (lines[iterador].Contains(intervalString) == false)
            {
                textGridPhonemesHeader += lines[iterador] + "\n";
                iterador++;
            }
            textGridPhonemesHeader += lines[iterador] + "\n";

            // Ver cuántos fonos hay en el textGrid
            //Console.WriteLine(lines[iterador]);
            string stringNumberGridsInFirstRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            int numberGridsInFirstRow = Convert.ToInt16(stringNumberGridsInFirstRow);

            // Construir la lista de intervalos para los fonemas
            interval[] phonemes = new interval[numberGridsInFirstRow];
            iterador = iterador + 1;
            phonemes = readTextGridIntervals(lines, iterador, numberGridsInFirstRow);
            Console.WriteLine(phonemes.Length.ToString());

            // Construir la lista de intervalos para las palabras

            // Encontrar la línea que marca el inicio de los intervalos
            // que contienen las palabras

            iterador = iterador + numberGridsInFirstRow * 4;

            while (lines[iterador].Contains(intervalString) == false)
            {
                //Console.WriteLine(iterador.ToString());
                textGridWordsHeader += lines[iterador] + "\n";
                iterador++;
            }
            textGridWordsHeader += lines[iterador] + "\n";

            // Ver cuántos fonos hay en el textGrid
            //Console.WriteLine(lines[iterador]);
            string stringNumberGridsInSecondRow = lines[iterador].Substring((lines[iterador].IndexOf(intervalString) + intervalString.Length));
            int numberGridsInSecondRow = Convert.ToInt16(stringNumberGridsInSecondRow);

            // Leer el TextGrid para extraer las palabras
            interval[] words = new interval[numberGridsInSecondRow];
            iterador = iterador + 1;
            words = readTextGridIntervals(lines, iterador, numberGridsInSecondRow);

            Console.WriteLine(words[0].xmin.ToString());
            Console.WriteLine(words[0].xmax.ToString());

            Console.WriteLine(words.Length.ToString());

            //------------------------------------------------------------
            //------------------------------------------------------------

            // para cada palabra, buscar todos los fonemas que están dentro de ese índice de tiempo

            // buscar los índices de tiempo en los que ocurre una palabra (puede ocurrir varias veces en el texto)

            double currentWordXmin = 0;
            double currentWordXmax = 0;
            string currentWord = "";
            string[] currentWordOutputVector = new string[0];
            string currentWordJoinedArpabet = "";
            string iteratingWordJoinedArpabet = "";
            List<int> intervalPosition = new List<int>();

            for (int i = 0; i < numberGridsInSecondRow; i++)
            {

                if (words[i].text.Equals("sp") == false)
                {

                    intervalPosition = new List<int>();
                    currentWordOutputVector = new string[0];
                    iteratingWordJoinedArpabet = "";
                    currentWord = words[i].text;
                    currentWordXmin = words[i].xmin;
                    currentWordXmax = words[i].xmax;

                    /*Console.WriteLine("este es el diccionario");
                    for (int j = 0; j < dictionary.Length; j++) {
                        Console.WriteLine(dictionary[j].word + " - " + dictionary[j].wordArpabet + " - " + dictionary[j].wordOutput);
                    }
                    Console.WriteLine("-----------------------");*/

                    // Encontrar la palabra en el diccionario
                    for (int j = 0; j < dictionary.Length; j++)
                    {
                        if (dictionary[j].word.ToLower().Equals(currentWord.ToLower()) == true)
                        {
                            currentWordOutputVector = dictionary[j].outputLetters;
                            currentWordJoinedArpabet = dictionary[j].wordArpabet;
                        }
                    }

                    // Encontrar los índices de los intervalos que corresponden a los
                    // fonemas de la palabra actual
                    for (int j = 0; j < numberGridsInFirstRow; j++)
                    {
                        if (phonemes[j].xmin >= currentWordXmin && phonemes[j].xmax <= currentWordXmax)
                        {
                            intervalPosition.Add(j);
                            iteratingWordJoinedArpabet += phonemes[j].text;
                        }
                    }

                    // cambiar las letras arpabet en eltextgrid por las letras que queremos
                    if (currentWordJoinedArpabet.ToLower().Equals(iteratingWordJoinedArpabet.ToLower()) == true && currentWordOutputVector.Length == intervalPosition.Count)
                    {
                        for (int j = 0; j < intervalPosition.Count; j++)
                        {
                            phonemes[intervalPosition[j]].text = currentWordOutputVector[j];
                        }
                    }
                    else
                    {
                        Console.Write("Hubo un error al tratar de alinear " + currentWord + "porque ");
                        if (currentWordJoinedArpabet.Equals(iteratingWordJoinedArpabet) == false)
                        {
                            Console.Write(" la palabra arpabet ( " + currentWordJoinedArpabet + " ) no es igual a la palabra actual (" + iteratingWordJoinedArpabet + ")\n");
                        }
                        /*if (currentWordOutputVector.Length != intervalPosition.Count) {
                            Console.Write(" las palabras tienen diferente número de letras\n");
                        }*/
                    }

                }


            }

            res = textGridPhonemesHeader;

            // Construir los intervalos de los fonemas
            for (int i = 0; i < numberGridsInFirstRow; i++)
            {
                res += "\t\t\t" + "intervals [" + (i + 1).ToString() + "]:\n";
                res += "\t\t\t\t" + "xmin = " + phonemes[i].xmin.ToString().Replace(',', '.') + "\n";
                res += "\t\t\t\t" + "xmax = " + phonemes[i].xmax.ToString().Replace(',', '.') + "\n";
                res += "\t\t\t\t" + "text = \"" + phonemes[i].text + "\"\n";
            }

            res += textGridWordsHeader;

            for (int i = 0; i < numberGridsInSecondRow; i++)
            {
                res += "\t\t\t" + "intervals [" + (i + 1).ToString() + "]:\n";
                res += "\t\t\t\t" + "xmin = " + words[i].xmin.ToString().Replace(',', '.') + "\n";
                res += "\t\t\t\t" + "xmax = " + words[i].xmax.ToString().Replace(',', '.') + "\n";
                res += "\t\t\t\t" + "text = \"" + words[i].text + "\"\n";
            }

            //Console.WriteLine(res);

            return res;

        }

        private void txt_dict_TextChanged(object sender, EventArgs e)
        {

        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void txt_textGrid_TextChanged(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void btn_openUncorrectedTextGrid_Click(object sender, EventArgs e)
        {

            openFileTextGrid.Filter = "TextGrids (*.TextGrid)|*.TextGrid|Todos los archivos (*.*)|*.*";
            DialogResult result = openFileTextGrid.ShowDialog();

            if (result == DialogResult.OK)
            {
                txt_TextGridUncorrected.Text = openFileTextGrid.FileName;
            }

        }

        public class interval
        {

            public double xmin { get; set; }
            public double xmax { get; set; }
            public string text { get; set; }
            public interval() { }

            public interval(double inXmin, double inXmax, string inText)
            {
                xmin = inXmin;
                xmax = inXmax;
                text = inText;
            }

        }

        public class dictWord
        {

            public string word { get; set; }
            public string[] arpabetLetters { get; set; }
            public string[] outputLetters { get; set; }
            public string wordArpabet { get; set; }
            public string wordOutput { get; set; }

            public dictWord() { }

            public dictWord(string inWord, string inArpabet, string inOutput)
            {

                word = inWord;

                arpabetLetters = inArpabet.Split(' ');
                outputLetters = inOutput.Split(' ');

                wordArpabet = inArpabet.Replace(" ", "");
                wordOutput = inWord.Replace(" ", "");

            }

        }

        private void btn_openHandCorrectedTextGrid_Click(object sender, EventArgs e) {

            openFileTextGrid.Filter = "TextGrids (*.TextGrid)|*.TextGrid|Todos los archivos (*.*)|*.*";
            DialogResult result = openFileTextGrid.ShowDialog();

            if (result == DialogResult.OK) {
                txt_textGridHandCorrected.Text = openFileTextGrid.FileName;
            }

        }

        private void btn_RMSCalc_Click(object sender, EventArgs e) {

            if (txt_TextGridUncorrected.Text.Equals("") || txt_textGridHandCorrected.Text.Equals("") == true) {
                MessageBox.Show("Por favor seleccione dos TextGrids para continuar");
            }
            else {

                string output = processRMS(txt_TextGridUncorrected.Text, txt_textGridHandCorrected.Text);

                string nameOutputFile = Path.GetFileNameWithoutExtension(txt_TextGridUncorrected.Text);
                nameOutputFile += "-rms.txt";

                saveTextGrid.FileName = nameOutputFile;
                saveTextGrid.InitialDirectory = Path.GetDirectoryName(txt_TextGridUncorrected.Text);

                DialogResult result = saveTextGrid.ShowDialog();

                if (saveTextGrid.FileName != "" && result == DialogResult.OK) {
                    File.WriteAllText(saveTextGrid.FileName, output);
                    MessageBox.Show("Archivo guardado");
                }

                //Console.WriteLine(output);

            }
        }
    }
}
