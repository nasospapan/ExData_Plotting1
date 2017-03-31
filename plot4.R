## Coursera Exploratory Data Analysis - Project 1 : Plot 4
######################################################################
##############           CODE FOR READING DATA          ##############
######################################################################

## initialize the libraries
library(downloader)
library(data.table)
library(dplyr)

# define the url
urll <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# establish a destination file
destination <- "./power_consumption.zip"

# download file to the specified destination, with mode = BINARY
download.file(url = urll, destfile = destination, mode = "wb")

# keep a record of the date the file was downloaded
dateDownloaded <- date()

# unzip compressed file into the current directory
unzip("power_consumption.zip", exdir = getwd())

# create a character variable with the name of the file
myfile <- "household_power_consumption.txt"

# create a character vector with the names of the variables from our dataset
var_names <- scan(myfile, what = "character", sep = ";", nlines = 1,
                  quiet = TRUE)

# read the dataset beginning from the first entry of Feb 1st 2007 and ending 
# on the last entry of Feb 2nd 2007
# using as variable names the vector we stored above
power_data <- fread(myfile, skip = "1/2/2007", nrows = 2880, sep = ";",
                    header = FALSE, stringsAsFactors = FALSE, na.strings = "?",
                    col.names = var_names)

# create a new dataset where Date and Time are combined in one variable dateTime
# and converted to POSIXct
my_data <- power_data[,3:9]
dateTime <- strptime(paste(power_data$Date, power_data$Time),
                     format = "%d/%m/%Y %H:%M:%S")
my_data <- mutate(my_data, dateTime = as.POSIXct(dateTime))

###########################################################################
######                  CODE FOR PLOT4              #######################
###########################################################################


# Open device to save into a PNG file 480x480
png(filename = "plot4.png", width = 480, height = 480)

# set margins
par(mfrow = c(2,2) ,mar = c(4,4,1.5,1))

# create plot1 top left
with(my_data, plot(dateTime, Global_active_power, type = "l",
                   ylab = "Global Active Power", xlab = ""))

# create plot 2 top right
with(my_data, plot(dateTime, Voltage, type = "l", xlab = "datetime"))

# create plot3 bottom left
with(my_data, plot(dateTime, Sub_metering_1, type = "n",
                   ylab = "Energy sub metering", xlab = ""))
points(my_data$dateTime, my_data$Sub_metering_1, type = "l")
points(my_data$dateTime, my_data$Sub_metering_2, type = "l", col = "red")
points(my_data$dateTime, my_data$Sub_metering_3, type = "l", col = "blue")
legend("topright", bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1, col = c("black", "red", "blue"))

# create plot 4 bottom right
with(my_data, plot(dateTime, Global_reactive_power, type = "l",
                   xlab = "datetime"))

# close device
dev.off()