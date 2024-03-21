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

# ╔═╡ 13579840-e113-11ee-12c1-e547e5edf8af
begin
	import Pkg
	Pkg.activate(".")
end

# ╔═╡ 16864bb0-8b9b-4f88-9412-8d62f927da8b
begin
	using Plots
	using PlutoUI
	import .Utils
end

# ╔═╡ e716a53d-f611-4c9c-9882-bb80caf81b06
md"### Discrete Time Fourier Transform and its Inverse"

# ╔═╡ 8cbc44c6-20cf-455b-bb36-98b260ea5d4e
@bind dft_x_axis RangeSlider(-10:0.4:10, show_value=true)

# ╔═╡ fdcfeeef-6035-4acd-8afd-b2deafd23a75
begin
	# Points in the signal (N)
	N = size(dft_x_axis)[1]

	# Where DFT will be computed: 0 to N-1
	dft_signal_axis = 0:N-1
end

# ╔═╡ 31b3e108-b296-427f-848f-89d814a3bfd0
@bind dft_displacement Slider(-5:5, show_value=true, default=0)

# ╔═╡ 544f5abc-1016-4303-9a64-f87cd1f4fbcb
begin
	# Test signal
	dft_signal = sin.(dft_x_axis .+ dft_displacement)
	
	#=
	In a signal with N points, we only compute the DFT at the following
	equally-spaced points in the unit (complex) circle:
	=#
	unit_circle_points = exp.(dft_signal_axis.*(im*2π/N))

end

# ╔═╡ b652b1c7-2434-4762-ad98-c4a9cf1c22e3
let
	l = @layout [a; b; c d]

	s1 = scatter(dft_x_axis, dft_signal, title="Original signal", legend=false)
	
	s2 = scatter(
		real(unit_circle_points),
		imag(unit_circle_points),
		aspect_ratio=:equal,
		legend=false,
		title="DFT points"
	)

	signal_DFT = Utils.DFT(dft_signal)
	
	s3 = scatter(real(signal_DFT), imag(signal_DFT), title="DFT", legend=false)

	s4 = scatter(dft_signal_axis, real(iDFT(signal_DFT)), title="iDFT of the DFT of the signal", legend=false)

	plot(s1, s4, s3, s2, layout=l)
	
end

# ╔═╡ 5494381e-3bd7-4ccd-b1ff-3d0f9a2b4549
md"### Convolution of two signals"

# ╔═╡ adf5c527-d0fb-4c22-95b0-0c6fb8a9a607
@bind conv_n Slider(-5:0.1:5, show_value=true, default=0)

# ╔═╡ 5f234916-17a0-4131-ac68-5c94a4081ef7
let
	l = @layout [e f; a; b; c]
	x_axis = -5:0.01:5
	width = 1
	f(x) = convert(Int, abs(x) < width/2)
	g(x) = convert(Int, abs(x) < width)*(1-abs(x))

	p_f_0 = plot(x_axis, f.(x_axis), label="f(x)", aspect_ratio=:equal)
	p_f_1 = plot(x_axis, g.(x_axis), label="g(x)", aspect_ratio=:equal)

	multiplied_signals = f.(x_axis).*g.(conv_n.-x_axis)

	conv = map(x -> sum(f.(x_axis).*g.(x.-x_axis)), x_axis)
	
	p1 = plot(x_axis, f.(x_axis), aspect_ratio=:equal, label="f(x)")
	plot!(p1, x_axis, g.(conv_n.-x_axis), label="g(n-x)")
	
	p2 = plot(x_axis, multiplied_signals, aspect_ratio=:equal, label="f(x)*g(n-x)")
	
	p3 = plot(x_axis, conv, label="f(x) conv g(x)")
	vline!([conv_n], label=round(sum(multiplied_signals), digits=3))

	plot(p_f_0, p_f_1, p1, p2, p3, layout=l)
end

# ╔═╡ e7af2159-6667-40f3-a9fb-c5352d71a8ea
md"### Visual demonstration of why $e^{jk(m-n)\frac{2π}{N}}$ is 0 everywhere but where m = n"

# ╔═╡ 61006099-0ab4-4790-8dc2-6d0c3fd28553
@bind new_N Slider(2:1000, show_value=true, default=100)

# ╔═╡ cefbaf88-4579-41a2-855c-cd89601f7a0f
new_Ω_axis = 0:new_N-1

# ╔═╡ 522016a9-881e-4a7b-b0d5-3bd68287e636
@bind m Slider(new_Ω_axis, show_value=true)

# ╔═╡ 22334b12-a3c3-48eb-9480-80ebf47af041
@bind n Slider(new_Ω_axis, show_value=true)

# ╔═╡ 77b158fa-5d42-47c7-81f4-7a577de88e64
begin
	
	points = exp.(im*new_Ω_axis*(m-n)*2π/new_N)
	scatter(
		real(points),
		imag(points),
		aspect_ratio=:equal,
		xlims=(-1.1, 1.1),
		ylims=(-1.1, 1.1),
		legend=false
	)
end

# ╔═╡ Cell order:
# ╠═13579840-e113-11ee-12c1-e547e5edf8af
# ╠═16864bb0-8b9b-4f88-9412-8d62f927da8b
# ╠═e716a53d-f611-4c9c-9882-bb80caf81b06
# ╠═8cbc44c6-20cf-455b-bb36-98b260ea5d4e
# ╠═fdcfeeef-6035-4acd-8afd-b2deafd23a75
# ╠═31b3e108-b296-427f-848f-89d814a3bfd0
# ╠═544f5abc-1016-4303-9a64-f87cd1f4fbcb
# ╠═b652b1c7-2434-4762-ad98-c4a9cf1c22e3
# ╠═5494381e-3bd7-4ccd-b1ff-3d0f9a2b4549
# ╠═adf5c527-d0fb-4c22-95b0-0c6fb8a9a607
# ╠═5f234916-17a0-4131-ac68-5c94a4081ef7
# ╠═e7af2159-6667-40f3-a9fb-c5352d71a8ea
# ╠═61006099-0ab4-4790-8dc2-6d0c3fd28553
# ╠═cefbaf88-4579-41a2-855c-cd89601f7a0f
# ╠═522016a9-881e-4a7b-b0d5-3bd68287e636
# ╠═22334b12-a3c3-48eb-9480-80ebf47af041
# ╠═77b158fa-5d42-47c7-81f4-7a577de88e64
