title1 'Grade Crime Correlation Analyis';
title2 'By Brendon Carroll';
title3 '5/30/2020';
title4 'The goal of this analysis is to find if there is a correlation between highschool GPA within a subject and the amount of crime in a given state.';
title5 'Link at the bottom of the print out for a more in-depth description of the variables listed below.';

%let path=/home/u38887774/my_courses/Brendon/HSPRG/rawData/;

data work.Crime;
	infile"&path/state_crime.csv" dsd missover;
	
	length State $ 25;
	/* variables starting with R_ signifies data is a rate, rates are per 100,000*/
	/* variables starting with T_ signifies data is a total*/
	
	input State $ Year Population R_Property_All R_Property_Burglary R_Property_Larceny R_Property_Motor R_Property_Violent_All R_Property_Violent_Assault R_Property_Violent_Murder R_Property_Violent_Rape R_Property_Violent_Robery T_Property_All T_Property_Burglary T_Property_Larceny T_Property_Motor T_Violent_All T_Violent_Assault T_Violent_Murder T_Violent_Rape T_Violent_Robbery;
	
	/* Deletes the first obs, it contains bad info*/
	if _N_ = 1 then delete;
	/* School grades data set starts at 2005*/
	if year GE 2005;

run;

data work.Grades;
	infile"&path/school_scores.csv" dsd missover;
	
	/* jesus what a long line of code */
	input Year State_Code $ State $ T_Math T_Testers T_Verbal Arts_AvgGpa Arts_AvgYears ELA_AvgGpa ELA_AvgYears Foreign_AvgGpa Foreign_AvgYears Math_AvgGpa Math_AvgYears Science_AvgGpa Science_AvgYears NaturalS_AvgGpa NaturalS_AvgYears SocialS_AvgGpa Socials_AvgYears FI_20_40_Math FI_20_40_Testers FI_20_40_Verbal FI_40_60_Math FI_40_60_Testers FI_40_60_Verbal FI_60_80_Math FI_60_80_Testers FI_60_80_Verbal FI_80_100_Math FI_80_100_Testers FI_80_100_Verbal FI_0_20_Math FI_0_20_Testers FI_0_20_Verbal FI_100plus_Math FI_100plus_Testers FI_100plus_Verbal GPA_A_minus_Math GPA_A_minus_Testers GPA_A_minus_Verbal GPA_A_plus_Math GPA_A_plus_Testers GPA_A_plus_Verbal GPA_A_Math GPA_A_Testers GPA_A_Verbal GPA_B_Math GPA_B_Testers GPA_B_Verbal GPA_C_Math GPA_C_Testers GPA_C_Verbal GPA_D_Lower_Math GPA_D_Lower_Testers GPA_D_Lower_Verbal GPA_NA_Math GPA_NA_Testers GPA_NA_Verbal Female_Math Female_Testers Female_Verbal Male_Math Male_Testers Male_Verbal Female_Math_200to300 Male_Math_200to300 Total_Math_200to300 Female_Verbal_200to300 Male_Verbal_200to300 Total_Verbal_200to300 Female_Math_300to400 Male_Math_300to400 Total_Math_300to400 Female_Verbal_300to400 Male_Verbal_300to400 Total_Verbal_300to400 Female_Math_400to500 Male_Math_400to500 Total_Math_400to500 Female_Verbal_400to500 Male_Verbal_400to500 Total_Verbal_400to500 Female_Math_500to600 Male_Math_500to600 Total_Math_500to600 Female_Verbal_500to600  Male_Verbal_500to600 Total_Verbal_500to600 Female_Math_600to700 Male_Math_600to700 Total_Math_600to700 Female_Verbal_600to700 Male_Verbal_600to700 Total_Verbal_600to700 Female_Math_700to800 Male_Math_700to800 Total_Math_700to800 Female_Verbal_700to800 Male_Verbal_700to800 Total_Verbal_700to800;
	
	/* Deletes the first obs, it contains bad info*/
	if _N_ = 1 then delete;
	
	
run;

/*must sort data by state inorder to merge by state */
proc sort data=work.Grades
		out = work.Grades;
		by State;
run;
proc sort data = work.Crime
		out = work.Crime;
		by State;
run;


/* 'ods exclude EngineHost' prevents proc contents from printing so much*/
ods exclude EngineHost;
proc contents data = work.Grades ;

run;
title;
ods exclude EngineHost;
proc contents data = work.Crime;

run;

/* Crime Grade is merged by state inorder to perform observations such as proc corr on both */
data work.CrimeGrade;
	
	merge work.Grades work.Crime;
	by State;
	
run;


/* Shows a negative correlation between math scores and reading scores with how much crime goes on */
ods graphics / imagemap=on;
title1 "Correlation Between GPA and Total Counts Of Crime In Illinois";
proc corr data=WORK.CRIMEGRADE pearson nosimple 
		plots=scatter(ellipse=none);
		where state = "Illinois";
	var ELA_AvgGpa Math_AvgGpa;
	with T_Property_All T_Violent_All T_Violent_Robbery;
run;
title;
ods graphics / reset width=6.4in height=4.8in imagemap;

title1 "Total Violent Crimes In Illinois from 2005-2012";
proc sgplot data=WORK.CRIMEGRADE;
	scatter x=Year y=T_Violent_All /;
	xaxis grid;
	yaxis grid;
	where state = "Illinois";
run;
title;
title1 "Average GPA within ELA Subjects In Illinois from 2005-2012";
proc sgplot data=WORK.CRIMEGRADE;
	scatter x=Year y=ELA_AvgGpa /;
	xaxis grid;
	yaxis grid;
	where state = "Illinois";
run;
title;

title1 "Correlation Between GPA and Total Counts Of Crime In North Carolina";
proc corr data=WORK.CRIMEGRADE pearson nosimple 
		plots=scatter(ellipse=none);
		where State_Code = "NC";
	var ELA_AvgGpa Math_AvgGpa;
	with T_Property_All T_Violent_All T_Violent_Robbery;
run;
title;

title1 "Total Violent Crimes In North Carolina from 2005-2012";
proc sgplot data=WORK.CRIMEGRADE;
	scatter x=Year y=T_Violent_All /;
	xaxis grid;
	yaxis grid;
	where State_Code = "NC";
run;
title;

title1 "Average GPA within ELA Subjects In North Carolina from 2005-2012";
footnote1 'CSV file sources:';
footnote2 'https://corgis-edu.github.io/corgis/csv/school_scores/';
footnote3 'https://corgis-edu.github.io/corgis/csv/state_crime/';
proc sgplot data=WORK.CRIMEGRADE;
	scatter x=Year y=ELA_AvgGpa /;
	xaxis grid;
	yaxis grid;
	where State_Code = "NC";
run;


ods graphics / reset;
footnote;
title;