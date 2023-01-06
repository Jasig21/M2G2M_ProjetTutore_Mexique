rm(list=ls())

#install.packages("corrplot")
#install.packages("devtools")
#install.packages("rmarkdown")
#install.packages("FactoInvestigate")
# devtools::install_github("diegovalle/mxmaps")
#library(mxmaps)
#install.packages("reshape")
library("corrplot")
library(stringr)
library(Hmisc)
library("rmarkdown")
library(FactoInvestigate)
library("FactoMineR")
library("NbClust")
library(cluster)
library(FactoClass)
library(ade4)
library(ggplot2)
library(scales)
library(reshape)
#pandoc_available(version = NULL, error = FALSE)
#pandoc_version()

# On importe le tableau en csv
dfc <- read.table("crime_phab.csv",sep=";", header=T)
head(dfc)

# Longueur de 5 pour tous les codes mun
mun <- str_pad(dfc$mun, 5, pad = "0")
dfc$mun <- mun

# Passage en index des codes mun pour ne pas gêner lors des traitements
row.names(dfc) <- dfc[,1]
dfc <- dfc[,-1] 

#---------------
# BIVARIEE
#---------------

# Création d'une matrice de corrélation
MC <- cor(dfc)
head(round(MC,4))

#Visualisation de la matrice en integer et en couleur
corrplot(MC, method="number")
# Tout est fortement corrélé à l'exception des logements précaires

#test de la significativité des résultats (p-value)
rcorr(MC, type=c("pearson","spearman"))
rcorr(as.matrix(MC))

#---------------
# MULTIVARIEE
#---------------

### On prépare les données pour les analyses multivariée
# On commence par centrer-réduire les variables
dfc_multi <- data.frame(bles_phab=scale(dfc$bles_phab),
                        dc_phab=scale(dfc$dc_phab), 
                        hfgv_phab=scale(dfc$hfgv_phab), 
                        sec_phab=scale(dfc$sec_phab),
                        vf_phab=scale(dfc$vf_phab),
                        vol_phab=scale(dfc$vol_phab)
                        )


### On calcul une matrice des distances
# On affiche tous les résultats sous forme de matrice
# Les valeurs sont arrondies 2 chiffres après la virgule
matMultiCri <- as.matrix(round(dist(dfc_multi),2))

# On affiche les résultats
as.matrix(round(dist(dfc_multi),2))

# Si 0 forte ressemblance si 9 faible ressemblance
range(matMultiCri)

#--------------- ACP ---------------#

### SOCIODEMO ###

ACPc <- princomp(dfc_multi, cor = TRUE)

summary(ACPc)
attributes(ACPc)

VarEx <- (ACPc$sdev^2 / sum(ACPc$sdev^2))*100

plot(VarEx, xlab="Comp", ylab="% variance") 

loadings(ACPc)

PC1 <- ACPc$scores[,1] ; round(PC1, 2); range(round(PC1, 2))

PC2 <- ACPc$scores[,2] ; round(PC2, 2)

range(PC1)

## Verification
cor(dfc_multi, PC1)
cor(dfc_multi, PC2)

#ACP
res.dfc.pca <- PCA(dfc,
                   quanti.sup=NULL,
                   quali.sup=NULL,
                   ncp = 6,
                   scale.unit = TRUE,
                   graph = TRUE,
                   )

#la fonction Investigate fait un rapport des résultat de l'ACP sous format html stocké dans le wd
Investigate(res.dfc.pca)

ACP1 <- data.frame(mun,PC1)
ACP2 <- data.frame(mun,PC2)

write.csv(ACP1,
          fileEncoding = "UTF-8",
          row.names=F,
          file = "crime_ACP1.csv")

write.csv(ACP2,
          fileEncoding = "UTF-8",
          row.names=F,
          file = "crime_ACP2.csv")

#--------------- CAH APRES ACP ---------------#
res.hcpc <- HCPC(res.dfc.pca, graph = FALSE)

fviz_dend(res.hcpc, 
          cex = 0.7,                     # Taille du text
          palette = "jco",               # Palette de couleur ?ggpubr::ggpar
          rect = TRUE, rect_fill = TRUE, # Rectangle autour des groupes
          rect_border = "jco",           # Couleur du rectangle
          labels_track_height = 0.8      # Augment l'espace pour le texte
)

fviz_cluster(res.hcpc,
             repel = TRUE,            # Evite le chevauchement des textes
             show.clust.cent = TRUE, # Montre le centre des clusters
             palette = "jco",         # Palette de couleurs, voir ?ggpubr::ggpar
             ggtheme = theme_minimal(),
             main = "Factor map"
)

# Principal components + tree
plot(res.hcpc, choice = "3D.map")

# Variables quantitatives décrivant le plus chaque cluster:
head(res.hcpc$data.clust, 10)

# On récupère les classes de la cah
crimecah <- data.frame(res.hcpc$data.clust)
#remet mun dedans
crimecah <- rownames_to_column(crimecah, var = "mun") %>% as_tibble()

#Justification du nombre de classes choisis
res <- NbClust(dfc_multi, distance = "euclidean", min.nc = 2, max.nc = 8, method = "complete",
               index = "alllong")

write.csv(crimecah,
          fileEncoding = "UTF-8",
          row.names=F,
          file = "crime_CAH.csv")

#--------------- CAH ---------------#

#ecntrée réduite
dfscale <- scale(dfc)
cahCSP <- agnes(dfscale, 
                metric = "euclidean",
                method = "complete")

library(cluster)
library(FactoClass)
library(ade4)
library(ggplot2)
library(scales)
library(reshape)
###
clusCSP <- cutree(cahCSP, k = 3)
dfscale <- as.data.frame(dfscale)
dfscale$CLUSCSP <- factor(clusCSP,
                          levels = 1: 3,
                          labels = paste("CLUS", 1: 3))


clusProfile <- aggregate(dfscale,
                         by = list(dfscale$CLUSCSP),
                         mean)

clusProfile <- subset(clusProfile, select = -c(CLUSCSP))
                     
#install.packages("FactoClass")
colnames(clusProfile)[ 1] <- "CLUSTER"
clusLong <- melt(clusProfile, id.vars = "CLUSTER")

ggplot(clusLong) +
  geom_bar(aes(x = variable, y = value, fill = CLUSTER),
           stat = "identity") +
  scale_fill_grey() +
  facet_wrap(~ CLUSTER) +
  coord_flip() + theme_bw()


