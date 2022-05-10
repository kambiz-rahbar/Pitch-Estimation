function [F] = calc_pitch(n, x, sample_rate, sc, disp_res)
    % n: sample idx
    % x: signal
    % sc: scale factor
    
    % check inputs
    if length(n)~=length(x)
        n = 1:length(x);
    end
    
    if ~exist('disp_res','var')
        disp_res = 0;
    end
    
    sh = -floor(length(n)/2) : floor(sample_rate/2) : floor(length(n)/2);
    F = zeros(1, length(sh));
    for k = 1:length(sh)
        shift_x = matshift(x, sh(k));

        % calc signal window and apply it, calc corr
        xwin = gausswin(length(n),sc*sample_rate);
        
        win_x = xwin.*shift_x;
        
        r = xcorr(win_x, win_x);

        idx = 0; % r_xx[0]
        corr_idx = idx + length(n);
        signal_energy = r(corr_idx);
        
        normalized_r = r./signal_energy;
        
        % smooth normalized_r
        windowSize = 300; 
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        normalized_r = filter(b,a,normalized_r);

        % calc corr indeses, result win, and apply it
        nr = -length(n)+1:length(n)-1;
        nr = nr + min(n);
        
        rwin = gausswin(length(nr),sc*sample_rate);
        
        cnd = rwin < 0.4;
        r(cnd) = [];
        normalized_r(cnd) = [];
        nr(cnd) = [];
        
        % calc pitch
        [~, pks_loc] = findpeaks(normalized_r);
        
        if length(pks_loc)>=2
            T = (pks_loc(2)-pks_loc(1))/sample_rate;
            F(k) = 1 / T;
        else
            F(k) = nan;
        end
               
        % disp results
        if disp_res
            figure(disp_res+k-1);
            subplot(2,2,1); stem(n,shift_x); xlim([min(n) max(n)]); title('main signal');
            subplot(2,2,2); plot(shift_x, '.-'); hold on; plot(xwin, 'r'); plot(win_x, 'g'); legend('s','win','win_s'); title('windowed signal');
            subplot(2,2,3); stem(nr,r); xlim([min(nr) max(nr)]);  title('windowed AC');
            subplot(2,2,4); stem(nr,normalized_r); xlim([min(nr) max(nr)]);  title('windowed NAC'); 
        end
    end
end