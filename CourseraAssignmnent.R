#Loading required packages
required <- c("dplyr","tidyr","readr","stringr")
sapply(required,require,character.only=T)

#reading files required for cleaning
test_X <- read_delim('./data/UCI HAR Dataset/test/X_test.txt',delim = ' ',col_names = FALSE,
                     col_types = cols(.default = col_number()))
train_X <- read_delim('./data/UCI HAR Dataset/train/X_train.txt',delim = ' ',col_names = FALSE,
                      col_types = cols(.default = col_number()))
test_Y <- read_lines('./data/UCI HAR Dataset/test/y_test.txt')
train_Y <- read_lines('./data/UCI HAR Dataset/train/y_train.txt')
label <- read_lines('./data/UCI HAR Dataset/activity_labels.txt') %>% str_sub(start = 3)
colNames <- read_lines('./data/UCI HAR Dataset/features.txt') %>% str_extract(pattern = '\\s(.*)') %>% str_trim(side = 'left')

# row binding test and training datasets 
X <- bind_rows(test_X,train_X)
Y <- c(test_Y,train_Y)

#creating factors of activities and appropriately labeling them
Y <-factor(Y,levels =1:6,labels = label)

#column binding features and activity into a single dataset
SingleDataSet <- bind_cols(X,Labels = Y)

#setting the names of variables
names(SingleDataSet) <- c(colNames,'Activity')

#Selecting only those features with mean and standard deviation and then summarizing them
TidyData <- SingleDataSet %>% select(contains(c('mean()','std()')),Activity)%>% 
            group_by(Activity) %>% summarize(across(1:66,mean))
