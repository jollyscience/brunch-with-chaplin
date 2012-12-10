Chaplin = require 'chaplin'

mediator = require 'mediator'

module.exports = class ModuleController extends Chaplin.Controller

#overwrite chaplinController- otherwise init is called twice
  constructor: () ->
    @initDeferred()
    super()
  
  initialize: (options) ->

    unless @asModule or @asController?
      @init(options)
    else
      if @isModule and @asModule
        @asModule(options)
      else if @isModule isnt true and @asController?
        @asController(options)  
      
    return @promise()
          
  # Creates a new deferred and mixes it into the controller
  # This method can be called multiple times to reset the
  # status of the Deferred to 'pending'.
  initDeferred: ->
    _(this).extend $.Deferred()
    
  # initialize will wrap this in a Deferred Object, Overwrite the init function to prevent the 
  # controller from being resolved immediately
  init: () =>
    @loaded()
  
  loaded: () =>
    @resolve.apply(arguments)
    
  # Used to load collections automatically if called as a module
  asModule: (options) =>
    if options.collection_id? and options.collection_class? then (@loadCollection options.collection_id, options.collection_class)
    
    
  # Shorthand function to load a collection using the module_loader
  loadCollection: (id, collectionClass, bootstrap) =>  
    mediator.publish 'collection:load',
      id: id
      class: collectionClass
      options:
        bootstrap: bootstrap
      done: (collection) =>
        @collection = collection
        @loaded()