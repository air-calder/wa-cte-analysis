*Summary Statistics
*Roddy Theobald
*last modified: 11/14/22 by Roddy Theobald

clear all
cap log close
log using "W:\WA CTE SPED teachers\Log files\an_summary_stats.txt", text replace
clear all
set more off

use "W:\WA CTE SPED teachers\Data\analytic_data", replace

//Student and Teacher Variables
local allvars total_excu_abs total_unexcu_abs discipline_incidents suspension _gpa grade_progression on_time_graduation smscore8 srscore8 smscore8_miss srscore8_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl dis_ld dis_health dis_ebd dis_autism dis_intellectual dis_other lre_80_100 lre_40_80 lre_other tch_exp tch_female tch_sex_missing tch_mastersplus tch_bachelors tch_nodegree tch_missingdegree cert_cte_temp cert_cte_full end_cte cte_pathway_bi cte_pathway_uni 

//Student Variables 
local stu_allvars total_excu_abs total_unexcu_abs discipline_incidents suspension _gpa grade_progression on_time_graduation smscore8 srscore8 smscore8_miss srscore8_miss female black americanindian_alaskannative asian hispanic_latinx nativehawaiian_other spec_ed lep frl

//CTE variables 
local ctevars clus_HumanServices clus_HealthScience clus_ArtsComm clus_BuisManAdmin clus_Agriculture clus_STEM clus_InfoTech clus_Hospitality clus_Architecture clus_Law clus_Education clus_Manufacturing clus_Transportation clus_Marketing clus_Finance clus_GovPublicAdmin clus_All prog_TechSci prog_BuisMarketing prog_FamilyCons prog_HumanServices prog_HealthSciences prog_AgriculturalEd prog_STEM prog_All

bys cte_pathway_bi: sum `allvars' `ctevars' if CTEcourse == 1

//Teacher Variables 
local tchvars tch_exp tch_female tch_aian tch_asianpi tch_black tch_hisp tch_white tch_mastersplus tch_bachelors tch_nodegree cert_cte_temp cert_cte_full end_cte

//Student and Teacher Summary Stats 
eststo grade_from_enroll9_nosped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 0

eststo grade_from_enroll9_sped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1 & spec_ed == 1

eststo grade_from_enroll10_nosped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 0

eststo grade_from_enroll10_sped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1 & spec_ed == 1

eststo grade_from_enroll11_nosped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 0

eststo grade_from_enroll11_sped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1 & spec_ed == 1

eststo grade_from_enroll12_nosped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 0

eststo grade_from_enroll12_sped: estpost summarize `allvars' [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1 & spec_ed == 1

esttab grade_from_enroll9_nosped grade_from_enroll9_sped grade_from_enroll10_nosped grade_from_enroll10_sped grade_from_enroll11_nosped grade_from_enroll11_sped grade_from_enroll12_nosped grade_from_enroll12_sped using "W:\WA CTE SPED teachers\Output\student_tch_summary_stats.csv", replace main(mean) aux(sd) mtitle nostar unstack nonote nonumber

//Student Summary Stats
eststo grade_from_enroll9_0: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 9 & CTEcourse  == 0

eststo grade_from_enroll9_1: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1

eststo grade_from_enroll10_0: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 10  & CTEcourse  == 0

eststo grade_from_enroll10_1: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 10  & CTEcourse  == 1

eststo grade_from_enroll11_0: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 11 & CTEcourse  == 0

eststo grade_from_enroll11_1: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 11 & CTEcourse  == 1

eststo grade_from_enroll12_0: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 12 & CTEcourse  == 0 

eststo grade_from_enroll12_1: estpost summarize `stu_allvars' [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1

esttab grade_from_enroll9_0 grade_from_enroll9_1 grade_from_enroll10_0 grade_from_enroll10_1 grade_from_enroll11_0 grade_from_enroll11_1 grade_from_enroll12_0 grade_from_enroll12_1 using "W:\WA CTE SPED teachers\Output\student_summary_stats.csv", replace main(mean) aux(sd) mtitle nostar unstack nonote nonumber

//Teacher Summary Stats 
eststo tch_grade_9: estpost summarize `tchvars' `ctevars'  [aw=final_weight] if grade_from_enroll == 9 & CTEcourse == 1

eststo tch_grade_10: estpost summarize `tchvars' `ctevars'  [aw=final_weight] if grade_from_enroll == 10 & CTEcourse == 1

eststo tch_grade_11: estpost summarize `tchvars' `ctevars'  [aw=final_weight] if grade_from_enroll == 11 & CTEcourse == 1

eststo tch_grade_12: estpost summarize `tchvars' `ctevars'  [aw=final_weight] if grade_from_enroll == 12 & CTEcourse == 1

esttab tch_grade_9 tch_grade_10 tch_grade_11 tch_grade_12 using "W:\WA CTE SPED teachers\Output\tch_summary_stats.csv", replace main(mean) aux(sd) mtitle nostar unstack nonote nonumber

//Summary Stats Traditional Pathway 
duplicates drop certificationnumber, force

keep if CTEcourse == 1 

eststo tch_uni_pathway: estpost summarize `tchvars' [aw=final_weight] if cte_pathway_uni == 1

eststo tch_bi_pathway: estpost summarize `tchvars' [aw=final_weight] if cte_pathway_bi == 1 

esttab tch_uni_pathway tch_bi_pathway using "W:\WA CTE SPED teachers\Output\summary_stats_tch_pathway.csv", replace main(mean) aux(sd) mtitle nostar unstack nonote nonumber

log close





	