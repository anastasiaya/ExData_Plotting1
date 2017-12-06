## check working directory
## plot1.R - Frequency / Global Active Power (kilowatts)

dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datasetFile <- "household_power_consumption.txt"
zipFile <- "./data/epc.zip"
plotName <- 'plot1.png'

# A directory to put the data in.
if(!file.exists('data')) {
        dir.create('data')
}

# Ensure we have the dataset file.
if(!file.exists(zipFile)) {
        download.file(dataUrl, destfile = zipFile, method = 'curl')
        epc_date <- date();
}
unzip(zipFile, datasetFile) #unzip file and save it

library(data.table)

## read in the household power consumption data into a data table
data<-fread("household_power_consumption.txt",sep=";",na.strings=c("?"))
data$Date <- as.Date(data$Date,format="%d/%m/%Y") #read date column in the specified format

## only using data from the dates 2007-02-01 and 2007-02-02
Date1<-as.Date("01/02/2007",format="%d/%m/%Y")
Date2<-as.Date("02/02/2007",format="%d/%m/%Y")

## create the subset of data we're interested in (keep only if dates fulfil the criteria above)
data<-subset(data, Date == Date1 | Date == Date2)

## save the plot in the specified format
png(filename= plotName, width=480, height=480)
hist(as.numeric(data$Global_active_power), main="Global Active Power", xlab="Global Active Power (kilowatts)",col="red") #<- as.numeric is needed??
hist(data$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)",col="red") #<- without as.numeric

dev.off() #end the connection to the device
