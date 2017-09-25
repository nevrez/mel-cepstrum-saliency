% % These codes are used for computing saliency maps using 2D mel-cepstrum.
% % This is a revised version of the following publication for public 
% % distribution on web. Please cite the following paper when you use 
% % this code.
% % 
% % Reference:
% % Nevrez Imamoglu, Yuming Fang, Wenwei Yu, Weisi Lin: 
% % 2D Mel-Cepstrum Based Saliency Detection. IEEE ICIP 2013.
% % 
% % DISCLAIMER: The Matlab codes provided are only for evaluation of the algorithm. 
% % Neither the authors of the codes, nor affiliations of the authors can be held 
% % responsible for any damages arising out of using this code in any manner. 
% % Please use the try out code at your own risk.

%%
clear all;
close all;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Select an RGB color image from the database
[FileName,PathName] = uigetfile( {'*.bmp;*.jpeg;*.jpg;*.tif;*.png;*.gif','All Image Files';...
                                 '*.*','All Files' },...
                                 'Select the test image file','testFile.jpg');
myFile = [PathName FileName];
img = imread(myFile);

% image resized for time efficiency. comment the resizing if you want to 
% see saliency map of image in original size
[rows,cols,~]=size(img);
if max(rows,cols) > 400
    img = imresize(img,400/max(rows,cols));
end

%%RGB to CIE LAB color space conversion
cform = makecform('srgb2lab');

tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lab = applycform(uint8(255*double(img)/double(max(img(:)))),cform);
lab = mat2gray( imfilter(lab, fspecial('gaussian', [3, 3])) );
l = uint8(mat2gray(lab(:,:,1))*255); 
a = uint8(mat2gray(lab(:,:,2))*255); 
b = uint8(mat2gray(lab(:,:,3))*255);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[s,cl,ca,cb] = spectrum2DwithMelCepstrumTrial(l,a,b); % s is the saliency map
s = medfilt2(s,[5 5]);
s = mat2gray( imfilter(s, fspecial('gaussian', [5, 5])) );
s = sqrt(s); %added later for scaling the salient values

% % Below enhancement function on the final saliency map is used as in the reference below:
% % Nevrez Imamoglu, Weisi Lin, and Yuming Fang: A Saliency Detection Model Using Low-Level Features Based on Wavelet Transform. 
% % IEEE Transactions on Multimedia 15(1): 96-105 (January 2013)
s = funSaliencyEnhance(s);
toc

figure;
subplot(2,3,1); imshow(img,[]); title('color image')
subplot(2,3,2); imshow(s,[]); title('saliency map result')
subplot(2,3,4); imshow(cl,[]); title('saliency of luminance')
subplot(2,3,5); imshow(ca,[]); title('saliency of chromacy a')
subplot(2,3,6); imshow(cb,[]); title('saliency of chromacy b')



