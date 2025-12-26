sub init()
    m.json = getJson()
    m.top.functionName = "execute"
end sub

sub execute()
    taskPayload = m.top.taskPayload
    responce = BasicSearchChannels(m.json, taskPayload.query)
    m.top.response = responce
end sub

function BasicSearchChannels(channels as Object, query as String) as Object
    results = []

    for each item in channels
        ' ?"BasicSearchChannels"
        if item <> invalid
            if item.title.Instr(query) <> -1 or item.category.Instr(query) <> -1 then
                results.Push(item)
            end if
        end if
    end for

    return results
end function