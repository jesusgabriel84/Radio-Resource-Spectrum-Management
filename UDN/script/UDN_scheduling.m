clear all; close all; clc;
%% define the number of ANds, and their position
ANdPos = [132 50 7; 144 100 7; 132 150 7; 144 200 7; 132 250 7; 144 300 7; 132 350 7; 144 400 7; 132 450 7; 144 500 7;... % Y axis streets
            283 50 7; 283 100 7; 283 150 7; 283 200 7; 283 250 7; 283 300 7; 283 350 7; 283 400 7; 283 450 7; 283 500 7;...
            337 48 7; 337 113 7; 337 178 7; 337 243 7; 337 308 7; 337 373 7; 337 438 7; 337 502 7;...
            49 144 7; 89 132 7; 187 144 7; 227 132 7; 325 144 7;...% 312 144 1; 363 132 1;... % X axis streets
            49 271 7; 89 283 7; 187 271 7; 227 283 7; 325 271 7;...% 312 271 1; 363 283 1;...
            49 420 7; 89 408 7; 187 420 7; 227 408 7; 325 420 7;...%; 312 420 1; 363 408 1];
             182 350 7;232 350 7;];
nANd = length(ANdPos);
figure;
for pp = 1:nANd
plot(ANdPos(:,1),ANdPos(:,2),'b','Marker','diamond','LineStyle','none');
end
%% load the values of  UE location and corresponding RSS every 2m in the grid
load UNdPos;
load RSSdB;
%% select randomly 200  UEs and their corresponding RSS from each ANd
%%UNd_Seq=randperm(length(UNdPos),200);%randperm(a,b) returns b unique integers selected randomly from 1 to a inclusive
UNd_Seq_o = randperm(length(UNdPos));%randperm(b) returns b unique integers in random fashion
UNd_Seq = UNd_Seq_o(1:200);%%% assume we have 200 users
UNdPos_new = UNdPos(UNd_Seq,:);
nUNd = size(UNdPos_new,1);
RSSdB_new = RSSdB(UNd_Seq,:);
RSSlin_new = 10.^(RSSdB_new./10);
%% plot UE location on map
hold on;
for pp = 1:nUNd
plot(UNdPos_new(:,1),UNdPos_new(:,2),'r','Marker','*','LineStyle','none');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% If, you are using windows operating system, uncomment the below line to load the map of madrid grid
map = madrid_3Dgrid();
%% User association with ANds based on RSS
[Ma,Ua] = max(RSSdB_new'); %Ma is max value and Ua is the index of UNd with max RSSdB
assoc = [1:nUNd;Ua]';

for i = 1:nANd
    A_temp = find(assoc(:,2)==i)';
ANd_UNd_Assoc(i,1:length(A_temp)) = A_temp;
end


%% Load BALANCING

% The first task in the simulation was to limit the number of time slots in 
% to 10 in each base station. In order to perform this load balancing, 
% I have performed the following tasks:
% 
% 1)	Find the base stations serving more than 10 users.
% 2)	Find the RSSI of all the users in each full BS.
% 3)	Sort ascending the RSSI for each user.
% 4)	Select the exact amount of users to be offloaded from the BS.
% 5)	Select the second best RSSI BS for the selected users.
% 6)	Validate if the destination BS has free time slots and the number 
%       of time slots is less than 10.
% 7)	Assign the UE to the free time slot in the destination BS.
% 8)	Repeat the process for every full BS.
% 
% After performing the previous steps, the resulting BS-UE association 
% variable is sorted descending to remove as many time slots as needed 
% according to the restriction that no more than 10 users must be served 
% by each BS simultaneously, then we can observe that the number of users 
% per base station is limited to 10.

% 1)	Find the base stations serving more than 10 users.
BS_full_idx=[];
for i=1:nANd
    if(nnz(ANd_UNd_Assoc(i,:))>10) 
        BS_full_idx=[BS_full_idx i]; 
    end
end

for i=BS_full_idx
    
    tmp_UEs=ANd_UNd_Assoc(i,:);
    tmp_UEs=tmp_UEs(tmp_UEs~=0); %check the UEs different than ID==0
    tmp_RSSI_UE=RSSdB_new(tmp_UEs,i);
    [~,index]=sort(tmp_RSSI_UE); %Sorting ascending
    tmp_UEs=tmp_UEs(index);
    tmp_UEs=tmp_UEs(1:length(tmp_UEs)-10);
    
    for j=tmp_UEs
        tmp_RSSI_UE2=RSSdB_new(j,:);
        [~,idx]=sort(tmp_RSSI_UE2,'descend'); %sort descending
        for jj=idx(2:end)
            tmp_index=nnz(ANd_UNd_Assoc(jj,:));
            if(tmp_index<10)
                ANd_UNd_Assoc(ANd_UNd_Assoc==j)=0;
                ANd_UNd_Assoc(jj,tmp_index+1)=j;
                break
            end
        end
    end
