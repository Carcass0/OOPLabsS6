function runTest(start)
    asize = 7
    arr = Array{Vector}(undef, asize)
    arr[1] = [(2, 10), (4, 30), (5, 100)]
    arr[2] = [(3, 50)]
    arr[3] = [(5, 10)]
    arr[4] = [(3, 20), (5, 60)]
    arr[5] = [(2, 60)]
    arr[6] = []
    d = fill(Inf, asize)
    d[start] = 0
    u = fill(false, asize)
    p = fill(0, asize)
    for i = 1:asize
        v = -1
        for j= 1:asize
            if (!u[j] && (v==-1 || d[j] < d[v]))
                v = j
            end
        end
        if (d[v] == Inf)
            break;
        end
        u[v] = true
        for j = 1:length(arr[v])
            to = arr[v][j][1]
            len = arr[v][j][2]
            if (d[v] + len < d[to])
                d[to] = d[v] + len
                p[to] = v
            end
        end
    end
    for k = 1:asize
        path = []
        v=k
        while !(v==start)
            try
                v = p[v]
            catch e
                path = [0]
                break
            end
            push!(path,v)
        end
        path = reverse(path)
        println(path)
    end
    println(d)
end


runTest(1)