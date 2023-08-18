local version = "0.0.1"

-- function that outputs "Hello, World!
function Secret()
    print("Hello, World!")
    return true
end

local leftPadding = 2

-- export functions to be used in other files
return {
    secret = Secret,
    leftPadding = leftPadding,
    version = version
}
