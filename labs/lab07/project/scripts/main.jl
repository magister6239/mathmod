using DrWatson
@quickactivate "project"
using DifferentialEquations, Plots


N = 901.0
n0 = 9.0
tspan = (0.0, 30.0)

function reklama1!(du, u, p, t)
    n = u[1]
    a1 = 0.91
    a2 = 0.00019
    du[1] = (a1 + a2 * n) * (N - n)
end

function reklama2!(du, u, p, t)
    n = u[1]
    a1 = 0.000081
    a2 = 0.18
    du[1] = (a1 + a2 * n) * (N - n)
end

function reklama3!(du, u, p, t)
    n = u[1]
    a1 = 0.2 * sin(2t)
    a2 = 0.4 * cos(4t)
    du[1] = (a1 + a2 * n) * (N - n)
end

prob1 = ODEProblem(reklama1!, [n0], tspan)
sol1 = solve(prob1, saveat=0.005)

prob2 = ODEProblem(reklama2!, [n0], tspan)
sol2 = solve(prob2, saveat=0.005)

prob3 = ODEProblem(reklama3!, [n0], tspan)
sol3 = solve(prob3, saveat=0.005)

plt = plot(sol1, label="Случай 1", xlabel="t", ylabel="n(t)")
plot!(plt, sol2, label="Случай 2", linestyle=:dash)
plot!(plt, sol3, label="Случай 3", linestyle=:dot)
title!(plt, "Распространение рекламы")
savefig(plotsdir("reklama_all.png"))

t2 = sol2.t
n_vals = sol2[1,:]
dn2 = [ (0.000081 + 0.18 * n) * (N - n) for n in n_vals ]
peak_idx = argmax(dn2)
t_peak = t2[peak_idx]
println("Максимальная скорость роста в случае сарафанного радио достигается при t = ", t_peak)

figure2 = plot(t2, dn2, label="Скорость dn/dt (Сарафанное радио)", xlabel="t", ylabel="dn/dt")
scatter!([t_peak], [dn2[peak_idx]], label="Максимум")
savefig(plotsdir("skorost.png"))
