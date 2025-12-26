sub init()
    m.json = getJson()
    m.top.functionName = "execute"
end sub

sub execute()
    taskPayload = m.top.taskPayload
    responce = BasicSearchChannels(m.json, taskPayload.query,m.top.startingIndex,m.top.itemsPerTask)
    m.top.response = {responce: responce,id :m.top.arrayId}
end sub

function TrimString(s as String) as String
    start = 1
    finish = Len(s)

    while start <= finish and Mid(s, start, 1) = " "
        start++
    end while

    while finish >= start and Mid(s, finish, 1) = " "
        finish--
    end while

    if start > finish then return ""
    return Mid(s, start, finish - start + 1)
end function

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