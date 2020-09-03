# Create a map of the US showing the incidence per 100,000 of COVID cases in the last 7 days
# Author: Beth Secor
library(tidyverse)
library(usmap)
library(gridExtra)

## Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"
## Date data was last downloaded
downdate <- "September 1, 2020 at 1:02pm"

load(paste(path, "/data/COVID_7days_byState.Rda", sep=""))
summary(COVID_7days_byState)

# Round incidence to 1 decimal point
inc.tbl <- data.frame(COVID_7days_byState[,c("state","incidence_7days")])
inc.tbl$incidence_7days <- round(inc.tbl$incidence_7days, 1)

# Create map using plot_usmap, which returns a ggplot2 object
covid_7inc_map <- plot_usmap(data = inc.tbl, values = "incidence_7days",  color = "#423bcc", labels=F) + 
  scale_fill_continuous(low = "white", high = "#423bcc", 
   name = "Incidence of Cases in Last 7 Days per 100,000", label = scales::comma) + 
  labs(title = "Incidence of COVID-19 Cases in the Last 7 Days per 100,000", subtitle=paste("As Reported to the CDC on ", downdate, sep=""), caption = "Source: CDC and US Census") +
    theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=10), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12))

ggsave(paste(path, "/graphs/COVID_7days_byState_Map.png", sep=""), covid_7inc_map, width=10, height=8, dpi=600)

# Future improvements could be to add a table below with the values, or even better, use something like leaflet to create an interactive map.