% Calculate FFT for R , G , B images
% Only works with 512x512 files
% Can use weblinks or local files
%I = imread ('C:\Users\minec\Desktop\CompressJPEG.online_512x512_image.png');

I = imread ('https://i.imgur.com/2svdjbH.png');

%Change - cast to double 
I = double(I);

% Extract three images 
Red = I (: , : , 1);
Green = I (: , : , 2);
Blue = I(: , : , 3);

% Change - Transform, then shift
fft_r = fft2(Red); 
Fshift_r = fftshift(fft_r); 

fft_g = fft2(Green); 
Fshift_g = fftshift(fft_g);

fft_b = fft2(Blue); 
Fshift_b = fftshift(fft_b); 

% Calculate the gaussian filter then find its FFT 
h = fspecial( 'gaussian', [512 512] , 3.0 );

% Change - Filter, then FFT shift
H = fft2(h);  % Fourier Transform of 2D Gaussian 
H = fftshift(H); 

% Now filter
FF_R = H .* Fshift_r ; 
FF_G = H .* Fshift_g; 
FF_B = H .* Fshift_b; 

% Change - perform ifftshift, then ifft2, then cast to real
% Inverse RED 
Ir = ifftshift(FF_R);
Irr = fftshift(real(ifft2(Ir)));

% Inverse Green 
Ig = ifftshift(FF_G);
Igg = fftshift(real(ifft2(Ig)));

% Inverse Blue
Ib = ifftshift(FF_B);
Ibb = fftshift(real(ifft2(Ib)));

% Visualize the red, green and blue components
b = zeros(512, 512, 'uint8');
i_red = cat(3,Irr, b, b);
i_green = cat(3, b, Igg, b);
i_blue = cat(3, b, b, Ibb);

% Combine the three component together
% Change - Removed fluff
b = uint8(cat(3, Irr, Igg, Ibb));

% Display each component as well as the final image in a new figure
figure;
subplot(2,3,4);

imshow(i_red);
title('Red Channel');

subplot(2,3,5);

imshow(i_green);
title('Green Channel');

subplot(2,3,6);

imshow(i_blue);
title('Blue Channel');

subplot(2,3,2);

imshow(b);
title('Original');