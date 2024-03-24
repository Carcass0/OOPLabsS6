using Random

function generate_random_name()
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    random_name = string(uppercase(rand(alphabet)))
    for _ in 1:rand(2:9)
        random_name *= rand(alphabet)
    end
    return random_name
end

function generate_name_set(amount)
    names = []
    for i in 1:amount
        push!(names, generate_random_name())
    end
    return names
end

function generate_names_file(file_name, line_num)
    names = generate_name_set(div(line_num, 10))
    open(file_name, "w") do file
        for i in 1:line_num
            name = rand(names)
            println(file, name)
        end
    end
end

function initialize_lab()
    generate_names_file("1000 names.txt", 1000)
    generate_names_file("1000000 names.txt", 1000000)
end

function process_names(filepath)
    names = Dict{String, Int}()
    open(filepath, "r") do file
        line_num = 0 
        for line in eachline(file)
            line_num += 1
            name = line
            names[name] = line_num
        end
    end
    return names
end

function dict_print(d)
    for (key, value) in d
        println("$key: $value")
    end
end

function main()
    result1 = process_names("1000 names.txt")
    result2 = process_names("1000000 names.txt")
    dict_print(result1)
    dict_print(result2)
    println(length(result1))
    println(length(result2))
end

main()
