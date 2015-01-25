## 1

# Read and Merge the data sets together
trainX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")


testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
X <- rbind(trainX, testX)

# create 'y' data set
Y <- rbind(trainY, testY)

# create 'subject' data set
Subject <- rbind(trainSubject, testSubject)


## 2
# Read features and make the feature names better suited for R with some substitutions
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

# Include only columns with mean() or std() in their names
onlyMeanStdFeatures <- grep("-(mean|std)\\(\\)", features[,2])

X <- X[, onlyMeanStdFeatures]
# correct the column names
names(X) <- features[onlyMeanStdFeatures, 2]


## 3
activity = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
# Descriptive activity names to name the activities
Y[, 1] <- activity[Y[, 1], 2]


## 4
# Descriptive variable names
# Rename column name in Y
names(Y) <- "activity"

# correct column name in subject data set
names(Subject) <- "subject"

# Merge all the data
allData <- cbind(X, Y, Subject)


## 5

library(plyr)
# Dont include last two columns as they are subject and activity columns as the mean of those
# does not make sense
## ddply - split data frame, apply function and return result in a data frame.
averageData <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averageData, "tidy.txt", row.name=FALSE)

