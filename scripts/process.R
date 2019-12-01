#Process


rm(list=ls()) # Fjerner alle matriser


# Pakker ------------------------------------------------------------------
library(tidyverse)
library(DBI)
library(RMariaDB)
library(data.table)
library(jsonlite)


# Passwords ---------------------------------------------------------------


id = fromJSON("~/prosjekter/bomstasjoner/scripts/keys.json")$id  
pw = fromJSON("~/prosjekter/bomstasjoner/scripts/keys.json")$pw


URL <- "http://hotell.difi.no/download/vegvesen/bomstasjoner?download"
bom <- fread(URL)



# Tilpasse ----------------------------------------------------------------

bom <- bom %>%
  select(everything(), Longitude = long,Latitude = lat)



# Laste inn data ----------------------------------------------------------



con <- dbConnect(RMariaDB::MariaDB(),
                 user= id, password= pw,
                 dbname="bom", host="localhost")


dbWriteTable(con, "bom", bom, overwrite=TRUE)


#meta <- dbReadTable(con, "meta")


dbListTables(con)

dbDisconnect(con)
rm(con)





