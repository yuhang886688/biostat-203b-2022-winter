# Load packages
library(shiny)
library(tidyverse)

# Load data
icu_cohort <- readRDS("icu_cohort.rds")

# User interface
ui <- fluidPage(
  titlePanel("Summaries of the ICU cohort data"),
  
  tabsetPanel(
    
    tabPanel("demo",
             sidebarLayout(
               sidebarPanel(
                 selectInput("demovar", 
                             label = "demographics",
                             choices = c("gender", "language",
                                         "marital_status", "ethnicity",
                                         "insurance", "thirty_day_mort"),
                             selected = "gender"),
                 
               ),
               
               mainPanel(plotOutput("demodistPlot"))
             )
             
    ),
    
    
    tabPanel("lab",
        sidebarLayout(
          sidebarPanel(
            selectInput("labvar", 
                        label = "lab measurements",
                        choices = c("calcium", "magnesium",
                                    "potassium", "chloride",
                                    "sodium", "creatinine",
                                    "bicarbonate", "glucose",
                                    "hematocrit", "wbc"),
                        selected = "calcium"),
            
          ),
          
          mainPanel(sliderInput("labbins",
                      "Number of bins for histogram:",
                      min = 1,
                      max = 50,
                      value = 30),
                    plotOutput("labdistPlot"))
        )
    
    ),
    tabPanel("chart",
             sidebarLayout(
               sidebarPanel(
                 selectInput("vitalvar", 
                             label = "vitals measurements",
                             choices = c("meanbp", "sbp",
                                         "temp", "resp_rate",
                                         "heartrate"),
                             selected = "meanbp"),
                 
               ),
               
               mainPanel(sliderInput("vitalbins",
                                     "Number of bins for histogram:",
                                     min = 1,
                                     max = 50,
                                     value = 30),
                         plotOutput("vitaldistPlot"))
             )
             
    )
    
    
  )
)



# Server logic
server <- function(input, output) {
  
    output$demodistPlot <- renderPlot({
      ggplot() +
      geom_bar(mapping = aes(y = icu_cohort[[input$demovar]]), na.rm = TRUE) +
        labs(y = input$demovar)
    })
  
    output$labdistPlot <- renderPlot({
      ggplot(icu_cohort, aes(x = .data[[input$labvar]])) +
        geom_histogram(bins = input$labbins, na.rm = TRUE) +
        labs(x = input$labvar)
    })
    
    output$vitaldistPlot <- renderPlot({
      ggplot(icu_cohort, aes(x = .data[[input$vitalvar]])) +
        geom_histogram(bins = input$vitalbins, na.rm = TRUE) +
        labs(x = input$vitalvar)
    })
}
    
# Run the application 
shinyApp(ui = ui, server = server)
