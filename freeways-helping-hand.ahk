﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#singleinstance force
Process, Priority,, High
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include includes/static-math.ahk
#Include includes/static-gui.ahk
#Include includes/static-list.ahk

startup() {
    global
    checkpoints := []
    t := 0
    path := []

    setupOverlaySystem()
}
startup()
return

^q:: ExitApp, 200
w:: checkBusyThenCallback("moveForward")
f:: checkBusyThenCallback("moveFullPath")
e:: checkBusyThenCallback("setCheckpoint")
r:: resetCheckpoints()
s:: adjustedLevel()
d:: displayPath()

1:: editCheckpoint(1)
2:: editCheckpoint(2)
3:: editCheckpoint(3)
4:: editCheckpoint(4)
5:: editCheckpoint(5)
6:: editCheckpoint(6)
7:: editCheckpoint(7)
8:: editCheckpoint(8)
9:: editCheckpoint(9)
0:: editCheckpoint(10)

editCheckpoint(id) {
    global checkpoints

    if (id <= checkpoints.MaxIndex()) {
        checkBusyThenCallback("updateCheckpoint", id)
    } else {
        overlayText("Checkpoint " id " does not exist")
        SoundBeep, 200, 150
    }
}

updateCheckpoint(id) {
    global checkpoints

    MouseGetPos, x, y
    location := {x: x, y: y}

    addCheckpoint(location, id)
    overlayText("Update checkpoint " + id)

    SoundBeep, 1500, 50
}

setCheckpoint() {
    global checkpoints, t

    if (checkpoints.MaxIndex() >= 10) {
        overlayText("Maximum checkpoints reached!")
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
}

addCheckpoint(checkpoint, id) {
    global checkpoints, path, t

    if (t != 0) {
        resetCheckpoints()
        lineHide()
    }

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
        location := getBezierLerpLocation(checkpoints, A_Index * .01)
        path.Push(location)
        if (mod(A_Index, 5) == 0 && A_Index != 0 && A_Index != 100) {
            lowResPath.Push(location)
        }
    }

    drawPath(lowResPath)
}

moveForward() {
    global checkpoints, t, path

    if (checkpoints.MaxIndex() <= 1) {
        return
    }

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
            lineHide()
            break
        }
    }

    MouseClick, , , , , , U
    Sleep, 200
}

getCurrentIndex() {
    global t
    return Round(t * 100) + 1
}

checkBusyThenCallback(callbackName, params*) {
    global busy

    if (busy == 1) {
        return
    }
    busy := 1

    callback := Func(callbackName)
    callback.Call(params*)

    busy := 0
}

moveFullPath() {
    global checkpoints, t, path

    if (checkpoints.MaxIndex() <= 1) {
        return
    }

    location := path[getCurrentIndex()]
    MouseMove, location.x, location.y
    Sleep, 150

    MouseClick, , , , , , D
    resolution := distance(path[1], path[2]) < 15 ? .25 : 1
    Loop, % resolution * 100
    {
        location := path[Round(A_Index / resolution)]

        MouseMove, location.x, location.y
        Sleep, 1
    }

    Sleep, 150
    MouseClick, , , , , , U

    resetCheckpoints()
    lineHide()
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

    for key, value in path {
        newIndexToContinueFrom := currentIndex + A_Index + 1
        distance := distance(path[currentIndex], path[newIndexToContinueFrom])

        if (distance > 40) {
            break
        }
    }

    t := newIndexToContinueFrom * .01

    SoundBeep, 2000, 150
}
