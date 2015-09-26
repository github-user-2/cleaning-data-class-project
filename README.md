Analysis of "Human Activity Recognition Using Smartphones Data Set"
===================================================================

Overview
--------
This script analyzes the "Human Activity Recognition Using Smartphones Data
Set". A description of the data set along with the data is available at:

   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This script will combine all the mean and standard deviation data from the training and
test data in the original data set into the `means_and_stds` variable.
The mean of each column grouped by activity and subject is then computed
and stored in the `averages_by_activity_and_subject` variable.  This table is
also written out to the `averages_by_activity_and_subject.txt` file in the
working directory.

A fuller description of transformations and output can be found in the
[CodeBook.md](CodeBook.md) file.

Files
-----
This archive contains the following files:

 * [README.md](README.md) --- This file
 * [CodeBook.md](CodeBook.md) --- A full description of how the data is acquired,
   transformed, and written.
 * [run_analysis.R](run_analysis.R) --- The script that performs the transformation
 * [averages_by_activity_and_subject.txt](averages_by_activity_and_subject.txt) ---
   A tidy data set the contains the averages of all the means and standard
   deviations, grouped by activity label and subject ID.  See the
   [CodeBook.md](CodeBook.md) file for a description of the format.

Usage
-----
To perform the transformation simply run the [run_analysis.R](run_analysis.R)
script.

Dependencies:
-------------
### Data
The script needs the Human Activity Recognition Using
Smartphones Data Set in order to perform the transformation.  If this is not
present in the working directory then the data is downloaded from
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### dplyr
The script uses dplyr to perform the analysis.  If this
package is not present then the script will install it.

