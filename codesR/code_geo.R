rm(list=ls())

#import library
install.packages("purrr")
install.packages("plyr")
install.packages("readr")
library(stringr)
library(dplyr)
library(ggplot2)
library("purrr")
library("plyr")
library("readr")

#import du csv
df_bles <- read.table("blessure.csv",sep=";", header=T)
df_dc <- read.table("droit_commun.csv",sep=";", header=T)
df_ext <- read.table("extorsion.csv",sep=";", header=T)
df_sec <- read.table("secuestro.csv",sep=";", header=T)
df_vf <- read.table("violence_familliale.csv",sep=";", header=T)
df_vol <- read.table("vol.csv",sep=";", header=T)
df_homgv <- read.table("homicide_gouv.csv", sep=";", header=T)
df_femgv <- read.table("feminicide_gouv.csv", sep=";", header=T)
df_hf <- read.table("hf.csv", sep=";", header=T)

# Verifier si les mun sont bons
head(df_homgv)
head(df_dc)

# si les codes mun n'ont pas tous une longueur de 5, on ajoute 0
mun_bles <- str_pad(df_bles$Cve..Municipio, 5, pad = "0")
df_bles$Cve..Municipio <- mun_bles

mun_dc <- str_pad(df_dc$Cve..Municipio, 5, pad = "0")
df_dc$Cve..Municipio <- mun_dc

mun_ext <- str_pad(df_ext$Cve..Municipio, 5, pad = "0")
df_ext$Cve..Municipio <- mun_ext

mun_sec <- str_pad(df_sec$Cve..Municipio, 5, pad = "0")
df_sec$Cve..Municipio <- mun_sec

mun_vf <- str_pad(df_vf$Cve..Municipio, 5, pad = "0")
df_vf$Cve..Municipio <- mun_vf

mun_vol <- str_pad(df_vol$Cve..Municipio, 5, pad = "0")
df_vol$Cve..Municipio <- mun_vol

mun_homgv <- str_pad(df_homgv$Cve..Municipio, 5, pad = "0")
df_homgv$Cve..Municipio <- mun_homgv

mun_femgv <- str_pad(df_femgv$Cve..Municipio, 5, pad = "0")
df_femgv$Cve..Municipio <- mun_femgv

mun_hf <- str_pad(df_hf$mun, 5, pad = "0")
df_hf$mun <- mun_hf

#on aggrège les données sommées par mun
df_bles_aggreg <- aggregate(df_bles$Somme,by = list(df_bles$Cve..Municipio), FUN=sum, row = FALSE)
df_dc_aggreg <- aggregate(df_dc$Somme,by = list(df_dc$Cve..Municipio), FUN=sum, row = FALSE)
df_ext_aggreg <- aggregate(df_ext$Somme,by = list(df_ext$Cve..Municipio), FUN=sum, row = FALSE)
df_sec_aggreg <- aggregate(df_sec$Somme,by = list(df_sec$Cve..Municipio), FUN=sum, row = FALSE)
df_vf_aggreg <- aggregate(df_vf$Somme,by = list(df_vf$Cve..Municipio), FUN=sum, row = FALSE)
df_vol_aggreg <- aggregate(df_vol$Somme,by = list(df_vol$Cve..Municipio), FUN=sum, row = FALSE)
df_homgv_aggreg <- aggregate(df_homgv$Somme,by = list(df_homgv$Cve..Municipio), FUN=sum, row = FALSE)
df_femgv_aggreg <- aggregate(df_femgv$Somme,by = list(df_femgv$Cve..Municipio), FUN=sum, row = FALSE)



#on renomme les col
df_bles_aggreg <- rename(df_bles_aggreg, mun = Group.1,
                  bles_s = x
                  )

df_dc_aggreg <- rename(df_dc_aggreg, mun = Group.1,
                dc_s = x
                )

df_ext_aggreg <- rename(df_ext_aggreg, mun = Group.1,
                         ext_s = x
)

df_sec_aggreg <- rename(df_sec_aggreg, mun = Group.1,
                         sec_s = x
)

