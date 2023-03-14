@testset "Unit tests" begin
using MallocDeques:data,data!,next,next!,prev,prev!,front,front!,back,back!

a = MallocDeque{Int,2}()
@testset "Constructor" begin
    @test a.head == a.rear
    @test a.len == 0
    @test front(a.head) == back(a.head) + 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
end
@testset "push!()" begin
    push!(a, 1)
    @test a.head == a.rear
    @test a.len == 1
    @test front(a.head) == back(a.head)
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    push!(a, 2)
    @test a.head == a.rear
    @test a.len == 2
    @test front(a.head) == back(a.head) - 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    @test data(Int, a.head, back(a.head)) == 2
    push!(a, 3)
    @test a.head != a.rear
    @test a.len == 3
    @test front(a.head) == back(a.head) - 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.rear
    @test data(Int, a.head, front(a.head)) == 1
    @test data(Int, a.head, front(a.head)+1) == 2
    @test front(a.rear) == back(a.rear)
    @test prev(a.rear) == a.head
    @test next(a.rear) == a.rear
    @test data(Int, a.rear, front(a.rear)) == 3
end 
@testset "pop!()" begin
    x = pop!(a)
    @test a.head == a.rear
    @test a.len == 2
    @test front(a.head) == back(a.head) - 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    @test data(Int, a.head, front(a.head)+1) == 2
    @test x == 3
    x = pop!(a)
    @test a.head == a.rear
    @test a.len == 1
    @test front(a.head) == back(a.head) 
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    @test x == 2
    x = pop!(a)
    @test a.head == a.rear
    @test a.len == 0
    @test front(a.head) == back(a.head) + 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
end 

@testset "pushfirst!()" begin
    pushfirst!(a, 1)
    @test a.head == a.rear
    @test a.len == 1
    @test front(a.head) == back(a.head)
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    pushfirst!(a, 2)
    @test a.head == a.rear
    @test a.len == 2
    @test front(a.head) == back(a.head) - 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 2
    @test data(Int, a.head, back(a.head)) == 1
    pushfirst!(a, 3)
    @test a.head != a.rear
    @test a.len == 3
    @test front(a.head) == back(a.head)
    @test prev(a.head) == a.head
    @test next(a.head) == a.rear
    @test data(Int, a.head, front(a.head)) == 3
    @test front(a.rear) == back(a.rear) - 1
    @test prev(a.rear) == a.head
    @test next(a.rear) == a.rear
    @test data(Int, a.rear, front(a.rear)) == 2
    @test data(Int, a.rear, back(a.rear)) == 1
end 
@testset "popfirst!()" begin
    x = popfirst!(a)
    @test a.head == a.rear
    @test a.len == 2
    @test front(a.head) == back(a.head) - 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 2
    @test x == 3
    x = popfirst!(a)
    @test a.head == a.rear
    @test a.len == 1
    @test front(a.head) == back(a.head)
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test data(Int, a.head, front(a.head)) == 1
    @test x == 2
    x = popfirst!(a)
    @test a.head == a.rear
    @test a.len == 0
    @test front(a.head) == back(a.head) + 1
    @test prev(a.head) == a.head
    @test next(a.head) == a.head
    @test x == 1
end 
free(a)
end
