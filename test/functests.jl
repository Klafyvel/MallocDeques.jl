@testset "Functests" begin
    a = MallocDeque{Int}()
    @test isempty(a)
    @test length(a) == 0
    @test eltype(a) == Int64
    push!(a, 10)
    push!(a, 20)
    @test !isempty(a)
    @test first(a) == 10
    @test last(a) == 20
    @test pop!(a) == 20
    @test pop!(a) == 10
    @test isempty(a)
    push!(a, 10)
    push!(a, 20)
    @test popfirst!(a) == 10
    @test first(a) == 20
    pushfirst!(a, 10)
    @test first(a) == 10
    empty!(a)
    @test isempty(a)

    for i in 1:2048
        push!(a, i)
    end
    for i in 2048:-1:1
        @test pop!(a) == i
    end
    empty!(a)
    for i in 1:2048
        push!(a, i)
    end
    for i in 1:2048
        @test popfirst!(a) == i
    end
    empty!(a)
    for i in 1:2048
        push!(a, i)
    end
    empty!(a)
    @test isempty(a)
    for i in 1:2048
        push!(a, i)
    end
    free(a)
end
