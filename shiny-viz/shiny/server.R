
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(dplyr)
library(ggplot2)
library(leaflet)


shinyServer(function(input, output) {

  clinics_filtered <- reactive({
    df <- clinics %>% 
      filter(provider %in% input$provider) %>% 
      filter(sexual_orientation %in% input$sexualOrientation)
    df
  })
  
  output$variablesUi <- renderUI({
    selectizeInput("variablesSelect", "Feedback tags:",
                   c("clean", "messy", "uncomfortable", "nonjudgemental", "friendly", "safe", "fast", "longwaittimes", "professional", "empathy"),
                   selected =  c("clean", "messy", "uncomfortable", "nonjudgemental", "friendly", "safe", "fast", "longwaittimes", "professional", "empathy"), 
                   multiple = TRUE,
                   options = list(placeholder = "Select feedback tags to show"))
  })
  
  output$userInfo <- renderPlotly({
    xaxis <- list(
      autotick = FALSE,
      ticks = "outside",
      tick0 = 0,
      dtick = 1,
      tickcolor = toRGB("#262626"),
      title = "clinic"
    )
    
    yaxis <- list(
      title = 'frequency'
    )
    
    plot_ly(clinics_filtered(), x = ~clinic_name, y = ~n, type="bar") %>% 
      layout(xaxis = xaxis, yaxis = yaxis, legend = list(orientation = 'h', x = 0.1, y = -0.3))
  })
  
  
  output$map <- renderLeaflet({
    leaflet(data = clinics_filtered()) %>% 
      addProviderTiles("OpenMapSurfer.Grayscale", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, label=~as.character(clinic_name), stroke=FALSE, fillOpacity=0.8)
  })
  
  
  clinicTable <- reactive({
    clinics_table <- clinics_filtered() %>% 
      group_by(clinic_name) %>% 
      summarise(
        number_patients = n(),
        avg_age = round(quantile(age, 0.3),1),
        msp_required = mean(msp_required)
      )
    clinics_table
  })
  
  
  output$dataTable <- renderTable(
    {
      clinicTable()
    },
    include.rownames = FALSE
  )

})
