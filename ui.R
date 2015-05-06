library(shiny)
library(leaflet)

shinyUI(
  fluidPage(
    tags$head(includeCSS("styles.css")),
    fixedPanel(id = "fullscreen",
               top = 0, left = 0, width = "100%", height = "100%",
               leafletOutput("cities_map", width = "100%", height = "100%")
               ),
    fixedPanel(id = "controls",
               bottom = 10, left = 50, width = 450, height = "auto",
               h3("These are the controls"),
               p("Aren't they great?"),
               sliderInput("year", "Year", value = 1790, sep = "",
                           min = 1790, max = 2010, step = 10,
                           animate = TRUE, width = "100%"),
               plotOutput("cities_hist", height = 200)
               )
    )



)