end


%After performing the previous steps, the resulting BS-UE association 
%variable is sorted descending to remove as many time slots as needed 
%according to the restriction that no more than 10 users must be served by 
%each BS simultaneously, then we can observe that the number of users per 
%base station is limited to 10

ANd_UNd_Assoc=sort(ANd_UNd_Assoc,2,'descend');
to_remove=size(ANd_UNd_Assoc,2)-10;
if(to_remove<0)
    ANd_UNd_Assoc=[ANd_UNd_Assoc zeros(nANd,abs(to_remove))];
else
    ANd_UNd_Assoc=ANd_UNd_Assoc(:,1:10);
end


%% Initialization for scheduling
Initial_Schedule = zeros(size(ANd_UNd_Assoc));%Initial_Schedule=zeros(size(ANd_UNd_Assoc,1),5+size(ANd_UNd_Assoc,2));
New_Schedule = Initial_Schedule;
k = size(New_Schedule,2);
DONE=0;cnt =0;


%% Scheduling of UNds using GADIA
while((~DONE))
    cnt = cnt + 1;
    UNdrandlist=randperm(nUNd);
for i = 1:length (UNdrandlist)
    
    [II,JJ] = find(ANd_UNd_Assoc==UNdrandlist(i));
    
    Sig_Pow(i) = RSSlin_new(UNdrandlist(i),II);
    
    if (cnt>1)
        New_Schedule(II,JJ)=0;
    end
 for iaa=1:k %% the number of potentially available TS
 
 if (New_Schedule(II,iaa)==0)
    
    for jaa = 1:size (New_Schedule,1)%the no of UNds potentially supposed to share a given TS
        
        if (New_Schedule(jaa,iaa)==0)
            Interf(jaa) = 0;
        else
            Interf(jaa)= RSSlin_new(New_Schedule(jaa,iaa),II);
        end
    end
    
    SIR(iaa) = Sig_Pow(i)/sum(Interf);
 else
    SIR (iaa) = -Inf;
 end
 
 end
    TS_with_max_sir = find(SIR==max(SIR));%find(SIR==max(SIR))returns a vector containing the indices of SIR == max(SIR)
    if(length(TS_with_max_sir)>1)
    %TSnew_with_max_sir=TS_with_max_sir(randperm(length(TS_with_max_sir),1)); %. If the minimizer is not unique, the scheduler randomly picks one
    temp = randperm(length(TS_with_max_sir));
    TSnew_with_max_sir = TS_with_max_sir(temp(1));%. If the minimizer is not unique, the scheduler randomly picks one
    else 
        TSnew_with_max_sir = TS_with_max_sir;
    end
    
    New_Schedule(II,TSnew_with_max_sir)= UNdrandlist(i); 
end

ANd_UNd_Assoc = New_Schedule;
     
if (nnz(New_Schedule - Initial_Schedule) == 0)
        DONE = 1;
else
        Initial_Schedule = New_Schedule;
end
end


%% Modify/fill the code to do load balancing
%% Fill the code to compute SIR of each UE  when UE transmitting to its associated ANd afer final scheduling
SIR_new=[];
for kk=1:nUNd
    [BS,channel]=find(ANd_UNd_Assoc==kk);
    numerator = RSSlin_new(kk,BS);
    %Obtaining in the vector denominator the UE id in the corresponding
    %channel that are not 0 and not considering the UE over which we want
    %to calculate the SIR.
    denominator=ANd_UNd_Assoc((ANd_UNd_Assoc(:,channel)~=0)&(ANd_UNd_Assoc(:,channel)~=kk),channel);
    denominator=sum(RSSlin_new(denominator,BS));
    SIR_new(kk)= numerator/denominator;
end

%Calculating the SIR in dB
SIR_new_dB=10*log10(SIR_new);

%%   Fill the code to compute capacity of each UE when it is transmitting to its associated ANd afer final scheduling
% The capacity of each channel is 200MHz:
capacity=2e8*log2(1+SIR_new);

%Sum of the capacity:
total_capacity=sum(capacity);

%% Plot the figures showing cdf of SIR, capacity of users after scheduling
figure
cdfplot(SIR_new_dB);


figure
cdfplot(capacity);
return;