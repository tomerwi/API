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

**Code**

barplot(table(filings$Driver$nationality), col="wheat", main = "Number of drivers in each country")

**End of code**




![alt tag](/pics/number_of_driver_per_counrty.jpeg)

The photo shows the distribution of driver across countries. 
---Hirtut here---

**Code**

barplot(table(filings$Constructor$name), col="red", main = "Number of cars in the races")

**End code**


![alt tag](/pics/carInRaces.JPG)

This plot shows the cars type distribution across all races. As we can see, Mercedes (German), Ferrari (Italia) and Williams(UK) cars are most used in the races. The reason is that cars made in those countires often tend to be reliable, with high engine perfromance, which are great for car races. 

**Code**

high<-c('1','2','3','4','5')

mediun<-c('6','7','8','9','10','11','12','13','14','15')

low<-c('16','17','18','19','20')


for(i in 1:604)

{

  if(filings$position[i] %in% high)
  
  {
  
    
    filings$position[i]="high"
    
  }
  
  else if(filings$position[i] %in% mediun)
  
  {
  
    
    filings$position[i]="medium"
    
  }
  
  else
  
  {
  
    filings$position[i]="low"
    
  }
  
}



**End of code**

In the code above, we coverted the nominal values of the position to dicrete values (High, Low, Medium). 
High - positions between 1 to 5.
Medium - positions between 6 to 15.
Low - positions between 16 to 20.

We needed to perfom this operation for further analysis of the data. 


**Code**

library("mlbench")
library("caret")


set.seed(604)

number <- filings$number
points <- filings$points
Driver_nationality <- filings$Driver$nationality
Constructor_name <- filings$Constructor$name
position <- filings$position
filings <- data.frame(number,points,Driver_nationality,Constructor_name,position)


filings$position<-as.factor(filings$position)

filings$number<-as.numeric(filings$number)
filings$points<-as.numeric(filings$points)
filings$Driver_nationality<-as.numeric(filings$Driver_nationality)
filings$Constructor_name<-as.numeric(filings$Constructor_name)


TrainData <- filings[,1:4]

TrainClasses <- filings[,5]
TrainClasses<-as.factor(TrainClasses)


control<-trainControl(method="repeatedcv",number=10,repeats=3)
library("e1071")
model<-train(as.data.frame(TrainData),TrainClasses,method = "lvq",preProcess = "scale",trControl =control)
library("pROC")
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
