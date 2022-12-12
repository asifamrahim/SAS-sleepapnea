libname proj1"C:\Users\asifa\OneDrive\Desktop\BS723\project";
run;
proc format;
value femalef 0='male' 1='female';
value racef 1='African American' 2='caucasian' 3='Other';
value AHIf 1='AHI<5' 2='5<=AHI<15' 3='15<=AHI<30' 4='AHI>=30';
value smokingf 0='non-smoker' 1='smoker';
value diabetesf 0='no' 1='yes';
value hyperf 0='no' 1='yes';
value CADf 0='no' 1='yes';
value preop_antihyper_medf 0='no' 1='yes';
value CPAPf 0='no' 1='yes';
value intraop_antihyper_medf 0='no' 1='yes';
value vasopressorf 0='no'1='yes';
value ephedrinef 0='no' 1='yes';
value epinephrinef 0='no' 1='yes';
value phenylephrinef 0='no'1='yes';
run;
data proj1.hypoxia_new;
set proj1.hypoxia;
length sleeptime_cat $13;
if sleeptime=. then sleeptime_cat=.;
else if sleeptime >=8then sleeptime_cat="normal";
else if sleeptime<8 then sleeptime_cat="low";
length map_cat $20;
if TWA_MAP=. then map_cat=.;
else if TWA_MAP >=70then map_cat="not hypoxic";
else if TWA_MAP<70 then map_cat="hypoxic";
length type_surg_new  $30;
if Type_Surg=1 then type_surg_new= 'gastroenterostomy';
else if Type_Surg in (2,3,4) then type_surg_new= 'other procedure' ;
format Female femalef. Race racef. 
AHI AHIf. Smoking smokingf.
Diabetes diabetesf. Hyper hyperf.
CAD CADf. Preop_AntiHyper_Med preop_antihyper_medf.
CPAP CPAPf. Intraop_AntiHyper_Med intraop_antihyper_medf.
Vasopressor vasopressorf. Ephedrine ephedrinef.
Epinephrine epinephrinef. Phenylephrine phenylephrinef.;
label AHI="apnea/hypopnea index"
 MAC="minimum alveolar concentration"
hyper="is the patient currently hypertensive"
CAD="does the patient currently have coronary artery disease"
CPAP="does the patient use continous positive airway pressure therapy?"
sleeptime_cat="is the sleep time normal or low"
map_cat="mean arterial pressure hypoxic or not hypoxic"
type_surg_new="is the surgery gastroenterostomy or other procedure";
run;
proc means data=proj1.hypoxia_new;
var Age BMI Duration_of_surg;
run;
proc freq data=proj1.hypoxia_new;
tables Female Race AHI smoking Diabetes Hyper Preop_AntiHyper_Med CAD CPAP Type_Surg_new;
run;
title 'Two Sample T-Test';
proc ttest data=proj1.hypoxia_new;
class sleeptime_cat; 
var age;
run;


proc sort data=proj1.hypoxia_new;
by descending female; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables female*sleeptime_cat / chisq;
run;

proc freq data=proj1.hypoxia_new;
tables Race*sleeptime_cat / chisq fisher;
run;

title 'Two Sample T-Test';
proc ttest data=proj1.hypoxia_new;
class sleeptime_cat; 
var BMI;
run;


proc freq data=proj1.hypoxia_new;
tables AHI*sleeptime_cat /missing chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending smoking; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables smoking*sleeptime_cat / chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending diabetes; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables diabetes*sleeptime_cat / chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending hyper; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables hyper*sleeptime_cat / chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending CAD; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables CAD*sleeptime_cat / chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending Preop_AntiHyper_Med; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables Preop_AntiHyper_Med*sleeptime_cat / chisq;
run;

proc sort data=proj1.hypoxia_new;
by descending CPAP; 
run;
proc freq data=proj1.hypoxia_new order=data;
tables CPAP*sleeptime_cat / chisq;
run;
proc freq data=proj1.hypoxia_new;
tables Type_surg_new*sleeptime_cat / chisq;
run;
title 'Two Sample T-Test';
proc ttest data=proj1.hypoxia_new;
class sleeptime_cat; 
var duration_of_surg;
run;
options nofmterr;
libname proj2"C:\Users\asifa\OneDrive\Desktop\BS723\project 2";
run;
proc glm data=proj2.Hypoxia2;
class Female(ref='0') Smoking(ref='0') Hyper(ref='0') CPAP(ref='0') Sleeptime_cat(ref='normal');
model TWA_MAP=Sleeptime_cat Age Female BMI smoking hyper CPAP/solution CLPARM;
means Sleeptime_cat;
lsmeans sleeptime_cat/stderr;
run;
quit;
proc glm data=proj2.Hypoxia2;
	class Sleeptime_cat(ref='normal');
	model TWA_MAP=Sleeptime_cat/solution;
	means Sleeptime_cat;
run;quit;
proc logistic data=proj2.Hypoxia2 descending;
  class Sleeptime_cat (ref='normal') Smoking (ref='0') Female(ref='0') Hyper(ref='0') CPAP(ref='0')/param=ref;
  model MAP_Cat =Sleeptime_cat Age Female BMI Smoking Hyper CPAP; 
run;
proc glm data=proj2.Hypoxia2;
class Sleeptime_cat (ref='normal') Female(ref='0') Hyper(ref='0') CPAP(ref='0');
model TWA_MAP = age Female BMI hyper CPAP sleeptime_cat smoking/solution clparm;
by smoking;
run;quit;

proc glm data=proj2.Hypoxia2;
class Sleeptime_cat(ref='normal')Smoking (ref='0') Female(ref='0') Hyper(ref='0') CPAP(ref='0');
model TWA_MAP = age Female BMI hyper CPAP sleeptime_cat|smoking/solution CLPARM;
run;quit;

proc logistic data=proj2.Hypoxia2;
  class Sleeptime_cat (ref='normal') /param=ref;
  model Map_cat =Age Female BMI Hyper CPAP Sleeptime_cat Smoking;
  by Smoking;
run;quit;

proc logistic data=proj2.Hypoxia2;
  class Sleeptime_cat (ref='normal')Smoking (ref='0')/param=ref;
  model Map_cat =Age Female BMI Hyper CPAP Sleeptime_cat|Smoking;
run;quit;

