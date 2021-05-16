clear all

*handle the display of results. On= pause every time. 
set more off

*1)Open the data
use spread.dta

*2)declare the  data as time - series 

*3) Draw a diagram for the changing variable of the stock 

*3)Generate the variable spread as the difference between 

*4)Plot the Long & short Term Int. Rate along with Their Spread

*5)ACF & PACF functions 
     *Use corrgram command to figure out the ACF and PACF faster 

*6)Determine if stationary or not by referring to ACF and PACF by measuring ACF<= 1 (stationary)

*7)Generate the first difference of spread

*8)Plor the first diff of spread

** The plot is fluctuating near zero, meaning not much information we could get from 1st diff.

***9)Choosing a model to use**

*Has to have have residuals which are white noise*

