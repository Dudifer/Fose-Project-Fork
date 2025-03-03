from flask import Blueprint, request, jsonify, render_template, current_app
# import mysql.connector
import bcrypt
# from .app import db  # Import db from app.py

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    return render_template('index.html')

@main_bp.route('/about')
def about():
    return render_template('about.html')

# @main_bp.route('/api/login', methods=['POST'])
@main_bp.route('../../react-frontend/src/components/login.jsx', methods=['POST'])
def login():
    data = request.json
    email = data['email']
    password = data['password']

    cursor = db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
    email = cursor.fetchone()

    if email and bcrypt.checkpw(password.encode('utf-8'), email['password_hash'].encode('utf-8')):
        return jsonify({"message": "Login successful"}), 200
    else:
        return jsonify({"error": "Invalid credentials"}), 401
