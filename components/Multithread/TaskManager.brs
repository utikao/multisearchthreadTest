sub initTaskManager()
    m.arr = []
    m.resultarray = []
    searchTask = invalid
    m.taskCount = 2
    m.totalItems = getJson().Count()
    fraction = m.totalItems / m.taskCount
    m.itemsPerTask = int(fraction)
    currentStartingIndex = 0

    i = 0
    while i < m.taskCount - 1
        searchTask = CreateObject("roSGNode", "MultiSearchTask")
        searchTask.observeField("response", "onResponseReceived")
        searchTask.arrayId = i
        searchTask.startingIndex = currentStartingIndex
        searchTask.itemsPerTask = m.itemsPerTask
        currentStartingIndex = currentStartingIndex + m.itemsPerTask
        m.arr.push(searchTask)
        i++
        m.resultarray.push([])
    end while
    searchTask = CreateObject("roSGNode", "MultiSearchTask")
    searchTask.observeField("response", "onResponseReceived")
    searchTask.arrayId = i
    searchTask.startingIndex = currentStartingIndex
    searchTask.itemsPerTask = m.totalItems - m.itemsPerTask * i
    m.arr.push(searchTask)
    m.resultarray.push([])

    m.top.observeField("query", "Search")
    m.top.observeField("requestArray", "MakeArrayOfRequests")
end sub

sub Search(query)

    for each task in m.arr
        task.taskPayload = {
            query: query
        }
        task.control = "RUN"
    end for
    m.tasksToLoad = m.taskCount
end sub

sub onResponseReceived(event as Object)
    taskResponse = event.Getdata()
    ' ?"onResponseReceived",taskResponse.responce
    id = taskResponse
    m.resultarray[taskResponse.id] = taskResponse.responce
    m.tasksToLoad = m.tasksToLoad - 1
    if m.tasksToLoad = 0 then
        results = []
        for each item in m.resultarray
            results.push(item)
        end for
        OnSearchResponse(results)
    end if
end sub
