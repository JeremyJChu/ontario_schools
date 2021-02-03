#install.packages("rvest")
library(rvest)
library(tidyverse)

raw_data <- read_html("https://en.wikipedia.org/wiki/List_of_postal_codes_of_Canada:_M")
write_html(raw_data, "inputs/wiki/fsas.html")

raw_data <- read_html("inputs/wiki/fsas.html")

parse_data_inspection <- 
  raw_data %>%
  html_nodes("tr") %>%
  html_text()

parsed_data <-
  tibble(raw_text = parse_data_inspection) 

head(parsed_data)

initial_clean <- 
  parsed_data %>%
  separate(raw_text,
           into = c("Postal Code", "Borough", "Neighbourhood"),
           sep = "\n\n")

initial_clean = initial_clean[-1,]

fsaM <- initial_clean

fsaM_assigned <- filter(fsaM, Borough != "Not assigned")
fsaM_assigned <- slice(fsaM_assigned, 1:(n()-4))

write_csv(fsaM_assigned, "inputs/data/01_fsaM_cleaned.csv")