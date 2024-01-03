library(tidyverse)
library(fs)
library(readxl)

# reading files in manually
jan_df = read_csv("data_orig/january_project_dataset.csv")
feb_df = read_csv("data_orig/february_project_dataset.csv")
march_df = read_csv("data_orig/march_project_dataset.csv")

# bind
all_months = bind_rows(jan_df, feb_df, march_df) 

rm(jan_df, feb_df, march_df)

# all files at once
all_months2 = read_csv(c("data_orig/january_project_dataset.csv", 
                         "data_orig/february_project_dataset.csv", 
                         "data_orig/march_project_dataset.csv"))


# using filesystem (fs)
all_months3 = dir_ls("data_orig", glob = "*project*.csv") %>% 
  read_csv()

# example

test = read_csv(c("CopyOfdata_orig/CopyOffebruary_project_dataset.csv",
                "CopyOfdata_orig/february_project_dataset.csv"))

tst1 = read_csv("CopyOfdata_orig/CopyOffebruary_project_dataset.csv")
tst2 = read_csv("CopyOfdata_orig/february_project_dataset.csv")

full_test = full_join(tst1, tst2)

## Excel 

# multiple different files - first sheet 

excel_all = dir_ls("data_orig/excel/", glob = "*project*.xlsx") %>% 
  map_dfr(~ read_excel(.))


all_sheets = excel_sheets("data_orig/excel/all_months.xlsx") %>% 
  map_dfr(~ read_excel("data_orig/excel/all_months.xlsx",
                       sheet = .))









