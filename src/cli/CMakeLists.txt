# CLI Component CMakeLists.txt
cmake_minimum_required(VERSION 3.12)

# Define source directories
set(CLI_SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR})
set(CLI_INCLUDE_DIR ${CMAKE_SOURCE_DIR}/include/nlink/cli)
set(CLI_COMMANDS_DIR ${CLI_SRC_DIR}/commands)

# Define all CLI sources
set(CLI_SOURCES
    ${CLI_SRC_DIR}/cli.c
    ${CLI_SRC_DIR}/command.c
    ${CLI_SRC_DIR}/command_params.c
    ${CLI_SRC_DIR}/command_registry.c
    ${CLI_SRC_DIR}/command_router.c
    ${CLI_SRC_DIR}/command_registration.c
    ${CLI_SRC_DIR}/parse.c
)

# Include the commands subdirectory
add_subdirectory(commands)

# Command implementations
set(CLI_COMMAND_SOURCES
    ${CLI_COMMANDS_DIR}/load.c
    ${CLI_COMMANDS_DIR}/version.c
    ${CLI_COMMANDS_DIR}/version_utils.c
    ${CLI_COMMANDS_DIR}/minimize.c
    ${CLI_COMMANDS_DIR}/minimal.c
    ${CLI_COMMANDS_DIR}/pipeline.c
)

# Combine sources
list(APPEND CLI_SOURCES ${CLI_COMMAND_SOURCES})

# Main executable source
set(CLI_MAIN_SOURCE ${CLI_SRC_DIR}/main.c)

# First create the CLI library
add_library(nexus_cli SHARED ${CLI_SOURCES})

# Set properties for the library
set_target_properties(nexus_cli PROPERTIES
    C_STANDARD 11
    C_STANDARD_REQUIRED ON
    POSITION_INDEPENDENT_CODE ON
)

# Set include directories for the library
target_include_directories(nexus_cli
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
)

# Link the library with its dependencies
target_link_libraries(nexus_cli
    PUBLIC
        nexus_common
        nexus_minimizer
    PRIVATE
        ${CMAKE_DL_LIBS}
        pthread
)

# Create the CLI executable
add_executable(nlink ${CLI_MAIN_SOURCE})

# Link the executable with the CLI library
target_link_libraries(nlink
    PRIVATE
        nexus_cli
)

# Install targets
install(TARGETS nexus_cli
    EXPORT NexusLinkTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(TARGETS nlink
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install header files
install(DIRECTORY ${CMAKE_SOURCE_DIR}/include/nlink/cli/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/nlink/cli
    FILES_MATCHING PATTERN "*.h"
)

# Install command headers
install(DIRECTORY ${CMAKE_SOURCE_DIR}/include/nlink/cli/commands/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/nlink/cli/commands
    FILES_MATCHING PATTERN "*.h"
)

# Add compile definitions
target_compile_definitions(nlink PRIVATE
    NEXUSLINK_VERSION="1.0.0"
    NEXUSLINK_BUILD_DATE="${CMAKE_BUILD_TIME}"
    NEXUSLINK_COPYRIGHT="Copyright © 2025 OBINexus Computing"
)

# Set output directory
set_target_properties(nlink PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)

set_target_properties(nexus_cli PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)