df_vf_aggreg <- rename(df_vf_aggreg, mun = Group.1,
                         vf_s = x
)

df_vol_aggreg <- rename(df_vol_aggreg, mun = Group.1,
                       vol_s = x
)

df_homgv_aggreg <- rename(df_homgv_aggreg, mun = Group.1,
                        homgv_s = x
)

df_femgv_aggreg <- rename(df_femgv_aggreg, mun = Group.1,
                          femgv_s = x
)

#on créer un df qui regroupe hom et fem pour les données du gouv
df_hfgv_aggreg <-  data.frame(df_femgv_aggreg$mun,df_homgv_aggreg$homgv_s + df_femgv_aggreg$femgv_s)

#on renomme les champs de ce nouveau df
df_hfgv_aggreg <- rename( df_hfgv_aggreg, mun = df_femgv_aggreg.mun ,
                          hfgv_s = df_homgv_aggreg.homgv_s...df_femgv_aggreg.femgv_s
)


#on calcul la part pour 100 000 hab
df_bles_aggreg$bles_phab <- df_bles_aggreg$bles_s / 21804515 * 100000
df_dc_aggreg$dc_phab <- df_dc_aggreg$dc_s / 21804515 * 100000
df_ext_aggreg$ext_phab <- df_ext_aggreg$ext_s / 21804515 * 100000
df_sec_aggreg$sec_phab <- df_sec_aggreg$sec_s / 21804515 * 100000
df_vf_aggreg$vf_phab <- df_vf_aggreg$vf_s / 21804515 * 100000
df_vol_aggreg$vol_phab <- df_vol_aggreg$vol_s / 21804515 * 100000
df_homgv_aggreg$homgv_phab <- df_homgv_aggreg$homgv_s / 21804515 * 100000
df_femgv_aggreg$femgv_phab <- df_femgv_aggreg$femgv_s / 21804515 * 100000
df_hfgv_aggreg$hfgv_phab <- df_hfgv_aggreg$hfgv_s / 21804515 * 100000
df_hf$hom_phab <- df_hf$hom_s / 21804515 * 100000
df_hf$fem_phab <- df_hf$fem_s / 21804515 * 100000
df_hf$hf_phab <- df_hf$hf_s / 21804515 * 100000

#on récupère les données qui nous interessent dans un nouveau df
df_hf_aggreg <- data.frame(df_hf$mun, df_hf$hf_s, df_hf$hf_phab)

#on renomme les colonnes
df_hf_aggreg <- rename(df_hf_aggreg, 
                       mun = df_hf.mun,
                       hf_s = df_hf.hf_s,
                       hf_phab = df_hf.hf_phab
)

head(df_hf_aggreg)

#export en csv
write.csv(df_bles_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "bles_aggreg.csv")

write.csv(df_dc_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "dc_aggreg.csv")

write.csv(df_ext_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "bles_ext.csv")

write.csv(df_sec_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "sec_aggreg.csv")

write.csv(df_vf_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "vf_aggreg.csv")

write.csv(df_vol_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "vol_aggreg.csv")

write.csv(df_homgv_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "homgv_aggreg.csv")

write.csv(df_femgv_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "femgv_aggreg.csv")

write.csv(df_hfgv_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "hfgv_aggreg.csv")

write.csv(df_hf_aggreg,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "hf_aggreg.csv")

#Jointure
bd_crime <- list.files(path = "C:/Users/Enora/Documents/M2G2M/mexico/stat_ini/stat_ini/csv",
                        pattern = "*.csv", full.names = TRUE) %>% 
                        lapply(read_csv) %>%                              
                        reduce(full_join, by = "mun")
bd_crime 
  
write.csv(bd_crime,
          row.names=F,
          fileEncoding = "UTF-8",
          file = "bd_crime.csv")

#création d'un histogramme
ggplot(df_bles_aggreg, aes(x = df_bles_aggreg$bles_phab)) + 
  geom_histogram(colour = 4, 
                 fill = "white", 
                 bins = 15
                 )
