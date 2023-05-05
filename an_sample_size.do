cap log close
clear all
set more off

use "W:\WA CTE SPED teachers\Data\cleaned_data"

//Check number of students that have taken a CTE course 
gen cte_course = 1 if (ctecipcode >= 10000 & ctecipcode != .) 

egen any_cte = max(cte_course), by(student_id syear)

duplicates drop student_id syear, force

tab syear grade_from_enroll if any_cte == 1

//Check the number of teachers that have taught a CTE course 
gen cte_course = 1 if (ctecipcode >= 10000 & ctecipcode != .) 

keep if cte_course == 1 

codebook certificationnumber2 if certificationnumber1 == "" 

drop if certificationnumber1 == "" 

codebook certificationnumber1

keep syear certificationnumber1 certificationnumber2 certificationnumber3 certificationnumber4 certificationnumber5 certificationnumber6 certificationnumber7 certificationnumber8 certificationnumber9 certificationnumber10 certificationnumber11 certificationnumber12 certificationnumber13 certificationnumber14 certificationnumber15 

/*/Egen unique id for each variables
egen class = group (syear codistid school_id locationid term sectionid courseid)

//Drop missing variables 
drop if class == . 

//Counting var within class 
bysort class : gen count = _n
*/

//reshape 
gen count = _n

reshape long certificationnumber, i(count) j(teachnum)

codebook certificationnumber 





