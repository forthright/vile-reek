# vile-reek

A [vile](http://github.com/brentlintner/vile) plugin for
[reek](https://github.com/troessner/reek).

**NOTICE**

This project is not actively maintained. If you want to
help maintain the project, or if you have a better
alternative to switch to, please open an issue and ask!

## Requirements

- [nodejs](http://nodejs.org)
- [npm](http://npmjs.org)
- [ruby](http://ruby-lang.org)
- [rubygems](http://rubygems.org)

## Installation

Currently, you need to have `reek` installed manually.

Example:

    npm i vile-reek
    gem install reek

Note: A good strategy is to use [bundler](http://bundler.io).

## Config

```yaml
reek:
  config: .reek.yml
```

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
