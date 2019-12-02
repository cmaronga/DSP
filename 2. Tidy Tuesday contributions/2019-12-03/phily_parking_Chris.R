
# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(patchwork)


# Read  Data --------------------------------------------------------

philly <- read_csv("data/2019/2019-12-03/tickets.csv")


# separate date_time column into date & time

philly <- philly %>% 
  separate(issue_datetime, into = c("date", "time"), sep = " ", remove = F)

# create day of the week variable from date column

philly <- philly %>% 
  mutate_at(vars(date), as_date) %>% 
  mutate(
    time2 = as_hms(time),
    d_week = wday(date, label = T, abbr = F),  # day of the week
    wk_year = week(date),  # week of the year
    hr_day = hour(time2) # hour of the day
  )


philly$d_week <- factor(philly$d_week,
                        levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
                                   "Sunday"))


## Visualize tickets each day of the week
ggplot(philly, aes(d_week)) + geom_bar(width = 0.8, fill = "steelblue", col = "black") +
  theme_minimal() + labs(x="Day of the week", y = "Issued tickets", title = "Issued tickets",
                         subtitle = "specific week days in 2017", caption = "Source::Tidy Tuesday") 

# Least number of ticket were issued during the weekends, with Sundays having the lowest number of tickets all year


## time of day tickets were issued
philly <- philly %>% 
  mutate(
    time_categ = case_when(
      hr_day %in% c(6,7,8,9) ~ "06-09Hrs",
      hr_day %in% c(10,11,12,13) ~ "10-13Hrs",
      hr_day %in% c(14,15,16,17) ~ "14-17Hrs",
      hr_day %in% c(18,19,20,21) ~ "18-21Hrs",
      hr_day %in% c(22,23,0,1) ~ "22hrs-midnight",
      hr_day %in% c(2,3,4,5) ~ "01-04Hrs"
    )
  )


## hour of the  day
ggplot(philly, aes(d_week, fill = time_categ)) + geom_bar(width = 0.8, col = "black", position = position_dodge(0.9)) +
  theme_minimal() + labs(x="Day of the week", y = "Issued tickets", title = "Issued tickets",
                         subtitle = "Time of the day", caption = "Source::Tidy Tuesday", fill = "Time of the day") +
  scale_fill_brewer(palette = "Dark2")

# generally in all days of the week across the year, many tickets were issued between 10 - 13 hrs
# with an exception of Sundays with slightly many tickets being issued between 14-17hrs
















