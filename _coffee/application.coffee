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

    # More Button
    $(document).on 'click', '.btn-more', (e) ->
      e.preventDefault()
      offset = $('.main-header').height()
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
    0: 16004885 # sqlite-analyzer
    1: 25312557 # bintray-release
    2: 19490270 # gradle-android-command-plugin
    3: 10677957 # robolectric-plugin
    4: 17395619 # gradle-android-jacoco-plugin
    5: 53143469 # ios-demos
    6: 73317406 # gradle-build-properties-plugin
    7: 73275282 # gradle-static-analysis-plugin
    8: 78538262 # eslint-config-novoda
  'run-time':
    0: 11662606 # notils
    1: 35211795 # download-manager
    2: 35604965 # rxmocks
    3: 35604995 # rxpresso
    4: 46065249 # simple-chrome-custom-tabs
    5: 10883852 # simple-easy-xml-parser
    6: 9941578  # merlin
    7: 1077753  # sqlite-provider
    8: 35665177 # landing-strip
    9: 2161802  # image-loader
    10: 55979944 # view-pager-adapter
    11: 54135763 # accessibilitools
  'apps':
    0: 47839983 # snowy-village-wallpaper
    1: 44617096 # droidcon-booth
    2: 31185420 # material-painter
    3: 31650174 # iosched-webapp
    4: 50032733 # novoda.github.io
    5: 61706237 # bonfire-firebase-sample
  'scripting':
    0: 32337114 # aosp.changelog.to
    1: 26584518 # novoda
    2: 13472524 # gradle-android-test-plugin
  'do-not-list':
    0: 6509909  # dojos
    1: 13300550 # spikes
    2: 260841   # android-demos
    3: 24189087 # RxAndroid
    4: 22604806 # ci-game-plugin
    5: 27539225 # junit-plugin
    6: 23464489 # pmd
    7: 27084480 # github-oauth-plugin
    8: 41148441 # hubot-slack
    9: 52445441 # ExoPlayer
    10: 52599862 # aws-java-sample
    11: 2168934  # public-mvn-repo

### Repository IDs
2161802  # image-loader
35604995 # rxpresso
1077753  # sqlite-provider
25312557 # bintray-release
9941578  # merlin
31185420 # material-painter
19490270 # gradle-android-command-plugin
11662606 # notils
13472524 # gradle-android-test-plugin
35211795 # download-manager
10677957 # robolectric-plugin
16004885 # sqlite-analyzer
46065249 # simple-chrome-custom-tabs
35604965 # rxmocks
10883852 # simple-easy-xml-parser
47839983 # snowy-village-wallpaper
44617096 # droidcon-booth
17395619 # gradle-android-jacoco-plugin
26584518 # novoda
31650174 # iosched-webapp
2168934  # public-mvn-repo
32337114 # aosp.changelog.to
24189087 # RxAndroid
35665177 # landing-strip
55979944 # view-pager-adapter
28082079 # cast-receiver
22604806 # ci-game-plugin
27539225 # junit-plugin
23464489 # pmd
27084480 # github-oauth-plugin
41148441 # hubot-slack
52445441 # ExoPlayer
52599862 # aws-java-sample
53143469 # ios-demos
54135763 # accessibilitools
50032733 # novoda.github.io
61706237 # bonfire-firebase-sample
73312159 # dashboards
78538262 # eslint-config-novoda
65547837 # github-reports
73317406 # gradle-build-properties-plugin
73275282 # gradle-static-analysis-plugin
###


github =
  username: "novoda"
  api_url: "https://api.github.com"
  at: "077be9086e2ef3479e91c8b7682dfb2fcd0d0112"
  cat_temp: ''
  cat_key_temp: ''
  repo_count: 0
  contributor_count: 0

  init: ->
    @get_repositories()

  get_repositories: ->
    endpoint = @api_url + '/orgs/' + @username + '/repos?type=public&per_page=100&access_token=' + @at
    @fetch endpoint, @list_repositories

  list_repositories: (repos) ->
    repos = github.sort_object repos, 'stargazers_count'
    github.repo_count = repos.length
    $.each repos, (key, val) ->
      cat = github.get_category val
      unless cat is 'do-not-list'
        if cat is ''
          cat = 'default'
        # console.log val
        repo = '<div class="repo" data-rid="'+val.id+'"><h3>'+(val.language or "Script")+'</h3><h2><a href="'+val.html_url+'">'+val.name+'</a></h2><p>'+(val.description or "You can find more information on GitHub.")+'</p><div class="repo-contributors"></div><div class="repo-meta"><a href="https://github.com/'+github.username+'/'+val.name+'/stargazers"><span class="entypo-star"></span> '+val.stargazers_count+'</a><!--<a href="https://github.com/'+github.username+'/'+val.name+'/forks"><span class="entypo-flow-branch"></span> '+val.forks+'</a>--></div></div>'
        $('.repos[data-category="'+cat+'"] .loading').hide()
        $('.repos[data-category="'+cat+'"]').append repo
        github.get_contributors val.name, val.id

  get_category: (repo) ->
    github.cat_temp = ''
    github.cat_key_temp = ''
    $.each categories, (key, val) ->
      github.cat_key_temp = key
      $.each val, (i, d) ->
        # Check if repo is in this category
        if d is repo.id
          github.cat_temp = github.cat_key_temp
    github.cat_temp

  get_contributors: (repo_name, repo_id) ->
    endpoint = @api_url + '/repos/' + @username + '/' + repo_name + '/contributors?access_token=' + @at
    @fetch endpoint, @list_contributors, repo_id

  list_contributors: (contributors, repo_id) ->
    if contributors
      contributors = github.sort_object contributors, 'contributions'
      github.contributor_count += contributors.length
      repo = $('.repo[data-rid="'+repo_id+'"]')
      i = 0
      while i < 5
        if contributors[i]
          c = '<a href="https://github.com/'+contributors[i].login+'"><img src="'+contributors[i].avatar_url+'" alt="" title="'+contributors[i].login+'" /></a>'
          $('.repo-contributors', repo).append c
        i++
    github.display_stats()

  display_stats: ->
    $('.repo-count').html github.repo_count
    $('.contributor-count').html github.contributor_count

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
