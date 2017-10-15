% Implemented by: Rosaleena Mohanty


function [Outputu8, output] = bilateral(SrcImgOri)

OutputRange = 30;
SrcImg = SrcImgOri(:,:,:);
R = SrcImg(:, :, 1);
G = SrcImg(:, :, 2);
B = SrcImg(:, :, 3);

I = 1/61*(R*20+G*40+B);

r = R ./ I;
g = G ./ I;
b = B ./ I;

ILog = log(I);
ILogBase = imbltflt(ILog, 10, 8, 0.2);

%H = fspecial('gaussian',21,8);
%ILogBase = imfilter(ILog, H)

ILogDetail = ILog - ILogBase;
CFactor = log(OutputRange) / (max(max(ILogBase)) - min(min(ILogBase)));
ILogOffset = -max(max(ILogBase)) * CFactor;
IlogOutput = ILogBase * CFactor + ILogOffset + ILogDetail;
IOutput = exp(IlogOutput);

ROutput = r .* IOutput;
GOutput = g .* IOutput;
BOutput = b .* IOutput;

Output(:, :, 1) = ROutput * 255;
Output(:, :, 2) = GOutput * 255;
Output(:, :, 3) = BOutput * 255;
Outputu8 = uint8(Output);
output = Output;
% imshow(Outputu8); 
