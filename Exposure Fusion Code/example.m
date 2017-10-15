% This function uses multiple exposures as input, and outputs a
% well-balanced output with even exposure.
% Implemented by: Rosaleena Mohanty

function example;

close all;
I = load_images('window_series');

R = exposure_fusion(I,[1 1 1]);
figure('Name','Result'); 
imshow(R); 
