* Taking the example data set from STATA 

*use http://www.stata-press.com/data/r15/wpi1.dta

use http://www.stata-press.com/data/r16/wpi1.dta

* Declare the data as time-series

tsset t, quarterly

* Draw a line diagram for the variable wpi

twoway (tsline wpi), ytitle(wpi) ttitle(year) ///
 title(Whole Sale Price Index from 1960 to 1990)
 
twoway (tsline wpi), ytitle(log(wpi)) ttitle(year) ///
 title(US Whole Sale Price Index from 1960 to 1990)
 
twoway (tsline D.ln_wpi), ytitle(dlog(wpi)) ttitle(year) ///
 title(First Difference of US WPI from 1960 to 1990)
 

* Drawing the autocorrelation function of log(wpi) at level
 
ac ln_wpi, ytitle(log(wpi)) xtitle(year) title(ACF of WPI at Level)
 
 * Drawing the partial autocorrelation function of log(wpi) at level
 
pac ln_wpi, ytitle(log(wpi)) xtitle(year) title(PACF of WPI at level)

** Conclusion - ACF is slowly decaying and PACF is oscillating. 
** The series log(wpi) is non-stationary at level.

* Drawing the autocorrelation function of first diff of log(wpi)

ac D.ln_wpi, title(ACF of 1st Difference of log(wpi))

** From ACF it seems there MA(5) is appropiate

* Drawing the partial autocorrelation function of first diff of log(wpi)

pac D.ln_wpi, title(PACF of 1st Difference of log(wpi))

** From PACF it seems there AR(1,3) is appropiate

* Estimating by AR(1)

arima D.ln_wpi, ar(1)

* Estimating AR(1,3)

arima D.ln_wpi, ar(1 3)

* Estimating MA(1)

arima D.ln_wpi, ma(1)

* Estimating MA(5)

arima D.ln_wpi, ma(5)

* Estimating ARMA(1,1)

arima D.ln_wpi, ar(1) ma(1)

* Estimating ARMA(1 3,5)

arima D.ln_wpi, ar(1 3) ma(1 2 3 4 5)

* Estimating ARMA(1 3,1)

arima D.ln_wpi, ar(1 3) ma(1)

*Lag 3 becomes insignificant. We may go for ARMA(1,1) model

** Estimation and Diagnostic Test

* 1) Estimating ARMA(1,1)

arima D.ln_wpi, ar(1) ma(1)

* 2) Obtain the residuals

predict Dln_wpires, resid

* 3) Plot the ACF fucntion of the residuals

ac Dln_wpires, title(ACF of Residuals at 0 Difference)

* Plot the PACF functions of the residuals

pac Dln_wpires, title(PACF of Residuals at 0 Difference)


**

** Estimation and Diagnostic Test with level data

* 1) Estimating ARMA(1,1)

arima ln_wpi, ar(1) ma(1)

* 2) Obtain the residuals

predict ln_wpires, resid

* 3) Plot the ACF fucntion of the residuals

ac ln_wpires, title(ACF of Residuals at 0 Difference)

* Plot the PACF functions of the residuals

pac ln_wpires, title(PACF of Residuals at 0 Difference)

