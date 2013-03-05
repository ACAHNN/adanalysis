% second price auction optimal reserve
clear
close all

 
% load bid data 
load rev10.mat
subplot(3,1,1)
hist(x,1000);
h=title('histogram of second prices from antennaweb.org');
set(h,'Fontsize',14)

 
% parameters of log normal model mu and sig
% number of bidders k
% find MLE fit of model to data
% be careful to make search ranges large enough
% and fine enough... may need to tune this for
% on a case by case basis
t=0;
for k=1:10
    for mu = -10:.1:0
        for sig = 1:.1:3
            t = t+1;
            f = pdf('logn',x,mu,sig);
            F = cdf('logn',x,mu,sig);
            p = k*(k-1)*F.^(k-2).*(1-F).*f;
            ll(t) = sum(log(p));
            kk(t)=k;
            mm(t)=mu;
            ss(t)=sig;
        end
    end
end
[mn,tml] = max(ll);
kml = kk(tml);
muml = mm(tml);
sigml = ss(tml);
[kml muml sigml]

 
% MLE bid distribution
mxbid = max(x);
x = 0:.0001:mxbid;
f = pdf('logn',x,muml,sigml);
F = cdf('logn',x,muml,sigml);
subplot(3,1,3)
plot(x,f)
str = sprintf('MLE bid dist:  lognormal(%f,%f)',muml,sigml);
h=title(str);
set(h,'Fontsize',14)

 

 
% MLE second price distribution 
p = kml*(kml-1)*F.^(kml-2).*(1-F).*f;
subplot(3,1,2)
plot(x,p)
str = sprintf('MLE 2nd price dist: %f bidders, lognormal(%f,%f)',kml,muml,sigml);
h=title(str);
set(h,'Fontsize',14)