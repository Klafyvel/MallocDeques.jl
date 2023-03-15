using StaticTools, StaticCompiler, MallocDeques

function mallocdeques()
    # argc == 2 || return printf(stderrp(), c"Incorrect number of command-line arguments\n")
    # n = argparse(Int64, argv, 2)            # First command-line argument
    n = 2

    md = MallocDeque{Int64}()
    for i=1:n
        push!(md, i)
    end
    for i=1:n
        pushfirst!(md, i)
    end
    for _=1:n
        pop!(md)
    end
    for _=1:n
        popfirst!(md)
    end
    for i=1:n
        push!(md, i)
    end
    empty!(md)

    # Clean up
    free(md)
end

# Attempt to compile
# path = compile_executable(mallocdeques, (Int64, Ptr{Ptr{UInt8}}), "./")
path = compile_executable(mallocdeques, (), "./")
