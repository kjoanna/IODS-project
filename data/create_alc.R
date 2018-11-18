# Chapter 3
# Kaisla Komulainen
# 11/17/2018
 
setwd ("/Users/kjkomula/Documents/GitHub/IODS-project/data/")

math <- read.table("/Users/kjkomula/Documents/GitHub/IODS-project/data/student-mat.csv", sep=";", header=TRUE)
por <- read.table("/Users/kjkomula/Documents/GitHub/IODS-project/data/student-por.csv", sep=";", header=TRUE)

str(math)
dim(math)
str(por)
dim(por)

library(dplyr)
library(tidyr)
library(ggplot2)
library(psych)

# join the two datasets by common columns
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))
head(math_por)

#exclude duplicated columns
colnames(math_por)
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  if(is.numeric(first_column)) {
  alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}


# define a new logical column 'high_use'
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

dim(alc)

setwd ("/Users/kjkomula/Documents/GitHub/IODS-project/")

write.table(alc, file = "alc", sep = "\t")


