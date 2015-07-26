setwd("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project")

library(reshape2)

if(!file.exists("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/ProjectData.zip")){
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              "C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/ProjectData.zip")
}

if(!file.exists("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset")) {
unzip("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/ProjectData.zip")
}

##read in train data
x_train <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/train/subject_train.txt")

##read in test data
x_test <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/test/subject_test.txt")




##read in features and activity labels
features <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/features.txt")
activity_labels <- read.table("C:/Users/Neil/SkyDrive/DataScience/GettingandCleaningData/Project/UCI HAR Dataset/activity_labels.txt")
features[,2] <- as.character(features[,2])
activity_labels[,2] <- as.character((activity_labels[,2]))

## Extract mean and sd information
mean_std_idx <- grep(".*mean.*|.*std.*", features[,2])
mean_std_names <- features[mean_std_idx,2]
mean_std_names <- gsub('-mean', 'Mean', mean_std_names)
mean_std_names <- gsub('-std', 'Std', mean_std_names)
mean_std_names <- gsub('[-()]', '', mean_std_names)

##subsets train and test data to only include mean and std info
x_train <- x_train[mean_std_idx]
x_test <- x_test[mean_std_idx]


##merges train and test data and adds column labels
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test, x_test)
mergedData <- rbind(train, test)
colnames(mergedData) <- c("subject", "activity", mean_std_names)

##converts merged data to factors
mergedData$activity <- factor(mergedData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
mergedData$subject <- as.factor(mergedData$subject)

melt_mergedData <- melt(mergedData, id = c("subject", "activity"))
mean_mergedData <- dcast(melt_mergedData, subject + activity ~ variable, mean)

##exports tidy dataset to txt file
write.table(mean_mergedData, "tidyData.txt", row.names = FALSE, quote = FALSE )