############################################################################
# Auteur : Anthony Carmichael                                               
# UQTR Méthodologie ECL1017-00                                              
# Projet: Liens entre la présence de grenouillette et mauvaise qualité d'eau                      
# Github: https://github.com/AnthonyCarmichael/projet_metho_grenouillette 
############################################################################

library(ggmap)
library(tidyverse)
library(dplyr)

# Set current dir relative to script as working dir
dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

# Step to put API KEY :
# 1. You need to put your API_KEY in .env.temp
# 2. You need to rename file .env.temp to .env
# Else script won't work : "Error : API KEY not found" 
readRenviron(".env")

API_KEY <- Sys.getenv("API_KEY")
if (API_KEY == FALSE || API_KEY == "") {
  stop("API KEY not found, check README.md")
} else if (API_KEY == "put_key_here") {
  stop("You need to put your API KEY in .env file, read README.md")
}
# Activation API KEY
#register_stadiamaps("test")
register_stadiamaps(API_KEY)
has_stadiamaps_key()
stadiamaps_key()

# load data
don_grenouillette <- read.csv("./data/Hydrocharide_grenouillette_fixed.csv",
                              sep = ";")
don_stations <- read.csv("./data/stations_p.csv",
                         sep = ";")
# Visualisation data
################################################################################
# station map                                                                  #
################################################################################
# bounding box
polygone <- c(left =min(don_stations$LONGITUDE),
              bottom = min(don_stations$LATITUDE),
              right = max(don_stations$LONGITUDE),
              top = max(don_stations$LATITUDE))

# get backgroud map from stadiamap
fond <- get_stadiamap(bbox=polygone, zoom=6,
                      maptype="stamen_toner_lite")
ggmap(fond)

sum_quality_mean_station <- don_stations |>
  filter(ANNEE >= 2000 & ANNEE <= 2025) |>
  summarise(.by = c(NO_BQMA, LONGITUDE, LATITUDE),
            nb = n(),
            quality_mean = mean(IQBP_MOY,na.rm = TRUE))

carte_quality <-ggmap(fond) +
  geom_point(data = sum_quality_mean_station,
             alpha=0.5,
             aes(LONGITUDE,LATITUDE,
                 color = quality_mean)) +
  theme_classic()+
  labs(color = "Qualité de l'eau")
carte_quality

ggsave('./output/qualite_eau.pdf',
       carte_quality,width=6,height=3)


################################################################################
# observations Hydrocharis morsus-ranae L.                                     #
################################################################################

sum_grenouillette_filter <- don_grenouillette |>
  filter(year >= 2000 & year <= 2025)
  
carte_grenouillette <-ggmap(fond) +
  geom_point(data = sum_grenouillette_filter,
             aes(decimalLongitude,decimalLatitude),
             color = "aquamarine3", size=3,alpha=0.5)+
  theme_classic()

carte_grenouillette
ggsave('./output/repartition_grenouillette.pdf',
       carte_grenouillette,width=6,height=3)

citation("ggmap")
citation("tidyverse")
citation("dplyr")


