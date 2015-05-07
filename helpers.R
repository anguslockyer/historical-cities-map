cities <- read_csv("cities.csv")

mapbox_pat  <- "pk.eyJ1IjoibG11bGxlbiIsImEiOiJ0d2NyaXIwIn0.yQRq0XD7U1uW3jxnpEt1pg"
mapbox_map  <- "lmullen.b1562664"
mapbox_attr <- "Labels <a href='https://www.mapbox.com/about/maps/' target='_blank'>&copy; Mapbox &copy; OpenStreetMap</a>"
mapbox_url  <- paste0("http://api.tiles.mapbox.com/v4/",
                      mapbox_map,
                      "/{z}/{x}/{y}.png?access_token=",
                      mapbox_pat)

radius_scale <- function(x) {
  max_pop <- sqrt(max(cities$population))
  x %>%
    sqrt() %>%
    rescale(to = c(1, 35), from = range(0, max_pop))
    # Technically the lowest number on the radius scale should be 0, not 1, but
    # I'm willing to tolerate a little distortion for the sake of being able to
    # see the smallest places.
}

popup_maker <- function(name, year, population) {
  paste(name, year, population)
}

draw_cities <- function(map, data) {
  map %>%
    clearMarkers() %>%
    addCircleMarkers(data = data,
                       fillColor = "white", fillOpacity = 0, weight = 2,
                       radius = ~radius_scale(population),
                       lng = ~lng, lat = ~lat, layerId = ~id,
                       popup = popup_maker(data$cityst,
                                           data$year,
                                           data$population))
}
