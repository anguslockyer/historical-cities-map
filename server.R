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
    leaflet() %>%
      addProviderTiles(provider = "Esri.WorldTerrain") %>%
      setView(lat = 37.45, lng = -93.85, zoom = 4)  #%>%
#       addCircleMarkers(data = current_cities,
#                        fill = FALSE, radius = ~radius_scale(population),
#                        lng = ~lng, lat = ~lat, layerId = ~id,
#                        popup = popup_maker(current_cities$cityst,
#                                            current_cities$year,
#                                            current_cities$population))
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
    current_cities <- cities_by_year()
    leafletProxy("cities_map", session, deferUntilFlush = FALSE) %>%
      clearMarkers() %>%
      addCircleMarkers(data = current_cities,
                       fillColor = "white", fillOpacity = 0, weight = 2,
                       radius = ~radius_scale(population),
                       lng = ~lng, lat = ~lat, layerId = ~id,
                       popup = popup_maker(current_cities$cityst,
                                           current_cities$year,
                                           current_cities$population))
  })

})
