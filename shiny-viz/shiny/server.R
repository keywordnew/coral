library(leaflet)
library(magrittr)
library(ggplot2)

shinyServer(function(input, output) {

  clinics_filtered <- reactive({
    clinics %>% 
      dplyr::filter(provider %in% input$provider) %>% 
      dplyr::filter(year >= input$year[1] & year <= input$year[2]) %>% 
      dplyr::filter(age >= input$age[1] & age <= input$age[2]) %>% 
      dplyr::filter(gender %in% input$gender) %>% 
      dplyr::filter(sexual_orientation %in% input$sexualOrientation) %>% 
      dplyr::filter(service_type %in% input$serviceType)
  })
  
  clinics_plot <- reactive({
    clinics_filtered() %>% 
      dplyr::group_by(clinic_name) %>% 
      dplyr::summarise(count=n())
  })
  
  output$variablesUi <- renderUI({
    selectizeInput("variablesSelect", "Feedback tags:",
                   c("clean", "messy", "uncomfortable", "nonjudgemental", "friendly", "safe", "fast", "longwaittimes", "professional", "empathy"),
                   selected =  c("clean", "nonjudgemental"), 
                   multiple = TRUE,
                   options = list(placeholder = "Select feedback tags to show"))
  })
  
  output$ggplot <- renderPlot({
    ggplot2::ggplot(data=clinics_plot()) +
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
    
    leaflet::leaflet(data = clinic_info) %>% 
      addProviderTiles("OpenMapSurfer.Grayscale", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, label=content, radius=~funding*10, color=~pal(mean_age), stroke=FALSE, fillOpacity=0.8)
  })
  
  
  clinicTable <- reactive({
    clinics_filtered() %>% 
      dplyr::group_by(clinic_name) %>% 
      dplyr::summarise(
        n_patients = n(),
        avg_age = round(quantile(age, 0.3),0.1),
        msp_required = mean(msp_required)
      )
  })
  
  
  output$dataTable <- renderTable(
    {
      clinicTable()
    }
  )

})
