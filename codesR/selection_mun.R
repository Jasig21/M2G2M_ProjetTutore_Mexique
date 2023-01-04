#Code_MUN de la ZMVM
#Ciudad
09002:09017
#Hidalgo
13069
#Mexico
15002, 15009:15011, 15013, 15015:15017, 15020, 15022:15025,15028:15031,
15033:15039, 15044, 15046, 15050, 15053, 15057:15061, 15065, 15068:15070,
15075, 15081, 15083, 15084, 15089, 15091:15096, 15099, 15100, 15103, 15104, 
15108, 15109, 15112, 15120:15122, 15125


#script utilisé pour séléctionner les code MUN mais avec leur position
install.packages('dplyr')
library(dplyr)

#conserve MUN de ZMVM
ZMVM_V15 <- filter(V15_select, MUN %in% c(2,9:11,13,15:17,20,22:25,28:31,
                                          33:39,44,46,50,53,57:61,65,68:70,
                                          75,81,83,84,89,91:96,99,100,103,104, 
                                          108,109,112,120:122,125))

write.csv2(ZMVM_V15, file = "Viviendas15_ZMVM.csv")

P15_select <- read.table("Personas15_selct_champs.csv", sep=",", header=T)

ZMVM_P15 <- filter(P15_select, MUN %in% c(2,9:11,13,15:17,20,22:25,28:31,
                                          33:39,44,46,50,53,57:61,65,68:70,
                                          75,81,83,84,89,91:96,99,100,103,104, 
                                          108,109,112,120:122,125))

write.csv2(ZMVM_P15, file = "Personas15_ZMVM.csv")
