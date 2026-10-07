from flask import Flask, jsonify, render_template, request
from db import get_db_connection
from mysql.connector import Error
from datetime import date, datetime, time, timedelta
from decimal import Decimal

app = Flask(
    __name__,
    template_folder="../frontend/templates",
    static_folder="../frontend/static",
    static_url_path="/static"
)


# ============================================================
# JSON SERIALIZATION
# ============================================================

def make_json_safe(value):
    if isinstance(value, Decimal):
        return float(value)

    if isinstance(value, (datetime, date, time)):
        return value.isoformat()

    if isinstance(value, timedelta):
        total_seconds = int(value.total_seconds())
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        seconds = total_seconds % 60
        return f"{hours:02d}:{minutes:02d}:{seconds:02d}"

    if isinstance(value, dict):
        return {
            key: make_json_safe(val)
            for key, val in value.items()
        }

    if isinstance(value, list):
        return [
            make_json_safe(item)
            for item in value
        ]

    return value


def safe_json(data, status_code=200):
    return jsonify(make_json_safe(data)), status_code


def get_connection_or_error():
    connection = get_db_connection()

    if connection is None:
        return None, jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    return connection, None, None


# ============================================================
# PAGE ROUTES
# ============================================================

@app.route("/")
def home():
    return render_template("index.html")


@app.route("/tables")
def tables_page():
    return render_template("tables.html")


@app.route("/reservations")
def reservations_page():
    return render_template("reservations.html")


@app.route("/orders")
def orders_page():
    return render_template("orders.html")


@app.route("/menu")
def menu_page():
    return render_template("menu.html")


@app.route("/billing")
def billing_page():
    return render_template("billing.html")


@app.route("/reports")
def reports_page():
    return render_template("reports.html")


# ============================================================
# TEST DATABASE
# ============================================================

