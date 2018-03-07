library(shinycssloaders)
library(shinythemes)

shinyUI(navbarPage( theme = shinytheme("flatly"),
  title = "Sexual Health Clinics in Vancouver",
  tags$head(tags$style(HTML(
    "li.active { display: none; }"
  ))),
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
                         choices = list("Male" = "male", 
                                        "Female" = "female",
                                        "Unspecified" = "unspecified"),
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
                         choices = list("STI testing" = "sti_testing",
                                        "Emergency contraceptive" = "emergency contraceptive",
                                        "Birth control services" = "birth control services", 
                                        "Abortion" = "abortion",
                                        "Pregnancy testing" = "pregnancy_testing",
                                        "Counselling" = "counselling"),
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

