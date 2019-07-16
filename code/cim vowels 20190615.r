library(phonR)
library(ggplot2)

# Read the vowels
fileCIM = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\cim-vowels-20190615-1859.csv"
cim <- read.csv(file=fileCIM, header=TRUE, sep=",")
vowels = subset(cim, TextGridLabel == "a" | TextGridLabel == "e" | TextGridLabel == "i" | TextGridLabel == "o" | TextGridLabel == "u" |
                      TextGridLabel == "a" | TextGridLabel == "e" | TextGridLabel == "i" | TextGridLabel == "o" | TextGridLabel == "u" )
vowels$TextGridLabel = as.factor(as.character(vowels$TextGridLabel))
unique(vowels$TextGridLabel)

# Create additional information 
vowels$vLength = "long"
vowels$vLength[vowels$TextGridLabel=="a" | vowels$TextGridLabel=="e" | vowels$TextGridLabel=="i" | vowels$TextGridLabel=="o" | vowels$TextGridLabel=="u"] = "short"
vowels$island = "Mangaia"  # EDS1PiriMarearai20150529HSB
vowels$island[vowels$Filename=="atiu-targetWords-20171029"] = "Atiu"
vowels$island[vowels$Filename=="EMM20160413MuseumWordStressZ"] = "Ma'uke"
vowels$island[vowels$Filename=="ETauRongo20160414HSBNWS"] = "Rarotonga"
vowels$island[vowels$Filename=="ETauRongo20160414HSBSentences"] = "Rarotonga"
vowels$island[vowels$Filename=="glottalsaitutaki201708291447"] = "Aitutaki"
vowels$island[vowels$Filename=="KoNgaeTaRima"] = "Rarotonga"
vowels$island[vowels$Filename=="SATN_Election_2011_A_CIM"] = "Rarotonga"
vowels$island = as.factor(vowels$island)
unique(vowels$island)
vowels$segment = "a"
vowels$segment[vowels$TextGridLabel == "a" | vowels$TextGridLabel == "a"] = "a"
vowels$segment[vowels$TextGridLabel == "e" | vowels$TextGridLabel == "e"] = "e"
vowels$segment[vowels$TextGridLabel == "i" | vowels$TextGridLabel == "i"] = "i"
vowels$segment[vowels$TextGridLabel == "o" | vowels$TextGridLabel == "o"] = "o"
vowels$segment[vowels$TextGridLabel == "u" | vowels$TextGridLabel == "u"] = "u"
vowels$segment = as.factor(vowels$segment)
unique(vowels$segment)


# =================================
# normalization
# =================================

# log
vowels$logf1 = log(vowels$F1_midpoint)
vowels$logf2 = log(vowels$F2_midpoint)

vowels$meanLogF1 = -999
vowels$sdLogF1 = -999

vowels$meanLogF1[vowels$Filename=="EDS1PiriMarearai20150529HSB"] = mean(vowels$logf1[vowels$Filename=="EDS1PiriMarearai20150529HSB"])
vowels$sdLogF1[vowels$Filename=="EDS1PiriMarearai20150529HSB"]   = sd(vowels$logf1[vowels$Filename=="EDS1PiriMarearai20150529HSB"])

vowels$meanLogF1[vowels$Filename=="atiu-targetWords-20171029"] = mean(vowels$logf1[vowels$Filename=="atiu-targetWords-20171029"])
vowels$sdLogF1[vowels$Filename=="atiu-targetWords-20171029"]   = sd(vowels$logf1[vowels$Filename=="atiu-targetWords-20171029"])

vowels$meanLogF1[vowels$Filename=="EMM20160413MuseumWordStressZ"] = mean(vowels$logf1[vowels$Filename=="EMM20160413MuseumWordStressZ"])
vowels$sdLogF1[vowels$Filename=="EMM20160413MuseumWordStressZ"]   = sd(vowels$logf1[vowels$Filename=="EMM20160413MuseumWordStressZ"])

vowels$meanLogF1[vowels$Filename=="ETauRongo20160414HSBNWS"] = mean(vowels$logf1[vowels$Filename=="ETauRongo20160414HSBNWS"])
vowels$sdLogF1[vowels$Filename=="ETauRongo20160414HSBNWS"]   = sd(vowels$logf1[vowels$Filename=="ETauRongo20160414HSBNWS"])

