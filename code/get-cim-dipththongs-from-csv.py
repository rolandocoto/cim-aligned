import os
import string
import sys

if __name__ == "__main__":

	inFilePath = os.path.join("",sys.argv[1])
	inputCSV = open(inFilePath, encoding='utf-8').readlines()

	vowels = ["a", "e", "i", "o", "u", "ā", "ē", "ī", "ō", "ū"]
	header = "diphthong,Filename,TextGridLabel,Word,PreviousLabel,FollowingLabel,start,end,duration,f0_0point,f0_10point,f0_20point,f0_25point,f0_30point,f0_33point,f0_40point,f0_50point,f0_60point,f0_67point,f0_70point,f0_75point,f0_80point,f0_90point,f0_100point,F1_midpoint,F2_midpoint,F3_midpoint,intensity_midpoint,next_Filename,next_TextGridLabel,next_Word,next_PreviousLabel,next_FollowingLabel,next_start,next_end,next_duration,next_f0_0point,next_f0_10point,next_f0_20point,next_f0_25point,next_f0_30point,next_f0_33point,next_f0_40point,next_f0_50point,next_f0_60point,next_f0_67point,next_f0_70point,next_f0_75point,next_f0_80point,next_f0_90point,next_f0_100point,next_F1_midpoint,next_F2_midpoint,next_F3_midpoint,next_intensity_midpoint"

	lineNumber = 1
	totLines = len(inputCSV)
	res = header + "\r\n"

	for line in inputCSV:

		line = line.replace("\r", "")
		line = line.replace("\n", "")

		tabLine = line.split(",")
		letter = tabLine[1]
		word = tabLine[2]
		prevLetter = tabLine[3]
		nextLetter = tabLine[4]

		if (lineNumber < (totLines-1) and line != ""):
			nextWord = inputCSV[lineNumber+1].split(",")[2] 


		if (letter in vowels and
			nextLetter in vowels and
			letter != nextLetter and
			word == nextWord):
			
			res += letter + nextLetter + "," + line + inputCSV[lineNumber+1]



		lineNumber = lineNumber + 1

	open("cim-diph.csv", "wb").write((res.encode('utf-8','replace')))
