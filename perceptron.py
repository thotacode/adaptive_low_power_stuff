
import numpy as np
from sklearn.linear_model import Perceptron

X = []
y = []

# Burst workloads
for _ in range(500):
    seq = np.random.choice([0,1], size=8, p=[0.2,0.8]) 
    X.append(seq)
    y.append(1)

# Idle workloads
for _ in range(500):
    seq = np.random.choice([0,1], size=8, p=[0.9,0.1]) 
    X.append(seq)
    y.append(0)

# Periodic workloads
for _ in range(500):
    seq = np.array([1,0]*4)
    np.random.shuffle(seq)
    X.append(seq)
    y.append(1) 

X = np.array(X)
y = np.array(y)

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report

# Train, test, split to measure Test Accuracy
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.25, shuffle=True, random_state=42
)

model = Perceptron(alpha=0.001, max_iter=500, tol=1e-3)
model.fit(X_train, y_train)

y_pred = model.predict(X_test)

print("Training Accuracy:", model.score(X_train, y_train))
print("Test Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification Report:")
print(classification_report(y_test, y_pred))
print("\nConfusion Matrix:")
print(confusion_matrix(y_test, y_pred))

# -----------------------------
# Train Perceptron
# -----------------------------
model = Perceptron(alpha=0.001, max_iter=500, tol=1e-3)
model.fit(X,y)

print("Training Accuracy:", model.score(X,y))

weights = model.coef_[0]
bias = model.intercept_[0]

print("Float Weights:", weights)
print("Float Bias:", bias)

# -----------------------------
# Quantize Weights
# -----------------------------
scale = 16
qW = np.round(weights * scale).astype(int)
qB = int(round(bias * scale))

print("\nQuantized Weights:", qW)
print("Quantized Bias:", qB)

# -----------------------------
# Print as Verilog literals
# -----------------------------
print("\nCopy these to Verilog:")
for i,w in enumerate(qW):
    print(f"parameter signed W{i} = {w};")
print(f"parameter signed BIAS = {qB};")