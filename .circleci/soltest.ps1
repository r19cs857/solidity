$ErrorActionPreference = "Stop"

cd "$PSScriptRoot\.."

.\build\solc\Release\solc.exe --version
if ( -not $? ) { throw "Cannot execute solc --version." }

# How to report errors?
mkdir test_results
.\build\test\Release\soltest.exe --color_output=no --show_progress=yes --logger=JUNIT,error,test_results/result.xml -- --no-smt --batches 2 --selected-batch 0 &
#    if ( -not $? ) { throw "Unoptimized soltest run 0 failed." }
.\build\test\Release\soltest.exe --color_output=no --show_progress=yes --logger=JUNIT,error,test_results/result.xml -- --no-smt --batches 2 --selected-batch 1 &
#    if ( -not $? ) { throw "Unoptimized soltest run 1 failed." }
.\build\test\Release\soltest.exe --color_output=no --show_progress=yes --logger=JUNIT,error,test_results/result_opt.xml -- --optimize --no-smt --batches 2 --selected-batch 0 &
#    if ( -not $? ) { throw "Optimized soltest run 0 failed." }
.\build\test\Release\soltest.exe --color_output=no --show_progress=yes --logger=JUNIT,error,test_results/result_opt.xml -- --optimize --no-smt --batches 2 --selected-batch 1 &
#    if ( -not $? ) { throw "Optimized soltest run 1 failed." }

Get-Job | Wait-Job
if ( -not $? ) { throw "tes run failed." }
