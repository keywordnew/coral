library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),

  # Application title
  headerPanel("Sexual Health Clinics in Vancouver"),

  # Sidebar with a slider input for number of bins
    sidebarPanel(
      checkboxGroupInput("provider", 
                         "Clinic provider:",
                         choices = list("BC-CDC"=1, "Opt Sexual Health"=2),
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
                         choices = list("Male" = 1, 
                                        "Female" = 2, 
                                        "Unspecified" = 3),
                         selected = list(1,2,3)),
      checkboxGroupInput("sexualOrientation", 
                         "Sexual Orientation:", 
                         choices = list("Heterosexual" = 1, 
                                        "Homosexual" = 2, 
                                        "Bisexual" = 3,
                                        "Other" = 4),
                         selected = list(1,2,3,4)),
      checkboxGroupInput("service_type", 
                         "Service type", 
                         choices = unique(clinics$service_type),
                         selected = unique(clinics$service_type))
    ),
  
    mainPanel(
      uiOutput("variablesUi"),
      plotOutput("ggplot"),
      hr(),
      leafletOutput("map"),
      tableOutput("dataTable")
    )
))

