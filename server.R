library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(scales)
library(leaflet)

source("helpers.R")

shinyServer(function(input, output, session) {

  cities_by_year <- reactive({
    cities %>%
      filter(year == input$year,
             population >= input$min_pop)
  })

  output$cities_hist <- renderPlot({
    pops <- cities_by_year()
    ggplot(pops, aes(x = population)) +
      geom_histogram() +
      scale_x_log10(labels = comma) +
      theme_minimal() +
      labs(x = "Population", y = "# of cities",
           title = paste("U.S. Cities in", input$year))
  })

  output$cities_map <- renderLeaflet({
    map <- leaflet() %>%
            addProviderTiles(provider = "Esri.WorldTerrain") %>%
            setView(lat = 37.45, lng = -93.85, zoom = 4)

    # Initally draw the map without relying on cities_by_year(). Because if we
    # rely on that, then Shiny will make drawing the map reactive, and every
    # time cities_by_year() changes, the entire map will be redrawn.
    map %>%
      draw_cities(filter(cities, year == 1790))

  })

  observe({
    map <- leafletProxy("cities_map", session, deferUntilFlush = TRUE)
    if (input$place_labels) {
      map %>% addTiles(urlTemplate = mapbox_url, attribution = mapbox_attr,
                       layerId = "place-labels")
    } else {
     map %>% removeTiles("place-labels")
    }
  })

  observe({
    leafletProxy("cities_map", session, deferUntilFlush = FALSE) %>%
      draw_cities(cities_by_year())
  })

})
