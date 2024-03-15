library(tidyverse)
library(finalfit)

# Dataset from medicaldata::licorice_gargle 
licodata_raw = read_csv("licodata_raw.csv")

# reading in 0,1, recoding
licodata = licodata_raw %>% 
  mutate(preOp_gender.factor = preOp_gender %>% 
           factor() %>% 
           fct_recode("Male" = "0",
                      "Female" = "1"),
         preOp_asa.factor = preOp_asa %>% 
           factor() %>% 
           fct_recode("a normal healthy patient" = "1",
                      "a patient with mild systemic disease" = "2",
                      "a patient with severe systemic disease" = "3"),
         treat.factor = treat %>% 
           factor() %>% 
           fct_recode("Sugar 5g" = "0",
                      "Licorice 0.5g" = "1"),
         preOp_smoking.factor = preOp_smoking %>% 
           factor() %>% 
           fct_recode("Current" = "1",
                      "Past" = "2",
                      "Never" = "3"),
         
         pod1am_throatPain.factor = pod1am_throatPain %>% 
           factor() %>% 
           fct_collapse("No Pain" = "0",
                        other_level = "Pain"),
         pod1am_cough.factor = pod1am_cough %>% 
           factor() %>% 
           fct_collapse("No Cough" = "0",
                        other_level = "Cough"),
         pacu30min_swallowPain.factor = pacu30min_swallowPain %>% 
           factor() %>% 
           fct_collapse("No Pain" = "0",
                        other_level = "Pain")) 

licodata %>% 
  count(treat, treat.factor)

licodata %>% 
  ggplot(aes(preOp_asa.factor)) +
  geom_bar()

licodata %>% 
  finalfit("pod1am_throatPain", c("treat.factor"))

licodata = licodata %>% 
  mutate(treat = treat.factor,
         preOp_gender = preOp_gender.factor,
         preOp_asa = preOp_asa.factor) %>% 
  select(-ends_with(".factor"))

licodata %>% 
  write_csv("licodata.csv")

# reading in CSV 
licodata_csv = read_csv("licodata.csv")

licodata_csv %>% 
  finalfit("pod1am_throatPain", c("treat"))

licodata %>% 
  drop_na(pod1am_throatPain) %>% 
  ggplot(aes(preOp_asa, fill = factor(pod1am_throatPain))) +
  geom_bar(position = "fill") +
  scale_fill_brewer(palette = "BuGn")


licodata = licodata %>% 
  mutate(preOp_asa = fct_collapse(preOp_asa,
                                  "Healthy" = "a normal healthy patient",
                                  "Systemic disease" = c("a patient with mild systemic disease",
                                                         "a patient with severe systemic disease")))


licodata = licodata %>% 
  mutate(pod1am_throatPain2 = pod1am_throatPain %>% 
         factor() %>% 
         fct_collapse(
           "No pain"   = "0",
           other_level = "Pain"))

licodata %>% 
  drop_na(pod1am_throatPain2) %>% 
  ggplot(aes(preOp_asa, fill = pod1am_throatPain2)) +
  geom_bar(position = "fill") +
  scale_fill_brewer(palette = "BuGn")
