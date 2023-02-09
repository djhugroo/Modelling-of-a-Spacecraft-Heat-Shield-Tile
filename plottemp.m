function [] = plottemp(name)
% function to plot image of measured temperature automatically.
%
%
%
img=imread([name '.jpg']);

% Create matrix indicating coordinate of colour
[height,width,~] = size(img);
Red = zeros(height,width);
Black = zeros(height,width);

Red( img(:,:,1)> 200 & img(:,:,2)< 100 & img(:,:,3)< 100 ) = 1;
Black( img(:,:,1)< 100 & img(:,:,2)< 100 & img(:,:,3)< 100 ) = 1;

% Find origin coordiantes
originY = find( sum(Black.') == max(sum(Black.')) );
originY = originY(1);
origin(2) = height - originY;
originX = find( sum(Black) == max(sum(Black)) );
origin(1) = originX(1);

% Find x = 2k coordinates
x2k = Black(originY,origin(1):end);
x2k = find( x2k == 1, 1, 'last');
x2k = x2k + origin(1) - 1;

% Find y = 2k coordinates
y2k = Black(1:originY,origin(1));
y2k = find( y2k == 0, 1,'last');
y2k = y2k + 1 ;
y2k = height - y2k;

% Find coordinates of red dots
[tempdata,timedata] = find ( Red == 1);
tempdata = height - tempdata;

% sort data and remove duplicate points.
[timedata, index] = unique(timedata);
tempdata = tempdata(index);

xScale = 2000 / (x2k - origin(1)); % x-coordinate scaling factor
yScale = 2000 / (y2k - origin(2)); % y-coordinate scaling factor

% Convert to time and temperature coordinates
timedata = (timedata - origin(1)) * xScale;
tempdata = (tempdata - origin(2)) * yScale;

% Convert temperature to Kelvin
tempdata = ((tempdata - 32) * (5/9)) + 273.15;

%save data to .mat file with same name as image file
save(name, 'timedata', 'tempdata')

end
