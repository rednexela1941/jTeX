module math_jtex
export matrix_tex

function matrix_tex(matrix)
    rows, cols = size(matrix)
    string = "\\begin{pmatrix}\n"
    for i in 1:rows
        for j in 1:cols
            term = matrix[i,j]
            re = real(term)
            im = imag(term)
            if im == 0
                string *= "$(re)"
            elseif re == 0
                if abs(im) == 1
                    if im == 1
                        string *= "i"
                    else
                        string *= "-i"
                    end
                else
                    string *= "$(im)i"
                end
            else
                if im < 0
                    string *= "$(re)-$(im)i"
                else
                    string *= "$(re)+$(im)i"
                end
            end
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

