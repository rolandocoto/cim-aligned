library(phonR)
library(ggplot2)
library(hqmisc)


# =================================
# Functions
# =================================


prepareDF = function(dfIn, typeOfSound) {
  
  if (typeOfSound=="vowel") {
    out = subset(dfIn, phone == "a" | phone == "e" | phone == "i" | phone == "o" | phone == "u" |
                      phone == "ax" | phone == "ex" | phone == "ix" | phone == "ox" | phone == "ux")
  }
  else if (typeOfSound=="diphthong") {
    out = subset(dfIn, type == "diphthong")
  }
  out$TextGridLabel = as.factor(as.character(out$TextGridLabel))
  out$phone = as.factor(as.character(out$phone))
  unique(out$TextGridLabel)
  unique(out$phone)
  
  # Create additional information 
  out$island = "Mangaia"  # EDS1PiriMarearai20150529HSB
  out$island[out$Filename=="atiu-targetWords-20171029"] = "‘Atiu"
  out$island[out$Filename=="20170907TiareA-tangata"] = "‘Atiu"
  out$island[out$Filename=="EMM20160413MuseumWordStressZ"] = "Ma‘uke"
  out$island[out$Filename=="ETauRongo20160414HSBNWS"] = "Rarotonga"
  out$island[out$Filename=="ETauRongo20160414HSBSentences"] = "Rarotonga"
  out$island[out$Filename=="glottals-aitutaki-20170829-1447"] = "Aitutaki"
  out$island[out$Filename=="20170829EGlAna"] = "Aitutaki"
  out$island[out$Filename=="KoNgaeTaRima"] = "Rarotonga"
  out$island[out$Filename=="SATN_Election_2011_A_CIM"] = "Rarotonga"
  out$island = as.factor(out$island)
  unique(out$Filename)
  
  if (typeOfSound=="vowel") {
    out$vLength = "long"
    out$vLength[out$TextGridLabel=="a" | out$TextGridLabel=="e" | out$TextGridLabel=="i" | out$TextGridLabel=="o" | out$TextGridLabel=="u"] = "short"
    out$frontingGroup="Fronted /u/"
    out$frontingGroup[out$island=="Ma‘uke"]="Back /u/"
    out$frontingGroup[out$island=="‘Atiu"]="Back /u/"
    unique(out$island)
    out$segment = "a"
    out$segment[out$phone == "a" | out$phone == "ax"] = "a" #ā
    out$segment[out$phone == "e" | out$phone == "ex"] = "e" #ē
    out$segment[out$phone == "i" | out$phone == "ix"] = "i" #ī
    out$segment[out$phone == "o" | out$phone == "ox"] = "o" #ō
    out$segment[out$phone == "u" | out$phone == "ux"] = "u" #ū
    out$segment = as.factor(out$segment)
    unique(out$segment)
    unique(out$frontingGroup)
  }
  
  
  out$start = as.numeric(as.character(out$start))
  out$duration = as.numeric(as.character(out$duration))
  
  out = subset(out, duration > 0.005)
  
  # normalization ============================
  
  # conversion to semitones
  out$logf1 = f2st( out$F1_midpoint, base=50 )
  out$logf2 = f2st( out$F2_midpoint, base=50 )
  
  if (typeOfSound=="diphthong") {
    out$next_logf1 = f2st( out$next_F1_midpoint, base=50 ) 
    out$next_logf2 = f2st( out$next_F2_midpoint, base=50 ) 
  }
  
  # yes, i know i shouldn't have loops in R. bite me.
  files = unique(out$Filename)
  if (typeOfSound=="vowel") {
    for(i in files){
      out$meanLogF1[out$Filename==i] = mean(out$logf1[out$Filename==i])
      out$sdLogF1[out$Filename==i]   = sd(out$logf1[out$Filename==i])
      out$meanLogF2[out$Filename==i] = mean(out$logf2[out$Filename==i])
      out$sdLogF2[out$Filename==i]   = sd(out$logf2[out$Filename==i])
    }
    out$zf1 = (out$logf1-out$meanLogF1) / out$sdLogF1
    out$zf2 = (out$logf2-out$meanLogF2) / out$sdLogF2
  }
  else if (typeOfSound=="diphthong") {
    for(i in files){
      out$meanLogF1[out$Filename==i] = mean(c(out$logf1[out$Filename==i],out$next_logf1[out$Filename==i]))
      out$sdLogF1[out$Filename==i] = sd(c(out$logf1[out$Filename==i],out$next_logf1[out$Filename==i]))
      out$meanLogF2[out$Filename==i] = mean(c(out$logf2[out$Filename==i],out$next_logf2[out$Filename==i]))
      out$sdLogF2[out$Filename==i] = sd(c(out$logf2[out$Filename==i],out$next_logf2[out$Filename==i]))
    }
    out$zf1 = (out$logf1-out$meanLogF1) / out$sdLogF1
    out$zf2 = (out$logf2-out$meanLogF2) / out$sdLogF2
    out$next_zf1 = (out$next_logf1-out$meanLogF1) / out$sdLogF1
    out$next_zf2 = (out$next_logf2-out$meanLogF2) / out$sdLogF2
  }
  
  unique(out$meanLogF1)
  
  return(out)
    
}

