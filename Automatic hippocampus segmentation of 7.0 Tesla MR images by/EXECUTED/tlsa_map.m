function [F df] = tlsa_map(mapfun,omega,R,F,df)
    
   
    
    V = size(R,1);
    K = size(omega,1);
    if nargin < 4
        F = zeros(K,V);
    end
    if nargin < 5 && nargout > 1
        df = cell(1,K);
    end
    
    for k = 1:K
        if nargout > 1
            [F(k,:) df{k}] = mapfun(omega(k,:),R);
        else
            F(k,:) = mapfun(omega(k,:),R);
        end
    end