@app.route("/test-db")
def test_db():
    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE()")
        database = cursor.fetchone()[0]

        return jsonify({
            "status": "success",
            "database": database,
            "message": "Flask is connected to MySQL"
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# DASHBOARD
# ============================================================

@app.route("/api/dashboard")
def dashboard():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor()

        cursor.execute("SELECT COUNT(*) FROM restaurant_table")
        tables = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM reservation")
        reservations = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM food_order")
        orders = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM menu_item")
        menu_items = cursor.fetchone()[0]

        return jsonify({
            "status": "success",
            "tables": tables,
            "reservations": reservations,
            "orders": orders,
            "menu_items": menu_items
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# TABLES
# ============================================================

@app.route("/api/tables")
def get_tables():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                rt.table_id,
                rt.table_number,
                da.area_name,
                rt.capacity,
                rt.table_status
            FROM restaurant_table rt
            JOIN dining_area da
                ON rt.area_id = da.area_id
            ORDER BY rt.table_id
        """)

        tables = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(tables),
            "tables": tables
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# CUSTOMERS
# ============================================================

@app.route("/api/customers")
def get_customers():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                customer_id,
                customer_name,
                phone,
                email
            FROM customer
            ORDER BY customer_name
        """)

        customers = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(customers),
            "customers": customers
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# RESERVATIONS - GET
# ============================================================

@app.route("/api/reservations", methods=["GET"])
def get_reservations():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                r.reservation_id,
                c.customer_name,
                rt.table_number,
                da.area_name,
                r.reservation_date,
                r.start_time,
                r.end_time,
                r.guest_count,
                r.reservation_status
            FROM reservation r
            JOIN customer c
                ON r.customer_id = c.customer_id
            JOIN restaurant_table rt
                ON r.table_id = rt.table_id
            JOIN dining_area da
                ON rt.area_id = da.area_id
            ORDER BY
                r.reservation_date DESC,
                r.start_time DESC,
                r.reservation_id DESC
        """)

        reservations = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(reservations),
            "reservations": reservations
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# CREATE RESERVATION
# ============================================================

@app.route("/api/reservations", methods=["POST"])
def create_reservation():
    data = request.get_json(silent=True)

    if not data:
        return jsonify({
            "status": "error",
            "message": "Request body must contain JSON data"
        }), 400

    required_fields = [
        "customer_id",
        "table_id",
        "reservation_date",
        "start_time",
        "end_time",
        "guest_count"
    ]

    for field in required_fields:
        if field not in data or data[field] in ("", None):
            return jsonify({
                "status": "error",
                "message": f"Missing field: {field}"
            }), 400

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        try:
            customer_id = int(data["customer_id"])
            table_id = int(data["table_id"])
            guest_count = int(data["guest_count"])

        except (ValueError, TypeError):
            return jsonify({
                "status": "error",
                "message": "Customer ID, Table ID and Guest Count must be valid numbers"
            }), 400

        reservation_date = str(data["reservation_date"])
        start_time = str(data["start_time"])
        end_time = str(data["end_time"])

        try:
            datetime.strptime(
                reservation_date,
                "%Y-%m-%d"
            )

        except ValueError:
            return jsonify({
                "status": "error",
                "message": "Invalid reservation date. Use YYYY-MM-DD"
            }), 400

        try:
            start_obj = datetime.strptime(
                start_time,
                "%H:%M"
            ).time()

        except ValueError:
            try:
                start_obj = datetime.strptime(
                    start_time,
                    "%H:%M:%S"
                ).time()

            except ValueError:
                return jsonify({
                    "status": "error",
                    "message": "Invalid start time. Use HH:MM"
                }), 400

        try:
            end_obj = datetime.strptime(
                end_time,
                "%H:%M"
            ).time()

        except ValueError:
            try:
                end_obj = datetime.strptime(
                    end_time,
                    "%H:%M:%S"
                ).time()

            except ValueError:
                return jsonify({
                    "status": "error",
                    "message": "Invalid end time. Use HH:MM"
                }), 400

        if guest_count <= 0:
            return jsonify({
                "status": "error",
                "message": "Number of guests must be greater than 0"
            }), 400

        if start_obj >= end_obj:
            return jsonify({
                "status": "error",
                "message": "Start time must be before end time"
            }), 400

        cursor.execute("""
            SELECT customer_id
            FROM customer
            WHERE customer_id = %s
        """, (customer_id,))

        customer = cursor.fetchone()

        if customer is None:
            return jsonify({
                "status": "error",
                "message": "Selected customer does not exist"
            }), 400

        cursor.execute("""
            SELECT
                table_id,
                table_number,
                capacity,
                table_status
            FROM restaurant_table
            WHERE table_id = %s
        """, (table_id,))

        table = cursor.fetchone()

        if table is None:
            return jsonify({
                "status": "error",
                "message": "Selected table does not exist"
            }), 400

        if guest_count > table["capacity"]:
            return jsonify({
                "status": "error",
                "message": (
                    f"Table {table['table_number']} can accommodate "
                    f"only {table['capacity']} guests"
                )
            }), 400

        if table["table_status"] == "MAINTENANCE":
            return jsonify({
                "status": "error",
                "message": (
                    f"Table {table['table_number']} is under maintenance"
                )
            }), 400

        cursor.execute("""
            SELECT
                reservation_id,
                start_time,
                end_time
            FROM reservation
            WHERE table_id = %s
              AND reservation_date = %s
              AND reservation_status NOT IN ('CANCELLED', 'NO_SHOW')
              AND start_time < %s
              AND end_time > %s
            LIMIT 1
        """, (
            table_id,
            reservation_date,
            end_time,
            start_time
        ))

        conflict = cursor.fetchone()

        if conflict:
            return jsonify({
                "status": "error",
                "message": (
                    f"Table {table['table_number']} is already reserved "
                    f"from {str(conflict['start_time'])} "
                    f"to {str(conflict['end_time'])}"
                )
            }), 409

        cursor.execute("""
            INSERT INTO reservation
            (
                customer_id,
                table_id,
                reservation_date,
                start_time,
                end_time,
                guest_count,
                reservation_status
            )
            VALUES
            (%s, %s, %s, %s, %s, %s, 'CONFIRMED')
        """, (
            customer_id,
            table_id,
            reservation_date,
            start_time,
            end_time,
            guest_count
        ))

        connection.commit()

        reservation_id = cursor.lastrowid

        return jsonify({
            "status": "success",
            "message": "Reservation created successfully",
            "reservation_id": reservation_id
        }), 201

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# UPDATE RESERVATION STATUS
# ============================================================

@app.route(
    "/api/reservations/<int:reservation_id>/status",
    methods=["PATCH"]
)
def update_reservation_status(reservation_id):
    data = request.get_json(silent=True)

    if not data or "status" not in data:
        return jsonify({
            "status": "error",
            "message": "Request body must contain a status"
        }), 400

    new_status = str(
        data["status"]
    ).strip().upper()

    allowed_statuses = {
        "CONFIRMED",
        "SEATED",
        "COMPLETED",
        "CANCELLED",
        "NO_SHOW"
    }

    if new_status not in allowed_statuses:
        return jsonify({
            "status": "error",
            "message": (
                "Invalid reservation status. Allowed values: "
                "CONFIRMED, SEATED, COMPLETED, CANCELLED, NO_SHOW"
            )
        }), 400

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                reservation_id,
                reservation_status
            FROM reservation
            WHERE reservation_id = %s
        """, (reservation_id,))

        reservation = cursor.fetchone()

        if reservation is None:
            return jsonify({
                "status": "error",
                "message": "Reservation not found"
            }), 404

        old_status = str(
            reservation["reservation_status"]
        ).strip().upper()

        allowed_transitions = {
            "CONFIRMED": {
                "SEATED",
                "CANCELLED",
                "NO_SHOW"
            },
            "SEATED": {
                "COMPLETED"
            },
            "COMPLETED": set(),
            "CANCELLED": set(),
            "NO_SHOW": set()
        }

        if new_status == old_status:
            return jsonify({
                "status": "success",
                "message": "Reservation status is already set to this value",
                "reservation_id": reservation_id,
                "old_status": old_status,
                "new_status": new_status
            })

        if new_status not in allowed_transitions.get(
            old_status,
            set()
        ):
            return jsonify({
                "status": "error",
                "message": (
                    f"Invalid reservation status transition: "
                    f"{old_status} -> {new_status}. "
                    f"Allowed transitions are: "
                    "CONFIRMED -> SEATED/CANCELLED/NO_SHOW; "
                    "SEATED -> COMPLETED."
                )
            }), 409

        cursor.execute("""
            UPDATE reservation
            SET reservation_status = %s
            WHERE reservation_id = %s
        """, (
            new_status,
            reservation_id
        ))

        connection.commit()

        return jsonify({
            "status": "success",
            "message": "Reservation status updated successfully",
            "reservation_id": reservation_id,
            "old_status": reservation["reservation_status"],
            "new_status": new_status
        })

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# ORDERS - GET ALL
# ============================================================

@app.route("/api/orders")
def get_orders():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                fo.order_id,
                fo.reservation_id,
                c.customer_name,
                w.waiter_name,
                fo.order_time,
                fo.order_status,
                COUNT(oi.order_item_id) AS item_count,
                COALESCE(
                    SUM(
                        oi.quantity * oi.unit_price
                    ),
                    0
                ) AS order_total
            FROM food_order fo
            JOIN reservation r
                ON fo.reservation_id = r.reservation_id
            JOIN customer c
                ON r.customer_id = c.customer_id
            JOIN waiter w
                ON fo.waiter_id = w.waiter_id
            LEFT JOIN order_item oi
                ON fo.order_id = oi.order_id
            GROUP BY
                fo.order_id,
                fo.reservation_id,
                c.customer_name,
                w.waiter_name,
                fo.order_time,
                fo.order_status
            ORDER BY fo.order_id DESC
        """)

        orders = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(orders),
            "orders": orders
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# GET WAITERS
# ============================================================

@app.route("/api/waiters", methods=["GET"])
def get_waiters():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                waiter_id,
                waiter_name,
                phone,
                shift,
                status
            FROM waiter
            WHERE status = 'ACTIVE'
            ORDER BY waiter_name
        """)

        waiters = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(waiters),
            "waiters": waiters
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# CREATE ORDER
# ============================================================

@app.route("/api/orders", methods=["POST"])
def create_order():
    data = request.get_json(silent=True)

    if not data:
        return jsonify({
            "status": "error",
            "message": "Request body must contain JSON data"
        }), 400

    for field in (
        "reservation_id",
        "waiter_id",
        "items"
    ):
        if field not in data or data[field] in ("", None):
            return jsonify({
                "status": "error",
                "message": f"Missing field: {field}"
            }), 400

    try:
        reservation_id = int(data["reservation_id"])
        waiter_id = int(data["waiter_id"])

    except (ValueError, TypeError):
        return jsonify({
            "status": "error",
            "message": "Reservation ID and Waiter ID must be valid numbers"
        }), 400

    items = data["items"]

    if not isinstance(items, list) or not items:
        return jsonify({
            "status": "error",
            "message": "At least one menu item is required"
        }), 400

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                reservation_id,
                reservation_status
            FROM reservation
            WHERE reservation_id = %s
            FOR UPDATE
        """, (reservation_id,))

        reservation = cursor.fetchone()

        if reservation is None:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Reservation not found"
            }), 404

        reservation_status = str(
            reservation["reservation_status"]
        ).strip().upper()

        if reservation_status != "SEATED":
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": (
                    "Order can only be placed for a SEATED reservation. "
                    f"Current reservation status is {reservation_status}."
                )
            }), 409

        cursor.execute("""
            SELECT
                waiter_id,
                waiter_name,
                status
            FROM waiter
            WHERE waiter_id = %s
        """, (waiter_id,))

        waiter = cursor.fetchone()

        if waiter is None:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Waiter not found"
            }), 404

        if str(
            waiter["status"]
        ).strip().upper() != "ACTIVE":
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Selected waiter is not active"
            }), 409

        normalized_items = []
        seen_item_ids = set()

        for item in items:

            if not isinstance(item, dict):
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": "Each order item must be an object"
                }), 400

            if (
                "item_id" not in item
                or "quantity" not in item
            ):
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": (
                        "Each order item requires "
                        "item_id and quantity"
                    )
                }), 400

            try:
                item_id = int(item["item_id"])
                quantity = int(item["quantity"])

            except (ValueError, TypeError):
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": (
                        "Menu item ID and quantity "
                        "must be valid numbers"
                    )
                }), 400

            if quantity <= 0:
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": (
                        "Order quantity must be greater than zero"
                    )
                }), 400

            if item_id in seen_item_ids:
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": (
                        "A menu item cannot be added "
                        "more than once in the same order"
                    )
                }), 400

            seen_item_ids.add(item_id)

            instruction = item.get(
                "special_instruction"
            )

            if instruction is not None:
                instruction = str(
                    instruction
                ).strip()[:255]

            normalized_items.append({
                "item_id": item_id,
                "quantity": quantity,
                "special_instruction": instruction
            })

        item_ids = [
            item["item_id"]
            for item in normalized_items
        ]

        placeholders = ", ".join(
            ["%s"] * len(item_ids)
        )

        cursor.execute(
            f"""
            SELECT
                item_id,
                item_name,
                price,
                is_available
            FROM menu_item
            WHERE item_id IN ({placeholders})
            FOR UPDATE
            """,
            tuple(item_ids)
        )

        menu_rows = cursor.fetchall()

        menu_by_id = {
            row["item_id"]: row
            for row in menu_rows
        }

        if len(menu_by_id) != len(item_ids):
            connection.rollback()

            missing_ids = [
                str(item_id)
                for item_id in item_ids
                if item_id not in menu_by_id
            ]

            return jsonify({
                "status": "error",
                "message": (
                    "Menu item not found: "
                    + ", ".join(missing_ids)
                )
            }), 404

        for item in normalized_items:

            menu_item = menu_by_id[
                item["item_id"]
            ]

            available = menu_item[
                "is_available"
            ]

            if available in (
                0,
                False,
                "0",
                "false",
                "False"
            ):
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": (
                        f"Menu item "
                        f"'{menu_item['item_name']}' "
                        "is currently unavailable"
                    )
                }), 409

        cursor.execute("""
            INSERT INTO food_order
            (
                reservation_id,
                waiter_id,
                order_status
            )
            VALUES
            (%s, %s, 'PLACED')
        """, (
            reservation_id,
            waiter_id
        ))

        order_id = cursor.lastrowid

        for item in normalized_items:

            menu_item = menu_by_id[
                item["item_id"]
            ]

            cursor.execute("""
                INSERT INTO order_item
                (
                    order_id,
                    item_id,
                    quantity,
                    unit_price,
                    special_instruction
                )
                VALUES
                (%s, %s, %s, %s, %s)
            """, (
                order_id,
                item["item_id"],
                item["quantity"],
                menu_item["price"],
                item["special_instruction"]
            ))

            order_item_id = cursor.lastrowid

            cursor.execute("""
                INSERT INTO kitchen_ticket
                (
                    order_id,
                    order_item_id,
                    kitchen_status
                )
                VALUES
                (%s, %s, 'RECEIVED')
            """, (
                order_id,
                order_item_id
            ))

        connection.commit()

        return jsonify({
            "status": "success",
            "message": "Order created successfully",
            "order_id": order_id,
            "reservation_id": reservation_id,
            "waiter_id": waiter_id
        }), 201

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# UPDATE ORDER STATUS
# ============================================================

@app.route(
    "/api/orders/<int:order_id>/status",
    methods=["PATCH"]
)
def update_order_status(order_id):
    data = request.get_json(silent=True)

    if not data or "status" not in data:
        return jsonify({
            "status": "error",
            "message": "Request body must contain a status"
        }), 400

    new_status = str(
        data["status"]
    ).strip().upper()

    allowed_statuses = {
        "PLACED",
        "PREPARING",
        "READY",
        "SERVED",
        "CANCELLED"
    }

    if new_status not in allowed_statuses:
        return jsonify({
            "status": "error",
            "message": (
                "Invalid order status. Allowed values: "
                "PLACED, PREPARING, READY, SERVED, CANCELLED"
            )
        }), 400

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                order_id,
                order_status
            FROM food_order
            WHERE order_id = %s
        """, (order_id,))

        order = cursor.fetchone()

        if order is None:
            return jsonify({
                "status": "error",
                "message": "Order not found"
            }), 404

        old_status = str(
            order["order_status"]
        ).strip().upper()

        allowed_transitions = {
            "PLACED": {
                "PREPARING",
                "CANCELLED"
            },
            "PREPARING": {
                "READY",
                "CANCELLED"
            },
            "READY": {
                "SERVED"
            },
            "SERVED": set(),
            "CANCELLED": set()
        }

        if new_status == old_status:
            return jsonify({
                "status": "success",
                "message": "Order status is already set to this value",
                "order_id": order_id,
                "old_status": old_status,
                "new_status": new_status
            })

        if new_status not in allowed_transitions.get(
            old_status,
            set()
        ):
            return jsonify({
                "status": "error",
                "message": (
                    f"Invalid order status transition: "
                    f"{old_status} -> {new_status}. "
                    f"Allowed transitions are: "
                    "PLACED -> PREPARING/CANCELLED; "
                    "PREPARING -> READY/CANCELLED; "
                    "READY -> SERVED."
                )
            }), 409

        cursor.execute("""
            UPDATE food_order
            SET order_status = %s
            WHERE order_id = %s
        """, (
            new_status,
            order_id
        ))

        connection.commit()

        return jsonify({
            "status": "success",
            "message": "Order status updated successfully",
            "order_id": order_id,
            "old_status": order["order_status"],
            "new_status": new_status
        })

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# MENU
# ============================================================

