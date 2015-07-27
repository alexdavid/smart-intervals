smartInterval = require '../src/smart_intervals'


describe 'smartInterval', ->

  beforeEach ->
    @clock = sinon.useFakeTimers()
    @interval = smartInterval 100, @fn = sinon.stub()

  afterEach ->
    @clock.restore()

  it 'does nothing initially', ->
    expect(@fn).to.not.have.been.called

  it 'calls function after timeout', ->
    @clock.tick 100
    expect(@fn).to.have.been.calledOnce

  it 'does not continue the interval until the callback is called', ->
    @clock.tick 100
    expect(@fn).to.have.been.calledOnce
    @clock.tick 999
    expect(@fn).to.have.been.calledOnce
    @fn.callArg 0
    expect(@fn).to.have.been.calledOnce
    @clock.tick 100
    expect(@fn).to.have.been.calledTwice

  it 'throws an error when calling callback multiple times', ->
    expect(=>
      @clock.tick 100
      @fn.callArg 0
      @fn.callArg 0
    ).to.throw Error


  describe '#stop', ->

    context 'waiting for timeout', ->

      beforeEach ->
        @clock.tick 50

      it 'stops the interval', ->
        @interval.stop()
        @clock.tick 100
        expect(@fn).to.not.have.been.called

      it 'calls its callback immediately', ->
        @interval.stop stopSpy = sinon.spy()
        expect(stopSpy).to.have.been.calledOnce


    context 'waiting for async function', ->

      beforeEach ->
        @clock.tick 100

      it 'waits for the async function to return', ->
        @interval.stop stopSpy = sinon.spy()
        @clock.tick 999
        expect(stopSpy).to.not.have.been.called
        @fn.callArg 0
        expect(stopSpy).to.have.been.calledOnce

      it 'does not error if callback is not provided', ->
        @interval.stop()
        @clock.tick 999
        @fn.callArg 0



  describe '#runNow', ->

    context 'waiting for timeout', ->

      beforeEach ->
        @clock.tick 50

      it 'runs the function immediately', ->
        @interval.runNow()
        expect(@fn).to.have.been.calledOnce

      it 'resumes normal operation', ->
        @interval.runNow()
        expect(@fn).to.have.been.calledOnce
        @clock.tick 999
        @fn.lastCall.callArg 0
        @clock.tick 99
        expect(@fn).to.have.been.calledOnce
        @clock.tick 1
        expect(@fn).to.have.been.calledTwice
        @clock.tick 999
        @fn.lastCall.callArg 0
        @clock.tick 99
        expect(@fn).to.have.been.calledTwice
        @clock.tick 1
        expect(@fn).to.have.been.calledThrice

      it 'calls callback after async action returns', ->
        @interval.runNow runNowSpy = sinon.spy()
        @clock.tick 999
        expect(runNowSpy).to.not.have.been.called
        @fn.callArg 0
        expect(runNowSpy).to.have.been.calledOnce


    context 'waiting for async function', ->

      beforeEach ->
        @clock.tick 100

      it 'waits for the async function to return', ->
        @interval.runNow runNowSpy = sinon.spy()
        @clock.tick 999
        expect(@fn).to.have.been.calledOnce
        expect(runNowSpy).to.not.have.been.called
        @fn.callArg 0
        expect(runNowSpy).to.have.been.calledOnce
