"use strict";

var _ = require("lodash");
var vile = require("vile");

var reek = function reek(custom_config_path) {
  var opts = { args: [".", "--format", "json"] };

  if (custom_config_path) {
    opts.args = ["-c", custom_config_path].concat(opts.args);
  }

  return vile.spawn("reek", opts).then(function (data) {
    var stdout = _.get(data, "stdout");
    return stdout ? JSON.parse(stdout) : [];
  });
};

var start = function start(issue) {
  return { line: issue.lines[0] };
};

var end = function end(issue) {
  return issue.lines.length > 1 ? { line: issue.lines[issue.lines.length - 1] } : {};
};

var message = function message(issue) {
  return issue.message + " (" + issue.smell_category + "/" + (issue.smell_type + ") (in " + issue.context + " " + issue.count + " time(s))");
};

var vile_issue = function vile_issue(issue) {
  return vile.issue({
    type: vile.MAIN,
    path: issue.source,
    message: message(issue),
    signature: "reek::" + message(issue),
    where: {
      start: start(issue),
      end: end(issue)
    }
  });
};

var punish = function punish(plugin_config) {
  return reek(_.get(plugin_config, "config")).then(function (cli_json) {
    return cli_json.map(vile_issue);
  });
};

module.exports = {
  punish: punish
};