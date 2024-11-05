function findMissingNumberSet(arr) {
    const n = arr.length + 1;
    const numSet = new Set(arr);

    for (let i = 1; i <= n; i++) {
        if (!numSet.has(i)) {
            return i;
        }
    }
}

const arr = [3, 7, 1, 2, 6, 4];
console.log("Missing Number (Set):", findMissingNumberSet(arr)); // 5 is expected
