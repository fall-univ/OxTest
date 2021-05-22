#include "OxTest.oxh"

TestSuite::Version() {
    return 1.0;
}
TestSuite::TestSuite(const sname) {
    s_name = sname;
    i_nb_test = 0 ;
    p_Tests = new array[i_NBMAXTEST_TS];
    p_TestResult = new array[i_NBMAXTEST_TS];
    v_status = constant(E_NULL, i_NBMAXTEST_TS, 1);
    v_times = zeros(i_NBMAXTEST_TS, 1);
    b_PrintIntermediarySummary = FALSE;
}
TestSuite::PrintIntermediarySummary(const eprint)
{
    b_PrintIntermediarySummary = eprint;
}
TestSuite::PrintSummary(const title)
{

    decl nbtestsfail,nbTestNotRun,nbtestsfails,nbTestSuccess ;
    nbtestsfails  = double(sumc(v_status[0:i_nb_test - 1].==E_FAIL));
    nbTestNotRun  = double(sumc(v_status[0:i_nb_test - 1].==E_NULL));
    nbTestSuccess = double(sumc(v_status[0:i_nb_test - 1].==E_SUCCES));
    println("---------  " + title + " ----------") ;
    println("Success: " + sprint("%i", nbTestSuccess) + " out of " + sprint(i_nb_test) + " tests passed.");
    println("Failure: " + sprint("%i", nbtestsfails) + " out of " + sprint(i_nb_test) + " tests failed.");
    println("Unknow: " + sprint(nbTestNotRun) + " out of " + sprint(i_nb_test) + " tests not run.");
    for (decl i = 0; i < i_nb_test; i++) {
        decl statut = v_status[i] == E_SUCCES ? "[1] SUCCESS " :  v_status[i] == E_FAIL ? "[0] FAILURE " :  "[X] NOT RUN " ;
        decl sNameTest =   sprint(p_Tests[i]) ;
        println(statut + "Time [" + sprint("%4.3f", v_times[i]) + "] - [" + sNameTest + "]");

        if (v_status[i] == E_FAIL) {
            p_TestResult[i].PrintFailMessages();
            //delete p_TestResult[i];
        }
    }
    if (nbTestNotRun > 0)
        println("Unknow: " + sprint(nbTestNotRun) + " out of " + sprint(i_nb_test) + " tests not run.");
      println("           ----------------            ");
}

TestSuite::RunAllTests(const bRaiseError) {
    println("------------------ Run All Test -------------------------");
    println("Suite name      : " + s_name) ;
    println("Number of tests : ", 	sprint(i_nb_test));

    for (decl t = 0; t < i_nb_test ; t++) {
        decl t0 = timer();
        decl sNameTest =   sprint(p_Tests[t]) ;
        decl testres = new TestResult(bRaiseError);
        println("Current Test [" + sprint(t + 1) + "/" + sprint(i_nb_test) + "] : "  +  sNameTest);
        p_Tests[t](testres);
        decl success =   testres.GetNbFailures() == 0 ;
        p_TestResult[t] = testres;
        v_status[t] = success ? E_SUCCES : E_FAIL;
        decl timeTest = (timer() - t0) / 6000;
        v_times[t] = timeTest;
        decl statut = success ? "SUCCESS " : "FAILURE " ;
        println("\t " + statut + "- Time [" + sprint("%4.3f", timeTest) + "] - [" + sNameTest + "]");

       if(b_PrintIntermediarySummary && t < (i_nb_test -1))
         PrintSummary("Intermediary Summary " + s_name);
    }
    println("---------------------------------------------------------");

    PrintSummary("Summary " + s_name);
    decl nbtestsfails  = double(sumc(v_status[0:i_nb_test - 1].==E_FAIL));
    println("Total Time (min): " + sprint("%4.3f", double(sumc(v_times[0:i_nb_test - 1]))));

     for (decl i = 0; i < i_nb_test; i++) 
            delete p_TestResult[i];
    println("---------------------------------------------------------");
    return nbtestsfails;
}
TestSuite::AddTest(const Test) {
    if (!isfunction(Test))
        oxrunerror("Invalid argument, it should be a function", 1);

    if (i_nb_test > i_NBMAXTEST_TS)
        oxrunerror("Maximum number of tests reached", 1);

    p_Tests[i_nb_test] = Test ;
    i_nb_test += 1 ;
}


/*
 TestResult members functions
*/

TestResult::AddAssertFailure(message) {
    if (message != "") println("\t Failure of :" + message);
    else  println("\t Assert Failure Number: " + sprint(icurrentAssert));
    ifailureCount ++;
    if (bRaiseError) {
        if (message != "")
            oxrunerror("\t Failure of :" + message, 0);

        oxrunerror("Test Failure", 0);
    }

    if (message != "")
        errorsmessages += "\t Assert Failure: " + message + "\n";
    else
        errorsmessages += "\t Assert Failure Number: " + sprint(icurrentAssert) + "\n";
}
TestResult::AddAssertTreated() {
    icurrentAssert++;
}
TestResult::PrintFailMessages() {
    println(errorsmessages);
}
TestResult::TestResult(const raiseError) {
    errorsmessages = "";
    icurrentAssert = 0;
    ifailureCount = 0;
    bRaiseError = raiseError;
}
TestResult::GetNbFailures() {
    return ifailureCount ;
}

