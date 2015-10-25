mimus = require "mimus"
Promise = require "bluebird"
reek = mimus.require "./../lib", __dirname, []
chai = require "./helpers/sinon_chai"
util = require "./helpers/util"
vile = mimus.get reek, "vile"
expect = chai.expect

# TODO: write integration tests for spawn -> cli
# TODO: don't use setTimeout everywhere (for proper exception throwing)

describe "running reek", ->
  after mimus.restore
  afterEach mimus.reset

  beforeEach ->
    mimus.stub vile, "promise_each"
    mimus.stub vile, "spawn"
    util.setup vile

  it "calls reek in the cwd", (done) ->
    reek
      .punish {}
      .should.be.fulfilled.notify ->
        setTimeout ->
          vile.promise_each.should.have.been
            .calledWith process.cwd()

          vile.spawn.should.have.been
            .calledWith "reek", args: [
                            "."
                            "--format"
                            "json"
                          ]
          done()
        , 1

  it "converts reek json to issues", ->
    reek
      .punish {}
      .should.eventually.eql util.issues

  it "creates a separate list of ok issues for all rb files", (done) ->
    reek
      .punish {}
      .should.be.fulfilled.notify ->
        setTimeout ->
          create_issue = vile.promise_each.args[0][2]
          expect(create_issue("foo.rb")).to
            .eql util.all_files[0]
          done()
        , 1


  it "handles an empty response", ->
    vile.spawn.reset()
    vile.spawn.returns new Promise (resolve) -> resolve ""

    reek
      .punish {}
      .should.eventually.eql util.all_files

  describe "config", ->
    it "supports it as a custom reek config file path", (done) ->
      config_path = ".reek.yml"

      reek
        .punish config: config_path
        .should.be.fulfilled.notify ->
          setTimeout ->
            vile.spawn.should.have.been
              .calledWith "reek", args: [
                            "-c"
                            config_path
                            "."
                            "--format"
                            "json"
                          ]
            done()
          , 1

  describe "ignore", ->
    it "is used as expected when collecting all files", (done) ->
      reek
        .punish ignore: [
          "node_modules"
          "some/dir/**"
          "somefile.rb"
        ]
        .should.be.fulfilled.notify ->
          allowed = vile.promise_each.args[0][1]
          setTimeout ->
            expect(allowed("node_modules/foo.rb"), 1).to.be.false
            expect(allowed("some/dir/foo.rb"), 2).to.be.false
            expect(allowed("somefile.rb"), 3).to.be.false
            expect(allowed("anotherfile.rb"), 4).to.be.true
            done()
          , 1
