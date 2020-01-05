# load packages
library(shiny)
library(DT)

ui <- fluidPage(
  
  verbatimTextOutput("intro_text"),
  
  dataTableOutput("all_pkgs")
)