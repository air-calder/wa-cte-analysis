*First-Stage Models
*last modified: 3/11/22 by Roddy Theobald

cap log close
log using "W:\WA CTE SPED teachers\Log files\an_coefplots.txt", text replace

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

*Grade 9
factor ln_excu_abs_plus1 ln_unexcu_abs_plus1 ln_discipline_incidents_plus1 ln_suspension_plus1 _gpa grade_progression [aw=final_weight] if grade_from_enroll == 9, mineigen(1)
local num_factors = e(f)
rotate, factor(`num_factors') blanks(.3)
rotate, factor(`num_factors')
esttab  e(L) using "W:\WA CTE SPED teachers\Output\pca9.csv",  replace b(4)
predict nontest_factor9 if grade_from_enroll == 9, bartlett
replace nontest_factor9 = -nontest_factor9  if grade_from_enroll == 9

*Grade 10
factor ln_excu_abs_plus1 ln_unexcu_abs_plus1 ln_discipline_incidents_plus1 ln_suspension_plus1 _gpa grade_progression [aw=final_weight] if grade_from_enroll == 10, mineigen(1)
local num_factors = e(f)
rotate, factor(`num_factors')
esttab  e(L) using "W:\WA CTE SPED teachers\Output\pca10.csv",  replace b(4)
predict nontest_factor10 if grade_from_enroll == 10, bartlett
replace nontest_factor10 = -nontest_factor10  if grade_from_enroll == 10

*Grade 11
factor ln_excu_abs_plus1 ln_unexcu_abs_plus1 ln_discipline_incidents_plus1 ln_suspension_plus1 _gpa grade_progression [aw=final_weight] if grade_from_enroll == 11, mineigen(1)
local num_factors = e(f)
rotate, factor(`num_factors')
esttab  e(L) using "W:\WA CTE SPED teachers\Output\pca11.csv",  replace b(4) 
predict nontest_factor11 if grade_from_enroll == 11, bartlett
replace nontest_factor11 = -nontest_factor11  if grade_from_enroll == 11

*Grade 12
factor ln_excu_abs_plus1 ln_unexcu_abs_plus1 ln_discipline_incidents_plus1 ln_suspension_plus1 _gpa on_time_graduation [aw=final_weight] if grade_from_enroll == 12, mineigen(1)
local num_factors = e(f)
rotate, factor(`num_factors')
esttab  e(L) using "W:\WA CTE SPED teachers\Output\pca12.csv",  replace b(4) 
predict nontest_factor12 if grade_from_enroll == 12, bartlett
replace nontest_factor12 = -nontest_factor12  if grade_from_enroll == 12

gen nontest_factor = nontest_factor9 if grade_from_enroll == 9
drop nontest_factor9 
replace nontest_factor = nontest_factor10 if grade_from_enroll == 10
drop nontest_factor10 
replace nontest_factor = nontest_factor11 if grade_from_enroll == 11
drop nontest_factor11 
replace nontest_factor = nontest_factor12 if grade_from_enroll == 12
drop nontest_factor12 

bys grade_from_enroll syear: egen std_nontest_factor = std(nontest_factor)

global allvars total_excu_abs total_unexcu_abs discipline_incidents suspension _gpa grade_progression on_time_graduation smscore8 srscore8 smscore8_miss srscore8_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 tch_female tch_sex_missing tch_aian tch_asianpi tch_black tch_hisp tch_ethnic_miss tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_10 tch_exp_10_20 tch_exp_20 tch_exp_miss tch_birth_60s tch_birth_70s tch_birth_80s tch_birth_90s other_cert cert_cte_full end_cte cte_pathway_bi other_pathway

global ctevars clus_HumanServices clus_HealthScience clus_ArtsComm clus_BuisManAdmin clus_Agriculture clus_STEM clus_InfoTech clus_Hospitality clus_Architecture clus_Law clus_Education clus_Manufacturing clus_Transportation clus_Marketing clus_Finance clus_GovPublicAdmin clus_All prog_TechSci prog_BuisMarketing prog_FamilyCons prog_HumanServices prog_HealthSciences prog_AgriculturalEd prog_STEM prog_All

*Control variable vector 
/*Old 9th grade local
local xvar9 smscore8 srscore8 smscore8_miss srscore8_miss lag_discipline_incidents lag_suspension lag_total_unexcu_abs lag_total_excu_abs lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 tch_female tch_sex_missing tch_aian tch_asianpi tch_black tch_hisp tch_ethnic_miss tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_12 tch_exp_12_20 tch_exp_20 other_cert cert_cte_full end_cte cte_pathway_bi other_pathway 
*/

//Local for student variables 
global stuvar10plus c.smscore8 c.srscore8 smscore8_miss srscore8_miss c.lag_gpa c.lag_discipline_incidents c.lag_suspension c.lag_total_unexcu_abs c.lag_total_excu_abs lag_gpa_miss lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 

//Local for teacher variables 
global tchvar tch_female tch_sex_missing tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_10 tch_exp_10_20 tch_exp_20 tch_exp_miss tch_birth_60s tch_birth_70s tch_birth_80s tch_birth_90s other_cert cert_cte_full end_cte cte_pathway_bi other_pathway

eststo reg_all_2:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
estimates store A
eststo reg_all_2_int:  reghdfe std_nontest_factor i.spec_ed##(i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar) [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
estimates store B
eststo reg_all_2_sped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
estimates store C
eststo reg_all_2_notsped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
estimates store D

//Label key variables for table 
lab var tch_female "Teacher Female (Ref. Male)" 
lab var tch_nodegree "Teacher No Degree (Ref. B.A.)"
lab var tch_mastersplus "Teacher M.A. (Ref B.A.)"
lab var cert_cte_full "Full Certificate (Ref. Limited)"
lab var end_cte "CTE Endorsement (Ref. None)"
lab var cte_pathway_bi "B&I Pathway (Ref. Traditional)"

//Coefficient plots 
//Horizontal Plot 
coefplot, drop(_cons) keep(tch_female tch_nodegree tch_mastersplus cert_cte_full end_cte cte_pathway_bi) xline(0) xtitle(Expected Change in Non-Test Factor)

//SWD and non-SWD 
coefplot C D, drop(_cons) keep(tch_female tch_nodegree tch_mastersplus cert_cte_full end_cte cte_pathway_bi) xline(0) xtitle(Expected Change in Non-Test Factor) p1(label(SWD)) p2(label (non-SWD))


(C, lable(SWD)) (D, lable(non-SWD)) 

log close