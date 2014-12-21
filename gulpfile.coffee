# gulpfile.coffee: build script for front assets
#
# gulp        - build assets
# gulp watch  - build assets continuously
# gulp server - start a server with assets and mocked APIs

sources =
  bower:  'bower.json'
  ts:     'app/**/*.ts'
  sass:   'app/**/*.scss'
  static: 'public/**/*'

libs =
  js: [
    'jquery/dist/jquery.min.js'
    'knockout/dist/knockout.js'
  ]
  css:    ['bootstrap/dist/**/*.min.css']
  static: ['bootstrap/dist/**/*']


bower       = require 'bower'
del         = require 'del'
gulp        = require 'gulp'
coffee      = require 'gulp-coffee'
ts          = require 'gulp-typescript'
concat      = require 'gulp-concat'
sass        = require 'gulp-ruby-sass'
nodemon     = require 'gulp-nodemon'
uglify      = require 'gulp-uglify'
plumber     = require 'gulp-plumber'

gulp.task 'default', ['clean'], ->
  gulp.start 'compile:lib', 'compile:ts', 'compile:sass', 'compile:static'

gulp.task 'clean', (cb) ->
  del 'target/webapp/', cb

gulp.task 'watch', ->
  gulp.watch sources.bower,  ['compile:lib']
  gulp.watch sources.ts,    ['compile:ts']
  gulp.watch sources.sas, ['compile:sass']
  gulp.watch sources.static, ['compile:static']

gulp.task 'compile:lib', ->
  bower.commands.install().on 'end', ->
    gulp.src libs.js.map (e) -> "bower_components/#{e}"
      .pipe concat 'lib.js'
      .pipe gulp.dest 'target/webapp/'
    gulp.src libs.css.map (e) -> "bower_components/#{e}"
      .pipe concat 'lib.css'
      .pipe gulp.dest 'target/webapp/'
    gulp.src libs.static.map (e) -> "bower_components/#{e}"
      .pipe gulp.dest 'target/webapp/'


tsProject = ts.createProject({
  declarationFiles: true,
  noExternalResolve: true
})

gulp.task 'compile:ts', ->
  gulp.src sources.ts
    .pipe plumber()
    .pipe ts(tsProject)
    .pipe uglify()
    .pipe concat 'app.js'
    .pipe gulp.dest 'target/webapp'

gulp.task 'compile:sass', ->
  gulp.src sources.sass
    .pipe plumber()
    .pipe sass()
    .pipe concat 'app.css'
    .pipe gulp.dest 'target/webapp'

gulp.task 'compile:static', ->
  gulp.src sources.static
    .pipe gulp.dest 'target/webapp/'


gulp.task 'server', ['compile:apimock'], ->
  gulp.start 'watch', 'watch:apimock'
  nodemon
    script: 'target/apimock.js'
    watch: ['target/apimock.js', 'target/webapp/']
    env:
      port: 8888
      webapp: "#{__dirname}/target/webapp/"

gulp.task 'watch:apimock', ->
  gulp.watch 'apimock.coffee', ['compile:apimock']

gulp.task 'compile:apimock', ->
  gulp.src 'apimock.coffee'
    .pipe coffee()
    .pipe gulp.dest 'target/'
