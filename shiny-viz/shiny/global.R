library(shiny)
library(leaflet)
library(plotly)
library(readr)

clinics <- read.csv('patient_clinic_join.csv')
clinic_info <- read.csv('clinics2.csv')