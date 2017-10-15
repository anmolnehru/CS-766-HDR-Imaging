function [shifts_matrix] = Shifterwrapper(pixArray,ref_index, tolerance)
%  Shifterwrapper - get all the x and y shift positions for all images
%                        relative to last image i.e. reference image
%--------------------------------------------------------------------------
%   Author: Anmol Mohanty
%   CS 766 - Assignment 1
%   Params: pixArray - 4-d pixel array
%           ref_index - the index for the reference image
%         
%           tolerance - the distance from median value used to compute
%                       exclusion bitmaps
%   %
%   Return: shifts_matrix - a 2-d matrix with number of rows equal to the 
%                           number of images and 2 columns.  The
%                           1st column contains the x shift, and 2nd column 
%                           contains the y shift.  The row
%                           corresponds to the image number
%--------------------------------------------------------------------------

% compares everything in pix array to reference image

numphotos = size(pixArray,1);
shifts_matrix = zeros(numphotos,2);
grayReferenceImg = GetGrayImage(pixArray(ref_index,:,:,:));
for i = 1:numphotos
    if i ~= ref_index
        currGrayImg = GetGrayImage(pixArray(i,:,:,:));
        curr_shifts = Actualshift_computer(grayReferenceImg,currGrayImg,tolerance);
        keyboard;
        shifts_matrix(i,:) = curr_shifts;
        keyboard;
    end
     
     display('The amount of shift computed is ^');
end
keyboard

end


function [grayImage] = GetGrayImage(img)
% GetGrayImage : get gray version of img passed in
%--------------------------------------------------------------------------

%   Params: img - 4-d where 4th dimension is 1,2, or 3 for RGB
%   Return: grayImage - a 2-D gray version of this image used for Ward's alg
%--------------------------------------------------------------------------

grayImage = zeros(size(img,2), size(img,3));
for row = 1:size(img,2)
    for column = 1:size(img,3)
        red = double(img(1,row,column,1));
        green = double(img(1,row,column,2));
        blue = double(img(1,row,column,3));
        grayImage(row,column) = (54*red + 183*green + 19*blue)/256;
    end
end

grayImage = uint8(grayImage);

end

