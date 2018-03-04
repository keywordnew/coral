
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
                  "Year:",
                  min = 2013,
                  max = 2017,
                  sep = "",
                  value = range(2013,2014)),
      sliderInput("age",
                  "Age:",
                  min = 14,
                  max = 70,
                  value = range(30,42)),
      uiOutput("variablesUi"),
      checkboxGroupInput("gender", 
                         "Gender", 
                         choices = list("Male" = 1, 
                                        "Female" = 2, 
                                        "Unspecified" = 3)),
      checkboxGroupInput("service_type", 
                         "Service type", 
                         choices = list("STI testing" = 1, 
                                        "Pregnancy testing" = 2, 
                                        "Counselling" = 3,
                                        "Birth control services" = 4,
                                        "Abortion services" = 5, 
                                        "Emergency contraceptive" = 6)),
      checkboxGroupInput("provider", 
                         h3("Provider"),
                         choices = list("BC-CDC" = 1, "Opt" = 2),
                         selected = list("BC-CDC" = 1, "Opt" = 2))
      

    ),
  
    mainPanel(
      leafletOutput("map")
    )
  )
))

