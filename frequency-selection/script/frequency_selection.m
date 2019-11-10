%% INITIAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%
%
ymax900 = 1200; % It is the long leg of cell
coverage_1800 = 0.65 %Coverage percentage of 1800MHz cell
coverage_2100 = 0.45 %Coverage percentage of 2100MHz cell
coverage_2600 = 0.30 %Coverage percentage of 2600MHz cell
snapshots = 200; %Number of Monte Carlo repetitions
num_users = 75; %Number of UEs to be randomly assigned in each cell
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Simulation:
% Coverage area of Layer1800 is 65% of the coverage area of the Layer900. 
% Layer2100 is 45% of the coverage area of the Layer900. Layer2600 is 30% 
% of the coverage area of the Layer900.


%% Creating cells geometry
% 900MHz cells:
h900 = apothem(ymax900); %It is the apothem of the polygon

% 1800MHz cells:
ymax1800 = calculate_side(coverage_1800*calculate_area(ymax900)); % It is the long leg of cell
h1800 = apothem(ymax1800); %It is the apothem of the polygon

% 2100MHz cells:
ymax2100 = calculate_side(coverage_2100*calculate_area(ymax900)); % It is the long leg of cell
h2100 = apothem(ymax2100); %It is the apothem of the polygon

% 2600MHz cells:
ymax2600 = calculate_side(coverage_2600*calculate_area(ymax900)); % It is the long leg of cell
h2600 = apothem(ymax2600); %It is the apothem of the polygon


%% Calculating coordinates of the cells

%Coordinates of the 900MHz cells
Layer900_cell_center_x_cord = 0; 
Layer900_cell_center_y_cord = 0;
coord900 = calculate_coordinates(Layer900_cell_center_x_cord,Layer900_cell_center_y_cord,ymax900,h900);

%Coordinates of the 1800MHz cells
Layer1800_cell_center_x_cord = 0; 
Layer1800_cell_center_y_cord = Layer900_cell_center_y_cord-(ymax900-ymax1800);
coord1800 = calculate_coordinates(Layer1800_cell_center_x_cord,Layer1800_cell_center_y_cord,ymax1800,h1800);

%Coordinates of the 2100MHz cells
Layer2100_cell_center_x_cord = 0; 
Layer2100_cell_center_y_cord = Layer900_cell_center_y_cord-(ymax900-ymax2100);
coord2100 = calculate_coordinates(Layer2100_cell_center_x_cord,Layer2100_cell_center_y_cord,ymax2100,h2100);

%Coordinates of the 2600MHz cells
Layer2600_cell_center_x_cord = 0; 
Layer2600_cell_center_y_cord = Layer900_cell_center_y_cord-(ymax900-ymax2600);
coord2600 = calculate_coordinates(Layer2600_cell_center_x_cord,Layer2600_cell_center_y_cord,ymax2600,h2600);


%% Creating the grid:
% This are the dimensions of the whole grid:
xmin = -2078;xmax = 2078;
ymin = -3000;ymax = 1200;
grid_cells=[xmin xmax;ymin ymax];

% Now we define the multidimensional arrays that will contain the cells for
% each layer:
cell900=[{},{}];
cell1800=[{},{}];
cell2100=[{},{}];
cell2600=[{},{}];

for i = 1:3
    [Layer900_x,Layer900_y] = create_hex(ymax900,coord900(i,1),coord900(i,2));
    [Layer1800_x,Layer1800_y] = create_hex(ymax1800,coord1800(i,1),coord1800(i,2));
    [Layer2100_x,Layer2100_y] = create_hex(ymax2100,coord2100(i,1),coord2100(i,2));
    [Layer2600_x,Layer2600_y] = create_hex(ymax2600,coord2600(i,1),coord2600(i,2));
    cell900=[cell900;[{Layer900_x},{Layer900_y}]];
    cell1800=[cell1800;[{Layer1800_x},{Layer1800_y}]];
    cell2100=[cell2100;[{Layer2100_x},{Layer2100_y}]];
    cell2600=[cell2600;[{Layer2600_x},{Layer2600_y}]];
