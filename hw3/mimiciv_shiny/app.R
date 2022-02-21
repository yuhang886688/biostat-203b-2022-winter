# Load packages
library(shiny)

# Load data
icu_cohort <- readRDS("./mimiciv_shiny/icu_cohort.rds")


# Run the application 
shinyApp(ui = ui, server = server)