vowels$meanLogF1[vowels$Filename=="ETauRongo20160414HSBSentences"] = mean(vowels$logf1[vowels$Filename=="ETauRongo20160414HSBSentences"])
vowels$sdLogF1[vowels$Filename=="ETauRongo20160414HSBSentences"]   = sd(vowels$logf1[vowels$Filename=="ETauRongo20160414HSBSentences"])

vowels$meanLogF1[vowels$Filename=="glottalsaitutaki201708291447"] = mean(vowels$logf1[vowels$Filename=="glottalsaitutaki201708291447"])
vowels$sdLogF1[vowels$Filename=="glottalsaitutaki201708291447"]   = sd(vowels$logf1[vowels$Filename=="glottalsaitutaki201708291447"])

vowels$meanLogF1[vowels$Filename=="KoNgaeTaRima"] = mean(vowels$logf1[vowels$Filename=="KoNgaeTaRima"])
vowels$sdLogF1[vowels$Filename=="KoNgaeTaRima"]   = sd(vowels$logf1[vowels$Filename=="KoNgaeTaRima"])

vowels$meanLogF1[vowels$Filename=="SATN_Election_2011_A_CIM"] = mean(vowels$logf1[vowels$Filename=="SATN_Election_2011_A_CIM"])
vowels$sdLogF1[vowels$Filename=="SATN_Election_2011_A_CIM"]   = sd(vowels$logf1[vowels$Filename=="SATN_Election_2011_A_CIM"])

vowels$meanLogF2[vowels$Filename=="EDS1PiriMarearai20150529HSB"] = mean(vowels$logf2[vowels$Filename=="EDS1PiriMarearai20150529HSB"])
vowels$sdLogF2[vowels$Filename=="EDS1PiriMarearai20150529HSB"]   = sd(vowels$logf2[vowels$Filename=="EDS1PiriMarearai20150529HSB"])

vowels$meanLogF2[vowels$Filename=="atiu-targetWords-20171029"] = mean(vowels$logf2[vowels$Filename=="atiu-targetWords-20171029"])
vowels$sdLogF2[vowels$Filename=="atiu-targetWords-20171029"]   = sd(vowels$logf2[vowels$Filename=="atiu-targetWords-20171029"])

vowels$meanLogF2[vowels$Filename=="EMM20160413MuseumWordStressZ"] = mean(vowels$logf2[vowels$Filename=="EMM20160413MuseumWordStressZ"])
vowels$sdLogF2[vowels$Filename=="EMM20160413MuseumWordStressZ"]   = sd(vowels$logf2[vowels$Filename=="EMM20160413MuseumWordStressZ"])

vowels$meanLogF2[vowels$Filename=="ETauRongo20160414HSBNWS"] = mean(vowels$logf2[vowels$Filename=="ETauRongo20160414HSBNWS"])
vowels$sdLogF2[vowels$Filename=="ETauRongo20160414HSBNWS"]   = sd(vowels$logf2[vowels$Filename=="ETauRongo20160414HSBNWS"])

vowels$meanLogF2[vowels$Filename=="ETauRongo20160414HSBSentences"] = mean(vowels$logf2[vowels$Filename=="ETauRongo20160414HSBSentences"])
vowels$sdLogF2[vowels$Filename=="ETauRongo20160414HSBSentences"]   = sd(vowels$logf2[vowels$Filename=="ETauRongo20160414HSBSentences"])

vowels$meanLogF2[vowels$Filename=="glottalsaitutaki201708291447"] = mean(vowels$logf2[vowels$Filename=="glottalsaitutaki201708291447"])
vowels$sdLogF2[vowels$Filename=="glottalsaitutaki201708291447"]   = sd(vowels$logf2[vowels$Filename=="glottalsaitutaki201708291447"])

vowels$meanLogF2[vowels$Filename=="KoNgaeTaRima"] = mean(vowels$logf2[vowels$Filename=="KoNgaeTaRima"])
vowels$sdLogF2[vowels$Filename=="KoNgaeTaRima"]   = sd(vowels$logf2[vowels$Filename=="KoNgaeTaRima"])

vowels$meanLogF2[vowels$Filename=="SATN_Election_2011_A_CIM"] = mean(vowels$logf2[vowels$Filename=="SATN_Election_2011_A_CIM"])
vowels$sdLogF2[vowels$Filename=="SATN_Election_2011_A_CIM"]   = sd(vowels$logf2[vowels$Filename=="SATN_Election_2011_A_CIM"])

