library(dplyr)
library(reshape)
rm(list=ls())

##read data
activity_labels<-read.table("activity_labels.txt")
features<-read.table("features.txt")

test.subj<-read.table("./test/subject_test.txt")
test.label<-read.table("./test/Y_test.txt")
test.set<-read.table("./test/X_test.txt")

train.set<-read.table("./train/X_train.txt")
train.label<-read.table("./train/Y_train.txt")
train.subj<-read.table("./train/subject_train.txt")


##combine with activity label and subject
train<-data.frame(train.set,train.subj,train.label)
test<-data.frame(test.set,test.subj,test.label)

##merge train data set and test data set.
df<-rbind(train,test)

##change name of Activity col
names(df)[562:563]<-c("Subject","Activity")   ##Activity label


##change Activity to descriptive name by merging the activity_label dataframe
df<-merge(df,activity_labels,by.x="Activity",by.y="V1")

##remove Activity label data
df<-df[,-1]

##rename all measures name as desriptive by checking from features table.
names(df)<-c(as.character(features[,2]),"Subject","Activity")


## get all col names of df
fname<-names(df)

##get the column number for "mean()" and "std()".
meanCol<-grep("mean()",fname,fixed=TRUE)
stdCol<-grep("std()",fname,fixed=TRUE)
df2<-data.frame(df[meanCol],df[stdCol],df$Subject,df$Activity)
names(df2)[(ncol(df2)-1):ncol(df2)]<-c("Subject","Activity")
    
df2$Subject<-as.factor(df2$Subject)  
##Step 4 Completed.

##Step 5 , using Reshape Package melt/cast combination to aggregate the data

df2.melt<-melt(df2)
df2.cast<-cast(df2.melt,variable~Subject+Activity,mean)
df2.cast<-data.frame(df2.cast)
##some dataframe adjustment to meet final result


##transpose matrix to put variables as col.
df_avg<-t(df2.cast[,-1])
df_avg<-data.frame(df_avg)
##give descriptive names as variable name
colName<-df2.cast[,1]
names(df_avg)<-colName

write.table(df_avg,"df_avg.txt",row.name=FALSE)
