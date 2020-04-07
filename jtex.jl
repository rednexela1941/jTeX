module jtex

# I kind of want a struct, which we could do with a function and 
# This will represent a class.
# We need to set the document class with properties.



function document()
    statements = []
    class = ("extrarticle", "12pt")
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
    add_line(string) = push!(statements, string)

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
            string *= "\\usepackage[$(opts)]{$(pkg)}\n"
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
            string *= c * "\n"
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

  print() = (println(class);println(packages))

  return ()->(print, set_class, use_package, raw_preamble, new_command, add_line, generate_tex)
end

doc = document()
doc.use_package("package1", "no options")
doc.raw_preamble("\\newstuff(blah blah blah)")

tex_string = doc.generate_tex()
println(tex_string)
end




