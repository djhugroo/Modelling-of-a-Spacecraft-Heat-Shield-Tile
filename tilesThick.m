% Calculate thickness of tile required for each temperature plot
%
location = [468 480 502 590 597 711 730 850];

for i = 1:8
    minThick = shootingMethod(location(i));
    disp(['Thickness of tile required for location ' num2str(location(i)) ' is ' num2str(minThick) ' m']);
end