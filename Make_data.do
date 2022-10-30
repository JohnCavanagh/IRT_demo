// Set up
clear all

cd "/Users/jackcavanagh/Downloads/Replication_Data_Ed_Incentives" //Original data
global out "/Users/jackcavanagh/Documents/Coding_lunch/IRT_demo/Data" //Where saving
use "DATA/Analysis.dta", clear

**** Keeping only school id, pupil id, and pre and post questions
keep pupil_id a01 treat pre_q* post_q*

**** Basic cleaning to mark questions as either "got points" or "didn't"
foreach x of varlist pre_q1-post_q37{
	replace `x' = 1 if `x' >0
	assert `x' == 0 | `x' == 1
}

save "$out/IRT_demo_data.dta", replace //Saving
