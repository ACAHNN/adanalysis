% adanalysis
% a. cahn
% 2/21/13

clear
close all


%open the daily report file
fid = fopen('_www.antennaweb.org_');
%fid = fopen('_www.titantv.com_');
%fid = fopen('_www.kcrg.com_');
%fid = fopen('_www.komonews.com_');
%fid = fopen('_www.katu.com_');
%fid = fopen('_www.trinidadexpress.com_');
addata = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%u%s%s%f%f%s%s%u',100000,'delimiter',',');
disp('File Read Done');

%parse the date/time column into separate date and time columns
timecell = cell(size(addata{2},1),2);
j=1;
for i=1:size(addata{2},1)
    if(~isempty(addata{2}{i,1}))
        timecell(j,:) = textscan(addata{2}{i,1},'%s%s','delimiter',' ');
        j=j+1;
    end
end
%grab revenue column
revenue = addata{17};
clearvars addata

%parse the time into hour, minute, and second columns
hmscell = cell(j-1,3);
for i=1:j-1
    hmscell(i,:) = textscan(timecell{i,2}{1,1},'%s%s%s','delimiter',':');
end
clearvars timecell
disp('Time Extraction Done');

%convert the the hour/minute/second time into a fractional time with 24
%being the max
time=zeros(size(hmscell,1),1);
for i=1:size(hmscell,1)
    time(i,1) = str2double(hmscell{i,1}) + (str2double(hmscell{i,2})*60 + str2double(hmscell{i,3}))/3600;
end
clearvars hmscell
disp('Time Conversion Done');

%extract the volume on a per hour basis
timei = round(time); 
volume = zeros(24,1);
for i=1:24   
    for j=1:size(timei,1)
        if(timei(j,1) == i)
            volume(i) = volume(i)+1;
        end
    end
end
volume = volume(:)/1000;
%clearvars timei

%find the mean on a per hour basis
meanh = zeros(24,1);
for i=1:24;
    inds = find(timei>i-1 & timei<i+1);
    meanh(i) = mean(revenue(inds));
end

%build the revenue vs time graph
figure(1)
scatter(time,revenue);
t=title('Revenue vs. Time');
xlabel('Time (Hours)');
ylabel('Revenue (Cents)');
set(t,'Fontsize',20)
hold on

%build the volume vs time graph
figure(2)
plot(1:24,volume,':o')
t=title('Volume vs. Time');
xlabel('Time (Hours)');
ylabel('Volume (in thousands)');
set(t,'Fontsize',20)

%build the mean revenue vs time graph
figure(3)
plot(1:24,meanh,':s')
t=title('Mean Revenue vs. Time');
xlabel('Time (Hours)');
ylabel('Mean Revenue');
set(t,'Fontsize',20)    


%close input file
fclose(fid);