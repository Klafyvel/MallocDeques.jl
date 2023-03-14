using StaticTools
using MallocDeques
using Test

@testset "MallocDeques.jl" begin
    include("functests.jl")
    include("internals.jl")
    include("teststaticcompiler.jl")
end
