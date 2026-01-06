sub initTaskManager()
    'This is modified request manager.Its modified to best suit specific needs of seach,but same principle could be used without using specific tasks,with little loss in performance.
    'I decided against using any solutions that could violate the product requirements.
    'Search results return all items in the same order as they were received.
    'The search starts after at least one character is entered (usually three are required).
    'I check whether the search string appears anywhere in the title string, not only at the beginning.
    'Items are not deleted after each search cycle to avoid performance issues when the user deletes characters.
    'The way I got performance, required specific roku knowledge and experience, not just general programming skills.
    'I made both multi and one thread solution,to show diference in speed  between just using one task,and true scalable multitask solution.
    'The multi-threaded solution is designed to handle larger datasets more efficiently by distributing the workload across multiple tasks.
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
        for each array in m.resultarray
            for each item in array
                results.push(item)
            end for
        end for
        OnSearchResponse(results)
    end if
end sub
