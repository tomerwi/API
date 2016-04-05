
res <- fromJSON('http://ergast.com/api/f1/2004/1/results.json')
drivers <- res$MRData$RaceTable$Races$Results[[1]]

high<-c('1','2','3','4','5')
mediun<-c('6','7','8','9','10','11','12','13','14','15')
low<-c('16','17','18','19','20')

for(i in 1:20)
{
  if(drivers$position[i] %in% high)
  {
    
    drivers$position[i]="high"
  }
  else if(drivers$position[i] %in% mediun)
  {
    
    drivers$position[i]="medium"
  }
  else
  {
    drivers$position[i]="low"
  }
}


