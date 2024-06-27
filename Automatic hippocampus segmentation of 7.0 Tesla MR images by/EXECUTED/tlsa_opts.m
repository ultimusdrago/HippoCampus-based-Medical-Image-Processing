function opts = tlsa_opts(opts,data)
    
   
    % default options
    def_opts.nIter = 50;                                 % number of VEM iterations
    def_opts.K = 50;                                     % number of sources
    def_opts.nu = 1;                                     % prior on tau (shape)
    def_opts.rho = 1;                                    % prior on tau (scale)
    def_opts.beta = 0.01;                                % coupling parameter
    
    D = size(data(1).R,2);
    
    if D == 4 % spatiotemporal RBF: 3 spatial dimensions, 1 temporal dimension
        def_opts.mapfun = @(theta,R) map_st_rbf(theta,R);    % mapping function
        def_opts.Lambda0 = diag([1e-5 1e-5 1e-5 10 1e-5 10]); % prior precision
        def_opts.omega_bar = [0 0 0 log(0.1) 0 log(0.1)];    % prior mean
        def_opts.omega_ub = [inf inf inf 0 inf 0];           % parameter upper bounds
        def_opts.omega_lb = -[inf inf inf 4 inf 4];          % parameter lower bounds
    elseif D == 3 % spatial RBF: 3 spatial dimensions
        def_opts.mapfun = @(theta,R) map_rbf(theta,R);       % mapping function
        def_opts.Lambda0 = diag([1e-5 1e-5 1e-5 10]);         % prior precision
        def_opts.omega_bar = [0 0 0 log(0.1)];               % prior mean
        def_opts.omega_ub = [inf inf inf 0];                 % parameter upper bounds
        def_opts.omega_lb = -[inf inf inf 4];                % parameter lower bounds
    elseif D == 2 % spatial RBF: 2 spatial dimensions (brain slice)
        def_opts.mapfun = @(theta,R) map_rbf(theta,R);       % mapping function
        def_opts.Lambda0 = diag([1e-5 1e-5 10]);              % prior precision
        def_opts.omega_bar = [0 0 log(0.1)];                 % prior mean
        def_opts.omega_ub = [inf inf 0];                     % parameter upper bounds
        def_opts.omega_lb = -[inf inf 4];                    % parameter lower bounds
    end
    
    % set missing options
    if isempty(opts)
        opts = def_opts;
    else
        F = fieldnames(def_opts);
        for f = 1:length(F)
            if ~isfield(opts,F{f}) || (~iscell(opts.(F{f})) && isempty(opts.(F{f})))
                opts.(F{f}) = def_opts.(F{f});
            end
        end
    end