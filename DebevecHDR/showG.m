% Program to output the camera response curve of each channel
% Implemented by: Rosaleena Mohanty

y = (0:255);
figure
hold on
subplot(2,2,1)
plot(gRed, y, 'r-');
xlabel('log Exposure X');
ylabel('Pixel Value Z');

subplot(2,2,2)
plot(gGreen, y, 'g-');
xlabel('log Exposure X');
ylabel('Pixel Value Z');

subplot(2,2,3)
plot(gBlue, y, 'b-');
xlabel('log Exposure X');
ylabel('Pixel Value Z');

subplot(2,2,4)
plot(gRed, y, 'r-', gGreen,y , 'g-', gBlue, y, 'b-');
xlabel('log Exposure X');
ylabel('Pixel Value Z');
hold off

figure
hold on
plot(gRed, y, 'r-', gGreen,y , 'g-', gBlue, y, 'b-');
xlabel('log Exposure X');
ylabel('Pixel Value Z');
hold off
