# Getting and Cleaning Data -- Project Solution

## Introduction

This is the description of the Barend Scholtus' solution to the programming project
for the Getting and Cleaning Data course on Coursera.

The project is divided into five tasks. The solution comprises just one file because
each task is small.

## The tasks

### Merge the training and test sets

First, the script loads the **features.txt** file with the feature (variable) labels. These
are used to create user-friendly (tidy) column names.

Next, the scripts loads **train/subject_train.txt**, **train/y_train.txt**, and
**train/X_train.txt**. The first file has one column only, and each row represents the
subject for that measurement. The second file also has only one column, and each
row represents the type of actvity that was performed by the 
subject. The last file has a set of 561 columns with features, and each row
represents one measurement for that subject doing that activity. The three data
sets have the same number of rows (of course.)

The three dataframes are combined with `cbind()`.

Next, the script loads **test/subject_train.txt**, **test/y_train.txt**, and
**test/X_train.txt**. These files have the same structure as the previous three, and
contain additional data. Again, the three data frames are combined with `cbind()`.

Finally, the two combined datasets are combined using `rbind()`. Temporary
datasets are removed from memory. The resulting dataset has the following
columns:

 * Subject
 * Activity
 * 561 features

### Extracts only the means and stdevs

The desired features are listed by taking all features in **features.txt** with
the word "mean" or "std" in the name. These are all the features that represent
a mean or standard deviation. The last few features use means but are angles,
so they are excluded.

After the list of features is prepared, the merged dataset is filtered based on
this list. The result is a dataset with fewer columns:

 * Subject
 * Activity
 * 79 features

### Uses descriptive activity names

The second column contains numeric values representing an activity that subjects
perform during measurements. There are six activities such as WALKING, SITTING,
etc.

To make the Activity type easier to read, the numeric variable was converted to
a factor variable with English labels. Converting to a factor also saves memory,
especially if the variable contains strings.

I decided against using `merge()` because this is a SQL-like operation while the
desired operation really is just a conversion to a different internal
representation (from numeric to factor.)

The activity labels are read from the **activity_labels.txt** file, and then
applied to the merged dataset.

### Appropriately labels the data set with descriptive variable names

This is already done when the data is loaded. The variable names are extracted
from the **features.txt** file, and a simple `gsub()` substitution is used to
make the names look friendlier to the user.

The names clearly show, in abbreviated format, what each column represents. The
Codebook provides detailed descriptions of what they mean.

### Determine the average of each variable for each activity and each subject

The last operation creates a new data set that comprises the average of each of
the 79 features, grouped by Subject and Activity. This is similar to using an
SQL query with GROUP BY Subject and Activity and an aggregate function.

In R, this is done using `aggregate()`. All you need to do is specify the
dataset, a list of columns to group by, and the aggregate function (which is
`mean`).

The function created two new columns, each for one of the columns that
I grouped by. I tidied up column headers.

### Final step

The final step was to write the tidied dataset with averages to disk. I decided
to write it to CSV format because this is easily portable. I included column
names, but omitted row names.
