sub init()
    m.top.functionName = "execute"
    ?"init"
    m.top.observeField("itemsPerTask", "splitJson")
end sub

sub splitJson()
    m.splitJson = []
    startingIndex = m.top.startingIndex
    itemsPerTask = m.top.itemsPerTask
    ?"startingIndex",startingIndex
    ?"itemsPerTask",itemsPerTask
    json = GetJson()
    while startingIndex < itemsPerTask
        item = json[startingIndex]
        ' ?"BasicSearchChannels"
        m.splitJson.push(item)
        startingIndex++
    end while
end sub

sub execute()
    taskPayload = m.top.taskPayload
    ' responce = BasicSearchChannels(Getjson(), taskPayload.query,m.top.startingIndex,m.top.itemsPerTask)
    responce = SplitSearchChannels(m.splitJson, m.top.taskPayload.query,m.top.itemsPerTask)
    m.top.response = {responce: responce,id :m.top.arrayId}
end sub

function BasicSearchChannels(channels as Object, query as String, startingIndex as Integer, itemsPerTask as Integer) as Object
    results = []
    while startingIndex < itemsPerTask
        item = channels[startingIndex]
        ' ?"BasicSearchChannels"
        if item <> invalid
            if item.title.Instr(query) <> -1 or item.category.Instr(query) <> -1 then
                results.Push(item)
            end if
        end if
        startingIndex++
    end while

    return results
end function

function SplitSearchChannels(channels as Object, query as String, itemsPerTask as Integer) as Object
    results = []
    i = 0
    while i < itemsPerTask
        item = channels[i]
        ' ?"BasicSearchChannels"
        if item <> invalid
            if item.title.Instr(query) <> -1 or item.category.Instr(query) <> -1 then
                results.Push(item)
            end if
        end if
        i++
    end while

    return results
end function