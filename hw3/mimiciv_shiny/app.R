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
               
               mainPanel(helpText("Distribution plot:"),
                         plotOutput("demodistPlot"),
                         helpText("Summary stastistics:"),
                         tableOutput("demotable"))
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
          
          mainPanel(helpText("Distribution plot:"),
                    sliderInput("labbins",
                      "Number of bins for histogram:",
                      min = 1,
                      max = 50,
                      value = 30),
                    plotOutput("labdistPlot"),
                    helpText("Summary stastistics:"),
                    tableOutput("labtable"))
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
               
               mainPanel(helpText("Distribution plot:"),
                         sliderInput("vitalbins",
                                     "Number of bins for histogram:",
                                     min = 1,
                                     max = 50,
                                     value = 30),
                         plotOutput("vitaldistPlot"),
                         helpText("Summary stastistics:"),
                         tableOutput("vitaltable"))
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
  
    output$demotable <- renderTable({
      icu_cohort %>%
        count(icu_cohort[[input$demovar]]) %>%
        mutate(prop = prop.table(n))
    })
    
    output$labdistPlot <- renderPlot({
      ggplot(icu_cohort, aes(x = .data[[input$labvar]])) +
        geom_histogram(bins = input$labbins, na.rm = TRUE) +
        labs(x = input$labvar)
    })

    output$labtable <- renderTable({
      icu_cohort %>%
        summarize(
          N = length(icu_cohort[[input$labvar]]),
          Mean = mean(icu_cohort[[input$labvar]], na.rm = T),
          SD = sd(icu_cohort[[input$labvar]], na.rm = T),
          Min = min(icu_cohort[[input$labvar]], na.rm = T),
          Max = max(icu_cohort[[input$labvar]], na.rm = T),
          Median = median(icu_cohort[[input$labvar]], na.rm = T))
    })
    
    output$vitaldistPlot <- renderPlot({
      ggplot(icu_cohort, aes(x = .data[[input$vitalvar]])) +
        geom_histogram(bins = input$vitalbins, na.rm = TRUE) +
        labs(x = input$vitalvar)
    })
    
    output$vitaltable <- renderTable({
      icu_cohort %>%
        summarize(
          N = length(icu_cohort[[input$vitalvar]]),
          Mean = mean(icu_cohort[[input$vitalvar]], na.rm = T),
          SD = sd(icu_cohort[[input$vitalvar]], na.rm = T),
          Min = min(icu_cohort[[input$vitalvar]], na.rm = T),
          Max = max(icu_cohort[[input$vitalvar]], na.rm = T),
          Median = median(icu_cohort[[input$vitalvar]], na.rm = T))
    })
    
}
    
# Run the application 
shinyApp(ui = ui, server = server)
