% Implemented by: Rosaleena Mohanty

function Im = imbltflt(InputMatrix, wsize, sigma_d, sigma_r)
% The implementation of bilateral filter.

[HeightSize, WidthSize] = size(InputMatrix);
InputMatrix = single(InputMatrix);
Im = zeros(size(InputMatrix));

for Height = 1: HeightSize
    for Width = 1: WidthSize
        FilterHeightBegin = Height - wsize;
        FilterHeightEnd = Height + wsize;
        FilterWidthBegin = Width - wsize;
        FilterWidthEnd = Width + wsize;
        if(FilterHeightBegin < 1)
            FilterHeightBegin = 1;
        end
        if(FilterHeightEnd > HeightSize)
            FilterHeightEnd = HeightSize;
        end
        if(FilterWidthBegin < 1)
            FilterWidthBegin = 1;
        end
        if(FilterWidthEnd > WidthSize)
            FilterWidthEnd = WidthSize;
        end
        FilterHeightSize = FilterHeightEnd - FilterHeightBegin + 1;
        FilterWidthSize = FilterWidthEnd - FilterWidthBegin + 1;
        
        FilterCoef = zeros(FilterHeightSize, FilterWidthSize);
        if(Height == 18 && Width == 88)
            Height = Height;
        end
        for FilterHeight = FilterHeightBegin: FilterHeightEnd
            for FilterWidth = FilterWidthBegin: FilterWidthEnd
                FilterCoef(FilterHeight - FilterHeightBegin + 1, FilterWidth - FilterWidthBegin + 1) = exp((-(Height - FilterHeight)^2 - (Width - FilterWidth)^2) / (2*sigma_d^2)) ...,
                    * exp((-(InputMatrix(FilterHeight, FilterWidth) - InputMatrix(Height, Width))^2) / (2*sigma_r^2));
                %exp((-(Height - FilterHeight)^2 - (Width - FilterWidth)^2) / (2*sigma_d))
                %(-(InputMatrix(FilterHeight, FilterWidth) - InputMatrix(Height, Width))^2) / (2*sigma_r)
            end
        end
        
        FilterCoefSum = sum(sum(FilterCoef));
        FilterCoef = FilterCoef / FilterCoefSum;
        TargetBlock = InputMatrix(FilterHeightBegin: FilterHeightEnd, FilterWidthBegin: FilterWidthEnd);
        Im(Height, Width) = sum(sum(FilterCoef .* TargetBlock));
        %TargetBlock
        %Im(Height, Width)
        %Im(Height, Width);
        
    end
end

end