#import "OxTest"
/**
*  OxTest tests itself here. 
*/

test_fail(oTest)  
{
    TS_ASSERT(FALSE ,&oTest); 
}
 
test_fail2(oTest)  
{
    TS_ASSERT_EQUAL(1,0, 0,&oTest);
}
test_success(oTest) 
{
    TS_ASSERT(TRUE ,&oTest); 
    TS_ASSERT_EQUAL(0,0, 0,&oTest);
    TS_ASSERT_EQUAL(0,0.5, 1,&oTest);
}
 
 
main()
{
    decl nbfail;

    decl ts = new TestSuite("A");
    ts.AddTest(test_fail);
    ts.AddTest(test_fail2);
    nbfail = ts.RunAllTests(FALSE); 
    if(nbfail !=2)oxrunerror("problem");
    delete ts;

    decl ts2 = new TestSuite("B");
    ts2.AddTest(test_success); 
    nbfail = ts2.RunAllTests(FALSE);
    if(nbfail !=0)oxrunerror("problem");

    ts2 = new TestSuite("B");
    ts2.AddTest(test_success); 
    ts2.AddTest(test_fail);
    ts2.AddTest(test_success);
    ts2.PrintIntermediarySummary(TRUE);
    nbfail = ts2.RunAllTests(FALSE);
    if(nbfail !=1)oxrunerror("problem");
    delete ts2;
}