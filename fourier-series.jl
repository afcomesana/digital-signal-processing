### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ fb1a38d5-13e6-4b14-b1ed-f965549608db
begin
	import Pkg
	Pkg.activate(".")
end

# ╔═╡ 38121088-dd6d-11ee-35ce-e783bd2a5937
begin
	using Plots
	using PlutoUI
end

# ╔═╡ fb6aa11c-0b5f-47b7-be67-5cff2ba71647
@bind waves_num Slider(1:1000, show_value=true)

# ╔═╡ a993a232-0637-4554-80dd-84c19a1e01a0
begin
	x_axis = 0:0.001:1
	heat(t) = if t < 0.5; return 1; else; return -1; end

	plot(x_axis, heat.(x_axis), label="Pulse")

	sin_sum = zeros(size(x_axis))
	
	for n in 1:waves_num
		freq = (n*2)-1
		ω = 2π*freq
		current_sin = sin.(ω*x_axis)./freq
		plot!(x_axis, current_sin, label=false)
		sin_sum.+=current_sin
	end

	sin_sum .*= 4/π
	
	plot!(x_axis, sin_sum, label="Approximation")
end

# ╔═╡ Cell order:
# ╠═fb1a38d5-13e6-4b14-b1ed-f965549608db
# ╠═38121088-dd6d-11ee-35ce-e783bd2a5937
# ╠═fb6aa11c-0b5f-47b7-be67-5cff2ba71647
# ╠═a993a232-0637-4554-80dd-84c19a1e01a0
