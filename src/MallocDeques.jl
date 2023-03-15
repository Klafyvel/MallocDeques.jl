"""
A StaticTools.jl and StaticCompilation.jl friendly double-ended queue implementation
based on [DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl).

It implements only a small subset of DataStructures.jl's Deque.

```
julia> using MallocDeques
julia> a = MallocDeque{Int}()
MallocDeque with 0 elements.
julia> isempty(a)
true
julia> length(a)
0
julia> eltype(a)
Int64
julia> push!(a, 10)
MallocDeque with 1 elements.
julia> pop!(a)
10
julia> pushfirst!(a, 10)
MallocDeque with 1 elements.
julia> push!(a, 20)
MallocDeque with 2 elements.
julia> first(a)
10
julia> last(a)
20
julia> popfirst!(a)
10
julia> push!(a, 10)
MallocDeque with 1 elements.
julia> empty!(a)
MallocDeque with 0 elements.

```

!!! warning "StaticCompiler.jl"
    In order to static compilation to work, no exception can be thrown. That 
    means that all boundary check were removed, so `pop!`-ing an empty deque
    will result in unpredicted behavior.

`MallocDeque` also implements `StaticTools.free`.
"""
module MallocDeques

using StaticTools

const DEFAULT_DEQUEUE_BLOCKSIZE = 1024
const MallocDequeBlock = Ptr{UInt8}

function mallocdequeblock(::Type{T}, C::Int, front::Int) where T
    alloc_size = C*sizeof(T) + 2*sizeof(Int) + 2*sizeof(MallocDequeBlock)
    blk = malloc(alloc_size)
    front!(blk, front)
    back!(blk, front-1)
    prev!(blk, blk)
    next!(blk, blk)
    blk
end
frontptr(blk::MallocDequeBlock) = reinterpret(Ptr{Int}, blk)
front(blk::MallocDequeBlock) = unsafe_load(frontptr(blk))
front!(blk::MallocDequeBlock, x::Int) = unsafe_store!(frontptr(blk), x)
backptr(blk::MallocDequeBlock) = reinterpret(Ptr{Int}, reinterpret(Int, frontptr(blk)) + sizeof(Int))
back(blk::MallocDequeBlock) = unsafe_load(backptr(blk))
back!(blk::MallocDequeBlock, x::Int) = unsafe_store!(backptr(blk), x)
prevptr(blk::MallocDequeBlock) = reinterpret(Ptr{MallocDequeBlock}, reinterpret(Int, backptr(blk)) + sizeof(Int))
prev(blk::MallocDequeBlock) = unsafe_load(prevptr(blk))
prev!(blk::MallocDequeBlock, x::MallocDequeBlock) = unsafe_store!(prevptr(blk), x)
nextptr(blk::MallocDequeBlock) = reinterpret(Ptr{MallocDequeBlock}, reinterpret(Int, prevptr(blk)) + sizeof(MallocDequeBlock))
next(blk::MallocDequeBlock) = unsafe_load(nextptr(blk))
next!(blk::MallocDequeBlock, x::MallocDequeBlock) = unsafe_store!(nextptr(blk), x)
dataptr(::Type{T}, blk::MallocDequeBlock) where {T} = reinterpret(Ptr{T}, reinterpret(Int, nextptr(blk)) + sizeof(MallocDequeBlock))
data(::Type{T}, blk::MallocDequeBlock, i::Integer=1) where {T} = unsafe_load(dataptr(T, blk), i)
data!(blk::MallocDequeBlock, x::T, i::Integer=1) where {T} = unsafe_store!(dataptr(T, blk), x, i)


# block at the rear of the chain, elements towards the front
rear_deque_block(ty::Type{T}, n::Int) where T = mallocdequeblock(ty, n, 1)

# block at the head of the train, elements towards the back
head_deque_block(ty::Type{T}, n::Int) where T = mallocdequeblock(ty, n, n+1)

Base.length(blk::MallocDequeBlock) = back(blk) - front(blk) + 1
Base.isempty(blk::MallocDequeBlock) = back(blk) < front(blk)
ishead(blk::MallocDequeBlock) = prev(blk) == blk
isrear(blk::MallocDequeBlock) = next(blk) == blk

function reset!(blk::MallocDequeBlock, front::Int)
    front!(blk, front)
    back!(blk, front - 1)
    prev!(blk, blk)
    next!(blk, blk)
end

#######################################
#
#  Deque
#
#######################################

"""
    MallocDeque{T, C}
Constructs `MallocDeque` object for elements of type `T`.
Parameters
----------
`T::Type` MallocDeque element data type.
`C::Int` MallocDeque block size (in bytes). Default = 1024.
"""
mutable struct MallocDeque{T,C}
    nblocks::Int
    len::Int
    head::MallocDequeBlock
    rear::MallocDequeBlock

end
MallocDeque(::Type{T}, C) where T = MallocDeque{T,C}()
@inline function MallocDeque{T, C}() where {T,C}
    h = rear_deque_block(T,C)
    MallocDeque{T, C}(1, 0, h, h)
end
MallocDeque{T}() where {T} = MallocDeque{T,DEFAULT_DEQUEUE_BLOCKSIZE}()::MallocDeque{T,DEFAULT_DEQUEUE_BLOCKSIZE}