end


%% Calculating Montecarlo simulation:
% First obtain 75 random points inside each cell of the grid (totally there
% will be 225 UEs):
total_UE = [];

%In the ratio variables I will store the percentage of each layer. The
%convention I used is to store the percentage of each layer in the
%following columns of the variables (every row is a snapshot of the Monte
%Carlo simulation:
%
% column 1: percentage of the UEs in 900 MHz
% column 2: percentage of the UEs in 1800 MHz
% column 3: percentage of the UEs in 2100 MHz
% column 4: percentage of the UEs in 2600 MHz

ratio_1st = [];
ratio_2nd = [];

%Now we run the Monte Carlo simulation according to the quantity of snap
%shots:



for jj = 1:snapshots
    %Distribute randomly 75 UEs in each cell:
    UE_cell1 = random_points(cell900{1,1},cell900{1,2},grid_cells,num_users);
    UE_cell2 = random_points(cell900{2,1},cell900{2,2},grid_cells,num_users);
    UE_cell3 = random_points(cell900{3,1},cell900{3,2},grid_cells,num_users);
    
    %Determine in which coverage layer each UE (coordinates x,y) belongs
    %to:
    for j = 1:75
        total_UE = [total_UE;calculate_layer(UE_cell1(j,1),UE_cell1(j,2),cell900,cell1800,cell2100,cell2600)];
        total_UE = [total_UE;calculate_layer(UE_cell2(j,1),UE_cell2(j,2),cell900,cell1800,cell2100,cell2600)];
        total_UE = [total_UE;calculate_layer(UE_cell3(j,1),UE_cell3(j,2),cell900,cell1800,cell2100,cell2600)];
    end
    
    %Calulate the layer for each UE according to the selection strategy
    %defined in the exercise:
    results_first_strategy = first_strategy(total_UE);
    results_second_strategy = total_UE;
    
    %Now we calculate the ratio for each layer in every snapshot for both
    %selection strategies:
    ratio_1st = [ratio_1st;sum(results_first_strategy==900)/length(total_UE) ....
                 sum(results_first_strategy==1800)/length(total_UE) ....
                 sum(results_first_strategy==2100)/length(total_UE) ....
                 sum(results_first_strategy==2600)/length(total_UE)];

    ratio_2nd = [ratio_2nd;sum(results_second_strategy==900)/length(total_UE) ....
                 sum(results_second_strategy==1800)/length(total_UE) ....
                 sum(results_second_strategy==2100)/length(total_UE) ....
                 sum(results_second_strategy==2600)/length(total_UE)];
    
    %Now we clean up the total_UE variable for the next round of
    %simulation:
    total_UE = [];
end
%Finally we calculate the average of the 200 snapshots for each layer in
%both selection strategies:
ratio_1st_avg = [sum(ratio_1st(:,1)) sum(ratio_1st(:,2)) sum(ratio_1st(:,3)) sum(ratio_1st(:,4))]*100/length(ratio_1st);
ratio_2nd_avg = [sum(ratio_2nd(:,1)) sum(ratio_2nd(:,2)) sum(ratio_2nd(:,3)) sum(ratio_2nd(:,4))]*100/length(ratio_2nd);

% We create the table with de details:
T = table(['1st';'2nd'],[ratio_1st_avg(1,1);ratio_2nd_avg(1,1)],....
    [ratio_1st_avg(1,2);ratio_2nd_avg(1,2)],[ratio_1st_avg(1,3);....
    ratio_2nd_avg(1,3)],[ratio_1st_avg(1,4);ratio_2nd_avg(1,4)]);
T.Properties.VariableNames = {'Strategy','UE_900' 'UE_1800' 'UE_2100' 'UE_2600'};

% Finally we output the table with both strategies and the value (in
% percentage) of the users attached to each layer after the 200 snapshots 
% of the Monte Carlo simulation:
T

%% Plotting the grid:
figure(1)
hold on;
grid on;
for ii = 1:3
    plot(cell900{ii,1},cell900{ii,2},'k','LineWidth',2);
    plot(cell1800{ii,1},cell1800{ii,2},'g','LineWidth',2);
    plot(cell2100{ii,1},cell2100{ii,2},'r','LineWidth',2);
    plot(cell2600{ii,1},cell2600{ii,2},'b','LineWidth',2);
end
hold off;


%% Functions

%Function to create hexagon with side 'ymax' and centered in
%x=xcoord,y=ycoord
function [xdim,ydim] = create_hex(ymax,xcoord,ycoord)
    xmax = (sqrt(3)*ymax)/2; % It is the short leg of cell
    
    %Creating the six sides of the hexagon
    xdim = [xcoord xcoord+xmax xcoord+xmax ....
    xcoord xcoord-xmax xcoord-xmax];

    ydim = [ycoord+ymax ycoord+ymax*sind(30) ....
    ycoord-ymax*sind(30) ycoord-ymax ....
    ycoord-ymax*sind(30) ycoord+ymax*sind(30)];

    xdim = xdim';
    ydim = ydim';

    xdim = [xdim ;xdim(1)];
    ydim = [ydim ;ydim(1)] ;

end

%Calculate the side of the Hexagon based on the area:
function ymax = calculate_side(area)
    ymax=sqrt((2*area)/(3*sqrt(3)));
end

%Calculate area of the hexagon:
function area = calculate_area(ymax)
    area=(3*sqrt(3)*ymax^2)/2;
end

%Calculate the apothem of the hexagon:
function h = apothem(ymax)
    h=(ymax/2)*sqrt(3);
end

function coordinates = calculate_coordinates(center_x,center_y,ymax,h)
    
    %Creating the six neighbors of the cell centered in center_x,center_y:
    coordinates = [center_x center_y; center_x-h center_y-1.5*ymax; ....
                   center_x+h center_y-1.5*ymax; center_x+2*h center_y; ....
                   center_x+h center_y+1.5*ymax; center_x-h center_y+1.5*ymax; ....
                   center_x-2*h center_y]; 
end

%Randomly distribute 'npoints' (UEs) within the cell with dimensions cellx
%and celly
function points = random_points(cellx,celly,grid,npoints)
    in_cell = 0;
    points = [];
    for i = 1:npoints
        while (in_cell == 0)
            x = (grid(1,2)-grid(1,1)).*rand(1,1) + grid(1,1);
            y = (grid(2,2)-grid(2,1)).*rand(1,1) + grid(2,1);
            [in_cell,~] = inpolygon(x,y,cellx,celly);
        end
        in_cell = 0;
        points = [points;x y];  
    end
end

%Determine in which layer the point (x,y) lies
function layer = calculate_layer(x,y,cell900,cell1800,cell2100,cell2600)
    in_cell900 = 0;
    in_cell1800 = 0;
    in_cell2100 = 0;
    in_cell2600 = 0;
    for ii = 1:length(cell900)
        [in900,~] = inpolygon(x,y,cell900{ii,1},cell900{ii,2});
        in_cell900 = in_cell900 + in900; 
        [in1800,~] = inpolygon(x,y,cell1800{ii,1},cell1800{ii,2});
        in_cell1800 = in_cell1800 + in1800;
        [in2100,~] = inpolygon(x,y,cell2100{ii,1},cell2100{ii,2});
        in_cell2100 = in_cell2100 + in2100;
        [in2600,~] = inpolygon(x,y,cell2600{ii,1},cell2600{ii,2});
        in_cell2600 = in_cell2600 + in2600;
    end
    if(in_cell2600>0), layer = 2600; end
    if(in_cell2100>0 && in_cell2600==0), layer = 2100; end
    if(in_cell1800>0 && in_cell2100==0), layer = 1800; end
    if(in_cell900>0 && in_cell1800==0), layer = 900; end
        
end

%Functions for selection strategies
%==================================
%
%Function for the first selection strategy:

function new_layers = first_strategy(UE)
    layers = [900,1800,2100,2600];
    new_layers = [];
    for ii = 1:length(UE)
        new_layers=[new_layers;layers(randi([1 find(layers==UE(ii))],1,1))];
    end
end
