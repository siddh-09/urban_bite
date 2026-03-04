# Urban Bite - Online Food Ordering System

![Urban Bite Banner](https://via.placeholder.com/1200x400.png?text=Urban+Bite+-+Online+Food+Ordering+System)  
<!-- Replace the placeholder image URL with your own banner/screenshot later -->

**A modern, secure, and efficient web-based platform for restaurant food ordering, customer management, and admin operations.**

Urban Bite solves real-world problems faced by restaurants and customers in manual or semi-digital ordering systems by providing a centralized, user-friendly online solution with secure authentication, real-time order tracking, menu management, and analytical reporting.

## 📖 Project Overview

### 1. Problem Identification & Definition
Many restaurants and cafes still depend on manual ordering, phone calls, or fragmented apps with limited functionality. This leads to:

**Customer pain points:**
- Difficulty placing smooth online orders
- No real-time order tracking
- Insecure or missing account management & order history

**Restaurant/Admin pain points:**
- Manual record-keeping is time-consuming and error-prone
- Slow menu updates
- No real-time sales monitoring or user activity insights

Urban Bite provides a **centralized web platform** with secure login, seamless ordering, instant menu updates, and powerful admin tools.

### 2. Key Features

#### Customer Features
- Secure user registration & login
- Browse menu with categories and search
- Add items to cart and place orders
- Multiple payment options (integrated gateway support)
- Real-time order tracking & status updates
- View order history and update profile
- Submit feedback and ratings

#### Admin Features
- Dashboard overview
- Add / Update / Delete menu items (with price, description, availability)
- Manage users and orders (confirm, cancel, update status)
- Real-time order monitoring
- Generate sales reports (daily, top-selling items, total revenue)
- View customer feedback

#### System Features
- Responsive design (mobile + desktop friendly)
- Centralized MySQL database
- Secure password encryption
- Role-based access (Customer vs Admin)

### 3. Tech Stack

| Layer            | Technology/Tools                          |
|------------------|-------------------------------------------|
| Frontend         | HTML5, CSS3, JavaScript, Bootstrap        |
| Backend          | PHP / Python (Flask/Django – choose one)  |
| Database         | MySQL                                     |
| Authentication   | Session-based / JWT (planned)             |
| Payment          | Razorpay / PayPal integration (optional)  |
| Tools & Others   | Git, GitHub, XAMPP / WAMP / Docker (dev)  |

### 4. System Architecture

- **Frontend** → Customer interface + Admin dashboard
- **Backend** → Handles business logic, API endpoints, authentication
- **Database** → Stores users, menu, orders, order details, login logs
- **External Services** → Payment gateway, (future: push notifications, delivery tracking)

### 5. Database Schema (Normalized – 3NF)

| Table          | Key Fields                                      | Description                          |
|----------------|-------------------------------------------------|--------------------------------------|
| `users`        | UserID (PK), Name, Email, Password, Contact, Address | Customer information                |
| `admins`       | AdminID (PK), Name, Email, Password             | Administrator accounts              |
| `menu`         | MenuID (PK), ItemName, Description, Price, AvailabilityStatus, AdminID (FK) | Food items                          |
| `orders`       | OrderID (PK), UserID (FK), OrderDate, TotalAmount, PaymentStatus, DeliveryAddress | Main order record                   |
| `order_details`| OrderDetailID (PK), OrderID (FK), MenuID (FK), Quantity, SubTotal | Items within each order (many-to-many) |
| `login_logs`   | LoginID (PK), UserID (FK), Username, Password (hashed), LoginTimestamp, Status | Login activity tracking             |

**Relationships:**
- User → Orders (1:N)
- Order → OrderDetails (1:N)
- Menu → OrderDetails (1:N)
- Admin → Menu (1:N)
- User → Login Logs (1:N)

### 6. Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/siddh-09/urban_bite.git
   cd urban_bite


### 2. Database Setup
- Create a MySQL database:
  ```sql
  CREATE DATABASE urban_bite_db;

## Import the schema:
If you have database/urban_bite.sql → import it via phpMyAdmin / MySQL Workbench / command line:Bashmysql -u root -p urban_bite_db < database/urban_bite.sql
Or manually create tables using this normalized schema:SQL-- users
```
CREATE TABLE users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,  -- hashed
    ContactNumber VARCHAR(15),
    Address TEXT
);

-- admins
CREATE TABLE admins (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL   -- hashed
);

-- menu
CREATE TABLE menu (
    MenuID INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    AvailabilityStatus ENUM('Available', 'Unavailable') DEFAULT 'Available',
    AdminID INT,
    FOREIGN KEY (AdminID) REFERENCES admins(AdminID)
);

-- orders
CREATE TABLE orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus ENUM('Pending', 'Paid', 'Failed') DEFAULT 'Pending',
    DeliveryAddress TEXT,
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

-- order_details (junction table)
CREATE TABLE order_details (
    OrderDetailID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    MenuID INT,
    Quantity INT NOT NULL,
    SubTotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (MenuID) REFERENCES menu(MenuID)
);

-- login_logs (optional for audit)
CREATE TABLE login_logs (
    LoginID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Username VARCHAR(100),
    LoginTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Success', 'Failed') NOT NULL,
    FOREIGN KEY (UserID) REFERENCES users(UserID)
);

```
## 3. Configure Backend

```
Clone the repo:Bashgit clone https://github.com/siddh-09/urban_bite.git

cd urban_bite

Create and activate virtual environment:Bashpython -m venv venv

source venv/bin/activate    # Linux/Mac

venv\Scripts\activate       # Windows

Install dependencies:Bashpip install -r requirements.txt

Update database connection in app.py or config.py / .env:Python# Example (adjust as per your file)

DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'your_password',
    'database': 'urban_bite_db'
}

```

## 4. Run the Project
```
Bashpython app.py
→ Open browser: http://127.0.0.1:5000 (or port shown in terminal)
5. Default Credentials (Change in production!)
```

### Admin: Email admin@urbanbite.com | Password admin123
Test User: Register through the signup page


### 🚀 Future Enhancements (Planned)

Mobile-responsive improvements / Progressive Web App (PWA) support
Real-time order updates (WebSockets / Socket.IO)
Coupon and discount system
Delivery partner module with route tracking
Email / SMS order notifications
Advanced rating & review moderation

## 📄 License
This project is open for educational and personal use.
See the LICENSE file for details.
(Recommendation: Use MIT license for open-source friendliness — add one if missing.)

## 💬 Contact & Contribution
Developed by Siddhant
GitHub: @siddh-09
Feel free to:


## Last updated: March 2026
## textThis version:
- Reflects the actual Flask + Python structure of your repo
- Includes complete setup steps with SQL code for easy reproduction
- Keeps academic/documentation focus
- Is clean, professional, and GitHub-friendly

MIT LICENSE




