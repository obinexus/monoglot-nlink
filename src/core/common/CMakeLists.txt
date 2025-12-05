# Common component CMakeLists.txt

# Collect all source files
set(COMMON_SOURCES
    result.c
    types.c
    json.c
    lazy.c
    lazy_legacy.c
    lazy_versioned.c
    nexus_core.c
    nexus_json.c
    nexus_lazy_versioned.c
    nexus_loader.c
)

# Collect all header files
set(COMMON_HEADERS
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/cold.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/forward_decl.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/json.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/lazy_legacy.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/lazy_versioned.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/lazy.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/nexus_core.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/nexus_json.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/nexus_lazy_versioned.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/nexus_loader.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/result.h
    ${CMAKE_SOURCE_DIR}/include/nlink/core/common/types.h
)

# Create common library
add_library(nexus_common ${COMMON_SOURCES} ${COMMON_HEADERS})

# Set up include directories for this target and dependent targets
target_include_directories(nexus_common
    PUBLIC
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_SOURCE_DIR}/include/nlink
    PRIVATE
        ${CMAKE_SOURCE_DIR}/src
)

# Add dependencies
find_package(Threads REQUIRED)
target_link_libraries(nexus_common
    PUBLIC
        ${CMAKE_DL_LIBS}  # For dlopen/dlclose
        Threads::Threads  # For pthread
)

# Install headers
install(DIRECTORY ${CMAKE_SOURCE_DIR}/include/nlink/core/common/
        DESTINATION include/nlink/core/common
        FILES_MATCHING PATTERN "*.h")

# Install library
install(TARGETS nexus_common
        EXPORT NexusLinkTargets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        RUNTIME DESTINATION bin)

# Export targets
export(TARGETS nexus_common
       FILE ${CMAKE_BINARY_DIR}/NexusLinkTargets.cmake)