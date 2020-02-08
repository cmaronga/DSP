library(tidyverse)
library(lubridate)


files_path <- "00 datasets/daily_Rdownloads209"   # path to the data

my_files <- dir(files_path, pattern = "*.csv") # get file names

Rdownloads_data <- my_files %>% 
  map(~ vroom::vroom(file.path(files_path, .), delim = ",")) %>% reduce(bind_rows)

# store combined file
write_csv(Rdownloads_data, "00 datasets/2019_daily_Rdownloads.csv")


# import data -------------------------------------------------------------
Rdownloads_data <- vroom::vroom("00 datasets/2019_daily_Rdownloads.csv", delim = ",")

# which country downloads more
Rdownloads_data %>% filter(Country_Name != "Missing/Namibia") %>% 
  group_by(version) %>% 
  summarise(
    total = n()
  ) %>% arrange(desc(total)) %>% head(20) %>% ggplot(aes(version, total)) + geom_bar(stat = "identity")
