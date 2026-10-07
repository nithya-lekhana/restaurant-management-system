# Restaurant Management System

A full-stack **Restaurant Table Reservation and Food Service Management System** developed using **Python Flask, MySQL, HTML, CSS, and JavaScript**.

The system provides a centralized platform for managing restaurant tables, customers, reservations, menu items, food orders, kitchen processing, billing, payments, discounts, and management reports.

---

## 1. Project Overview

The Restaurant Management System is a database-driven web application designed to simplify restaurant operations and maintain accurate, structured data.

The system manages the complete workflow:

Customer → Reservation → Table → Food Order → Kitchen Processing → Billing → Payment → Reports

The project focuses on applying **Database Management System concepts** such as:

- Relational database design
- Primary keys and foreign keys
- Normalization
- Constraints
- Triggers
- Views
- Indexing
- Transactions
- SQL joins
- Aggregate queries
- Nested queries
- Database security
- Flask REST APIs
- Frontend-backend integration

---

## 2. Objectives

The main objectives of the project are:

1. To design a structured relational database for restaurant operations.
2. To manage restaurant table reservations efficiently.
3. To prevent invalid and overlapping reservations.
4. To manage customers, menu items, waiters, orders, and kitchen tickets.
5. To automate billing, discounts, taxes, and payment processing.
6. To maintain data integrity using constraints and triggers.
7. To provide useful management reports.
8. To connect a web application with MySQL using Flask.
9. To demonstrate practical implementation of DBMS concepts.

---

## 3. Key Features

### Table Management

- View all restaurant tables.
- Display table capacity and status.
- Organize tables according to dining areas.
- Track available, occupied, reserved, and maintenance tables.

### Customer Management

- Add customer information.
- Store customer name, phone number, and email.
- Maintain unique customer contact information.

### Reservation Management

- Create table reservations.
- Specify reservation date and time.
- Validate guest count against table capacity.
- Prevent overlapping reservations.
- Manage reservation statuses:
  - CONFIRMED
  - SEATED
  - COMPLETED
  - CANCELLED
  - NO_SHOW

### Menu Management

- Display menu items.
- Organize items by category.
- Store item descriptions and prices.
- Track item availability.

### Order Management

- Create food orders for reservations.
- Assign orders to waiters.
- Add multiple menu items to an order.
- Store quantity and unit price.
- Add special instructions.
- Track order status:
  - PLACED
  - PREPARING
  - READY
  - SERVED
  - CANCELLED

### Kitchen Management

- Automatically maintain kitchen tickets for order items.
- Track kitchen processing status.
- Store received, started, and ready timestamps.
- Calculate kitchen preparation performance.

### Billing

- Generate bills for served orders.
- Calculate subtotal.
- Apply authorized discounts.
- Calculate tax.
- Maintain bill status.
- Prevent modification or deletion of closed bills.

### Payments

- Record payments using:
  - CASH
  - CARD
  - UPI
- Store transaction references.
- Validate payment amounts.
- Automatically close bills after successful payment.

### Reports

The system provides reports for:

- Revenue summary
- Waiter performance
- Best-selling menu items
- Table turnover
- Payment methods
- Discount usage
- Kitchen performance
- Revenue by date

---

## 4. Technology Stack

| Component               | Technology                |
| ----------------------- | ------------------------- |
| Frontend                | HTML5, CSS3, JavaScript   |
| Backend                 | Python Flask              |
| Database                | MySQL 8.x                 |
| Database Connector      | mysql-connector-python    |
| Environment Variables   | python-dotenv             |
| Web Server              | Gunicorn                  |
| Development Environment | VS Code / Antigravity IDE |
| Version Control         | Git                       |
| Repository Hosting      | GitHub                    |
| Deployment              | Railway                   |

---

## 5. System Architecture

```text
┌──────────────────────────────┐
│          Frontend            │
│      HTML / CSS / JS         │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Flask Backend          │
│          REST APIs           │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│    MySQL Connector/Python    │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       MySQL Database         │
│    restaurant_management     │
└──────────────────────────────┘
```

---

## 6. Project Structure

The project follows a clean separation between frontend, backend, and database resources.

```text
restaurent managment/
│
├── backend/
│   ├── app.py
│   ├── db.py
│   ├── requirements.txt
│   ├── .env
│   └── .env.example
│
├── frontend/
│   ├── templates/
│   │   ├── billing.html
│   │   ├── dashboard.html
│   │   ├── index.html
│   │   ├── menu.html
│   │   ├── navbar.html
│   │   ├── orders.html
│   │   ├── reports.html
│   │   ├── reservations.html
│   │   └── tables.html
│   │
│   └── static/
│       └── style.css
│
├── database/
│   └── restaurant_management.sql
│
├── .gitignore
├── Procfile
├── README.md
└── requirements.txt
```

