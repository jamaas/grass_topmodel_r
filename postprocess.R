#!/usr/bin/env Rscript
## Tidies up final part of Topmodel output for easy R processing
## Again copied from Roy Sanderson at Newcastle by JAM at UEA
## Created on 17/03/2016

## Last modified on 21/11/2016

rm(list=ls())

options(scipen=-10)

args <- commandArgs(trailingOnly=TRUE)
ntimesteps <- as.numeric(args[1])
walk_area <- as.character(args[2])
map_size <- as.character(args[3])

## ntimesteps <- 730
## walk_area <- as.character("GH")
## map_size <- as.character("sm")

## read in output data from topmodel for this particular walk area
topmod.dat <- read.table(paste ("topmod_output_", walk_area, map_size,
                                ".txt", sep =""), header=TRUE, sep=" ")

## calculate a couple of mean values to check performance of model of setting
## parameter values, these will be turned off when not doing parameterization
## topmod.dat$meanqt <- mean(topmod.dat$qt)
## topmod.dat$meanqo <- mean(topmod.dat$qo)

## round the long numbers to 5 significant digits to make it easier to read
weather.dat <- signif (read.table(paste (walk_area, "_Rn_Tp_Ep.txt", sep=""),
                                   header=FALSE, sep=" "), 3)

## set the three column names to ones that are required
colnames(weather.dat) <- c("rain", "temp", "Ep")

## Grab this file as it also has all the dates
dates.dat <- read.csv(file = "./EW2WeatherData.csv", sep=",", header=TRUE)

## actual dates are only in second column
date <- dates.dat[ ,2]

## column bind the results together, the walk area, the dates, the weather data
## including rain, temp and evapotranspiration
results1 <- cbind(walk_area, date, weather.dat, topmod.dat)

## rearrange column order
results2 <- results1[ , c(6,1:5,7:12)]

## change column names, latex doesn't like underscores!
colnames(results2)[c(2,12)] <- c("walk-area", "Smean")

## write the results out for this particular walk area
write.csv(results2, file = paste(walk_area, map_size, "_results.csv", sep=""),
          row.names=FALSE)

## when preparing for publishing, produce a latex object from a part of the
## results file

## library(dplyr)
## library(broom)
## library(pixiedust)

## results.print <- results2[289:325, ]

## head(results.print, 5)

## ##options(scipen=0)

## head(results.print, 5)

## stuff <- results.print %>%
##       dust %>%
##       sprinkle_print_method("latex") %>%
##       sprinkle(font_size=6L, tabcolsep = 3L) %>%
##       print(asis = FALSE) %>%
##       cat()
