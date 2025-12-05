cmake_minimum_required(VERSION 3.15)

project(NLink 
    VERSION 1.0.0
    DESCRIPTION "NexusLink - Link What You Need, Nothing Else"
    LANGUAGES C
)

# ============================================================================
# Build Configuration
# ============================================================================
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Default to Release if not specified
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# ============================================================================
# Platform Detection & Configuration
# ============================================================================
if(WIN32)
    set(NLINK_PLATFORM "windows")
    set(NLINK_LIB_SUFFIX ".dll")
    set(NLINK_LIB_PREFIX "")
    add_compile_definitions(NLINK_WINDOWS _WIN32_WINNT=0x0601)
    # Windows doesn't need -ldl or -lpthread
    set(PLATFORM_LIBS "")
elseif(APPLE)
    set(NLINK_PLATFORM "macos")
    set(NLINK_LIB_SUFFIX ".dylib")
    set(NLINK_LIB_PREFIX "lib")
    add_compile_definitions(NLINK_MACOS)
    set(PLATFORM_LIBS pthread dl)
else()
    set(NLINK_PLATFORM "linux")
    set(NLINK_LIB_SUFFIX ".so")
    set(NLINK_LIB_PREFIX "lib")
    add_compile_definitions(NLINK_LINUX)
    set(PLATFORM_LIBS pthread dl)
endif()

message(STATUS "?? Building NLink for: ${NLINK_PLATFORM}")
message(STATUS "?? Build Type: ${CMAKE_BUILD_TYPE}")

