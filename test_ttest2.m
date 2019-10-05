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
