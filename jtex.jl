module jtex

export document, env, command

function command(type; line = nothing, options = nothing)
    lines = []
    if line != nothing
        push!(lines, line)
    end
    function get_raw()
        string = "\\$(type)"
        if options != nothing
            string *= "[$(options)]"
        end
        string *= "{"
        for c in lines
            if typeof(c) == String
                string *= c
            else
                string *= c.get_raw()
            end
        end
        string *= "}"
    end
    add(cont) = push!(lines, cont)
    return ()->(add, get_raw)
end

function env(type; options=nothing) ## ie \begin{type}
    contents = []
    add(env) = push!(contents, env)
    function get_raw()
        string = "\\begin{$(type)}"
        if options != nothing
            string *= "[$(options)]"
        end
        string *= "\n"
        for c in contents
            if typeof(c) == String
                string *= c * "\n"
            else
                string *= c.get_raw()
            end
        end
        string *= "\\end{$(type)}"
        return string
    end
    # create the environment, allow the addition of statments and sub environments.
    return ()->(add, get_raw)
end

function document()
    class = ("extarticle", "12pt")
    packages = []
    preamble = [] # comes after packages
    commands = []
    # Relating to the preamble
    set_class(cl, opts) = begin
          class = (cl, opts)
    end
    use_package(pkg, opts) = begin
          push!(packages, (pkg, opts))
    end
    raw_preamble(string) = begin
        push!(preamble, string)
    end
    new_command(string) = begin
        push!(commands, string)
    end
    statements = []
    # Relating to the document.
    add(content) = push!(statements, content)
    #This should really be a new environment here, then we will break things up in a more normal way.
    out_class() = begin
        if class != nothing
            return "\\documentclass[$(class[2])]{$(class[1])}\n"
        else
            return ""
        end
    end
    out_packages() = begin
        string = ""
        for (pkg, opts) in packages
            # println(pkg, opts)
            if opts != nothing
              string *= "\\usepackage[$(opts)]{$(pkg)}\n"
            else
              string *= "\\usepackage{$(pkg)}\n"
            end
        end
        return string
    end
    out_preamble() = begin
        string = ""
        for pre in preamble
            string *= pre * "\n"
        end
        return string
    end

    out_lines() = begin
        string = ""
        for c in statements
            if typeof(c) == String
                string *= c * "\n"
            else # so it is a funciton
                string *= c.get_raw()
            end
        end
        return string
    end
    # outputting the document
    function generate_tex()
        # Handle the preamble first.
        tex_string = ""
        tex_string *= out_class()
        tex_string *= out_packages()
        tex_string *= out_preamble()
        # now handle the document. (begin/end)
        tex_string *= "\\begin{document}\n"
        tex_string *= out_lines()
        tex_string *= "\\end{document}\n"
        return tex_string
    end
    function output_tex(filename)
        tex_string = generate_tex()
        open(filename, "w+") do file
            write(file, tex_string)
        end
        println("jtex wrote $(filename)")
    end
  # return the various functions.
  return ()->(set_class, use_package, raw_preamble, new_command, add, generate_tex, output_tex)
end

# doc = document()
# doc.use_package("package1", "no options")
# doc.raw_preamble("\\newstuff(blah blah blah)")

# tex_string = doc.generate_tex()
# println(tex_string)
end




