import multiprocessing as mp
import time
import matplotlib.pyplot as plt

# --- Define the function at top level ---
def square_function(x):
    time.sleep(0.5)
    return x**2

def benchmark_with_cores(numbers, cores):
    """Benchmark using a specific number of cores."""
    start = time.time()
    with mp.Pool(processes=cores) as pool:
        _ = pool.map(square_function, numbers)
    end = time.time()
    return end - start

if __name__ == "__main__":
    numbers = list(range(1, 11))
    num_cores = mp.cpu_count()

    # Sequential benchmark
    start_seq = time.time()
    seq_result = [square_function(x) for x in numbers]
    end_seq = time.time()
    seq_time = end_seq - start_seq

    # Parallel benchmarks
    cores_to_test = list(range(1, num_cores + 1))
    times = [benchmark_with_cores(numbers, c) for c in cores_to_test]
    speedups = [seq_time / t for t in times]

    # Print results
    print(f"Sequential time: {seq_time:.2f}s")
    for c, t, s in zip(cores_to_test, times, speedups):
        print(f"{c} cores -> {t:.2f}s ({s:.2f}x speedup)")

    # Plot execution time
    plt.figure(figsize=(6, 4))
    plt.plot(cores_to_test, times, marker='o', label="Execution Time")
    plt.title("Execution Time vs Number of Cores")
    plt.xlabel("Number of Cores")
    plt.ylabel("Execution Time (seconds)")
    plt.grid()
    plt.savefig("execution_time_vs_cores.png")
    plt.show()

    # Plot speedup curve
    plt.figure(figsize=(6, 4))
    plt.plot(cores_to_test, speedups, marker='o', color='green', label="Speedup")
    plt.plot(cores_to_test, cores_to_test, '--', color='red', label="Ideal Speedup")
    plt.title("Speedup vs Number of Cores")
    plt.xlabel("Number of Cores")
    plt.ylabel("Speedup (Relative to Sequential)")
    plt.legend()
    plt.grid()
    plt.savefig("speedup_vs_cores.png")
    plt.show()