@app.route("/api/menu")
def get_menu():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                item_id,
                item_name,
                category,
                description,
                price,
                is_available
            FROM menu_item
            ORDER BY category, item_name
        """)

        menu_items = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(menu_items),
            "menu_items": menu_items
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# DISCOUNTS
# ============================================================

@app.route("/api/discounts")
def get_discounts():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                discount_id,
                discount_name,
                discount_type,
                discount_value,
                max_discount,
                is_active,
                authorized_by
            FROM discount
            ORDER BY discount_id
        """)

        discounts = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(discounts),
            "discounts": discounts
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# BILLING SUMMARY
# ============================================================

@app.route("/api/billing-summary")
def billing_summary():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                COUNT(*) AS total_bills,
                SUM(
                    CASE
                        WHEN bill_status = 'OPEN'
                        THEN 1
                        ELSE 0
                    END
                ) AS open_bills,
                SUM(
                    CASE
                        WHEN bill_status = 'CLOSED'
                        THEN 1
                        ELSE 0
                    END
                ) AS closed_bills,
                COALESCE(
                    SUM(
                        CASE
                            WHEN bill_status = 'CLOSED'
                            THEN total_amount
                            ELSE 0
                        END
                    ),
                    0
                ) AS revenue
            FROM bill
        """)

        summary = cursor.fetchone()

        cursor.execute("""
            SELECT
                COALESCE(
                    SUM(amount),
                    0
                ) AS payments_received
            FROM payment
            WHERE payment_status = 'SUCCESS'
        """)

        payment_data = cursor.fetchone()

        summary["payments_received"] = payment_data[
            "payments_received"
        ]

        return safe_json({
            "status": "success",
            **summary
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# BILLS
# ============================================================

@app.route("/api/bills")
def get_bills():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                b.bill_id,
                b.order_id,
                c.customer_name,
                b.subtotal,
                b.discount_id,
                d.discount_name,
                b.discount_amount,
                b.tax_amount,
                b.total_amount,
                COALESCE(
                    (
                        SELECT SUM(p.amount)
                        FROM payment p
                        WHERE p.bill_id = b.bill_id
                          AND p.payment_status = 'SUCCESS'
                    ),
                    0
                ) AS paid_amount,
                (
                    b.total_amount -
                    COALESCE(
                        (
                            SELECT SUM(p.amount)
                            FROM payment p
                            WHERE p.bill_id = b.bill_id
                              AND p.payment_status = 'SUCCESS'
                        ),
                        0
                    )
                ) AS balance_amount,
                b.bill_status,
                b.created_at,
                b.closed_at
            FROM bill b
            JOIN food_order fo
                ON b.order_id = fo.order_id
            JOIN reservation r
                ON fo.reservation_id = r.reservation_id
            JOIN customer c
                ON r.customer_id = c.customer_id
            LEFT JOIN discount d
                ON b.discount_id = d.discount_id
            ORDER BY b.bill_id DESC
        """)

        bills = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(bills),
            "bills": bills
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# CREATE BILL
# ============================================================

