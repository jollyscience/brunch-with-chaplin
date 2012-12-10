View = require 'views/base/view'
template = require '../templates/header'

module.exports = class HeaderView extends View
  template: template
  autoRender: yes
  className: 'header'
  container: '#header-container'
  id: 'header'
