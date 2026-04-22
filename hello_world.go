package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println("Hello World")
	fmt.Println("Integers like ", 2, ", or floats like ", 2.5, " can be added to strings")
	fmt.Println(!true || false)
	fmt.Println(true && false)
	// Go infers the type of the variable
	var b, c = 1, "c"
	fmt.Println(b, c)
	var s string = "hello"
	fmt.Println(s + " world")
	var d int
	fmt.Println(d) // equals 0

	// short variable declaration
	e := 3 // := means initialize a variable e; This syntax is only available inside functions.
	fmt.Println(e)

	// constants
	const pi = 5000000
	const f = 3e20 / pi
	fmt.Println(f)        //6e+13
	fmt.Println(int64(f)) //60000000000000
	fmt.Println(math.Sin(pi))

	for j := 0; j < 3; j++ {
		fmt.Println(j)
	}

	for i := range 3 {
		fmt.Println("range", i)
	}
	for {
		if 3 < 2 {
			continue
		}
		fmt.Println("for without conditions repeat forever until break")
		break
	}

	// in Go, a name is exported if it begins with a capital letter.
	fmt.Println(math.Pi) // correct. but math.pi is wrong.
}
