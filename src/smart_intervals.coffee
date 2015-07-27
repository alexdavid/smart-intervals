class SmartInterval

  constructor: (@function, @time) ->
    @_timeOut = null
    @_postRunCallbacks = []
    @_setTimeout()


  stop: (done) ->
    if @_waitingForTimeout()
      @_clearTimeout()
      done?()
    else
      @_postRunCallbacks.push done


  runNow: (done) ->
    @_postRunCallbacks.push done
    if @_waitingForTimeout()
      @_clearTimeout()
      @_runFunction()


  _clearTimeout: ->
    clearTimeout @_timeOut
    @_timeOut = null


  _runFunction: =>
    @_timeOut = null
    @function.call {}, =>
      cb?() for cb in @_postRunCallbacks
      @_postRunCallbacks = []
      @_setTimeout()


  _setTimeout: ->
    throw Error 'SmartInterval: timeout already set' if @_waitingForTimeout()
    @_timeOut = setTimeout @_runFunction, @time


  _waitingForTimeout: -> @_timeOut?


module.exports = (ms, fn) -> new SmartInterval fn, ms
