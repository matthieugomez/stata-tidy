program define gather
syntax varlist[, variable(string) value(string) label(string)]

if "`variable'"==""{
	local variable variable
}
if "`value'"==""{
	local value value
}

ds ____*
if "`r(varlist)'"{
	display as error "Please rename variables staring with ____ first" 
	exit 4
}

local i = 0
ds `varlist', not
local ivar `r(varlist)'
local names ""
foreach v of varlist `varlist'{
	local i = `i'+1
	local l`i' : variable label `v'
	rename `v' ____`i'
}

cap reshape long ____, i(`ivar') j(`variable') string
if _rc~=0{
	local i = 0
	foreach v of varlist `varlist'{
		local i = `i'+1
		rename ____`i' `v'
	}
}
else{
	rename v_ `value'
	tokenize `varlist'
	local i = 0
	if "`label'"~=""{
		gen `label'=""
		order `ivar' `variable' `label' `value'
		local i = 0
		foreach name in `varlist'{
			local i = `i'+1
			replace `label' = "`l`i''" if `variable' == "`i'"
		}
	}
	local i =0
	foreach name in `varlist'{
		local i = `i'+1
		replace `variable' = "``i''" if `variable' == "`i'"
	}
}
end




