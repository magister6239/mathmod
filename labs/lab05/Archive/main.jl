using DrWatson
using DifferentialEquations, Plots

gr(format=:png)

a = 0.61
b = 0.051
c = 0.41
d = 0.031

x0 = 6.0
y0 = 14.0
u0 = [x0, y0]
t = (0.0, 100.0)

function lotka_volterra!(du, u, p, t)
    x, y = u
    du[1] = -a*x + b*x*y
    du[2] =  c*y - d*x*y
end

prob = ODEProblem(lotka_volterra!, u0, t)
sol = solve(prob, saveat=0.1)

x_star = c / d
y_star = a / b

plt1 = plot(sol, vars=(0,1), label="Predators (x)", xlabel="Time", ylabel="Population")
plot!(plt1, sol, vars=(0,2), label="Prey (y)", lw=2)
title!("Predator-Prey dynamics")

x_vals = [u[1] for u in sol.u]
y_vals = [u[2] for u in sol.u]
plt2 = plot(x_vals, y_vals, label="Phase trajectory", xlabel="Predators (x)", ylabel="Prey (y)", aspect_ratio=:equal)
scatter!(plt2, [x_star], [y_star], label="Stationary point", markersize=6)

savefig(plotsdir("predator_prey_time.png"))
savefig(plotsdir("predator_prey_phase.png"))
display(plt1)
display(plt2)

println("Stationary state: x* = $(round(x_star, digits=3)), y* = $(round(y_star, digits=3))")
println("Initial conditions: x0 = $x0, y0 = $y0")
println("Min/max predators: $(round(minimum(x_vals), digits=2)) / $(round(maximum(x_vals), digits=2))")
println("Min/max prey: $(round(minimum(y_vals), digits=2)) / $(round(maximum(y_vals), digits=2))")
