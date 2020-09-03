# Graphing COVID-19 Data

The purpose of this project is to use data on COVID-19 cases from a few sources to visually track metrics by state.

### Data Sources

1. [CDC COVID Data Tracker Cases in Last 7 days](https://covid.cdc.gov/covid-data-tracker/#cases): ./data/raw/CDC/cases_in_last_7_days_by_state_territory.csv, downloaded September 1, 2020 at 1:02pm
2. [Census State Population Totals](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-state-total.html): ./data/raw/Census/nst-est2019-alldata.csv, downloaded August 31, 2020 (Population, Population Change, and Estimated Components of Population Change: April 1, 2010 to July 1, 2019)
3. [The COVID Tracking Project](https://covidtracking.com/data): ./data/raw/COVID_tracking/all-states-history.csv, downloaded August 31, 2020

### R Code

**R Version:** 4.0.3

**Packages:** [tidyverse](https://www.tidyverse.org/)

**Note:** Code was written using a macOS operating system, backslashes will need to be changed for use on a Windows operating system.

**Code Order**

1. First need to run the code to clean the data from the data sources listed above and save as output files to be later used for graphing: **clean_data.R**
