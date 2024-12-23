import os
import subprocess
import time

src_dir = "src"


def run_program(file):
    time_array = []
    start_time = time.perf_counter()
    subprocess.run(["lfc", f"src/{file}"], capture_output=True)
    end_time = time.perf_counter()
    print(f"Time for generating Uclid Model: {end_time - start_time:.5f} secs")
    time_array.append(end_time - start_time)
    start_time = time.perf_counter()
    subprocess.run(
        ["uclid", "-g", f"mod-gen/{file[:-3]}/smt", f"mod-gen/{file[:-3]}/*.ucl"],
        capture_output=True,
    )
    end_time = time.perf_counter()
    print(f"Time for generating SMT from Uclid Model: {end_time - start_time:.5f} secs")
    time_array.append(end_time - start_time)
    start_time = time.perf_counter()
    subprocess.run(["z3", f"mod-gen/{file[:-3]}/*.smt"], capture_output=True)
    end_time = time.perf_counter()
    print(f"Time for solving SMT using Z3 {end_time - start_time:.5f} secs")
    time_array.append(end_time - start_time)
    print(f"Total time: {time_array[0]+time_array[1]+time_array[2]:.5f} secs")
    with open(f"src/{file}", "r") as f:
        lf_lines = len(f.read().splitlines())
    files = [f for f in os.listdir(f"mod-gen/{file[:-3]}") if f[-4:] == ".ucl"][0]
    with open(f"mod-gen/{file[:-3]}/{files}", "r") as f:
        ucl_lines = len(f.read().splitlines())
    print(f"\nLines in LF program: {lf_lines}")
    print(f"Lines in .ucl file: {ucl_lines}")
    return time_array


if __name__ == "__main__":
    files = [f for f in os.listdir(src_dir) if os.path.isfile(os.path.join(src_dir, f))]
    time_array = [0, 0, 0]
    cnt = 0
    for f in files:
        cnt += 1
        print(f"============== Benchmark for {f} =====================\n")
        t = run_program(f)
        time_array[0] += t[0]
        time_array[1] += t[1]
        time_array[2] += t[2]
        print("\n")
    print("============== Average Time Calculation =====================")
    print(f"Average time for generating Uclid Model: {time_array[0]/cnt:.5f} secs")
    print(
        f"Average time for generating SMT from Uclid Model: {time_array[1]/cnt:.5f} secs"
    )
    print(f"Average time for solving SMT using Z3: {time_array[2]/cnt} secs")
    print(
        f"Total Average time: {(time_array[0]+time_array[1]+time_array[2])/cnt:.5f} secs"
    )
