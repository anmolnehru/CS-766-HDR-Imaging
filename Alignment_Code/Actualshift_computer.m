function [x_y_shift_amounts] = Actualshift_computer(referenceImg, img2, tolerance)
% Actualshift_computer: get expected shift to align img2 with referenceImg
%--------------------------------------------------------------------------
%   Author: Anmol Mohanty

%   CS 766 - Assignment 1
%   Params: referenceImg - 2-d gray image.  This is the reference image 
%                           that is used to compare to the other image 
%                           that will be used. Use GetGrayImage function
%                           if referenceImg is in RGB form
%           img2 - 2-d gray image.  Use GetGrayImage if img2 is in RGB form
%           max_shift - the estimated maximum shift in bits necessary
%           tolerance - the distance from median value used to compute
%                       exclusion bitmaps
%
%   Return: x_y_shift_amounts - a vector with 2 elements.  The 1st element 
%           is the x offset and the 2nd element is the y offset
%--------------------------------------------------------------------------
keyboard
x_y_shift_amounts = [0 0];

th1 = median(referenceImg(:)) ;
th2 = median(img2(:)) ;

[tb1, eb1] = ComputeBitmaps(referenceImg, tolerance,th1);
[tb2, eb2] = ComputeBitmaps(img2, tolerance,th2);

%the threshold bitmaps will be written to the folders specified below
imwrite(tb1,strcat('Reference_',num2str(max_shift),'_','.jpg'));
imwrite(tb2,strcat('Current_',num2str(max_shift),'_','.jpg'));

%%
%%The code portion below isn't functioning well
min_error = size(img2,1) * size(img2,2);
for i = -5:5
    for j = -5:5
        shifted_tb2 = BitmapShift(tb2,i,j);
        shifted_eb2 = BitmapShift(eb2,i,j);
        diff_bitmaps = BitmapXOR(tb1,shifted_tb2);
        diff_bitmaps = BitmapAND(diff_bitmaps,eb1);
        diff_bitmaps = BitmapAND(diff_bitmaps,shifted_eb2);
        error = BitmapTotal(diff_bitmaps);
       % keyboard
        if error < min_error
            %x_y_shift_amounts(1) = cur_shift(1) + i;
            x_y_shift_amounts(1) = x_y_shift_amounts(1) + i;
        %    keyboard
           
           x_y_shift_amounts(2) = x_y_shift_amounts(2)+j;
           min_error = error;
           %keyboard
        end
        %display(x_y_shift_amounts);
       
    end
 
end

% This outputs amount of shift computed || Not working
fprintf('Xshift =%d, Yshift=%d',x_y_shift_amounts(1),x_y_shift_amounts(2));
%the above implementation did not work out


%%
%the segment below generates the bitmap and outputs them
%it does nothing further and may be considered for partial credit.

th1 = median(referenceImg(:)) ;
th2 = median(img2(:)) ;
mtbIMG1=logical(zeros(size(referenceImg,1),size(referenceImg,2)));
mtbIMG2=logical(zeros(size(img2,1),size(img2,2)));

for i = 1 : size(grayIMG1,1) 
    for j = 1 : size(grayIMG1,2)
        if grayIMG1( i, j) < th1
           mtbIMG1( i, j) = 0; 
        elseif grayIMG1( i, j) >= th1
           mtbIMG1( i, j) = 1;
        end
        if grayIMG2( i, j) < th2
           mtbIMG2( i, j) = 0; 
        elseif grayIMG2( i, j) >= th2
           mtbIMG2( i, j) = 1;   
        end
    end
end
keyboard

imshow(mtbIMG2);
end

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUB FUNCTIONS INVOKED BELOW DEFINITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bm_ret] = BitmapXOR(bm1,bm2)
% BitmapXOR: get the "exclusive or" bitmap of bm1 and bm2
%--------------------------------------------------------------------------
%   Params: bm1 - first bitmap
%           bm2 - second bitmap
%   Return: bm_ret - the "exclusive or" bitmap
%--------------------------------------------------------------------------

bm_ret = zeros(size(bm1,1), size(bm1,2));
for row = 1:size(bm1,1)
    for column = 1:size(bm1:2)
        val1 = bm1(row,column);
        val2 = bm2(row,column);
        if (val1 == 0 && val2 == 0) || (val1 == 1 && val2 == 1)
            bm_ret(row,column) = 0;
        else
            bm_ret(row,column) = 1;
        end
    end
end


end


function [error] = BitmapTotal(bitmap)
% BitmapTotal : sum all bits in array to get error
%--------------------------------------------------------------------------
%   Params: bitmap - the bitmap used to calculate error
%   Return: error - the error for a bitmap shift
%--------------------------------------------------------------------------

error = sum(bitmap(:));
end


function [bm_ret] = BitmapAND(bm1,bm2)
% BitmapAND: get the "and" bitmap of bm1 and bm2
%--------------------------------------------------------------------------
%   Params: bm1 - first bitmap
%           bm2 - second bitmap
%   Return: bm_ret - the "and" bitmap
%--------------------------------------------------------------------------

bm_ret = zeros(size(bm1,1), size(bm1,2));
for row = 1:size(bm1,1)
    for column = 1:size(bm1:2)
        val1 = bm1(row,column);
        val2 = bm2(row,column);
        if (val1 == 1 && val2 == 1)
            bm_ret(row,column) = 1;
        else
            bm_ret(row,column) = 0;
        end
    end
end
end

function [map_ret] = BitmapShift(bitmap, x, y)
% BitmapShift : shift bitmap (or just a 2d array of pixels) by x and y given
%   Params: bitmap - the 2-d bitmap to shift
%           x - the x amount to shift
%           y - the y amount to shift
%   Return: map_ret - the shifted bitmap
%--------------------------------------------------------------------------

map_ret = zeros(size(bitmap,1),size(bitmap,2));
for row = 1:size(bitmap,1)
    for column = 1:size(bitmap,2)
        if column + x < 1 || column + x > size(bitmap,2) || row + y < 1 || row + y > size(bitmap,1)
            %No change
        else
            map_ret(row + y, column + x) = bitmap(row, column);
            %Note the inverted offsets
        end
    end
end

end

function [thresholdBitmap,exclusionBitmap] = ComputeBitmaps(img,tolerance,th)
% ComputeBitmaps : compute threshold and exclusion bitmaps for img
%--------------------------------------------------------------------------
%   Author: Anmol Mohanty
%   Return: thresholdBitmap - threshold bitmap for img
%           exclusionBitmap - exclusion bitmap for img
%--------------------------------------------------------------------------
thresholdBitmap = zeros(size(img,1), size(img,2));
exclusionBitmap = zeros(size(img,1), size(img,2));
for row = 1:size(img,1)
    for column = 1:size(img,2)
        currPix = img(row,column);
        if currPix > th
            thresholdBitmap(row,column) = 1;
        else
            thresholdBitmap(row,column) = 0;
        end
        if (currPix > (th + tolerance)) || (currPix < (th - tolerance))
            exclusionBitmap(row,column) = 1;
        else
            exclusionBitmap(row,column) = 0;
        end
    end
end
end



