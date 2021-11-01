#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#singleinstance force
Process, Priority,, High
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include static-math.ahk
#Include static-gui.ahk

checkpoints := []
t := 0
path := []

setupOverlaySystem()

return

^q:: ExitApp, 200
~w:: moveForward()
~f:: moveFullPath()
~e:: setCheckpoint()
~r:: resetCheckpoints()
~s:: adjustedLevel()
~d:: displayPath()

~1:: editCheckpoint(1)
~2:: editCheckpoint(2)
~3:: editCheckpoint(3)
~4:: editCheckpoint(4)

editCheckpoint(id) {
    global checkpoints

    if (id <= checkpoints.MaxIndex()) {
        updateCheckpoint(id)
    } else {
        overlayText("Checkpoint " id " does not exist")
        SoundBeep, 200, 150
    }
}

updateCheckpoint(id) {
    global checkpoints, busy

    if (busy == 1) {
        return
    }
    busy := 1

    MouseGetPos, x, y
    location := {x: x, y: y}

    addCheckpoint(location, id)
    overlayText("Update checkpoint " + id)

    SoundBeep, 1500, 50
    busy := 0
}

setCheckpoint() {
    global checkpoints, busy, t

    if (busy == 1) {
        return
    }
    busy := 1

    if (checkpoints.MaxIndex() >= 4) {
        overlayText("Maximum checkpoints reached!")
        busy := 0
        return
    }

    if (t != 0) {
        checkpoints := []
        overlayText("Cleared checkpoints")
    }

    MouseGetPos, x, y
    location := {x: x, y: y}

    addCheckpoint(location, 0)

    SoundBeep, 1000, 50
    busy := 0
}

addCheckpoint(checkpoint, id) {
    global checkpoints, path

    if (id != 0) {
        checkpoints[id] := checkpoint
    } else {
        checkpoints.Push(checkpoint)
    }
    overlayText("Checkpoint " + checkpoints.MaxIndex())

    drawCheckpointLabels(checkpoints)

    if (checkpoints.MaxIndex() < 2) {
        return
    }

    path := []
    lowResPath := []
    Loop, 100 {
        location := getLerpLocation(checkpoints, A_Index * .01)
        path.Push(location)
        if (mod(A_Index, 5) == 0 && A_Index != 0 && A_Index != 100) {
            lowResPath.Push(location)
        }
    }

    drawPath(lowResPath)
}

moveForward() {
    global checkpoints, t, path, busy

    if (busy == 1) {
        return
    }
    busy := 1

    if (checkpoints.MaxIndex() <= 1) {
        busy := 0
        return
    }

    lineHide()

    stepSize := 0.03
    if (t > 0) {
        t -= stepSize
    }

    location := path[getCurrentIndex()]
    MouseMove, location.x, location.y
    Sleep, 150

    MouseClick, , , , , , D
    stepsTaken := 0
    while (GetKeyState("w") || stepsTaken < 2)
    {
        location := path[getCurrentIndex()]

        MouseMove, location.x, location.y
        Sleep, 50

        t := t + stepSize
        stepsTaken++

        if (t > (1 + stepSize)) {
            resetCheckpoints()
            Sleep, 200
            break
        }
    }

    MouseClick, , , , , , U
}

getCurrentIndex() {
    global t
    return Round(t * 100) + 1
}

moveFullPath() {
    global checkpoints, t, path, busy

    if (busy == 1) {
        return
    }
    busy := 1

    if (checkpoints.MaxIndex() <= 1) {
        busy := 0
        return
    }

    lineHide()

    location := path[getCurrentIndex()]
    MouseMove, location.x, location.y
    Sleep, 150

    MouseClick, , , , , , D
    resolution := distance(path[1], path[2]) < 15 ? .25 : 1
    loopCount := resolution * 100
    Loop, %loopCount%
    {
        location := path[Round(A_Index / resolution)]

        MouseMove, location.x, location.y
        Sleep, 1
    }

    Sleep, 150
    MouseClick, , , , , , U

    resetCheckpoints()
    busy := 0
}

resetCheckpoints() {
    global checkpoints, path, t, busy

    checkpoints := []
    t := 0
    path := []
    busy := 0
    drawCheckpointLabels([])
    drawPath([])

    overlayText("Checkpoints reseted")
}

adjustedLevel() {
    global path, t

    maxIndex := path.MaxIndex()
    currentIndex := getCurrentIndex()
    if (maxIndex == 1 || currentIndex == 1) {
        SoundBeep, 300, 100
        return
    }

    distance := 0
    newIndexToContinueFrom := currentIndex

    Loop, %maxIndex% {
        newIndexToContinueFrom := currentIndex + A_Index + 1
        distance := distance(path[currentIndex], path[newIndexToContinueFrom])

        if (distance > 40) {
            break
        }
    }

    t := newIndexToContinueFrom * .01

    SoundBeep, 2000, 50
}
