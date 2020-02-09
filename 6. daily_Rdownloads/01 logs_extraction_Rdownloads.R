# script used in extracting the logs data

# load packages -----------------------------------------------------------
library(tidyverse)

# Download country and continent codes ------------------------------------

country_codes <- read_csv("https://pkgstore.datahub.io/JohnSnowLabs/country-and-continent-codes-list/country-and-continent-codes-list-csv_csv/data/b7876b7f496677669644f3d1069d3121/country-and-continent-codes-list-csv_csv.csv")


# use 3-letter code for namibia instead of NA
country_codes <- country_codes %>% 
  mutate(
    Two_Letter_Country_Code = replace(Two_Letter_Country_Code, 
                                      which(Three_Letter_Country_Code == "NAM"), "NAM"),
    
    Country_Name = replace(Country_Name, which(Three_Letter_Country_Code == "NAM"), "Missing/Namibia")
  )

# The Log repository started being tracked in october 2012 to date (2012-10-01)

  start <- as.Date('2019-01-01')
  today <- as.Date('2019-12-31')

  all_days <- seq(start, today, by = 'day')

  year <- as.POSIXlt(all_days)$year + 1900
  
  urls <- paste0('http://cran-logs.rstudio.com/', year, '/', all_days, "-r",'.csv.gz')
  
  for (url_id in 1:length(urls)){
    
    data_name <- str_sub(urls[url_id], start = 35, end = 44)
  
    dataset <- vroom::vroom(urls[url_id], delim = ",") %>% 
      mutate(
        country = replace(country, which(is.na(country)), "NAM")  # Either missing or belongs to Namibia (NA)
      )
    
    # left join with country codes
    dataset_with_country_name <- dataset %>%   # missing country code distorts the statistics
      left_join(country_codes %>% select(Country_Name, 
                                         Two_Letter_Country_Code, 
                                         Continent_Name),by = c("country" = "Two_Letter_Country_Code")) %>% 
      distinct(date, time, size, version, os, country, ip_id, Country_Name, Continent_Name, .keep_all = T)
    
  # export dataset
    dataset_with_country_name %>% 
      write_csv(paste("00 datasets", "/", "daily_Rdownloads209", "/", data_name, ".csv", sep = ""))
    
  }

  