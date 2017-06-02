BikeData = read.csv(file.choose())

library(tidyverse)

#Identify all unique stations by ID number
UniqueStations = distinct(BikeData, end.station.id, .keep_all = TRUE)

#Trim off starting points and just use end --> because there are more end than start stations
myvars = c("end.station.id", "end.station.name", "end.station.latitude", "end.station.longitude")
UniqueStations1 = UniqueStations[myvars]

#install.packages("devtools")
library(devtools)
#install_github("rodazuero/gmapsdistance")
library(gmapsdistance)

set.api.key("AIzaSyAoH8SwrWY1dPro21KnWz52Sj1HjZEhe_Q")
set.api.key("API KEY")

UniqueStations1$LatLong = paste(UniqueStations1$end.station.latitude, UniqueStations1$end.station.longitude, sep="+")

temp1 <- gmapsdistance(origin = UniqueStations1[, 5],
                       destination = UniqueStations1[, 5],
                       mode = "bicycling")

resultsDist <- data.frame(matrix(unlist(temp1$Distance), nrow=689, byrow=F),stringsAsFactors=FALSE)
resultsTime <- data.frame(matrix(unlist(temp1$Time), nrow=689, byrow=F),stringsAsFactors=FALSE)

resultsDist <- subset(resultsDist, select = -X1)
resultsTime <- subset(resultsTime, select = -X1)

colnames(resultsDist) <- UniqueStations1$end.station.id
rownames(resultsDist) <- UniqueStations1$end.station.id

colnames(resultsTime) <- UniqueStations1$end.station.id
rownames(resultsTime) <- UniqueStations1$end.station.id

BikeData$Distance = sapply(1:nrow(BikeData), function(i) 
  resultsDist[rownames(resultsDist)==BikeData$start.station.id[i],
              colnames(resultsDist)==BikeData$end.station.id[i]])

BikeData$DistTime = sapply(1:nrow(BikeData), function(i) 
  resultsTime[rownames(resultsTime)==BikeData$start.station.id[i],
              colnames(resultsTime)==BikeData$end.station.id[i]])


