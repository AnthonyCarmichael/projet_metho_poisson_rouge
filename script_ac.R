############################################################################
# Auteur : Anthony Carmichael                                               
# UQTR Méthodologie ECL1017-00                                              
# Projet: Impact du poisson rouge sur la biodiversité                      
# Github: https://github.com/AnthonyCarmichael/projet_metho_poisson_rouge
############################################################################

# Set current dir relative to script as working dir
dir <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(dir)

don <- read.csv("./data/BD_EAE_faunique_Quebec.csv")

# get key with 
