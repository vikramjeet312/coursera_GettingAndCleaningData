library(plyr)

#reading features.txt for the required column names
features<-read.table(file = "./UCI HAR Dataset//features.txt")

#reading all the required "train" data files
x_train<- read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train<-read.table("./UCI HAR Dataset//train//subject_train.txt")
y_train<-read.table("./UCI HAR Dataset//train//y_train.txt")

#setting appropriate column names for the "train" data sets
colnames(x_train)<-features[,2]
colnames(subject_train)<-"Subject"
colnames(y_train)<-"Activity"

#setting the y_train variable as a factor with levels (Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying)
y_train$Activity<- factor(y_train$Activity)
levels(y_train$Activity)<-c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing","Laying")

#creating "train" dataset with 563 variables
train<- cbind(x_train, subject_train, y_train)

#reading all the required "test" data files
x_test<- read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")

#setting appropriate column names for the "test" data sets
colnames(x_test)<- features[,2]
colnames(subject_test)<-"Subject"
colnames(y_test)<- "Activity"

#setting the y_test variable as a factor with levels (Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying)
y_test$Activity<- factor(y_test$Activity)
levels(y_test$Activity)<-c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing","Laying")

#creating "test" dataset with 563 variables
test<- cbind(x_test, subject_test, y_test)

#STEP 1: creating the merged data set
data<- rbind(train,test)

#STEP 2: extract only the mean and standard deviation measurements
data2<- data[,which(grepl("mean|std|Subject|Activity", names(data)))]

#STEP 3: Descriptive activity names already added with the factor and levels commands previously on y_train$Activity and y_test$Activity

#STEP 4: Adding appropriate variable names
names(data2)<-gsub('\\(|\\)', "", names(data2), perl=TRUE)
names(data2)<-gsub('Acc', "Acceleration", names(data2), perl=TRUE)
names(data2)<-gsub('Mag', "Magnitude", names(data2), perl=TRUE)
names(data2)<-gsub('mean', "Mean", names(data2), perl=TRUE)
names(data2)<-gsub('std', "StandardDeviation", names(data2), perl=TRUE)
names(data2)<-gsub('Freq', "Frequency", names(data2), perl=TRUE)
names(data2)<-gsub('^f', "Frequency", names(data2), perl=TRUE)
names(data2)<-gsub('^t', "Time", names(data2), perl=TRUE)

#STEP 5: creating tidy dataset with average of each variable for each activity and each subject
tidyData<- ddply(data2, c("Subject","Activity"), numcolwise(mean))
