# load package
library(shiny)
library(DT)


server <- function(input, output, session){
  
  
  pkgs_df <- reactive({
        available.packages()[, c("Version",
                         "Depends","Repository", 
                         "NeedsCompilation")]
  })
  
  output$intro_text <- renderPrint({
    
    paste("A total of", nrow(pkgs_df()), "contributed packages in CRAN")
  })
  
  output$all_pkgs <- renderDataTable({
 pkgs_df()
  })
  
}