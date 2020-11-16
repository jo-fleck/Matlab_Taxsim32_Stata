
# Connect Matlab to Taxsim32 via Stata

"You provide the data, the [NBER TAXSIM program](https://taxsim.nber.org) returns the tax calculations from our server in seconds."

`Matlab_Taxsim32_Stata.m` illustrates how to prepare Taxsim32 input data in Matlab and obtain imputed tax information using a simple function call to `taxsim32_stata.m`. Requires Stata. Written and tested on MacOS (10.15.7 Catalina), Matlab R2019b, Stata SE 14.0

## Instructions

To configure `taxsim32_stata.m`, proceed as follows

1. Open Stata, install `taxsim32.ado` and test it. Instructions here: https://users.nber.org/~taxsim/taxsim32/stata-remote.html

2. Adjust the Matlab system command to work on your machine (see `taxsim32_stata.m` lines 14 and 15)
- Mac: make sure the Stata executable is added to your PATH (see line 13)
- PC: point the command to the Stata exe file (I guess...)

## Example

```
% Add taxsim32_stata.m to your Matlab path

% Taxsim32 input: table with columns as required by taxsim32.ado (order, names)
year = 1970; mstat = 2; ltcg = 100000;
tbl_taxsim32_input_example = table(year,mstat,ltcg);

% Set directory (all generated files will be deleted after use)
dir_example = "/Users/main/Downloads/";

tbl_taxsim32_output_example = taxsim32_stata(dir_example, tbl_taxsim32_input_example);

```
