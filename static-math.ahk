getLerpLocation(checkpoints, t) {
    if (checkpoints.MaxIndex() == 3) {
        lerpA := lerp(checkpoints[1], checkpoints[2], t)
        lerpB := lerp(checkpoints[2], checkpoints[3], t)

        location := lerp(lerpA, lerpB, t)
    } else if (checkpoints.MaxIndex() == 4) {
        lerpA := lerp(checkpoints[1], checkpoints[2], t)
        lerpB := lerp(checkpoints[2], checkpoints[3], t)
        lerpC := lerp(checkpoints[3], checkpoints[4], t)

        lerpD := lerp(lerpA, lerpB, t)
        lerpE := lerp(lerpB, lerpC, t)

        location := lerp(lerpD, lerpE, t)
    } else {
        location := lerp(checkpoints[1], checkpoints[2], t)
    }

    return location
}

lerp(a, b, t) {
    tx := a.x * (1 - t) + b.x * t
    ty := a.y * (1 - t) + b.y * t
    return {x: tx, y: ty}
}

distance(a, b) {
    return Sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
}
