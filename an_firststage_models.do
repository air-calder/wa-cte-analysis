*First-Stage Models
*last modified: 2/16/22 by Roddy Theobald

cap log close
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
hist std_nontest_factor
graph export "W:\WA CTE SPED teachers\Output\std_nontest_factor.png", replace

global allvars total_excu_abs total_unexcu_abs discipline_incidents suspension _gpa grade_progression on_time_graduation smscore8 srscore8 smscore8_miss srscore8_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 tch_female tch_sex_missing tch_aian tch_asianpi tch_black tch_hisp tch_ethnic_miss tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_10 tch_exp_10_20 tch_exp_20 tch_exp_miss tch_birth_60s tch_birth_70s tch_birth_80s tch_birth_90s other_cert cert_cte_full end_cte cte_pathway_bi other_pathway

global ctevars clus_HumanServices clus_HealthScience clus_ArtsComm clus_BuisManAdmin clus_Agriculture clus_STEM clus_InfoTech clus_Hospitality clus_Architecture clus_Law clus_Education clus_Manufacturing clus_Transportation clus_Marketing clus_Finance clus_GovPublicAdmin clus_All prog_TechSci prog_BuisMarketing prog_FamilyCons prog_HumanServices prog_HealthSciences prog_AgriculturalEd prog_STEM prog_All

*Control variable vector 
/*Old 9th grade local
local xvar9 smscore8 srscore8 smscore8_miss srscore8_miss lag_discipline_incidents lag_suspension lag_total_unexcu_abs lag_total_excu_abs lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 tch_female tch_sex_missing tch_aian tch_asianpi tch_black tch_hisp tch_ethnic_miss tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_12 tch_exp_12_20 tch_exp_20 other_cert cert_cte_full end_cte cte_pathway_bi other_pathway 
*/

//Local for student variables 
global stuvar9 smscore8 srscore8 smscore8_miss srscore8_miss lag_discipline_incidents lag_suspension lag_total_unexcu_abs lag_total_excu_abs lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 

//Local for teacher variables 
global tchvar tch_female tch_sex_missing tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_10 tch_exp_10_20 tch_exp_20 tch_exp_miss tch_birth_60s tch_birth_70s tch_birth_80s tch_birth_90s other_cert cert_cte_full end_cte cte_pathway_bi other_pathway

sum $stuvar9 if grade_from_enroll == 9 

