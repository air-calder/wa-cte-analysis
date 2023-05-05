cap log close
log using "W:\WA CTE SPED teachers\Log files\an_chetty.txt", text replace

use "W:\WA CTE SPED teachers\Data\analytic_data", replace
keep if CTEcourse == 1
keep if grade_from_enroll >= 10
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

gen nontest_factor = nontest_factor10 if grade_from_enroll == 10
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

global stuvar10plus c.smscore8 c.srscore8 smscore8_miss srscore8_miss c.lag_gpa c.lag_discipline_incidents c.lag_suspension c.lag_total_unexcu_abs c.lag_total_excu_abs lag_gpa_miss lag_suspension_miss lag_total_unexcu_abs_miss lag_total_excu_abs_miss lag_discipline_incidents_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80

*eststo reg_all_1:  reghdfe std_nontest_factor i.grade_from_enroll##($stuvar10plus $ctevars) [aw=final_weight], absorb(i.codistid  i.syear) vce(cluster certificationnumber) resid

egen class_var = group(term sectionid courseid school_id locationid codistid syear)
egen certnum = group(certificationnumber)

vam std_nontest_factor, quasi teacher(certnum) year(syear) class(class_var) controls($stuvar10plus $ctevars i.grade_from_enroll i.syear i.codistid) tfx_resid(certnum) driftlimit(5) data(merge tv score_r)

collapse tv tv_2yr_l score_r tv_2yr_f tv_ss std_nontest_factor (sum) num_students = final_weight (first) codistid, by(grade_from_enroll school_id syear) fast

		sort grade_from_enroll school_id syear
		egen sch_gr_id = group(grade_from_enroll school_id)
		tsset sch_gr_id syear
		
		//create change in value-added across school-grade-year
		//l2 leaves out forecast and prior year. f2 leaves out forecast year and following year
		gen d_tv = tv_2yr_l - l.tv_2yr_f
		gen d_std_nontest_factor = std_nontest_factor - l.std_nontest_factor
		
		areg d_std_nontest_factor d_tv [weight = num_students], absorb(syear) vce(cluster sch_gr_id)
		test d_tv = 1

log close