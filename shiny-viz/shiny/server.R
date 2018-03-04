
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
    clinics %>% 
      filter(provider %in% input$provider) %>% 
      filter(sexual_orientation %in% input$sexualOrientation) %>% 
      filter(year %in% input$year)
  })
  
  clinics_plot <- reactive({
    clinics_filtered() %>% 
      group_by(clinic_name) %>% 
      summarise(count=n())
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
  
  output$ggplot <- renderPlot({
    ggplot(data=clinics_plot()) +
      geom_bar(aes(x=clinic_name, y=count), stat="identity") +
      xlab("clinic name") +
      ylab("frequency") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    
  })
  
  
  output$map <- renderLeaflet({
    pal <- colorFactor(c("#B5CFFC","#92AAE7", "#7386D2","#5763BD","#3F43A8","#2F2A93","#26197D","#1F0C68","#190254"), domain = c(19, 26, 28, 30, 31, 32, 34, 36, 41))
    content <- paste(
                     clinic_info$clinic_name,
                     "mean age:", clinic_info$mean_age,
                     "funding (in millions):", clinic_info$funding)
    
    leaflet(data = clinic_info) %>% 
      addProviderTiles("OpenMapSurfer.Grayscale", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, label=content, radius=~funding*10, color=~pal(mean_age), stroke=FALSE, fillOpacity=0.8)
  })
  
  
  clinicTable <- reactive({
    clinics_table <- clinics_filtered() %>% 
      group_by(clinic_name) %>% 
      summarise(
        n_patients = n(),
        avg_age = round(quantile(age, 0.3),0.1),
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
