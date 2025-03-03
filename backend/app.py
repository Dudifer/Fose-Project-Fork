# backend/app.py
from flask import Flask
# from backend.routes import main_bp
# from backend.db import init_db  # Import the db initialization function
from routes import main_bp
from db import init_db 

def create_app():
    app = Flask(__name__)
    
    # Initialize the database here
    db = init_db()

    # Register the blueprint
    app.register_blueprint(main_bp)

    return app
