function [stat con] = tlsa_linear_contrast(results,eta,data,threshold)
    
   
    
    for s = 1:length(results.q)
        C(s,:) = eta'*results.q(s).W;
    end
    
    [~,p,~,stat] = ttest(C);
    stat.p = p;
    
    if nargout > 1
        if nargin < 4; threshold = 0.05; end
        ix = stat.p < threshold;
        for s = 1:length(results.q)
            F = tlsa_map(results.opts.mapfun,results.q(s).omega,data(s).R);
            con(s,:) = C(s,ix)*F(ix,:);
        end
        con = mean(con);
    end