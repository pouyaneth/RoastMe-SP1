from flask import Flask, request, jsonify, render_template
import requests
import os
import random

app = Flask(__name__)

# Load API key from environment variable
API_KEY = os.getenv("HYPERBOLIC_API_KEY", "replace-your-api-key-here")

# Roasting prompts
ROAST_PROMPTS = [
    "{name} HODLs a dead coin like it’s fine art. Funny, crypto-themed roast only.",
    "{name} FOMO’d into a dump, now broke. Witty, crypto roast only.",
    "{name} owns a worthless NFT jpeg. Funny, blockchain roast only.",
    "{name} got rug-pulled in DeFi. Hilarious, crypto roast only.",
    "{name} moons a coin down 99%. Playful, crypto roast only.",
    "{name} sold BTC at $20k, oops. Funny, crypto roast only.",
    "{name} farms bad APYs like a pro. Humorous, blockchain roast only.",
    "{name} shills to 12 followers. Witty, crypto roast only.",
    "{name} whines about gas fees daily. Light, crypto roast only.",
    "{name} holds a 2021 altcoin bag. Funny, crypto roast only."
]

PERSONALITIES = [
    "The Diamond-Handed Degenerate", "The Yield-Farming Fool", "The FOMO Frenzy King",
    "The NFT Bagholder", "The Moon Lambo Loser", "The Gas Fee Griper", "The Rug Pull Rookie"
]

# Store the latest roast data for proof generation
latest_roast_data = {}

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/roast', methods=['POST'])
def roast():
    name = request.json.get('name')
    if not name:
        return jsonify({"error": "Name is required"}), 400

    prompt = random.choice(ROAST_PROMPTS).format(name=name)
    url = "https://api.hyperbolic.xyz/v1/chat/completions"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}"
    }
    data = {
        "messages": [{"role": "user", "content": prompt}],
        "model": "meta-llama/Meta-Llama-3.1-8B-Instruct",
        "max_tokens": 2048,
        "temperature": 0.7,
        "top_p": 0.9
    }

    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()
        roast = response.json()['choices'][0]['message']['content']
        personality = random.choice(PERSONALITIES)
        
        # Store data for proof generation
        global latest_roast_data
        latest_roast_data = {"name": name, "roast": roast}
        
        return jsonify({"roast": roast, "personality": personality})
    except requests.exceptions.RequestException:
        return jsonify({"error": "Failed to get roast"}), 500

@app.route('/get_roast_data', methods=['GET'])
def get_roast_data():
    return jsonify(latest_roast_data)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
