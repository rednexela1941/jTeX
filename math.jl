module math_jtex
export matrix_tex






function matrix_tex(matrix)
    rows, cols = size(matrix)
    string = "\\begin{pmatrix}\n"
    for i in 1:rows
        for j in 1:cols
            string *= "$(matrix[i,j])"
            if j < cols
                string *= " & "
            end
        end
        if i < rows
            string *= " \\\\\n"
        end
    end
    string *= "\n\\end{pmatrix}"
    return string
end
end

