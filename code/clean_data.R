# This code reads in csv data and cleans it
# Author: Beth Secor
library(tidyverse)

# Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"

## Read in data:
COVID_cases_CDC <- read.csv(paste(path,"/data/raw/CDC/total_cases_by_state_territory.csv", sep=""), skip=3, header=T)
head(COVID_cases_CDC)
summary(COVID_cases_CDC)
# change confirmed and probable from character to numeric
COVID_cases_CDC$Confirmed <- as.numeric(COVID_cases_CDC$Confirmed)
COVID_cases_CDC$Probable <- as.numeric(COVID_cases_CDC$Probable)
# note: New York does not include New York City cases
COVID_cases_CDC$State <- ifelse(COVID_cases_CDC$State.Territory == "New York City", "New York", COVID_cases_CDC$State.Territory)

# Remove Puerto Rico and outer islands and combine New York and NYC cases
COVID_cases_CDC_state <- COVID_cases_CDC %>% filter(!(State.Territory %in% c("Puerto Rico","Guam","Virgin Islands","Northern Mariana Islands","American Samoa", "Federated States of Micronesia", "Palau", "Republic of Marshall Islands"))) %>% group_by(State) %>% summarize(st_cases = sum(Total.Cases), st_confirmed = sum(Confirmed), st_probable = sum(Probable)) %>% ungroup()

# Check if query is correct:
summary(COVID_cases_CDC_state)
COVID_cases_CDC[COVID_cases_CDC$State.Territory %in% c("New York City","New York"),]
COVID_cases_CDC_state[COVID_cases_CDC_state$State %in% c("New York"),] #since New York does not track confirmed and probable, NYC's confirmed and probable would not be relevant at the state level.


