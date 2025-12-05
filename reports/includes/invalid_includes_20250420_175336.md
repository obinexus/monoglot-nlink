# NexusLink Invalid Include Report

- Files processed: 64
- Files with invalid includes: 2
- Total invalid includes: 2

## Files with Invalid Includes

### include/nlink/cli/nlink_cli.h

- Line 6: `nlink/cli/options.h`
  ```
  #include "nlink/cli/options.h"
  ```

### src/core/metadata/enhanced_metadata.c

- Line 6: `../include/nexus_enhanced_metadata.h`
  ```
  #include "../include/nexus_enhanced_metadata.h"
  ```


## Header Catalog

Available headers in the project:

- `automaton.h`
  - include/nlink/core/minimizer/automaton.h
- `cli.h`
  - include/nlink/cli/cli.h
- `command.h`
  - include/nlink/core/common/command.h
- `command_registry.h`
  - include/nlink/cli/command_registry.h
- `enhanced_metadata.h`
  - include/nlink/core/metadata/enhanced_metadata.h
- `json.h`
  - include/nlink/core/common/json.h
- `lazy.h`
  - include/nlink/core/common/lazy.h
- `lazy_legacy.h`
  - include/nlink/core/common/lazy_legacy.h
- `lazy_versioned.h`
  - include/nlink/core/common/lazy_versioned.h
  - include/nlink/core/versioning/lazy_versioned.h
- `load.h`
  - include/nlink/cli/commands/load.h
- `metadata.h`
  - include/nlink/core/metadata/metadata.h
- `minimal.h`
  - include/nlink/cli/commands/minimal.h
- `minimize.h`
  - include/nlink/cli/commands/minimize.h
- `nexus_automaton.h`
  - include/nlink/core/minimizer/nexus_automaton.h
- `nexus_core.h`
  - include/nlink/core/common/nexus_core.h
- `nexus_json.h`
  - include/nlink/core/common/nexus_json.h
- `nexus_lazy_versioned.h`
  - include/nlink/core/common/nexus_lazy_versioned.h
  - include/nlink/core/versioning/nexus_lazy_versioned.h
- `nexus_loader.h`
  - include/nlink/core/common/nexus_loader.h
- `nexus_minimizer.h`
  - include/nlink/core/minimizer/nexus_minimizer.h
- `nexus_missing.h`
  - include/nlink/core/versioning/nexus_missing.h
- `nexus_symbols.h`
  - include/nlink/core/symbols/nexus_symbols.h
- `nexus_version.h`
  - include/nlink/core/versioning/nexus_version.h
- `nexus_versioned_symbols.h`
  - include/nlink/core/symbols/nexus_versioned_symbols.h
- `nlink.h`
  - include/nlink/core/nlink.h
- `nlink_cli.h`
  - include/nlink/cli/nlink_cli.h
- `okpala_ast.h`
  - include/nlink/core/minimizer/okpala_ast.h
- `okpala_automaton.h`
  - include/nlink/core/minimizer/okpala_automaton.h
- `okpala_minimizer.h`
  - include/nlink/core/minimizer/okpala_minimizer.h
- `regex_matcher.h`
  - include/nlink/cli/regex_matcher.h
- `registry.h`
  - include/nlink/core/symbols/registry.h
- `result.h`
  - include/nlink/core/common/result.h
- `semver.h`
  - include/nlink/core/versioning/semver.h
- `symbols.h`
  - include/nlink/core/symbols/symbols.h
- `types.h`
  - include/nlink/core/common/types.h
- `version.h`
  - include/nlink/cli/commands/version.h
- `versioned_symbols.h`
  - include/nlink/core/versioning/versioned_symbols.h
