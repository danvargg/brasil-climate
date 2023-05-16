library(shiny)
library(shinythemes)

ui <- fluidPage(
  theme = shinytheme("paper"),
  titlePanel("Welcome"),
  navbarPage(
    id = "tsp",
    collapsible = TRUE,
    tabPanel("Climate Changes in Brazil", value = "commChart",
             fluidRow(
               column(8,
                      fluidRow(
                        column(6, selectInput(
                          "location", "Community",
                          choices = c("", locs), selected = "",
                          multiple = FALSE, width = "100%")),
                        column(6, selectInput(
                          "dec", "Decades",
                          choices = dec.lab, selected = dec.lab[c(1:9)],
                          multiple = TRUE, width = "100%"))
                      ),
                      fluidRow(
                        column(3, selectInput(
                          "variable", "Climate Variable",
                          choices = c("Temperature", "Precipitation"),
                          selected = "Temperature", multiple = FALSE, width = "100%")),
                        column(3, selectInput(
                          "units", "Units",
                          choices = c("C, mm", "F, in"),
                          selected = "C, mm", multiple = FALSE, width = "100%")),
                        column(3, selectInput(
                          "rcp", "RCP",
                          choices = c("4.5 (low)", "8.5 (high)"),
                          selected = "4.5 (low)", multiple = FALSE, width = "100%")),
                        column(3, selectInput(
                          "value", "Value",
                          choices = c("Mean", "Min", "Max"),
                          selected = "Mean", multiple = FALSE, width = "100%"))
                      )
               ),
               fluidRow(
                 column(4,
                        leafletOutput("Map")),
                 column(8,
                        highchartOutput("Chart1"),
                        tags$style(".rChart {width: 100%; height: auto;}")
                 )
               )
             )
    )
  )
)

server <- function(input, output) {
  # Server code here
}

shinyApp(ui, server)
