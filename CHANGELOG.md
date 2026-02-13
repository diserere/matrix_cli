# Changelog

All notable changes to the Matrix CLI project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

#### Planned
- Add terminal resize handling

## [0.3.2] (2026-02-13)
### Technical improvements release

#### Fixed
- **Android compatibility**: FPS benchmark mode (`-f`) no longer attempts to write to `/tmp/matrix_fps.log`.  
  Log is now stored in memory, fixing "Read-only file system" errors on Android and other restricted environments.
- **macOS compatibility**: Fixed time calculation in FPS benchmark on macOS (compatibility with `date` command).
- **Help text**: Removed obsolete reference to log file in `--fps` option description.

#### Changed
- **Internal**: FPS log storage moved from filesystem to global variable `FPS_LOG` for better cross-platform support.
- **Code clarity**: Removed unused `FPS_LOG_FILE` variable and related filesystem operations.

#### Removed
- **Dependency**: Script no longer requires write permission to `/tmp` directory.

## [0.3.1] (2026-02-13)
### Bug fix release

#### Changed
- **Shortened long name**: Long name for `-s, --columns-step` option have been shortened to `--step`.
- **Error reporting**: All error messages are sent to STDERR now.

#### Added
- **Param validation**: Validate that value for `--step` option is not only an integer but also greater than 0 to prevent break animation loop.
- **Improved output**: Run `curl` tool in non-silent mode while updating from repo.

#### Fixed
- **Help and service messages improvement**: Some changes for `--help` and `--update` options to make its output clearer.
- Code formatting

## [0.3.0] (2026-02-12)
### Add columns-step option

#### Added
- **Performance control**: New `-s, --columns-step INT` flag to control column update step.
  - Allows trading visual density for speed.
  - Step value is now configurable and logged in FPS benchmark mode (`-f`).

#### Fixed
- **Actual default step mismatch**: Previously, the `columns_step` variable defaulted to `1`, but the init loop hardcoded `i+=3`. This caused to any changes to step value were ignored.
  - **Effect**: Default behavior remains the same (step = 3), but now it's properly controlled by the `COLUMNS_STEP` variable and the new `-s` flag.
- **Help text improvement**: Default values are clearly stated in the help text for `--delay` and `--columns-step` flags.
- **Error text typo**: Corrected error message for `--delay` flag (previously referred to `--speed`).

#### Changed
- **Default delay**: Explicitly set to `0` in code (behavior unchanged).

## [0.2.1] (2026-02-09)
### Bug fix release

#### Fixed
- **Peformance fix**: Small improvenemt in line buffer string concatenation
- **Color palette**: Most bright green color changed to better match color palette
- **README**: Small fixes in README
- **CHANGELOG**: Improve CHANGELOG formatting

## [0.2.0] (2026-02-08)

#### Performance
- **Major rendering refactor**: Replaced per-character refresh with buffered output
- **10-30x speed improvement**: Achieved ~25 FPS at 80×24 and ~5 FPS at 238×65 resolution (Gnome terminal in full-screen mode on FullHD display)

#### Added
- **FPS benchmarking mode**: `-f, --fps` flag for performance testing
- **Frame delay control**: `-d, --delay` flag for smoother animation on high refresh rates
- **Real-time FPS display**: Shows current frame rate in corner during benchmark
- **Auto-benchmark**: Automatically runs 500 frames and outputs detailed performance log

## [0.1.2] (2026-02-07)

#### Added
- Update option with `-u, --update` flag

## [0.1.1] (2026-02-07)

#### Added
  - Version info with `-v, --version` flag
  - Cross-platform support tested (Linux, macOS, Android)
  - CHANGELOG.md following Keep a Changelog

## [0.1.0] (2026-02-05)

#### Added
  - Initial release of Matrix CLI
  - Basic digital rain animation
  - Two-color (green/grayscale) scheme with `-g, -grayscale` flag
  - Two symbol set (full/0,1-only) modes with `-b, --binary` flag
  - Erasing slow column traces mode with `-e, --erase` flag  
  - Test color palette mode with `-t, --test` flag
  - Help text with `-h, --help` flag

[Unreleased]: https://github.com/diserere/matrix_cli/compare/v0.3.2...HEAD
[0.3.2]: https://github.com/diserere/matrix_cli/releases/tag/v0.3.2
[0.3.1]: https://github.com/diserere/matrix_cli/releases/tag/v0.3.1
[0.3.0]: https://github.com/diserere/matrix_cli/releases/tag/v0.3.0
[0.2.1]: https://github.com/diserere/matrix_cli/releases/tag/v0.2.1
[0.2.0]: https://github.com/diserere/matrix_cli/releases/tag/v0.2.0
[0.1.2]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.2
[0.1.1]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.1
[0.1.0]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.0