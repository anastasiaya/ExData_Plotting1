## check working directory
## plot4.R - 4 plots together

dataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datasetFile <- "household_power_consumption.txt"
zipFile <- "./data/epc.zip" #within the working directory
plotFile <- 'plot4.png' #change here if needed

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

#keep original Date column, but create a duplicate to be able to keep only the relevant data
data$Date2 <- as.Date(data$Date,format="%d/%m/%Y") #read date column in the specified format
## only using data from the dates 2007-02-01 and 2007-02-02
date1<-as.Date("01/02/2007",format="%d/%m/%Y")
date2<-as.Date("02/02/2007",format="%d/%m/%Y")
## create the subset of data we're interested in (keep only if dates fulfil the criteria above)
data<-subset(data, Date2 == date1 | Date2 == date2)

# Combine date/time column to the frame and add it as a separate column
data <- data.frame(datetime = strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S"), data)

png(filename=plotFile, width=480, height=480)

par(mfrow=c(2,2)) #specify that we want 4 graphs: 2 columns, 2 rows. Start to draw in rows.

# Upper left plot
plot(data$datetime, data$Global_active_power, main='', xlab='', ylab='Global Active Power', type='l')

# Upper right plot
plot(data$datetime, data$Voltage, main='', xlab='datetime', ylab='Voltage', type='l')

# Lower left plot
plot(data$datetime, data$Sub_metering_1, main='', xlab='', ylab='Energy sub metering', type='l',col='black')
lines(data$datetime, data$Sub_metering_2,  col='red')
lines(data$datetime, data$Sub_metering_3, col='blue')
legend('topright', c('Sub_metering_1','Sub_metering_2','Sub_metering_3'), col=c('black','red','blue'),lty=1,bty='n')

# Lower right plot
plot(data$datetime, data$Global_reactive_power, main='', xlab='datetime', ylab='Global_reactive_power', type='l')

dev.off()