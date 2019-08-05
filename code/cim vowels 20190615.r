library(phonR)
library(ggplot2)


# Read the vowels
fileCIM = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\cim-vowels-20190729-1437.csv"
cim <- read.csv(file=fileCIM, header=TRUE, sep=",")


vowels = subset(cim, phone == "a" | phone == "e" | phone == "i" | phone == "o" | phone == "u" |
                     phone == "ax" | phone == "ex" | phone == "ix" | phone == "ox" | phone == "ux")
vowels$TextGridLabel = as.factor(as.character(vowels$TextGridLabel))
vowels$phone = as.factor(as.character(vowels$phone))
unique(vowels$TextGridLabel)
unique(vowels$phone)

# Create additional information 
vowels$vLength = "long"
vowels$vLength[vowels$TextGridLabel=="a" | vowels$TextGridLabel=="e" | vowels$TextGridLabel=="i" | vowels$TextGridLabel=="o" | vowels$TextGridLabel=="u"] = "short"
vowels$island = "Mangaia"  # EDS1PiriMarearai20150529HSB
vowels$island[vowels$Filename=="atiu-targetWords-20171029"] = "‘Atiu"
vowels$island[vowels$Filename=="20170907TiareA-tangata"] = "‘Atiu"
vowels$island[vowels$Filename=="EMM20160413MuseumWordStressZ"] = "Ma‘uke"
vowels$island[vowels$Filename=="ETauRongo20160414HSBNWS"] = "Rarotonga"
vowels$island[vowels$Filename=="ETauRongo20160414HSBSentences"] = "Rarotonga"
vowels$island[vowels$Filename=="glottals-aitutaki-20170829-1447"] = "Aitutaki"
vowels$island[vowels$Filename=="20170829EGlAna"] = "Aitutaki"
vowels$island[vowels$Filename=="KoNgaeTaRima"] = "Rarotonga"
vowels$island[vowels$Filename=="SATN_Election_2011_A_CIM"] = "Rarotonga"
vowels$island = as.factor(vowels$island)
vowels$frontingGroup="Fronted /u/"
vowels$frontingGroup[vowels$island=="Ma‘uke"]="Back /u/"
vowels$frontingGroup[vowels$island=="‘Atiu"]="Back /u/"
unique(vowels$island)
vowels$segment = "a"
vowels$segment[vowels$phone == "a" | vowels$phone == "ax"] = "a" #ā
vowels$segment[vowels$phone == "e" | vowels$phone == "ex"] = "e" #ē
vowels$segment[vowels$phone == "i" | vowels$phone == "ix"] = "i" #ī
vowels$segment[vowels$phone == "o" | vowels$phone == "ox"] = "o" #ō
vowels$segment[vowels$phone == "u" | vowels$phone == "ux"] = "u" #ū
vowels$segment = as.factor(vowels$segment)
unique(vowels$segment)
unique(vowels$frontingGroup)

# =================================
# leave only hand-corrected vowels
# =================================

unique(vowels$Filename)
vowels$start = as.numeric(as.character(vowels$start))
vowels$duration = as.numeric(as.character(vowels$duration))

#vowels = subset(vowels, type=="vowel" & 
#                  ((Filename == "ETauRongo20160414HSBNWS" & start<60) | 
#                     (Filename == "EDS1PiriMarearai20150529HSB" & start<130)|
#                     (Filename == "EMM20160413MuseumWordStressZ" & start<120)|
#                     (Filename == "20170829EGlAna"& start<100)|
#                     (Filename == "SATN_Election_2011_A_CIM")
#                  ))

vowels = subset(vowels, duration > 0.005)


# =================================
# normalization
# =================================

# log
vowels$logf1 = log(vowels$F1_midpoint)
vowels$logf2 = log(vowels$F2_midpoint)

vowels$meanLogF1 = -999
vowels$sdLogF1 = -999

# yes, i know i shouldn't have loops in R. bite me.
files = unique(vowels$Filename)
for(i in files){
  vowels$meanLogF1[vowels$Filename==i] = mean(vowels$logf1[vowels$Filename==i])
  vowels$sdLogF1[vowels$Filename==i]   = sd(vowels$logf1[vowels$Filename==i])
  vowels$meanLogF2[vowels$Filename==i] = mean(vowels$logf2[vowels$Filename==i])
  vowels$sdLogF2[vowels$Filename==i]   = sd(vowels$logf2[vowels$Filename==i])
}

