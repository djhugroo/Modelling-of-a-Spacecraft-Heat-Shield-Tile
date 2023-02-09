% Plot the inner surface temperature variation with timestep
%
i=0; 
nx = 21; % number of spatial steps
thick = 0.05; % total thickness
tmax = 4000; % maximum time
name = 597; % image to access

% Varies number of timesteps
for nt = 41:20:1001 
    i=i+1; 
    dt(i) = tmax/(nt-1); 
    disp (['nt = ' num2str(nt) ', dt = ' num2str(dt(i)) ' s']) 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'forward', false); 
    uf(i) = u(end, 1); 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'backward', false); 
    ub(i) = u(end, 1);
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'dufort-frankel', false); 
    ud(i) = u(end, 1); 
    [~, ~, u] = shuttle(name, tmax, nt, thick, nx, 'crank-nicolson', false); 
    uc(i) = u(end, 1);
end 
semilogx(dt, [uf; ub; ud; uc]) 
ylim([430 440]) 
xlabel('\itdt\rm (s)')
ylabel('\itu\rm (K)')
title('Inner surface temperature variation with timestep')
legend ('Forward', 'Backward', 'Dufort-Frankel', 'Crank-Nicolson','Location','northwest')