vowels$zf1 = (vowels$logf1-vowels$meanLogF1) / vowels$sdLogF1
vowels$zf2 = (vowels$logf2-vowels$meanLogF2) / vowels$sdLogF2

unique(vowels$meanLogF1)



with(vowels, plotVowels(F1_midpoint, F2_midpoint))
with(vowels, plotVowels(F1_midpoint, F2_midpoint, var.sty.by = island, var.col.by = island))

with(vowels, plotVowels(F1_midpoint, F2_midpoint, TextGridLabel, group = island, plot.tokens = FALSE, plot.means = TRUE, 
                      pch.means = TextGridLabel, cex.means = 2, var.col.by = TextGridLabel, var.sty.by = island, ellipse.line = TRUE, 
                      ellipse.fill = TRUE, fill.opacity = 0.1, pretty = TRUE, legend.kwd = "bottomright"))


s = subset(vowels, vLength=="short")
s = subset(vowels, vLength=="long")
with(s, plotVowels(zf1, zf2, TextGridLabel, group = island, var.col.by = island, var.sty.by = island, 
                      plot.tokens = FALSE, plot.means = TRUE, pch.means = TextGridLabel, cex.means = 2, pretty = TRUE, 
                      #xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                      xlim=c(2,-2),ylim=c(2,-2),
                      poly.line = TRUE, 
                      poly.order = c("i", "e", "a", "o", "u"), 
                      #poly.order = c("ī", "ē", "ā", "ō", "ū"), 
                      legend.kwd = "bottomleft", 
                      legend.args = list(seg.len = 3, cex = 1.2, lwd = 2), col = c("gray70", "black", 
                                                                                   "gray40", "black"), lty = c("solid", "dashed", "dotted")))

table(vowels$TextGridLabel, vowels$island)


# ===============================
# Vowel length
# ===============================

s = subset(vowels, duration < 1)
s$vLength = as.factor(as.character(s$vLength))
s$vLength = factor(s$vLength,levels(s$vLength)[c(2,1)])
ggplot(s, aes(x=vLength, y=duration, fill=island))+ geom_boxplot()+
  scale_y_continuous(limits=c(0,0.6)) + 
  facet_grid(. ~ segment)



# ===============================
# Diphthongs
# ===============================

fileDiph = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\cim-diph-20190701-2148.csv"
diph <- read.csv(file=fileDiph, header=FALSE, sep=",")
diph = subset(diph, V1 != "diphthong")
colnames(diph) = c("diphthong", "Filename", "TextGridLabel", "Word", "PreviousLabel", "FollowingLabel", "start", "end", "duration", "f0_0point", "f0_10point", "f0_20point", "f0_25point", "f0_30point", "f0_33point", "f0_40point", "f0_50point", "f0_60point", "f0_67point", "f0_70point", "f0_75point", "f0_80point", "f0_90point", "f0_100point", "F1_midpoint", "F2_midpoint", "F3_midpoint", "intensity_midpoint", "next_Filename", "next_TextGridLabel", "next_Word", "next_PreviousLabel", "next_FollowingLabel", "next_start", "next_end", "next_duration", "next_f0_0point", "next_f0_10point", "next_f0_20point", "next_f0_25point", "next_f0_30point", "next_f0_33point", "next_f0_40point", "next_f0_50point", "next_f0_60point", "next_f0_67point", "next_f0_70point", "next_f0_75point", "next_f0_80point", "next_f0_90point", "next_f0_100point", "next_F1_midpoint", "next_F2_midpoint", "next_F3_midpoint", "next_intensity_midpoint", "")
diph$F1_midpoint = as.double(as.character(diph$F1_midpoint))
diph$F2_midpoint = as.double(as.character(diph$F2_midpoint))
diph$next_F1_midpoint = as.double(as.character(diph$next_F1_midpoint))
diph$next_F2_midpoint = as.double(as.character(diph$next_F2_midpoint))



