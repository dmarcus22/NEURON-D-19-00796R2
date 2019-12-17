
clc
clear all
%% Get data
current=uigetdir('/Users/patellab/Desktop');
cd (current)
fileName=uigetfile('mouse1recall.xlsx'); %%write File name
[DataBase.Num DataBase.Txt] = xlsread(fileName);
DataBase.cell=DataBase.Txt(1,2:end);%get cell ids
DataBase.status=DataBase.Txt(2,2:end);%get cell accept/reject status
DataBase.values=DataBase.Num(1:end,2:end); %%get deltaFoverFvalues for all cells

%% accepted cells filter
for m=1:size(DataBase.status,2)
    
if DataBase.status{1,m}==' accepted'
    accepted(1,m)=1
else 
    accepted(1,m)=0
end
end
accepted=logical(accepted);
deltaFoverF=DataBase.values;

%%
deltaFoverF=deltaFoverF(:,accepted); %%coment/uncomment for accepted cells filter


%% Construct matrix around events from flag file around event of interest
%%construct tone matrix for each cell around event plus minus 15 s 
%CS- 59.8 149.8 399.6 499.6
%CS+ 224.6 309.6 599.4 709.5
EventOnset= [23.9,43.9,70.9,102.9,115.9,141.9,163.9,222.9,233.9,280.9,311.9]*10; %list events (either manually or from flag file; 1 decimal figure only)
EventOnset2=[23.9,43.9,70.9,102.9,115.9,141.9,163.9,222.9,233.9,280.9,311.9,341.9,349.9,382.9,413.9,449.9,465.9,492.9,540.9,564.9]*10;
EventOnset=EventOnset; 
EventOnset2=EventOnset2-11;
%60 150 399.8 499.7
%224.9 309.9 599.7 709.6
for tone=1:size(EventOnset,2);
    initial=(EventOnset(1,tone)-99);
    last=(EventOnset(1,tone)+100);

    Tone{tone}= [deltaFoverF(initial:last,1:size(deltaFoverF,2))];
end
 %For event 2
 
for tone2=1:size(EventOnset2,2);
    initial=(EventOnset2(1,tone2)-99);
    last=(EventOnset2(1,tone2)+100);

    Tone2{tone2}= [deltaFoverF(initial:last,1:size(deltaFoverF,2))];
end


%%Bin Data into selected bin size

%%
%Build matrix called Binned of values at 1 second precision from 0.1second precision matrix

%EnterVector length to bin in module multiple of 10
VectorLength=(size(Tone{1},1))/10;


%For reference:
%rows  = size(X,1)
%cols  = size(X,2)
%pages = size(X,3)


rr=1;
i=1;
j=1;


for tone=1:size(EventOnset,2);
   for i =1:size(deltaFoverF,2); %% build columns
    for j = 1:VectorLength; %build rows; bin 1 column at a time
        rr=j*10;
        A=Tone{tone}(rr-9:rr,i);
            Binned{tone}(j,i)= mean(A);
         
            
    end
  
   end
end
            
         
for tone2=1:size(EventOnset2,2);
   for i =1:size(deltaFoverF,2); %% build columns
    for j = 1:VectorLength; %build rows; bin 1 column at a time
        rr=j*10;
        A=Tone2{tone2}(rr-9:rr,i);
            Binned2{tone2}(j,i)= mean(A);
         
            
    end
  
   end
end




%% blocks of n for tones (n=nuber of events)
   
n=length(EventOnset); %number of events
     
temporary= sum(cat(3,Binned{:}),3);
Block=temporary/n;
   
 % blocks of n for tones (n=number of events)
   
n=length(EventOnset2); %number of events
     
   temporary2= sum(cat(3,Binned2{:}),3);
    Block2=temporary2/n;    
       
   
    

%% zScore the data with pretone as baseline; Fix this
%creates cell array with Zscores for all cells for each block of 2 

for ii=1:(length(EventOnset)/2);
    D=Block(1:10,1:end)
    x=mean(D,1);
    r=Block(1:end,1);
    dim=size(r,1)
    X=ones([dim,1])*x ;%create matrix of means same size as Block in order to substract means to each column element
    
    stdev=std(D,0,1);
    StDev=ones([dim,1])*stdev;
    delta=(Block-X);
    Z=delta./StDev; % create cell array with block of 2 as upper category and zScores x cells as other 2 dimensions 
    
end


for ii=1:(length(EventOnset)/2);
    D2=Block2(1:10,1:end)
    x2=mean(D2,1);
    r2=Block2(1:end,1);
    dim2=size(r2,1)
    X2=ones([dim2,1])*x2 ;%create matrix of means same size as Block in order to substract means to each column element
    
    stdev2=std(D2,0,1);
    StDev2=ones([dim2,1])*stdev2;
    delta2=(Block2-X2);
    Z2=delta2./StDev2; % create cell array with block of 2 as upper category and zScores x cells as other 2 dimensions 
    
end

%% To plot(X,Y)
% Use plot(1:30,Z(1:end,'the cell of interest'))
%%Example

% plot(1:30,Z(1:end,"the cell),'r')
%hold on
%plot(1:30,Z(1:end,"cell"),'b')
%plot(1:30,Z(1:end,"cell"),'m')

%hold off


