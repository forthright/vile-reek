let _ = require("lodash")
let vile = require("@brentlintner/vile")
let ignore = require("ignore-file")

let is_ruby_file = (file) => !!file.match(/\.rb$/)

let allowed = (ignore_list) => {
  let ignored = ignore.compile(ignore_list.join("\n"))
  return (file) => is_ruby_file(file) && !ignored(file)
}

let reek = (custom_config_path) => {
  let opts = { args: [".", "--format", "json"] }

  if (custom_config_path) {
    opts.args = [
      "-c", custom_config_path
    ].concat(opts.args)
  }

  return vile
    .spawn("reek", opts)
    .then((stdout) => stdout ? JSON.parse(stdout) : [])
}

let start = (issue) => { return { line: issue.lines[0] } }

let end = (issue) => issue.lines.length > 1 ?
  { line: issue.lines[issue.lines.length - 1] } : undefined

let message = (issue) => {
  return `${issue.message} (${issue.smell_category}/` +
    `${issue.smell_type}) (in ${issue.context} ${issue.count} time(s))`
}

let vile_issue = (issue) => {
  return vile.issue(
    vile.ERROR,
    issue.source,
    message(issue),
    start(issue),
    end(issue)
  )
}

let punish = (plugin_config) => {
  let config = _.get(plugin_config, "config")
  let ignore = _.get(plugin_config, "ignore", [])

  return vile.promise_each(
    process.cwd(),
    allowed(ignore),
    (filepath) => vile.issue(vile.OK, filepath),
    { read_data: false }
  )
  .then((all_files) => {
    return reek(config)
      .then((cli_json) => cli_json.map(vile_issue))
      .then((issues) => {
        return _.reject(all_files, (file) => {
          return _.any(issues, (issue) => issue.file == file.file)
        }).concat(issues)
      })
  })
}

module.exports = {
  punish: punish
}
