# Graphing COVID-19 Data

The purpose of this project is to use data on COVID-19 cases from a few sources to visually track metrics by state.

### Data Sources

1. [CDC COVID Data Tracker Cases in Last 7 days](https://covid.cdc.gov/covid-data-tracker/#cases): ./data/raw/CDC/cases_in_last_7_days_by_state_territory.csv, downloaded September 1, 2020 at 1:02pm
2. [Census State Population Totals](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-state-total.html): ./data/raw/Census/nst-est2019-alldata.csv, downloaded August 31, 2020 (Population, Population Change, and Estimated Components of Population Change: April 1, 2010 to July 1, 2019)
3. [The COVID Tracking Project](https://covidtracking.com/data): ./data/raw/COVID_tracking/all-states-history.csv, downloaded August 31, 2020

### R Code

**R Version:** 4.0.3

**Packages:** [tidyverse](https://www.tidyverse.org/), [usmap](https://cran.r-project.org/web/packages/usmap/usmap.pdf), [viridis](https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html), [directlabels](http://directlabels.r-forge.r-project.org/docs/index.html)

**Note:** Code was written using a macOS operating system, backslashes will need to be changed for use on a Windows operating system.

**Code Order and Output**

1. First need to run the code to clean the data from the data sources listed above and save as output files to be later used for graphing: **clean_data.R**. The output of this code is four files saved to the data folder:  **COVID_7days_byState** (.csv and .Rda) to be used for mapping and **COVID_tracking_COregion** (.csv and .Rda) to be used for graphing metrics over time.

  **Notes:** Interesting issue with collecting data cumulatively, if there is a major correction in the total count one day and you have less cases than the day before, how do you handle all the previous days daily counts? Checking the CDPHE's COVID data page, on August 31 they report 327 PCR tests done by CDPHE and 5491 PCR tests done by other labs, so why do I only have 4690 PCR tests for that day? Is their number the actual number of tests vs. number of people tested?

2. To create a map showing US COVID-19 case incidence per 100,000 in the last 7 days, run the program **map_US_COVID_last7days.R** and it will save a png called **COVID_7days_byState_Map** to the graphs folder.

  **Notes:** I really like this map, especially the color scheme. I originally started out with a simple white to blue color gradient, but found a package called viridis that provides palettes and gradients for colorblind users. Conversion to grayscale also retains the gradient effect. I found this gradient much easier to read than trying to match a shade of a color to the map. Future improvements could be to add a table below with the values, or even better, use something like leaflet to create an interactive map.

  ![Map of COVID cases in last 7 days](https://raw.githubusercontent.com/bethsecor/COVID_Secor/master/graphs/COVID_7days_byState_Map.png)


3. Run graph_COVID_tracking_COregion.R to output line graphs for the following three metrics:

  **Notes:** Wondering what the end goal of graphing these measures is for: to highlight CO and show the difference between it and the neighboring states (what I initially thought of)? to compare all states in the region to each other? should I have summarized the whole region and had three moving averages metrics for the region? Or compared CO to a single neighbor states group?

  a) the 7-day moving average of new cases reported per 100,000 (Output: **COVID_tracking_newcases_7MA.png**). This graph quickly shows that Colorado has been doing really well in flattening the curve, versus the neighboring states.

![7 day moving average for new cases](https://raw.githubusercontent.com/bethsecor/COVID_Secor/master/graphs/COVID_tracking_newcases_7MA.png)

  b) The 7-day moving average of daily PCR tests conducted per 100,000 people (Output: **COVID_tracking_PCR_7MA.png**). This graph shows a general trend of increasing PCR testing over time. Some states don't seem to report daily numbers for testing, but rather reporting a few days worth at a time, making this metric not all that reliable over time. Perhaps it would be smoother if we looked at weekly PCR tests conducted? I noticed when cleaning the data that the cumulative PCR testing count sometimes decreases, which makes it difficult to really rely on cumulative counts before that correction day.

![7 day moving average for new cases](https://raw.githubusercontent.com/bethsecor/COVID_Secor/master/graphs/COVID_tracking_PCR_7MA.png)

  c) The 7-day moving average of percent positivity (person-level positive PCR tests divided by the total number of people who received a PCR test each day (Output: **COVID_tracking_positivity_7MA.png**). This graph suffers from the same issue as the PCR test graph. Some states aren't really reporting daily PCR tests. It does get a bit more reliable for many states after June. After June it looks like Colorado has done a great job at keeping a consistently low positivity rate.

![7 day moving average for new cases](https://raw.githubusercontent.com/bethsecor/COVID_Secor/master/graphs/COVID_tracking_positivity_7MA.png)
