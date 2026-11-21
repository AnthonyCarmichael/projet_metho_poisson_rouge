############################################################################
# Auteur : Anthony Carmichael                                               
# UQTR Méthodologie ECL1017-00                                              
# Projet: Impact du poisson rouge sur la biodiversité                      
# Github: https://github.com/AnthonyCarmichael/projet_metho_poisson_rouge
############################################################################

library(ggmap)
library(tidyverse)

# Set current dir relative to script as working dir
dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

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
don <- read.csv("./data/BD_EAE_faunique_Quebec.csv")

don_poissons_rouges <- don |> 
  filter(don$especes == 'Carassius auratus')

# bounding box
polygone <- c(left =-75.7 , bottom = 45.0 , right =-68.8 , top = 48.5 )

# get backgroud map from stadiamap
fond <- get_stadiamap(bbox=polygone, zoom=7,
                      maptype="stamen_terrain")
ggmap(fond)
carte <-ggmap(fond) + geom_point(data = don_poissons_rouges, aes(longitude,latitude),color = "red", size=2,alpha=0.5) + theme_classic()
carte

ggsave('./output/carte_repartition_region.pdf',
       carte,width=6,height=3)
# Citations
citation("ggmap")
