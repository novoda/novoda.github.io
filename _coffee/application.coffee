$(document).ready ->
  app.init()
  github.init()

app =
  init: ->
    @bind_events()
    @sticky_nav_bottom()

  bind_events: ->
    $(window).scroll ->
      app.sticky_nav_top()
      app.sticky_nav_bottom()

    # Anchor scrolling
    $(document).on 'click', '[data-anchor-link]', (e) ->
      e.preventDefault()
      anchor = $(this).attr('data-anchor-link')
      offset = $('[data-anchor="'+anchor+'"]').offset().top - 60
      $('html,body').animate
        scrollTop: offset + 'px'
      , 1000

  sticky_nav_top: ->
    if $(window).width() > 705
      offset_top = $(".main-header").height()
      if $(window).scrollTop() >= offset_top
        $(".main-nav").addClass("sticky-top")
        $(".sticky-spacer").show()
      else
        $(".main-nav").removeClass("sticky-top")
        $(".sticky-spacer").hide()

  sticky_nav_bottom: ->
    if $(window).width() > 705
      if $(".main-header").height() > $(window).height() - 60
        $(".main-nav").addClass("sticky-bottom")
        # console.log $(".main-header").outerHeight(), $(window).height()
        # console.log "Nav sticks to bottom now"
      scroll_offset = $(".main-header").height() - $(window).height() + 60
      if $(window).scrollTop() >= scroll_offset
        $(".main-nav").removeClass("sticky-bottom")
        # console.log $(".main-header").outerHeight(), $(window).height()
        # console.log "Nav doesn't stick on bottom now"


categories =
  'build-time':
    0: 'aosp.changelog.to'
    1: 'notils'
    2: 'bintray-release'
  'test-time':
    0: 'gradle-android-command-plugin'
    1: 'gradle-android-test-plugin'
    2: 'gradle-android-jacoco-plugin'
  'run-time':
    0: 'image-loader'
    1: 'merlin'
    2: 'download-manager'
    3: 'cast-receiver'
    4: 'ExoPlayer'
  'apps':
    0: 'android-demos'
    1: 'public-mvn-repo'
    2: 'ci-game-plugin'
    3: 'ios-demos'
    4: 'aws-java-sample'
  'scripting':
    0: 'material-painter'
    1: 'dojos'
    2: 'droidcon-booth'
    3: 'iosched-webapp'
    4: 'novoda'
    5: 'landing-strip'
    6: 'github-oauth-plugin'
    7: 'accessibilitools'
    8: 'hubot-slack'


github =
  username: "novoda"
  api_url: "https://api.github.com"
  cat_temp: ''
  cat_key_temp: ''
  repo_count: 0
  contributor_count: 0

  init: ->
    @get_repositories()

  get_repositories: ->
    endpoint = @api_url + '/users/' + @username + '/repos'
    @fetch endpoint, @list_repositories

  list_repositories: (repos) ->
    repos = github.sort_object repos, 'stargazers_count'
    github.repo_count = repos.length
    $.each repos, (key, val) ->
      cat = github.get_category val
      if cat is ''
        cat = 'default'
      repo = '<div class="repo" data-rid="'+val.id+'"><h3>'+(val.language or "Script")+'</h3><h2><a href="'+val.html_url+'">'+val.name+'</a></h2><div class="repo-meta"><a href="'+val.stargazers_url+'"><span class="entypo-star"></span> '+val.stargazers_count+'</a><a href="'+val.forks_url+'"><span class="entypo-flow-branch"></span> '+val.forks+'</a></div><p>'+(val.description or "")+'</p><div class="repo-contributors"></div></div>'
      $('.repos[data-category="'+cat+'"] .loading').hide()
      $('.repos[data-category="'+cat+'"]').append repo
      github.get_contributors val.name, val.id

  get_category: (repo) ->
    github.cat_temp = ''
    github.cat_key_temp = ''
    $.each categories, (key, val) ->
      github.cat_key_temp = key
      $.each val, (i, d) ->
        if d is repo.name
          github.cat_temp = github.cat_key_temp
    github.cat_temp

  get_contributors: (repo_name, repo_id) ->
    endpoint = @api_url + '/repos/' + @username + '/' + repo_name + '/contributors'
    @fetch endpoint, @list_contributors, repo_id

  list_contributors: (contributors, repo_id) ->
    contributors = github.sort_object contributors, 'contributions'
    github.contributor_count += contributors.length
    repo = $('.repo[data-rid="'+repo_id+'"]')
    i = 0
    while i < 5
      c = '<a href="'+contributors[i].html_url+'"><img src="'+contributors[i].avatar_url+'" alt="" title="'+contributors[i].login+'" /></a>'
      $('.repo-contributors', repo).append c
      i++

  sort_object: (data, property) ->
    byProperty = (prop) ->
      (a, b) ->
        if typeof a[prop] == 'number'
          b[prop] - (a[prop])
        else
          if a[prop] < b[prop] then -1 else if a[prop] > b[prop] then 1 else 0
    return data.sort(byProperty(property))

  fetch: (url, callback, callback_param = '') ->
    $.ajax(
      method: 'GET'
      url: url
    ).done (data) ->
      if callback_param is ''
        callback data
      else
        callback data, callback_param