from flask import Flask, request, render_template, jsonify

app = Flask(__name__)

def calculate(num1, num2, operation):
    if operation == 'add':
        return num1 + num2
    elif operation == 'subtract':
        return num1 - num2
    elif operation == 'multiply':
        return num1 * num2
    elif operation == 'divide':
        if num2 != 0:
            return num1 / num2
        else:
            return "Error: Division by zero is not allowed."
    else:
        return "Error: Invalid operation."

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/calculate', methods=['POST'])
def calculate_route():
    data = request.form
    num1 = float(data.get('num1'))
    num2 = float(data.get('num2'))
    operation = data.get('operation')

    result = calculate(num1, num2, operation)
    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
