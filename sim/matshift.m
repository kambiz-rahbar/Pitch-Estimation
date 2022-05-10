function [res] = matshift(x, sh)
    rows = size(x,1);
    if rows > 1
        x = reshape(x,1,[]);
    end

    if sh > 0
        res = [x(sh+1:end) zeros(size(x(1:sh)))];
    else
        res = [zeros(size(x(1:-sh))) x(1:end+sh)];
    end

    if rows > 1
        res = reshape(res,[],1);
    end
end
