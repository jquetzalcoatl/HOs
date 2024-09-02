using Plots, Interact
using Blink: Window, body!
using YAML
w = Window()

begin
    include("./configs/yaml_loader.jl")
    config, _ = load_yaml_iter();
    t_start = config.parameters["t_start"]
    num_points = config.parameters["num_points"]
    PATH = config.dirs["fig_output"]
end


function harmonic_oscillator(k, m, x0, v0, t)
    ω = sqrt(k / m)
    x = @. x0 * cos(ω * t) + (v0 / ω) * sin(ω * t)
    p = @. m * v0 * cos(ω * t) - m * ω * x0 * sin(ω * t)
    return x,p
end

function plot_harmonic_oscillator(k, m, x0, v0, t_start, t_end, num_points)
    t = range(t_start, t_end, length=num_points)
    x,p = harmonic_oscillator(k, m, x0, v0, t)
    plot(t, x, xlabel="Time", label="Position", lw=2, frame=:box)
    plot!(t, p, xlabel="Time", label="Momentum", lw=2, frame=:box)
    plot!(size=(500,400))
end

ui = @manipulate for x0 in 0:0.01:1, v0 in 0.0:0.01:1.0, 
    t_end in 1:0.1:10, k in 0.1:0.01:1.0, m in 0.1:0.01:1.0, sav_fig in [false,true]
    f = plot_harmonic_oscillator(k, m, x0, v0, t_start, t_end, num_points)
    sav_fig ? savefig(f, PATH*"harmonic_oscillator.png") : nothing
    f
  end
  
  body!(w, ui)
