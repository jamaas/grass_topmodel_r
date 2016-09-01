## This R script pulls in the output files for the Great Harwood (GH) walk area,
## and then merges in the bootsock Campylobacter presence data.  It then
## analyses the data and produces results for GH only, for publishing the
## methods paper. It was first produced at UEA by JAM on 08/08/2016

## Last modified on 31/08/2016

## remove any old variables or libraries hanging around
rm(list=ls())

## add necessary libraries
library(plyr)
library(dplyr)
library(ggplot2)
library(lme4)
library(sjmisc)
library(sjPlot)
library(forecast)
library(stringr)
library(zoo)
library(broom)
library(pixiedust)
library(gridExtra)
library(xtable)
library(mgcv)
library(effects)
library(lattice)
library(phia)
library(survey)

## create a vector named "wknm" containing the abbreviated names for the six
## individual walk areas
wknm <- "GH"

## Read in the topmodel output (.csv) file into a data.frame using the vector of
## short names
AllOutputs <- ldply(wknm, function(x) read.csv
               (file = paste("../", x, "sm_results.csv", sep = "")))

## convert dates from factor format to POSIXct
AllOutputs$date <- as.POSIXct(AllOutputs$date)

## read in Campylobacter prevelance data file, remove first column as
## unnecssary, set date column to POSIXct, location column to character, and
## presence to integer
CampyData <- read.csv(file = "../GHPosBootSock.csv",
           colClasses = c("NULL", "POSIXct", "character", "integer") )

## replace the long string names with short ones so the topmodel outputs data
## can be merged with the Campylobacter presence data
CampyData$location <- str_replace_all(str_c(CampyData$location),
    c("Great Harwood" = "GH"))

## import the livestock number data
LsData <- read.csv(file = '../GH_livestock2.csv',
                   header = FALSE)

livestock_cols <- c('livewalkarea', 'poultry', 'cattle', 'horses', 'goats',
                    'deer', 'sheep', 'pigs', 'animalunits')

colnames(LsData) <- livestock_cols

## merge the two files, results from topmodel and also the Campy presence data,
## together by walk area and date.  This data is daily for the complete two year
## period for all of 2013 and 2014.
CombinedOutput1 <- merge(AllOutputs, CampyData, by.x = c("walk.area",
    "date"), by.y = c("location", "walk.date"), all.x = TRUE)

## now merge in the livestock data for statistical analysis
CombinedOutput2 <- merge(CombinedOutput1, LsData, by.x = "walk.area",
                         by.y = "livewalkarea", all.x = TRUE)

## calculate cumulative sums of rainfall data to see if that explains more
## variance in the statistical analysis

## first is to calculate the rain quantity on the day prior to the walk day
CombinedOutput2$rain1d <- rollapply(CombinedOutput2$rain, list(seq(-1,-1,1)),
    sum, fill = mean(CombinedOutput2$rain), align = "right")

## next rain cumulative sum over two days prior to the walk day
CombinedOutput2$rain2d <- rollapply(CombinedOutput2$rain, list(seq(-2,-1,1)),
    sum, fill = mean(CombinedOutput2$rain), align = "right")

## next rain cumalative sum for five days prior to walk day
CombinedOutput2$rain5d <- rollapply(CombinedOutput2$rain, list(seq(-5,-1,1)),
    sum, fill = mean(CombinedOutput2$rain), align = "right")

## next rain cumalative sum for ten days prior to the walk day
CombinedOutput2$rain10d <- rollapply(CombinedOutput2$rain, list(seq(-10,-1,1)),
      sum, fill = mean(CombinedOutput2$rain), align = "right")

## calculate cumulative mean of temperature data to see if that explains more
## variance in the statistical analysis

## first calculation the temp on the day prior to the walk day
CombinedOutput2$temp1d <- rollapply(CombinedOutput2$temp, list(seq(-1,-1,1)),
    mean, fill = mean(CombinedOutput2$temp), align = "right")

## next calculate the temp mean over two days prior to the walk day
CombinedOutput2$temp2d <- rollapply(CombinedOutput2$temp, list(seq(-2,-1,1)),
    mean, fill = mean(CombinedOutput2$temp), align = "right")

## next calculate temp mean for five days prior to walk day
CombinedOutput2$temp5d <- rollapply(CombinedOutput2$temp, list(seq(-5,-1,1)),
    mean, fill = mean(CombinedOutput2$temp), align = "right")

## next calculate temp mean for ten days prior to the walk day
CombinedOutput2$temp10d <- rollapply(CombinedOutput2$temp, list(seq(-10,-1,1)),
                                     mean, fill = mean(CombinedOutput2$temp), align = "right")

## create a column for number of walkers (walkdernum) per walk for later glm
## analysis
CombinedOutput2$walkernum <- 3

## create a colum for number of negative bootsocks (neg.bs) per walk for odds
## ratio calculations
CombinedOutput2$neg.bs <- CombinedOutput2$walkernum - CombinedOutput2$pres.final


