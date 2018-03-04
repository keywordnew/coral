
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(dplyr)
library(ggplot2)
library(leaflet)

clinics <- read_csv('clinics.csv')


shinyServer(function(input, output) {

  clinics_filtered <- reactive({
    df <- filter(clinics, provider %in% input$provider)
    df
  })
  
  output$variablesUi <- renderUI({
    selectizeInput("variablesSelect", "Variables to show:",
                   c("clean", "longwaittimes", "unjudgemental", "uncomfortable"),
                   selected =  c("clean", "longwaittimes", "unjudgemental", "uncomfortable"), 
                   multiple = TRUE,
                   options = list(placeholder = "Select variables to show"))
  })
  
  output$map <- renderLeaflet({
    leaflet(data = clinics_filtered()) %>% 
      addProviderTiles("OpenMapSurfer.Grayscale", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, label=~as.character(clinic_name), stroke=FALSE, fillOpacity=0.8)
  })

})
