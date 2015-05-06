library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(scales)

cities <- read_csv("cities.csv")

shinyServer(function(input, output, session) {

  cities_by_year <- reactive({
    cities %>%
      filter(year == input$year)
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
      addTiles() %>%
      setView(lat = 37.45, lng = -93.85, zoom = 4) %>%
      addCircleMarkers(data = filter(cities, year == 1790),
                       fill = FALSE, radius = 2,
                       lng = ~lng, lat = ~lat, layerId = ~id)

  })

  observe({
    message(nrow(cities_by_year()))
    leafletProxy("cities_map", session, deferUntilFlush = FALSE) %>%
      clearMarkers() %>%
      addCircleMarkers(data = cities_by_year(),
                       fill = FALSE, radius = 2,
                       lng = ~lng, lat = ~lat, layerId = ~id)
  })

})
