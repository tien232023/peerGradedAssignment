# The file provides some general explainations of how the run_analysis.R works.
# The details of how each code block works are also covered in the comments of run_analysis.R..

# Summary:
Run the entire code line by line. Some errors were deliberately made in order to demonstrate my exploring process.
For Task1: view the "original_data" object
For Task2,3 and 4: view the "original_data_onlyMeanStd" object
For Task5: view the "final_desired_data" object

# The package needed: dplyr

# Task 1: Merge the training and the test sets to create one data set.
We assembled the training dataset into the object "traindata" and the testing dataset into "testdata" using cbind().
The layout of the both datasets were alike: first column (subject), second column (activity), the rest (features)
Before merging these two dataframes, I checked the duplicity of the variable names and fixed it.
Finally, merge two dataframes with "by" argument set as the entire variable names and "all" argument set as TRUE.
In the script, I deliberately demonstrated an error there with explainations and the way to get away with it.

# Task 2: Extract only the measurements on the mean and standard deviation for each measurement. 
I used grep() and regular expression("mean|std|subject|activity") to extract variables with these patterns.

# Task 3: Use descriptive activity names to name the activities in the data set
I solved the task by converting the activity variable to a factor with labels provided by "activity_labels.txt".

# Task 4: Appropriately label the data set with descriptive variable names.
This task was actually done in the task 1.

# Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
First, I created a factor that would be used as grouping information by interaction() on "subject" and "activity".
Then I split the dataset using this grouping factor, fed the results into sapply(), with an anonymous function containing colMeans() for computing the average of each variables.
Then I did some transformations: list-->dataframe and the transposed one.
Finally, attach the "subject" and "activity" variable to make it complete.
