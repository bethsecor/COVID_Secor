# This code reads in csv data from the CDC, Census, and The COVID Tracking Project and cleans it to create two final datasets
# Author: Beth Secor
library(tidyverse)

## Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"

# US COVID-19 case incidence per 100,000 in the last 7 days.
# You'll also need to find and use state-level population estimates.
# Please only include the 48 continental US states, Alaska, and Hawaii in your final figure.

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
# note: the population estimates the CDC are using seem to be a bit lower than these estimates for 2019

# Merge COVID-19 case counts (last 7 days) with population estimates for 2019 and create incidence per 100,000:
COVID_cases_7_pop_state <- full_join(COVID_cases_7_CDC_state, population_state_2019, by="state") %>% mutate(incidence_7days = cases.7days / POPESTIMATE2019 * 100000)
save(COVID_cases_7_pop_state, file = paste(path,"/data/COVID_7days_byState.Rda",sep=""))
write.csv(COVID_cases_7_pop_state, file = paste(path,"/data/COVID_7days_byState.csv",sep=""))

## Read in data from The COVID Tracking Project:

# a) the 7-day moving average of new cases reported per 100,000,
# b) The 7-day moving average of daily PCR tests conducted per 100,000 people, and
# c) The 7-day moving average of percent positivity (person-level positive PCR tests divided by the total number of people who received a PCR test each day).
# All three metrics should include Colorado and our neighboring states, including Texas (Colorado, Wyoming, Nebraska, Kansas, Oklahoma, Texas, New Mexico, Arizona, Utah)

# note from website: US states and territories report data in differing units and with varying definitions. Our national summary Cases, Tests, and Outcomes numbers are simple sums of the data states and territories provide, but because of the disparate metrics they include, they should be considered estimates.

# data dictionary here: https://covidtracking.com/about-data/data-definitions

COVID_tracking_all <- read.csv(paste(path,"/data/raw/COVID_tracking/all-states-history.csv", sep=""), header=T)
head(COVID_tracking_all)
summary(COVID_tracking_all)
last_day <- 20200831
COVID_tracking_7days_COregion <- COVID_tracking_all %>% filter((date <= last_day & date >= (last_day - 7)) & state %in% c("CO","WY","NE","KS","OK","TX","NM", "AZ", "UT")) %>% select(state, date, positiveIncrease, positiveCasesViral, negative, negativeTestsViral, positiveTestsViral, totalTestsPeopleViral, totalTestsViral, totalTestEncountersViral) %>% group_by(date, state)

table(COVID_tracking_7days_COregion$date, COVID_tracking_7days_COregion$state)
COVID_tracking_7days_COregion[COVID_tracking_7days_COregion$state == "CO",]
COVID_tracking_7days_COregion[COVID_tracking_7days_COregion$state == "KS",]
# note: KS does not report the column positiveCasesViral. Since they do not report antibody tests, assume that positiveIncrease is the number of new cases and new positive PCR tests.

COVID_tracking_7days_COregion_cnts <- COVID_tracking_7days_COregion %>%
	group_by(state) %>%
	arrange(date) %>%
	mutate(positivePCRincrease = ifelse(state == "KS", positiveIncrease, positiveCasesViral - lag(positiveCasesViral, default = first(positiveCasesViral))), negativePCRincrease = negative - lag(negative, default = first(negative)), pct_positive = ifelse(negativePCRincrease != 0, positivePCRincrease / (positivePCRincrease + negativePCRincrease) * 100, NA)) %>%
	select(state, date, positiveIncrease, positiveCasesViral, positivePCRincrease, negative, negativePCRincrease, pct_positive) %>%
	filter(date > (last_day - 7))
	
COVID_tracking_7days_COregion_cnts[COVID_tracking_7days_COregion_cnts$state == "OK",]
COVID_tracking_7days_COregion_cnts[COVID_tracking_7days_COregion_cnts$state == "KS",]
# note: OK did not report an increase in negative PCR tests for 8/30 and 8/31