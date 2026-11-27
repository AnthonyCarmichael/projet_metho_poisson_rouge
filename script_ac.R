############################################################################
# Auteur : Anthony Carmichael                                               
# UQTR Méthodologie ECL1017-00                                              
# Projet:                      
# Github: 
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
don <- read.csv("./data/BD_EAE_faunique_Quebec.csv")










################################################################################
# Vestige                                                                      #
################################################################################
# 1. Dispertion map

# 
# don$date <- as.Date(don$date, format="%Y-%m-%d")
# don <- don |> 
#   mutate(annee = as.numeric(format(date,"%Y")))
# 
# don_poissons_rouges <- don |> 
#   filter(especes == 'Carassius auratus')
# 
# 
# 
# # bounding box
# polygone <- c(left =-75.7 , bottom = 45.0 , right =-68.8 , top = 48.5 )
# 
# # get backgroud map from stadiamap
# fond <- get_stadiamap(bbox=polygone, zoom=7,
#                       maptype="stamen_terrain")
# ggmap(fond)
# carte <-ggmap(fond) + 
#   geom_point(data = don_poissons_rouges, 
#              aes(longitude,latitude),
#              color = "red", size=1,alpha=0.5) +
#   theme_classic()
# carte
# 
# ggsave('./output/carte_repartition_region.pdf',
#        carte,width=6,height=3)
# 
# ################################################################################
# # 2. Worst localisation
# #
# # Del no names pond
# don_poissons_rouges <- don_poissons_rouges |>
#   filter(nom_plan_eau != "Sans Nom, Étang")
# 
# # Keep only worst localisation
# sum_don_poissons_rouges <- don_poissons_rouges  |>
#   group_by(nom_plan_eau) |>
#   mutate(n_observations_in_area = n()) |>
#   ungroup() |>
#   filter(n_observations_in_area == max(n_observations_in_area))
# 
# # bounding box
# polygone <- c(left =-73.7 , bottom = 45.4 , right =-73.5 , top = 45.6 )
# 
# # get backgroud map from stadiamap
# fond <- get_stadiamap(bbox=polygone, zoom=10,
#                       maptype="stamen_terrain")
# ggmap(fond)
# carte <-ggmap(fond) + 
#   geom_point(data = sum_don_poissons_rouges, 
#              aes(longitude,latitude),
#              color = "red", size=1,alpha=0.5) +
#   theme_classic()
# carte
# ggsave('./output/carte_lac_castor_mtl.pdf',carte,width=4,height=4)
# 
# ###############################################################################
# # 3. Growth
# #
# 
# # Group data by year
# nb_by_year <- don_poissons_rouges |> group_by(annee) |>
#   summarise(nb = n()) 
# 
# # nb by year drop data without dates
# graph <- nb_by_year |> drop_na() |>
#   ggplot(mapping = aes(x = annee,y = nb)) + 
#   geom_point () + 
#   theme_bw() + labs(
#     x = "Année",
#     y = "Observations de poissons rouges au Québec"
#   ) + geom_line()
# ggsave('./output/graph_croissance_observations_qc.pdf',graph,width=6,height=4)
# 
# ################################################################################
# # most commun observed species in montreal from 2020 - 2025 
# #
# most_commun_species_in_mtl <- don |>
#   filter(region == "Montréal" & annee>=2020 & annee <= 2025) |>
#   group_by(nom_commun) |>
#   mutate(nb = n()) |>
#   ungroup() 
#   #filter(nb >= 10)
# 
# graph2 <- most_commun_species_in_mtl |>
#   ggplot(mapping = aes(x = reorder(nom_commun,-nb))) + 
#   geom_bar()+
#   theme_bw() + labs(
#     x = "Nom commun",
#     y = "Observations")
# graph2
# ggsave('./output/graph_distribution_especes_mtl_2020_2025.pdf',graph2,width=12,height=4)

# Citations :
citation("ggmap")