vowels$zf1 = (vowels$logf1-vowels$meanLogF1) / vowels$sdLogF1
vowels$zf2 = (vowels$logf2-vowels$meanLogF2) / vowels$sdLogF2
unique(vowels$meanLogF1)


# =================================
# charts
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# =================================


with(vowels, plotVowels(F1_midpoint, F2_midpoint))
with(vowels, plotVowels(F1_midpoint, F2_midpoint, var.sty.by = island, var.col.by = island))

with(vowels, plotVowels(F1_midpoint, F2_midpoint, TextGridLabel, group = island, plot.tokens = FALSE, plot.means = TRUE, 
                      pch.means = TextGridLabel, cex.means = 2, var.col.by = TextGridLabel, var.sty.by = island, ellipse.line = TRUE, 
                      ellipse.fill = TRUE, fill.opacity = 0.1, pretty = TRUE, legend.kwd = "bottomright"))


s = subset(vowels, vLength=="short")
s = subset(vowels, vLength=="long")
s = subset(vowels, vLength=="short" & (island=="Rarotonga" | island=="Aitutaki" | island=="Mangaia"))
s = subset(vowels, vLength=="short" & (island=="Atiu" | island=="Ma'uke"))

# all together
with(s, plotVowels(zf1, zf2, phone, group = island, var.col.by = island, var.sty.by = island, 
                      #main = "Vowel triangle for short vowels",
                      plot.tokens = FALSE, plot.means = TRUE, pch.means = phone, cex.means = 2, pretty = TRUE, 
                      #xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                      xlim=c(2,-2.1),ylim=c(2,-2),
                      poly.line = TRUE, 
                      poly.order = c("i", "e", "a", "o", "u"), 
                      #poly.order = c("ix", "ex", "ax", "ox", "ux"), 
                      #poly.order = c("Ä«", "Ä", "Ä", "Å", "Å«"), 
                      xlab="F2 (z-score semitones)",
                      ylab="F1 (z-score semitones)",
                      legend.kwd = "bottomleft", 
                      legend.args = list(seg.len = 2, cex = 1.2, lwd = 2),
                      col = c("blue", "orange", "red", "red4", "lightslateblue"), 
                      lty = c("solid", "dotdash", "solid", "dotted", "dashed")
                   ))

#c("solid", "dashed", "dotted", "dotdash", "dashed")





#frontingAndBackGroup

par(mfcol = 1:2)
s = subset(vowels, vLength=="short")
sSub = subset(s, frontingGroup=="Back /u/")
with(sSub, plotVowels(zf1, zf2, phone, group = island, var.col.by = island, var.sty.by = island, 
                   #main = "Vowel triangle for short vowels",
                   plot.tokens = FALSE, plot.means = TRUE, pch.means = phone, cex.means = 2, pretty = TRUE, 
                   #xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                   xlim=c(2,-2.1),ylim=c(2,-2),
                   poly.line = TRUE, 
                   poly.order = c("i", "e", "a", "o", "u"), 
                   #poly.order = c("ix", "ex", "ax", "ox", "ux"), 
                   #poly.order = c("Ä«", "Ä", "Ä", "Å", "Å«"), 
                   xlab="F2 (z-score semitones)",
                   ylab="F1 (z-score semitones)",
                   legend.kwd = "bottomleft", 
                   legend.args = list(seg.len = 2, cex = 1.2, lwd = 2),
                   col = c("grey", "black"), 
                   lty = c("solid", "solid")
))
sSub = subset(s, frontingGroup=="Fronted /u/")
with(sSub, plotVowels(zf1, zf2, phone, group = island, var.col.by = island, var.sty.by = island, 
                   #main = "Vowel triangle for short vowels",
                   plot.tokens = FALSE, plot.means = TRUE, pch.means = phone, cex.means = 2, pretty = TRUE, 
                   #xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                   xlim=c(2,-2.1),ylim=c(2,-2),
                   poly.line = TRUE, 
                   poly.order = c("i", "e", "a", "o", "u"), 
                   #poly.order = c("ix", "ex", "ax", "ox", "ux"), 
                   #poly.order = c("Ä«", "Ä", "Ä", "Å", "Å«"), 
                   xlab="F2 (z-score semitones)",
                   ylab="F1 (z-score semitones)",
                   legend.kwd = "bottomleft", 
                   legend.args = list(seg.len = 2, cex = 1.2, lwd = 2),
                   col = c("grey", "grey50", "black"), 
                   lty = c("solid", "dotted", "solid")
))
par(mfcol = 1:1)