"""
    isempty(d::MallocDeque)
Verifies if deque `d` is empty.
"""
Base.isempty(d::MallocDeque) = d.len == 0

"""
    length(d::MallocDeque) 
Returns the number of elements in deque `d`.
"""
Base.length(d::MallocDeque) = d.len
num_blocks(d::MallocDeque) = d.nblocks
Base.eltype(::Type{MallocDeque{T, C}}) where {T,C} = T

"""
    first(d::MallocDeque)
Returns the first element of the deque `d`.
"""
Base.first(d::MallocDeque{T,C}) where {T,C} = data(T, d.head, front(d.head))

"""
    last(d::MallocDeque)
Returns the last element of the deque `d`.
"""
Base.last(d::MallocDeque{T,C}) where {T,C} = data(T, d.rear, back(d.rear))

@inline function StaticTools.free(md::MallocDeque{T}) where T
    blk = md.head
    s = 0
    while !isrear(blk)
        n_ptr = next(blk)
        s += free(blk)
        blk = n_ptr
    end
    s
end

# Showing

function Base.show(io::IO, d::MallocDeque)
    print(io, "MallocDeque with $(length(d)) elements.")
end

function Base.dump(io::IO, d::MallocDeque{T,C}) where {T,C}
    println(io, "MallocDeque (length = $(d.len), nblocks = $(d.nblocks))")
    blk = d.head
    i = 1
    while true
        print(io, "block $i [$(front(blk)):$(back(blk))] ==> ")
        for j = front(blk) : back(blk)
            print(io, data(T, blk, j))
            print(io, ' ')
        end
        println(io)

        if !isrear(blk)
            blk = next(blk)
            i += 1
        else
            break
        end
    end
end


# Manipulation

"""
    empty!(d::MallocDeque)
Reset the deque `d`.
"""
@inline function Base.empty!(d::MallocDeque)
    # release all blocks except the head
    if d.nblocks > 1
        blk = d.rear
        while !ishead(blk)
            p = prev(blk)
            free(blk)
            blk = p
        end
    end

    # clean the head block (but retain the block itself)
    blk = d.head
    reset!(blk, 1)

    # reset queue fields
    d.nblocks = 1
    d.len = 0
    d.rear = d.head
    return d
end


"""
    push!(d::MallocDeque{T,C}, x::T) where {T,C}
Add an element to the back of deque `d`.
"""
@inline function Base.push!(d::MallocDeque{T,C}, x::T) where {T,C}
    if isempty(d.rear)
        front!(d.rear, 1)
        back!(d.rear, 0)
    end

    if back(d.rear) < C
        b = back(d.rear)
        data!(d.rear, x, b += 1)
        back!(d.rear, b)
    else
        new_rear = rear_deque_block(T, C)
        back!(new_rear, 1)
        data!(new_rear, x, 1)
        prev!(new_rear, d.rear)
        next!(d.rear, new_rear)
        d.rear = new_rear
        d.nblocks += 1
    end
    d.len += 1
    return d
end

"""
    pushfirst!(d::MallocDeque{T,C}, x::T) where {T,C}
Add an element to the front of deque `d`.
"""
@inline function Base.pushfirst!(d::MallocDeque{T,C}, x::T) where {T,C}
    if isempty(d.head)
        front!(d.head, C + 1)
        back!(d.head, C)
    end

    if front(d.head) > 1
        f = front(d.head)
        data!(d.head, x, f -= 1)
        front!(d.head, f)
    else
        new_head = head_deque_block(T, C)
        front!(new_head, C)
        data!(new_head, x, C)
        next!(new_head, d.head)
        prev!(d.head, new_head)
        d.head = new_head
        d.nblocks += 1
    end
    d.len += 1
    return d
end

"""
    pop!(d::MallocDeque{T,C}) where {T,C}
Remove the element at the back of deque `d`. Since throwing errors is not
allowed, poping an empty deque will result in pain and suffering.
"""
@inline function Base.pop!(d::MallocDeque{T,C}) where {T,C}
    # @assert back(d.rear) >= front(d.rear)

    x = data(T, d.rear, back(d.rear))
    back!(d.rear, back(d.rear)-1)
    if back(d.rear) < front(d.rear)
        if d.nblocks > 1
            # release and detach the rear block
            former_rear = d.rear
            d.rear = prev(d.rear)
            next!(d.rear, d.rear)
            d.nblocks -= 1
            free(former_rear)
        end
    end
    d.len -= 1
    return x
end

"""
    popfirst!(d::MallocDeque{T,C}) where {T,C}
Remove the element at the front of deque `d`. Since throwing errors is not
allowed, poping an empty deque will result in pain and suffering.

"""
@inline function Base.popfirst!(d::MallocDeque{T,C}) where {T,C}
    # @assert back(d.head) >= front(d.head)

    x = data(T, d.head, front(d.head))
    front!(d.head, front(d.head)+1)
    if back(d.head) < front(d.head)
        if d.nblocks > 1
            # release and detach the head block
            former_head = d.head
            d.head = next(d.head)
            prev!(d.head, d.head)
            d.nblocks -= 1
            free(former_head)
        end
    end
    d.len -= 1
    return x
end

export MallocDeque

end