## clean up the column order just for aesthetics! :-)
CombinedOutput2 <- select(CombinedOutput2, walkarea = walk.area, timestep,
                          date, rain, rain1d, rain2d, rain5d, rain10d, temp,
                          temp1d, temp2d, temp5d, temp10d, Ep, Qt, qt, qo, qs,
                          qv, Smean, poultry, cattle, horses, goats, deer,
                          sheep, pigs, animalunits, walkernum, pos.bs = pres.final,
                          neg.bs)

## reduce data set down to complete cases only, remove those with missing data,
## should reduce to 40 rows
co2 <- CombinedOutput2[complete.cases(CombinedOutput2), ]
rownames(co2) <- NULL
summary(co2)

## create a function to do the graphing of the data for each individual walk
## area
multiplot <- function(walk) {
    par(mfrow = c(4, 2) + .2)
    plot(rain1d ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], ylim = c(0, 0.08), type = "l")
    plot(Ep ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(qt ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(qo ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(qs ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(qv ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(Smean ~ date, data = CombinedOutput2[CombinedOutput2$walkarea ==
        walk, ], type = "l")
    plot(pos.bs[walkarea == walk] ~ date[walkarea == walk],
        data = CombinedOutput2, xlab = paste("walk ", walk, sep = ""),
        ylab = "Positives", type = "h")
    par(mfrow = c(1, 1))
}

## start the pdf function that will save the graphs as pdfs
pdf(paste("GH_plots_publish.pdf", sep=""))

## do all the plots for GH walk area using the input list and the
## function and create pdf
lapply(wknm, multiplot)

## turn off the pdf device
dev.off()

## Now to do some stats on the outputs

## calculate the correlation between quantity of rain1d on the day and
## Campylobacter presence, note that the statement use = "pairwise.complete.obs"
## causes the correlations to use only complete data, i.e. only for the days
## when walks were done.
(rain1d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$rain1d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between quantity of rain, summed for two days
## prior, and Campylobacter presence
(rain2d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$rain2d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between quantity of rain, summed for five days
## prior, and Campylobacter presence
(rain5d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$rain5d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between quantity of rain, summed for ten days
## prior, and Campylobacter presence
(rain10d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$rain10d, .$pos.bs, use = "pairwise.complete.obs"))))

## pull together all the rain correlation outputs into one data frame
(GH_all_rain_cor <- bind_rows(rain1d_pres_cor, rain2d_pres_cor, rain5d_pres_cor,
                          rain10d_pres_cor, .id = "id"))

## calculate the correlation between temp on the day before and
## Campylobacter presence, note that the statement use = "pairwise.complete.obs"
## causes the correlations to use only complete data, i.e. only for the days
## when walks were done.
(temp1d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$temp1d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between temp, mean for two days
## prior, and Campylobacter presence
(temp2d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$temp2d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between temp, mean for five days
## prior, and Campylobacter presence
(temp5d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$temp5d, .$pos.bs, use = "pairwise.complete.obs"))))

## calculate the correlation between temp, mean for ten days
## prior, and Campylobacter presence
(temp10d_pres_cor <- co2 %>%
    do(tidy(cor.test(.$temp10d, .$pos.bs, use = "pairwise.complete.obs"))))

## pull together all the temp correlation outputs into one data frame
(GH_all_temp_cor <- bind_rows(temp1d_pres_cor, temp2d_pres_cor, temp5d_pres_cor,
                          temp10d_pres_cor, .id = "id"))

## set the theme for the pdf outputs
mytheme <- gridExtra::ttheme_default(
    core = list(fg_params=list(fontsize = 8)))

## print the pdf of all rain fall and Campylobacter presence correlations
pdf("GH_all_rain_cor.pdf", paper = "a4")
grid.table(GH_all_rain_cor, theme = mytheme)
dev.off()

## print the pdf of all temp and Campylobacter presence correlations
pdf("GH_all_temp_cor.pdf", paper = "a4")
grid.table(GH_all_temp_cor, theme = mytheme)
dev.off()

## calculate the correlation between overland flow on the day and presence
(qo_pres_cor <- co2 %>%
    do(tidy(cor.test(.$qo, .$pos.bs, use = "pairwise.complete.obs"))))

## print the pdf of overland flow and Campylobacter presence correlations
pdf("GH_qo_pres_cor.pdf", paper = "a4")
grid.table(qo_pres_cor, theme = mytheme)
dev.off()

## calculate the correlation between subsurface flow on the day and presence
(qs_pres_cor <- co2 %>%
    do(tidy(cor.test(.$qs, .$pos.bs, use = "pairwise.complete.obs"))))

## print the pdf of overland flow and Campylobacter presence correlations
pdf("GH_qs_pres_cor.pdf", paper = "a4")
grid.table(qs_pres_cor, theme = mytheme)
dev.off()

## calculate the correlation beween total flow, per unit area and presence
(qt_pres_cor <- co2 %>%
    do(tidy(cor.test(.$qt, .$pos.bs, use = "pairwise.complete.obs"))))

## print the pdf of total flow and Campylobacter presence correlations
pdf("GHqt_pres_cor.pdf", paper = "a4")
grid.table(qt_pres_cor, theme = mytheme)
dev.off()



## do the final glm analysis for this walk area only
final_analy <- co2 %>%
    glm (cbind (pos.bs, neg.bs) ~ rain10d + temp5d + qo,
         data = ., family = "binomial")


summary(final_analy)