> **Note:** The actual `.env` file is used only for local configuration and is excluded from GitHub. The repository contains `.env.example` as a template.

---

## 7. Database Design

The system uses a relational database named:

```text
restaurant_management
```

The database contains the following tables:

1. `dining_area`
2. `restaurant_table`
3. `customer`
4. `reservation`
5. `menu_item`
6. `waiter`
7. `food_order`
8. `order_item`
9. `kitchen_ticket`
10. `discount`
11. `bill`
12. `payment`

### Main Relationships

```text
Dining Area
     │
     └── Restaurant Table
              │
              └── Reservation
                    │
                    ├── Customer
                    │
                    └── Food Order
                           │
                           ├── Waiter
                           │
                           ├── Order Item
                           │      │
                           │      └── Menu Item
                           │
                           └── Kitchen Ticket


Food Order
    │
    └── Bill
         │
         ├── Discount
         │
         └── Payment
```

---

## 8. Database Constraints

The database uses several integrity constraints.

### Primary Keys

Every major entity has a unique primary key.

Examples:

```text
customer_id
table_id
reservation_id
order_id
item_id
bill_id
payment_id
```

### Foreign Keys

Foreign keys maintain relationships between tables.

Examples:

```text
reservation.customer_id → customer.customer_id
reservation.table_id → restaurant_table.table_id
food_order.reservation_id → reservation.reservation_id
food_order.waiter_id → waiter.waiter_id
order_item.order_id → food_order.order_id
order_item.item_id → menu_item.item_id
bill.order_id → food_order.order_id
payment.bill_id → bill.bill_id
```

### Other Constraints

The database also uses:

- `NOT NULL`
- `UNIQUE`
- `CHECK`
- `DEFAULT`
- Foreign key constraints

Examples include:

- Table capacity must be greater than zero.
- Menu price must be positive.
- Order quantity must be positive.
- Payment amount must be positive.
- Reservation start time must be before end time.
- Valid status values are enforced.

---

## 9. Database Triggers

The database contains triggers for important validation and integrity requirements.

### Reservation Validation

Triggers validate:

- Guest count against table capacity.
- Overlapping reservations.

### Billing Validation

Triggers help prevent:

- Invalid discounts.
- Modification of closed bills.
- Deletion of closed bills.

### Payment Validation

Payments are validated against the bill amount.

These triggers help maintain database-level integrity even when data is inserted outside the web application.

---

## 10. Database Views

The project uses database views for frequently required reports and combined information.

The main views include:

1. `available_tables_view`
2. `reservation_details_view`
3. `order_details_view`
4. `sales_report_view`
5. `waiter_performance_view`
6. `kitchen_performance_view`
7. `revenue_report_view`

These views simplify reporting queries and reduce repeated SQL logic.

---

## 11. Database Indexing

Indexes are created on frequently searched or filtered columns.

Important indexes include:

```text
idx_reservation_date
idx_reservation_table_date
idx_order_status
idx_order_time
idx_kitchen_status
idx_payment_bill
idx_menu_category
idx_table_status
```

Indexing improves query performance for reservation searches, order filtering, reporting, payment lookup, and table status queries.

---

## 12. Application Pages

The web application contains the following major pages:

### Dashboard

Displays an overview of restaurant activity.

### Tables

Displays restaurant tables, capacities, areas, and statuses.

### Reservations

Allows users to create and manage reservations.

### Orders

Allows food orders to be created and their statuses to be updated.

### Menu

Displays available menu items and their categories.

### Billing

Provides:

- Bill creation
- Discount selection
- Payment recording
- Bill status tracking
- Revenue summary

### Reports

Provides management reports including:

- Revenue
- Waiter performance
- Best-selling items
- Table turnover
- Payment methods
- Discount usage
- Kitchen performance
- Revenue by date

---

## 13. Billing Workflow

The billing process follows this sequence:

```text
Order Created
      ↓
Order Prepared
      ↓
Order Served
      ↓
Create Bill
      ↓
Calculate Subtotal
      ↓
Apply Discount
      ↓
Calculate Tax
      ↓
Generate Total
      ↓
Record Payment
      ↓
Bill Closed
      ↓
Reservation Completed
      ↓
Table Available
```

Bills can only be created for served orders.

Payments are validated before the bill is closed.

---

## 14. Local Installation

