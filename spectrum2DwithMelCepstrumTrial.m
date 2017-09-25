function [s,cl,ca,cb] = spectrum2DwithMelCepstrumTrial(l,a,b)
% I is 2D image data  

[ROW,COL] = size(l);

%make each channel square matrix
lp = myfunpadding(l,ROW,COL);
ap = myfunpadding(a,ROW,COL);
bp = myfunpadding(b,ROW,COL);

if ROW >= COL
    MAXSIZE = ROW;
else
    MAXSIZE = COL;   
end

[flA,flP] = funSpectralData(lp,MAXSIZE);
[faA,faP] = funSpectralData(ap,MAXSIZE);
[fbA,fbP] = funSpectralData(bp,MAXSIZE);

%grid values on u and v axis as 2^grid value = [1 2 4 8 16 32 ....]
MAX_GRID_ID_ON_1D = floor(log2(MAXSIZE/2)) + 1;
fg = 2.^( 0:MAX_GRID_ID_ON_1D );


% weights size 400x400 matrix as (this can change)
% [ 1.0000    0.7071    0.5000    0.3536    0.2500    0.1768    0.1250    0.0884    0.0625 ]
wg = sqrt( (sort(fg,'descend')/sum(sort(fg,'descend')))/max(sort(fg,'descend')/sum(sort(fg,'descend'))) );

rc = (MAXSIZE + 1)/2;
cc = (MAXSIZE + 1)/2;
%row and column distances separately on u and v axis respectively
for k = 1:MAXSIZE
    for m = 1:MAXSIZE
        distanceU(k,m) = round(k-rc);
        distanceV(k,m) = round(m-cc);
    end
end


% gridDistanceIndex = [-sort(fg,'descend') fg] result as below to create grids based
% on distance matrices distanceU and distanceV; for example,  for a size of 400x400 matrix, it will be
% [-256  -128   -64   -32   -16    -8    -4    -2    -1     1     2     4     8    16    32    64   128   256]
gridDistance = [-sort(fg,'descend') fg];

fl = flA;
fa = faA;
fb = fbA;
for gridRow = gridDistance%1:length(gridDistance)
    for gridCol = gridDistance%1:length(gridDistance)
        
        %create grid region on U axis
        if gridRow == -1
            uArea = (distanceU >= gridRow) .* (distanceU < 0);
        elseif gridRow == 1
            uArea = (distanceU <= gridRow) .* (distanceU > 0);
        elseif gridRow < -1
            uArea = (distanceU >= gridRow) .* ( distanceU < (gridRow/2) );
        elseif gridRow > 1
            uArea = (distanceU <= gridRow) .* ( distanceU > (gridRow/2) );
        end
        
        %create grid region on Y axis
        if gridCol == -1
            vArea = (distanceV >= gridCol) .* (distanceV < 0);
        elseif gridCol == 1
            vArea = (distanceV <= gridCol) .* (distanceV > 0);
        elseif gridCol < -1
            vArea = (distanceV >= gridCol) .* ( distanceV < (gridCol/2) );
        elseif gridCol >1
            vArea = (distanceV <= gridCol) .* ( distanceV > (gridCol/2) );
        end
        
        z = logical(uArea.*vArea);
        weight = 0.5 * ( wg( log2(abs(gridRow)) + 1 ) + wg( log2(abs(gridCol)) + 1 ) );
        fl(z) =  weight * mean(fl(z));
        fa(z) =  weight * mean(fa(z));
        fb(z) =  weight * mean(fb(z));

    end
end

flR = log( abs(flA - fl) + 1 );
faR = log( abs(faA - fa) + 1 );
fbR = log( abs(fbA - fb) + 1 );

lIR = abs(   ifft2( exp(flR + 1i*flP) )   ).^2;
aIR = abs(   ifft2( exp(faR + 1i*faP) )   ).^2; 
bIR = abs(   ifft2( exp(fbR + 1i*fbP) )   ).^2; 

cl = lIR(1:ROW,1:COL);
ca = aIR(1:ROW,1:COL);
cb = bIR(1:ROW,1:COL);

s = (cl + ca + cb)/3;

