# ============================================================================
# Directory Structure
# ============================================================================
set(NLINK_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(NLINK_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(NLINK_DOCS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/docs)

# Output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# ============================================================================
# Compiler Flags
# ============================================================================
add_compile_options(
    -Wall
    -Wextra
    -Wno-unused-parameter
    $<$<CONFIG:Debug>:-g -O0>
    $<$<CONFIG:Release>:-O2 -DNDEBUG>
    $<$<CONFIG:MinSizeRel>:-Os -DNDEBUG>
)

# Position Independent Code for shared libraries
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# ============================================================================
# Include Directories
# ============================================================================
include_directories(${NLINK_INCLUDE_DIR})

# ============================================================================
# Source Files Collection
# ============================================================================

# Common Module
file(GLOB COMMON_SOURCES
    ${NLINK_SOURCE_DIR}/core/common/*.c
)

# Symbols Module
file(GLOB SYMBOLS_SOURCES
    ${NLINK_SOURCE_DIR}/core/symbols/*.c
)

# Versioning Module
file(GLOB VERSIONING_SOURCES
    ${NLINK_SOURCE_DIR}/core/versioning/*.c
)

# Minimizer Module (Okpala Algorithm Implementation)
file(GLOB MINIMIZER_SOURCES
    ${NLINK_SOURCE_DIR}/core/minimizer/nexus_*.c
    ${NLINK_SOURCE_DIR}/core/minimizer/okpala_*.c
)

# Automaton Module
file(GLOB AUTOMATON_SOURCES
    ${NLINK_SOURCE_DIR}/core/automaton/*.c
)

# Core Module
file(GLOB CORE_SOURCES
    ${NLINK_SOURCE_DIR}/core/*.c
)

# CLI Module
file(GLOB CLI_SOURCES
    ${NLINK_SOURCE_DIR}/cli/*.c
    ${NLINK_SOURCE_DIR}/cli/commands/*.c
)

# ============================================================================
# Library Targets (Component-Based Architecture)
# ============================================================================

# 1. Common Library (Foundation)
add_library(nexus_common SHARED ${COMMON_SOURCES})
target_link_libraries(nexus_common PRIVATE ${PLATFORM_LIBS})
set_target_properties(nexus_common PROPERTIES
    OUTPUT_NAME "nexus_common"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 2. Symbols Library
add_library(nexus_symbols SHARED ${SYMBOLS_SOURCES})
target_link_libraries(nexus_symbols 
    PUBLIC nexus_common
    PRIVATE ${PLATFORM_LIBS}
)
set_target_properties(nexus_symbols PROPERTIES
    OUTPUT_NAME "nexus_symbols"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 3. Versioning Library (SemVer-X Implementation)
add_library(nexus_versioning SHARED ${VERSIONING_SOURCES})
target_link_libraries(nexus_versioning 
    PUBLIC nexus_common
    PRIVATE ${PLATFORM_LIBS}
)
set_target_properties(nexus_versioning PROPERTIES
    OUTPUT_NAME "nexus_versioning"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 4. Minimizer Library (Okpala Algorithm - The Secret Sauce ??)
add_library(nexus_minimizer SHARED 
    ${MINIMIZER_SOURCES}
    ${AUTOMATON_SOURCES}
)
target_link_libraries(nexus_minimizer 
    PUBLIC nexus_common
    PRIVATE ${PLATFORM_LIBS}
)
set_target_properties(nexus_minimizer PROPERTIES
    OUTPUT_NAME "nexus_minimizer"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 5. Core Library (Main Integration Layer)
add_library(nexus_core SHARED ${CORE_SOURCES})
target_link_libraries(nexus_core 
    PUBLIC 
        nexus_common
        nexus_symbols
        nexus_versioning
        nexus_minimizer
    PRIVATE 
        ${PLATFORM_LIBS}
)
set_target_properties(nexus_core PROPERTIES
    OUTPUT_NAME "nexus_core"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 6. CLI Library
add_library(nexus_cli SHARED ${CLI_SOURCES})
target_link_libraries(nexus_cli 
    PUBLIC nexus_core
    PRIVATE ${PLATFORM_LIBS}
)
set_target_properties(nexus_cli PROPERTIES
    OUTPUT_NAME "nexus_cli"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# 7. Main NLink Library (Everything Combined)
add_library(nlink SHARED)
target_link_libraries(nlink 
    PUBLIC
        nexus_core
        nexus_common
        nexus_symbols
        nexus_versioning
        nexus_minimizer
        nexus_cli
)
set_target_properties(nlink PROPERTIES
    OUTPUT_NAME "nlink"
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
)

# ============================================================================
# Executable Target
# ============================================================================
add_executable(nlink_bin ${NLINK_SOURCE_DIR}/cli/main.c)
target_link_libraries(nlink_bin PRIVATE nlink)
set_target_properties(nlink_bin PROPERTIES
    OUTPUT_NAME "nlink"
)

# Set RPATH for Unix-like systems
if(UNIX)
    set_target_properties(nlink_bin PROPERTIES
        INSTALL_RPATH "$ORIGIN/../lib"
        BUILD_WITH_INSTALL_RPATH TRUE
    )
endif()

# ============================================================================
# Installation Rules
# ============================================================================
install(TARGETS 
    nexus_common
    nexus_symbols
    nexus_versioning
    nexus_minimizer
    nexus_core
    nexus_cli
    nlink
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

install(TARGETS nlink_bin
    RUNTIME DESTINATION bin
)

install(DIRECTORY ${NLINK_INCLUDE_DIR}/
    DESTINATION include/nlink
    FILES_MATCHING PATTERN "*.h"
)

install(DIRECTORY ${NLINK_DOCS_DIR}/
    DESTINATION share/doc/nlink
    FILES_MATCHING 
    PATTERN "*.md"
    PATTERN "*.pdf"
)

# ============================================================================
# Testing Support
# ============================================================================
option(NLINK_BUILD_TESTS "Build NLink test suite" OFF)

if(NLINK_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# ============================================================================
# Package Configuration
# ============================================================================
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/NLinkConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/NLinkConfig.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/NLink
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/NLinkConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/NLinkConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/NLinkConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/NLink
)

# ============================================================================
# Build Summary
# ============================================================================
message(STATUS "")
message(STATUS "?? NLink Build Configuration Summary")
message(STATUS "=====================================")
message(STATUS "  Platform: ${NLINK_PLATFORM}")
message(STATUS "  Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "  C Compiler: ${CMAKE_C_COMPILER}")
message(STATUS "  Install Prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "  Binary Output: ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
message(STATUS "  Library Output: ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
message(STATUS "")
message(STATUS "?? Quick Commands:")
message(STATUS "  Build:   cmake --build .")
message(STATUS "  Test:    ctest")
message(STATUS "  Install: cmake --install .")
message(STATUS "")
