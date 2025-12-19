from flask import Flask, request, jsonify
from flask_cors import CORS
from pymongo import MongoClient
import os


app = Flask(__name__)
CORS(app)


MONGO_URI = "mongodb+srv://maqs_db_user:UzwPnTZi2Jjf2M8y@cluster0.b3gn9jq.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

client = MongoClient(MONGO_URI)
db = client['formdb']
collection = db['submissions']


@app.route('/submit', methods=['POST'])
def submit():
	data = request.get_json()
	if not data:
		return jsonify({"error": "No data received"}), 400

	insert_result = collection.insert_one(data)

	return jsonify({
		"status": "success",
		"inserted_id": str(insert_result.inserted_id)
	})


@app.route('/')
def home():
	return {"message": "Flask backend running"}


if __name__ == '__main__':
	app.run(host='0.0.0.0', port=5000)

