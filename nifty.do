clear all

*handle the display of results. On= pause every time. 
set more off

*1)Open the data
use nifty.dta

*2)declare the  data as time - series 

tsset obs, monthly

*3) Draw a diagram for the changing variable of the stock 
      *variable of stoc called: return_perc
      



*3)Generate the variable spread as the difference between 

*4)Plot the Long & short Term Int. Rate along with Their Spread

twoway (tsline return_perc), ttitle(Year) ///
title(Monthly Returns for NIFTY 50: 2013-2019)

*5)ACF & PACF functions 
     *Use corrgram command to figure out the ACF and PACF faster 

corrgram return_perc

ac return_perc, title(ACF of Returns at Level)

pac return_perc, title(PACF of Returns at Level)     

*6)Determine if stationary or not by referring to ACF and PACF by measuring ACF<= 1 (stationary)

*7)Generate the first difference of the varibale 

*8)Plor the first diff of spread

** The plot is fluctuating near zero, meaning not much information we could get from 1st diff.

***9)Choosing a model to use**
        *Using the model ARIMA()

arima return_perc if tin(1961Q4,2012Q4), ar(1 2 7)

** To compute AIC and SBC/BIC

estat ic

*Has to have have residuals which are white noise*

