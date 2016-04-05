/*
 * Require gulp and all the modules
 */
var gulp = require('gulp'),
    coffeelint = require('gulp-coffeelint'),
    coffee = require('gulp-coffee'),
    uglify = require('gulp-uglify'),
    concat = require('gulp-concat'),
    gulpif = require('gulp-if'),
    watch = require('gulp-watch'),
    gutil = require('gulp-util');

/*
 * Paths
 */
var paths = {
  coffee: ['./_coffee/*.coffee'],
  js: ['./js/*.js']
};

/*
 * Gulp default task
 */
gulp.task('default', ['scripts'], function() {
  // Watch script changes
  gulp.watch(paths.coffee, ['scripts', 'coffeelint']);
});

/*
 * Gulp task for javascripts
 */
gulp.task('scripts', function() {
  gulp.src(paths.coffee)
    .pipe(gulpif(/[.]coffee$/, coffee({bare: true}).on('error', gutil.log)))
    .pipe(uglify())
    .pipe(concat('application.min.js'))
    .pipe(gulp.dest('./js'));
});

/*
 * Gulp task for linting coffee
 */
gulp.task('coffeelint', function() {
  gulp.src(paths.coffee)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
});