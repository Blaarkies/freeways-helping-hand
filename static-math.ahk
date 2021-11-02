getBezierLerpLocation(points, t) {
    return iterativeLerping(points, t)
}

iterativeLerping(points, t) {
    edges := arrayWindowed(points)
    Loop, 999 { ; infinite loop 'break' not working. numbered loop fixes it
        newPoints := []
        for key, edge in edges {
            newPoints.Push(lerp(edge[1], edge[2], t))
        }

        newPointsCount := newPoints.MaxIndex()
        if (newPointsCount >= 2) {
            edges := arrayWindowed(newPoints)
        } else {
            edges := []
            result := newPoints[1]
            break
        }
    }

    return result
}

arrayWindowed(list) {
    result := []
    Loop, % list.MaxIndex() - 1 {
        result.Push([list[A_Index], list[A_Index + 1]])
    }

    return result
}

lerp(a, b, t) {
    tx := a.x * (1 - t) + b.x * t
    ty := a.y * (1 - t) + b.y * t
    return {x: tx, y: ty}
}

distance(a, b) {
    return Sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
}
