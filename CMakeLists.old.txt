# CMakeLists.txt (Windows-optimized version)
cmake_minimum_required(VERSION 3.14)
project(NexusLink VERSION 1.0.0 LANGUAGES C)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Windows-specific settings
if(WIN32)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
    set(BUILD_SHARED_LIBS ON)
    # Use MinGW-style import libraries
    set(CMAKE_IMPORT_LIBRARY_PREFIX "")
    set(CMAKE_IMPORT_LIBRARY_SUFFIX ".a")
endif()

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# Include directories
include_directories(${CMAKE_SOURCE_DIR}/include)

# Compiler flags
if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-Wall -Wextra -Wno-unused-parameter -g)
elseif(MSVC)
    add_compile_options(/W4 /wd4100)
endif()

# Find required libraries
find_package(Threads REQUIRED)

# Source file collection
file(GLOB_RECURSE CORE_SOURCES 
    src/core/*.c
    src/core/common/*.c
    src/core/symbols/*.c
    src/core/versioning/*.c
    src/core/minimizer/*.c
    src/core/automaton/*.c
)

file(GLOB_RECURSE CLI_SOURCES
    src/cli/*.c
    src/cli/commands/*.c
)

# Create libraries
add_library(nexus_core SHARED ${CORE_SOURCES})
target_link_libraries(nexus_core PRIVATE Threads::Threads ${CMAKE_DL_LIBS})

add_library(nexus_cli SHARED ${CLI_SOURCES})
target_link_libraries(nexus_cli PRIVATE nexus_core)

# Main executable
add_executable(nlink src/cli/main.c)
target_link_libraries(nlink PRIVATE nexus_core nexus_cli)

# Installation
install(TARGETS nlink nexus_core nexus_cli
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(DIRECTORY include/ DESTINATION include)

# Testing
enable_testing()
add_subdirectory(tests)

# Package configuration
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/NexusLinkConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)
