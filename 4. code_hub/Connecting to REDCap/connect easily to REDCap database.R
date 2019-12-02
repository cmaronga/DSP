## Required package
library(redcapAPI)

# create a connection (supply token and REDCap URL)
connection <- redcapConnection(url = 'https://your_redcap_link_name/api/',  # API specific URL
                               token = 'paste your token here')  # token from REDCap


## Exporting records
my_dataset <- exportRecords(connection)  # export all records


?exportRecords  ## for more customized exporting of REDCaps


## alternative package
library(REDCapR)

browseURL("https://ouhscbbmc.github.io/REDCapR/reference/redcap_read.html")
