library(tidyverse)
eurovision <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-05-17/eurovision.csv')

## Summary of variables ----
eurovision %>% 
  count(winner)

eurovision %>% 
  count(artist_country, sort = TRUE)

## Plotting - geom_bar vs geom_col ----
eurovision %>% 
  ggplot(aes(x = artist_country, fill = winner)) + 
  geom_bar(position = "fill") + 
  coord_flip()

## Further plot using geom_col ----
eurovision %>% 
  count(artist_country, winner) %>% 
  group_by(artist_country) %>% 
  mutate(nn = sum(n),
         prop = n / nn) %>%
  mutate(prop = if_else(!winner, 0, prop)) %>% 
  ggplot(aes(y = fct_reorder(artist_country, prop), x = n, fill = winner)) + 
  geom_col(position = "fill")