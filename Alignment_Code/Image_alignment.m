function [pixArrayShiftedNoFilter, pixArrayShiftedFilter] = Image_alignment(directory)

%--------------------------------------------------------------------------
%   Author: Anmol Mohanty
%   CS 766 - Assignment 1
%--------------------------------------------------------------------------

ref_index = 1;
tolerance = 3;

[pixArray] = readImages1(directory);

Shifterwrapper(pixArray, ref_index, max_shift, tolerance); 
%reads the series of images and outputs arrays of pixels

keyboard
end