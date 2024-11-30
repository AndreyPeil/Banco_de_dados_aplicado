import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
import seaborn as sns

modelo = None
X_train_columns = None

def carregar():
    csv_path = r"C:\Users\andei\Downloads\Tarefa1_real_estate_data - Tarefa1_real_estate_data.csv"
    data = pd.read_csv(csv_path)
    return data

def visualizar(data):  
    print(data.head())
    
def coluna_atual(data):
    print(data.columns)

def verificar_nulos(data):
    print("Dados nulos por coluna:")
    print(data.isnull().sum())

def renomear_colunas(data):
    data.columns = ["Localizacao", "Tamanho (m²)", "Quartos", "Idade (Anos)", "Preco ($)"]
    return data

def criar_dummies(data, coluna):
    dummies = pd.get_dummies(data[coluna], prefix=coluna)
    data = pd.concat([data, dummies], axis=1)
    data = data.drop(coluna, axis=1)  
    return data

def calcular_correlacao(data):
    corr = data.corr()
    sns.set(rc={'axes.facecolor': 'white', 'figure.facecolor': 'white'})
    plt.figure(figsize=(12, 9))
    sns.heatmap(corr, vmax=0.8, annot=True, fmt='.2f', annot_kws={'size': 10})
    plt.title("Mapa de Correlação")
    plt.show()

def treinar_modelo(data):
    global modelo, X_train_columns

    X = data.drop("Preco ($)", axis=1)
    y = data["Preco ($)"]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    modelo = LinearRegression()
    modelo.fit(X_train, y_train)

    X_train_columns = X_train.columns

    y_pred = modelo.predict(X_test)
    print("Avaliação do modelo:")
    print(f"Mean Absolute Error (MAE): {mean_absolute_error(y_test, y_pred):.2f}")
    print(f"Mean Squared Error (MSE): {mean_squared_error(y_test, y_pred):.2f}")
    print(f"R² Score: {r2_score(y_test, y_pred):.2f}")

def predict_price():
    global modelo, X_train_columns

    location = input("Enter the location: ")
    size = float(input("Enter the size of the property (in m²): "))
    bedrooms = int(input("Enter the number of bedrooms: "))
    age = int(input("Enter the age of the property (in years): "))

    new_data = pd.DataFrame({'Tamanho (m²)': [size], 'Quartos': [bedrooms], 'Idade (Anos)': [age]})

    location_encoded = pd.get_dummies(pd.Series([location]), prefix='Localizacao')

    new_data = pd.concat([new_data, location_encoded], axis=1)
    new_data = new_data.reindex(columns=X_train_columns, fill_value=0)

    predicted_price = modelo.predict(new_data)
    print(f"The predicted price is: ${predicted_price[0]:,.2f}")

data = carregar()
visualizar(data)
coluna_atual(data)
verificar_nulos(data)
data = renomear_colunas(data)
data = criar_dummies(data, "Localizacao")
calcular_correlacao(data)

treinar_modelo(data)

predict_price()