s$phone = as.factor(as.character(s$phone))
unique(s$island)
table(s$phone, s$island)


# ===================================================
# https://guilhermegarcia.github.io/vowels.html
# ===================================================

ggplot(data = s, aes(x = zf2, y = zf1, color = phone, label = phone)) + facet_wrap( ~ island, ncol=2) + 
  geom_text() + 
  scale_y_reverse(position = "right") + 
  scale_x_reverse(position = "top") + 
  #geom_density_2d(aes(fill = ..level..), geom = "polygon") +
  #stat_density_2d(aes(fill = ..level..), geom = "polygon")+
  geom_density_2d(aes(fill = ..level..), bins = 3)+
  #stat_density_2d(aes(fill = stat(level)), geom = "polygon")+
  theme(legend.position = "none")+
  xlim(2, -2) + ylim(2, -2)


library(dplyr)
ggplot(s %>% group_by(island, phone) %>% 
         summarise(zf2=mean(zf2)), 
       aes(x = phone, y = zf2)) + 
  geom_point(data=s, aes(color=phone, group=phone), size=4) + 
  facet_wrap( ~ island, ncol=2) + 
  geom_line(colour="blue", linetype="11", size=0.3) + 
  geom_point(shape=4, colour="blue", size=3)


# https://www.r-bloggers.com/plotting-individual-observations-and-group-means-with-ggplot2/
b = s %>% group_by(island, phone) %>% summarise(zf2 = mean(zf2), zf1=mean(zf1))


ggplot(s, aes(x = zf2, y = zf1, color = phone)) +
  xlim(2, -2) + ylim(2, -2)+
  facet_wrap( ~ island, ncol=2) + 
  geom_point(alpha = .4) +
  #geom_line()+
  geom_point(data = b, size = 6, aes(group=phone))+
  geom_path(data = b, aes(group=phone))

ggplot(b, aes(x = zf2, y = zf1, color = phone)) +
  xlim(2, -2) + ylim(2, -2)+
  facet_wrap( ~ island, ncol=2) + 
  geom_point(size=6)+
  geom_line()
  #geom_point(data = b, size = 6, aes(group=phone))+
  #geom_path(data = b, aes(group=phone))



# ===============================
# Vowel length
# ===============================

s = subset(vowels, duration < 1)
unique(s$phone)
s$vLength = as.factor(as.character(s$vLength))
s$vLength = factor(s$vLength,levels(s$vLength)[c(2,1)])
ggplot(s, aes(x=vLength, y=duration, fill=island))+ geom_boxplot()+
  scale_y_continuous(limits=c(0,0.35)) + 
  facet_grid(. ~ segment)

s$phone = as.factor(as.character(s$phone))
table(s$phone, s$island)

# ========================================================================================
# Diphthongs
# ========================================================================================

diph = subset(cim, type == "diphthong")
# Create additional information 
diph$island = "Mangaia"  # EDS1PiriMarearai20150529HSB
diph$island[diph$Filename=="atiu-targetWords-20171029"] = "Atiu"
diph$island[diph$Filename=="20170907TiareA-tangata"] = "Atiu"
diph$island[diph$Filename=="EMM20160413MuseumWordStressZ"] = "Ma'uke"
diph$island[diph$Filename=="ETauRongo20160414HSBNWS"] = "Rarotonga"
diph$island[diph$Filename=="ETauRongo20160414HSBSentences"] = "Rarotonga"
diph$island[diph$Filename=="glottalsaitutaki201708291447"] = "Aitutaki"
diph$island[diph$Filename=="20170829EGlAna"] = "Aitutaki"
diph$island[diph$Filename=="KoNgaeTaRima"] = "Rarotonga"
diph$island[diph$Filename=="SATN_Election_2011_A_CIM"] = "Rarotonga"
diph$island = as.factor(diph$island)
unique(diph$island)

