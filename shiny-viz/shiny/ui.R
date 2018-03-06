library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("Sexual Health Clinics in Vancouver"),

    sidebarPanel(
      checkboxGroupInput("provider", 
                         "Clinic provider:",
                         choices = list("BC-CDC"=1, 
                                        "Opt Sexual Health"=2),
                         selected = unique(clinics$provider)),
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
                         choices = unique(clinics$gender),
                         selected = unique(clinics$gender)),
      checkboxGroupInput("sexualOrientation", 
                         "Sexual Orientation:", 
                         choices = list("Heterosexual" = 1, 
                                        "Homosexual" = 2, 
                                        "Bisexual" = 3,
                                        "Other" = 4),
                         selected = list(1,2,3,4)),
      checkboxGroupInput("serviceType", 
                         "Service type", 
                         choices = unique(clinics$service_type),
                         selected = unique(clinics$service_type))
    ),
  
    mainPanel(
      uiOutput("variablesUi"),
      plotOutput("ggplot"),
      hr(),
      leaflet::leafletOutput("map"),
      tableOutput("dataTable")
    )
))

