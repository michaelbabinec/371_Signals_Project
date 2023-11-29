I = imread("conv_image.jpg");

%figure 
%imshow(I)
%title ("Original Image ");

h = ones(5,5)/25;

I2 = imfilter(I,h);
figure
imshow(I2)
title("Filtered Image");