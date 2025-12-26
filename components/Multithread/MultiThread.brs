sub init()
    initTaskManager()
    m.top.backgroundURI = "pkg:/images/rsgde_bg_hd.jpg"

    example = m.top.findNode("exampleKeyboard")
    example.observeField("text", "onTextChanged")
    examplerect = example.boundingRect()
    centerx = (1280 - examplerect.width) / 2
    centery = (720 - examplerect.height) / 2
    example.translation = [ centerx, centery ]

    m.top.setFocus(true)
    m.timer = m.top.findNode("searchDebounceTimer")
    m.timer.observeField("fire", "onDebounceFire")
    m.searchTimer = CreateObject("roTimespan")
end sub

sub onTextChanged(event as Object)
    m.pendingQuery = event.getData()
    m.timer.control = "stop"
    m.timer.control = "start"
end sub

sub onDebounceFire()
    if m.pendingQuery <> invalid and m.pendingQuery <> "" then
        m.searchTimer.Mark()
        StartSearch(m.pendingQuery)
    end if
end sub

sub StartSearch(searchText as string)
    ?"StartSearch"
    Search(searchText)
end sub

sub OnSearchResponse(responce)
    Print "Task took: " + m.searchTimer.TotalMilliseconds().ToStr()
    ' ?"OnSearchResponse",responce
end sub