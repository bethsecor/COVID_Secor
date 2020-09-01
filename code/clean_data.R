# This code reads in csv data from the CDC, Census, and The COVID Tracking Project and cleans it to create two final datasets
# Author: Beth Secor
library(tidyverse)

## Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"

## Read in CDC data:
# Last Downloaded: September 1, 2019
COVID_cases_7_CDC <- read.csv(paste(path,"/data/raw/CDC/cases_in_last_7_days_by_state_territory.csv", sep=""), skip=3, header=T)
head(COVID_cases_7_CDC)
summary(COVID_cases_7_CDC)

# note: New York does not include New York City cases
COVID_cases_7_CDC$state <- ifelse(COVID_cases_7_CDC$State.Territory == "New York City", "New York", COVID_cases_7_CDC$State.Territory)

# Remove DC, Puerto Rico, and outer islands and combine New York and NYC cases
# question: Combine DC into Maryland or Virginia or leave it out?
COVID_cases_7_CDC_state <- COVID_cases_7_CDC %>% filter(!(State.Territory %in% c("District of Columbia","Puerto Rico","Guam","Virgin Islands","Northern Mariana Islands","American Samoa", "Federated States of Micronesia", "Palau", "Republic of Marshall Islands"))) %>% group_by(state) %>% summarize(cases.7days = sum(Cases.in.Last.7.Days)) %>% ungroup()

# Check if query is as expected:
summary(COVID_cases_7_CDC_state)
COVID_cases_7_CDC[COVID_cases_7_CDC$State.Territory %in% c("New York City","New York"),]
COVID_cases_7_CDC_state[COVID_cases_7_CDC_state$state %in% c("New York"),]

## Read in Census data:
population_all <- read.csv(paste(path,"/data/raw/Census/nst-est2019-alldata.csv", sep=""), header=T)
head(population_all)
summary(population_all)
# note: 2019 population estimates are as of July 1, 2019 (most recent available from Census)
population_state_2019 <- population_all %>% filter(SUMLEV == 40 & !(NAME %in% c("District of Columbia","Puerto Rico"))) %>% select(NAME, CENSUS2010POP, POPESTIMATE2019) %>% rename(state = NAME)
summary(population_state_2019)

## Merge COVID-19 case counts (last 7 days) with population estimates for 2019 and create incidence per 100,000:
COVID_cases_7_pop_state <- full_join(COVID_cases_7_CDC_state, population_state_2019, by="state") %>% mutate(incidence_7days = cases.7days / POPESTIMATE2019 * 100000)
save(COVID_cases_7_pop_state, file = paste(path,"/data/COVID_7days_byState.Rda",sep=""))
write.csv(COVID_cases_7_pop_state, file = paste(path,"/data/COVID_7days_byState.csv",sep=""))