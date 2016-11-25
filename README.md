[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]

# logger_

Empower your log capabilities to the maximum level

## Install

With [fisherman]

```
fisher logger_
```

## Usage

```fish
logger_ foo
logger_debug foo # or logger_ foo 1
logger_info foo # or logger_ foo 1
logger_warn foo # or logger_ foo 2
logger_error foo # or logger_ foo 3
logger_fatal foo # or logger_ foo 4
logger_critical foo # or logger_ foo 5
```

[travis-link]: https://travis-ci.org/fisherman/logger
[travis-badge]: https://img.shields.io/travis/fisherman/logger.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
