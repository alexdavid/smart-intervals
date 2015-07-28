# Smart Intervals [![Circle CI](https://circleci.com/gh/alexdavid/smart-intervals/tree/master.svg?style=svg)](https://circleci.com/gh/alexdavid/smart-intervals/tree/master)

`setInterval` replacement for asynchronous tasks

```javascript
var smartInterval = require('smart-intervals')

interval = smartInterval(1000, function(callback) {
  doAsyncActiviy(callback)
  // interval will be called again 1000ms after doAsyncActiviy calls its callback
})
```

## Methods

### `interval.stop([callback])`

Clears the interval.

If the interval was waiting for the next run it calls the optional callback immediately.

If the interval is waiting for its async function to return it calls the optional callback once the async function finishes


### `interval.runNow([callback])`

Skips waiting for the interval and calls the function immediately if not already running.

Calls the optional callback once the async function finishes
