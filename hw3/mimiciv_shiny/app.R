# Load packages
library(shiny)

# Load data
icu_cohort <- readRDS("icu_cohort.rds")

# User interface
ui <- fluidPage(
  titlePanel("Summaries of the ICU cohort data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("lab measurements"),
      
      selectInput("labvar", 
                  label = "lab measurements",
                  choices = c("calcium", "magnesium",
                              "potassium", "chloride",
                              "sodium", "creatinine",
                              "bicarbonate", "glucose",
                              "hematocrit", "wbc"),
                  selected = "calcium"),
      
    ),
    
    mainPanel(plotOutput("labdistPlot"))
  )
)


# Server logic
server <- function(input, output) {
    
    output$labdistPlot <- renderPlot({
      x <- icu_cohort[[input$labvar]]
      hist(x, col = 'darkgray', border = 'white')
    })

}
    
# Run the application 
shinyApp(ui = ui, server = server)
