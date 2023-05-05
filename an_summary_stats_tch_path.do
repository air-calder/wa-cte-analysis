*Summary Statistics
*Roddy Theobald
*last modified: 1/28/22 by Roddy Theobald

clear all
cap log close
log using "W:\WA CTE SPED teachers\Log files\an_summary_stats.txt", text replace
clear all
set more off

use "W:\WA CTE SPED teachers\Data\analytic_data", replace

duplicates drop certificationnumber, force

keep if CTEcourse == 1 
/*
count if cte_pathway_uni == 1 gen(tch_uni)

gen tch_uni = count cte_pathway_uni if cte_pathway_uni == 1 

gen tch_bi = count cte_pathway_bi if cte_pathway_bi == 1 
*/

local tchvars tch_exp tch_female tch_aian tch_asianpi tch_black tch_hisp tch_white tch_mastersplus tch_bachelors tch_nodegree cert_cte_temp cert_cte_full cert_cte

*local ctevars clus_HumanServices clus_HealthScience clus_ArtsComm clus_BuisManAdmin clus_Agriculture clus_STEM clus_InfoTech clus_Hospitality clus_Architecture clus_Law clus_Education clus_Manufacturing clus_Transportation clus_Marketing clus_Finance clus_GovPublicAdmin clus_All prog_TechSci prog_BuisMarketing prog_FamilyCons prog_HumanServices prog_HealthSciences prog_AgriculturalEd prog_STEM prog_All

//bys cte_pathway_bi: sum `allvars' `ctevars' if CTEcourse == 1

//Summary Stats Traditional Pathway 
eststo tch_uni_pathway: estpost summarize `tchvars' [aw=final_weight] if cte_pathway_uni == 1

eststo tch_bi_pathway: estpost summarize `tchvars' [aw=final_weight] if cte_pathway_bi == 1 
esttab tch_uni_pathway tch_bi_pathway using "W:\WA CTE SPED teachers\Output\summary_stats_tch_pathway.csv", replace main(mean) aux(sd) mtitle nostar unstack nonote nonumber

log close
