
%Set path -----------------------------------------------------------------
filepath = '/Users/jamesryan/Box Sync/PhD/Fiber_Photometry/FP_2019';  %Where the tank is
tank = '100719_Sachin_BLA_PL_day1'; %Name of the tank
blk = 'FP166'; %Name of the animal
name = 'LMag'; %Channel set to extract from
filename = strcat(tank,'_',blk); %Data file names

%Extract data from data tank ----------------------------------------------
S = TDT_Import_mod(filepath, tank, blk, name, filename);

%Extract GCaMP signal using channel 3 as reference
Signal = S.data; 
row_idx = (Signal(:,3) < 1);  %pulse time locked to test session on- and offset
GCaMP = Signal(row_idx, 1);  %Extracted GCaMP signal
l = length(GCaMP); %length of the GCaMP signal

%Calculate dF/F -----------------------------------------------------------
%relative change instead of raw value
%detrended with rolling window median (Xs before [window] and Ys after [wall])
unit = l/1800;
dFF = [];
window = 40*unit;
wall = 40*unit;
for j = 1:1:l %one:one;L
    if j < ceil(window)
        F = median(GCaMP(1:j+floor(wall))); 
        dF = (GCaMP(j) - F);
        dFF(j) = double(dF*100/F);  
    elseif j>l-ceil(window)
        F = median(GCaMP(j-floor(window):end)); 
        dF = (GCaMP(j) - F);
        dFF(j) = double(dF*100/F);  
    else
        F = median(GCaMP(j-floor(window):j+floor(wall))); 
        dF = (GCaMP(j) - F);
        dFF(j) = double(dF*100/F);  
    end
end


mean_for_z = mean(dFF);
std_for_z = std(dFF);
z_score = (dFF-mean_for_z)/std_for_z;
dFF = z_score;



%Compiling individual mouse and trial data into comprehensive excel file
filename = blk;
rangePre=(floor(5*unit));
rangePost=(floor(12*unit));
cue1 = dFF(floor(600*unit)-rangePre:floor(600*unit)+rangePost); 
cue2 = dFF(floor(630*unit)-rangePre:floor(630*unit)+rangePost); 
cue3 = dFF(floor(650*unit)-rangePre:floor(650*unit)+rangePost); 
cue4 = dFF(floor(680*unit)-rangePre:floor(680*unit)+rangePost); 
cue5 = dFF(floor(690*unit)-rangePre:floor(690*unit)+rangePost); 
cue6 = dFF(floor(710*unit)-rangePre:floor(710*unit)+rangePost); 
cue7 = dFF(floor(740*unit)-rangePre:floor(740*unit)+rangePost); 
cue8 = dFF(floor(770*unit)-rangePre:floor(770*unit)+rangePost); 
cue9 = dFF(floor(810*unit)-rangePre:floor(810*unit)+rangePost); 
cue10 = dFF(floor(840*unit)-rangePre:floor(840*unit)+rangePost); 
cue11 = dFF(floor(850*unit)-rangePre:floor(850*unit)+rangePost); 
cue12 = dFF(floor(860*unit)-rangePre:floor(860*unit)+rangePost); 
cue13 = dFF(floor(900*unit)-rangePre:floor(900*unit)+rangePost); 
cue14 = dFF(floor(950*unit)-rangePre:floor(950*unit)+rangePost); 
cue15 = dFF(floor(1000*unit)-rangePre:floor(1000*unit)+rangePost); 
cue16 = dFF(floor(1020*unit)-rangePre:floor(1020*unit)+rangePost); 
cue17 = dFF(floor(1060*unit)-rangePre:floor(1060*unit)+rangePost); 
cue18 = dFF(floor(1110*unit)-rangePre:floor(1110*unit)+rangePost); 
cue19 = dFF(floor(1130*unit)-rangePre:floor(1130*unit)+rangePost); 
cue20 = dFF(floor(1170*unit)-rangePre:floor(1170*unit)+rangePost); 
datafile = table(cue1',cue2',cue3',cue4',cue5',cue6',cue7',cue8',cue9',cue10',cue11',cue12',cue13',cue14',cue15',cue16',cue17',cue18',cue19',cue20');
writetable(datafile, strcat('FP166_sachin_day1_10sec_zscored','.txt'));
cueAvg = ((cue1+cue2+cue3+cue4+cue5+cue6+cue7+cue8+cue9+cue10+cue11+cue12+cue13+cue14+cue15+cue16+cue17+cue18+cue19+cue20)/20);
cueError = std(cueAvg);
figure; hold on
TimeAxis = linspace(-5,12,length(cueAvg));
plot(TimeAxis, cueAvg, 'LineWidth',1.25)
A = fill([TimeAxis fliplr(TimeAxis)],[cueAvg+cueError fliplr(cueAvg-cueError)],'b','edgecolor','none'); %Fill SEM
set(A,'facealpha',0.15);  
y = get(gca, 'YLim'); 
plot([0,0], [y(1),y(2)],'k--') 
plot([2,2], [y(1),y(2)],'k--')