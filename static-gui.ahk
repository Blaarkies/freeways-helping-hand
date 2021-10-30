overlayText(text)
{
    ToolTip, % text, 500, 500
    SetTimer, RemoveToolTip, -2000
}

RemoveToolTip()
{
    ToolTip
}
