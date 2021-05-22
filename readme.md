# Test Suite #

TestSuite is a (very) lightweight [unit testing](https://en.wikipedia.org/wiki/Unit_testing) framework for Ox. This allows you to easily add unit tests to your own ox code. 

## Quick start ##

The TestSuite class has two main functions: 

- `AddTest(tested_function)` : that permits to add a test to a suite (a group of tests);

- `RunAllTest(TRUE)` : that permits to run all your tests and display results. This function takes a boolean value as an argument indicating if it should raise an error whenever a test fails. 

---
### Test ###

A test is a simple function that needs to respect the two following requirements :

1. The prototype of the test function has to take a single non-constant argument: 
    - Valid example     : `functionname(testResult)`
    - Valid example     : `test_1(res)`
    - Invalid prototype : `test_1(const a, ...)`
    - Invalid prototype : `functionname(const testResult)`

    The argument of the test function is a `TestResult` object transmitted by the framework and shouldn't be modified directly in code.

2. It must be **independent** of other functions.
 
 So the most basic test (successful) is given as: 

```ox
test(TestResult)
{

}
```

---
### Checks ###

Inside a Test, a custom logic is implemented by the user and failure is indicating via the (static) `TS_ASSERT` function.

Example of a successful test : 

```ox
test(testres)
{
    //custom logic
    TS_ASSERT(TRUE,&testres);
}
```

Example of a fail test: 

```ox
test(testres)
{
    //custom logic
    TS_ASSERT(FALSE,&testres);
}
```

The `TS_ASSERT` prototype is : 

- `TS_ASSERT(const cond,   TestResult ,   custommessage="")` 

Internally it evaluates the condition : `cond == TRUE` , if this condition is false then TestResult is modified to warn the framework. 

Two additional `ASSERT` functions are implemented to ease testing (you can easily create your own static).

- `TS_ASSERT_EQUAL(const expected, const actual, const tolerance,   TestResult , custommessage="")`

- `TS_ASSERT_NOT_EQUAL(const expected, const actual, const tolerance,   TestResult , custommessage="")`

 

Example :

```ox
test(TestResult)
{
    decl a = 1;
    decl b = 2;  
    TS_ASSERT_EQUAL(a,b, 0,&TestResult); //FALSE because tolerance =0 
    TS_ASSERT_EQUAL(a,b, 1,&TestResult); //TRUE because tolerance = 1
}
```

### Run your tests ###

In order to run your test, you need to create a TestSuite object, then add your tests thanks to the `AddTest` method and finally call `RunAllTests`.

```ox
test(TestResult)
{
    decl a = 1;
    decl b = 2;  
    TS_ASSERT_EQUAL(a,b, 0,&TestResult); //FALSE because tolerance =0 
    TS_ASSERT_EQUAL(a,b, 1,&TestResult); //TRUE because tolerance = 1
}
main()
{
    decl ts = new TestSuite("Demo Suite");
    ts.AddTest(test); 
    ts.RunAllTests(FALSE);
    delete ts;
}
```
produces the output :

        ------------------ Run All Test -------------------------
        Suite name      : Demo Suite
        Number of tests : 1
        Current Test [1/1] : test()
            Assert Failure Number: 0
            FAILURE - Time [0.000] - [test()]
        --------------------------------------------------------
                ----------------            
        ---------  Summary Demo Suite ----------
        Success: 0 out of 1 tests passed.
        Failure: 1 out of 1 tests failed.
        Unknow: 0 out of 1 tests not run.
        [0] FAILURE Time [0.000] - [test()]
            Assert Failure Number: 0
                ----------------            
        Total Time (min): 0.000
        --------------------------------------------------------

---

It is possible to raise a runtime error whenever an assert fails by using `RunAllTests(TRUE);` . Then the call trace and the error message can be used to find the corresponding assert.
The output displays in live the results for each individual test and summarize at the end the result for all tests. 


## Example ##

The file [TestSuiteDemo.ox](./samples/demo.ox) provides a detailed example.
 
------------------------------------