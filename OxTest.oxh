#include <oxstd.oxh>
#include <oxstd.h>

#ifndef OXTEST_INCLUDED
#define OXTEST_INCLUDED

static decl i_NBMAXTEST_TS = 100; /**< int, maximum number of tests supported */

/**
*  Class for internal use. Haandle result of tests.
*/
class TestResult  
{
public:
	TestResult(const raiseError);
	AddAssertFailure(message ="");
	GetNbFailures();
	PrintFailMessages();
	AddAssertTreated();
protected:
	decl ifailureCount ;
	decl icurrentAssert  ;
	decl bRaiseError ;
	decl errorsmessages ;
}

/** 
*  A lightweight unit testing framework for Ox that can be easely extended.
*/
class TestSuite
{
	enum {E_NULL, E_FAIL, E_SUCCES};
    decl i_nb_test;  /**< int, number of tests */
    decl s_name ;    /**< string, name of the testsuite */
	decl p_Tests ;	 /**< array of functions to tests */
	decl v_status;  /**< T X 1 vector of results, 1 = Failure, 0 = Success , 3 =  not run */
	decl v_times;  	 /**< T X 1 vector of elapsed times in minutes */
	decl p_TestResult; 	 /**< T X 1 vector of TestResult objects */
	decl b_PrintIntermediarySummary;

	/**
	* Print results of tests 
	* @param    title (string)
	*/
    PrintSummary(const title);
	
	/**
	*  Add a test to the suite.
	* @param  Test (function), the function to test.
	*/
	AddTest(const func);


	PrintIntermediarySummary(const bprint);

	/**
	* Run all UT tests. 
	* @param    bRaiseError True to raise a runtime error if a test fails.
	*
	* @return (int), the number of fails tests.
	*/
	RunAllTests(const bRaiseError);
	
	/**
	* Constructor
	* @param    sname (string), name of the suite.
	*/
	TestSuite(const sname);

	/**
	* @return  (double) the version  
	*/	
	Version();
}

/* 
  Assert functions are volountary independents of TestSuite to ease extensions.
*/
static almostEqual(const val1,const val2, const precision)
{
	   if(ismissing(val1) || ismissing(val2))	return FALSE;
		decl diff = fabs(val1-val2);
		if(diff>precision)
			return FALSE;
		return TRUE;
}
/**
* Assert that condition is true.
* @param    statement (boolean), condition to test.
* @param    oTestResult (TestResult), per reference.  Argument that must be transmitted (untouched) form the argument of the parent's function.
* @param    message (string) Information about the current condition. 
*
*/
static TS_ASSERT(const statement,   oTestResult , message="")
{
	if (!statement)
	{
		oTestResult[0].AddAssertFailure(message);
	}
	oTestResult[0].AddAssertTreated();
}
/**
* Verifies that the actual value is within +/- tolerance of the expected value. 
* @param    val1 (double), expected value.
* @param    val2 (double), actual value.
* @param    tolerance double, the precision.
* @param    oTestResult  (TestResult, by reference) this value is set to FALSE if condition fails.
* @param    bRaiseError boolean, if TRUE this function raises an error if the condition is not met.
						it must be transmitted (untouched) form the argument of the parent's function.
*
* To assert that val1 and val2 are not equal, @see  TS_ASSERT_NOT_EQUAL
*/
static TS_ASSERT_EQUAL(const expected, const actual, const tolerance,   oTestResult , message="")
{
		   TS_ASSERT(almostEqual(expected,actual ,tolerance),oTestResult,message) ;
}
/* @see TS_ASSERT_EQUAL*/
static TS_ASSERT_NOT_EQUAL(const expected, const actual, const tolerance,   oTestResult , message="")
{
			TS_ASSERT(!almostEqual(expected,actual ,tolerance),oTestResult,message) ;
}

#endif