@app.route("/api/bills", methods=["POST"])
def create_bill():
    data = request.get_json(silent=True)

    if not data or "order_id" not in data:
        return jsonify({
            "status": "error",
            "message": "Order ID is required"
        }), 400

    try:
        order_id = int(data["order_id"])

    except (ValueError, TypeError):
        return jsonify({
            "status": "error",
            "message": "Order ID must be a valid number"
        }), 400

    discount_id = data.get("discount_id")

    if discount_id in ("", None):
        discount_id = None

    else:
        try:
            discount_id = int(discount_id)

        except (ValueError, TypeError):
            return jsonify({
                "status": "error",
                "message": "Discount ID must be a valid number"
            }), 400

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                order_id,
                order_status
            FROM food_order
            WHERE order_id = %s
            FOR UPDATE
        """, (order_id,))

        order = cursor.fetchone()

        if order is None:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Order not found"
            }), 404

        order_status = str(
            order["order_status"]
        ).strip().upper()

        if order_status != "SERVED":
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": (
                    "A bill can only be created for a SERVED order. "
                    f"Current order status is {order_status}."
                )
            }), 409

        cursor.execute("""
            SELECT bill_id
            FROM bill
            WHERE order_id = %s
            FOR UPDATE
        """, (order_id,))

        existing_bill = cursor.fetchone()

        if existing_bill is not None:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": (
                    f"Order #{order_id} already has "
                    f"Bill #{existing_bill['bill_id']}"
                ),
                "bill_id": existing_bill["bill_id"]
            }), 409

        cursor.execute("""
            SELECT COALESCE(
                SUM(quantity * unit_price),
                0
            ) AS subtotal
            FROM order_item
            WHERE order_id = %s
        """, (order_id,))

        subtotal_row = cursor.fetchone()

        subtotal = Decimal(
            str(
                subtotal_row["subtotal"]
                or 0
            )
        )

        if subtotal <= 0:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Order has no billable items"
            }), 409

        discount_amount = Decimal("0.00")

        if discount_id is not None:

            cursor.execute("""
                SELECT
                    discount_id,
                    discount_type,
                    discount_value,
                    max_discount,
                    is_active
                FROM discount
                WHERE discount_id = %s
                FOR UPDATE
            """, (discount_id,))

            discount = cursor.fetchone()

            if discount is None:
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": "Discount not found"
                }), 404

            if not discount["is_active"]:
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": "Cannot apply an inactive discount"
                }), 409

            discount_type = str(
                discount["discount_type"]
            ).strip().upper()

            discount_value = Decimal(
                str(
                    discount["discount_value"]
                )
            )

            max_discount = discount["max_discount"]

            if max_discount is not None:
                max_discount = Decimal(
                    str(max_discount)
                )

            if discount_type == "PERCENTAGE":

                discount_amount = (
                    subtotal
                    * discount_value
                    / Decimal("100")
                )

            elif discount_type == "FIXED":

                discount_amount = discount_value

            else:
                connection.rollback()

                return jsonify({
                    "status": "error",
                    "message": "Invalid discount type"
                }), 400

            if max_discount is not None:
                discount_amount = min(
                    discount_amount,
                    max_discount
                )

            discount_amount = min(
                discount_amount,
                subtotal
            ).quantize(
                Decimal("0.01")
            )

        # Existing project billing data uses 5% tax.
        # Tax is calculated on subtotal before discount.
        tax_amount = (
            subtotal
            * Decimal("0.05")
        ).quantize(
            Decimal("0.01")
        )

        total_amount = (
            subtotal
            - discount_amount
            + tax_amount
        ).quantize(
            Decimal("0.01")
        )

        cursor.execute("""
            INSERT INTO bill
            (
                order_id,
                subtotal,
                discount_id,
                discount_amount,
                tax_amount,
                total_amount,
                bill_status
            )
            VALUES
            (%s, %s, %s, %s, %s, %s, 'OPEN')
        """, (
            order_id,
            subtotal,
            discount_id,
            discount_amount,
            tax_amount,
            total_amount
        ))

        bill_id = cursor.lastrowid

        connection.commit()

        return safe_json({
            "status": "success",
            "message": "Bill created successfully",
            "bill_id": bill_id,
            "order_id": order_id,
            "subtotal": subtotal,
            "discount_amount": discount_amount,
            "tax_amount": tax_amount,
            "total_amount": total_amount,
            "bill_status": "OPEN"
        }, 201)

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# PAYMENTS
# ============================================================

@app.route("/api/payments")
def get_payments():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                p.payment_id,
                p.bill_id,
                b.order_id,
                c.customer_name,
                p.payment_method,
                p.amount,
                p.payment_status,
                p.transaction_reference,
                p.paid_at,
                b.total_amount AS bill_total
            FROM payment p
            JOIN bill b
                ON p.bill_id = b.bill_id
            JOIN food_order fo
                ON b.order_id = fo.order_id
            JOIN reservation r
                ON fo.reservation_id = r.reservation_id
            JOIN customer c
                ON r.customer_id = c.customer_id
            ORDER BY p.payment_id DESC
        """)

        payments = cursor.fetchall()

        return safe_json({
            "status": "success",
            "count": len(payments),
            "payments": payments
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# RECORD PAYMENT
# ============================================================

@app.route("/api/payments", methods=["POST"])
def create_payment():
    data = request.get_json(silent=True)

    required_fields = [
        "bill_id",
        "amount",
        "payment_method"
    ]

    if not data:
        return jsonify({
            "status": "error",
            "message": "Request body must contain JSON data"
        }), 400

    for field in required_fields:

        if field not in data or data[field] in ("", None):
            return jsonify({
                "status": "error",
                "message": f"Missing field: {field}"
            }), 400

    try:
        bill_id = int(data["bill_id"])

        amount = Decimal(
            str(data["amount"])
        )

    except (
        ValueError,
        TypeError,
        ArithmeticError
    ):
        return jsonify({
            "status": "error",
            "message": "Bill ID and amount must be valid values"
        }), 400

    payment_method = str(
        data["payment_method"]
    ).strip().upper()

    if payment_method not in {
        "CASH",
        "CARD",
        "UPI"
    }:
        return jsonify({
            "status": "error",
            "message": (
                "Invalid payment method. "
                "Allowed values: CASH, CARD, UPI"
            )
        }), 400

    if amount <= 0:
        return jsonify({
            "status": "error",
            "message": "Payment amount must be greater than zero"
        }), 400

    transaction_reference = data.get(
        "transaction_reference"
    )

    if transaction_reference is not None:
        transaction_reference = str(
            transaction_reference
        ).strip()[:100]

        if transaction_reference == "":
            transaction_reference = None

    connection = get_db_connection()

    if connection is None:
        return jsonify({
            "status": "error",
            "message": "Database connection failed"
        }), 500

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                bill_id,
                order_id,
                total_amount,
                bill_status
            FROM bill
            WHERE bill_id = %s
            FOR UPDATE
        """, (bill_id,))

        bill = cursor.fetchone()

        if bill is None:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": "Bill not found"
            }), 404

        bill_status = str(
            bill["bill_status"]
        ).strip().upper()

        if bill_status != "OPEN":
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": (
                    f"Bill #{bill_id} is already "
                    f"{bill_status.lower()} and cannot receive another payment"
                )
            }), 409

        bill_total = Decimal(
            str(
                bill["total_amount"]
            )
        )

        cursor.execute("""
            SELECT
                COALESCE(
                    SUM(amount),
                    0
                ) AS paid_amount
            FROM payment
            WHERE bill_id = %s
              AND payment_status = 'SUCCESS'
        """, (bill_id,))

        payment_row = cursor.fetchone()

        paid_amount = Decimal(
            str(
                payment_row["paid_amount"]
                or 0
            )
        )

        remaining_before = (
            bill_total
            - paid_amount
        ).quantize(
            Decimal("0.01")
        )

        if amount > remaining_before:
            connection.rollback()

            return jsonify({
                "status": "error",
                "message": (
                    "Payment exceeds remaining balance. "
                    f"Remaining balance is ₹{remaining_before:.2f}"
                )
            }), 409

        cursor.execute("""
            INSERT INTO payment
            (
                bill_id,
                payment_method,
                amount,
                payment_status,
                transaction_reference
            )
            VALUES
            (%s, %s, %s, 'SUCCESS', %s)
        """, (
            bill_id,
            payment_method,
            amount,
            transaction_reference
        ))

        payment_id = cursor.lastrowid

        paid_amount_after = (
            paid_amount
            + amount
        ).quantize(
            Decimal("0.01")
        )

        remaining_balance = (
            bill_total
            - paid_amount_after
        ).quantize(
            Decimal("0.01")
        )

        bill_closed = False

        if remaining_balance == Decimal("0.00"):

            cursor.execute("""
                UPDATE bill
                SET
                    bill_status = 'CLOSED',
                    closed_at = CURRENT_TIMESTAMP
                WHERE bill_id = %s
                  AND bill_status = 'OPEN'
            """, (bill_id,))

            bill_closed = True

            cursor.execute("""
                SELECT reservation_id
                FROM food_order
                WHERE order_id = %s
            """, (bill["order_id"],))

            order_info = cursor.fetchone()

            if order_info:

                reservation_id = order_info[
                    "reservation_id"
                ]

                cursor.execute("""
                    SELECT COUNT(*) AS open_bills
                    FROM bill b
                    JOIN food_order fo
                        ON b.order_id = fo.order_id
                    WHERE fo.reservation_id = %s
                      AND b.bill_status = 'OPEN'
                """, (reservation_id,))

                open_bill_row = cursor.fetchone()

                if open_bill_row["open_bills"] == 0:

                    cursor.execute("""
                        UPDATE reservation
                        SET reservation_status = 'COMPLETED'
                        WHERE reservation_id = %s
                          AND reservation_status = 'SEATED'
                    """, (reservation_id,))

                    cursor.execute("""
                        UPDATE restaurant_table rt
                        JOIN reservation r
                            ON rt.table_id = r.table_id
                        SET rt.table_status = 'AVAILABLE'
                        WHERE r.reservation_id = %s
                          AND r.reservation_status = 'COMPLETED'
                          AND rt.table_status <> 'MAINTENANCE'
                    """, (reservation_id,))

        connection.commit()

        return safe_json({
            "status": "success",
            "message": "Payment recorded successfully",
            "payment_id": payment_id,
            "bill_id": bill_id,
            "amount": amount,
            "paid_amount": paid_amount_after,
            "remaining_balance": remaining_balance,
            "bill_closed": bill_closed
        }, 201)

    except Error as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 400

    except Exception as e:
        connection.rollback()

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - REVENUE SUMMARY
# ============================================================

@app.route("/api/reports/revenue-summary")
def revenue_summary():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                COALESCE(
                    SUM(total_amount),
                    0
                ) AS total_revenue,
                COUNT(*) AS closed_bills
            FROM bill
            WHERE bill_status = 'CLOSED'
        """)

        data = cursor.fetchone()

        cursor.execute("""
            SELECT
                COALESCE(
                    SUM(amount),
                    0
                ) AS total_payments
            FROM payment
            WHERE payment_status = 'SUCCESS'
        """)

        payment_data = cursor.fetchone()

        cursor.execute("""
            SELECT
                COALESCE(
                    AVG(total_amount),
                    0
                ) AS average_order_value
            FROM bill
            WHERE bill_status = 'CLOSED'
        """)

        average_data = cursor.fetchone()

        return safe_json({
            "status": "success",
            "total_revenue": data["total_revenue"],
            "closed_bills": data["closed_bills"],
            "total_payments": payment_data["total_payments"],
            "average_order_value":
                average_data["average_order_value"]
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - WAITER PERFORMANCE
# ============================================================

@app.route("/api/reports/waiter-performance")
def waiter_performance():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                w.waiter_name,
                COUNT(
                    DISTINCT fo.order_id
                ) AS total_orders,
                COALESCE(
                    SUM(
                        CASE
                            WHEN b.bill_status = 'CLOSED'
                            THEN b.total_amount
                            ELSE 0
                        END
                    ),
                    0
                ) AS total_revenue
            FROM waiter w
            LEFT JOIN food_order fo
                ON w.waiter_id = fo.waiter_id
            LEFT JOIN bill b
                ON fo.order_id = b.order_id
            GROUP BY
                w.waiter_id,
                w.waiter_name
            ORDER BY total_revenue DESC
        """)

        data = cursor.fetchall()

        return safe_json({
            "status": "success",
            "waiter_performance": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - BEST SELLING
# ============================================================

@app.route("/api/reports/best-selling")
def best_selling():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                mi.item_name,
                mi.category,
                SUM(
                    oi.quantity
                ) AS quantity_sold,
                SUM(
                    oi.quantity * oi.unit_price
                ) AS total_sales
            FROM order_item oi
            JOIN menu_item mi
                ON oi.item_id = mi.item_id
            JOIN food_order fo
                ON oi.order_id = fo.order_id
            WHERE fo.order_status <> 'CANCELLED'
            GROUP BY
                mi.item_id,
                mi.item_name,
                mi.category
            ORDER BY
                quantity_sold DESC,
                total_sales DESC
        """)

        data = cursor.fetchall()

        for index, row in enumerate(
            data,
            start=1
        ):
            row["rank"] = index

        return safe_json({
            "status": "success",
            "best_selling": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - TABLE TURNOVER
# ============================================================

@app.route("/api/reports/table-turnover")
def table_turnover():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                rt.table_number,
                da.area_name,
                COUNT(
                    CASE
                        WHEN r.reservation_status = 'COMPLETED'
                        THEN r.reservation_id
                    END
                ) AS completed_reservations
            FROM restaurant_table rt
            JOIN dining_area da
                ON rt.area_id = da.area_id
            LEFT JOIN reservation r
                ON rt.table_id = r.table_id
            GROUP BY
                rt.table_id,
                rt.table_number,
                da.area_name
            ORDER BY
                completed_reservations DESC,
                rt.table_id
        """)

        data = cursor.fetchall()

        return safe_json({
            "status": "success",
            "table_turnover": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - PAYMENT METHOD
# ============================================================

@app.route("/api/reports/payment-method")
def payment_method_report():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                payment_method,
                COUNT(*) AS number_of_payments,
                SUM(amount) AS total_amount
            FROM payment
            WHERE payment_status = 'SUCCESS'
            GROUP BY payment_method
            ORDER BY total_amount DESC
        """)

        data = cursor.fetchall()

        return safe_json({
            "status": "success",
            "payment_methods": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - DISCOUNT USAGE
# ============================================================

@app.route("/api/reports/discount-usage")
def discount_usage():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                d.discount_name,
                COUNT(
                    b.bill_id
                ) AS times_used,
                COALESCE(
                    SUM(
                        b.discount_amount
                    ),
                    0
                ) AS total_discount
            FROM discount d
            LEFT JOIN bill b
                ON d.discount_id = b.discount_id
            GROUP BY
                d.discount_id,
                d.discount_name
            ORDER BY times_used DESC
        """)

        data = cursor.fetchall()

        return safe_json({
            "status": "success",
            "discount_usage": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - KITCHEN PERFORMANCE
# ============================================================

@app.route("/api/reports/kitchen-performance")
def kitchen_performance():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                COALESCE(
                    AVG(
                        TIMESTAMPDIFF(
                            MINUTE,
                            received_at,
                            ready_at
                        )
                    ),
                    0
                ) AS average_preparation_time
            FROM kitchen_ticket
            WHERE ready_at IS NOT NULL
        """)

        data = cursor.fetchone()

        return safe_json({
            "status": "success",
            "average_preparation_time":
                data["average_preparation_time"]
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT - REVENUE BY DATE
# ============================================================

@app.route("/api/reports/revenue-by-date")
def revenue_by_date():
    connection, error_response, error_code = get_connection_or_error()

    if connection is None:
        return error_response, error_code

    cursor = None

    try:
        cursor = connection.cursor(dictionary=True)

        cursor.execute("""
            SELECT
                r.reservation_date AS date,
                COUNT(
                    b.bill_id
                ) AS bills,
                SUM(
                    b.total_amount
                ) AS revenue
            FROM bill b
            JOIN food_order fo
                ON b.order_id = fo.order_id
            JOIN reservation r
                ON fo.reservation_id = r.reservation_id
            WHERE b.bill_status = 'CLOSED'
            GROUP BY r.reservation_date
            ORDER BY r.reservation_date
        """)

        data = cursor.fetchall()

        return safe_json({
            "status": "success",
            "revenue_by_date": data
        })

    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

    finally:
        if cursor:
            cursor.close()

        connection.close()


# ============================================================
# REPORT ALIASES
# ============================================================

@app.route("/api/reports/kitchen")
def kitchen_performance_alias():
    return kitchen_performance()


@app.route("/api/reports/revenue")
def revenue_by_date_alias():
    return revenue_by_date()


# ============================================================
# ERROR HANDLER
# ============================================================

@app.errorhandler(404)
def page_not_found(error):
    return jsonify({
        "status": "error",
        "message": "Requested route was not found"
    }), 404


# ============================================================
# RUN
# ============================================================

if __name__ == "__main__":
    app.run(
        debug=True,
        host="127.0.0.1",
        port=5000
    )