plotDiphthong = function(dfIn, diphthong, islands, rowsCols) {
  par(mfrow=rowsCols)
  for(i in islands){
    d = subset(diph, phone==diphthong)
    d = subset(d, island==i)
    with(d, plotVowels(cbind(zf1, next_zf1), cbind(zf2, next_zf2),
                       main=i,
                       xlim=c(1.5,-2.5),ylim=c(2,-2),
                       xlab="F2 (z-score semitones)",
                       ylab="F1 (z-score semitones)",
                       phone, plot.tokens = TRUE, pch.tokens = NA, alpha.tokens = 0.2, plot.means = TRUE, 
                       pch.means =phone, cex.means = 2, var.col.by = phone, pretty = TRUE, 
                       diph.arrows = TRUE, diph.args.tokens = list(lwd = 0.8), diph.args.means = list(lwd = 3), 
                       family = "Charis iSIL"))
  }
  par(mfrow=c(1,1))
}


# =================================
# Read the vowels
# =================================

fileCIM = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\cim-vowels-20190729-1437.csv"
cim <- read.csv(file=fileCIM, header=TRUE, sep=",")

fileUncorr = "C:\\Users\\Bender\\Desktop\\rolando\\universidad\\dartmouth\\research\\201907 cim vowels\\cim-vowels-uncorrected-20190807-0033.csv"
unc <- read.csv(file=fileUncorr, header=TRUE, sep=",")

vowels = prepareDF(cim, "vowel")
uncV   = prepareDF(unc, "vowel")
vowels$corrType = "Corrected"
uncV$corrType   = "Not corrected"
allV = rbind(vowels, uncV)

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
                      #col = c("blue", "orange", "red", "red4", "lightslateblue"),
                      col = c("black", "black", "black", "grey", "grey"), 
                      #lty = c("solid", "dotdash", "solid", "dotted", "dashed")
                      lty = c("solid", "dotted", "dashed", "solid", "dotted")
                   ))






#frontingAndBackGroup

