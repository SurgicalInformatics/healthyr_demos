library(rmarkdown)
library(tidyverse)

# Copy and paste of code and changing parameter, somewhat simplifies the method
# run knit in script rather than manual click
# e.g 

# Europe
render("reports_automated.Rmd", 
       params = list(my_continent = "Europe"), 
       output_file = "automated_report_Europe.pdf") 

# Asia
render("reports_automated.Rmd", 
       params = list(my_continent = "Asia"), 
       output_file = "automated_report_Asia.pdf") 

# Automate this step using purrr from tidyverse

continents = c("Americas", "Europe", "Asia", "Africa", "Oceania")
render_all = tibble(my_continent = continents) %>% 
  mutate(output_file = paste0("reports_automated/reports_automated_", my_continent, ".pdf"),
         params = map(my_continent, ~list(my_continent = .))) %>% 
  select(params, output_file) 

render_all %>% 
  pwalk(render, input = "reports_automated.Rmd")














