#!/bin/bash
# Script to format all C code in the NexusLink project

# Find all C files in include and src directories
find include src -name "*.c" -o -name "*.h" | while read -r file; do
    echo "Formatting $file"
    clang-format -i "$file"
done

echo "Formatting complete!"
