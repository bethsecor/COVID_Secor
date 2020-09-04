# Graph the metrics for 7 day moving averages of data from The COVID Tracking Project
# Author: Beth Secor
library(tidyverse)
library(directlabels)

## Path to git repository:
path <- "~/Documents/CDPHE/COVID_Secor"
## Date data was last downloaded
downdate <- "August 31, 2020"

load(paste(path, "/data/COVID_tracking_COregion.Rda", sep=""))
summary(COVID_tracking_COregion)

# create a drawing order for the lines, CO is number 4, but it will be drawn last to see it better
states <- unique(COVID_tracking_COregion$state_abrv)
order_st <- c(1,2,3,9,4,5,6,7,8)

COVID_tracking_COregion <- COVID_tracking_COregion %>%
	mutate(line_col_CO = ifelse(state_abrv == "CO", "CO", "Neighboring State"),
		   line_draw_order = order_st[match(state_abrv, states)])
summary(COVID_tracking_COregion)

# check if CO is last to be drawn
head(as.data.frame(COVID_tracking_COregion[COVID_tracking_COregion$state_abrv == "CO",]))

# Wondering what the end goal of graphing these measures is for: to highlight CO and show the difference between it and the neighboring states (what I initially thought of)? to compare all states in the region to each other? should I have summarized the whole region and had three moving averages metrics for the region?

# a) the 7-day moving average of new cases reported per 100,000

COVID_tracking_newcase_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=newcase_7MA, group=state_abrv, color=line_col_CO)) +
	geom_line(aes(group= line_draw_order)) +
	ylab("7-day moving average of new cases reported per 100,000") +
	xlab("Month") +
	labs(title = "7-Day Moving Average of New Cases Reported per 100,000", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project and US Census") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=12) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12), axis.title=element_text(size=12), axis.text=element_text(size=11, color="black")) +
	scale_color_manual("",values=c("darkorchid3","darkgray")) +
	geom_dl(aes(label= state_abrv), method=list("last.polygons", cex = 0.8))


ggsave(paste(path, "/graphs/COVID_tracking_newcases_7MA.png", sep=""), COVID_tracking_newcase_7MA, width=8, height=8, dpi=600)

# b) The 7-day moving average of daily PCR tests conducted per 100,000 people

COVID_tracking_PCR_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=PCR_7MA, group=state_abrv, color=line_col_CO)) +
	geom_line(aes(group= line_draw_order)) +
	ylab("7-day moving average of daily PCR tests conducted per 100,000") +
	xlab("Month") +
	labs(title = "7-Day Moving Average of Daily PCR tests Conducted per 100,000", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project and US Census") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=12) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12), axis.title=element_text(size=12), axis.text=element_text(size=11, color="black")) +
	scale_color_manual("",values=c("deepskyblue3","darkgray")) +
	geom_dl(aes(label= state_abrv), method=list("last.polygons", cex = 0.8))
	
ggsave(paste(path, "/graphs/COVID_tracking_PCR_7MA.png", sep=""), COVID_tracking_PCR_7MA, width=8, height=8, dpi=600)

# c) The 7-day moving average of percent positivity (person-level positive PCR tests divided by the total number of people who received a PCR test each day

COVID_tracking_positivity_7MA <- 
COVID_tracking_COregion %>%
	ggplot(aes(x=date_fmt, y=positivity_7MA, group=state_abrv, color=line_col_CO)) +
	geom_line(aes(group= line_draw_order)) +
	ylab("7-day moving average of percent positivity") +
	xlab("Month") +
	labs(title = "7-Day Moving Average of Percent Positivity ", subtitle=paste("as reported up to ", downdate, sep=""), caption = "Source: The COVID Tracking Project") +
	scale_x_date(date_breaks = "months", date_labels = "%b") + 
	scale_y_continuous(n.breaks=12) +
	theme_bw() +
	theme(plot.title = element_text(size=16, hjust=0.5), plot.subtitle=element_text(size=12, hjust=0.5), plot.caption=element_text(size=10), legend.position = "bottom", legend.text=element_text(size=12), legend.key.width=unit(3,"lines"), legend.title=element_text(size=12), axis.title=element_text(size=12), axis.text=element_text(size=11, color="black")) +
	scale_color_manual("",values=c("tomato","darkgray")) +
	geom_dl(aes(label= state_abrv), method=list("last.polygons", cex = 0.8))
	
ggsave(paste(path, "/graphs/COVID_tracking_positivity_7MA.png", sep=""), COVID_tracking_positivity_7MA, width=8, height=8, dpi=600)

### Messing around with a plot for the most recent day's data:

last(COVID_tracking_COregion$date)
COVID_tracking_COregion_last <- as.data.frame(COVID_tracking_COregion %>%
	filter(date == last(date)))

ggplot(COVID_tracking_COregion_last, aes(x= newcase_7MA, y= PCR_7MA, size = positivity_7MA)) +
    geom_point(alpha=0.7) +
    geom_text(aes(label=state_abrv), size=5, nudge_x=0.0, nudge_y=-0.15)
# Abandoning this graph, I don't think it's easily read by anyone, one might ask, why are the positivity rates of WY and NM so different when they have similar new case incidence and PCR testing incidence? An average of rates is different than the average numerator divided by the average denominator.
