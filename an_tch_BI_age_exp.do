cap log close
clear all
set more off

log using "W:\WA CTE SPED teachers\Log files\an_firststage_models.txt", text replace

use "W:\WA CTE SPED teachers\Data\analytic_data", replace
replace smscore8 = 0 if smscore8_miss == 1 // Want for regressions
replace srscore8 = 0 if srscore8_miss == 1 // Want for regressions

//Generate lagged missing variables 
gen lag_suspension_miss = (lag_suspension == .)
replace lag_suspension = 0 if lag_suspension_miss == 1 

gen lag_discipline_incidents_miss = (lag_discipline_incidents == .)
replace lag_discipline_incidents = 0 if lag_discipline_incidents_miss == 1

gen lag_total_unexcu_abs_miss = (lag_total_unexcu_abs == .)
replace lag_total_unexcu_abs = 0 if lag_total_unexcu_abs_miss == 1 

gen lag_total_excu_abs_miss = (lag_total_excu_abs == .)
replace lag_total_excu_abs = 0 if lag_total_excu_abs_miss == 1 

gen lag_gpa_miss = (lag_gpa == .)
replace lag_gpa = 0 if lag_gpa_miss == 1 

//Combine cte pathway into one catergory 
gen other_pathway = (cte_pathway_bi == 0 & cte_pathway_uni == 0)

//Combine cte certifications into one category 
gen other_cert = (cert_cte_full == 0 & cert_cte_temp == 0)

//Generate teacher experience variable 
gen tch_exp_5_10 = inrange(tch_exp, 5, 9.99)

gen tch_exp_10_20 = inrange(tch_exp, 10, 19.99)

gen tch_exp_20 = tch_exp >= 20

gen tch_exp_miss = tch_exp == .

//Generate birth cohorts
gen tch_birth_60s = inrange(tch_birthyear,1960,1969)
gen tch_birth_70s = inrange(tch_birthyear,1970,1979)
gen tch_birth_80s = inrange(tch_birthyear,1980,1989)
gen tch_birth_90s = inrange(tch_birthyear,1990,1999)

/*Teacher variables 
tch_female tch_sex_missing tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_10 tch_exp_10_20 tch_exp_20 tch_exp_miss tch_birth_60s tch_birth_70s tch_birth_80s tch_birth_90s other_cert cert_cte_full end_cte cte_pathway_bi other_pathway c.westb_mean 
*/

//Look at experience and birth year by teachers with no degree 
tab tch_nodegree if tch_exp_5_10 == 1 & tch_birth_60s == 1 
tab tch_nodegree if tch_exp_5_10 == 1 & tch_birth_70s == 1 
tab tch_nodegree if tch_exp_5_10 == 1 & tch_birth_80s == 1 
tab tch_nodegree if tch_exp_5_10 == 1 & tch_birth_90s == 1 

tab tch_nodegree if tch_exp_10_20 == 1 & tch_birth_60s == 1 
tab tch_nodegree if tch_exp_10_20 == 1 & tch_birth_70s == 1 
tab tch_nodegree if tch_exp_10_20 == 1 & tch_birth_80s == 1 
tab tch_nodegree if tch_exp_10_20 == 1 & tch_birth_90s == 1 

tab tch_nodegree if tch_exp_20 == 1 & tch_birth_60s == 1 
tab tch_nodegree if tch_exp_20 == 1 & tch_birth_70s == 1 
tab tch_nodegree if tch_exp_20 == 1 & tch_birth_80s == 1 
tab tch_nodegree if tch_exp_20 == 1 & tch_birth_90s == 1 

//Look at business and industry cte teachers by experience and birth year 
tab cte_pathway_bi if tch_exp_5_10 == 1 & tch_birth_60s == 1 
tab cte_pathway_bi if tch_exp_5_10 == 1 & tch_birth_70s == 1 
tab cte_pathway_bi if tch_exp_5_10 == 1 & tch_birth_80s == 1 
tab cte_pathway_bi if tch_exp_5_10 == 1 & tch_birth_90s == 1 

tab cte_pathway_bi if tch_exp_10_20 == 1 & tch_birth_60s == 1 
tab cte_pathway_bi if tch_exp_10_20 == 1 & tch_birth_70s == 1 
tab cte_pathway_bi if tch_exp_10_20 == 1 & tch_birth_80s == 1 
tab cte_pathway_bi if tch_exp_10_20 == 1 & tch_birth_90s == 1 

tab cte_pathway_bi if tch_exp_20 == 1 & tch_birth_60s == 1 
tab cte_pathway_bi if tch_exp_20 == 1 & tch_birth_70s == 1 
tab cte_pathway_bi if tch_exp_20 == 1 & tch_birth_80s == 1 
tab cte_pathway_bi if tch_exp_20 == 1 & tch_birth_90s == 1 

tab cte_pathway_bi if tch_nodegree == 1 












