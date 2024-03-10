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

# ╔═╡ 32765e95-3c67-42c4-bf02-c9e2859bdebe
begin
	import Pkg
	Pkg.activate(".")
end

# ╔═╡ b34822fb-8b30-4f03-abad-c1463b0a2289
begin
	using Colors, ColorVectorSpace
	using PlutoUI
	using Plots
end

# ╔═╡ c5e3fcc2-db9f-11ee-0d27-bbd9be9f57f9
md"
- RangeSlider(1:2:10, show_value=true)
- Slider(1:2:10, show_value=true)
"

# ╔═╡ 2ab36214-a24d-44be-968f-b6ec91d6ef24
@bind T Slider(0.01:0.01:10, show_value=true) # sampling period

# ╔═╡ 35831e94-62ea-47d7-899b-c9581eae04e3
@bind time RangeSlider(-10:T:10, show_value=true)

# ╔═╡ 5c7a47cc-268c-4da1-8eac-d1c8bb222342
@bind ω Slider(0:0.01:1, show_value=true)

# ╔═╡ 18e9c106-a955-46f8-a045-4880e3886957
begin
	# Continuous time:
	continuous_time = -10:0.001:10
	
	# Dirac delta:
	δ(t) = 1

	# Train pulse
	scatter(time, δ.(time))

	# Example function
	f(t) = sin(t)
	plot!(continuous_time, f.(continuous_time))

	# Sampled example function:
	scatter!(time, δ.(time).*f.(time))
end

# ╔═╡ 6be14323-6cfc-4194-8b4c-b8b22e7a7388
begin
	acc = 0
	scatter()
	println(T)
	
	for n in -2:2
		point = (1/T)*exp(im*n*(2π/T)*3)
		println(string(n*2π/T," --- ", point))
		println(mod(n*2π/T, 2π))
		acc += point
		scatter!([real(point)], [imag(point)], aspect_ratio=:equal, label=string("point", n))
	end
	scatter!([real(acc)], [imag(acc)], label="sum")

	span = max(norm(acc), 1/T)
	span = 1.1*span
	xlims!(-span, span)
	ylims!(-span, span)
end

# ╔═╡ df8738ba-5aa1-4661-b104-714f5d1e007e
begin
	x_axis = -10:0.01:10
	sampling_period = 0.1
	h(t) = (sin((π/sampling_period)*t))/((π/sampling_period)*t)

	plot(x_axis, h.(x_axis))
end

# ╔═╡ Cell order:
# ╠═32765e95-3c67-42c4-bf02-c9e2859bdebe
# ╠═b34822fb-8b30-4f03-abad-c1463b0a2289
# ╠═c5e3fcc2-db9f-11ee-0d27-bbd9be9f57f9
# ╠═2ab36214-a24d-44be-968f-b6ec91d6ef24
# ╠═35831e94-62ea-47d7-899b-c9581eae04e3
# ╠═5c7a47cc-268c-4da1-8eac-d1c8bb222342
# ╠═18e9c106-a955-46f8-a045-4880e3886957
# ╠═6be14323-6cfc-4194-8b4c-b8b22e7a7388
# ╠═df8738ba-5aa1-4661-b104-714f5d1e007e
