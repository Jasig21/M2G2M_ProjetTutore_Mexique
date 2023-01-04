rm(list=ls())

#---------------------
#P15
#---------------------
#import
readLines("Personas15.CSV", n=10)

P15 <- read.table("Personas15.CSV", sep=",", header=T)
P15

head(P15)
tail(P15)
dim(P15)
#1228485 lignes et 91 colonnes

#traitement
P15_select <- P15[,c(1:10,12,13,17:22,24,39,41:44,47:49,51,54,56:59,61,66,74:77,80,81)]
dim(P15_select)
#1228485 lignes et 52 colonnes

#export
write.csv(P15_select, file = "Personas15_selct_champs.csv")

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
#flemme de réécrire les variables communes, fait sur excel

#---------------------
# mettre a l'echelle de la ZMVM
#---------------------
#voir script ZMVM_code_MUN

# OUTPUT: Personas_ZMVM.csv 

