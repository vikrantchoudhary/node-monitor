# Profiling.
require('nodetime').profile()

# Reset console.
console.log '\x1B[0m'

Base = require process.cwd() + '/src/lib/base'
Config = require process.cwd() + '/src/lib/config'
Plugins = require process.cwd() + '/src/lib/plugins'
ApiInterface = require process.cwd() + '/src/lib/api'

class NodeMonitor extends Base

  constructor: () ->

    @log JSON.stringify(@info()), @bold

  loadConfig: (cb) ->

    ### Load configuration from a file. ###

    config = new Config(
      (err) =>
        @err err
      (config) =>
        # Set config globally.
        @setGlobalConfig config
        cb()
    )

  runApiInterface: (cb) ->

    ### Run the API interface. ###

    express = require 'express'
    
    # Configure the server.
    api = express()
    api.configure () ->
      api.use express.bodyParser()
      api.use express.methodOverride()
      api.use api.router

    api.get '/app', (req, res) =>

      ### Restart service. ###

      res.send 200, '{"status":"ok"}'

    api.get '/plugin', (req, res) =>

      ### Update plugin config and restart. ###

      ### Add plugin from Gist and start. ###
     
      ### Stop plugin and remove. ###

      res.send 200, '{"status":"ok"}'

    ###api.get '/*', (req, res) =>
      
      @log 'url: ' + req.originalUrl, @bold
      @log 'method: ' + req.method, @bold

      @emit 'api:req', req, res

      res.send 200, '{"status":"ok"}'###

    api.listen 3000, () -> 
      cb()

  runPlugins: (cb) ->

    ### Run plugins. ###

    @plugins = new Plugins(
      () ->
        cb()
    )

  restart: () ->

    ### Restart the service. ###

  interfaces: (cb) ->

    @on 'plugins:cpu', (cpu) ->
      @log 'plugins:cpu -> ' + cpu

    @on 'plugins:df', (disk, usage) ->
      @log 'plugins:df -> ' + disk + ', ' + usage

    @on 'plugins:filesize', (file, size, max) ->
      @log 'plugins:filesize -> ' + file + ', ' + size + ', ' + max

    @on 'plugins:load', (load) ->
      @log 'plugins:load -> ' + load

    @on 'plugins:memory', (memory, units) ->
      @log 'plugins:memory -> ' + memory + ', ' + units

    @on 'plugins:tail', (file, line) ->
      @log 'plugins:tail -> ' + file + ', ' + line

    @on 'plugins:uptime', (uptime, units) ->
      @log 'plugins:uptime -> ' + uptime + ', ' + units

    cb()

monitor = new NodeMonitor()

# Make available to all.
process.monitor = monitor

monitor.loadConfig () ->
  monitor.runApiInterface () ->
    monitor.interfaces () ->
      monitor.runPlugins () ->
        monitor.log monitor.messages.PLUGINS_LOADED, monitor.green