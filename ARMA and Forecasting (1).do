clear all

set more off

* Open the data

use spread.dta


* Declare the data as time-series

tsset obs, quarterly

* Generate the variable spread as the difference between 

generate spread = r5 - tbill

* Plot the Long & short Term Int. Rate along with Their Spread

twoway (tsline spread) (tsline r5) (tsline tbill), ttitle(Year) ///
title(Long & Short Term Int Rate with Their Spread)

twoway (tsline spread), ttitle(Year) ///
title(Interest Rate Spread from 1960 to 2012)


** ACF & PACF functions of spread

corrgram spread, lags(20)

ac spread, title(ACF of Spread at Level)

pac spread, title(PACF of Spread at Level)

** Seems stationary as no ACF is equal to or greater than one.

* Generate the first difference of spread

generate dspread = D.spread

* Plor the first diff of spread

twoway (tsline dspread), ttitle(Year) ///
title(First Difference of Interest Rate Spread from 1960 to 2012)

** The plot is fluctuating near zero, meaning not much information we could get from 1st diff.

corrgram dspread, lags(20)


** Different Models:

** 1. AR(7) Model

arima spread if tin(1961Q4,2012Q4), arima(7,0,0)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resar7_spread, resid
 
corrgram resar7_spread, lags(20)

ac resar7_spread, title(ACF of Residual from AR(7) at Zero Difference)

** From AR(7) model, the residuals are white noise. We might continue with this.

** 2. AR(6) model

arima spread if tin(1961Q4,2012Q4), arima(6,0,0)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resar6_spread, resid

corrgram resar6_spread, lags(20)

ac resar6_spread, title(ACF of Residual from AR(6) at Zero Difference)

** Residuals seem white noise, except lag no. = 7. We may discard this one.


** 3. AR(2) model

arima spread if tin(1961Q4,2012Q4), arima(2,0,0)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resar2_spread, resid

corrgram resar2_spread, lags(20)

ac resar2_spread, title(ACF of Residual from AR(2) at Zero Difference)

** Starting from lag no. 3, residuals don't look like white noise. Discard this model.


** 4. AR(1,2,7) model

arima spread if tin(1961Q4,2012Q4), ar(1 2 7)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resar127_spread, resid

corrgram resar127_spread, lags(20)

ac resar127_spread, title(ACF of Residual from AR(1,2,7) Model at Zero Difference)

** Starting from lag no. 3, residuals don't look like white noise. Discard this model.


** 5. ARMA(1,1) model

arima spread if tin(1961Q4,2012Q4), arima(1,0,1)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resarma11_spread, resid

corrgram resarma11_spread, lags(20)

ac resarma11_spread, title(ACF of Residual from ARMA(1,1) Model at Zero Difference)

** Residuals doesn't look like white noise for higher lags. Discard this model.


** 6. ARMA(2,1) model

arima spread if tin(1961Q4,2012Q4), arima(2,0,1)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resarma21_spread, resid

corrgram resarma21_spread, lags(20)

ac resarma21_spread, title(ACF of Residual from ARMA(2,1) Model at Zero Difference)

** Residuals doesn't look like white noise for lags = 11, 12, 14, 15. Discard this model.


* 7. ARMA(2,(1,7)) model

arima spread if tin(1961Q4,2012Q4), ar(1 2) ma(1 7)

** To compute AIC and SBC/BIC

estat ic

** Diangostic test for residual

predict resarma217_spread, resid

corrgram resarma217_spread, lags(20)

ac resarma217_spread, title(ACF of Residual from ARMA(1,(1,7)) at Zero Difference)

* Residuals are white noise. We might continue with this model. 



*Conclusion - We may consider 2 models: AR(7) & ARMA(2,(1,7))

** computing optimal lags

varsoc spread, maxlag(8)

**************************************************************************

**** Forecasting ****

***************************************************************************

** Method -1** (Text Book's Method of F-test and MSPE Criteria)

***************************************************************************
** Create forecast from 1960q1 to 2009q1


** Model 1 - AR(7)**

clear all
use spread.dta
tsset obs, quarterly
gen spread = r5 - tbill

** Forecast from AR(7) with sample size 196 instead of 212

arima spread if tin(1961Q4,2008Q4), arima(7,0,0)

estimates store myar7


forecast create mymodel1

forecast estimates myar7


forecast solve, prefix(ar_) begin(196) end(211)

tsline spread ar_spread, xline(196)


*Generating Mean Square Prediction Error

regress spread ar_spread if obs>= 197
	
	* Devide Residual SS by df, which is MSE. Store as MSE_1 = 3.207/13 = 0.247

		** Stote F-statistics from the last Regerssion as well. 


** Rolling regression

rolling _b _se in 197/212, window(10) clear : reg spread ar_spread
  list in 1/5, abbrev(10) table

generate lower = _b_ar_spread - 1.96*_se_ar_spread
generate upper = _b_ar_spread + 1.96*_se_ar_spread

gen date = _n

twoway (line _b_ar_spread date) (rline lower upper date), ytitle("Beta from AR(7)")



** Model 2 - ARMA(2,(1,7))**

clear all
use spread.dta
tsset obs, quarterly
gen spread = r5 - tbill


** Forecast from ARMA(2,(1,7)) with sample size 198 instead of 212

arima spread if tin(1961Q4,2008Q4), ar(1,2) ma(1,7)


estimates store myarma217

forecast create mymodel2

forecast estimates myarma217

forecast solve, prefix(arma_) begin(196) end(211)

tsline spread arma_spread, xline(196)


*Generating Mean Square Prediction Error

reg spread arma_spread if obs >= 197
	
	* Devide Residual SS by df, which is MSE. Store as MSE_2 = 2.692/13 = 0.207

		** Store F-statistics from the last Regerssion as well. 


** Rolling regression

rolling _b _se in 197/212, window(10) clear : reg spread arma_spread
  list in 1/5, abbrev(10) table

generate lower = _b_arma_spread - 1.96*_se_arma_spread
generate upper = _b_arma_spread + 1.96*_se_arma_spread

gen date = _n

twoway (line _b_arma_spread date) (rline lower upper date), ytitle("Beta from ARMA(2, (1,7)")




***************************************************************************

** Method -2** 
** Debold Mariano Test**
** H0: Two models have same forecasting accuracy**

***************************************************************************

clear all
use spread.dta
tsset obs, quarterly
gen spread = r5 - tbill


** Model 1 - AR(7)**

arima spread if tin(1961Q4,2008Q4), arima(7,0,0) 

* We want to forecast from obs 197 to 212 (2009Q1 - 2012Q4)

predict sprdhat1, dynamic(197)

** Model 1 - ARMA(1,(1,7))**

arima spread if tin(1961Q4,2008Q4), ar(1,2) ma(1,7)

* We want to forecast from obs 197 to 212 (2009Q1 - 2012Q4)

predict sprdhat2, dynamic(197)

* Generating the DM test

dmariano spread sprdhat1 sprdhat2 if obs>190

****************



