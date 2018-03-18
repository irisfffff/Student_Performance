# Student Performance Data Mining
This project is about using data mining techniques to predict students' final grade from the [Student Performance](http://archive.ics.uci.edu/ml/datasets/Student+Performance) data set from UCI Machine Learning Repository.

## Motivation
Data mining is one of the most interesting course I've had during my undergraduate study though it's a bit tough at first because I did so little math in these two years. After taking the course, we were encouraged to do our own project and I found this appropriate dataset.

## Aim
The aim of the project is to predict whether a student will pass either course in the end. The grade is recorded in 20-point score system but instead of predicting a score, I think predict a simple result would be more helpful and accurate.

## Process
The project follows Image result for crisp-dm
Cross-industry standard process for data mining (CRISP-DM). There is no missing value in this dataset and I used chi-square test to select attributes.

In modulation part, I compared logistic regression to random forest. Random forest doesn't require data selecting soI used the original data and I do find it performs better without chi-test filter in logistic regression :( The results are as bellow:
![](https://ws2.sinaimg.cn/large/006tKfTcgy1fph3jjr8v8j316e0dy0vf.jpg)

## Deployment
Since Math and Porguguese are two quite different subjects, they perform very differently. Overall, the most important features in a student's final grade is his former grades, past course failures, how often he goes out with friends and family relationship.

With this conclusion, teachers can preemptively become aware of which kids might need more attention to help them pass and it also helps students with their future plans.

## Authors

* **Zhuowen Fang** - *Initial work* - [irisfffff](https://github.com/irisfffff)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
