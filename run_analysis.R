library(dplyr)
library(data.table)
# method to get source data
get_source_data <- function(){
  if(!dir.exists("./data_source")){
    dir.create("./data_source")
    file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(file_url, destfile="./data_source/data.zip", method="curl")
    unzip(zipfile="./data_source/data.zip", exdir="./data_source")
  }
}

# method to match up activityId to activity name for a more descriptive data
get_activity_name <- function(id){
  filter(data.activity_labels, Id==id)$Type
}

get_source_data()

# measurements labels
data.measurement_labels <- read.table('./data_source/UCI HAR Dataset/features.txt',
                                      col.names=c("Id", "Type"))
#activity labels
data.activity_labels <- read.table('./data_source/UCI HAR Dataset/activity_labels.txt',
                                   col.names=c("Id", "Type"))

# read training data set
data.train.x <- read.table('./data_source/UCI HAR Dataset/train/X_train.txt',
                           col.names = data.measurement_labels$Type)
# contains activitiesId
data.train.y <- read.table('./data_source/UCI HAR Dataset/train/y_train.txt',
                           col.names=c("Id"))
# contains subjectId
data.train.subject <- read.table('./data_source/UCI HAR Dataset/train/subject_train.txt', 
                                 col.names=c("subjectId"))

# create a mapping between activityId and the descriptive name
data.train.activity = mapply(get_activity_name, data.train.y$Id)
# combine the training data with the activity and the subject Id
data.train <- cbind(data.train.x, data.train.activity, data.train.subject)

# rename the activity column name
data.train <- rename(data.train, activity=data.train.activity)


# read test data set
data.test.x <- read.table('./data_source/UCI HAR Dataset/test/X_test.txt',
                          col.names = data.measurement_labels$Type)
# test activityId
data.test.y <- read.table('./data_source/UCI HAR Dataset/test/y_test.txt',
                          col.names=c('Id'))

# test subjectId
data.test.subject <- read.table('./data_source/UCI HAR Dataset/test/subject_test.txt', 
                                col.names=c("subjectId"))

# create a mapping between activityId and the descriptive name
data.test.activity = mapply(get_activity_name, data.test.y$Id)

# combine the training data with the activity and the subject Id
data.test <- cbind(data.test.x, data.test.activity, data.test.subject)

# rename the activity column name
data.test <- rename(data.test, activity=data.test.activity)

# combine the training and test data set
data.combined <- rbind(data.train, data.test)

# extract only mean and std columns, reorder it
data.mean_and_std <- cbind(
  data.combined$subjectId,
  data.combined$activity,
  data.combined[grep('mean|std', data.measurement_labels$Type)])
setnames(data.mean_and_std, 
         old=c('data.combined$subjectId', 'data.combined$activity'),
         new=c('subjectId', 'activity'))

# rename column names to be more descriptive
names(data.mean_and_std) <- gsub("^t", "time", names(data.mean_and_std))
names(data.mean_and_std) <- gsub("^f", "frequency", names(data.mean_and_std))
names(data.mean_and_std) <- gsub("Acc", "Accelerometer", names(data.mean_and_std))
names(data.mean_and_std) <- gsub("Gyro", "Gyroscope", names(data.mean_and_std))
names(data.mean_and_std) <- gsub("Mag", "Magnitude", names(data.mean_and_std))
names(data.mean_and_std) <- gsub("BodyBody", "Body", names(data.mean_and_std))

# get the average of each variable for each activity and each subject.
mean_grouped_by_subject_and_activity <-  aggregate(. ~subjectId + activity, data.mean_and_std, mean)
write.table(mean_grouped_by_subject_and_activity, file="tidy.txt")
mean_grouped_by_subject_and_activity