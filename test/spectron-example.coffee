Application = require('spectron').Application
assert = require('assert')
fs = require('fs')

describe 'application launch', ->

  @timeout 10000

  beforeEach ->
    @app = new Application
      path: '/usr/local/bin/electron'
      args: ['./main.js']
    @app.start()

  afterEach ->
    if @app and @app.isRunning()
      return @app.stop()

  it 'shows an initial window', ->
    @app.client.getWindowCount().then (count) ->
      assert.equal count, 1

  it 'capture page', ->
    @app.browserWindow.capturePage().then (imageBuffer) ->
      fs.writeFile './captured-page.png', imageBuffer

  it 'get text', ->
    @app.client.getText "#main-message"
      .then (mainMessage)->
        console.log "The #main-message text content is " + mainMessage

  it 'CRUD localStorage', ->
    @app.client.localStorage 'POST',
      key: 'testKey'
      value: "testValue"

    @app.client.localStorage 'GET', 'testKey'
      .then (res)->
        assert.equal res.value, "testValue"

    @app.client.localStorage 'DELETE', 'testKey'

    @app.client.localStorage 'GET', 'testKey'
      .then (res)->
        assert.notEqual res.value, "testValue"

  it 'capture google top page', ->
    @app.client.url "http://google.com"
    @app.browserWindow.capturePage().then (imageBuffer) ->
      fs.writeFile './captured-webpage.png', imageBuffer

  it 'get main process logs', ->
    @app.client.getMainProcessLogs().then (logs) ->
      logs.forEach (log) ->
        console.log log

  it 'get renderer process logs',->
    @app.client.getRenderProcessLogs().then (logs) ->
      logs.forEach (log) ->
        console.log log.message
        console.log log.source
        console.log log.level
