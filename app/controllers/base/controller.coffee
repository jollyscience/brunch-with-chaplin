Chaplin = require 'chaplin'

mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
    
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