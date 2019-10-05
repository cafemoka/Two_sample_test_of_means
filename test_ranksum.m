% Wilcoxon rank sum test 
group1 = [7 5 6 4 12]; 
group2 = [3 6 4 2 1]; 

p = ranksum(group1,group2,'tail','right'); 

% 1. Estimate the rank of samples 
n1 = 5; n2 = 5; n = n1+n2; 
samples = [group1 group2]; 
[tval,tind] = sort(samples,'ascend'); 
[val,ia] = unique(tval); 

% rerank elements with the same value
orank = [1:n]; 
rrank = zeros(1,n);
for i = 1:length(ia), 
    if i < length(ia), 
        rrank(ia(i):(ia(i+1)-1)) = mean(orank(ia(i):(ia(i+1)-1))); 
    else
        rrank(ia(i):n) = mean(orank(ia(i):n));
    end 
end
rank_samples = zeros(1,n);
rank_samples(tind) = rrank;

% 2. Estimate test statistic U 
group1_rank = rank_samples(1:n1); 
group2_rank = rank_samples(n1+1:n); 
R1 = sum(group1_rank); 
R2 = sum(group2_rank); 
U1 = n1*n2 + n1*(n1+1)/2 - R1;
U2 = n1*n2 + n2*(n2+1)/2 - R2;
U = min(U1,U2);

% 3. Estimate test distribution 
% 'nchoosek' returns all possible combinaitions of the elements of [1:10]
% taken 5 at a time 
group1_null = nchoosek([1:10],5); 
group2_null = []; 
for i = 1:size(group1_null,1), 
    group2_null(i,:) = setdiff([1:10],group1_null(i,:)); 
end 
R1 = sum(group1_null,2);
R2 = sum(group2_null,2); 
U1 = n1*n2 + n1*(n1+1)/2 - R1;
U2 = n1*n2 + n2*(n2+1)/2 - R2;
Unull = min(U1,U2);

% 4. Estimate p-value 
myp = sum(Unull < 3)/length(Unull); 

% Compare p estimated by 'ranksum' and myp estimated by my own code 
[p my]