library(readr)
library(tidyr)
library(dplyr)

cities <- read_csv("historical-us-city-populations/data/1790-2010_MASTER.csv")

fix_missing <- function(x, missing) {
  x[x == missing] <- NA
  x
}

fix_coord <- function(x, y) {
  ifelse(!is.na(x), x, y)
}

cities <- fix_missing(cities, 0)

cities <- cities %>%
  gather(year, population, 5:27, na.rm = TRUE, convert = TRUE) %>%
  mutate(lat = fix_coord(LAT, LAT_BING),
         lng = fix_coord(LON, LON_BING)) %>%
  filter(!is.na(lat),
         !is.na(lng)) %>%
  select(-STPLFIPS_2010, -Name_2010, -County, -`Place Type`,
         -LAT_BING, -LON_BING, -LAT, -LON, -`Population Source`,
         -`City Source`)

names(cities) <- tolower(names(cities))

write_csv(cities, path = "cities.csv")
