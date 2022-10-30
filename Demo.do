clear all

cd "/Users/jackcavanagh/Documents/Coding_lunch/IRT_demo"

use "Data/IRT_demo_data.dta", clear



***** First IRT -- basic run ********
** Running 3pl model on all questions
irt 2pl pre_q1-pre_q30

estat report, byparm sort(b)
irtgraph icc pre_q27, blocation ylabel(0 0.09 0.545 1)
irtgraph icc pre_q17, blocation ylabel(0 0.09 0.545 1)
irtgraph tcc, thetalines(-1.96 0 1.96)
predict theta, latent

***** Second IRT -- constraining post-test parameters to be the same as pre-test

** Storing the parameters in locals
matrix est_1 = r(table)
local y = 2
local i = 1
foreach x of varlist pre_q1-pre_q30{
	local q_`i'_disc = est_1[1,`i']
	local q_`y'_diff = est_1[1,`y']
	local constraints "`constraints' (3pl `x', cns(a@`q_`i'_disc' b@`q_`y'_diff'))"
	local y = `y' + 2
	local i = `i' + 2
}
predict theta_w, latent

** Running full IRT model with constraints from only-written model
irt ///
	`constraints' ///
    (3pl pre_q1-post_q37) 
estat report, byparm sort(b)
irtgraph icc q7, blocation ylabel(0 0.09 0.545 1)
irtgraph tcc, thetalines(-1.96 0 1.96)
predict theta, latent


*** Standardizing
foreach var in theta_w theta theta_LOTS theta_HOTS {
qui: summ `var' if T == 0 & baseline == 1 & Written_test_attendance == 1
gen `var'_sd = (`var' - `r(mean)')/ `r(sd)'
}



