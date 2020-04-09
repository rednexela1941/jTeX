module math_jtex
export matrix_tex, format_num

function format_num(input)
    re = real(input)
    im = imag(input)
    string = ""
    if im == 0
        if isinteger(re)
            string *= "$(trunc(Int,re))"
        else
            string *= "$(re)"
        end
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
    return string
end



function matrix_tex(matrix)
    if length(size(matrix)) == 1
        cols = 1
        rows = size(matrix)[1]
    else
        rows, cols = size(matrix)
    end
    string = "\\begin{pmatrix}\n"
    for i in 1:rows
        for j in 1:cols
            term = matrix[i,j]
            string *= format_num(term)
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

