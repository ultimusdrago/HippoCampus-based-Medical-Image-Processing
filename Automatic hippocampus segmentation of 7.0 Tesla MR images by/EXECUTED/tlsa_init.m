function q = tlsa_init(opts,data)
    
   
    
    K = opts.K;
    D = size(data(1).R,2);
    if D == 4
        M = 6;  % spatiotemporal RBF: 3 spatial dimensions, 1 temporal dimension
    elseif D == 3
        M = 4;  % spatial RBF: 3 spatial dimensions
    elseif D == 2
        M = 3;  % spatial RBF: 2 spatial dimensions (brain slice)
    end
    mu = zeros(K,D);
    omega = zeros(K,M);
    vx = zeros(K,1);
    
    % construct average image
    Y = []; for s = 1:length(data); Y=[Y; data(s).Y]; end
    y = mean(Y,1);
    
    % Find the maximum of the average image, put a source there, then
    % subtract it from the average image
    for k = 1:K
        y = (y-min(y))/(max(y)-min(y)); % rescale average image to [0,1]
        [~,vx(k)] = max(y);
        r = data(1).R(vx(k),:);
        r(r==0) = 1e-5; r(r==1) = 1-1e-5;
        mu(k,:) = log(r./(1-r));
        if D == 4
            omega(k,:) = [mu(k,1:D-1) opts.omega_bar(D) mu(k,D) opts.omega_bar(end)];
        else
            omega(k,:) = [mu(k,:) opts.omega_bar(D+1)];
        end
        f = tlsa_map(opts.mapfun,omega(k,:),data(1).R);
        y = y - f;
    end
    
    % Each subject gets the same initial set of source parameters
    for s = 1:length(data)
        q(s).omega = omega;
        [N V] = size(data(s).Y);
        q(s).nu = opts.nu + N*V/2;
        q(s).rho = 1/q(s).nu;
    end