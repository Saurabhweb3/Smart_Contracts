// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.5.0 < 0.9.0;

contract FoodDelivery{

    struct Order {
        address user;
        string foodItems;
        string deliveryLocation;
        uint256 deliveryTime;
        uint256 payment;
        bool isCompleted;
    }

    mapping (uint256 => Order) public orders;
    uint256 public orderCount;
    
    event NewOrder(address user, string foodItems, string deliveryLocation, uint256 deliveryTime, uint256 payment);
    event DeliveryConfirmed(uint256 orderId);
    
    function placeOrder(string memory _foodItems, string memory _deliveryLocation, uint256 _deliveryTime) public payable {
        require(msg.value > 0, "Payment is required to place an order.");
        orderCount++;
        orders[orderCount] = Order(msg.sender, _foodItems, _deliveryLocation, _deliveryTime, msg.value, false);
        emit NewOrder(msg.sender, _foodItems, _deliveryLocation, _deliveryTime, msg.value);
    }
    
    function confirmDelivery(uint256 _orderId) public {
        require(orders[_orderId].user == msg.sender, "You are not authorized to confirm the delivery.");
        require(orders[_orderId].isCompleted == false, "The delivery has already been confirmed.");
        orders[_orderId].isCompleted = true;
        payable(orders[_orderId].user).transfer(orders[_orderId].payment);
        emit DeliveryConfirmed(_orderId);
    }
    
    function getOrderDetails(uint256 _orderId) public view returns (address, string memory, string memory, uint256, uint256, bool) {
        return (orders[_orderId].user, orders[_orderId].foodItems, orders[_orderId].deliveryLocation, orders[_orderId].deliveryTime, orders[_orderId].payment, orders[_orderId].isCompleted);
    }
}

//This code defines a FoodDelivery smart contract that allows users to place orders for food delivery, 
//and delivery drivers to confirm the delivery of an order.

//The Order struct contains the details of each order, including the user's address, the food items, 
//delivery location, delivery time, payment amount, and completion status.

//The mapping orders maps order IDs to Order structs. 
//The orderCount variable is used to keep track of the number of orders placed.

//The placeOrder function allows users to place an order by sending a payment along with the order details.
//The function creates a new Order struct with the provided details, adds it to the orders mapping, 
//increments orderCount, and emits a NewOrder event.

//The confirmDelivery function allows delivery drivers to confirm the delivery of an order. 
//The function requires that the sender is the user who placed the order, 
//and that the order has not already been completed. 
//If the conditions are met, the function sets the isCompleted flag of the corresponding Order struct to true, 
//transfers the payment to the user who placed the order, and emits a DeliveryConfirmed event.

//The getOrderDetails function allows anyone to retrieve the details of an order by providing the order ID.