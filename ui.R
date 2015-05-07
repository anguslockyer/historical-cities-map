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
               bottom = 10, left = 10, width = 350, height = "auto",
               h3("Historical U.S. Cities"),
               sliderInput("year", "Year", value = 1790, sep = "",
                           min = 1790, max = 2010, step = 10,
                           width = "100%"),
               sliderInput("min_pop", "Minimum Population", value = 0,
                           min = 0, max = 0.5e6, step = 1e3,
                           width = "100%", pre = "≥"),
               checkboxInput("place_labels", "Contemporary place labels?",
                             FALSE),
               plotOutput("cities_hist", height = 200),
               tags$p(tags$small(includeHTML("cesta_attr.html"))),
               tags$p(tags$small(includeHTML("my_attr.html")))
               )
    )
)

