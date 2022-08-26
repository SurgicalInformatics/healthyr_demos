library(tidyverse)
library(ggthemes)
library(countrycode)

wwc_outcomes = readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-09/wwc_outcomes.csv")
team_lookup  = read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-09/codes.csv")


# Explore data
## Count years

wwc_outcomes %>% 
  count(year)

## Games per country
wwc_outcomes %>% 
  filter(year == 1991) %>% 
  count(team)

## Teams per year
wwc_outcomes %>% 
  group_by(year) %>% 
  distinct(team, .keep_all = TRUE) %>% 
  count(team) %>% 
  count(year)

### Riinu's version
wwc_outcomes %>% 
  distinct(year, team) %>% 
  count(year)

### Understand round
wwc_outcomes %>% 
  distinct(round)

### Niall - who won each year?
wwc_outcomes %>% 
  filter(round == "Final") %>% 
  filter(win_status == "Won")

## Mapping
### Create summary table
countries_takenpart = wwc_outcomes %>% 
  distinct(team, year) %>% 
  count(team)

### Change 3 letter codes to country names
countries_takenpart %>% 
  mutate(country = countrycode(team, origin = "iso3c", destination = "country.name"))
#### Countries in our dataset are not ISO coded, so we will use a separate look-up. 

### Join look-up
countries_takenpart = left_join(countries_takenpart, team_lookup, by = c("team" = "team"))

## Can we map yet?!
world_map = map_data("world") %>% 
  filter(! long > 180)

countries = world_map %>% 
  distinct(region) %>% 
  rowid_to_column()

### Add our data
mycountries = left_join(countries, countries_takenpart, by = c("region" = "country"))

### Check our data
mycountries %>% 
  filter(!is.na(n))
### 30 countries - we have lost 6 countries. 

### Do an anti-join!
anti_join(countries_takenpart, countries, by = c("country" = "region"))

### Solve mismatches
countries_takenpart = countries_takenpart %>% 
  mutate(country = case_when(
    country == "China PR" ~ "China",
    country == "Ivory Coast (Côte d'Ivoire)" ~ "Ivory Coast",
    country == "Chinese Taipei" ~ "Taiwan",
    country == "United States" ~ "USA",
    TRUE ~ country
  ))

# Recreate
mycountries = left_join(countries, countries_takenpart, by = c("region" = "country"))

### Map
mycountries %>% 
  ggplot(aes(fill = n, map_id = region)) +
  geom_map(map = world_map) +
  expand_limits(x = world_map$long, y = world_map$lat) +
  coord_map("moll") +
  theme_map()
