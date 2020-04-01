Summary
-------

The objective was to create tidy data in a tall format, with maximum
number of variables in different columns, to facilitate easy working
with the data.

Observations
------------

1.  Feature names included multiple points of information which could be
    split into variables across different columns. Eg:
    tBodyGyro-mean()-X has primarily 4 components. 't' refers to the
    type of signal measured, which is either time or frequency.
    'BodyGyro' is the name of a measurement from the Gyroscope. 'mean()'
    indicates the type of statistic measured, while 'X' indicates the
    axis in reference to which a particular measurement was done.
    However, due to certain measurements not having this component as
    factor of variabilty, it was combined with statistic measyured.  
2.  Each combination of subject, activity and measurement name had
    multiple observations. In order to enable unique identification of
    rows, they were given observation numbers in a separate column.

The steps can be largely divided into five phases:
--------------------------------------------------

**1. Reading in data**  
Here the files corresponding to the input data were read in using
read.csv, along with the files containing activity labels and feature
names.  
**2. Combining Data and Subsetting**  
The input data was combined using rbind and cbind, and then subset using
column indices. The column indices were obtained through use of grep
with a pattern matching for 'mean' or 'std' This returned 79 columns.
Combined with subject and activity identification columns, the output of
this phase is saved as 'reqdata'.  
**3. Renaming of Columns to Descriptive Variable names**  
This happened in stages. First stage involved naming all variables by
their feature name. They were selected and stored earlier along with the
indices.  
**4. Tidying of Data**  
This was done using a combination of gather(), separate(), mutate() and
select(), to get the data into the form of a tall tidy table  
**5. Summarising of Data**  
This was done using a combination of group\_by() and summarise\_all()
functions, to generate the tidy data required as output of step 5. of
the project instructions.

Step-wise Explanation:
----------------------

**1. Reading in data from text files into data frames using
read.csv().**  
The activity labels and feature names were read into dataframes with
corresponding names. Data frames for text and train samples were named
in the format <samplegroup><Variable>. Eg: Test file for subject ids is
names 'testsubject'.  
**2. Retrieving indices and names of columns with mean() and std() data
from the datafram containing feature names.**  
The vectors 'columnindices' and 'columnnames' were the output. They also
included the indices and names for subject and activity name columns, to
facilitate subsetting of required columns later.  
**3. Combining Data**  
The data frames corresponding to test and train samples were combined
into a single data frame, first by combining the respective columns for
each sample using cbind() and then rbind() to combine these resultant
data frames, into a data frame called 'fulldata'.  
**4. Subsetting for required data**  
Using columnindices, the required columns were selected and stored in
'reqdata'. The column names retain their original names.  
**5. Modification of Column Names Vector**  
Prior to renaming the columns of 'reqdata', the column names are
modified to replace 't' and 'f' with 'time' and 'frequency'
respectively, to make them more descriptive. This was done using
sub().  
**6. Renaming of Columns of 'Reqdata'**  
The names as per 'columnnames' was assigned to 'Reqdata' using
names().  
**7. Replacing Activity Id numbers with Activity labels.**  
Using match function in combination with subsetting using indices, the
activity id numbers were replaced with activity labels, to make them
more descriptive.  
**8. Gathering Columns**  
Using gather() the columns of variables were stacked on top of each
other, with the variable names in 'measurementname' and the values in
'valueofmeasurement'.  
**9. Separation of 'measurementname' into two variables**  
Using separate(), the column was divided into 'signaltype' (time or
frequency) and 'measuredattribute'.  
**10. Adding 'observationnumber' column**  
To keep track of multiple observations for the same combination of
subject and activity, mutate() was used in combination with group\_by()
to apply the row\_number() function and obtain 'observationnumber'. It
was ungrouped subsequently, to avoid issues.  
**11. Separation of 'measuredattribute' column**  
Using separate(), the column was divided into 'measurementname' and
'statistic-axis(ifapplicable)'. The latter is so named as not all of the
mean or standard deviations include the axis along which it is
measured.  
**12. Generation of Summary data**  
Using group\_by() and summarise\_all(), the mean values of all the
unique combinations of subject, activity and measurement were
calculated, and displayed. Select() was used to remove
'observationnumber' column.
