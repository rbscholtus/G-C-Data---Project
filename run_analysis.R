# run_analysis.R
# Written by Barend Scholtus
# 27/07/2014

# the number of rows to read in each data file (negative value means all)
read.rows = -1

#
# PART 1: Merges the training and the test sets to create one data set.
#

# read feature labels
features.table <- read.table("./UCI HAR Dataset/features.txt")
features <- gsub("[.]+", "", make.names(features.table$V2))

# read all training data
subjects <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                       col.names=c("Subject"), nrows=read.rows)
activities <- read.table("./UCI HAR Dataset/train/y_train.txt",
                    col.names=c("Activity"), nrows=read.rows)
measurements <- read.table("./UCI HAR Dataset/train/X_train.txt",
                           col.names=features, nrows=read.rows)

# merge training data into one set
data <- cbind(subjects, activities, measurements)

# read all test data
subjects <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                       col.names=c("Subject"), nrows=read.rows)
activities <- read.table("./UCI HAR Dataset/test/y_test.txt",
                    col.names=c("Activity"), nrows=read.rows)
measurements <- read.table("./UCI HAR Dataset/test/X_test.txt",
                           col.names=features, nrows=read.rows)

# merge training and test data into one set
data <- rbind(data, cbind(subjects, activities, measurements))

# clean up to save memory
rm(subjects, activities, measurements)

#
# PART 2: Extracts only the measurements on the mean and standard deviation for
# each measurement.
#

# determine all feature labels with mean and std in their names (but not the angles)
features2 <- c("Subject", "Activity", features[grep("mean|std", features)])  

# keep only required columns
data <- data[,features2]

#
# PART 3: Uses descriptive activity names to name the activities in the data set
#

# load the activity labels
activity.labels <- read.table("./UCI HAR Dataset/activity_labels.txt") 

# apply the labels to Activity column as factors
data$Activity <- factor(data$Activity, labels=activity.labels$V2)

#
# PART 4: Appropriately labels the data set with descriptive variable names. 
#

# This has already been done by loading the data using:
#     col.names=features
# where features is a vector with all feature labels

#
# PART 5: Creates a second, independent tidy data set with the average of each
# variable for each activity and each subject.
#

# calculate averages for each Subject and Activity
averages <- aggregate(data, list(data$Subject, data$Activity), mean)

# tidy up column names
averages$Subject = averages$Group.1
averages$Activity = averages$Group.2
averages$Group.1 = NULL
averages$Group.2 = NULL

#
# LAST PART: Saves the averages to a file 
#

write.csv(averages, file="averages.csv", row.names=FALSE)
