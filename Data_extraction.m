clc
clear

[data1, companies, Raw] = xlsread('20030919-september_review_committee_papers.xls','Index','A7:J57');
%[data1, companies, Raw] = xlsread('20031219-december_2003_review_committee_papers.xls','Index','A7:J57');
% Checking free float requirements
[n m] = size(Raw);          %dimensions of the data set
included = ones(1,n);
N = 40;                         %number of constituents of the index

% for i = 1:n                 %for all the rows/companies check their free
%     %float is larger than 15%
%     if data1(i,10) < 0.15
%         included(i) = 0;
%         A = companies(i,1);
%         A = string(A);
%         fprintf(' The company %s was found to have a free float below 15%% \n and therefore is not eligible for the index \n',A)    %displays the company which failed the free float test
%     end
% end

% OR!

for i = 1:N     %checking if the company is included in the top40 or not
    if string(Raw(i,1)) == '0'
        included(i) = 0;    %if the company is not excluded assign 0 to its row position
        N = N + 1;          %if one of the companies is excluded add a row to be looked at.
    end
end

counter = sum(included == 0);   %the number of constituents to be excluded due to eligibility

%Note N is now minimum number of rows to look at that, includes the top40

%Calculating each companies weightings based on market cap

%initialising Price, Shares and free float vector
P = zeros(N,1); 
S = zeros(N,1); 
F = zeros(N,1);
Weightings = zeros(N,1);

P = data1(:,8); %assigning prices to P
S = data1(:,9); %assinging no of shares to S
F = data1(:,10);%assigning each companies floats to the appropriate shares

%deletes the non-eligible constituents
P = included'.*P;
S = included'.*S;
F = included'.*F;

d = 0;
for i = 1:N
    d = d + P(i)*S(i)*F(i);  %The sum of all the market caps (after free float adjustments)
                             %in the index
end

for i = 1:N
    Weightings(i) = (P(i)*S(i)*F(i))/d; %Note this doesnt include Capping factor C
end

sum(Weightings)         %checking that the weightings add up to 1

%Imposing weighting limit of 10%

%bla if W(i) > 0.1
    %W(i) = 0.1
    %re balance weightings.
%check again 

