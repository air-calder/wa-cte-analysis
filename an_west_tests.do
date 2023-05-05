cap log close
clear all
set more off

use "W:\WA CTE SPED teachers\Data\analytic_data"

//Keep CTE courses 
keep if CTEcourse == 1 

//Drop to one observation per teacher 
duplicates drop certificationnumber, force 

//tabulate overall how many CTE teachers have taken WEST-B and WEST-E tests 
//List of west tests 
/*westb_math 
westb_read 
westb_writ 
weste_ag 
weste_bilingual 
weste_biology 
weste_business 
weste_chem 
weste_dance1 
weste_dance2 
weste_deaf 
weste_world 
weste_latin 
weste_early1 
weste_early2 
weste_earth 
weste_elem1 
weste_elem2 
weste_ELA 
weste_ELL 
weste_family 
weste_health 
weste_history 
weste_library 
weste_math 
weste_mlhum11 
weste_mlhum12
weste_mlhum21 
weste_mlhum22 
weste_mlmath 
weste_mlscience 
weste_choral1 
weste_choral2 
weste_music 
weste_music1 
weste_music2 
weste_physics 
weste_reading 
weste_science 
weste_socialstudies 
weste_sped 
weste_tech 
weste_theatre1 
weste_theatre2 
weste_traffic 
weste_visual
*/

local west

//Generate teacher experience variable 
gen tch_exp_0_5 = inrange(tch_exp, 0, 4.99)

gen tch_exp_5_10 = inrange(tch_exp, 5, 9.99)

gen tch_exp_10_20 = inrange(tch_exp, 10, 19.99)

gen tch_exp_20 = tch_exp >= 20

//Tabulations 
tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if tch_exp_0_5

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if tch_exp_5_10

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if tch_exp_10_20

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if tch_exp_20

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if cte_pathway_bi == 1

tab1 westb_math westb_read westb_writ weste_ag weste_bilingual weste_biology weste_business weste_chem weste_dance1 weste_dance2 weste_deaf weste_world weste_latin weste_early1 weste_early2 weste_earth weste_elem1 weste_elem2 weste_ELA weste_ELL weste_family weste_health weste_history weste_library weste_math weste_mlhum11 weste_mlhum12 weste_mlhum21 weste_mlhum22 weste_mlmath weste_mlscience weste_choral1 weste_choral2 weste_music weste_music1 weste_music2 weste_physics weste_reading weste_science weste_socialstudies weste_sped weste_tech weste_theatre1 weste_theatre2 weste_traffic weste_visual if cte_pathway_uni == 1




