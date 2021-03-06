library(data.table)
library(lattice)

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

png("figure/plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))

with(working_set, plot(f_datetime, Global_active_power, type = "l", xlab = ""))

with(working_set, plot(f_datetime, Voltage, type = "l", xlab = "datetime"))

with(working_set, plot(f_datetime, Sub_metering_1, type = "l", 
                       xlab = "", ylab = "Energy sub metering"))
with(working_set, lines(f_datetime, Sub_metering_2, type = "l", col = "red"))
with(working_set, lines(f_datetime, Sub_metering_3, type = "l", col = "blue"))
legend("topright", 
       box.lty = 0, 
       lty = 1, 
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(working_set, plot(f_datetime, Global_reactive_power, type = "l", xlab = "datetime"))


dev.off()

