#App.R


# Pakker ------------------------------------------------------------------


library(shiny)
library(shinydashboard)
library(RMariaDB)
library(leaflet)
library(tidyverse)
library(jsonlite)


# Passwords ---------------------------------------------------------------


id = fromJSON("keys.json")$id  
pw = fromJSON("keys.json")$pw


# Get data ----------------------------------------------------------------

con <- dbConnect(RMariaDB::MariaDB(),
                 user= id, password= pw,
                 dbname="bom", host="localhost")



#dbWriteTable(con, "bom", bom, overwrite=TRUE)


bom <- dbReadTable(con, "bom")


dbListTables(con)

dbDisconnect(con)
rm(con)


# Tilpasse ----------------------------------------------------------------

df <- bom




ui <- dashboardPage(

#1  Header ------------------------------------------------------------------

  dashboardHeader( disable = T,
    
    title = "Frontbird dashboard",
    titleWidth = 450


  )# Header slutt
,


# Sidebar -----------------------------------------------------------------

  dashboardSidebar(  disable = T,
                     width = 250,

    
# Sidebarmenu -------------------------------------------------------------

        
    sidebarMenu(


# Sidebarmenu 1 Dashboard -------------------------------------------------

      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")
               )# menuItem slutt



    ) #Menu slutt

    
  ) # Sidebar slutt
,


# 2 Body --------------------------------------------------------------------

  dashboardBody(
    
    tabItems(

# Body 1 Dashboard --------------------------------------------------------

      tabItem(tabName = "dashboard",
              
              
              fluidRow(
                
                leafletOutput("mymap",height = 1000)    
                )
                
                
              )   
              
              
      ) 

        
 



# Neste side kommer her (lim inn over. -----------------------------------------------


    ) #  dashboardBody slutt
    
    
  ) #Body slutt





# 3 Server ------------------------------------------------------------------


server <- function(input, output) { 



# Leaflet map -------------------------------------------------------------

  data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude,
                 lat = ~Latitude,
                 popup = paste("Takst liten bil", df$takst_liten_bil, "<br>",
                               "Takst stor bil:", df$takst_stor_bil))
    m
  })  

  
  } # Server slutt


# App ---------------------------------------------------------------------


shinyApp(ui, server)