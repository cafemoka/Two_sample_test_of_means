<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=Tex-AMS-MML_HTMLorMML"></script>

# Two sample test of means

# t test

Suppose we have midterm scores of five classes. Each class has 120 students. 
We will test whether the score distributions of the first and second classes are the same by two sample t-test. 

```Matlab 
clear all; 

% load the dataset 
% 'grades' has 5 columns and 120 rows. 
% Each row represents a student, and each column represents a class. 
grades = load('grades.txt'); 

% We perform the two sample t-test of the grades of the first and second
% classes. 
x = grades(:,1);
y = grades(:,2);

% Null hypothesis: mean(x) = mean(y) 
[h,p] = ttest2(x,y);  
% h: 0 (rejected) 1 (accepted) 
% p: p-value 

% The null hypothesis was rejected. 
% Let's check the distribution of x and y 
% 1. by boxplot 
figure; 
subplot(2,3,[1 4]); 
boxplot([x y]); 
title('Boxplot of x and y'); 

% 2. by histogram 
subplot(2,3,[2 3]); hist(x); xlim([min(min(x),min(y)) max(max(x),max(y))]); 
title('Histogram of x'); 
subplot(2,3,[5 6]); hist(y); xlim([min(min(x),min(y)) max(max(x),max(y))]); 
title('Histogram of y'); 
``` 

![test_ttest2_1](https://user-images.githubusercontent.com/54297018/66203704-f726f180-e6e3-11e9-9f65-db404bb11387.png) 

We can make our own codes as follows: 

![ttest2_explanation](https://user-images.githubusercontent.com/54297018/66203766-250c3600-e6e4-11e9-91e7-6db8ae357fca.png)

1. Set null hypothesis: mean(x) = mean(y) 
2. Estimate test statistic t 
   to estimate t, we need the number of samples, mean, standard deviation, and the total standard deviation. 
3. Estimate the parameters of t distribution, nu 
4. Estimate the p-value by using cumulative distribution function for Student's t distribution, 'tcdf' 

```Matlab
% Let's make my own 'ttest2.m' 
% 1. null hypothesis: mean(x) = mean(y) 
% 2. Test statistic, t 
% number of samples in x and y
n1 = length(x); 
n2 = length(y); 
% mean of x and y 
mean1 = mean(x); 
mean2 = mean(y); 
% standard deviation of x and y 
std1 = std(x); 
std2 = std(y);
% total standard deviation 
s2T = sqrt(((n1-1)*std1^2 + (n2-1)*std2^2)/(n1+n2-2));
% test statistic t
t = (mean1-mean2)/(s2T*sqrt(1/n1+1/n2));

% 3. parameter of the test distribution 
nu = n1 + n2 - 2; 

% 4. Estimate p-value 
% A function 'tcdf' computes the cumulative distribution function for
% Student's T distribution with 'nu' degrees of freedom at the values in
% '-abs(t)'. 
% Both left and right tail 
myp = 2*tcdf(-abs(t),nu); 

% Compare p-value estimated by the function 'ttest2' and p-value estimated by my own code   
[p myp] 
```

ans =

    0.9867    0.9867
    
The p-values are the same. 


# Wilcoxon rank sum test (Mann Whitney U test) 

If we have the small number of samples and don't know the distribution of data, we can use Wilcoxon rank sum test for two sample test of means with null hypothesis, mean(x) = mean(y). 
The Wilcoxon rank sum test uses the rank of the data. 

If we have 10 samples: 5 samples in Group 1 and 5 samples in Group 2, we can't predict the exact samples in two groups that follows the null hypothesis, but we can predict the ranks of samples, for example, Group1={1, 3, 5, 7, 9} and Group2={2, 4, 6, 8, 10}. 
The total number of cases that the ranks of 10 samples, 1, 2, ... ,10, are divided into two groups with five elements is nchoosek(10,5)/2, where nchoosek(10,5) is the number of combinations for 10 things taken 5 at a time. 
The division by 2 is because the order of the groups is not important. 

$$nchoosek(10,5) = \frac{10!}{5!5!}$$ 
