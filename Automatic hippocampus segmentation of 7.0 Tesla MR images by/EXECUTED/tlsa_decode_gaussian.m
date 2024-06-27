function [mu iS] = tlsa_decode_gaussian(data,testdata,results,mu0,iS0)
    
    
    for s = 1:length(data)
        
        % if no mean & precision given, estimate empirical (MLE) prior
        if nargin < 4
            [mu0 iS0] = tlsa_empirical_prior(data(s));
        end
        
        q = results.q(s);
        tau = q.rho*q.nu;
        F = tlsa_map(results.opts.mapfun,q.omega,data(s).R);
        A = q.W*F;
        iS{s} = iS0 + tau*(A*A');
        mu{s} = bsxfun(@plus,mu0*iS0,tau*testdata(s).Y*A')/iS{s};
    end
    
end

function [mu iS] = tlsa_empirical_prior(data,diagonalize)
    
    % Constructs an empirical prior for the covariates based on the training data.
    %
    % This prior is equivalent to the maximum likelihood estimates of
    % the mean and covariance matrix of a Gaussian.
    %
    % USAGE: [mu iS] = tlsa_empirical_prior(data,[diagonalize])
    %
    % INPUTS:
    %   data - data structure
    %   diagonalize (optional) - if 1, uses diagonal approximation of the
    %                           precision matrix (default: 1)
    %
    % OUTPUTS:
    %   mu - [1 x C] mean vector
    %   iS - [C x C] precision matrix
    %
    % Sam Gershman, Sep 2011
    
    if nargin < 2 || isempty(diagonalize); diagonalize = 1; end
    
    X = data.X;
    mu = mean(X);
    r = bsxfun(@minus,X,mu);
    Sigma = (r'*r)/size(X,1);
    if diagonalize
        iS = diag(1./(eps+diag(Sigma)));
    else
        iS = inv(Sigma);
    end
end