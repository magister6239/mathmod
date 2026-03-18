using DrWatson
@quickactivate "project"
using DifferentialEquations, Plots
gr(format=:png)

x0 = 27300.0
y0 = 20400.0
u0 = [x0; y0]

a1 = 0.405;
b1 = 0.7;
c1 = 0.68;
h1 = 0.37;

P1(t) = sin(t + 8) + 1
Q1(t) = cos(t + 6) + 1

a2 = 0.304;
b2 = 0.78;
c2 = 0.68;
h2 = 0.2;

P2(t) = 2*sin(2t)
Q2(t) = 2*cos(2t)

tspan = (0.0, 10.0)

function reg!(du, u, p, t)
    x, y = u
    du[1] = -a1*x - b1*y + P1(t)
    du[2] = -c1*x - h1*y + Q1(t)
end

function part!(du, u, p, t)
    x, y = u
    du[1] = -a2*x - b2*y + P2(t)
    du[2] = -c2*x*y - h2*y + Q2(t)
end


prob1 = ODEProblem(reg!, u0, tspan)
sol1 = solve(prob1, saveat=0.05)

prob2 = ODEProblem(part!, u0, tspan)
sol2 = solve(prob2, saveat=0.05)

plt1 = plot(sol1, vars=(0,1), label="x(t) - регулярная", xlabel="Время t", ylabel="Численность")
plot!(plt1, sol1, vars=(0,2), label="y(t) - регулярная", lw=2)
title!("Модель регулярных войск (вариант 20)")

plt2 = plot(sol2, vars=(0,1), label="x(t) - смешанная", xlabel="Время t", ylabel="Численность")
plot!(plt2, sol2, vars=(0,2), label="y(t) - смешанная", lw=2)
title!("Модель с партизанами (вариант 20)")

savefig(plt1, plotsdir("lanchester_reg.png"))
savefig(plt2, plotsdir("lanchester_part.png"))
display(plt1)
display(plt2)

function find_winner(sol)
    t_vals = sol.t
    x_vals = [u[1] for u in sol.u]
    y_vals = [u[2] for u in sol.u]
    for i in 1:length(t_vals)
        if x_vals[i] <= 0 && y_vals[i] > 0
            return "X проиграла в момент t = $(t_vals[i])"
        elseif y_vals[i] <= 0 && x_vals[i] > 0
            return "Y проиграла в момент t = $(t_vals[i])"
        elseif x_vals[i] <= 0 && y_vals[i] <= 0
            return "Обе армии уничтожены в момент t = $(t_vals[i])"
        end
    end
    return "За время моделирования ни одна из сторон не уничтожена (возможно, затяжная война)"
end

println("Результат для регулярной модели: ", find_winner(sol1))
println("Результат для смешанной модели: ", find_winner(sol2))
