# Use CMake (recommended)
cmake -B build -G "MinGW Makefiles"
cmake --build build --config Release

# Or use fixed Makefile
make -f Makefile.windows clean
make -f Makefile.windows all
.\build\bin\nlink.exe --version
