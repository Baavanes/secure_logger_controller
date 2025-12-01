
import os
import shutil
import argparse

parser = argparse.ArgumentParser(description="Run cocotb tests")
parser.add_argument("-extend", help="extend the command")
args = parser.parse_args()

os.environ["CARAVEL_ROOT"] = "/home/carlos/caravel_secure/caravel"
os.environ["MCW_ROOT"] = "/home/carlos/caravel_secure/mgmt_core_wrapper"

os.chdir("/home/carlos/caravel_secure/caravel_user_neuromorphic_secure")

command = "python3 /usr/local/bin/caravel_cocotb -test secure_test2_asserts -tag run_26_Nov_17_45_48_74/RTL-secure_test2_asserts/rerun   -sim RTL -corner nom-t "
if args.extend is not None:
    command += f" {args.extend}"
os.system(command)

shutil.copyfile("/home/carlos/caravel_secure/caravel_user_neuromorphic_secure/sim/run_26_Nov_17_45_48_74/RTL-secure_test2_asserts/rerun.py", "/home/carlos/caravel_secure/caravel_user_neuromorphic_secure/sim/run_26_Nov_17_45_48_74/RTL-secure_test2_asserts/rerun/RTL-secure_test2_asserts/rerun.py")