par(mfrow=c(1,2))
s = subset(vowels, vLength=="short")
#s = subset(vowels, vLength=="Long")
sSub = subset(s, frontingGroup=="Back /u/")
with(sSub, plotVowels(zf1, zf2, phone, group = island, var.col.by = island, var.sty.by = island, 
                   main = "Unfronted /u/",
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
                   main = "Fronted /u/",
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
par(mfrow=c(1,1))



s$phone = as.factor(as.character(s$phone))
unique(s$island)
table(s$phone, s$island)


# ===================================================
# Long vowels
# ===================================================


s = subset(vowels, vLength=="long")

s$phone = as.character(s$phone)
s$phone[s$phone=="ax"]="aː"#"ā"
s$phone[s$phone=="ex"]="eː"#"ē"
s$phone[s$phone=="ix"]="iː"#"ī"
s$phone[s$phone=="ox"]="oː"#"ō"
s$phone[s$phone=="ux"]="uː"#"ū"
s$phone = as.factor(s$phone)
unique(s$phone)

s$phone = as.factor(as.character(s$phone))
unique(s$island)
table(s$phone, s$island)

# combinations for which there aren't enough tokens
s = subset(s, !(phone=="iː" & island=="‘Atiu") )
s = subset(s, !(phone=="iː" & island=="Rarotonga") )
s = subset(s, !(phone=="oː" & island=="‘Atiu") )
s = subset(s, !(phone=="uː" & island=="Mangaia") )


# all together
with(s, plotVowels(zf1, zf2, phone, group = island, var.col.by = island, var.sty.by = island, 
                   #main = "Vowel triangle for short vowels",
                   plot.tokens = FALSE, plot.means = TRUE, pch.means = phone, cex.means = 2, pretty = TRUE, 
                   #xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                   xlim=c(2,-2.1),ylim=c(2,-2),
                   poly.line = TRUE, 
                   #poly.order = c("i", "e", "a", "o", "u"), 
                   #poly.order = c("ix", "ex", "ax", "ox", "ux"),
                   poly.order = c("iː", "eː", "aː", "oː", "uː"), 
                   #poly.order = c("Ä«", "Ä", "Ä", "Å", "Å«"), 
                   xlab="F2 (z-score semitones)",
                   ylab="F1 (z-score semitones)",
                   legend.kwd = "bottomleft", 
                   legend.args = list(seg.len = 2, cex = 1.2, lwd = 2),
                   #col = c("blue", "orange", "red", "red4", "lightslateblue"),
                   col = c("black", "black", "black", "grey", "grey"), 
                   #lty = c("solid", "dotdash", "solid", "dotted", "dashed")
                   lty = c("solid", "dotted", "dashed", "solid", "dotted")
))

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

#=========================================================================================
# Compare corrected and uncorrected
#=========================================================================================


s = subset(allV, vLength=="short")
s = subset(allV, vLength=="long")
s = subset(allV, vLength=="short" & (island=="Rarotonga" | island=="Aitutaki" | island=="Mangaia"))
s = subset(allV, vLength=="short" & (island=="Atiu" | island=="Ma'uke"))

unique(s$corrType)
#s = subset(s, island=="Rarotonga" & corrType=="Not corrected")
s = subset(s, island=="Mangaia")
# ‘Atiu Ma‘uke

# all together
with(s, plotVowels(zf1, zf2, phone, group = corrType, var.col.by = corrType, var.sty.by = corrType, 
                   main = "Mangaia",
                   plot.tokens = FALSE, plot.means = TRUE, pch.means = phone, cex.means = 2, pretty = TRUE, 
                   xlim=c(1.5,-1.5),ylim=c(1.5,-1.5),
                   xlim=c(2,-2.1),ylim=c(2,-2),
                   poly.line = TRUE, 
                   poly.order = c("i", "e", "a", "o", "u"), 
                   #poly.order = c("ix", "ex", "ax", "ox", "ux"), 
                   #poly.order = c("Ä«", "Ä", "Ä", "Å", "Å«"), 
                   xlab="F2 (z-score semitones)",
                   ylab="F1 (z-score semitones)",
                   legend.kwd = "bottomleft", 
                   legend.args = list(seg.len = 2, cex = 1.2, lwd = 2),
                   #col = c("blue", "orange", "red", "red4", "lightslateblue"),
                   col = c("black", "black", "black", "grey", "grey"), 
                   #lty = c("solid", "dotdash", "solid", "dotted", "dashed")
                   lty = c("solid", "dashed", "dashed", "solid", "dotted")
))



# ========================================================================================
# Diphthongs
# ========================================================================================

diph = prepareDF(cim, "diphthong")

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



plotDiphthong(diph, "au", c("‘Atiu", "Aitutaki", "Ma‘uke", "Rarotonga"), c(2,2))
plotDiphthong(diph, "ua", c("Aitutaki", "Mangaia", "Rarotonga"), c(1,3))
plotDiphthong(diph, "ou", c("‘Atiu", "Mangaia", "Rarotonga"), c(1,3))

plotDiphthong(diph, "ia", c("‘Atiu", "Aitutaki", "Ma‘uke", "Rarotonga"), c(2,2))
plotDiphthong(diph, "ei", c("‘Atiu", "Ma‘uke", "Mangaia", "Rarotonga"), c(2,2))
plotDiphthong(diph, "ai", c("Aitutaki", "Mangaia"), c(1,2))



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
