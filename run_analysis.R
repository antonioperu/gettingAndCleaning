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

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)


TidyData <- Merged_Data %>% select(subject, n, contains("mean"), contains("std"))


TidyData$n <- activities[TidyData$n, 2]

#Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Acceler", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "Time_Body", names(TidyData))
names(TidyData)<-gsub("-mean()", "Average", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "Standard_Deviation", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


Result <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Result, "Results.txt", row.name=FALSE)


str(Result)
