
%%% Taxsim32 Integration for Matlab using taxsim32.ado

% This file allows to prepare Taxsim32 input data in Matlab and obtain imputed
% tax information using a simple function call to taxsim32_stata.m. Requires Stata.

% Written and tested on MacOS (10.15.7 Catalina), Matlab R2019b, Stata SE 14.0
% Maintained here: https://github.com/jo-fleck/Matlab_Taxsim32_Stata
% Copyright (C) 2020 Johannes Fleck; www.jofleck.com // Johannes.Fleck@eui.eu


%% Structure

% 1. Instructions
% 2. Function Definition: taxsim32_stata
% 3. Example


%% 1. Instructions

% To configure taxsim32_stata.m, proceed as follows

% 1) Open Stata, install taxsim32.ado and test it
% Instructions here: https://users.nber.org/~taxsim/taxsim32/stata-remote.html

% 2) Adjust the Matlab system command to work on your machine (see lines 49 and 50)
% Mac: make sure the Stata executable is added to your PATH
% PC: point the command to the Stata exe file (I guess...)


%% 2. Function Definition: taxsim32_stata

function [tbl_out] = taxsim32_stata(dir, tbl_in) % (version: 1.0.0)

writetable(tbl_in, strcat(dir,'taxsim32_input.csv'));

tmp_do_file = ["clear all", strcat("cd ", dir), strcat("import delimited using ", dir, "taxsim32_input.csv"), "taxsim32, full", strcat("use ", dir, "taxsim_out.dta, clear"), strcat("export delimited ", dir, "taxsim32_output.csv, replace")];
fileID = fopen(strcat(dir,"tmp_do_file.do"),'w' );
for i = 1:length(tmp_do_file)
    fprintf(fileID, strcat(tmp_do_file(i), " \n"));
end
fclose(fileID);

% Create and issue system command
setenv('PATH', '/Applications/Stata/StataSE.app/Contents/MacOS:/usr/local/bin:/usr/bin:');
command_taxsim32_do = strcat('stata-se -b do', " ", convertStringsToChars(dir),'tmp_do_file.do');
system(command_taxsim32_do);

tbl_out = readtable(strcat(dir, "taxsim32_output.csv")); % import Taxsim32 output

% Avoid cluttering: Remove tmp_do_file, csvs and files created by taxsim32.ado
cd(dir)
delete tmp_do_file.do taxsim32_input.csv taxsim32_output.csv taxsim_out.dta txpydata.raw results.raw tmp_do_file.log

end


%% 3. Example

% Save code in 2. as taxsim32_stata.m (or download from https://github.com/jo-fleck/Matlab_Taxsim32_Stata)
% and add the file to your Matlab path

% Taxsim32 input: table with columns as required by taxsim32.ado (order, names)
year = 1970; mstat = 2; ltcg = 100000;
tbl_taxsim32_input_example = table(year,mstat,ltcg);

% Set directory (all generated files will be deleted after use)
dir_example = "/Users/main/Downloads/";

tbl_taxsim32_output_example = taxsim32_stata(dir_example, tbl_taxsim32_input_example);
