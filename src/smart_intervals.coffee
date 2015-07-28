roca = require 'robust-callbacks'


class SmartInterval

  constructor: (@function, @time) ->
    @_timeOut = null
    @_stopped = no
    @_postRunCallbacks = []
    @_setTimeout()


  stop: (done) ->
    @_stopped = yes

    if @_timeOut?
      @_clearTimeout()
      done?()
    else
      @_postRunCallbacks.push done


  runNow: (done) ->
    @_postRunCallbacks.push done

    if @_timeOut?
      @_clearTimeout()
      @_runFunction()


  _clearTimeout: ->
    clearTimeout @_timeOut
    @_timeOut = null


  _runFunction: =>
    @_timeOut = null
    @function.call {}, roca =>
      cb?() for cb in @_postRunCallbacks
      @_postRunCallbacks = []
      return if @_stopped
      @_setTimeout()


  _setTimeout: ->
    @_timeOut = setTimeout @_runFunction, @time


module.exports = (ms, fn) -> new SmartInterval fn, ms
