#load the library
library(dplyr)

#Set working directory
setwd("C:/Users/anton/Desktop")

filename <- "AssignmentCoursera.zip"

# Checks if file is already present in the directory
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checks if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#Assigns dataframes

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("n", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "n")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "n")

xmerged <- rbind(x_train, x_test)
ymerged <- rbind(y_train, y_test)
subjectmerged <- rbind(subject_train, subject_test)
Merged_Data <- cbind(subjectmerged, ymerged, xmerged)


Data <- Merged_Data %>% select(subject, n, contains("mean"), contains("std"))


Data$n <- activities[Data$n, 2]

#Appropriately labels the data set with descriptive variable names.

names(Data)[2] = "activity"
names(Data)<-gsub("Acc", "Acceler", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("tBody", "Time_Body", names(Data))
names(Data)<-gsub("-mean()", "Average", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-std()", "Standard_Deviation", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data)<-gsub("angle", "Angle", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))


Result <- Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Result, "Results.txt", row.name=FALSE)

#check in console
#str(Result)
