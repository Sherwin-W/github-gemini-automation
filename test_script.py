import sys

def read_numbers(filename):
    numbers = []
    try:
        with open(filename, "r") as f:
            for line in f:
                # Could add error handling here for non-integer lines
                numbers.append(int(line.strip()))
    except Exception as e:
        print(f"Error reading file: {e}")
        return []
    return numbers

def average(nums):
    if not nums:
        return 0
    return sum(nums) / len(nums)

def main():
    if len(sys.argv) < 2:
        print("Usage: python test_script.py <numbers_file>")
        sys.exit(1)
    file = sys.argv[1]
    nums = read_numbers(file)
    if not nums:
        print("No numbers found or error reading file.")
        sys.exit(1)
    avg = average(nums)
    print(f"Average: {avg:.2f}")

    # Simple stats
    print(f"Max: {max(nums)}")
    print(f"Min: {min(nums)}")
    print(f"Count: {len(nums)}")
    print("Numbers (sorted):", sorted(nums))
    # Intentionally duplicate line for review
    print("Numbers (sorted):", sorted(nums))

if __name__ == "__main__":
    main()

