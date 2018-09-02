# Immigrant types assimilation rate
Using US census data to look at the assimilation rate of refugees, family and economic immigrants between 2000 and 2010.

In this project I use US Census and the American Community Survey data to assess the assimilation rate of different immigrant types. Since neither of these surveys provide information on visa types that immigrants hold, I have proxied immigrant type (refugee, family reunification immigrants and economic/work immigrants) by country of origin and year of arrival. Looking at those immigrants arriving only between 1995 and 2000, immigrant groups were defined as follows: 

Family Immigrants: Philippines 
Refugee Immigrants: Vietnam and Cuba, and countries from the former Soviet Union
Economic Immigrants: South Africa and Canada

To assess assimilation rate, I look at the economic outcomes of each group between 2000 and 2010, looking at:  wages; the probability of being employed, and; the probability of working in a "high skilled" job. 

## In this repository:

1) For summary statistics for refugees, family immigrants, Economic immigrants please see summaryFamRefEcon.do, and for summary statistics for US natives, please see summarynatives.do

2) PSM-DiD on a Wage Equation: I use the Difference in Difference "DiD" estimator to estimate the causal effect ofimmigrant type on the rate of assimilation which will be measured as the change inincome over 10 years. I use Ordinary Least Squares (OLS) on an augmented Mincer equation. To ensure that the common trends assumption is satisfied, I use Propensity Score Matching (PSM) to ensure that comparison groups are valid counterfactuals (after performing some balancing tests). This can be found in WageEqu.do - note that here you will need to select the control immigrant group to compare to the family reunification immigrants

3) Estimate two probit models per time period to compare probability of being employed and the probability of being in a highly skilled job. High-skilled occupations are defined as those in the top three categories of the Standard Occupational Classification system (SOC) (i.e. Managers and Senior Officials, Professional occupations, and Occupational Classifcation Associate Professional and Technical). This can be found in ProbitFamvsRef.do and ProbitFamvsEcon.do, where the former compares family immigrants to refugees while in the latter family immigrants are compared to economic immigrants. 

4) In Robustnesschecks.do: I perform a test to check whether there could be endogeneity in my model(s) due to unobserved characteristics of immigrants from the global North. By removing older immigrants that are coming from Canada, whose returns to years of experience would be closer to natives' than any of the other immigrant sourcecountries in my sample, I drop Canadian immigrants that are over the age of 35 in 2000 (age >= 45 in 2010) from my sample to hopefully remove some endogeneity as per Ruiz and Vargas-Silva (2016). The second test that I perform is to investigate whether it is the presence of Cuban and Vietnamese immigrants in the refugee cohort that results in an insignificant difference in expected mean outcomes between family reunification immigrants and refugee immigrants. Literature highlights that historically Cuban and Vietnamese immigrants have been successful in the US due to ethnic enclaves if the enclave economy hypothesis is to be believed (Portes and Bach,1985).

## Results Summary
I find that the average wages of family immigrants exceed average wages of economic immigrants by 2010 despite initially having lower wages. I also find that by 2010 both have very similar probability of being employed. Both results corroborate existing findings in the assimilation literature. The key difference between the two groups is that a gap in occupational prestige grows between 2000 and 2010, with family immigrants being less likely (approximately 24 percentage points less likely) than economic immigrants to work in a highly skilled job in 2010. I also find that on the whole, family reunifcation immigrants and refugees had very little differences in outcomes by 2010, despite refugees having a lower wage and a lower probability of being employed not long after arrival to the US. A significant difference is the average marginal effect of being employed in a highly skilled job: refugees were less likely to be employed in high skilled jobs by 2010, suggesting that family reunification immigrants have better occupational mobility in the long-run.


