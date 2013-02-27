% adanalysis
% a. cahn
% 2/21/13
dlmcell
clear
close all

%macro for array allocation
numrows = 50000;

%open the daily report file
fid = fopen('REPORT_CSV_seller_IC_87330338_2013-01-30-00009-of-00010');

%allocate addata and read in from the CSV file
rline = fgetl(fid);
x=1;
while(ischar(rline))
    addata = cell(numrows,21);
    i = 1;
    while (ischar(rline) && i <= numrows)
        temp = textscan(rline,'%s%s%s%s%s%s%s%s%s%s%s%s%s%u%s%s%f%f%s%s%u','delimiter',',');
        addata(i,:) = temp;
        rline = fgetl(fid);
        i = i+1;
    end

    %grab the url in cell and str versions as well as scrub addata
    url = addata(:,5);
    j=1;
    for i=1:numrows 
        if(addata{i,21} == 0 | addata{i,21} == 1)   
            urlstr(j,1) = url{i};
            addata(j,:) = addata(i,:);
            j = j+1;
        end
    end

    %find the indices of unique urls
    [unurls,ia,ic] = unique(urlstr);
    [indices,ja,jc] = unique(ic);
    %{
    for i=1:size(ia)
        badsp = strfind(unurls{i,1},' ');
        badqu = strfind(unurls{i,1},'"');
        if(~isempty(badsp) || ~isempty(badqu))
            disp(unurls{i,1})
        end
       % clearvars badurl
    end
    %}
    
    %create a file for each unique url and write all lines associated with it
    
    for i=1:size(ia)
        badurl = strfind(unurls{i,1},' ');
        badqu = strfind(unurls{i,1},'"');
        if(isempty(badurl) && isempty(badqu))
            file = sprintf('_%s_',unurls{i,1});
            uind = find(jc>i-1 & jc<i+1);
            %write out to files
            dlmcell(file,addata(uind(:),:),',','-a');
        end
    end
    
    clearvars -except fid numrows rline x
    rline = fgetl(fid);
    disp(x);
    x=x+1;
end

%finish the program
disp('Done');
fclose(fid);

