class List {

    value := []

    __New(items) {
        this.value := items
    }

    Filter(callback) {
        filtered := []
        for key, item in this.value {
            if (callback.Call(item, A_Index, this.value)) {
                filtered.Push(item)
            }
        }
        return new List(filtered)
    }

    Map(callback) {
        mapped := []
        for key, item in this.value {
            mapped.Push(callback.Call(item, A_Index, this.value))
        }
        return new List(mapped)
    }

    ForEach(callback) {
        for key, item in this.value {
            callback.Call(item, A_Index, this.value)
        }
        return this
    }

}
