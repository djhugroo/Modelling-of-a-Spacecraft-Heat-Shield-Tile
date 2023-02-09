% Plot the inner surface temperature variation with step size
%
i=0; 
nt = 501; % number of timesteps
thick = 0.05; % total thickness
tmax = 4000; % maximum time
name = 597; % image to access

% Varies number of spatial steps
for nx = 5:1:51 
    i=i+1; 
    dx(i) = thick/(nx-1); 
    disp (['nx = ' num2str(nx) ', dx = ' num2str(dx(i)) ' m']) 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'forward', false); 
    uf(i) = u(end, 1); 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'backward', false); 
    ub(i) = u(end, 1);
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'dufort-frankel', false); 
    ud(i) = u(end, 1); 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'crank-nicolson', false); 
    uc(i) = u(end, 1);
end 
plot(dx, [uf; ub; ud; uc]) 
ylim([432 436])
xlabel('\itdx\rm (m)')
ylabel('\itu\rm (K)')
title('Inner surface temperature variation with stepsize')
legend ('Forward', 'Backward', 'Dufort-Frankel', 'Crank-Nicolson')