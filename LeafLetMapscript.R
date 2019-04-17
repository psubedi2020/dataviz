
library(leaflet)
library(htmltools)
library(rgdal)

library(dplyr)

cities <- read.csv(textConnection("
Company,Lat,Long,Years,Hourly
NVCC,38.6183312,-77.2944831,1,9
GMU,38.830665,-77.3088917,1,7
INLS,38.915618,-77.0501627,4,1
Walcoff Technologies (now DDL Omni Engineering),38.8595866,-77.365037,4,35
RCI (now Serco),38.8830157,-77.2281617,5,55
ACS (now XeRox),39.2006021,-77.2628966,3,50
CareFirst of Maryland,39.4078582,-76.7969309,6,55
Center for Medicare and Medicaid with Acentia,39.185313,-76.8063225,1,62
Remote work for LegalShield Ada OK with SystemOne,39.267196,-76.8153927,.25,70
Modis w/ CSRA,39.3264819,-76.7496914,.25,75
Freddie Mac with Experis,38.9327908,-77.2292522,.2,70
The Iron Yard,38.8985656,-77.0315957,1,69
PNC Bank with Mastech,40.4417929,-80.0030184,1.25,75
DCCA with Teksystems,39.246257,-76.8345331,.3,85
"))


leaflet(data = cities) %>% addTiles()  %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1, 
             radius = ~sqrt(Years * Hourly) * 500, popup = ~Company
  )  %>%
  
  addLegend("bottomright", colors= "#ffa500", labels="Size of bubles indicate number of years.", title="Prakash Subedi's Professional Expreriences Locations")





