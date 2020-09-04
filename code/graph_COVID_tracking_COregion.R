# Graph the metrics for 7 day moving averages of data from The COVID Tracking Project
# Author: Beth Secor
library(tidyverse)
library(viridis)

## Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"
## Date data was last downloaded
downdate <- "August 31, 2020"

load(paste(path, "/data/COVID_tracking_COregion.Rda", sep=""))
summary(COVID_tracking_COregion)

states <- unique(COVID_tracking_COregion$state_abrv)
order_st <- c(1,2,3,9,4,5,6,7,8)

COVID_tracking_COregion <- COVID_tracking_COregion %>%
	mutate(line_col_CO = ifelse(state_abrv == "CO", "CO", "Neighboring State"),
		   line_draw_order = order_st[match(state_abrv, states)])
summary(COVID_tracking_COregion)

head(as.data.frame(COVID_tracking_COregion[COVID_tracking_COregion$state_abrv == "CO",]))

#a) the 7-day moving average of new cases reported per 100,000,

#COVID_tracking_newcase_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=newcase_7MA, group=state_abrv)) +
	geom_line(aes(group= line_draw_order, color=line_col_CO)) +
	ylab("7-day moving average of new cases reported per 100,000") +
	xlab("Month") +
	labs(title = "7-day Moving Average of New Cases Reported per 100,000", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project and US Census") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=6) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12)) +
	scale_color_manual("",values=c("purple", "gray"))
	
#ggsave(paste(path, "/graphs/COVID_tracking_newcases_7MA.png", sep=""), COVID_tracking_newcase_7MA, width=8, height=10, dpi=600)

#b) The 7-day moving average of daily PCR tests conducted per 100,000 people, and

#COVID_tracking_PCR_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=PCR_7MA, group=state_abrv)) +
	geom_line(aes(group= line_draw_order, color=line_col_CO)) +
	ylab("7-day moving average of daily PCR tests conducted per 100,000") +
	xlab("Month") +
	labs(title = "7-day Moving Average of Daily PCR tests Conducted per 100,000", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project and US Census") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=6) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12)) +
	scale_color_manual("",values=c("purple", "gray"))
	
#ggsave(paste(path, "/graphs/COVID_tracking_PCR_7MA.png", sep=""), COVID_tracking_PCR_7MA, width=8, height=10, dpi=600)

#c) The 7-day moving average of percent positivity (person-level positive PCR tests divided by the total number of people who received a PCR test each day).

#COVID_tracking_positivity_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=positivity_7MA, group=state_abrv)) +
	geom_line(aes(group= line_draw_order, color=line_col_CO)) +
	ylab("7-day moving average of percent positivity") +
	xlab("Month") +
	labs(title = "7-day Moving Average of Percent Positivity ", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project and US Census") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=6) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12)) +
	scale_color_manual("",values=c("purple", "gray"))
	
#ggsave(paste(path, "/graphs/COVID_tracking_positivity_7MA.png", sep=""), COVID_tracking_positivity_7MA, width=8, height=10, dpi=600)

### Messing around with a plot for the most recent day's data:

last(COVID_tracking_COregion$date)
COVID_tracking_COregion_last <- as.data.frame(COVID_tracking_COregion %>%
	filter(date == last(date)))

