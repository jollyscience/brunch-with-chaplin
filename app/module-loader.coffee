mediator = require 'mediator'

module.exports = class ModuleLoader
  constructor: ->
    @initialize()

  #stores instances of modules so they can be called later
  moduleInstances: {}
  
  #stores instances of collections so they can be called later
  collections: {}

  initialize: =>
    mediator.subscribe 'module:load', @loadModule
    mediator.subscribe 'collection:load', @loadCollection

  loadCollection: (options) =>
    unless options.params?
      options.params = {}
    
    unless options.options?
      options.options = {}

    unless @collections[options.id]?
      try
        @collections[options.id] = new options.class()
        @collections[options.id].keepAlive = true
        @collections[options.id].id = options.id
        @collections[options.id].initDeferred()
        @collections[options.id]['_dispose'] = @collections[options.id].dispose
        @collections[options.id].dispose = null
        @collections[options.id].init(options.options)
        mediator.publish "collection:loaded::#{options.id}"
      catch err
        console.log err, err.message
  
    if @collections[options.id]?
      if options.done
        @collections[options.id].done ( =>
          options.done(@collections[options.id])
        )

  loadModule: (options) =>
    unless options.id?
      unless options.container?
        options.container = $("##{id}")

    unless options.initOptions?
      options.initOptions = {}

    unless options.params?
      options.params = {}

    options.params.container = options.container

    unless @moduleInstances[options.id]?
      try
        module = require "modules/#{options.module}/#{options.module}-controller"
        @moduleInstances[options.id] = new module(options.initOptions)
        @moduleInstances[options.id].isModule = true
        mediator.publish "module:loaded::#{options.id}"
      catch err
        console.log err, err.message
    
    if options.action?
      @moduleInstances[options.id].done( => 
        @moduleInstances[options.id][options.action] options.params
      )