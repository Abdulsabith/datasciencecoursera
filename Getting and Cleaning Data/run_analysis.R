library(dplyr)
library(tidyr)
testx <- read.table("UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainx <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/Y_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
columnnames <- c("subjectid","activityname",grep("mean|std",features$V2,value = TRUE))
columnindices <- c(1:2,grep("mean|std",features$V2)+2)
test <- cbind(testsubject,testy,testx)
train <- cbind(trainsubject,trainy,trainx)
fulldata <- rbind(test,train)
reqdata <- fulldata[,columnindices]
columnnames <- sub("^f","frequency_",columnnames)
columnnames <- sub("^t","time_",columnnames)
names(reqdata) <- columnnames
reqdata$activityname <- activitylabels$V2[match(reqdata$activityname,activitylabels$V1)]
tidydata <- reqdata %>% 
  gather(measurementname,valueofmeasurement,-(subjectid:activityname)) %>%
  separate(measurementname,c("signaltype","measuredattribute"),extra="merge") %>%
  group_by(subjectid,activityname) %>% 
  mutate(observationnumber= row_number()) %>%
  ungroup() %>%
  select(subjectid,activityname,observationnumber,everything())
tidydata$measuredattribute <- sub("-","_",tidydata$measuredattribute)
tidydata <- tidydata %>%
  separate(measuredattribute,c("measurementname","statistic-axis(if applicable)"),extra = "merge")
tidydatasummary <- tidydata %>%
  select(-observationnumber) %>%
  group_by(subjectid,activityname,signaltype,measurementname,`statistic-axis(if applicable)`) %>%
  summarise_all(mean)
write.table(tidydatasummary,"TidyDataSummary",row.name=FALSE)