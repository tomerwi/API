


library("jsonlite", lib.loc="~/R/win-library/3.2")
#store all pages in a list first
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

#combine all into one
filings <- rbind.pages(pages)

#check output
barplot(table(filings$Driver$nationality), col="wheat", main = "Number of drivers in each country")
barplot(table(filings$Constructor$name), col="red", main = "Number of cars in the races")

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



set.seed(604)





