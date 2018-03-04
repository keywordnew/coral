
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(

  # Application title
  titlePanel("Sexual Health Clinics in Vancouver"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("year",
                  "Year of visit:",
                  min = 2013,
                  max = 2017,
                  sep = "",
                  value = c(2013,2017)),
      sliderInput("age",
                  "Age:",
                  min = min(clinics$age),
                  max = max(clinics$age),
                  value = range(clinics$age)),
      checkboxGroupInput("gender", 
                         "Gender:", 
                         choices = list("Male" = 1, 
                                        "Female" = 2, 
                                        "Unspecified" = 3)),
      checkboxGroupInput("service_type", 
                         "Service type", 
                         choices = unique(clinics$service_type),
                         selected = unique(clinics$service_type)),
      checkboxGroupInput("provider", 
                         "Provider",
                         choices = list("BC-CDC"=1, "Opt Sexual Health"=2),
                         selected = unique(clinics$provider))
      

    ),
  
    mainPanel(
      uiOutput("variablesUi"),
      leafletOutput("map")
    )
  )
))

