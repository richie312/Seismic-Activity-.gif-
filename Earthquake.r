## Read the datatset and load the necessary packages
library(dplyr)
library(ggmap)
library(ggplot2)
library(gganimate)
EQ=read.csv("eq.csv",stringsAsFactors = FALSE)
names(EQ)
EQ<-EQ%>%filter(Magnitude>=6)

## Convert the dates into character in order to split the coloumn into dd mm yy columns
EQ$Date<-as.character(EQ$Date)
list<-strsplit(EQ$Date,"-")
## Convert the list intok dataframe
library(plyr)
EQ_Date1<-ldply(list)
colnames(EQ_Date1)<-c("Day","Month","Year")

## Column bind with the main dataframe
EQ<-cbind(EQ,EQ_Date1)
names(EQ)
## Change the Date to numeric
EQ$Year=as.numeric(EQ$Year)

## Get the world map for plot and load the necessary package
library(ggmap)
library(ggalt)    # devtools::install_github("hrbrmstr/ggalt")

world<-map_data("world")
world <- world[world$region != "Antarctica",]
map<-ggplot()+geom_map(data=world,map=world,aes(x=long,y=lat,map_id=region),color='#993300',fill='#FFCC66')

## Make the data frame year wise

EQ<-EQ[order(EQ$Year),]
Y1<-seq(from=1965,to=2015, by=5)

## Make a legend column

#Plot points on world Map
p <- map + geom_point(data = EQ, aes(x = Longitude, y = Latitude, 
                                             frame = Year, 
                                        cumulative = TRUE,size=EQ$Magnitude), alpha = 0.3, size = 2.5,color="#990000") + 
  geom_jitter(width = 0.1) + scale_color_manual(values ="#darkgreen") + theme_bw() +
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  labs(title = "Earthquake above 6 point on richter scale")

print(p)

#Make Flood GIF
gganimate(p)
