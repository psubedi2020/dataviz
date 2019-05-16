
library(leaflet)
library(htmltools)
library(rgdal)

library(dplyr)

cities <- read.csv(textConnection("
Company,Lat,Long,Years,Hourly
Washington DC: Delivered Java Crash course to group of meetup participants,38.8985656,-77.0315957,8,69
Orlando FL: Delivered Instructor Led training on Java and Spring JPA,28.5421194,-81.3874442,2,69
Charlott NC; Delivered Instructor Led training on Java and Spring JPA,35.2269725,-80.8481366,2,69
Cincy OH: Trained and menotored on coding bootcamp instructional delivery Git,39.105145,-84.5120602,1,69
Woodbridge VA: Delivered Instructor led coding boot camp training on Java Spring AndroidSDK SQL HTML CSS Bootstrap JavaScript AngularJS AWS Heroku jHipster Agile Scrum Methodology,38.6217323,-77.2936578,16,69
BCBS of NC Durham NC:  Taught MEAN Crash course on Mongo Express Angular Node,35.9522669,-78.9640229,1,69
Ally Financial Detroit MI: Delivered Corporate Upskilling Training on Java Spring REST Spring JPA Jenkins AnguarJS,42.3285642,-83.0449688,3,69 
Liberty Mutual Carmel IN: Devliered Java Spring Security Spring JPA Angular Upskilling training,39.9433796,-86.1632651,4,69
Austin TX: Delivered Instructor led training on Java Spring JPA REST Swagger AngularJS,30.2253303,-97.762282,4,69 
"))


leaflet(data = cities) %>% addTiles()  %>%
  addCircles(lng = ~Long, lat = ~Lat, weight = 1, 
             radius = ~sqrt(Years * Hourly * 50) * 500, popup = ~Company
  )  %>%
  
  addLegend("bottomright", colors= "#ffa500", labels="Size of bubles indicate number of weeks.", title="Instructor Led Trainings Delivered by Prakash Subedi in 2016-17.")





