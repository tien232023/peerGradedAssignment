# Summary:
# Run the entire code line by line. Some errors are deliberately made in order to demonstrate
# my exploring process.
# For Task1: view the "original_data" object
# For Task2,3 and 4: view the "original_data_onlyMeanStd" object
# For Task5: view the "final_desired_data" object

# The package needed
library(dplyr)

# Task 1: Merge the training and the test sets to create one data set.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
feature_names <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
# Assemble train dataset: first column(subject), second column(activity), the rest(feature vector).
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
feature_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
traindata <- cbind(subject_train, activity_train, feature_train)
names(traindata) <- c("subject", "activity", feature_names[,2])
# Assemble test dataset in like manner above.
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
feature_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
testdata <- cbind(subject_test, activity_test, feature_test)
names(testdata) <- c("subject", "activity", feature_names[,2])
# Now we want to merge traindata and testdata.
# We might tend to apply this code, but an error will occur.
merge(traindata, testdata, by=names(testdata), all = TRUE)
# Why an error? --> We then noticed that in traindata/testdata there are some duplicated variable names.
names(testdata)[duplicated(names(testdata))]
# Merge() dose not allow us to pass, or set by default, a character vector to "by" argument with elements 
# that will match the names of datasets more than once.
# For example, in this case, the "fBodyAcc-bandsEnergy()-1,8" element in "by" will match the names of 
# traindata/testdata twice.
# Actually, if debug mode is used, one can see that the merge() stops at the fix.by() defined in merge().
# By doing the following, the duplicated names that come later were spontaneously suffixed with ".1", ".2"...and so on.
# This simple trick (selecting the entire dataframe "again") just solves the problem of duplicated variable names.
traindata <- traindata[1:nrow(traindata), 1:ncol(traindata)]
testdata <- testdata[1:nrow(testdata), 1:ncol(testdata)]
names(testdata)[duplicated(names(testdata))] # no duplicated variable name now
# Then, we can merge traindata and testdata into the original dataset.
original_data <- merge(traindata, testdata, by=names(testdata), all=TRUE)


# Task 2: Extract only the measurements on the mean and standard deviation for each measurement. 
var_mean_std<- grep("mean|std|subject|activity", names(original_data), value = TRUE)
original_data_onlyMeanStd <- original_data[var_mean_std]


# Task 3: Use descriptive activity names to name the activities in the data set
original_data_onlyMeanStd$activity <- factor(original_data_onlyMeanStd$activity, labels = activity_labels[,2])


# Task 4: Appropriately label the data set with descriptive variable names.
# This task is actually done in the task 1.


# Task 5: From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
groupfac <- interaction(original_data_onlyMeanStd$subject,
                        original_data_onlyMeanStd$activity,
                        drop = TRUE)
desired_data <- sapply(split(original_data_onlyMeanStd, groupfac),
                             function(x){colMeans(x[3:ncol(x)])}) %>% t
# desired_data is a matrix
id_df <- strsplit(row.names(desired_data), "[.]") %>% as.data.frame %>% t
final_desired_data <- data.frame(subject=as.numeric(id_df[,1]), activity=id_df[,2], desired_data,
                                 row.names=NULL, check.names=FALSE) 
# We need to use data.frame() instead of cbind(). cbind() will convert all the cells into
# character class because of the presence activity variable.
# R will by default convert "a-b" into something like "a.b", and by setting check.names=FALSE, 
# we cancelled this conversion.


# Finally, output the desired dataset into a txt file in the current working directory.
write.table(final_desired_data, file = "final_desired_data.txt",
            row.name=FALSE,
            col.names = names(final_desired_data))
# Please read back the desired dataframe created in Task 5 using the following code.
final_desired_data_readback <- read.table("final_desired_data.txt", header = TRUE, check.names = FALSE)
all.equal(final_desired_data, final_desired_data_readback)



