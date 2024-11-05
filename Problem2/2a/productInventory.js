class Product {
    constructor(name, price, quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }
}

const inventory = [
    new Product("Laptop", 999.99, 5),
    new Product("Smartphone", 499.99, 10),
    new Product("Tablet", 299.99, 0),
    new Product("Smartwatch", 199.99, 3)
];

// Calculate total inventory value
function calculateTotalInventoryValue(inventory) {
    return inventory.reduce((total, product) => total + (product.price * product.quantity), 0).toFixed(2);
}

// Find the most expensive product
function findMostExpensiveProduct(inventory) {
    return inventory.reduce((expensive, product) => product.price > expensive.price ? product : expensive).name;
}

// Check if headphones are in stock
function isProductInStock(inventory, productName) {
    return inventory.some(product => product.name === productName && product.quantity > 0);
}

// Sort products by ascending or descending
function sortProducts(inventory, property, order = 'asc') {
    return inventory.slice().sort((a, b) => {
        if (order === 'asc') return a[property] - b[property];
        else return b[property] - a[property];
    });
}

// Outputs
console.log("Total Inventory Value:", calculateTotalInventoryValue(inventory));
console.log("Most Expensive Product:", findMostExpensiveProduct(inventory));
console.log("Is 'Headphones' in Stock:", isProductInStock(inventory, "Headphones"));
console.log("Products Sorted by Price (Ascending):", sortProducts(inventory, "price", "asc"));
console.log("Products Sorted by Quantity (Descending):", sortProducts(inventory, "quantity", "desc"));
