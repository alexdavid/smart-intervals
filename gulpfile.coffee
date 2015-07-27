coffee = require 'gulp-coffee'
gulp = require 'gulp'

gulp.task 'default', ->
  gulp.src './src/*.coffee'
      .pipe coffee()
      .pipe gulp.dest './lib'
