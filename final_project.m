% Michael Babinec & Tyler Santiago
% EGEC - 371
% Ankita Mohapatra
% Only works with 512x512 files
% Can use weblinks or local files
%I = imread ('C:\Users\minec\Desktop\CompressJPEG.online_512x512_image.png');


original_image = imread ('https://i.imgur.com/2svdjbH.png');
%currently links to the CSUF Logo

%original_image = imread ('https://cdn1.iconfinder.com/data/icons/google_jfk_icons_by_carlosjj/512/chrome.png');
%links to the Chrome logo

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
% it convers the spacial domain image to something in the foruier frequency
% domain
fft_red = fft2(Channel_Red); 
fft_green = fft2(Channel_Green); 
fft_blue = fft2(Channel_Blue); 


%fftshift will completely rearrange an fft so that the smallest frequency
%   values are held in center
shifted_red = fftshift(fft_red); 
shifted_green = fftshift(fft_green);
shifted_blue = fftshift(fft_blue);

%These are representations of the actual FFTs

figure;
sgtitle("Figures of the RGB Channels in shifted FFT form");


subplot(2, 3, 1);
imshow(fft_red);
title('Red FFT');
subplot(2, 3, 2);
imshow(fft_green);
title('Green FFT');
subplot(2, 3, 3);
imshow(fft_blue);
title('Blue FFT');

subplot(2, 3, 4);
imshow(shifted_red);
title('Shifted Red FFT')
subplot(2, 3, 5);
imshow(shifted_green);
title('Shifted Green FFT')
subplot(2, 3, 6);
imshow(shifted_blue);
title('Shifted Blue FFT')



%Attempts to plot FFTs in plot form
%subplot (3, 1, 3)
%plot(abs(shifted_blue))
%title("Blue (Shifted)")
%xlabel("Frequency (Hz)")
%ylabel("Amplitude")

%subplot (3, 1, 1);
%plot(abs(shifted_red))
%title("Red (Shifted)")
%xlabel("Frequency (Hz)")
%ylabel("Amplitude")

%subplot (3, 1, 2);
%plot(abs(shifted_green))
%title("Green (Shifted)")
%xlabel("Frequency (Hz)")
%ylabel("Amplitude")




% Using fspecial, you calculate a gaussian pulse, and apply it to a matrix
% the same size as our matrices
gaussian_blur_filter = fspecial( 'gaussian', [512 512] , 5.0 );




%In the same way as we did for each of the color channels, now we have to
%preform an fft on the gaussian matrix, and shift the values.
gauss_fft = fft2(gaussian_blur_filter);  % Fourier Transform of 2D Gaussian 
filter = fftshift(gauss_fft); 

%Plots of the Gaussian Blur

figure;
sgtitle('Gaussian Filter & FFT');

subplot(1, 3, 1);
imshow(gaussian_blur_filter);
title('Gaussian Kernel')

subplot(1, 3, 2);
imshow(gauss_fft);
title('Gaussian FFT')

subplot(1, 3, 3);
imshow(filter);
title('Final Shifted Gaussian Blur')

%Attempts to plot Gaussian in plot form

%figure;
%sgtitle('Gaussian Filter & FFT');

%subplot (3, 1, 1);
%plot(abs(gaussian_blur_filter))
%title("Gauss")

%subplot (3, 1, 2);
%plot(abs(gauss_fft))
%title("Gaussian FFT")
%xlabel("Frequency (Hz)")
%ylabel("Amplitude")

%subplot (3, 1, 3);
%plot(abs(filter))
%title("Gaussian FFT (Shifted)")
%xlabel("Frequency (Hz)")
%ylabel("Amplitude")


% We can apply the filter using simple dot products of matrices.
postproc_red = filter .* shifted_red ; 
postproc_green = filter .* shifted_green; 
postproc_blue = filter .* shifted_blue; 

figure;
sgtitle('Gaussian Filter Applied to Channels');

subplot(1, 3, 1);
imshow(postproc_red);
title('Red Channel with Gaussian')

subplot(1, 3, 2);
imshow(postproc_green);
title('Green Channel with Gaussian')

