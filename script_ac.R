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
don <- read.csv("./data/BD_EAE_faunique_Quebec.csv")

don_poissons_rouges <- don |> 
  filter(especes == 'Carassius auratus')

################################################################################
# 1. Dispertion map

# bounding box
polygone <- c(left =-75.7 , bottom = 45.0 , right =-68.8 , top = 48.5 )

# get backgroud map from stadiamap
fond <- get_stadiamap(bbox=polygone, zoom=7,
                      maptype="stamen_terrain")
ggmap(fond)
carte <-ggmap(fond) + 
  geom_point(data = don_poissons_rouges, aes(longitude,latitude),color = "red", size=1,alpha=0.5) +
  theme_classic()
carte

ggsave('./output/carte_repartition_region.pdf',
       carte,width=6,height=3)

################################################################################
# 2. Worst localisation
#
# Del no names pond
don_poissons_rouges <- don_poissons_rouges |>
  filter(nom_plan_eau != "Sans Nom, Étang")

# Keep only worst localisation
sum_don_poissons_rouges <- don_poissons_rouges  |>
  group_by(nom_plan_eau) |>
  mutate(n_observations_in_area = n()) |>
  ungroup() |>
  filter(n_observations_in_area == max(n_observations_in_area))

# bounding box
polygone <- c(left =-73.7 , bottom = 45.4 , right =-73.5 , top = 45.6 )

# get backgroud map from stadiamap
fond <- get_stadiamap(bbox=polygone, zoom=10,
                      maptype="stamen_terrain")
ggmap(fond)
carte <-ggmap(fond) + 
  geom_point(data = sum_don_poissons_rouges, aes(longitude,latitude),color = "red", size=1,alpha=0.5) +
  theme_classic()
carte
ggsave('./output/carte_lac_castor_mtl.pdf',
       carte,width=4,height=4)
# Citations :
citation("ggmap")
