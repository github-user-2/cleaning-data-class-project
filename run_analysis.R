################################################################################
# run_analysis.R
#
# This script analyzes the "Human Activity Recognition Using Smartphones Data
# Set". A description of the data set along with the data is available at:
#
#   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# This script will combine all the mean and standard deviation data (all columns
# containing the string "mean()" or "std()" in their name) from the training and
# test data in the original data set into the means_and_stds variable.
# The mean of each column grouped by activity and subject is then computed
# and stored in the averages_by_activity_and_subject variable.  This table is
# also written out to the "averages_by_activity_and_subject.txt" file in the
# working directory.
#
# A fuller description of transformations and output can be found in the
# CodeBook.md file.
#

#
# Install dplyr if it isn't already on the machine
#
if (!require("dplyr")) {
  print("Installing dplyr package")
  install.packages("dplyr")
  library(dplyr)
}

#
# These are the names of the files that will be used to read and save data
#
# URL of the zipped source data
zipped_data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Name of source data file to save locally
zipped_data_filename <- "getdata-projectfiles-UCI HAR Dataset.zip"
# Top level path (relative to the working directory) where the source data
# will be unzipped
unzipped_data_path <- "UCI HAR Dataset"
# Path to the activities label file, which contains the code and label for each
# activity
activity_labels_path <- file.path(unzipped_data_path, "activity_labels.txt")
# Path to the features file, which contains the column index and label for each
# feature
features_path <- file.path(unzipped_data_path, "features.txt")
# Path to the training data directory
training_data_dir <- file.path(unzipped_data_path, "train")
# Training data files to read
train_subjects_path <- file.path(training_data_dir, "subject_train.txt")
train_x_path <- file.path(training_data_dir, "X_train.txt")
train_y_path <- file.path(training_data_dir, "y_train.txt")
# Path to the test data directory
test_data_dir <- file.path(unzipped_data_path, "test")
# Test data files to read
test_subjects_path <- file.path(test_data_dir, "subject_test.txt")
test_x_path <- file.path(test_data_dir, "X_test.txt")
test_y_path <- file.path(test_data_dir, "y_test.txt")
# Name of the file to save the averages by activity and subject
averages_by_activity_and_subject_path <- "averages_by_activity_and_subject.txt"

#
# Retrieve and unzip the source data file if needed
#
if (!file.exists(unzipped_data_path)) {
  # The source data directory doesn't exist, so see if the zipped source
  # data file is present
  if (!file.exists(zipped_data_filename)) {
    print("Downloading source zipped data file")
    download.file(zipped_data_url, zipped_data_filename, method = "curl")
  }

  # We should have the zipped source data file at this point, so now unzip it
  print("Unzipping source data file")
  unzip(zipped_data_filename)
}

#
# Read in the activity labels file and name its columns in preparation for
# merging
#
activity_labels <- read.table(activity_labels_path)
colnames(activity_labels) <- c("ActivityCode", "ActivityLabel")

#
# Read in the features table and filter for features that end in "mean()" or
# "std()" in order to later extract only the mean and standard deviation fields
#
features <- read.table(features_path)
colnames(features) <- c("FeatureColumn", "FeatureName")
filtered_features <- features[sort(c(grep("mean()", features$FeatureName, fixed = TRUE), grep("std()", features$FeatureName, fixed = TRUE))),]

#
# Read in training and test data: the subjects, x, and y tables
#
train_subjects <- read.table(train_subjects_path)
train_x <- read.table(train_x_path)
train_y <- read.table(train_y_path)
test_subjects <- read.table(test_subjects_path)
test_x <- read.table(test_x_path)
test_y <- read.table(test_y_path)

#
# Combine the training and test data sets for subjects
#
all_subjects = rbind(train_subjects, test_subjects)
# Name the only column in the data set SubjectID for later merging
colnames(all_subjects) <- c("SubjectID")

#
# Combine the training and test data sets for x (the sensor data)
#
all_x = rbind(train_x, test_x)

#
# Combine the training and test data sets for y (the activity code determined
# from the sensor data)
#
all_y = rbind(train_y, test_y)
# Name the only column in the data set ActivityCode for later merging
colnames(all_y) <- c("ActivityCode")
#all_y <- merge(all_y, activity_labels)

#
# Use the filtered_features table to filter the data in the x data set to
# include just the mean and standard deviation fields
#
# The first column of filtered_features contains the column index, so use that
# to filter which columns are in the filtered data set
filtered_x <- all_x[, filtered_features[,1]]
# The second column of filtered_features contains the column names, so use that
# to label the columns in the filtered data set
colnames(filtered_x) <- filtered_features[,2]

#
# Combine the subjects, filtered x, and y data sets
#
means_and_stds <- cbind(all_subjects, filtered_x, all_y)
# Merge in the activity labels so the activities will have a descriptive name
means_and_stds <- merge(means_and_stds, activity_labels)
# Drop the ActivityCode column since the merge brought in the ActivityLabel
means_and_stds <- subset(means_and_stds, select = -ActivityCode)

#
# Compute a data set that contains the averages of each column grouped by
# activity and subject
#
averages_by_activity_and_subject <-
  group_by(means_and_stds, ActivityLabel, SubjectID) %>%
  summarize_each(funs(mean))
# Save the table to file
write.table(averages_by_activity_and_subject,
            file = averages_by_activity_and_subject_path,
            row.names = FALSE)
