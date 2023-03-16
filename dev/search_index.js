var documenterSearchIndex = {"docs":
[{"location":"","page":"MallocDeques.jl","title":"MallocDeques.jl","text":"CurrentModule = MallocDeques","category":"page"},{"location":"#MallocDeques.jl","page":"MallocDeques.jl","title":"MallocDeques.jl","text":"","category":"section"},{"location":"","page":"MallocDeques.jl","title":"MallocDeques.jl","text":"Pages = [\"index.md\"]","category":"page"},{"location":"","page":"MallocDeques.jl","title":"MallocDeques.jl","text":"Modules = [MallocDeques]","category":"page"},{"location":"#MallocDeques.MallocDeques","page":"MallocDeques.jl","title":"MallocDeques.MallocDeques","text":"A StaticTools.jl and StaticCompilation.jl friendly double-ended queue implementation based on DataStructures.jl.\n\nIt implements only a small subset of DataStructures.jl's Deque.\n\njulia> using MallocDeques\njulia> a = MallocDeque{Int}()\nMallocDeque with 0 elements.\njulia> isempty(a)\ntrue\njulia> length(a)\n0\njulia> eltype(a)\nInt64\njulia> push!(a, 10)\nMallocDeque with 1 elements.\njulia> pop!(a)\n10\njulia> pushfirst!(a, 10)\nMallocDeque with 1 elements.\njulia> push!(a, 20)\nMallocDeque with 2 elements.\njulia> first(a)\n10\njulia> last(a)\n20\njulia> popfirst!(a)\n10\njulia> push!(a, 10)\nMallocDeque with 1 elements.\njulia> empty!(a)\nMallocDeque with 0 elements.\n\n\nwarning: StaticCompiler.jl\nIn order to static compilation to work, no exception can be thrown. That  means that all boundary check were removed, so pop!-ing an empty deque will result in unpredicted behavior.\n\nMallocDeque also implements StaticTools.free.\n\n\n\n\n\n","category":"module"},{"location":"#MallocDeques.MallocDeque","page":"MallocDeques.jl","title":"MallocDeques.MallocDeque","text":"MallocDeque{T, C}\n\nConstructs MallocDeque object for elements of type T. Parameters ––––– T::Type MallocDeque element data type. C::Int MallocDeque block size (in bytes). Default = 1024.\n\n\n\n\n\n","category":"type"},{"location":"#Base.empty!-Tuple{MallocDeque}","page":"MallocDeques.jl","title":"Base.empty!","text":"empty!(d::MallocDeque)\n\nReset the deque d.\n\n\n\n\n\n","category":"method"},{"location":"#Base.first-Union{Tuple{MallocDeque{T, C}}, Tuple{C}, Tuple{T}} where {T, C}","page":"MallocDeques.jl","title":"Base.first","text":"first(d::MallocDeque)\n\nReturns the first element of the deque d.\n\n\n\n\n\n","category":"method"},{"location":"#Base.isempty-Tuple{MallocDeque}","page":"MallocDeques.jl","title":"Base.isempty","text":"isempty(d::MallocDeque)\n\nVerifies if deque d is empty.\n\n\n\n\n\n","category":"method"},{"location":"#Base.last-Union{Tuple{MallocDeque{T, C}}, Tuple{C}, Tuple{T}} where {T, C}","page":"MallocDeques.jl","title":"Base.last","text":"last(d::MallocDeque)\n\nReturns the last element of the deque d.\n\n\n\n\n\n","category":"method"},{"location":"#Base.length-Tuple{MallocDeque}","page":"MallocDeques.jl","title":"Base.length","text":"length(d::MallocDeque)\n\nReturns the number of elements in deque d.\n\n\n\n\n\n","category":"method"},{"location":"#Base.pop!-Union{Tuple{MallocDeque{T, C}}, Tuple{C}, Tuple{T}} where {T, C}","page":"MallocDeques.jl","title":"Base.pop!","text":"pop!(d::MallocDeque{T,C}) where {T,C}\n\nRemove the element at the back of deque d. Since throwing errors is not allowed, poping an empty deque will result in pain and suffering.\n\n\n\n\n\n","category":"method"},{"location":"#Base.popfirst!-Union{Tuple{MallocDeque{T, C}}, Tuple{C}, Tuple{T}} where {T, C}","page":"MallocDeques.jl","title":"Base.popfirst!","text":"popfirst!(d::MallocDeque{T,C}) where {T,C}\n\nRemove the element at the front of deque d. Since throwing errors is not allowed, poping an empty deque will result in pain and suffering.\n\n\n\n\n\n","category":"method"},{"location":"#Base.push!-Union{Tuple{C}, Tuple{T}, Tuple{MallocDeque{T, C}, T}} where {T, C}","page":"MallocDeques.jl","title":"Base.push!","text":"push!(d::MallocDeque{T,C}, x::T) where {T,C}\n\nAdd an element to the back of deque d.\n\n\n\n\n\n","category":"method"},{"location":"#Base.pushfirst!-Union{Tuple{C}, Tuple{T}, Tuple{MallocDeque{T, C}, T}} where {T, C}","page":"MallocDeques.jl","title":"Base.pushfirst!","text":"pushfirst!(d::MallocDeque{T,C}, x::T) where {T,C}\n\nAdd an element to the front of deque d.\n\n\n\n\n\n","category":"method"}]
}