# Create additional information 
diph$vLength = "long"
diph$vLength[diph$TextGridLabel=="a" | diph$TextGridLabel=="e" | diph$TextGridLabel=="i" | diph$TextGridLabel=="o" | diph$TextGridLabel=="u"] = "short"
diph$island = "Mangaia"  # EDS1PiriMarearai20150529HSB
diph$island[diph$Filename=="atiu-targetWords-20171029"] = "Atiu"
diph$island[diph$Filename=="EMM20160413MuseumWordStressZ"] = "Ma'uke"
diph$island[diph$Filename=="ETauRongo20160414HSBNWS"] = "Rarotonga"
diph$island[diph$Filename=="ETauRongo20160414HSBSentences"] = "Rarotonga"
diph$island[diph$Filename=="glottalsaitutaki201708291447"] = "Aitutaki"
diph$island[diph$Filename=="KoNgaeTaRima"] = "Rarotonga"
diph$island[diph$Filename=="SATN_Election_2011_A_CIM"] = "Rarotonga"
diph$island = as.factor(diph$island)
unique(diph$island)
diph$segment = "a"
diph$segment[diph$TextGridLabel == "a" | diph$TextGridLabel == "a"] = "a"
diph$segment[diph$TextGridLabel == "e" | diph$TextGridLabel == "e"] = "e"
diph$segment[diph$TextGridLabel == "i" | diph$TextGridLabel == "i"] = "i"
diph$segment[diph$TextGridLabel == "o" | diph$TextGridLabel == "o"] = "o"
diph$segment[diph$TextGridLabel == "u" | diph$TextGridLabel == "u"] = "u"
diph$segment = as.factor(diph$segment)
unique(diph$segment)

table(diph$diphthong, diph$island)


# simulate some diphthongs; not terribly realistic values
f1delta <- sample(c(-10:-5, 5:15), nrow(indo), replace = TRUE)
f2delta <- sample(c(-15:-10, 20:30), nrow(indo), replace = TRUE)
f1coefs <- matrix(sample(c(2:5), nrow(indo) * 4, replace = TRUE), nrow = nrow(indo))
f2coefs <- matrix(sample(c(3:6), nrow(indo) * 4, replace = TRUE), nrow = nrow(indo))
indo <- within(indo, {
  f1a <- f1 + f1delta * f1coefs[, 1]
  f2a <- f2 + f2delta * f2coefs[, 1]
  f1b <- f1a + f1delta * f1coefs[, 2]
  f2b <- f2a + f2delta * f2coefs[, 2]
  f1c <- f1b + f1delta * f1coefs[, 3]
  f2c <- f2b + f2delta * f2coefs[, 3]
  f1d <- f1c + f1delta * f1coefs[, 4]
  f2d <- f2c + f2delta * f2coefs[, 4]
})
with(indo, plotVowels(cbind(f1, f1a, f1b, f1c, f1d), cbind(f2, f2a, f2b, f2c, f2d), 
                      vowel, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                      pch.means =vowel, cex.means = 2, var.col.by = vowel, pretty = TRUE, 
                      diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                      family = "Charis SIL"))

unique(diph$diphthong)
diph$F1_midpoint
d = subset(diph, diphthong=="ae" | diphthong=="ai"| diphthong=="ao" | diphthong=="au")
d = subset(diph, diphthong=="ei")
d = subset(diph, diphthong=="ea" | diphthong=="ei"| diphthong=="eo" | diphthong=="eu")
d = subset(diph, diphthong=="ia" | diphthong=="ie"| diphthong=="io" | diphthong=="iu")
d = subset(diph, diphthong=="oa" | diphthong=="oe"| diphthong=="oi" | diphthong=="ou")
d = subset(diph, diphthong=="ua" | diphthong=="ue"| diphthong=="ui" | diphthong=="uo")
with(d, plotVowels(cbind(F1_midpoint, next_F1_midpoint), cbind(F2_midpoint, next_F2_midpoint), 
                      xlim=c(2500,1000),ylim=c(1000,200),
                      diphthong, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                      pch.means =diphthong, cex.means = 2, var.col.by = diphthong, pretty = TRUE, 
                      diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                      family = "Charis SIL"))


with(d, plotVowels(cbind(F1_midpoint, next_F1_midpoint), cbind(F2_midpoint, next_F2_midpoint), 
                   xlim=c(2500,1000),ylim=c(1000,200),
                   island, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                   pch.means =island, cex.means = 2, var.col.by = island, pretty = TRUE, 
                   diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                   family = "Charis SIL"))

table(d$diphthong)
table(d$island)
cbind(d$F1_midpoint, d$next_F1_midpoint)

t = subset(d, diphthong="")