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
