@testset "Static compilation" begin
testpath = pwd()
scratch = tempdir()
cd(scratch)
jlpath = joinpath(Sys.BINDIR, Base.julia_exename()) # Get path to julia executable

let
    # Attempt to compile
    # We have to start a new Julia process to get around the fact that Pkg.test
    # disables `@inbounds`, but ironically we can use `--compile=min` to make that
    # faster.
    status = -1
    try
        isfile("mallocdeques") && rm("mallocdeques")
        status = run(`$jlpath --compile=min $testpath/scripts/mallocdeques.jl`)
    catch e
        @warn "Could not compile $testpath/scripts/mallocdeques.jl"
        println(e)
    end
    @test isa(status, Base.Process)
    @test isa(status, Base.Process) && status.exitcode == 0

    # Attempt to run
    println("Playing with 1026 Int in a MallocDeque.")
    status = -1
    try
        status = run(`./mallocdeques 1026`)
    catch e
        @warn "Could not run $(scratch)/mallocdeques"
        println(e)
    end
    @test isa(status, Base.Process)
    @test isa(status, Base.Process) && status.exitcode == 0
end

cd(testpath)
end
