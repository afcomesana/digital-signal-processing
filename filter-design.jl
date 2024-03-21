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

# ╔═╡ 9e2155b0-e5ff-11ee-2a8a-4b22abc37f49
begin
	import Pkg
	Pkg.activate(".")
end

# ╔═╡ 75921bed-8105-40fd-bbaa-e364fd68ab77
begin
	include("./modules.jl")
	import .Windows, .Transforms, .FrequencyFilters
	using Plots
	using PlutoUI
end

# ╔═╡ 1fa929ba-7b0c-4f06-8e7d-146ba2a54d23
html"
<h2>Discrete filter design steps</h2>
<ol>
<li>Specify ideal zero-phase frequency response</li>
<li>Calculate time response of the filter</li>
<li>Truncate using window</li>
</ol>
"

# ╔═╡ ef68ad3a-2da9-42dd-ba7c-08b0edd75044
html"<h3>1. Specify ideal zero-phase frequency response.</h3>"

# ╔═╡ 5835ca34-c3f7-487d-946d-c00cc06132d6
md"
Window type: $(@bind window_type Select([Windows.Rect => \"Rect\", Windows.Barlett => \"Barlett\", Windows.Hann => \"Hann\", Windows.Hanning => \"Hanning\", Windows.Blackman => \"Blackman\"]))

Window span (s): $(@bind window_span Slider(1:80, show_value=true))
"

# ╔═╡ 407f4ee6-a8d4-41bc-8541-7603c85fe9f6
begin
	l = @layout [a; b c; d e]

	time_resolution = freq_resolution = 0.01
	ω = -10π:freq_resolution:10π
	t = -100:time_resolution:100

	# Define filter:
	lp_filter = FrequencyFilters.LowPassFilter(1)

	# 1. Specify ideal zero-phase frequency response
	ideal_lp_freq = FrequencyFilters.apply_filter(ω, lp_filter)
	p1 = plot(
		ω,
		ideal_lp_freq,
		xlabel="ω",
		aspect_ratio=:equal,
		title="Ideal low pass filter zero-phase frequency response",
		legend=false
	)

	# 2. Calculate time response of the filter
	ideal_lp_time = FrequencyFilters.time_response(t, lp_filter)
	p2 = plot(
		t,
		real(ideal_lp_time),
		title="Impulse response",
		xaxis="time",
		legend=false
	)

	# 3. Truncate using window
	window_size = convert(Int, round(window_span/(time_resolution*2)))
	window_size -= 1
	
	window = Windows.window(window_type(window_size))
	diff_size = convert(Int, (size(ideal_lp_time)[1] - size(window)[1])/2)
	
	padded_window = vcat(zeros(diff_size), window, zeros(diff_size))
	
	p3 = plot(t, padded_window)

	windowed_ideal_lp_time = ideal_lp_time.*padded_window
	
	p4 = plot(t, real(windowed_ideal_lp_time))

	# Inverse of the truncated impulse response
	freq_response_windowed_ideal_lp = Transforms.frequency_response(windowed_ideal_lp_time)

	p5 = plot(
		# (1:size(freq_response_windowed_ideal_lp)[1])[9900:10100],
		1:201,
		abs.(freq_response_windowed_ideal_lp)[9900:10100],
		label="Real"
	)
	
	plot(p1, p2, p3, p4, p5, layout=l)
end

# ╔═╡ 8e779667-9807-46de-8487-8849c73d05b1
let
	s_size = size(windowed_ideal_lp_time)[1]
	windowed_ideal_lp_time = windowed_ideal_lp_time[diff_size:diff_size + size(window)[1]]
	
	dft = Transforms.DFT(windowed_ideal_lp_time)
	N = size(dft)[1]
	plot(1:N, real(dft), label="Real{DFT}")
	plot!(1:N, imag(dft), label="Imag{DFT}")
end

# ╔═╡ 7da0c041-2953-4339-ae71-d513f767dd94
let
	l = @layout [a; b]
	samples = 1000
	T = 0.01
	axis = 1:samples
	test_signal = sin.(5*T*axis) + sin.(20*T*axis)
	p1 = plot(axis, test_signal, title="Original signal")

	
	dft = Transforms.DFT(test_signal)
	lp_filter = vcat(zeros(20), ones(500), zeros(480))
	dft .*= lp_filter
	
	# plot(axis[1:50], abs.(dft)[1:50])

	filtered_signal = Transforms.iDFT(dft)
	p2 = plot(axis, real(filtered_signal), title="Filtered signal")

	plot(p1, p2, layout=l)
	
end

# ╔═╡ Cell order:
# ╠═9e2155b0-e5ff-11ee-2a8a-4b22abc37f49
# ╠═75921bed-8105-40fd-bbaa-e364fd68ab77
# ╠═1fa929ba-7b0c-4f06-8e7d-146ba2a54d23
# ╠═ef68ad3a-2da9-42dd-ba7c-08b0edd75044
# ╠═5835ca34-c3f7-487d-946d-c00cc06132d6
# ╠═407f4ee6-a8d4-41bc-8541-7603c85fe9f6
# ╠═8e779667-9807-46de-8487-8849c73d05b1
# ╠═7da0c041-2953-4339-ae71-d513f767dd94
