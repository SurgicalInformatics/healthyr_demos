# November 2022 
# HealthyR Clinic 
# *_join() demo

library(tidyverse)
library(lubridate)

# The data sets being used

df1 = tibble(subjid = 1:10,
             dob = sample(seq(ymd('1950-01-01'), ymd('2002-01-01'), by = "day"), 
                          size = 10, replace=TRUE),
             country = sample(c("England", "Scotland", "Wales", "N. Ireland"), 
                              size=10, replace=TRUE, prob=c(0.7, 0.16, 0.09, 0.05)),
             sex = c("female", "male", "male", "male", "female", "other", "female",
                     "female", "male", "male"))

df2 = tibble(id = 3:12,
             height = round(runif(10, 150, 190)),
             weight = round(runif(10, 50, 100)),
             test_result = round(runif(10, 40, 80)),
             gender = c("male", "male", "female", "other", "female", "female", 
                        "male", "male", "male", "female"))

df3 = tibble(subjid = 3:12,
             test_result = round(runif(10, 60, 100)),
             job = c("doctor", "lawyer", "police officer", "teacher", "accountant",
                     "scientist", "lecturer", "artist", "author", "engineer"),
             fav_animal = c("dog", "penguin", "giraffe", "armadillo", "elephant",
                            "gorilla", "Guinea pig", "sloth", "lion", "parrot"))


extra_patient = tibble(subjid = 13,
                       dob = ymd("1997-03-11"),
                       country = "Scotland",
                       sex = "Female",
                       height = 173,
                       weight = 70,
                       test_result_1 = 65,
                       test_result_2 = 89,
                       job = "data scientist")



# Q1 - Join df1 and df2 using the subject id column
## Only rows in common
df1 %>% 
  inner_join(df2, by = c("subjid" = "id"))

## Keep all of df1
df1 %>% 
  left_join(df2, by = c("subjid" = "id"))

## Full join
tmp = df1 %>% 
  full_join(df2, by = c("subjid" = "id"))

## How to use a base R function with %$%
library(magrittr)
tmp %>% 
  drop_na() %$% 
  identical(sex, gender)

# Q2 - Join on multiple columns
## Full join
df1 %>% 
  full_join(df2, by = c("subjid" = "id",
                        "sex" = "gender"))


# Q3 - Join multiple datasets
df1 %>% 
  full_join(df2, by = c("subjid" = "id")) %>% 
  full_join(df3, by = c("subjid"), suffix = c(".day1", ".discharge")) 


# Q4 - What would you do about the column that has the same name? 


# Q5 - how would you join everything except the favourite animal column?
df1 %>% 
  full_join(df2, by = c("subjid" = "id")) %>% 
  full_join(df3, by = c("subjid"), suffix = c(".day1", ".discharge")) %>% 
  select(-fav_animal)

# Q6 - Filtering joins - which individuals are not in the third dataset?
df1 %>% 
  anti_join(df2, by = c("subjid" = "id"))

# Q7 - What would you do if you wanted to add on an extra row of data
df4 = df1 %>% 
  slice(1:4)
df5 = df1 %>% 
  slice(5:10)

df4 %>% 
  select(-sex) %>% 
  bind_rows(df5)

df4 = df4 %>% 
  select(-sex)
rbind(df4, df5) # error

# Q8 watch when joining factors
df4 = df1 %>% 
  slice(1:4) %>% 
  mutate(sex = factor(sex))

df5 = df1 %>% 
  slice(5:10) %>% 
  mutate(sex = factor(sex))

df4$sex %>% levels()
df5$sex %>% levels()

df4 %>% 
  full_join(df5) %$% 
  levels(sex)
  

df6 = tibble(subjid = 3:12,
             test_result = round(runif(10, 60, 100)),
             job = c("doctor", "lawyer", "police officer", "teacher", "accountant",
                     "scientist", "lecturer", "artist", "author", "engineer"),
             fav_animal2 = c("doggy", "penguin", "giraffe", "armadillo", "elephant",
                            "gorilla", "Guinea pig", "sloth", "lion", "parrot"))

df3 %>% 
  full_join(df6, by = c("fav_animal" = "fav_animal2"))
