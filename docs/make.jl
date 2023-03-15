using Documenter
using MallocDeques

makedocs(
    sitename = "MallocDeques",
    format = Documenter.HTML(),
    modules = [MallocDeques]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/Klafyvel/MallocDeques.jl"
)
