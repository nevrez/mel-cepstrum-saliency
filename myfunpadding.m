function out = myfunpadding(I,ROW,COL)

if ROW >= COL
    MAXSIZE = ROW;
    I2 = uint8(zeros(MAXSIZE,MAXSIZE));
    I2(:,1:COL) = I; 
    
    lastcolumn = I(:,COL);
    paddingtemp = repmat(lastcolumn,1,MAXSIZE-COL);
    
    I2(:,COL+1:end) = paddingtemp;
    
else
    MAXSIZE = COL;
    I2 = uint8(zeros(MAXSIZE,MAXSIZE));
    
    I2(1:ROW,:) = I; 
    
    lastrow = I(ROW,:);
    paddingtemp = repmat(lastrow,MAXSIZE-ROW,1);
    
    I2(ROW+1:end,:) = paddingtemp;
    
end

out = I2;