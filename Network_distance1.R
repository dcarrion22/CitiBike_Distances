BikeData = read.csv(file.choose())

BikeDatasubset = BikeData[1:20, ]

library(tidyverse)

#Identify all unique stations by ID number
UniqueStations = distinct(BikeDatasubset, start.station.id, .keep_all = TRUE)

#Trim off destinations
myvars = c("start.station.id", "start.station.name", "start.station.latitude", "start.station.longitude")
UniqueStations1 = UniqueStations[myvars]

#install.packages("gmapsdistance")

#install.packages("devtools")
library(devtools)
#install_github("rodazuero/gmapsdistance")
library(gmapsdistance)

set.api.key("API KEY")

UniqueStations1$LatLong = paste(UniqueStations1$start.station.latitude, UniqueStations1$start.station.longitude, sep="+")

temp1 <- gmapsdistance(origin = UniqueStations1[, 5],
                       destination = UniqueStations1[, 5],
                       mode = "bicycling")

resultsDist <- data.frame(matrix(unlist(temp1$Distance), nrow=18, byrow=F),stringsAsFactors=FALSE)
resultsTime <- data.frame(matrix(unlist(temp1$Time), nrow=18, byrow=F),stringsAsFactors=FALSE)

resultsDist <- subset(resultsDist, select = -X1)
resultsTime <- subset(resultsTime, select = -X1)

colnames(resultsDist) <- UniqueStations1$start.station.id
rownames(resultsDist) <- UniqueStations1$start.station.id

colnames(resultsTime) <- UniqueStations1$start.station.id
rownames(resultsTime) <- UniqueStations1$start.station.id

BikeDatasubset$Distance = sapply(1:nrow(BikeDatasubset), function(i) 
                          resultsDist[rownames(resultsDist)==BikeDatasubset$start.station.id[i],
                                      colnames(resultsDist)==BikeDatasubset$end.station.id[i]])

BikeDatasubset$DistTime = sapply(1:nrow(BikeDatasubset), function(i) 
  resultsTime[rownames(resultsTime)==BikeDatasubset$start.station.id[i],
              colnames(resultsTime)==BikeDatasubset$end.station.id[i]])

unique(BikeData$start.station.id)

unique(BikeData$end.station.id)
unique(BikeData$start.station.id)

length(unique(BikeData$end.station.id))
length(unique(BikeData$start.station.id))

setdiff(BikeData$end.station.id, BikeData$start.station.id)
