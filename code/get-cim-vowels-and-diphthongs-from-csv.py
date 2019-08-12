import os
import string
import sys

def change_long_for_x(inText):
  outText =  inText.replace("ā", "ax")
  outText = outText.replace("ē", "ex")
  outText = outText.replace("ī", "ix")
  outText = outText.replace("ō", "ox")
  outText = outText.replace("ū", "ux")
  return outText
  
def change_x_for_long(inText):
  outText =  inText.replace("ax","ā")
  outText = outText.replace("ex","ē")
  outText = outText.replace("ix","ī")
  outText = outText.replace("ox","ō")
  outText = outText.replace("ux","ū")
  return outText

if __name__ == "__main__":
	inFilePath = os.path.join("",sys.argv[1])
	inputCSV = open(inFilePath, encoding='utf-8').readlines()

	vowels = ["a", "e", "i", "o", "u", "ā", "ē", "ī", "ō", "ū"]
	header = "phone,type,Filename,TextGridLabel,Word,PreviousLabel,FollowingLabel,start,end,duration,f0_0point,f0_10point,f0_20point,f0_25point,f0_30point,f0_33point,f0_40point,f0_50point,f0_60point,f0_67point,f0_70point,f0_75point,f0_80point,f0_90point,f0_100point,F1_midpoint,F2_midpoint,F3_midpoint,intensity_midpoint,prevConsonant,prevVowel,nextConsonant,nextVowel,syllPos,next_Filename,next_TextGridLabel,next_Word,next_PreviousLabel,next_FollowingLabel,next_start,next_end,next_duration,next_f0_0point,next_f0_10point,next_f0_20point,next_f0_25point,next_f0_30point,next_f0_33point,next_f0_40point,next_f0_50point,next_f0_60point,next_f0_67point,next_f0_70point,next_f0_75point,next_f0_80point,next_f0_90point,next_f0_100point,next_F1_midpoint,next_F2_midpoint,next_F3_midpoint,next_intensity_midpoint,syllType"
	
	#header = "phone,type,Filename,TextGridLabel,Word,PreviousLabel,FollowingLabel,start,end,duration,f0_0point,f0_10point,f0_20point,f0_25point,f0_30point,f0_33point,f0_40point,f0_50point,f0_60point,f0_67point,f0_70point,f0_75point,f0_80point,f0_90point,f0_100point,F1_midpoint,F2_midpoint,F3_midpoint,intensity_midpoint,prevConsonant,prevVowel,syllPos,next_Filename,next_TextGridLabel,next_Word,next_PreviousLabel,next_FollowingLabel,next_start,next_end,next_duration,next_f0_0point,next_f0_10point,next_f0_20point,next_f0_25point,next_f0_30point,next_f0_33point,next_f0_40point,next_f0_50point,next_f0_60point,next_f0_67point,next_f0_70point,next_f0_75point,next_f0_80point,next_f0_90point,next_f0_100point,next_F1_midpoint,next_F2_midpoint,next_F3_midpoint,next_intensity_midpoint"

	lineNumber = 1
	csvTotLines = 0
	totLines = len(inputCSV)
	res = header + "\r\n"
	
	previousPhone = ""
	wordOfPreviousPhone = ""
	wordOfNextPhone = ""
	prevPhoneStart = -1
	currWordStart = -1
	currWordEnd = -1
	nextPhoneEnd = -1
	
	prevVowelInSameWord = ""
	prevConsonantInSameWord = ""
	nextVowelInSameWord = ""
	nextConsonantInSameWord = ""
	
	
	sylls = [""]
	words = [""]
	resLines = [""]
	
	#prevPhone = ""
	#prevVowelInSameWord = ""
	#prevVowel = ""
	#wordOfPrevVowel = ""

	#for line in inputCSV:
	while lineNumber < totLines:

		line = inputCSV[lineNumber]
	
		line = line.replace("\r", "")
		line = line.replace("\n", "")

		syllPosInit = -1
		syllPosEnd = -1
		
		tabLine = line.split(",")
		syllPos = "unk"
		letter = tabLine[1]
		word = tabLine[2]
		prevLetter = tabLine[3]
		nextLetter = tabLine[4]
		currPhoneStart = tabLine[5]
		currPhoneEnd = tabLine[6]
		
		

		
					
		
		# Get the previous word
		if (lineNumber != 0 and line != ""):
			previousPhone = change_x_for_long(inputCSV[lineNumber-1].split(",")[1])
			wordOfPreviousPhone = inputCSV[lineNumber-1].split(",")[2] 
			prevPhoneStart = inputCSV[lineNumber-1].split(",")[5]
			
		# Get the start of the current word
		if ( wordOfPreviousPhone != word ):
			currWordStart = currPhoneStart
			prevVowelInSameWord = ""
			prevConsonantInSameWord = ""
		# Get the previous vowel and consonant in the current word
		else:
			if (previousPhone != ""):
				
				if (previousPhone in vowels):
					prevVowelInSameWord = previousPhone
					prevVowelInSameWordStart = prevPhoneStart
					
					if (lineNumber > 1 and line != ""):
						prevPrevPhone = change_x_for_long(inputCSV[lineNumber-2].split(",")[1])
						prevPrevWord = inputCSV[lineNumber-2].split(",")[2]
						if (prevPrevPhone in vowels and prevPrevWord == word and prevPrevPhone != prevVowelInSameWord):
							prevVowelInSameWord = prevPrevPhone + prevVowelInSameWord
							prevVowelInSameWordStart = inputCSV[lineNumber-2].split(",")[5]
					
				else:
					prevConsonantInSameWord = previousPhone
					prevConsonantInSameWordStart = prevPhoneStart

					
					
					
					
		nextWord = ""
		nextPhone = ""
		# Get the end of the current word
		k = lineNumber
		if (k < (totLines-1) and inputCSV[k+1] != ""):
			nextWord  = inputCSV[k+1].split(",")[2] 
			nextPhone = change_x_for_long(inputCSV[k+1].split(",")[1])
		wordOfNextPhone = nextWord
		while (word == wordOfNextPhone):
			k = k+1
			if (k+1 < (totLines) and line!=""):
				wordOfNextPhone = inputCSV[k+1].split(",")[2]
			else:
				wordOfNextPhone = ""
		if (k+1 < (totLines) and line!=""):
			currWordEnd = inputCSV[k].split(",")[6]
		else:
			currWordEnd = -1
			
			
			
			
			
			
		# Get the next vowel
		k = lineNumber
		nextVowel = ""
		nextPhone = ""
		nextNextVowel = ""
		nextNextPhone = ""
		nextNextNextVowel = ""
		nextNextNextPhone = ""
		if (k < (totLines-1) and inputCSV[k+1] != ""):
			nextWord  = inputCSV[k+1].split(",")[2] 
			nextPhone = change_x_for_long(inputCSV[k+1].split(",")[1])
		wordOfNextPhone = nextWord
		if (word == wordOfNextPhone):
			if (nextPhone in vowels):
				nextVowelInSameWord = nextPhone
				#print("phone: " + letter + "; nextWord: " + wordOfNextPhone + "; " + "nextPhone: " + nextPhone + "; "  + "nextVowelInSameWordAssign: " + nextVowelInSameWord)
				if (k+1 < (totLines-1) and inputCSV[k+2] != ""):
					nextNextWord  = inputCSV[k+2].split(",")[2]
					nextNextPhone = change_x_for_long(inputCSV[k+2].split(",")[1])
					#print("nextWord: " + nextWord + "; " + "nextNextWord: " + nextNextWord + "; " + "nextNextPhone: " + nextNextPhone + "; " + "nextPhone: " + nextPhone)
					if (word == nextNextWord and nextNextPhone in vowels and nextPhone != nextNextPhone):
						#print("phone: " + letter + "; nextWord: " + nextWord + "; " + "nextNextWord: " + nextNextWord + "; " + "nextNextPhone: " + nextNextPhone + "; " + "nextPhone: " + nextPhone + "; "  + "nextVowelInSameWordAssign: " + nextVowelInSameWord + nextNextPhone)
						nextVowelInSameWord = nextVowelInSameWord + nextNextPhone
			else:
				if (k+2 < (totLines-1) and inputCSV[k+2] != ""):
					nextNextWord  = inputCSV[k+2].split(",")[2]
					nextNextPhone = change_x_for_long(inputCSV[k+2].split(",")[1])
					if (nextNextPhone in vowels and word == nextNextWord and nextPhone != nextNextPhone):
						nextVowelInSameWord = nextNextPhone
						if (k+3 < (totLines-1) and inputCSV[k+3] != ""):
							nextNextNextWord  = inputCSV[k+3].split(",")[2]
							nextNextNextPhone = change_x_for_long(inputCSV[k+3].split(",")[1])
							if (nextNextNextPhone in vowels and word == nextNextNextWord and nextNextPhone != nextNextNextPhone):
								nextVowelInSameWord = nextNextPhone + nextNextNextPhone
								if (k+4 < (totLines-1) and inputCSV[k+4] != ""):
									next4Word  = inputCSV[k+4].split(",")[2]
									next4Phone = change_x_for_long(inputCSV[k+4].split(",")[1])
									if (next4Phone in vowels and word == next4Word and nextNextNextPhone != next4Phone):
										#print("nextWord: " + nextWord + "; " + "next4Word: " + next4Word + "; " + "nextNextNextPhone: " + nextNextNextPhone + "; " + "next4Phone: " + next4Phone)
										nextVowelInSameWord = nextNextNextPhone + next4Phone

			
			# if it's an ng, and then a diphthong follows
			if (nextPhone == "ng"):
				if (k+2 < (totLines-1) and inputCSV[k+3] != ""):
					nextNextNextWord  = inputCSV[k+3].split(",")[2]
					nextNextNextPhone = change_x_for_long(inputCSV[k+3].split(",")[1])
					if (word == nextNextNextWord and nextNextNextPhone in vowels and nextNextPhone != nextNextNextPhone):
						nextVowelInSameWord = nextNextPhone + nextNextNextPhone
						
			# if the sound itself is a diphthong
			if (letter in vowels and nextPhone in vowels):
				#print("k: " + str(k) + " - soy un diptongo: " + word)
				if (k+2 < (totLines-1) and inputCSV[k+2] != ""):
					nextNextWord  = inputCSV[k+2].split(",")[2]
					nextNextPhone = change_x_for_long(inputCSV[k+2].split(",")[1])
					if (word == nextNextWord):
						if (nextNextPhone in vowels and nextPhone != nextNextPhone):
							nextVowelInSameWord = nextNextPhone
							if (k+2 < (totLines-1) and inputCSV[k+2] != ""):
								nextNextNextWord  = inputCSV[k+2].split(",")[2]
								nextNextNextPhone = change_x_for_long(inputCSV[k+2].split(",")[1])
								#print("nextNextNextPhone: " + nextNextNextPhone)
								if (word == nextNextNextWord and nextNextNextPhone in vowels and nextNextPhone != nextNextNextPhone):
									nextVowelInSameWord = nextNextPhone + nextNextNextPhone
						else:
							if (k+3 < (totLines-1) and inputCSV[k+3] != ""):
								next4Word  = inputCSV[k+3].split(",")[2]
								next4Phone = change_x_for_long(inputCSV[k+3].split(",")[1])
								if (word == next4Word and next4Phone in vowels and nextNextNextPhone != next4Phone):
									#print("k: " + str(k+3) + " - next4Word: " + next4Word + " - 4PhoneAssign: " + next4Phone)
									nextVowelInSameWord = next4Phone
									if (k+4 < (totLines-1) and inputCSV[k+4] != ""):
										next5Word  = inputCSV[k+4].split(",")[2]
										next5Phone = change_x_for_long(inputCSV[k+4].split(",")[1])
										if (word == next5Word and next5Phone in vowels and next4Phone != next5Phone):
											#print("k: " + str(k+4) + " - next5Word: " + next5Word + " - 5PhoneAssign: " + next5Phone)
											nextVowelInSameWord = next4Phone + next5Phone
					else:
						nextVowelInSameWord = ""
						
		else:
			nextVowelInSameWord = ""
			
			
			
			
			

			

			
		# Get the next consonant
		k = lineNumber
		if (k < (totLines-1) and inputCSV[k+1] != ""):
			nextWord  = inputCSV[k+1].split(",")[2] 
			nextPhone = change_x_for_long(inputCSV[k+1].split(",")[1])
		wordOfNextPhone = nextWord
		if (word == wordOfNextPhone):
			if (nextPhone not in vowels):
				nextConsonantInSameWord = nextPhone
			else: 
				if (k+1 < (totLines-1) and inputCSV[k+2] != ""):
					nextNextWord  = inputCSV[k+2].split(",")[2] 
					nextNextPhone = change_x_for_long(inputCSV[k+2].split(",")[1])
					if (word == nextNextWord and nextNextPhone not in vowels):
						nextConsonantInSameWord = nextNextPhone
					else:
						if (k+2 < (totLines-1) and inputCSV[k+2] != ""):
							nextNextNextWord  = inputCSV[k+3].split(",")[2] 
							nextNextNextPhone = change_x_for_long(inputCSV[k+3].split(",")[1])
							if (word == nextNextNextWord and nextNextNextPhone not in vowels):
								nextConsonantInSameWord = nextNextNextPhone
						else:
							nextConsonantInSameWord = ""
				else:
					nextConsonantInSameWord = ""
		else:
			nextConsonantInSameWord = ""
		
		
		
		
		# If the long has a vowel
		if (letter in vowels):

			# And this vowel is part of a diphthong (i.e. if it's followed by another vowel within the same word)
			if (nextLetter in vowels and
			letter != nextLetter and
			word == nextWord):
			
				if (currPhoneStart == currWordStart or prevConsonantInSameWordStart == currWordStart):
					syllPosInit = 1
				else: syllPosInit = 0
				if (nextPhoneEnd == currWordEnd):
					syllPosEnd = 1
				else: syllPosEnd = 0
				
				if (syllPosInit == 1 and syllPosEnd == 0) :
					syllPos = "first"
				elif (syllPosInit == 0 and syllPosEnd == 1):
					syllPos = "last"
				elif (syllPosInit == 1 and syllPosEnd == 1):
					syllPos = "monosyll"
				elif (syllPosInit == 0 and syllPosEnd == 0):
					syllPos = "mid"
			
				joinedLetter = letter + nextLetter
				joinedLetter = change_long_for_x(joinedLetter)
				#resLines.append(joinedLetter + "," + "diphthong" + "," + line + "," + prevConsonantInSameWord + "," + prevVowelInSameWord + "," + syllPos + "," + inputCSV[lineNumber+1].replace("\n",""))
				res += joinedLetter + "," + "diphthong" + "," + line + "," + prevConsonantInSameWord + "," + prevVowelInSameWord + "," + nextConsonantInSameWord + "," + nextVowelInSameWord + "," + syllPos + "," + inputCSV[lineNumber+1]
				sylls.append(syllPos)
				words.append(word)
				csvTotLines = csvTotLines + 1
				lineNumber = lineNumber+1
				
			# If it's a lone vowel (i.e. not followed by another vowel within the same word)
			else:
			
				if (currPhoneStart == currWordStart or prevConsonantInSameWordStart == currWordStart):
					syllPosInit = 1
				else: syllPosInit = 0
				if (currPhoneEnd == currWordEnd):
					syllPosEnd = 1
				else: syllPosEnd = 0
				
				if (syllPosInit == 1 and syllPosEnd == 0) :
					syllPos = "first"
				elif (syllPosInit == 0 and syllPosEnd == 1):
					syllPos = "last"
				elif (syllPosInit == 1 and syllPosEnd == 1):
					syllPos = "monosyll"
				elif (syllPosInit == 0 and syllPosEnd == 0):
					syllPos = "mid"
				
				res += change_long_for_x(letter) + "," + "vowel" + "," + line + "," + prevConsonantInSameWord + "," + prevVowelInSameWord + "," + nextConsonantInSameWord + "," + nextVowelInSameWord + "," + syllPos + "\r\n"
				#resLines.append(change_long_for_x(letter) + "," + "vowel" + "," + line + "," + prevConsonantInSameWord + "," + prevVowelInSameWord + "," + syllPos + ",,,,,,,,,,,,,,,,,,,,,,,,,,,")
				sylls.append(syllPos)
				words.append(word)
				csvTotLines = csvTotLines + 1


		lineNumber = lineNumber + 1

	
	# add syllable position and quantity information
	

	
	csvLines = res.split("\r\n")
	csvIterator = 0
	nextSyll = ""
	
	csvIterator = 0
	while csvIterator < len(sylls):
		if ((csvIterator+1) < len(sylls)):
			if (sylls[csvIterator+1] == "last"):
				sylls[csvIterator] = "penult"
		csvIterator = csvIterator+1
	
	csvIterator = 0
	while csvIterator < len(sylls):
		if ((csvIterator+1) < len(sylls)):
			if (sylls[csvIterator+1] == "penult" and words[csvIterator] == words[csvIterator+1]):
				sylls[csvIterator] = "antepenult"
		csvIterator = csvIterator+1
		
	csvIterator = 0
	while csvIterator < len(sylls):
		if ((csvIterator+1) < len(sylls)):
			if (sylls[csvIterator+1] == "antepenult" and words[csvIterator] == words[csvIterator+1]):
				sylls[csvIterator] = "anteantepenult"
		csvIterator = csvIterator+1
	
	#csvIterator = 0
	#while csvIterator < len(sylls):
	#	print(sylls[csvIterator] + "-" + words[csvIterator])
	#	csvIterator = csvIterator+1
	
	#csvIterator = 0	
	#while csvIterator < len(sylls):
	#	if (resLines[csvIterator] != ""):
	#		res += resLines[csvIterator] + "," + sylls[csvIterator] + "\r\n"
	#	csvIterator = csvIterator+1
	
	res = res.replace(",","\t")
	open("cim-phones.csv", "wb").write((res.encode('utf-8','replace')))