*9th grade regressions
eststo reg_9_1:  reghdfe std_nontest_factor $stuvar9 $ctevars [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_1_sped:  reghdfe std_nontest_factor $stuvar9 $ctevars [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_1_notsped:  reghdfe std_nontest_factor $stuvar9 $ctevars [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_2:  reghdfe std_nontest_factor $stuvar9 $ctevars $tchvar  [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_2_sped:  reghdfe std_nontest_factor $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_2_notsped:  reghdfe std_nontest_factor $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_3:  reghdfe ln_excu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_3_sped:  reghdfe ln_excu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_3_notsped:  reghdfe ln_excu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_4:  reghdfe ln_unexcu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_4_sped:  reghdfe ln_unexcu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_4_notsped:  reghdfe ln_unexcu_abs_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_5:  reghdfe ln_discipline_incidents_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_5_sped:  reghdfe ln_discipline_incidents_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_5_notsped:  reghdfe ln_discipline_incidents_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_6:  reghdfe ln_suspension_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_6_sped:  reghdfe ln_suspension_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_6_notsped:  reghdfe ln_suspension_plus1 $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_7:  reghdfe _gpa $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_7_sped:  reghdfe _gpa $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1  & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_7_notsped:  reghdfe _gpa $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1  & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_8:  reghdfe grade_progression $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_8_sped:  reghdfe grade_progression $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_9_8_notsped:  reghdfe grade_progression $stuvar9 $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
esttab  reg_9_1 reg_9_1_sped reg_9_1_notsped reg_9_2 reg_9_2_sped reg_9_2_notsped reg_9_3 reg_9_3_sped reg_9_3_notsped reg_9_4 reg_9_4_sped reg_9_4_notsped reg_9_5 reg_9_5_sped reg_9_5_notsped reg_9_6 reg_9_6_sped reg_9_6_notsped reg_9_7 reg_9_7_sped reg_9_7_notsped reg_9_8 reg_9_8_sped reg_9_8_notsped using "W:\WA CTE SPED teachers\Output\reg9.csv", replace b(4) se(6) star(* 0.05 ** 0.01 *** 0.001)

/*Old 10+ local
local xvar10plus smscore8 srscore8 smscore8_miss srscore8_miss lag_gpa lag_discipline_incidents lag_suspension lag_total_unexcu_abs lag_total_excu_abs lag_gpa_miss lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 tch_female tch_sex_missing tch_aian tch_asianpi tch_black tch_hisp tch_ethnic_miss tch_mastersplus tch_nodegree tch_missingdegree tch_exp_5_12 tch_exp_12_20 tch_exp_20 other_cert cert_cte_full end_cte cte_pathway_bi other_pathway $ctevars
*/

global stuvar10plus c.smscore8 c.srscore8 smscore8_miss srscore8_miss c.lag_gpa c.lag_discipline_incidents c.lag_suspension c.lag_total_unexcu_abs c.lag_total_excu_abs lag_gpa_miss lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80

sum $stuvar10plus if grade_from_enroll >= 10 

*10th grade regressions
eststo reg_10_1:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_1_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_1_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_2:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_2_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_2_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_3:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_3_sped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_3_notsped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_4:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_4_sped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_4_notsped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_5:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_5_sped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_5_notsped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_6:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_6_sped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_6_notsped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_7:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_7_sped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_7_notsped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_10_8:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber) 
eststo reg_10_8_sped:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber) 
eststo reg_10_8_notsped:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber) 
esttab  reg_10_1 reg_10_1_sped reg_10_1_notsped reg_10_2 reg_10_2_sped reg_10_2_notsped reg_10_3 reg_10_3_sped reg_10_3_notsped reg_10_4 reg_10_4_sped reg_10_4_notsped reg_10_5 reg_10_5_sped reg_10_5_notsped reg_10_6 reg_10_6_sped reg_10_6_notsped reg_10_7 reg_10_7_sped reg_10_7_notsped reg_10_8 reg_10_8_sped reg_10_8_notsped using "W:\WA CTE SPED teachers\Output\reg10.csv", replace b(4) se(6) star(* 0.05 ** 0.01 *** 0.001)

*11th grade regressions
eststo reg_11_1:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_1_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_1_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_2:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_2_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_2_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_3:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_3_sped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_3_notsped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_4:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_4_sped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_4_notsped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_5:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_5_sped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_5_notsped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_6:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_6_sped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_6_notsped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_7:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_7_sped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1  & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_7_notsped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1  & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_8:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_8_sped:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_11_8_notsped:  reghdfe grade_progression $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
esttab  reg_11_1 reg_11_1_sped reg_11_1_notsped reg_11_2 reg_11_2_sped reg_11_2_notsped reg_11_3 reg_11_3_sped reg_11_3_notsped reg_11_4 reg_11_4_sped reg_11_4_notsped reg_11_5 reg_11_5_sped reg_11_5_notsped reg_11_6 reg_11_6_sped reg_11_6_notsped reg_11_7 reg_11_7_sped reg_11_7_notsped reg_11_8 reg_11_8_sped reg_11_8_notsped using "W:\WA CTE SPED teachers\Output\reg11.csv", replace b(4) se(6) star(* 0.05 ** 0.01 *** 0.001)

*12th grade regressions
eststo reg_12_1:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_1_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_1_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_2:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_2_sped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_2_notsped:  reghdfe std_nontest_factor $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_3:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_3_sped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_3_notsped:  reghdfe ln_excu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_4:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_4_sped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_4_notsped:  reghdfe ln_unexcu_abs_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_5:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_5_sped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_5_notsped:  reghdfe ln_discipline_incidents_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_6:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_6_sped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_6_notsped:  reghdfe ln_suspension_plus1 $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_7:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_7_sped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_7_notsped:  reghdfe _gpa $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_8:  reghdfe on_time_graduation $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_8_sped:  reghdfe on_time_graduation $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_12_8_notsped:  reghdfe on_time_graduation $stuvar10plus $ctevars $tchvar [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
esttab  reg_12_1 reg_12_1_sped reg_12_1_notsped reg_12_2 reg_12_2_sped reg_12_2_notsped reg_12_3 reg_12_3_sped reg_12_3_notsped reg_12_4 reg_12_4_sped reg_12_4_notsped reg_12_5 reg_12_5_sped reg_12_5_notsped reg_12_6 reg_12_6_sped reg_12_6_notsped reg_12_7 reg_12_7_sped reg_12_7_notsped reg_12_8 reg_12_8_sped reg_12_8_notsped using "W:\WA CTE SPED teachers\Output\reg12.csv", replace b(4) se(6) star(* 0.05 ** 0.01 *** 0.001)

//All grades regression add if grade_frm_enroll >= 10 
eststo reg_all_1:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber) resid
predict resid, residuals
bys certificationnumber syear: egen totalweight = sum(final_weight)
egen certgroup = group(certificationnumber)
preserve
collapse resid totalweight [aw=final_weight] , by(certgroup syear)
sort certgroup syear
tsset certgroup syear
cor resid l.resid [aw=totalweight]
sum resid l.resid [aw=totalweight]
restore

//Regressions for all students
eststo reg_all_1_sped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_1_notsped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_2:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_2_int:  reghdfe std_nontest_factor i.spec_ed##(i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar) [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_2_sped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_2_notsped:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_3:  reghdfe ln_excu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_3_sped:  reghdfe ln_excu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_3_notsped:  reghdfe ln_excu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_4:  reghdfe ln_unexcu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_4_sped:  reghdfe ln_unexcu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_4_notsped:  reghdfe ln_unexcu_abs_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_5:  reghdfe ln_discipline_incidents_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_5_sped:  reghdfe ln_discipline_incidents_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_5_notsped:  reghdfe ln_discipline_incidents_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_6:  reghdfe ln_suspension_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_6_sped:  reghdfe ln_suspension_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_6_notsped:  reghdfe ln_suspension_plus1 i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_7:  reghdfe _gpa i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_7_sped:  reghdfe _gpa i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_7_notsped:  reghdfe _gpa i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_8:  reghdfe on_time_graduation i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_8_sped:  reghdfe on_time_graduation i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 1 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)
eststo reg_all_8_notsped:  reghdfe on_time_graduation i.grade_from_enroll##($stuvar10plus $ctevars) $tchvar [aw=final_weight] if CTEcourse == 1 & spec_ed == 0 & grade_from_enroll >= 10, absorb(i.codistid  i.syear) vce(cluster certificationnumber)

esttab  reg_all_1 reg_all_1_sped reg_all_1_notsped reg_all_2 reg_all_2_sped reg_all_2_notsped reg_all_3 reg_all_3_sped reg_all_3_notsped reg_all_4 reg_all_4_sped reg_all_4_notsped reg_all_5 reg_all_5_sped reg_all_5_notsped reg_all_6 reg_all_6_sped reg_all_6_notsped reg_all_7 reg_all_7_sped reg_all_7_notsped using "W:\WA CTE SPED teachers\Output\regall.csv", replace b(4) se(6) star(* 0.05 ** 0.01 *** 0.001)

log close