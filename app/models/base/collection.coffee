Chaplin = require 'chaplin'
Model = require 'models/base/model'

mediator = require 'mediator'

module.exports = class Collection extends Chaplin.Collection
  # Use the project base model per default, not Chaplin.Model
  model: Model
  
  # Mixin a synchronization state machine
  # _(@prototype).extend SyncMachine

  # subscribed to function used to refresh all collections. Can be overridden in child classes
  init: (options) =>
    mediator.subscribe 'collections:fetch', => 
      @initDeferred()
      @fetch()
            
  fetch: (options) => 
    unless options? then options = {}     
    options.cache = false #Prevents IE from caching JSON
    
    options.success = => @resolve()
    super(options)

  # Turns Collection into a deferred object. Additionally publishes notification if the collection is empty
  # after fetching  
  initDeferred: =>
    super
    @done => 
      if @length is 0 then mediator.publish "collection:isEmpty::#{@id}"  