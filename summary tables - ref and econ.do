

clear all
cd /Users/annapeebles-brown/Dropbox/Dissertation
use usa_00010.dta

	
qui {	
drop if age<=24 & year==2000
drop if age>=46 & year==2000 
drop if age<=34 & year==2010
drop if age>=56 & year==2010
drop if age==.
drop if yrimmig<=1994
drop if yrimmig>=2001 
drop if yrimmig==0
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
	
gen id=_n
compress id white emplyd agesq agecu agefo logwage female marr



		** Treatment Dummy **
gen D_F00=.
	replace D_F00=1 if bpld==51500  /*Family Immigrant*/     
	/*replace D_F00=0 if bpld==51800   /* Can restrict - Ref */
	replace D_F00=0 if bpld==25000   /* Can restrict - Ref */
	replace D_F00=0 if bpld==45700   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46530   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46540   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46541   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46542   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46543   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46544   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46545   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46546   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46547   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46548   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46590   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46000   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46100   /* Can restrict - Ref */
	replace D_F00=0 if bpld==46200   /* Can restrict - Ref */ */ 
	replace D_F00=0 if bpld==15000   /* Can restrict - Econ */ 
	replace D_F00=0 if bpld==60094   /* Can restrict - Econ */
drop if D_F00==. 

gen hskill = 1 if strmatch(occsoc, "1*") | strmatch(occsoc, "2*")
	replace hskill=0 if strmatch(occsoc, "3*") | strmatch(occsoc, "4*") | strmatch(occsoc, "5*")

}


** Summary Stats For Family, Economic and Refugee Immigrants - user needs to select
bysort D_F00 year: sum D_F00 female white marr educ nchild age emplyd hskill
