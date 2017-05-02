# vile-reek

A [vile](https://vile.io) plugin for [reek](https://github.com/troessner/reek).

**NOTICE**

This project is not actively maintained.
If you want to help maintain the project, or if you have a better
alternative to switch to, please open an issue and ask!

## Requirements

- [nodejs](http://nodejs.org)
- [npm](http://npmjs.org)
- [ruby](http://ruby-lang.org)
- [rubygems](http://rubygems.org)

## Installation

Currently, you need to have `reek` installed manually.

Example:

    npm i -D vile vile-reek
    gem install reek

Note: A good strategy is to use [bundler](http://bundler.io).

## Config

```yaml
reek:
  config: .reek.yml
```

## Versioning

This project ascribes to [semantic versioning](http://semver.org).

## Licensing

This project is licensed under the [MPL-2.0](LICENSE) license.

Any contributions made to this project are made under the current license.

## Contributions

Current list of [Contributors](https://github.com/forthright/vile-reek/graphs/contributors).

Any contributions are welcome and appreciated!

All you need to do is submit a [Pull Request](https://github.com/forthright/vile-reek/pulls).

1. Please consider tests and code quality before submitting.
2. Please try to keep commits clean, atomic and well explained (for others).

### Issues

Current issue tracker is on [GitHub](https://github.com/forthright/vile-reek/issues).

Even if you are uncomfortable with code, an issue or question is welcome.

### Code Of Conduct

This project ascribes to [contributor-covenant.org](http://contributor-covenant.org).

By participating in this project you agree to our [Code of Conduct](CODE_OF_CONDUCT.md).

### Maintainers

- Nothing to see here...

## Architecture

This project is currently written in JavaScript. Reek provides
a JSON CLI output that is currently used until a more ideal
IPC option is implemented.

- `bin` houses any shell based scripts
- `src` is es6+ syntax compiled with [babel](https://babeljs.io)
- `lib` generated js library

## Hacking

    cd vile-reek
    npm install
    gem install reek
    npm run dev
    npm test
