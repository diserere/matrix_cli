# Changelog

All notable changes to the Matrix CLI project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

### [Unreleased]

<!-- #### Added
#### Changed
#### Deprecated
#### Removed
#### Fixed
#### Security -->
#### Planned
- Refactor rendering to improve performance
- Add animation speed control
- Add terminal resize handling

### [0.2.0] (2026-02-08)
- Changed
  - Fully refactored rendering: use buffered output instead of per-symbol refresh.
  Achieve 10-30x speedup: ~25 FPS at 80x24, ~5 FPS at 238×65 (Gnome terminal in full-screen mode on FullHD display)
- Added
  - FPS benchmarking mode with `-f, --fps` flag
  - Framerate delay option for small screen sizes with `-d, --delay` flag

### [0.1.2] (2026-02-07)
- Added
  - Update option with `-u, --update` flag

### [0.1.1] (2026-02-07)
- Added
  - Version info with `-v, --version` flag
  - Cross-platform support tested (Linux, macOS, Android)
  - CHANGELOG.md following Keep a Changelog

### [0.1.0] (2026-02-05)
- Added
  - Initial release of Matrix CLI
  - Basic digital rain animation
  - Two-color (green/grayscale) scheme with `-g, -grayscale` flag
  - Two symbol set (full/0,1-only) modes with `-b, --binary` flag
  - Erasing slow column traces mode with `-e, --erase` flag  
  - Test color palette mode with `-t, --test` flag
  - Help text with `-h, --help` flag


[Unreleased]: https://github.com/diserere/matrix_cli/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/diserere/matrix_cli/releases/tag/v0.2.0
[0.1.2]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.2
[0.1.1]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.1
[0.1.0]: https://github.com/diserere/matrix_cli/releases/tag/v0.1.0