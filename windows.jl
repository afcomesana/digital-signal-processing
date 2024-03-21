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
    if iseven(span); span += 1; end
    return map(sample -> window(sample, type), -span:span)
end

window(sample::Int, type::Rect) = 1
window(sample::Int, type::Barlett) = 1 - abs(sample)/(type.span + 1)
window(sample::Int, type::Hann) = (1+cos((2π*sample)/(2*type.span + 1)))/2
window(sample::Int, type::Hanning) = 0.54 + 0.46*cos((2π*sample)/(2*type.span + 1))
window(sample::Int, type::Blackman) = 0.42 + 0.5*cos((2π*sample)/(2*type.span + 1)) + 0.08*cos((4π*sample)/(2*type.span + 1))

end