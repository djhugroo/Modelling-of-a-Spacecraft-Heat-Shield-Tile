function [reqThick] = shootingMethod(name)
% Calculate the thickness of tile required for different temperature plot
%
%
% set paramaters for shuttle.m function
tmax = 4000; % maximum time
nt = 801; % number of timesteps
nx = 34; % number of spatial steps
method = 'crank-nicolson'; % solution method
innerTemp = 450;

% 1st Guess
thick(1) = 0.05;
[~,~,u]=shuttle(name,tmax,nt,thick(1),nx,method,false);
intemp(1) = max( u(:,1) );
error(1) = innerTemp - intemp(1);

% 2nd Guess
thick(2) = 0.07;
[~,~,u]=shuttle(name,tmax,nt,thick(2),nx,method,false);
intemp(2) = max( u(:,1) );
error(2) = innerTemp - intemp(2);

i = 2;

while error(end) > 0.01
    
    i = i + 1;
    
    % Generate ith Guess
    thick(i) = thick(i-1) + error(end) * ((thick(end)-thick(end-1))/(intemp(end)-intemp(end-1)));
    
    % Compute ith Guess
    [~,~,u]=shuttle(name,tmax,nt,thick(i),nx,method,false);
    intemp(i) = max( u(:,1) );
    error(i) = innerTemp - intemp(i);
    
end
reqThick = thick(i);
end
