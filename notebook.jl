### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 32765e95-3c67-42c4-bf02-c9e2859bdebe
begin
	import Pkg
	Pkg.activate(".")
end

# ╔═╡ b34822fb-8b30-4f03-abad-c1463b0a2289
begin
	include("./utils.jl")
	include("./windows.jl")
	
	using Colors, ColorVectorSpace
	using PlutoUI
	using Plots
	using .Utils
	using .Windows
end

# ╔═╡ c5e3fcc2-db9f-11ee-0d27-bbd9be9f57f9
md"
- RangeSlider(1:2:10, show_value=true)
- Slider(1:2:10, show_value=true)
"

# ╔═╡ e6557b70-47fd-4385-8a6d-318caac95362
begin
	x_axis = -3*2π:0.01:2*3π
	T = 1
	H(Ω) = (1-exp(-im*Ω*T))/(im*Ω*T)

	plot(real(H.(x_axis)), imag(H.(x_axis)))
end

# ╔═╡ 45eb291c-645e-46bc-94c6-215abfd93392
plot(x_axis, norm.(H.(x_axis)))

# ╔═╡ edc32995-bfbb-4a11-bcca-6e6d1ac339e5


# ╔═╡ Cell order:
# ╠═32765e95-3c67-42c4-bf02-c9e2859bdebe
# ╠═b34822fb-8b30-4f03-abad-c1463b0a2289
# ╠═c5e3fcc2-db9f-11ee-0d27-bbd9be9f57f9
# ╠═e6557b70-47fd-4385-8a6d-318caac95362
# ╠═45eb291c-645e-46bc-94c6-215abfd93392
# ╠═edc32995-bfbb-4a11-bcca-6e6d1ac339e5
