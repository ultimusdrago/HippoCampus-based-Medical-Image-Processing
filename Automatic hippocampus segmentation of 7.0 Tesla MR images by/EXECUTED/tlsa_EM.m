function results = tlsa_EM(data,opts,q)
    
   
    if nargin < 2; opts = []; end
    opts = tlsa_opts(opts,data);            
    if length(data)==1 && opts.beta > 0
        warning('You are fitting single-subject data; you should set opts.beta=0');
    end
    
    
    K = opts.K;                             
    S = length(data);
    if (nargin < 3) || isempty(q)
        disp('Initializing...');
        q = tlsa_init(opts,data);           
    end
    M = length(opts.omega_bar);
    q0.beta = repmat([opts.beta opts.beta],M,1);
    if opts.beta==0
        G = repmat(opts.Lambda0*opts.omega_bar',1,K);
        L = opts.Lambda0;
    end
    
    
    tic;
    for i = 1:opts.nIter
        
        
        if opts.beta > 0
            L = diag(q0.beta(:,1).*q0.beta(:,2));
            omega = zeros(K,M); for s = 1:S; omega = omega + q(s).omega; end
            iS = S*L + opts.Lambda0;
            q0.omega0 = bsxfun(@plus,opts.omega_bar*opts.Lambda0,omega*L)/iS;
            q0.omega = bsxfun(@min,q0.omega0,opts.omega_ub);    
            q0.omega = bsxfun(@max,q0.omega0,opts.omega_lb);
            G = L*q0.omega0';   
            
            
            for m = 1:M
                h=0; for s = 1:S; h = h + sum((q(s).omega(:,m)-q0.omega0(:,m)).^2); end
                q0.beta(m,1) = opts.beta + 0.5*S*K;
                q0.beta(m,2) = 1/(1/opts.beta + 0.5*h);
            end
        end
        
        
        for s = 1:S
            
           
            [F df] = tlsa_map(opts.mapfun,q(s).omega,data(s).R);
            q(s).W = data(s).X \ data(s).Y / F; 
            yhat = data(s).X*q(s).W*F;              
            res = data(s).Y-yhat;                   
            err = res(:)'*res(:);                  
            tau = q(s).nu*q(s).rho;                 
            A = data(s).X*q(s).W;
            tr = 0;
            for k = 1:K
                JJ = (A(:,k)'*A(:,k))*(df{k}*df{k}');
                iSigma = tau*JJ + L;
                tr = tr + trace(iSigma\JJ);
                h = A(:,k)*q(s).omega(k,:)*df{k};
                q(s).omega(k,:) = iSigma\(tau*(A(:,k)'*(h+res)*df{k}')'+G(:,k));
            end
            q(s).omega = bsxfun(@min,q(s).omega,opts.omega_ub); 
            q(s).omega = bsxfun(@max,q(s).omega,opts.omega_lb);
            
           
            q(s).rho = 1/(1/opts.rho + 0.5*err + 0.5*tr);
        end
        
        if ~mod(i,10)
            disp(['iteration ',num2str(i)]);
        end
    end
    toc
    
   
    results.opts = opts;
    results.q = q;
    if opts.beta > 0; results.q0 = q0; end