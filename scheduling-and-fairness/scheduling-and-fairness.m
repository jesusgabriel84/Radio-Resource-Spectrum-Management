%% Setting variables
%We have the following peak rates:
r1=1;
r2=2;
r3=2;

%Number of users:
N = 3;

%Considering the vector of 51 elements for alpha:
alpha=0:50;

%% Max-min fair scheduling
%Calculating the values for the fraction of time for every user:
phi_UE1=(r1.^((1./alpha)-1))./(r1.^((1./alpha)-1)+r2.^((1./alpha)-1)+r3.^((1./alpha)-1));
phi_UE2=(r2.^((1./alpha)-1))./(r1.^((1./alpha)-1)+r2.^((1./alpha)-1)+r3.^((1./alpha)-1));
phi_UE3=(r3.^((1./alpha)-1))./(r1.^((1./alpha)-1)+r2.^((1./alpha)-1)+r3.^((1./alpha)-1));

%Since the phi with alpha=0 is infinite, we set the first element 
%(index = 1) to a 'big' value in the 'y' axis:
phi_UE2(1)=0.5; 
phi_UE3(1)=0.5;

%Now we calculate the value of the average throughput as a function of
%alpha:
avg_throughput_UE1=r1*phi_UE1;
avg_throughput_UE2=r2*phi_UE2;
avg_throughput_UE3=r3*phi_UE3;

%Now we calculate the value of the aggregate throughput in the cell as a
%function of alpha:
agg_throughput_cell=avg_throughput_UE1+avg_throughput_UE2+avg_throughput_UE3;


%% Proportional fair scheduling
%In this approach the value of phi is constant and is the same for every 
%UE:
phi_PF=(1/N)*ones(1,51);

%Now we calculate the value of the average throughput for each user, in
%this case it is independent from alpha:
avg_throughput_PF_UE1=r1*phi_PF;
avg_throughput_PF_UE2=r2*phi_PF;
avg_throughput_PF_UE3=r3*phi_PF;

%Now we calculate the value of the aggregate throughput in the cell, in
%this case it is independent from alpha:
agg_throughput_cell_PF=avg_throughput_PF_UE1+avg_throughput_PF_UE2+avg_throughput_PF_UE3;

%% Nash Bargaining scheduling
%In this approach the value of phi does not depend on alpha, then from the
%calculations obtained in the exercise we have:
phi_NB_UE1=0.4166*ones(1,51);
phi_NB_UE2=0.29166*ones(1,51);
phi_NB_UE3=0.29166*ones(1,51);

%Now we calculate the value of the average throughput for each user, in
%this case it is independent from alpha:
avg_throughput_NB_UE1=r1*phi_NB_UE1;
avg_throughput_NB_UE2=r2*phi_NB_UE2;
avg_throughput_NB_UE3=r3*phi_NB_UE3;

%Now we calculate the value of the aggregate throughput in the cell, in
%this case it is independent from alpha:
agg_throughput_cell_NB=avg_throughput_NB_UE1+avg_throughput_NB_UE2+avg_throughput_NB_UE3;


%% Plotting the values

%The figure 4 contains the plots of phi from each UE for the max-min,
%proportional fair and Nash Bargaining scheduling apporaches:
figure(1)
hold on
grid on
plot(alpha,phi_UE1, 'b');
plot(alpha,phi_UE2,'g');
plot(alpha,phi_UE3,'r*');
plot(alpha,phi_PF,'k','LineWidth',1.25);
plot(alpha,phi_NB_UE1,'ko');
plot(alpha,phi_NB_UE2,'k+');
hold off
title('Allocated fraction of time (phi)');
legend('UE1(max-min)','UE2(max-min)','UE3(max-min)','PF','UE1(NB)','UE2(NB) and UE3(NB)');
xlabel('Alpha');
ylabel('Allocated time fraction per user');

%The figure 2 contains the plots of the average throughput from each UE for
%the max-min, proportional fair and Nash Bargaining scheduling approaches:
figure(2)
hold on
grid on
plot(alpha,avg_throughput_UE1, 'b');
plot(alpha,avg_throughput_UE2,'g');
plot(alpha,avg_throughput_UE3,'r*');
plot(alpha,avg_throughput_PF_UE1,'k','LineWidth',1.25);
plot(alpha,avg_throughput_PF_UE2,'k--','LineWidth',1.25);
plot(alpha,avg_throughput_NB_UE1,'ko');
plot(alpha,avg_throughput_NB_UE2,'k+');
hold off
title('Mean Throughput of each user (Mbps)');
legend('UE1(max-min)','UE2(max-min)','UE3(max-min)','UE1(PF)','UE2(PF) and UE3(PF)','UE1(NB)','UE2(NB) and UE3(NB)');
xlabel('Alpha');
ylabel('Mean Throughput of each user (Mbps)');

%The figure 3 contains the plots of the aggregate throughput in the cell for
%the max-min, proportional fair and Nash Bargaining scheduling approaches:
figure(3)
hold on
grid on
plot(alpha,agg_throughput_cell, 'b','LineWidth',2);
plot(alpha,agg_throughput_cell_PF,'g','LineWidth',2);
plot(alpha,agg_throughput_cell_NB,'r','LineWidth',2);
hold off
title('Aggregate Throughput in the cell (Mbps)');
legend('Max-Min','Proportional Fair','Nash Bargaining');
xlabel('Alpha');
ylabel('Aggregate Throughput in the cell (Mbps)');
