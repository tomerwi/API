# API


 
**This dataset contains information about car races between the year 1990 and 2015. **


Main Columns in the datatable:
- number - id of the driver in the races.
- Points - score for a driver in a specific race
- Position - position for driver in a specific race (1st,2st and so...)
- Driver nationality - Country birth of the driver (numeric data)
- Constructor name - Technical assistant of the driver

**Code**

library("jsonlite", lib.loc="~/R/win-library/3.2")

//store all pages in a list first

baseurl <- "http://ergast.com/api/f1/"

baseurl2 <- "/1/results.json"

pages <- list()

for(i in 1990:2015){

  message(paste0(baseurl, i, baseurl2))
  
  mydata <- fromJSON(paste0(baseurl, i, baseurl2))
  
  mydata<-mydata$MRData$RaceTable$Races$Results[[1]]
  
  message("Retrieving page", i)
  
  pages[[i+1]] <- mydata
  
}


//combine all into one

filings <- rbind.pages(pages)


**End of code**


First, we load the libaries that we need in order to get and parse the json file.
Becuase the information from one race wasn't enough, we had to retrieve information from 20 races (see loop).
Finally, we combine the lists into one big dataframe. 





![alt tag](/pic/number_of_cars_per_races.jpg)

The photo shows the crimes distribution across Sacremento. 
the districts were divided crimes - north and south. district number bigger then 3 are in the north while the rest in the south.
As we can see, more crimes were commited in the south (red color). It is known that south Sacramento is considred less reacher area then the north, which can describe the fact about the crimes distribution. 

**Code**

barplot(table(crimes$district),col = "wheat",main = "number of crimes in each district")

**End code**


![alt tag](/pic/number_of_crimes.jpg)

This plot shows the number of crimes in each district. As we can see, district 3 has the highest crimes number. It is located in south Sacramento, which has more crimes.

**Code**

library("mlbench")
library("caret")

library("pROC")

library("e1071")

set.seed(7584)
crimes$district<-as.factor(crimes$district)
crimes<-crimes[c(5,7,6,4,1,2,8,9,3)]
crimes$beat<-as.numeric(crimes$beat)
crimes$crimedescr<-as.numeric(crimes$crimedescr)

TrainData <- crimes[,1:4]

TrainClasses <- crimes[,9]
TrainClasses<-as.factor(TrainClasses)


control<-trainControl(method="repeatedcv",number=10,repeats=3)
model<-train(as.data.frame(TrainData),TrainClasses,method = "lvq",preProcess = "scale",trControl =control)
importance<-varImp(model,scale=FALSE)
print(importance)
plot(importance)


**End of code**

![alt tag](/pic/importance_of_data.jpg)

The photo shows the relevance of each coloumn to the class attribute, which is the district number. 
We chose the column beat, grid, crimedescr, ucr_ncic_code. The other attribute in the table were not taken becouse they were too specific for each record. 
We can see that beat and grid are the most relevant for the district number. It makes sense beacause they describe the area of the districts. 


**Conclusions:**

1. Looking for a more up-to-date dataset that contains recent crimes, which can be used for comparison between years.
2. Check for other causes for crimes except economical conditions in the population.
3. Advice and warning the police about areas with crimes that occur more often