### Step 1: Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
```

Move into the project:

```bash
cd "restaurent managment"
```

---

### Step 2: Create a Virtual Environment

```bash
python -m venv venv
```

Activate it on Windows:

```powershell
venv\Scripts\activate
```

---

### Step 3: Install Dependencies

From the project root:

```powershell
pip install -r requirements.txt
```

---

## 15. Configure Environment Variables

Create:

```text
backend/.env
```

Add:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=restaurant_management
```

Do not commit `.env` to GitHub.

The repository contains:

```text
backend/.env.example
```

as a configuration template.

---

## 16. Database Setup

Open **MySQL Workbench** or another MySQL client.

Create the database:

```sql
CREATE DATABASE restaurant_management;
```

Then import:

```text
database/restaurant_management.sql
```

The SQL file contains the database structure, constraints, triggers, views, indexes, and sample data.

---

## 17. Run the Application

Navigate to the backend:

```powershell
cd backend
```

Run:

```powershell
python app.py
```

The Flask development server will start at:

```text
http://127.0.0.1:5000
```

Open this URL in a browser.

---

## 18. Database Connection Test

The application provides a database connection test endpoint:

```text
http://127.0.0.1:5000/test-db
```

A successful connection returns:

```json
{
  "database": "restaurant_management",
  "message": "Flask is connected to MySQL",
  "status": "success"
}
```

---

## 19. Sample Database Statistics

The sample database contains:

| Entity            | Records |
| ----------------- | ------: |
| Dining Areas      |       4 |
| Restaurant Tables |      16 |
| Customers         |      15 |
| Reservations      |      16 |
| Menu Items        |      18 |
| Waiters           |       5 |
| Food Orders       |      13 |
| Order Items       |      45 |
| Kitchen Tickets   |      45 |
| Discounts         |       4 |
| Bills             |      12 |
| Payments          |      12 |

---

## 20. Sample Reports

The database provides sample reporting data such as:

### Best-Selling Items

- Butter Naan
- Chicken Biryani
- Garlic Naan

### Payment Methods

- UPI
- CARD
- CASH

### Management Reports

- Waiter performance
- Table turnover
- Kitchen performance
- Discount usage
- Revenue by date
- Best-selling menu items

---

## 21. API Overview

The Flask backend provides APIs for major restaurant operations.

Examples include:

```text
/api/customers/
/api/reservations/
/api/reservations/<id>/status
/api/orders/
/api/orders/<id>/status
/api/menu/
/api/waiters/
/api/bills/
/api/payments/
/api/reports/revenue-summary
/api/reports/waiter-performance
/api/reports/best-selling
/api/reports/table-turnover
/api/reports/payment-method
/api/reports/discount-usage
/api/reports/kitchen-performance
/api/reports/revenue-by-date
```

---

## 22. Security and Data Integrity

The application uses several mechanisms to improve data integrity:

- Environment variables for database credentials.
- `.env` excluded from version control.
- Parameterized database queries.
- Primary and foreign keys.
- Unique constraints.
- Check constraints.
- Database triggers.
- Transaction handling.
- Row locking for critical billing operations.
- Controlled status transitions.
- Validation of reservation and payment data.

---

## 23. GitHub and Version Control

The project uses Git for version control.

Files excluded from Git include:

```text
.env
venv/
.venv/
__pycache__/
*.pyc
```

The project can be pushed to GitHub using Git or an IDE such as Antigravity.

---

## 24. Deployment

The application is designed for deployment using **Railway**.

The root `Procfile` contains:

```text
web: gunicorn --chdir backend app:app
```

The production architecture is:

```text
User Browser
      ↓
Railway Flask Application
      ↓
Gunicorn
      ↓
Flask Backend
      ↓
Railway MySQL
```

For deployment, database credentials should be configured using Railway environment variables rather than committing credentials to the repository.

---

## 25. Future Enhancements

Possible future improvements include:

- Online customer authentication.
- Admin login and role-based access control.
- QR-based table ordering.
- Real-time kitchen dashboard.
- Online payment gateway integration.
- Customer order history.
- Email/SMS reservation notifications.
- Advanced analytics dashboard.
- Restaurant staff management.
- Automated backup and recovery.
- Improved concurrency handling for reservations.
- Cloud-based image storage for menu items.

---

## 26. Project Outcome

The completed system demonstrates how a relational DBMS can be integrated with a web application to manage restaurant operations.

The project combines:

```text
Database Design
       +
SQL
       +
Constraints
       +
Triggers
       +
Views
       +
Indexes
       +
Transactions
       +
Flask REST APIs
       +
HTML/CSS/JavaScript
       =
Restaurant Management System
```

---

## 27. Author

**E. Nithya Lekhana**

B.Tech – Computer Science Engineering
Specialization: Artificial Intelligence and Machine Learning
