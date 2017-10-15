% Implements a complete hdr and bilateral tonemapping
%
% 1.: Computes the camera response curve according to "Recovering High
% Dynamic Range Radiance Maps from Photographs" by P. Debevec.
% You need a wide range of differently exposed pictures from the same scene
% to get good results.
%
% 2.: Recovers a hdr radiance map from the range of ldr pictures 
%
% 3.: Tonemaps the resulting hdr radiance map using bilateral filtering
% from Durand's paper
% Implemented by: Rosaleena Mohanty

% -------------------------------------------------------------------------

close all;
clear all;

% Specify the directory that contains your range of differently exposed
% pictures. Needs to have a '/' at the end. 
% The images need to have exposure information encoded in the filename,
% i.e. the filename 'window_exp_1_60.jpg' would indicate that this image
% has been exposed for 1/60 second. 
dirName = ('C:/Users/rmohanty/Downloads/Final_Zip/DebevecHDR/window_series/');
[filenames, exposures, numExposures] = readDir(dirName);

fprintf('Opening test image\n');
tmp = imread(filenames{1});

numPixels = size(tmp,1) * size(tmp,2);
numExposures = size(filenames,2);

% define lamda smoothing factor
l = 70;

fprintf('Computing weighting function\n');
% precompute the weighting function value
% for each pixel
weights = [];
for i=1:256
    weights(i) = weight(i,1,256);
end

% load and sample the images
[zRed, zGreen, zBlue, sampleIndices] = makeImageMatrix(filenames, numPixels);

B = zeros(size(zRed,1)*size(zRed,2), numExposures);

fprintf('Creating exposures matrix B\n')
for i = 1:numExposures
    B(:,i) = log(exposures(i));
end

% solve the system for each color channel
fprintf('Solving for red channel\n')
[gRed,lERed]=gsolve(zRed, B, l, weights);
fprintf('Solving for green channel\n')
[gGreen,lEGreen]=gsolve(zGreen, B, l, weights);
fprintf('Solving for blue channel\n')
[gBlue,lEBlue]=gsolve(zBlue, B, l, weights);
save('gMatrix.mat','gRed', 'gGreen', 'gBlue');

% compute the hdr radiance map
fprintf('Computing hdr image\n')
hdrMap = hdr(filenames, gRed, gGreen, gBlue, weights, B);
figure, imshow(hdrMap); title('HDR Radiance Map');

% Biltaeral filter implementation
[outu8, out] = bilateral(hdrMap);
figure, imshow(outu8); title('bilateral');

% Gamma Correction
Correction = (255 * ((out)/255).^2.8999);
figure, imshow(Correction), title('Gamma Correction');

fprintf('Finished!\n');