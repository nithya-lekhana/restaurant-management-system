import os

import mysql.connector
from mysql.connector import Error
from dotenv import load_dotenv


# Load environment variables from backend/.env
load_dotenv()


def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=int(os.getenv("DB_PORT", "3306")),
            user=os.getenv("DB_USER", "root"),
            password=os.getenv("DB_PASSWORD", ""),
            database=os.getenv(
                "DB_NAME",
                "restaurant_management"
            )
        )

        if connection.is_connected():
            print("MySQL database connected successfully!")
            return connection

    except Error as e:
        print("Database connection error:", e)

    return None