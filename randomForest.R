# randomForest.R by Zhuowen Fang
# 2018.03.14

# install.packages("randomForest")
# install.packages("party")
library(randomForest)
library(foreign)
library(party)
library(ggplot2)

math_rf <- read.csv("student-mat.csv", sep = ";") # Get student performance dataset
ptgs_rf <- read.csv("student-por.csv", sep = ";")

# Discretization
math_rf$G3[math_rf$G3<10] <- "F"
math_rf$G3[math_rf$G3>=10&math_rf$G3<=20] <- "P"
ptgs_rf$G3[ptgs_rf$G3<10] <- "F"
ptgs_rf$G3[ptgs_rf$G3>=10&ptgs_rf$G3<=20] <- "P"

# -------------------------math----------------------------
ind <- sample(2,nrow(math_rf),replace = TRUE,prob=c(0.7,0.3))
training_m <- math_rf[ind==1,]
testing_m <- math_rf[ind==2,]

rf_m <- randomForest(as.factor(G3) ~ ., data = training_m, ntree = 500, importance = TRUE, proximity = TRUE)
print(rf_m)
plot(rf_m)
importance(rf_m)
varImpPlot(rf_m)
hist(treesize(rf_m,terminal = TRUE), main = "Tree size", col = "blue", xlab = "size", ylab = "frequency")

p_rf_m <- predict(rf_m, newdata = testing_m)
table(testing_m$G3, p_rf_m)

true_m <- as.numeric(as.factor(testing_m$G3))-1
p_rf_m_i <- as.numeric(p_rf_m)-1
accuracy_rf_m <- (sum(true_m & p_rf_m_i)+sum(!true_m & !p_rf_m_i))/length(true_m)
precision_rf_m <- sum(true_m & p_rf_m_i)/sum(p_rf_m_i)
recall_rf_m <- sum(true_m & p_rf_m_i)/sum(true_m)
F_measure_rf_m <- 2*precision_rf_m*recall_rf_m/(precision_rf_m+recall_rf_m)
cat("Math - logistic regression\nAccuracy: ",accuracy_rf_m,"\tPrecision: ",precision_rf_m,"\nRecall: ",recall_rf_m,"\tF1measure: ",F_measure_rf_m)
modelroc_rf_m <- roc(true_m,p_rf_m_i)
plot(modelroc_rf_m, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)

# -------------------------ptgs----------------------------
ind <- sample(2,nrow(ptgs_rf),replace = TRUE,prob=c(0.7,0.3))
training_p <- ptgs_rf[ind==1,]
testing_p <- ptgs_rf[ind==2,]

rf_p <- randomForest(as.factor(G3) ~ ., data = training_p, ntree = 500, importance = TRUE, proximity = TRUE)
print(rf_p)
plot(rf_p)
importance(rf_p)
varImpPlot(rf_p)
hist(treesize(rf_p,terminal = TRUE), main = "Tree size", col = "green", xlab = "size", ylab = "frequency")

p_rf_p <- predict(rf_p, newdata = testing_p)
table(testing_p$G3, p_rf_p)

true_p <- as.numeric(as.factor(testing_p$G3))-1
p_rf_p_i <- as.numeric(p_rf_p)-1
accuracy_rf_p <- (sum(true_p & p_rf_p_i)+sum(!true_p & !p_rf_p_i))/length(true_p)
precision_rf_p <- sum(true_p & p_rf_p_i)/sum(p_rf_p_i)
recall_rf_p <- sum(true_p & p_rf_p_i)/sum(true_p)
F_measure_rf_p <- 2*precision_rf_p*recall_rf_p/(precision_rf_p+recall_rf_p)
cat("Math - logistic regression\nAccuracy: ",accuracy_rf_p,"\tPrecision: ",precision_rf_p,"\nRecall: ",recall_rf_p,"\tF1measure: ",F_measure_rf_p)
modelroc_rf_p <- roc(true_p,p_rf_p_i)
plot(modelroc_rf_p, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)

