use ooc-base
use ooc-unit

TestClass: class {
	intVal := 0
	init: func { this intVal = 99 }
	increase: func { this intVal += 1 }
}

PromiseTest: class extends Fixture {
	counter := func {
		for (i in 0 .. 100_000_000) { }
	}
	quickcounter := func {
		for (i in 0 .. 10) { }
	}

	init: func {
		super("Promise")
		this add("noresult", func {
			promise := Promise start(this quickcounter)
			promise2 := Promise start(this counter)
			promise3 := Promise start(this counter)
			promise4 := Promise start(this counter)
			promise2 cancel()
			expect(promise wait())
			expect(promise2 wait(), is equal to(false))
			expect(promise3 wait(), is equal to(true))
			expect(promise4 wait())
			(counter as Closure) dispose()
			(quickcounter as Closure) dispose()
			promise free()
			promise2 free()
			promise3 free()
			promise4 free()
		})
		this add("Future", func {
			future := Future start(Text, func { for (i in 0 .. 100_000_000) { } t"job1" } )
			future2 := Future start(TestClass, func { for (i in 0 .. 100_000_000) { } TestClass new() } )
			future3 := Future start(Text, func { for (i in 0 .. 100_000_000) { } t"job3" } )
			future4 := Future start(Text, func { for (i in 0 .. 100_000_000) { } t"job4" } )
			future5 := Future start(Int, func { for (i in 0 .. 100_000) { } 42 } )
			future cancel()
			compare := t"cancelled"
			result2 := future2 wait~default(null)
			result := future wait(compare)
			result3 := future3 wait(compare)
			result4 := future4 wait(compare)
			result5 := future5 wait~default(10)
			future3 cancel()
			expect(result == t"cancelled")
			expect(result2 intVal == 99)
			expect(result3 == t"job3")
			expect(result4 == t"job4")
			expect(result5 == 42)
			result free()
			result2 free()
			result3 free()
			result4 free()
			compare free()
			future free()
			future2 free()
			future3 free()
			future4 free()
			future5 free()
		})
	}
}

PromiseTest new() run()
