% adx1
% r. nowak
% 2/4/13

clear
close all

% choose formatting of your file

fid = fopen('_www.antennaweb.org_');

C = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%f%s%s%s%s','Delimiter',',');

 

% converts '2013-01-29 20:10:00' into a float describing number of
% fractional days since 'Jan-1-0000 00:00:00'. That is, datenum('Jan-2-0000
% 00:00:00') returns 2. 

goodi = 1-strcmp(C{2},'')-strcmp(C{2},'true');
ii = find(goodi==1); ii = ii(1:end-1);
time = datenum(C{2}(ii));
time = time-min(time);
[time jj] = sort(time,'ascend');


% get revenues
revenue = C{17}(ii);
revenue = revenue(jj);

figure(1)
semilogy(time,revenue)


% filter by URL

goodi = 1-strcmp(C{2},'')-strcmp(C{2},'true'); % eliminate missing/erroneous times
goodi = goodi.*strcmp(C{3},'false'); % eliminate anonymous bids
goodi = goodi.*strcmp(C{7},'http://www.antennaweb.org/');

ii = find(goodi==1); ii = ii(1:end-1);
time = datenum(C{2}(ii));
time = time-min(time);
[time jj] = sort(time,'ascend');


% get revenues
revenue = C{17}(ii);
revenue = revenue(jj);

minbid = C{18}(ii);
minbid = str2double(minbid(jj))/1000;

anonymous = strcmp(C{3}(ii),'false');

figure(2)
subplot(3,1,1)
semilogy(time,revenue)
hold on
semilogy(time,minbid,'m')
t=title('revenue (blue) and minbid (magenta) vs. time')
set(t,'Fontsize',20)

subplot(3,1,2)
[n,m]=hist(double(revenue),100);
hist(double(revenue),100);
t=title('histogram of revenue for http://www.komonews.com/')
set(t,'Fontsize',20)

subplot(3,1,3)
hist(double(minbid),m)
t=title('histogram of minbids')
set(t,'Fontsize',20)

figure(3)
ii = find(minbid==min(minbid));
subplot(2,1,1)
[n,m]=hist(double(revenue(ii)),100);
hist(double(revenue(ii)),100);
t=title('histogram of revenue for min(minbid)')
set(t,'Fontsize',20)
subplot(2,1,2)
hist(double(minbid(ii)),m)
t=title('histogram of min(minbid)')
set(t,'Fontsize',20)
