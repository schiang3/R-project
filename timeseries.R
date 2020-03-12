library(forecast)
library(magrittr)
library(fpp2)
library(astsa)
library(lmtest)
library(ggplot2)
setwd('C:/Users/Shuya C/Desktop/depaul/DSC 425/group')
gl= read.csv(file="GOOGL.csv", header=TRUE, sep=",")
gl$Date=as.Date(gl$Date)
head(gl)
tail(gl)
str(gl)
#check missing value
missing_value<-sum(is.na(gl))
print(missing_value)
summary(gl)
hist(gl$Close)

#google_close
#2006 -253 ,2007-253, 2008-255,2009-253,2010-251,2011-255,2012-252,
#2013-253, 2014-256,2015-253,2016-253,2017-254 (each year - observations)
#timeplot using frequency =253
g_close=ts(gl$Close,start=2006,end=2017, frequency =253 )
autoplot(g_close,xlab = "Date", ylab = "Close price")
gl$Close %>% acf2()
Acf(g_close,lag.max=60)
Box.test(g_close, lag=6, type='Ljung')
hist(g_close)
library(tseries)
library(moments)
skewness(g_close)
agostino.test(g_close)
kpss.test(g_close,null = "Trend")
kpss.test(g_close,null = "Level")

#log transformation
ln_close= log(gl$Close)
ln_cts=ts(ln_close,start=2006,end=2017, frequency =253)
autoplot(ln_cts, xlab = "Time", ylab = "ln_close",main ="The time plot of log(close)")
summary(ln_cts)

gl$Close%>% log %>% acf2()
acf(ln_close,lag.max=100)
kpss.test(ln_cts,null = "Trend")
kpss.test(ln_cts,null = "Level")
hist(ln_cts)

#first order - differecing
diff1_ts =ts(diff(gl$Close),start=2006,end=2017, frequency =253)
autoplot(diff1_ts, xlab = "Time", ylab = "diff(close)",main ="The time plot of diff(close)")
gl$Close %>% diff() %>% acf2()
kpss.test(diff1_ts,null = "Trend")
kpss.test(diff1_ts,null = "Level")
hist(diff1_ts)

#log transformation with first order differecing
g_close %>% log %>% diff() %>% autoplot()
gl$Close%>%log %>% diff() %>% acf2()
ln_diff_ts=ts(diff(ln_close))
kpss.test(ln_diff_ts,null = "Trend")
kpss.test(ln_diff_ts,null = "Level")
hist(ln_diff_ts)
#auto arima using whole dataset
fit<-auto.arima(g_close, trace=TRUE, allowmean=FALSE, allowdrift = FALSE, max.p=1, 
           max.q=1, max.P=1, max.Q=1,max.d=1,max.D=1, ic="bic")
fit
fit %>% forecast(h=506)%>%plot()
forecast(fit,h=506)
source("backtest_v2.R")
backtest(fit,g_close,2100,1)
m=auto.arima(g_close, trace=TRUE, allowmean=TRUE, allowdrift = TRUE, max.p=1, 
             max.q=1, max.P=1, max.Q=1,max.d=1,max.D=1, ic="aic")
m
#using window to forecast-spliting the data
xtr= window(g_close, start=2006, end=2014)
xtest=window(g_close,start=2014)
#auto arima using training set
fit2 <-auto.arima(xtr, ic=c("bic"))
fit2
#forecast
forecast(fit2, h = 759, level = c(0.70, 0.90)) %>% plot()
lines(xtest)
auto_fc = forecast(fit2, h = 759, level = c(0.70, 0.90))
auto_fc
library(MLmetrics)
#sarima
sa1 = sarima(g_close, p=0, d=1, q=0, no.constant = TRUE)
sa1
#arima(0,1,0)
fc_s1=sarima.for(xtr,759, p=0, d=1, q=0)


#arima(0,1,0)(0,0,1)[253]
sa2 = sarima(g_close, p=0, d=1, q=0,P = 0, D = 0, Q = 1,S=253, no.constant = TRUE)
sa2
fc_s2=sarima.for(xtr,759, p=0, d=1, q=0, P = 0,D = 0, Q = 1,S=253)


#arima(1,1,0)
sa3 = sarima(g_close, p=1, d=1, q=0, no.constant = TRUE)
sa3
fc_s3=sarima.for(xtr,759, p=1, d=1, q=0)

#arima(0,1,1)
sa4 = sarima(g_close, p=0, d=1, q=1, no.constant = TRUE)
sa4
fc_s4=sarima.for(xtr,759, p=0, d=1, q=1)

#arima(1,1,1)
sa5 = sarima(g_close, p=1, d=1, q=1, no.constant = TRUE)
sa5
fc_s5=sarima.for(xtr,759, p=1, d=1, q=1)

#RMSE
RMSE( fc_s1$pred,xtest)
RMSE( fc_s2$pred,xtest)
RMSE( fc_s3$pred,xtest)
RMSE( fc_s4$pred,xtest)
RMSE( fc_s5$pred,xtest)
#BEST MODEL
sarima(xtr, p=0, d=1, q=0, P=0,D = 0, Q = 1,S=253)
sarima.for(xtr,759, p=0, d=1, q=0,P=0, D = 0, Q = 1,S=253)
lines(xtest)


