# backend/db.py
import mysql.connector

def init_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="password",
        database="dams"
    )
