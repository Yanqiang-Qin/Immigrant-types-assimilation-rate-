clear all
cd /Users/annapeebles-brown/Dropbox/Dissertation
use usa_00010.dta

** Robustness (1) - For Economic Immigrants, remove older Canadians **

qui {	
drop if age<=24 & year==2000
drop if age>=46 & year==2000 
drop if age>=36 & year==2000 & bpld==15000
drop if age<=34 & year==2010
drop if age>=56 & year==2010
drop if age>=46 & year==2010 & bpld==15000
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
*drop if female==0

		** Treatment Dummy **
gen D_F00=.
	replace D_F00=1 if bpld==51500      
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


label define D_F00 0 "Employment or Refugee" 1 "Family Immigrant"
label variable D_F00 "Family Immigrant Dummy Variable" 
compress D_F00

	** Census Year Dummy Variable **
gen d_y=.
	replace d_y=1 if year==2010
	replace d_y=0 if year==2000

label define d_y 1 "Census Year 2010" 0 "Census Year 2000"
label variable d_y "Census Year Dummy Variable"
	compress d_y
	
gen dfdyr=D_F00*d_y
compress dfdyr
xtset id year 
}
	
	
	
	** Balancing Test & Graph **
		
 /* Test Without Weights */
diff logwage, t(D_F00) p(d_y) cov(age agesq agecu agefo white marr nchild female) test 		

  /* Test with weights */
diff logwage, t(D_F00) p(d_y) cov(age agesq agecu agefo marr nchild female) test kernel rcs ktype(gaussian)

 /* Graphing Propensity Score - no Weights */
twoway (kdensity _ps if D_F00==1 & d_y==0) (kdensity _ps if D_F00==0 & d_y==0, lpattern(dash)), legend( label( 1 "Family Immigrants") label(  2 "Economic Immigrants" ) ) xtitle("Propensity Score Comparison without Weights - Robustness Test")


		*  PS with new weights (Kernel)  *
		gen n_ps=_ps*_weight

/* Graphing Propensity Score - with Kernel Weights */
*twoway (kdensity n_ps if D_F00==1 & d_y==0) (kdensity n_ps if D_F00==0 & d_y==0, lpattern(dash)), legend( label( 1 "Family Immigrants") label(  2 "Economic Immigrants" ) ) xtitle("Propensity Score Comparison with Weights - Robustness Test")

** Kernel Matching
		** ATT with -diff- command **
diff logwage, t(D_F00) p(d_y) cov(statefip yrimmig age agesq agecu agefo educ white marr nchild female) kernel rcs ktype(gaussian) pscore(_ps) robust
*The above command is useful (two period PSM DiD) as it gives me the pscore and kernel weights
*but limitations to metiod. Use pscore to construct IPW and run linear regression that way 
	
		** Regression Using Kernel Weights for ATE **
*Simple*		
reg logwage i.D_F00##i.d_y [aw=_weights], robust
est store basic
*Full*
reg logwage i.D_F00##i.d_y age agesq agecu agefo white educ nchild marr i.female [aw=_weights], robust
est store controls
****FE****
xtset id year
*Simple FE*
reg logwage i.D_F00##i.d_y i.statefip i.yrimmig [aw=_weights], robust	
*Full FE*
reg logwage i.D_F00##i.d_y age agesq agecu agefo white educ nchild marr i.female i.statefip i.yrimmig [aw=_weights], robust	
est store fe

est table basic controls fe,  b(%7.4f) star
est table basic controls fe,  b se



*****************************************************************

clear all
cd /Users/annapeebles-brown/Dropbox/Dissertation
use usa_00010.dta

** Robustness (2) - remove Cuban and Vietnamese Immigrants **


	
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
*drop if female==0






		** Treatment Dummy **
gen D_F00=.
	replace D_F00=1 if bpld==51500      
	*replace D_F00=0 if bpld==51800  /* Can restrict - Cuban Ref */
	*replace D_F00=0 if bpld==25000   /* Can restrict - Vietnam Ref */
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
	replace D_F00=0 if bpld==46200   /* Can restrict - Ref */ 
	*replace D_F00=0 if bpld==15000   /* Can restrict - Econ */ 
	*replace D_F00=0 if bpld==60094   /* Can restrict - Econ */
drop if D_F00==.


label define D_F00 0 "Employment or Refugee" 1 "Family Immigrant"
label variable D_F00 "Family Immigrant Dummy Variable" 
compress D_F00

	** Census Year Dummy Variable **
gen d_y=.
	replace d_y=1 if year==2010
	replace d_y=0 if year==2000

label define d_y 1 "Census Year 2010" 0 "Census Year 2000"
label variable d_y "Census Year Dummy Variable"
	compress d_y
	
gen dfdyr=D_F00*d_y
compress dfdyr
xtset id year 
}
	

	
	
	** Balancing Test & Graph **
		
 /* Test Without Weights */
diff logwage, t(D_F00) p(d_y) cov(age agesq agecu agefo white marr nchild female) test 

 /* Test with weights */
diff logwage, t(D_F00) p(d_y) cov(age agesq agecu agefo marr nchild female) test kernel rcs ktype(gaussian)
		

 /* Graphing Propensity Score - no Weights */
twoway (kdensity _ps if D_F00==1 & d_y==0) (kdensity _ps if D_F00==0 & d_y==0, lpattern(dash)), legend( label( 1 "Family Immigrants") label(  2 "Economic & Refugees" ) ) xtitle("Propensity Score Comparison without Weights")


		*  PS with new weights (Kernel)  *
		*gen n_ps=_ps*_weight

/* Graphing Propensity Score - with Kernel Weights */
*twoway (kdensity n_ps if D_F00==1 & d_y==0) (kdensity n_ps if D_F00==0 & d_y==0, lpattern(dash)), legend( label( 1 "Family Immigrants") label(  2 "Economic & Refugees" ) ) xtitle("Propensity Score Comparison with Weights")

** Kernel Matching
		** ATT with -diff- command **
diff logwage, t(D_F00) p(d_y) cov(statefip yrimmig age agesq agecu agefo educ white marr nchild female) kernel rcs ktype(gaussian) pscore(_ps) robust
*The above command is useful (two period PSM DiD) as it gives me the pscore and kernel weights
*but limitations to metiod. Use pscore to construct IPW and run linear regression that way 
	
		** Regression Using Kernel Weights for ATE **
*Simple*		
reg logwage i.D_F00##i.d_y [aw=_weights], robust
est store basic
*Full*
reg logwage i.D_F00##i.d_y age agesq agecu agefo white educ nchild marr i.female [aw=_weights], robust
est store controls
****FE****
xtset id year
*Simple FE*
reg logwage i.D_F00##i.d_y i.statefip i.yrimmig [aw=_weights], robust	
*Full FE*
reg logwage i.D_F00##i.d_y age agesq agecu agefo white educ nchild marr i.female i.statefip i.yrimmig [aw=_weights], robust	
est store fe

est table basic controls fe,  b(%7.4f) star
est table basic controls fe,  b se