subplot(1, 3, 3);
imshow(postproc_blue);
title('Blue Channel with Gaussian')



% Inverse FFT on Each of the Channels to bring this back into the necessary domain for display
inverse_red = ifftshift(postproc_red);
inverse_green = ifftshift(postproc_green);
inverse_blue = ifftshift(postproc_blue);

% As we shifted this before, the post transformation fft results still
% need to be shifted from the inverse
Blurred_Red = fftshift(real(ifft2(inverse_red)));
Blurred_Green = fftshift(real(ifft2(inverse_green)));
Blurred_Blue = fftshift(real(ifft2(inverse_blue)));



figure;
sgtitle("Processed Figures of the RGB Channels in shifted FFT form");


subplot(2, 3, 1);
imshow(inverse_red);
title('Blurred Red FFT');
subplot(2, 3, 2);
imshow(inverse_green);
title('Blurred Green FFT');
subplot(2, 3, 3);
imshow(inverse_blue);
title('Blurred Blue FFT');

subplot(2, 3, 4);
imshow(Blurred_Red);
title('Blurred Shifted Red FFT')
subplot(2, 3, 5);
imshow(Blurred_Green);
title('Blurred Shifted Green FFT')
subplot(2, 3, 6);
imshow(Blurred_Blue);
title('Blurred Shifted Blue FFT')



%cat concatenates the matrices back into its RGB image form. 
% as shown before, these are the 3 RGB matrices of the image being
% constructed by the concatenation, with emtpy black 0 matrices taking the
% place of any necessary channels when we're only trying to show one
red_image = cat(3,Blurred_Red, true_black, true_black);
green_image = cat(3, true_black, Blurred_Green, true_black);
blue_image = cat(3, true_black, true_black, Blurred_Blue); 


%this does the same for the unblurred channels
red_orig = cat(3,Channel_Red, true_black, true_black);
green_orig = cat(3, true_black, Channel_Green, true_black);
blue_orig = cat(3, true_black, true_black, Channel_Blue);

%Same for the extra outputs, but Uint8 to get real colors
extra_image1 = uint8(cat(3,Blurred_Red, Blurred_Green, Channel_Blue));
extra_image2 = uint8(cat(3, Channel_Red, Channel_Green, Blurred_Blue));
extra_image3 = uint8(cat(3, Blurred_Blue, Blurred_Red, Blurred_Green));

%Reconstruction of the image is handled here, if you want a certain color
%channel to skip the gaussian blur, you can insert the original channel as
%   'Channel_Color' here, from before its fft inversions
recon_image = uint8(cat(3, Blurred_Red, Blurred_Green, Blurred_Blue));

% Image Display

figure;
sgtitle("Final Output");

subplot(4,3,1);
%Image from Red Matrix
imshow(original_image);
title('Original Image');

subplot(4,3,3);
%Image from Red Matrix
imshow(recon_image);
title('Reconstruction of the Original Through Channels');


%Original Channels
subplot(4,3,4);
%Image from Red Matrix
imshow(red_orig);
title('Original Red Channel');
subplot(4,3,5);
%Image from Green Matrix
imshow(green_orig);
title('Original Green Channel');
subplot(4,3,6);
%Image from Blue Matrix
imshow(blue_orig);
title('Original Blue Channel');

%Blurred Channels
subplot(4,3,7);
%Image from Red Matrix
imshow(red_image);
title('Blurred Red Channel');
subplot(4,3,8);
%Image from Green Matrix
imshow(green_image);
title('Blurred Green Channel');
subplot(4,3,9);
%Image from Blue Matrix
imshow(blue_image);
title('Blurred Blue Channel');

%Extra Outputs
subplot(4,3,10);
%Currently a Red/Green Channel Blur
imshow(extra_image1);
title('Red/Blue Blur');
subplot(4,3,11);
%%Currently only blurs the Blue Channel
imshow(extra_image2);
title('Only Blurred Blue');
subplot(4,3,12);
%%Currently places the blurred 'RGB' channels back into an image
% with a 'BRG' shift
imshow(extra_image3);
title('Blurred Channel Shift');