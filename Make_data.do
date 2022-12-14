// Set up
clear all

cd "s" //Original data
global out "" //Where saving
use "DATA/Analysis.dta", clear

**** Keeping only school id, pupil id, and pre and post questions
keep pupil_id a01 treat pre_q* post_q* pre_pp_b03

**** Basic cleaning to mark questions as either "got points" or "didn't"
foreach x of varlist pre_q1-pre_q30 post_q1-post_q37{
	replace `x' = 1 if `x' >0
	assert `x' == 0 | `x' == 1
}

save "$out/IRT_demo_data.dta", replace //Saving
