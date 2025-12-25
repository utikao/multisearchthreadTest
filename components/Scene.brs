sub init()
    m.top.backgroundURI = "pkg:/images/rsgde_bg_hd.jpg"

    example = m.top.findNode("exampleKeyboard")
    example.observeField("text", "StartSearch")
    examplerect = example.boundingRect()
    centerx = (1280 - examplerect.width) / 2
    centery = (720 - examplerect.height) / 2
    example.translation = [ centerx, centery ]

    m.top.setFocus(true)
    m.searchTask = CreateObject("roSGNode", "SearchTask")
    m.searchTask.control = "RUN"
    m.searchTask.taskpayload = {
        query: ""
    }
    m.searchTask.observeField("response", "OnSearchResponse")
end sub

sub StartSearch(event as Object)
    ?"StartSearch"
    searchText = event.getData()
    m.searchTask.taskpayload = {
        query: searchText
    }
    m.searchTask.control = "RUN"
end sub

sub OnSearchResponse(event)
    responce = event.getData()
    ?"OnSearchResponse",responce
end sub