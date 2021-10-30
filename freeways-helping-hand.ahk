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

return

^q:: ExitApp, 200

w:: moveForward()

f:: moveFullPath()

e:: setCheckpoint()

r:: resetCheckpoints()

s:: adjustedLevel()

setCheckpoint()
{
    global checkpoints, t

    if (checkpoints.MaxIndex() >= 4) {
        overlayText("Maximum checkpoints reached!")
        return
    }

    if (t != 0) {
        checkpoints := []
        overlayText("Cleared checkpoints")
    }

    MouseGetPos, x, y
    location := {x: x, y: y}

    addCheckpoint(location)

    SoundBeep, 1000, 50
}

addCheckpoint(checkpoint) {
    global checkpoints, path

    checkpoints.Push(checkpoint)
    overlayText("Checkpoint " + checkpoints.MaxIndex())

    if (checkpoints.MaxIndex() < 2) {
        return
    }

    path := []
    Loop, 100 {
        path.Push(getLerpLocation(checkpoints, A_Index * .01))
    }
}

moveForward()
{
    global checkpoints, t, path
    stepSize := 0.03

    if (checkpoints.MaxIndex() <= 1) {
        return
    }

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

moveFullPath()
{
    global checkpoints, t, path

    if (checkpoints.MaxIndex() <= 1) {
        return
    }

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
    Sleep, 200
}

resetCheckpoints()
{
    global checkpoints, t
    checkpoints := []
    t := 0
    path := []
    overlayText("Checkpoints reseted")
}

adjustedLevel()
{
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
