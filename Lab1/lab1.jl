mutable struct RungeKuttMethod
    size::UInt16
    currentTime::Float64
    solution::Array{Float64}
    YY::Array{Float64}
    Y1::Array{Float64}
    Y2::Array{Float64}
    Y3::Array{Float64}
    Y4::Array{Float64}
    FY::Array{Float64}
end


function initializer(startTime::Float64, inintialCondition::Array{Float64})
    l = length(inintialCondition)
    rungeKutt = RungeKuttMethod(l, startTime, inintialCondition, zeros(Float64, l), zeros(Float64, l), zeros(Float64, l), zeros(Float64, l), zeros(Float64, l), zeros(Float64, l))
    return rungeKutt
end


function F(t::Float64, Y::Array{Float64}, rungeKutt::RungeKuttMethod)
    rungeKutt.FY[1] = Y[2];
    rungeKutt.FY[2] = -Y[1];
    return (rungeKutt.FY, rungeKutt);
end


function nextStep(dt::Float16, rungeKutt::RungeKuttMethod)
    if dt<0
        return
    end
    rungeKutt.Y1, rungeKutt = F(rungeKutt.currentTime, rungeKutt.solution, rungeKutt)
    for i = 1:rungeKutt.size
        rungeKutt.YY[i] = rungeKutt.solution[i] + rungeKutt.Y1[i] * (dt / 2.0)
    end
    rungeKutt.Y2, rungeKutt = F(rungeKutt.currentTime + dt / 2.0, rungeKutt.YY, rungeKutt)
    for i = 1:rungeKutt.size
        rungeKutt.YY[i] = rungeKutt.solution[i] + rungeKutt.Y2[i] * (dt / 2.0);
    end
    rungeKutt.Y3, rungeKutt = F(rungeKutt.currentTime + dt / 2.0, rungeKutt.YY, rungeKutt)
    for i = 1: rungeKutt.size
        rungeKutt.YY[i] = rungeKutt.solution[i] + rungeKutt.Y3[i] * dt;
    end
    rungeKutt.Y4, rungeKutt = F(rungeKutt.currentTime + dt, rungeKutt.YY, rungeKutt)
    for i = 1:rungeKutt.size
        rungeKutt.solution[i] = rungeKutt.solution[i] + dt / 6.0 * (rungeKutt.Y1[i] + 2.0 * rungeKutt.Y2[i] + 2.0 * rungeKutt.Y3[i] + rungeKutt.Y4[i]);
    end
    rungeKutt.currentTime = rungeKutt.currentTime + dt;
    return rungeKutt
end


function testInitialize()
    start::Float64 = 0.0
    init::Array{Float64} = [0.0, 1.0]
    rungeKutt = initializer(start, init)
    dt::Float16 = 0.001
    while rungeKutt.currentTime <= 15
        print("Time = $(rungeKutt.currentTime); Func = $(rungeKutt.solution[1]); d Func/ d x = $(rungeKutt.solution[2])\n")
        rungeKutt = nextStep(dt, rungeKutt)
    end
end


testInitialize()
