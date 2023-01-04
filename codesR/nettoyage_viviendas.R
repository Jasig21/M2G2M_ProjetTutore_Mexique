rm(list=ls())

#---------------------
#P15
#---------------------
#import
readLines("Viviendas15.CSV", n=10)

P15 <- read.table("Viviendas15.CSV", sep=",", header=T)
P15

head(P15)
tail(P15)
dim(P15)
#1228485 lignes et 91 colonnes

#traitement
P15_select <- P15[,c(1:9,12,19,22,50,53,58,60,64,67,69,71,73:80)]
dim(P15_select)
#1228485 lignes et 52 colonnes

#export
write.csv(P15_select, file = "Viviendas15_selct_champs.csv")

#---------------------
#P13
#---------------------
#import
readLines("Personas13.CSV", n=10)

P13 <- read.table("Personas13.CSV", sep=",", header=T)
P13

head(P13)
tail(P13)
dim(P13)
#1228485 lignes et 91 colonnes

#traitement
P13_select <- P13[,c(1:10,12,13,17:22,24,39,41:44,47:49,51,54,56:59,61,66,74:77,80,81)]
dim(P13_select)
#1228485 lignes et 52 colonnes

#export
write.csv(P13_select, file = "Personas13_selct_champs.csv")

#---------------------
#P09
#---------------------
readLines("Personas09.CSV", n=10)

P09 <- read.table("Personas09.CSV", sep=",", header=T)
P09

head(P09)
tail(P09)
dim(P09)
#1228485 lignes et 91 colonnes

#traitement
P09_select <- P09[,c(1:10,12,13,17:22,24,39,41:44,47:49,51,54,56:59,61,66,74:77,80,81)]
dim(P09_select)
#1228485 lignes et 52 colonnes

#export
write.csv(P09_select, file = "Personas09_selct_champs.csv")

#---------------------
#fusion des Entite Fede
#---------------------
#import autres tables

#export table homogene
fullPersonas <- full_join(P15_select,P13_select,P09_select)
dim(fullPersonas)

write.csv(fullPersonas, file = "Personas_09_13_15_champs_selectionnes.csv")

#---------------------
#mettre a l'echelle de la ZMVM
#---------------------

