clear all

cd "" //CD of the downloaded repo here

use "Data/IRT_demo_data.dta", clear



***** First IRT -- basic run ********
** Running 2pl model on all questions
irt 2pl pre_q1-pre_q30
matrix est_1 = r(table)

estat report, byparm sort(b)
irtgraph icc pre_q27, blocation ylabel(0 0.09 0.545 1)
irtgraph icc pre_q17, blocation ylabel(0 0.09 0.545 1)
irtgraph tcc, thetalines(-1.96 0 1.96)

***** Second IRT -- constraining post-test parameters to be the same as pre-test

** Storing the parameters in locals
local y = 2
local i = 1
foreach x of varlist pre_q1-pre_q30{
	local q_`i'_disc = est_1[1,`i']
	local q_`y'_diff = est_1[1,`y']
	local constraints "`constraints' (2pl `x', cns(a@`q_`i'_disc' b@`q_`y'_diff'))"
	local y = `y' + 2
	local i = `i' + 2
}
predict theta_w, latent
di "`constraints'"

** Running full IRT model with constraints from only-written model
irt ///
	`constraints' ///
    (2pl post_q31-post_q37) 
estat report, byparm sort(b)


****** Third IRT -- running on subgroups
irt 2pl pre_q1-pre_q30, group(pre_pp_b03)


