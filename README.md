# CSV


 
**This dataset contains information about crimes commited in Sacramento in 2006. This information are available from Sacramento police department. **

crimes<-read.csv("C:/Users/דודו/Downloads/SacramentocrimeJanuary2006.csv")

This command gets the data from the CSV file and puts it in a data frame.

Main Columns in the datatable:
- District - Number of the district where the crime commited
- Beat - Area inside the district
- grid - sub-area in the district
- Crime description - crime type
- Latitude & Longtitude - Location parameters, which is used to show the location of the crime in the map
- ucr_ncic_code - Code which is given by the police to describe the crime severity.

**Code**

library("ggmap")

library("ggplot2")

map <- get_map(location = c(lon = mean(crimes$longitude), lat = mean(crimes$latitude)), zoom = 15,  maptype = "satellite", scale =  2) 

ggmap(map) +  geom_point(data = crimes, aes(x = longitude, y = latitude, colour = ifelse(district>3,F,T), alpha = 0.1), size = 10, shape = 10) +  guides(fill=FALSE, alpha=FALSE, size=FALSE) 

**End of code**


![alt tag](/pic/North_vs_South.jpg)

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
