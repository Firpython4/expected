-- premake5.lua

-- Minimum Premake version
premake.minimum_version("5.0")

-- Project information
project("expected" LANGUAGES "CXX")
version("1.0") -- Update with the actual version

-- Set the C++ standard
cppdialect("C++20")

-- Compiler configurations
if os.host() == "windows" then
    buildoptions { "/Zc:__cplusplus" }
end

-- Set the build type to Debug if not specified
if not (buildtype and buildtype ~= "") then
    buildtype "Debug"
end

-- Add compile options
target_compile_options("project_options" INTERFACE "/std:c++latest") -- Visual Studio

-- Set compiler flags based on platform
filter { "system:windows", "action:gmake", "toolset:gcc" }
    buildoptions { "-std=c++20" }

-- Enable Conan package manager
include("cmake/Conan.lua")
conan_basic_setup()

-- Options
option("ENABLE_TESTING", "Enable Test Builds", "ON")
option("ENABLE_EXAMPLES", "Enable Example Builds", "OFF")

-- Project configuration
project("expected")
    location("build") -- Set the output directory for generated project files
    kind("StaticLib") -- Change to "ConsoleApp" or "SharedLib" as needed
    targetdir("bin/%{cfg.buildcfg}")

-- Add source files if any

-- Add test and example projects if specified
if _OPTIONS["ENABLE_TESTING"] then
    project("test")
        location("build")
        kind("ConsoleApp")
        files { "test/**.cpp" } -- Adjust the pattern based on your project structure
        links { "expected" }
        filter "configurations:Debug"
            symbols "On"
        filter "configurations:Release"
            optimize "On"
end

if _OPTIONS["ENABLE_EXAMPLES"] then
    project("examples")
        location("build")
        kind("ConsoleApp")
        files { "examples/**.cpp" } -- Adjust the pattern based on your project structure
        links { "expected" }
        filter "configurations:Debug"
            symbols "On"
        filter "configurations:Release"
            optimize "On"
end
