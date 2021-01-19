function [ krnelN ] = calcLoG( sigma )
  kSize = ceil(sigma*4*sqrt(2));
  if rem(kSize,2)==0 kSize=kSize+1; end
  hSize=floor(kSize/2);
  
  [X,Y]=meshgrid(-hSize:hSize,-hSize:hSize);
  krnel=((X.^2+Y.^2-2*(sigma^2))./(sigma^4)).*exp(-(X.^2+Y.^2)./(2*sigma^2));

  % calculate kernel with integer coefficients (sum of matrix is 0)
  krnel = krnel-(mean(krnel(:)));
  mSuma=sum(round(krnel(:).*(-1.49/krnel(hSize+1,1))));
  valS=-1.49;
  for v=-1.48:0.01:-0.50
    suma=sum(round(krnel(:).*(v/krnel(hSize+1,1))));
    if ((abs(mSuma)>abs(suma)))
      mSuma=suma;
      valS=v;
    end
  end
  krnelN=round(krnel.*(valS/krnel(hSize+1,1)));
%   hs=surf(X,Y,krnel);hs.EdgeColor='none';
%   title(sprintf('LoG filter: \\sigma = %d',sigma));
%   xlabel('X');ylabel('Y');
end

