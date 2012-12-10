ModuleController = require 'controllers/base/module-controller'
HeaderView = require './views/header-view'

module.exports = class HeaderController extends ModuleController
  initialize: ->
    super
    @view = new HeaderView()
