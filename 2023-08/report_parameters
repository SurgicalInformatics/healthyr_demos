library(rmarkdown)
library(tidyverse)

# Run knit in script rather than manual click
# copy and pasting this code already makes it easier to render automatically if relatively few parameters are needed
# e.g.

# Europe
render("reports_automated.Rmd", 
       params = list(my_continent = "Europe"), 
       output_file = "automated_report_Europe.pdf") 

# Asia
render("reports_automated.Rmd", 
       params = list(my_continent = "Asia"), 
       output_file = "automated_report_Asia.pdf") 

# How to automate - use pwalk 

continents = c("Americas", "Europe", "Asia", "Africa", "Oceania")
render_all = tibble(my_continent = continents) %>% 
  mutate(output_file = paste0("reports_automated/reports_automated_", my_continent, ".pdf"),
         params = map(my_continent, ~list(my_continent = .))) %>% 
  select(params, output_file) 


render_all %>% 
  pwalk(render, input = "reports_automated.Rmd")








