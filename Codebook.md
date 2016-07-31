# Goal
This document describes the code inside of run_analysis.R

## Background of data
There were 30 subjects that were involved in this experiment.   Each subject performed 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) and different measurements were taken.

Each row in the test and the training data are associated with one subject and a single activity.  One of the goals of this script was to combine the test and training data and associate it with a subject and activity. 


## Functions
### get_source_data
Creates a custom folder in current file path and downloads the data needed to run the code.
### get_activity_name
Custom function to map activity id to activity description


## Variables
 - **data.measurement_labels** - All the features that were measured.
 - **data.activity_labels** - Activity mapping. It maps an id to the description.
 - **data.train.x** - Training data set that contains the measured features.
 - **data.train.y** - Activities that corresponds with each row in data.train.x
 - **data.train.subject** - Subjects that corresponds with each row in data.train.x
 - **data.train** - Combined training data with measurements, activity and subject.
 - **data.test.x** - Test data set that contains the measured features.
 - **data.test.y** - Activities that corresponds with each row in data.test.x
 - **data.test.subject** - Subjects that corresponds with each row in data.test.x
 - **data.test** - Combined test data with measurements, activity and subject.
 - **data.combined** - Combined training and test data with measurements, activity and subject.
 - **data.mean_and_std** - Combined training and test data with measurements, activity and subject narrowed down to only measurements with means and standard deviation
 - **mean_grouped_by_subject_and_activity** - Averages grouped by subject and activity


## Result
A file called tidy.txt will be produced at the end of this script which calculates the average of each variable for each activity and each subject.

