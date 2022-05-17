********************************************************************************************
*** All-cause graft failure
********************************************************************************************
// Read in data
use "data/dataextraction.dta", clear

// Format variables
destring, replace

// Cannot add estimates without a confidence interval to plot so we create a small one for plotting only
replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if (Outcome != "All-cause graft failure")
replace Model_type = "D&V" if Model_type == "Development and validation"
replace Model_type = "V" if Model_type != "Development and validation"
replace measure = "T-D AUC" if measure == "Time-dependent AUC"

// Declare as meta analysis data
meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-1)

*Forest plot
meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Pred_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(ModelNo, title("Model" "number")) columnopts(measure, title("Discrimination" "measure")) xlabel(0.4 0.5  0.6 0.7 0.8 0.9 1.0) markeropts(msize("medsmall"))


********************************************************************************************
***All-cause mortality
********************************************************************************************
use "data/dataextraction.dta", clear

destring, replace

replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if (Outcome != "All-cause mortality")
replace Model_type = "D&V" if Model_type == "Development and validation"
replace measure = "T-D AUC" if measure == "Time-dependent AUC"

meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-2)

meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Pred_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(ModelNo, title("Model" "number")) columnopts(measure, title("Discrimination" "measure")) xlabel(0.4 0.5  0.6 0.7 0.8 0.9 1.0) markeropts(msize("medsmall"))


********************************************************************************************
***Death-censored graft failure
********************************************************************************************
use "data/dataextraction.dta", clear

destring, replace

replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if Outcome != "Death-censored graft failure" 
replace Model_type = "D&V" if Model_type == "Development and validation"
replace measure = "T-D AUC" if measure == "Time-dependent AUC"

meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-2)

*Forest plot
meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Pred_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(ModelNo, title("Model" "number")) columnopts(measure, title("Discrimination" "measure")) xlabel(0.4 0.5  0.6 0.7 0.8 0.9 1.0) markeropts(msize("medsmall"))
