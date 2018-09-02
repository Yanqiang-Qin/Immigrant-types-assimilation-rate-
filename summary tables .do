

clear all
cd /Users/annapeebles-brown/Dropbox/Dissertation
use usa_00010.dta

		
qui {	
drop if age<=24 & year==2000
drop if age>=46 & year==2000 
drop if age<=34 & year==2010
drop if age>=56 & year==2010
drop if age==.
drop if yrimmig!=0
drop if yrimmig==.
drop if incwage==.
drop if statefip==.
gen agesq=(age)^2
gen agecu=(age)^3
gen agefo=(age)^4
gen incwage99=incwage*cpi99
gen logwage=log(incwage99)
label variable logwage "log Wage" 
drop if logwage==.
gen white=.
	replace white=1 if race==1
	replace white=0 if race==2
	replace white=0 if race==3
	replace white=0 if race==3
	replace white=0 if race==4
	replace white=0 if race==5
	replace white=0 if race==6
	replace white=0 if race==7
	replace white=0 if race==8
	replace white=0 if race==9
	drop if white==.
gen emplyd=.
	replace emplyd=1 if empstat==1
	replace emplyd=0 if empstat==2
drop if emplyd==.
gen female=.
	replace female=1 if sex==2
	replace female=0 if sex==1
gen marr=.
	replace marr=1 if marst==1
	replace marr=1 if marst==2
	replace marr=0 if marst==3
	replace marr=0 if marst==4
	replace marr=0 if marst==5
	replace marr=0 if marst==6
	drop if marr==.
drop if nchild==.	
	gen hskill = 1 if strmatch(occsoc, "1*") | strmatch(occsoc, "2*")
	replace hskill=0 if strmatch(occsoc, "3*") | strmatch(occsoc, "4*") | strmatch(occsoc, "5*")
gen id=_n
compress id white emplyd agesq agecu agefo logwage female marr

}


** Summary Stats for Natives **
bysort year: sum female white marr educ nchild age emplyd hskill

