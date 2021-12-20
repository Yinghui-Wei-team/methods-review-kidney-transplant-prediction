********************************************************************************************
*** All-cause graft failure
********************************************************************************************
// Read in data

import excel "data\data-extraction-rob-analysis.xlsx", sheet("DataExtrac") firstrow clear
save "data\data.dta", replace
// Format variables
destring, replace

// Cannot add estimates without a confidence interval to plot so we create a small one for plotting only
replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if Outcome != "All-cause graft failure"
replace Model_type = "D&V" if Model_type == "Development and validation"

// Declare as meta analysis data
meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-1)

*Forest plot
meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Model_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(measure, title("Discrimination" "measure")) columnopts(_plot, xsize(10)) xlabel(0.5 0.55 0.6 0.65 0.7 0.75)


********************************************************************************************
***All-cause mortality
********************************************************************************************
use "data\data.dta", clear

destring, replace

replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if Outcome != "All-cause mortality"
replace Model_type = "D&V" if Model_type == "Development and validation"

meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-2)

meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Model_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(measure, title("Discrimination" "measure")) xlabel(0.55 0.6 0.65 0.7 0.75 0.8)

********************************************************************************************
***Death-censored graft failure
********************************************************************************************
use "data\data.dta", clear

destring, replace

replace upperci = upperci + 0.0001 if upperci == est
replace lowerci = lowerci - 0.0001 if lowerci==est

drop if Outcome != "Death-censored graft failure"
replace Model_type = "D&V" if Model_type == "Development and validation"

meta set est lowerci upperci, studylabel(Author Year) eslabel("Discrimination") studysize(Used_sample_size) civartolerance(1e-2)

*Forest plot
meta forestplot _id ModelNo measure _plot _esci, nooverall subgroup(Model_type) nohrule noohet noohom noghet nogwhom nogbhom noomarker nonotes nogmarker columnopts(measure, title("Discrimination" "measure")) xlabel(0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85)


