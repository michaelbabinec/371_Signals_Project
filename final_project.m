% Michael Babinec & Tyler Santiago
% EGEC - 371
% Ankita Mohapatra
% Only works with 512x512 files
% Can use weblinks or local files
%I = imread ('C:\Users\minec\Desktop\CompressJPEG.online_512x512_image.png');


original_image = imread ('https://i.imgur.com/2svdjbH.png');
%currently links to the CSUF Logo


%FFTs require the image be a double
% This does that conversion
image_preprocess = double(original_image);

% From the original image, the three color matrices are taken, one for each color channel
% These will appear as greyscale, with black showing for the intensity of
%   given channel
% MATLAB's image toolbox allows for this

%MATLAB RGB Image matrix 1 is for the Red Channel
Channel_Red = image_preprocess (: , : , 1);

%MATLAB RGB Image matrix 2 is for the Green Channel
Channel_Green = image_preprocess (: , : , 2);

%MATLAB RGB Image matrix 3 is for the Blue Channel
Channel_Blue = image_preprocess(: , : , 3);


%Outside of the original image color channels, we do create two more for
%  the image modification process.

% this is just a matrix of zeros,within the color channels, it's entirely true black
true_black = zeros(size(original_image, 1), size(original_image, 2), 'uint8');

%I was trying to make white, however, this just turns the rgb into cyan,
%magenta, and yellow. I am not entirely sure why.
true_white = zeros(size(original_image, 1), size(original_image, 2), 'uint8')+255;

%figure;
%subplot(1,3,1);
%imshow(Channel_Red);
%title('To be Red');

%subplot(1,3,2);
%imshow(Channel_Green);
%title('To be Green');

%subplot(1,3,3);
%imshow(Channel_Blue);
%title('To be Blue');


%fft2 returns the two-dimensional Fourier transform of a matrix
fft_red = fft2(Channel_Red); 
fft_green = fft2(Channel_Green); 
fft_blue = fft2(Channel_Blue); 


%fftshift will completely rearrange an fft so that the smallest frequency
%   values are held in center
shifted_red = fftshift(fft_red); 
shifted_green = fftshift(fft_green);
shifted_blue = fftshift(fft_blue);




%Fs = 1000;            % Sampling frequency                    
%T = 1/Fs;             % Sampling period     

%These are representations of the actual FFTs as spikes on a plot
%the shift can be seen

%figure;
%subplot (3, 1, 1)
%plot(Fs/L*(0:length(fft_blue)-1),abs(fft_blue),"LineWidth",3)
%title("blue")
%xlabel("f (Hz)")
%ylabel("|fft(X)|")


%subplot (3, 1, 2);
%plot(Fs/L*(0:length(shifted_red)-1),abs(shifted_red),"LineWidth",3)
%title("red")
%xlabel("f (Hz)")
%ylabel("|fft(X)|")


%subplot (3, 1, 3);
%plot(Fs/L*(0:length(fft_green)-1),abs(fft_green),"LineWidth",3)
%title("green")
%xlabel("f (Hz)")
%ylabel("|fft(X)|")










% Using fspecial, you calculate a gaussian blur, and apply it to a matrix
% the same size as our matrices
gaussian_blur_filter = fspecial( 'gaussian', [512 512] , 3.0 );

%In the same way as we did for each of the color channels, now we have to
%preform an fft on the gaussian matrix, and shift the values.
gauss_fft = fft2(gaussian_blur_filter);  % Fourier Transform of 2D Gaussian 
filter = fftshift(gauss_fft); 

% We can apply the filter using simple dot products of matrices.
postproc_red = filter .* shifted_red ; 
postproc_green = filter .* shifted_green; 
postproc_blue = filter .* shifted_blue; 


% Inverse FFT on Each of the Channels to bring this back into the necessary form for display
inverse_red = ifftshift(postproc_red);
inverse_green = ifftshift(postproc_green);
inverse_blue = ifftshift(postproc_blue);

% As we shifted this before, the post transformation fft results still
% need to be shifted from the inverse
Blurred_Red = fftshift(real(ifft2(inverse_red)));
Blurred_Green = fftshift(real(ifft2(inverse_green)));
Blurred_Blue = fftshift(real(ifft2(inverse_blue)));


%cat concatenates the matrix back into its image form. 
% as shown before, these are the 3 RGB matrices of the image being
% constructed by the concatenation
red_image = cat(3,Blurred_Red, true_black, true_black);
green_image = cat(3, true_black, Blurred_Green, true_black);

%This is the the blue image, currently minus any guassian blue
blue_image = cat(3, true_black, true_black, Channel_Blue); 

%Reconstruction of the image is handled here, if you want a certain color
%channel to skip the gaussian blur, you can insert the original channel
%here, from before its fft inversions
recon_image = uint8(cat(3, Blurred_Red, Blurred_Green, Channel_Blue));

% Image Display

figure;
subplot(2,3,4);
%Image from Red Matrix
imshow(red_image);
title('Red Channel');

subplot(2,3,5);
%Image from Green Matrix
imshow(green_image);
title('Green Channel');

subplot(2,3,6);
%Image from Blue Matrix
imshow(blue_image);
title('Blue Channel', 'Currently Not Blurred');

subplot(2,3,2);
%Image from Red Matrix
imshow(recon_image);
title('Reconstruction of the Original');