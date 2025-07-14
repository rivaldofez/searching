from flask import Flask, request, jsonify  # Import Flask for the web server, request to get query params, jsonify for JSON responses
import csv  # Import CSV module for reading the CSV file

# Create the Flask app instance
app = Flask(__name__)

# -------------------------------
# Load CSV data into memory once
# -------------------------------

# List to hold all news entries
news_entries = []

# Open the CSV file with latin-1 encoding to handle special characters
with open('all-data.csv', newline='', encoding='latin-1') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        if row:  # Skip empty rows
            # Combine all columns in the row into a single string and add to the list
            news_entries.append(' '.join(row))

# -------------------------------
# Define the /search route
# -------------------------------

@app.route("/search")
def search():
    # Get the query parameter 'q' from the URL, default to empty string if not provided
    q = request.args.get('q', '').lower()

    results = []

    if q:
        # Loop through all loaded news entries
        for entry in news_entries:
            # Case-insensitive search: check if query is in the entry
            if q in entry.lower():
                results.append(entry)

            # Limit the results to 15 matches max
            if len(results) >= 15:
                break

    # Return the results as JSON array
    return jsonify(results)

# -------------------------------
# Run the Flask server locally on port 5000
# -------------------------------
if __name__ == "__main__":
    app.run(port=5000)
