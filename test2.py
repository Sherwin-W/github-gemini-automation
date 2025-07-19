from typing import List

def pair_sum_sorted(nums: List[int], target: int) -> List[int]:
    n = len(nums)
    left, right = 0, n-1
    while left < right:
        if nums[left] + nums[right] < target:
            left += 1
        elif nums[left] + nums[right] > target:
            right -= 1
        else:
            return [left,right]
    return []

if __name__ == "__main__":
    nums = [1, 2, 4, 6, 10]
    target = 8
    result = pair_sum_sorted(nums, target)
    print("Input:", nums)
    print("Target:", target)
    print("Output:", result)
