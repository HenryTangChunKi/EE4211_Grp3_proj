%code
oriimage = imread('2.jpg');
[rows columns numberOfColorBands] = size(oriimage);
if numberOfColorBands > 1
grayImage = rgb2gray(oriimage);
end
subplot(3, 3, 1);
imshow(grayImage);
title('Original Grayscale Image');
set(gcf, 'Position', get(0,'Screensize'));
set(gcf,'name','Demo by ImageAnalyst','numbertitle','off')
[pixelCount grayLevels] = imhist(grayImage);
subplot(3, 3, 2);
bar(pixelCount);
title('Histogram of original image');
xlim([0 grayLevels(end)]); 
binaryImage = grayImage < 150;
subplot(3, 3, 3);
imshow(binaryImage);
title('Binary Image');
binaryImage = imclearborder(binaryImage);    
subplot(3, 3, 4);
imshow(binaryImage);
title('Border cleared');
maskImage = imfill(binaryImage, 'holes'); 

subplot(3, 3, 5);
imshow(maskImage);
title('Lungs Mask');

maskImage = ~maskImage;

Result = imoverlay(oriimage,maskImage,'black');

subplot(3, 3, 6);
imshow(Result);
title('Lung Segmentation');

h_img = imclearborder(grayImage);
d1ca = imadjust(h_img); 

d1nF = wiener2(d1ca);

d1Level  = graythresh(d1nF);
d1sBW = im2bw(d1nF,d1Level); 
sed = strel('diamon',10); 
BWfinal = imerode(d1sBW,sed);
BWfinal = imerode(BWfinal,sed);

BWoutline = bwperim(BWfinal);
Segout = d1nF;
Segout(BWoutline) = 0; 

%edgePrewitt = edge(d1nF,'prewitt'); 
%figure,imshow(edgePrewitt)

output_image = im2bw(d1nF); 
subplot(3, 3, 8);
imshow(output_image); title('Processed Image'); 

p_image = output_image
subplot(3, 3, 9);
imshow(p_image); 
title('Processed Image with detection'); 
stats = regionprops('table',p_image,'Centroid','Area',...
    'MajorAxisLength','MinorAxisLength')
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

ids = find([stats.Area] > 10 & [stats.Area] < 1000);
p_image = ismember(p_image,ids);

hold on
viscircles(centers,radii);
hold off

% % Get rid of white border
% BWConv = bwconvhull(~BW);
% BW = BW & BWConv;
% % Checkout the image to make sure the conversion made sense.
% % Keep the figure because we'll add to it later
% % Note the orientation of the y axis (reversed)
% figure()
% h = imshow(BW); 
% axis on
% % Get the center coordinate for each object, it's orientation [-90:90 deg], 
% % and the lenght of its major axis (in pixels).  
% stats = regionprops('table',BW,'Centroid','MajorAxisLength','Orientation')
% % How many objects were detected?
% nObjects = size(stats,1);  % = 74
% % take a look at the results
% head(stats) %first few objects
% % Continuing with the figure created above, add the center points
% hold on
% ph1 = plot(stats.Centroid(:,1), stats.Centroid(:,2), 'rs'); 
% % using orientation, compute slope and y-intercept of each major axis
% % Note the reversal of the sign of the orientation!  This is to account 
% % for the reversed y axis!            
% %           here---v
% stats.Slope = atan(-stats.Orientation*pi/180); 
% % Compute y interceps
% stats.Intercep = stats.Centroid(:,2) - stats.Slope.*stats.Centroid(:,1); 
% % Now that we've got the linear eq for each line, compute the bounds of each
% % object along its major axis line. Add some extra length so we can see more of the lines. 
% % To use the exact major axis lenght, divide by 2 instead of 1.6 (both lines below)
% stats.EndpointX = stats.Centroid(:,1) + [-1,1].* (stats.MajorAxisLength/1.6 .* sqrt(1./(1+stats.Slope.^2))); 
% stats.EndpointY = stats.Centroid(:,2) + [-1,1].* (stats.Slope .* stats.MajorAxisLength/1.6 .* sqrt(1./(1+stats.Slope.^2))); 
% % Plot major axis of each object that spans the length of the obj
% mah = plot(stats.EndpointX.', stats.EndpointY.', 'r-')