library(dplyr) ## loading dplyr package

## set correct path to the folder with datasets
setwd("/Users/asset/Documents/data/R text/Cleaning data/course3project/UCI HAR Dataset")

## read all tables with the assigned column names 

## we have 30 volunteers in total, but they are not all represented in each test/train group
## take each volunteer's number from test group
volunteer_test <- read.table("test/subject_test.txt", col.names = "volunteer")
## take each volunteer's numbers from train group
volunteer_train <- read.table("train/subject_train.txt", col.names = "volunteer")

## we will use this activities codes from each group with codes from activity_label.txt
## take activities codes from test group   
y_test <- read.table("test/y_test.txt", col.names = "code")
## take activities codes from train group
y_train <- read.table("train/y_train.txt", col.names = "code")

## read dataset with measurements of each groups  
x_test <- read.table("test/X_test.txt", col.names = features$functions)
x_train <- read.table("train/X_train.txt", col.names = features$functions)

## take column names from features.txt file
features <- read.table("features.txt", col.names = c("n","functions"))
## data reading end


## merging measurement's datasets from each groups
X <- rbind(x_train, x_test)

## merging activities codes from each groups
Y <- rbind(y_train, y_test)

## create merged volunteers list in one data frame
Volunteer <- rbind(volunteer_train, volunteer_test)
## bind measurements, activities, and volunteers in one data frame 
total_data <- cbind(Volunteer, Y, X)
## TASK 1 COMPLETED!


## extracting only the mean and standard deviation for each measurement
clean_data <- total_data %>% select(volunteer, code, contains("mean"), contains("std"))
## TASK 2 COMPLETED!


## create table with same codes from activity_labels.txt file and changing codes
## to the activities names
activities <- read.table("activity_labels.txt", col.names = c("code", "activity")) 
clean_data$code<-activities[clean_data$code, 2]
names(clean_data)[2] = "activity"
## TASK 3 COMPLETED! 


## make describtive names for variables
names(clean_data)<-gsub("Acc", "Accelerometer", names(clean_data))
names(clean_data)<-gsub("Gyro", "Gyroscope", names(clean_data))
names(clean_data)<-gsub("BodyBody", "Body", names(clean_data))
names(clean_data)<-gsub("Mag", "Magnitude", names(clean_data))
names(clean_data)<-gsub("^t", "Time", names(clean_data))
names(clean_data)<-gsub("^f", "Frequency", names(clean_data))
names(clean_data)<-gsub("tBody", "TimeBody", names(clean_data))
names(clean_data)<-gsub("-mean()", "Mean", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-std()", "STD", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("-freq()", "Frequency", names(clean_data), ignore.case = TRUE)
names(clean_data)<-gsub("angle", "Angle", names(clean_data))
names(clean_data)<-gsub("gravity", "Gravity", names(clean_data))
## TASK 4 COMPLETED!


## create the second data set with the average of each variable for each activity and each volunteer
second_data <- clean_data %>% group_by(volunteer, activity) %>% summarise_all(funs(mean))
## TASK 5 COMPLETED!