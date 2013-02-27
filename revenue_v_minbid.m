% revenue_v_minbid
% r. nowak
% 2/13/13

clear
close all

% choose formatting of your file

% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00000-of-00010');
 fid = fopen('_www.antennaweb.org_');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00002-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00003-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00004-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00005-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00006-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00007-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00008-of-00010');
% fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00009-of-00010');

C = textscan(fid, '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%f%s%s%s%s','Delimiter',',');

% get revenues
revenue = C{17};

% get minbids
minbid = C{18};
minbid = str2double(minbid)/1000;

close all
figure(1)
scatter(minbid,revenue)
axis([0 max(minbid) 0 5*max(minbid)])
t=title('revenue vs. minbid');
set(t,'Fontsize',20)


ii = find(minbid>=0);
minbidvals = unique(minbid(ii));

for i=1:length(minbidvals)
    jj = find(minbid==minbidvals(i));
    mr = revenue(jj); 
    kk = find(mr>=0 & mr <= 100);
    meanrevenue(i) = mean(mr(kk));
end

figure(2)
kk = find(meanrevenue>=0);
plot(minbidvals(kk),meanrevenue(kk),'*m')
hold on
plot(minbidvals(kk),meanrevenue(kk))
plot(minbidvals(kk),minbidvals(kk),'k')
t=title('mean revenue vs. minbid');
set(t,'Fontsize',20)

vv = mean(meanrevenue(kk)'./minbidvals(kk))
