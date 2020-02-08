# load packages -----------------------------------------------------------
library(tidyverse)


# Download country and continent codes ------------------------------------

country_codes <- read_csv("https://pkgstore.datahub.io/JohnSnowLabs/country-and-continent-codes-list/country-and-continent-codes-list-csv_csv/data/b7876b7f496677669644f3d1069d3121/country-and-continent-codes-list-csv_csv.csv")


# The Log repository started being tracked in october 2012 to date (2012-10-01)

  start <- as.Date('2019-06-01')
  today <- as.Date('2019-12-31')

  all_days <- seq(start, today, by = 'day')

  year <- as.POSIXlt(all_days)$year + 1900
  
  urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, '.csv.gz')
  
  for (url_id in 1:length(urls)){
    
    data_name <- str_sub(urls[url_id], start = 35, end = 44)
  
    dataset <- vroom::vroom(urls[url_id], delim = ",")
    
    # left join with country codes
    dataset_with_country_name <- dataset %>% filter(!is.na(country)) %>% # missing country code distorts the statistics
      left_join(country_codes %>% select(Country_Name, 
                                         Two_Letter_Country_Code, 
                                         Continent_Name),by = c("country" = "Two_Letter_Country_Code"))
    
    # Africa downloads dataset
    africa_dataset <- dataset_with_country_name %>% 
      filter(Continent_Name == "Africa")
    
  # filter 20 most downloaded packages in Africa
  top_20 <- africa_dataset %>% 
    group_by(package) %>% 
    summarise(total = n()) %>% 
    arrange(desc(total)) %>% head(20)
      
  # export dataset
    africa_dataset %>% filter(package %in% c(top_20$package)) %>% 
      write_csv(paste("00 datasets", "/", "2019_Afrstats", "/", data_name, ".csv", sep = ""))
    
  }
  






  
  