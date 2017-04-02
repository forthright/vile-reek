Promise = require "bluebird"

setup = (vile) ->
  vile.spawn.returns new Promise (resolve) ->
    resolve({
      code: 0,
      stderr: "",
      stdout: JSON.stringify(reek_json)
    })

issues = [
  {
    path: "bar.rb"
    message: "something (smellcat/smelltype) (in method 1 time(s))",
    signature: "reek::something (smellcat/smelltype) (in method 1 time(s))",
    type: "maintainability"
    where: {
      end: {}
      start: { line: 8 }
    }
  },
  {
    path: "bar.rb",
    message: "something else (smellcat2/smelltype2) (in another_method 4 time(s))",
    signature: "reek::something else (smellcat2/smelltype2) (in another_method 4 time(s))",
    type: "maintainability",
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
  setup: setup
