mutable struct MyGraph
    nodeNum::Int
    capacities::Matrix{Int}
    currentFlows::Matrix{Int}
end


function resCapacity(graph, u, v)
    return graph.capacities[u, v] - graph.currentFlows[u, v]
end


function bfs(graph, source, sink, parent)
    visited = falses(graph.nodeNum)
    queue = [source]
    visited[source] = true
    while !isempty(queue)
        u = popfirst!(queue)
        for v in 1:graph.nodeNum
            if !visited[v] && resCapacity(graph, u, v) > 0
                push!(queue, v)
                visited[v] = true
                parent[v] = u
            end
        end
    end
    return visited[sink]
end


function edmondsKarp(graph, source, sink)
    parent = fill(-1, graph.nodeNum)
    potok = 0
    while bfs(graph, source, sink, parent)
        pathFlow = Inf
        v = sink
        while v != source
            u = parent[v]
            pathFlow = min(pathFlow, resCapacity(graph, u, v))
            v = u
        end
        v = sink
        while v != source
            u = parent[v]
            graph.currentFlows[u, v] += pathFlow
            graph.currentFlows[v, u] -= pathFlow
            v = u
        end
        potok += pathFlow
    end
    return potok
end


function addEdge!(graph, u, v, capacity)
    graph.capacities[u, v] = capacity
    graph.capacities[v, u] = capacity
end


function initFlows(graph)
    graph.currentFlows = zeros(Int, graph.nodeNum, graph.nodeNum)
end


function initGraph()
    g = MyGraph(6, zeros(Int, 6, 6), zeros(Int, 6, 6))
    addEdge!(g, 1, 2, 7)
    addEdge!(g, 1, 3, 5)
    addEdge!(g, 2, 4, 3)
    addEdge!(g, 2, 5, 4)
    addEdge!(g, 3, 4, 2)
    addEdge!(g, 3, 5, 3)
    addEdge!(g, 4, 6, 4)
    addEdge!(g, 5, 6, 7)
    return g
end


function runTest()
    graph = initGraph()
    initFlows(graph)
    potok = edmondsKarp(graph, 1, 6)
    println("Максимальный поток в графе: ", potok)
end


runTest()
