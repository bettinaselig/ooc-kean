import threading/Mutex

SynchronizedList: class <T> extends List<T> {
	_mutex := Mutex new()
	_backend : VectorList<T>
	count ::= this _backend count
	empty ::= this _backend empty
	pointer ::= this _backend pointer
	init: func ~default {
		this init(32)
	}
	init: func ~heap (capacity: Int, freeContent := true) {
		this init(VectorList<T> new(capacity, freeContent))
	}
	init: func (=_backend)
	free: override func {
		this _backend free()
		this _mutex free()
		super()
	}
	add: override func (item: T) {
		this _mutex lock()
		this _backend add(item)
		this _mutex unlock()
	}
	append: override func (other: This<T>) {
		this _mutex lock()
		this _backend append(other _backend)
		this _mutex unlock()
	}
	insert: override func (index: Int, item: T) {
		this _mutex lock()
		this _backend insert(index, item)
		this _mutex unlock()
	}
	remove: override func ~last -> T {
		this _mutex lock()
		result := this _backend remove()
		this _mutex unlock()
		result
	}
	remove: override func ~atIndex (index: Int) -> T {
		this _mutex lock()
		result := this _backend remove(index)
		this _mutex unlock()
		result
	}
	removeAt: override func (index: Int) {
		this _mutex lock()
		this _backend removeAt(index)
		this _mutex unlock()
	}
	clear: override func {
		this _mutex with(|| this _backend clear())
	}
	reverse: override func -> This<T> {
		this _mutex lock()
		result := This<T> new(this _backend reverse())
		this _mutex unlock()
		result
	}
	sort: override func (greaterThan: Func (T, T) -> Bool) {
		this _mutex lock()
		this _backend sort(greaterThan)
		this _mutex unlock()
	}
	copy: override func -> This<T> {
		this _mutex lock()
		result := This new(this _backend copy())
		this _mutex unlock()
		result
	}
	apply: override func (function: Func(T)) {
		this _mutex lock()
		this _backend apply(function)
		this _mutex unlock()
	}
	modify: override func (function: Func(T) -> T) {
		this _mutex lock()
		this _backend modify(function)
		this _mutex unlock()
	}
	map: override func <S> (function: Func(T) -> S) -> This<S> {
		this _mutex lock()
		result := This<S> new(this _backend map(function))
		this _mutex unlock()
		result
	}
	fold: override func <S> (S: Class, function: Func(T, S) -> S, initial: S) -> S {
		this _mutex lock()
		result := this _backend fold(S, function, initial)
		this _mutex unlock()
		result
	}
	getFirstElements: override func (number: Int) -> This<T> {
		this _mutex lock()
		result := This<T> new(this _backend getFirstElements(number))
		this _mutex unlock()
		result
	}
	getElements: override func (indices: This<Int>) -> This<T> {
		this _mutex lock()
		result := This<T> new(this _backend getElements(indices _backend))
		this _mutex unlock()
		result
	}
	getSlice: override func ~range (range: Range) -> This<T> {
		this _mutex lock()
		result := This<T> new(this _backend getSlice(range))
		this _mutex unlock()
		result
	}
	getSlice: override func ~indices (start, end: Int) -> This<T> {
		this _mutex lock()
		result := This<T> new(this _backend getSlice(start, end))
		this _mutex unlock()
		result
	}
	getSliceInto: override func ~range (range: Range, buffer: This<T>) {
		this _mutex lock()
		this _backend getSliceInto(range, buffer)
		this _mutex unlock()
	}
	getSliceInto: override func ~indices (start, end: Int, buffer: This<T>) {
		this _mutex lock()
		this _backend getSliceInto(start, end, buffer)
		this _mutex unlock()
	}
	iterator: override func -> Iterator<T> { this _backend iterator() }

	operator [] (index: Int) -> T {
		this _mutex lock()
		result := this _backend[index]
		this _mutex unlock()
		result
	}
	operator []= (index: Int, item: T) {
		this _mutex lock()
		this _backend[index] = item
		this _mutex unlock()
	}
}
