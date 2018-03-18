# logisticRegression.R by Zhuowen Fang
# 2018.03.07

# install.packages("DMwR")
# install.packages("caret")
# install.packages("pROC")
library(grid)
library(DMwR)
library(lattice)
library(ggplot2)
library(caret)
data(mdrr)
library(pROC)

math <- read.csv("student-mat.csv", sep = ";") # Get student performance dataset
ptgs <- read.csv("student-por.csv", sep = ";")

sum(is.na(math)) # If there is any missing values
sum(is.na(ptgs))
# No missing values

hist(math$G3,breaks=seq(0,20,by=1))
hist(ptgs$G3,breaks=seq(0,20,by=1))

# Nominal to numeric
for (i in 1:ncol(math)) {
  if (is.factor(math[[i]])) {
    math[[i]] <- as.integer(math[[i]])
  }
}

for (i in 1:ncol(ptgs)) {
  if (is.factor(ptgs[[i]])) {
    ptgs[[i]] <- as.integer(ptgs[[i]])
  }
}

# Discretization
math$G3[math$G3<10] <- 0
math$G3[math$G3>=10&math$G3<=20] <- 1
ptgs$G3[ptgs$G3<10] <- 0
ptgs$G3[ptgs$G3>=10&ptgs$G3<=20] <- 1

# Filter - Chi-square test
as_math <- c()
i <- 1
while (i < ncol(math)) {
  tmp <- chisq.test(xtabs(~math$G3+math[[i]], data = math))$p.value[1]
  if (tmp < 0.05)
    as_math <- c(as_math, i)
  i <- i+1
}

as_ptgs <- c()
i <- 1
while (i < ncol(ptgs)) {
  tmp <- chisq.test(xtabs(~ptgs$G3+ptgs[[i]], data = ptgs))$p.value[1]
  if (tmp < 0.01)
    as_ptgs <- c(as_ptgs, i)
  i <- i+1
}

chi_math <- math[c(as_math,ncol(math))]
chi_ptgs <- ptgs[c(as_ptgs,ncol(ptgs))]

# -------------------------math----------------------------
ind <- sample(2,nrow(chi_math),replace = TRUE,prob=c(0.7,0.3))
training_m1 <- chi_math[ind==1,]
testing_m1 <- chi_math[ind==2,]
lr_m <- glm(G3~., training_m1, family = binomial(link = "logit"))
summary(lr_m)
anova(lr_m)
p_m <- predict(lr_m,testing_m1)
p_m <- exp(p_m)/(1+exp(p_m))
p_lr_m <- 1*(p_m>0.5)
table(testing_m1$G3, p_lr_m)
accuracy_lr_m <- (sum(testing_m1$G3 & p_lr_m)+sum(!testing_m1$G3 & !p_lr_m))/nrow(testing_m1)
precision_lr_m <- sum(testing_m1$G3 & p_lr_m)/sum(p_lr_m)
recall_lr_m <- sum(testing_m1$G3 & p_lr_m)/sum(testing_m1$G3)
F_measure_lr_m <- 2*precision_lr_m*recall_lr_m/(precision_lr_m+recall_lr_m)
cat("Math - logistic regression\nAccuracy: ",accuracy_lr_m,"\tPrecision: ",precision_lr_m,"\nRecall: ",recall_lr_m,"\tF1measure: ",F_measure_lr_m)
modelroc_lr_m <- roc(testing_m1$G3,p_lr_m)
plot(modelroc_lr_m, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)

# -------------------------ptgs----------------------------
ind <- sample(2,nrow(chi_ptgs),replace = TRUE,prob=c(0.7,0.3))
training_p1 <- chi_ptgs[ind==1,]
testing_p1 <- chi_ptgs[ind==2,]
lr_p <- glm(G3~., training_p1, family = binomial(link = "logit"))
summary(lr_p)
anova(lr_p)
p_p <- predict(lr_p,testing_p1)
p_p <- exp(p_p)/(1+exp(p_p))
p_lr_p <- 1*(p_p>0.5)
table(testing_p1$G3, p_lr_p)
accuracy_lr_p <- (sum(testing_p1$G3 & p_lr_p)+sum(!testing_p1$G3 & !p_lr_p))/nrow(testing_p1)
precision_lr_p <- sum(testing_p1$G3 & p_lr_p)/sum(p_lr_p)
recall_lr_p <- sum(testing_p1$G3 & p_lr_p)/sum(testing_p1$G3)
F_measure_lr_p <- 2*precision_lr_p*recall_lr_p/(precision_lr_p+recall_lr_p)
cat("Math - logistic regression\nAccuracy: ",accuracy_lr_p,"\tPrecision: ",precision_lr_p,"\nRecall: ",recall_lr_p,"\tF1measure: ",F_measure_lr_p)
modelroc_lr_p <- roc(testing_p1$G3,p_lr_p)
plot(modelroc_lr_p, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.2),
     grid.col=c("green", "red"), max.auc.polygon=TRUE,
     auc.polygon.col="skyblue", print.thres=TRUE)
