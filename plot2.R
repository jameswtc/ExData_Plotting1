library(data.table)

data <- fread("household_power_consumption.txt", 
              na.strings = c("?"), 
              colClasses = "character",
              stringsAsFactors = FALSE)

data[, f_date := as.Date(Date, "%d/%m/%Y")]
working_set <- data[data[, f_date %between% c("2007-02-01", "2007-02-02")], ]

rm(data); gc()

working_set[, datetime := paste(Date, Time, sep = " ")]
working_set[, f_datetime := as.POSIXct(strptime(datetime, "%d/%m/%Y %H:%M:%S"))]

working_set[, Global_active_power := as.numeric(Global_active_power)]
working_set[, Global_reactive_power := as.numeric(Global_reactive_power)]
working_set[, Voltage := as.numeric(Voltage)]
working_set[, Global_intensity := as.numeric(Global_intensity)]
working_set[, Sub_metering_1 := as.numeric(Sub_metering_1)]
working_set[, Sub_metering_2 := as.numeric(Sub_metering_2)]
working_set[, Sub_metering_3 := as.numeric(Sub_metering_3)]

png("figure/plot2.png", width = 480, height = 480)

plot(working_set$f_datetime, 
     working_set$Global_active_power,  
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")

dev.off()