# =================================
# leave only hand-corrected vowels
# =================================

unique(diph$Filename)
diph$start = as.numeric(as.character(diph$start))
diph$duration = as.numeric(as.character(diph$duration))

#diph = subset(diph, type=="diphthong" & 
#                  ((Filename == "ETauRongo20160414HSBNWS" & start<60) | 
#                     (Filename == "EDS1PiriMarearai20150529HSB" & start<130)|
#                     (Filename == "EMM20160413MuseumWordStressZ" & start<120)|
#                     (Filename == "20170829EGlAna"& start<100)|
#                     (Filename == "SATN_Election_2011_A_CIM")
#                  ))

diph = subset(diph, duration > 0.005)

# =================================
# normalization
# =================================

# log
diph$logf1 = log(diph$F1_midpoint)
diph$logf2 = log(diph$F2_midpoint)
diph$next_logf1 = log(diph$next_F1_midpoint)
diph$next_logf2 = log(diph$next_F2_midpoint)

diph$meanLogF1 = -999
diph$sdLogF1 = -999
diph$next_meanLogF1 = -999
diph$next_sdLogF1 = -999

mean(c(1,2))

files = unique(diph$Filename)
for(i in files){
  diph$meanLogF1[diph$Filename==i] = mean(c(diph$logf1[diph$Filename==i],diph$next_logf1[diph$Filename==i]))
  diph$sdLogF1[diph$Filename==i] = sd(c(diph$logf1[diph$Filename==i],diph$next_logf1[diph$Filename==i]))
  diph$meanLogF2[diph$Filename==i] = mean(c(diph$logf2[diph$Filename==i],diph$next_logf2[diph$Filename==i]))
  diph$sdLogF2[diph$Filename==i] = sd(c(diph$logf2[diph$Filename==i],diph$next_logf2[diph$Filename==i]))
}

diph$zf1 = (diph$logf1-diph$meanLogF1) / diph$sdLogF1
diph$zf2 = (diph$logf2-diph$meanLogF2) / diph$sdLogF2
diph$next_zf1 = (diph$next_logf1-diph$meanLogF1) / diph$sdLogF1
diph$next_zf2 = (diph$next_logf2-diph$meanLogF2) / diph$sdLogF2
unique(diph$meanLogF1)

#============
# charts
#============

d = diph
d = subset(diph, phone=="au")
table(d$island, d$phone)

with(d, plotVowels(cbind(F1_midpoint, next_F1_midpoint), cbind(F2_midpoint, next_F2_midpoint), 
                   xlim=c(2500,1000),ylim=c(1000,200),
                   phone, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                   pch.means =phone, cex.means = 2, var.col.by = phone, pretty = TRUE, 
                   diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                   family = "Charis iSIL"))


with(d, plotVowels(cbind(zf1, next_zf1), cbind(zf2, next_zf2), 
                   xlim=c(1.5,-2.5),ylim=c(2,-2),
                   island, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                   pch.means =island, cex.means = 2, var.col.by = island, pretty = TRUE, 
                   diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                   family = "Charis SIL"))


d = diph
d = subset(diph, phone=="au" | phone=="ua" | phone=="ou")
d = subset(diph, phone=="au" | phone=="ou")
d = subset(diph, phone=="au" | phone=="ua")
d = subset(d, island=="Ma'uke")
with(d, plotVowels(cbind(zf1, next_zf1), cbind(zf2, next_zf2),
                   main="Ma'uke",
                   xlim=c(1.5,-2.5),ylim=c(2,-2),
                   xlab="F2 (z-score semitones)",
                   ylab="F1 (z-score semitones)",
                   phone, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                   pch.means =phone, cex.means = 2, var.col.by = phone, pretty = TRUE, 
                   diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                   family = "Charis iSIL"))




# ==================================================================================
# error measurement
# ==================================================================================



fileERR = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\error-check-20190729-1806.csv"


# error for phonemes

