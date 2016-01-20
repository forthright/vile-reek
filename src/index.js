let _ = require("lodash")
let vile = require("@brentlintner/vile")

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

let message = (issue) =>
  `${issue.message} (${issue.smell_category}/` +
    `${issue.smell_type}) (in ${issue.context} ${issue.count} time(s))`

let vile_issue = (issue) =>
  vile.issue({
    type: vile.STYL,
    path: issue.source,
    title: message(issue),
    message: message(issue),
    signature: "reek::" + message(issue),
    where: {
      start: start(issue),
      end: end(issue)
    }
  })

let punish = (plugin_config) =>
  reek(_.get(plugin_config, "config"))
    .then((cli_json) => cli_json.map(vile_issue))

module.exports = {
  punish: punish
}
