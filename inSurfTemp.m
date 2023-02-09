function [xmax] = inSurfTemp(name,tmax,nt,nx,method)
% Function to plot the inner surface temperature variation with thickness of tile
%
% Input arguments:
% name   - name of image to scan
% tmax   - maximum time
% nt     - number of timesteps
% nx     - number of spatial steps
% method - solution method ('forward', 'backward' etc)
%
% Return arguments:
% xmax   - optimum thickness

i = 0;

% Variation of thickness
thickMin = 0.05; % minimum thickness
thickMax = 0.07; % maximum thickness
thickChange = 0.001; % change in thickness

stop = 0;

% Varies total thickness
for thick = thickMin:thickChange:thickMax
    i = i + 1;
    % Find variation of inner surface temperature with time for thick
    [~,t,u] = shuttle(name, tmax,nt,thick,nx,method,false);
    innerU(i,:) = transpose( u(:,1) ); % vector of temperature variation
    thicknesses(i) = thick; % vector of different thicknesses
    
    % Detect index for thickness when inner surface temperature unchanged
    if ( ( ( u(:,1) - 450 ) < 1 ) & stop == 0 )
        optimumThick = i;
        stop = stop + 1;
    end
        
end

% plot of inner surface temperature against time  for range of thicknesses
h = surf(t,thicknesses,innerU);
set(h,'LineStyle','none');
view(120,20)
xlabel('\itt\rm (s)')
ylabel('\itthickness\rm (m)')
zlabel('\itu\rm (K)')
xlim([0 4000])
ylim([thickMin thickMax])
zlim([0 1400])
title(['Temperature profile' ' for temp' num2str(name) ' using ' method ' method'])

% Display suitable tile thickness based on inner surface temperature
xmax = thicknesses(optimumThick);
disp(['Suitable tile thickness is ' num2str(xmax) ' m'])
end
