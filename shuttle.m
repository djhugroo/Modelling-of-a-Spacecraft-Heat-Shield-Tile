function [x, t, u] = shuttle(name,tmax, nt, xmax, nx, method, doplot)
% Function for modelling temperature in a space shuttle tile
% D N Johnston  30/1/19
% Modified by D Jhugroo 10/3/19
%
% Input arguments:
% name   - name of image to scan
% tmax   - maximum time
% nt     - number of timesteps
% xmax   - total thickness
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
% doplot - true to plot graph; false to suppress graph.
%
% Return arguments:
% x      - distance vector
% t      - time vector
% u      - temperature matrix
%
% For example, to perform a  simulation with 501 time steps
%   [x, t, u] = shuttle(4000, 501, 0.05, 21, 'forward', true);
%

% Set tile properties
thermcon = 0.141; % W/(m K)
density  = 351;   % 22 lb/ft^3
specheat = 1259;  % ~0.3 Btu/lb/F at 500F

% Some crude data to get you started:
% timedata = [0  60 500 1000 1500 1750 4000]; % s
% tempdata = [16 16 820 760  440  16   16];   % degrees C

% Better to load surface temperature data from file.
% (you need to have modified and run plottemp.m to create the file first.)
% Uncomment the following line.

name = num2str(name);
name = ['temp' name];
plottemp(name);

load ([name '.mat'])

% Initialise everything.
dt = tmax / (nt-1);
t = (0:nt-1) * dt;
dx = xmax / (nx-1);
x = (0:nx-1) * dx;
u = zeros(nt, nx);
alpha = thermcon / (density * specheat);
p = alpha * dt / dx^2;

% set initial conditions to 16C throughout.
% Do this for first two timesteps.
u([1 2], :) = 16 + 273.15;

% set up index vector
im = [2 1:nx-2];
i  = 1:nx-1;
ip = 2:nx;

% Assuming ambient temperature for time greater than 2000s
timedata(end:end+1) = [2008 2010];
tempdata(end:end+1) = 16 + 273.15;

% Main timestepping loop.
for n = 2:nt - 1
    
    % RHS boundary condition: outer surface.
    % Use interpolation to get temperature R at time t(n+1).
    R = interp1(timedata, tempdata, t(n+1), 'linear', 'extrap');
    u(n+1,nx) = R; % outer surface - boundary condition
    
    % Select method.
    switch method
        case 'forward'
            u(n+1,i) = (1 - 2 * p) * u(n,i) + p * (u(n,im) + u(n,ip));
            
        case 'dufort-frankel'
            u(n+1,i) = ((1 - 2 * p) * u(n-1,i) + 2 * p * (u(n,im) + u(n,ip))) / (1 + 2 * p);
            
        case 'backward'
            b(1)          = 1 + 2 * p;
            c(1)          = -2 * p;
            d(1)          = u(n,1);
            a(2:nx-1)     = -p;
            b(2:nx-1)     = 1 + 2 * p;
            c(2:nx-1)     = -p;
            d(2:nx-1)     = u(n,2:nx-1);
            a(nx)         = 0;
            b(nx)         = 1;
            d(nx)         = R;
            u(n+1,:)      = tdm(a,b,c,d);
            
        case 'crank-nicolson'
            b(1)          = 1 + p;
            c(1)          = -p;
            d(1)          = (1 - p) * u(n,1) + p * u(n,2);
            a(2:nx-1)     = -p / 2;
            b(2:nx-1)     = 1 + p;
            c(2:nx-1)     = -p / 2;
            d(2:nx-1)     = (p / 2) * u(n,1:nx-2) + (1 - p) * u(n,2:nx-1) + (p / 2) * u(n,3:nx);
            a(nx)         = 0;
            b(nx)         = 1;
            d(nx)         = R;
            u(n+1,:)      = tdm(a,b,c,d);
            
        otherwise
            error (['Undefined method: ' method])
            
    end
end

if doplot
    % Create a plot here.
    % simple 3D plot
    surf(x,t,u);
    shading('interp')
    colorbar
    view(120,20)
    xlabel('\itx\rm (m)')
    ylabel('\itt\rm (s)')
    zlabel('\itu\rm (K)')
    xlim([0 xmax])
    ylim([0 tmax])
    zlim([0 1400])
    title(['Temperature profile' ' for ' name ' using ' method ' method'])
    
end
% End of shuttle function

