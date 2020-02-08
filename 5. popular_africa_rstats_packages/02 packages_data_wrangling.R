library(tidyverse)
library(lubridate)


files_path <- "00 datasets/2019_Afrstats"   # path to the data

my_files <- dir(files_path, pattern = "*.csv") # get file names

africa_data <- my_files %>% 
  map(~ vroom::vroom(file.path(files_path, .), delim = ",")) %>% reduce(bind_rows)

write_csv(africa_data, "00 datasets/popular_rstats_packages.csv")


# Import data -------------------------------------------------------------
AF_packages_data <- vroom::vroom("00 datasets/popular_rstats_packages.csv", delim = ",")


# adding month, day, week -------------------------------------------------
AF_packages_data <- AF_packages_data %>% 
  mutate(
    month = month(date, label = T, abbr = T), # month label
    Day = wday(date, label = T, abbr = T), # day of the week
    Week = week(date) # week in the year 2019
  )


# top 10 packages
top_10 <- AF_packages_data %>% 
  group_by(package) %>% 
  summarise(
    total = n()
  ) %>% arrange(desc(total)) %>% head(10)


# top country downloads
top_countries <- AF_packages_data %>% 
  group_by(Country_Name) %>% 
  summarise(
    total = n()
  ) %>% arrange(desc(total)) %>% head(10)




