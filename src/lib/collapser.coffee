class Collapser
  @bindEvent: (item, options) ->
    @options = options
    collapser = document.createElement('div')
    collapser.className = 'collapser'
    collapser.innerHTML = if @options.collapsed then '+' else '-'
    collapser.addEventListener('click', (event) =>
      @toggle(event.target)
    )
    item.insertBefore(collapser, item.firstChild)
    @collapse(collapser, @collapseTargets(collapser)[0]) if @options.collapsed

  @expand: (collapser, target) ->
    return unless @isCollapsed(target)
    ellipsis = target.parentNode.getElementsByClassName('ellipsis')[0]
    target.parentNode.removeChild(ellipsis)
    target.style.display = ''
    collapser.innerHTML = '-'

  @collapse: (collapser, target) ->
    return if @isCollapsed(target)
    target.style.display = 'none'
    ellipsis = document.createElement('span')
    ellipsis.className = 'ellipsis'
    ellipsis.innerHTML = ' &hellip; '
    target.parentNode.insertBefore(ellipsis, target)
    collapser.innerHTML = '+'

  @toggle: (collapser) ->
    targets = @collapseTargets(collapser)

    action = if @isCollapsed(targets[0]) then 'expand' else 'collapse'

    if @options.recursive_collapser
      collapsers = collapser.parentNode.getElementsByClassName('collapser')
      for _, index in collapsers
        @[action](collapsers[index], targets[index])
    else
      @[action](collapser, targets[0])

  @collapseTargets: (collapser) ->
    targets = collapser.parentNode.getElementsByClassName('collapsible')
    return unless targets.length
    targets

  @isCollapsed: (target) ->
    target.style.display == 'none'