err <- read.csv(file=fileERR, header=TRUE, sep=",")
err$type = "Other"
err$type[err$textInterval == "a" | err$textInterval == "e" | err$textInterval == "i" | err$textInterval == "o" | err$textInterval == "u"] = "Short vowels"
err$type[err$textInterval == "ax" | err$textInterval == "ex" | err$textInterval == "ix" | err$textInterval == "ox" | err$textInterval == "ux"] = "Long vowels"  #āēīōū
err$type[err$textInterval == "ng"] = "/ŋ/"
err$type[err$textInterval == "m" | err$textInterval == "n"] = "Other nasals"
#err$type[err$textInterval == "m" | err$textInterval == "n" | err$textInterval == "ng"] = "Nasal"
err$type[err$textInterval == "l" | err$textInterval == "r"] = "/ɾ/"
err$type[err$textInterval == "p" | err$textInterval == "t" | err$textInterval == "k"] = "Stops"
err$type[err$textInterval == "'" | err$textInterval == "êžŒ" | err$textInterval == "q" | err$textInterval == "Q"] = "Glottal Stop"
err$type[err$textInterval == "v"] = "/v/"
err = subset(err, type!="Other")
err$type = as.factor(err$type)
#err$type = factor(err$type,levels(err$type)[c(3,5,2,7,1,6,4)])
#err$type = factor(err$type,levels(err$type)[c(6,7,4,5,1,2,3)])
err$type = factor(err$type,levels(err$type)[c(3,5,2,8,6,7,1,4)])
err$type = factor(err$type,levels(err$type)[c(6,2,4,1,3,7,5,8)])
err$island = as.character(err$island)
err$island[err$island=="Atiu"] = "‘Atiu"
err$island[err$island=="Mauke"] = "Ma‘uke"
err$island = as.factor(err$island)
unique(err$type)
err$diffLenPerc = err$diffLenPerc*100
e = subset(err, diffLenPerc< 1000)

ggplot(e, aes(x=type, y=diffLenPerc)) + 
  geom_boxplot()+
  coord_cartesian(ylim = c(0,120))+
  facet_wrap( ~ island, ncol=2)

ggplot(e, aes(x=type, y=diffLenPerc)) +
  facet_wrap(~ island, ncol=2)+
  geom_boxplot()+
  labs(x ="", y = "Difference in the center of phones as percentage\nof the length of the hand-corrected phones")+
  coord_cartesian(ylim = c(0,170))

tapply(e$diffLenPerc, e$type, mean)
tapply(e$diffLenPerc, e$type, median)
tapply(e$endCorr, e$type, function(x) length(unique(na.omit(x))))

t=subset(e, type=="Short vowels")
t=subset(e, type=="Long vowels")
t=subset(e, type=="Stops")
t=subset(e, type=="/v/")
t=subset(e, type=="/ɾ/")
t=subset(e, type=="/ŋ/")
t=subset(e, type=="/ŋ/" | type=="Other nasals")
t=subset(e, type=="Glottal Stop")
mt = lm(t$diffLenPerc~t$island)
#mt = lm(t$diffLenPerc~t$island*t$type)
mt$df
summary(mt)
tapply(t$diffLenPerc, t$type, median)
tapply(t$endCorr, t$type, function(x) length(unique(na.omit(x))))

# error for words

err <- read.csv(file=fileERR, header=TRUE, sep=",")
err$diffLenPerc = err$diffLenPerc*100
err$island = as.character(err$island)
err$island[err$island=="Atiu"] = "‘Atiu"
err$island[err$island=="Mauke"] = "Ma‘uke"
err$island = as.factor(err$island)
e = subset(err, typeInterval=="word" & diffLenPerc<1000)
ggplot(e, aes(x=island, y=diffLenPerc)) + 
  coord_cartesian(ylim = c(0,100))+
  labs(x ="", y = "Difference in the center of words as\npercentage of the length of the word")+
  geom_boxplot()


tapply(e$diffLenPerc, e$island, mean)
tapply(e$diffLenPerc, e$island, median)
tapply(e$endCorr, e$island, function(x) length(unique(na.omit(x))))

mi = lm(e$diffLenPerc ~ e$island)
summary(mi)
mi$df
