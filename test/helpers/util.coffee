Promise = require "bluebird"

all_files = [
  {
    file: "foo.rb",
    msg: "",
    type: "ok",
    where: { end: {}, start: {} }
  }
  {
    file: "bar.rb",
    msg: "",
    type: "ok",
    where: { end: {}, start: {} }
  }
]

setup = (vile) ->
  vile.promise_each.returns new Promise (resolve) ->
    resolve(all_files)

  vile.spawn.returns new Promise (resolve) ->
    resolve(JSON.stringify reek_json)

issues = [
  {
    file: "foo.rb",
    msg: "",
    type: "ok",
    where: { end: {}, start: {} }
  }
  {
    file: "bar.rb"
    msg: "something (smellcat/smelltype) (in method 1 time(s))",
    type: "error"
    where: {
      end: {}
      start: { line: 8 }
    }
  },
  {
    file: "bar.rb",
    msg: "something else (smellcat2/smelltype2) (in another_method 4 time(s))",
    type: "error",
    where: {
      end: { line: 14 }
      start: { line: 11 }
    }
  }
]

reek_json =
  [
    {
      source: "bar.rb", context: "method",
      lines: [8], message: "something", count: 1,
      smell_category: "smellcat", smell_type: "smelltype"
    }
    {
      source: "bar.rb", context: "another_method", count: 4,
      lines: [11, 12, 13, 14], message: "something else",
      smell_category: "smellcat2", smell_type: "smelltype2"
    }
  ]

module.exports =
  issues: issues
  all_files: all_files
  setup: setup
