checkpointLabels := []
pathLabels := []

overlayText(text) {
    ToolTip, % text, 500, 500
    SetTimer, removeToolTip, -2000
}

removeToolTip() {
    ToolTip
}

setupOverlaySystem() {
    global guiCurve

    CoordMode, Mouse, Screen
    backgroundColor = 000000

    ; +E0x20 prevents pointer events
    Gui, guiCurve:New, +Owner +AlwaysOnTop -Resize -SysMenu -MinimizeBox -MaximizeBox -Disabled -Caption -Border -ToolWindow +E0x20
    Gui, guiCurve:Color, % backgroundColor

    Gui, guiCurve:-Caption +ToolWindow +AlwaysOnTop +LastFound ;for transparency to work
    Gui, guiCurve:Show, x0 y0
    Gui, guiCurve:Maximize

    WinSet, TransColor, %backgroundColor% 128
}

declareGlobal(angelic) {
   global           ; Makes the entire function global
   (%angelic%)      ; Dereference. Parethesis make this a valid statement.
   return           ; A reference i.e. %angelic% cannot be returned.
}

drawCheckpointLabels(points) {
    global guiCurve, checkpointLabels

    Loop, % checkpointLabels.MaxIndex() {
        declareGlobal(checkpointLabels[A_Index])
    }

    Gui, guiCurve:Font, cDDFFDD s16 w700, Arial

    labelsCount := checkpointLabels.MaxIndex()
    Loop, % points.MaxIndex() {
        location := points[A_Index]

        if (A_Index > labelsCount) {
            newLabel := "checkpointLabel" + A_Index
            checkpointLabels.Push(newLabel)
            labelsCount++
            declareGlobal(newLabel)
            Gui, guiCurve:Add, Text, % "v" newLabel " x" location.x - 6 " y" location.y - 12, % A_Index
        } else {
            GuiControl, guiCurve:Move, % checkpointLabels[A_Index], % " x" location.x - 6 " y" location.y - 12
        }
    }

    ; Empty arrays have null MaxIndex(). Refine that to 0
    pointsCount := points.MaxIndex() ? points.MaxIndex() : 0
    Loop, % checkpointLabels.MaxIndex() - pointsCount {
        ; Hide label off screen
        GuiControl, guiCurve:MoveDraw, % checkpointLabels[pointsCount + A_Index], x-100 y-100
    }

    lineShow()
}

drawPath(points) {
    global guiCurve, pathLabels

    if (!points.MaxIndex()) {
        Loop, % pathLabels.MaxIndex() {
            ; Hide label off screen
            GuiControl, guiCurve:MoveDraw, % pathLabels[A_Index], x-100 y-100
        }
    }

    Gui, guiCurve:Font, cDDFFDD s16 w700, Arial

    labelsCount := pathLabels.MaxIndex()
    Loop, % points.MaxIndex() {
        location := points[A_Index]

        if (A_Index > labelsCount) {
            newLabel := "pathLabel" + A_Index
            pathLabels.Push(newLabel)
            labelsCount++
            declareGlobal(newLabel)
            Gui, guiCurve:Add, Text, % "v" newLabel " x" location.x - 6 " y" location.y - 12, ●
        } else {
            GuiControl, guiCurve:MoveDraw, % pathLabels[A_Index], % " x" location.x - 6 " y" location.y - 12
        }
    }

    lineShow()
}

lineShow() {
    global guiCurve

    Gui, guiCurve:Show
}

lineHide() {
    global guiCurve

    Gui, guiCurve:Hide
}

displayPath() {
    lineShow()
    SetTimer, lineHide, -1500
}
