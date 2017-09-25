function [fISA,fISP] = funSpectralData(I,MAXSIZE)

%%FFT of the input image
fI = fft2(single(I),MAXSIZE,MAXSIZE);
fIS = fftshift(fI);

%Amplitude Spectrum
fISA = abs(fIS);

%%Phase spectrum
fISP = angle(fIS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%