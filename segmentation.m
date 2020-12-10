%Step1 read file
clc;
clear;
imagefiles = dir('COVID\*.png');      
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
    currentfilename = imagefiles(ii).name;
    path = "COVID\"+currentfilename;
    originalimage = imread(path);
    %Step2 get size and change to black white gray only 
    [rows, columns, numberOfColorBands] = size(originalimage);
    if numberOfColorBands > 1
    grayImage = rgb2gray(originalimage);
    end
    [pixelCount, grayLevels] = imhist(grayImage);
    binaryImage = grayImage < 150;
    binaryImage = imfill(binaryImage, 'holes');
    %step3 cut border but if lung near to border, ignore 
    borderImage = imclearborder(binaryImage);
    [Count1, gray1] = imhist(binaryImage);
    [Count2, gray2] = imhist(borderImage);
    num = (Count2(1)-Count1(1))/(Count1(1) + Count1(2));
    if num < 0.15
        binaryImage = borderImage;
    end
    %step4 dilate the image, to get more lung space 
    SE = strel('square',7);
    binaryImage = imdilate(binaryImage,SE);
    binaryImage = imfill(binaryImage, 'holes');
    %step5 take it to a mask abnd overlay to the original image 
    maskImage = ~binaryImage;
    LungSegment = imoverlay(originalimage,maskImage,'black');
    imwrite(LungSegment,"segmentation/"+currentfilename)
    
end