#import "../OxTest"

//region fake class to test
class Adder
{
    Add(const val1, const val2);
}

Adder::Add(const val1, const val2)
{
    return val1 + val2 ;
}
//endregion 


//region actual unit tests functions
test_add(oRes) // Fail
{
    decl a = new Adder();
    decl out = a.Add(1,1);
    TS_ASSERT(out == 2,&oRes); // TRUE  - Number 0
    TS_ASSERT(3 ==out ,&oRes); // FALSE - Number 1
}
other_func(oRes)// Fail
{
    decl a = new Adder();
    decl out = a.Add(1,1);
    TS_ASSERT(out == 2,&oRes); //OK  - Number 0
    TS_ASSERT(out == 3,&oRes, "specific message here"); //FALSE - Number 1
    TS_ASSERT(out == 3,&oRes); // idem with default error message (display the assert number that fails (zero based so 2 for this one))
}
test_add3(oRes)// Success
{
    decl a = new Adder();
    decl out = a.Add(1,1);
    decl precision = 1;
    TS_ASSERT_EQUAL(out, 3,precision, &oRes); //TRUE$
    if(oRes.GetNbFailures()==0)
    {
        // conditional logic..
    }
}
test(oRes)
{
    decl a = 1;
    decl b = 2;  
    TS_ASSERT_EQUAL(a,b, 0,&oRes); //FALSE because tolerance =0 
    TS_ASSERT_EQUAL(a,b, 1,&oRes); //TRUE because tolerance = 1
    TS_ASSERT_EQUAL(a,b, 0,&oRes, "my custom message"); //FALSE because tolerance =0 
}
//endregion
main()
{
    decl nbfail;

    decl ts = new TestSuite("Demo Test Adder");
    ts.AddTest(test_add);
    ts.AddTest(other_func); 
    ts.AddTest(test_add3); 
    nbfail = ts.RunAllTests(FALSE); 
    delete ts;

    decl ts2 = new TestSuite("Another suite");
    ts2.AddTest(test); 
    nbfail = ts2.RunAllTests(FALSE); // FALSE so does not raise an runtime error. 
    delete ts2;
}
 