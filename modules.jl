########################
###### NEW MODULE ######
########################

module Transforms

export DFT, iDFT, frequency_response

function frequency_response(signal::Vector{<:Number})
    N = size(signal)[1]
    resolution = 2π/N

    return map(ω -> sum(signal.*exp.(-im*ω*(0:N-1))), -π:resolution:π)
end

# Discrete Fourier Transform for frequency ω:
DFT(signal::Vector{<:Number}, ω::Int, N::Int, direction::Int = -1) = sum(signal.*exp.(direction*im*ω*(0:N-1)*2π/N))

# Discrete Fourier Transform for all the frequencies:
function DFT(signal::Vector{<:Number}, is_inverse::Bool=false)
    N = size(signal)[1]
    direction = (convert(Int, is_inverse)*2) - 1
    result = map(ω -> DFT(signal, ω, N, direction), 0:N-1)

    if is_inverse; result /= N; end

    return result
end

# Inverse Discrete Fourier Transform at point "n":
iDFT(dft::Vector{<:Number}) = DFT(dft, true)

end


########################
###### NEW MODULE ######
########################

module Windows

abstract type Window end

export Rect, Barlett, window

struct Rect <: Window; span::Int; end
struct Barlett <: Window; span::Int; end
struct Hann <: Window; span::Int; end
struct Hanning <: Window; span::Int; end
struct Blackman <: Window; span::Int; end

function window(type::Window)
    span = type.span
    if iseven(span); span -= 1; end
    return map(sample -> window(sample, type), -type.span:type.span)
end

window(sample::Int, type::Rect) = 1
window(sample::Int, type::Barlett) = 1 - abs(sample)/(type.span + 1)
window(sample::Int, type::Hann) = (1+cos((2π*sample)/(2*type.span + 1)))/2
window(sample::Int, type::Hanning) = 0.54 + 0.46*cos((2π*sample)/(2*type.span + 1))
window(sample::Int, type::Blackman) = 0.42 + 0.5*cos((2π*sample)/(2*type.span + 1)) + 0.08*cos((4π*sample)/(2*type.span + 1))

end


########################
###### NEW MODULE ######
########################

module FrequencyFilters

abstract type FrequencyFilter end

struct LowPassFilter <: FrequencyFilter; cutoff::Real; end
struct HighPassFilter <: FrequencyFilter; cutoff::Real; end

function apply_filter(ω::Union{Real, AbstractVector}, freq_filter::FrequencyFilter)
    if freq_filter.cutoff >= π
        throw("Cutoff frequency must be lower than π.")
    end

    return _apply_filter(ω, freq_filter)
end

_apply_filter(ω::AbstractVector{<:Real}, freq_filter::FrequencyFilter) = map(freq -> _apply_filter(freq, freq_filter), ω)

_apply_filter(ω::Real, freq_filter::LowPassFilter) = convert(Int, abs(angle(exp(im*freq_filter.cutoff))) > abs(angle(exp(im*ω))))

function time_response(t::Union{Real, AbstractVector}, frequency_filter::FrequencyFilter, resolution::Real = 0.001)
    π_range = -π:resolution:π
    frequency_response = apply_filter(π_range, frequency_filter)

    if isa(t, Real)
        return time_response(frequency_response, t, resolution)
    end

    return map(item -> time_response(frequency_response, item, resolution), t)
end

time_response(frequency_response::Vector{<:Number}, t::Real, resolution::Real = 0.001) = sum(frequency_response.*exp.(im*(-π:resolution:π)*t))/2π

end