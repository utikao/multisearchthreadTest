sub init()
    m.top.backgroundURI = "pkg:/images/rsgde_bg_hd.jpg"

    example = m.top.findNode("exampleKeyboard")
    example.observeField("text", "onTextChanged")
    examplerect = example.boundingRect()
    centerx = (1280 - examplerect.width) / 2
    centery = (720 - examplerect.height) / 2
    example.translation = [ centerx, centery ]

    m.top.setFocus(true)
    m.searchTask = CreateObject("roSGNode", "SearchTask")
    m.searchTask.observeField("response", "OnSearchResponse")
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
    m.searchTask.taskpayload = {
        query: searchText
    }
    m.searchTask.control = "RUN"
end sub

sub OnSearchResponse(event)
    responce = event.getData()
    Print "Task took: " + m.searchTimer.TotalMilliseconds().ToStr()
    ' ?"OnSearchResponse",responce
end sub