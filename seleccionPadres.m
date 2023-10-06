% 29 - septiembre - 2023
% Valeria Jahzeel Castañon Hernandez
% Prorgama que escoge padres mediante el metodo de la ruleta

% se definen las variables
poblacion = 10;
variables = 2;
ls = [1,1];
li = [-1,-1];
press = [3,3];

valores_reales = zeros(poblacion, variables);
num_bits_totales = 0;


% ******************************************************************************
% -------------------- PARTE 1 / GENERACION DE LOS INDIVIDUOS ------------------
% ******************************************************************************

% Calcular el número total de bits necesarios
for j = 1:variables
    Nb = ceil(log((ls(j) - li(j)) * 10^press(j)) + 0.9); % calcula Nb con la formula
    bits = (2^Nb) - 1;    % arreglo de bits
    num_bits_totales = num_bits_totales + Nb;
end

matriz = zeros(poblacion, num_bits_totales);

columna_actual = 1; % para saber en donde termina cada variable
for j = 1:variables
    Nb = ceil(log((ls(j) - li(j)) * 10^press(j)) + 0.9); % calcula Nb con la formula

    for i = 1:poblacion
        binario = randi([0, 1], 1, Nb); % obtiene el binario aleatoriamente
        matriz(i, columna_actual:columna_actual + Nb - 1) = binario;  % almacenar el binario en la matriz
        decimal = binarioDecimal(binario);  % pasa de binario a decimal
        real = li(j) + (decimal / ((2^Nb) - 1)) * (ls(j) - li(j)); % valor real en base a lo anterior
        valores_reales(i, j) = real;
    end
    columna_actual = columna_actual + Nb; % avanzar a la siguiente columna en la matriz
end

% suma_individuo = zeros(poblacion, 1);  % para almacenar las sumas
%     
% for i = 1:poblacion
%     for j = 1:variables
%        suma_individuo(i) = suma_individuo(i) + valores_reales(i, j)^2;
%     end
% end

% Imprimir la matriz de valores reales
fprintf("Matriz de valores reales:\n");
disp(valores_reales);

% Imprimir la matriz de arreglos binarios
fprintf("Matriz de arreglos binarios:\n");
disp(matriz);

% Imprimir el número total de bits utilizados
% fprintf("Número total de bits utilizados: %d\n", num_bits_totales);

%Imprimir la suma de cuadrados de cada individuo
% fprintf("Suma de cuadrados de cada individuo:\n");
% disp(suma_individuo);

% final = cat(2,valores_reales, suma_individuo);
% fprintf("Nueva matriz generada: \n");
% disp(final);

fprintf("-------------------------------------------------------------")


% ***********************************************************************
% -------------------- PARTE 2 / SELECCION DE PADRES --------------------
% ***********************************************************************

% separa las columnas (variables) de los valores reales
x = valores_reales(:, 1);
y = valores_reales(:, 2);
% x =1;
% y = 1;

% funcion objetivo
fx = 3 * (1 - x).^2 .* exp(-x.^2 - (y + 1).^2) + 10 * (x / 5 - x.^3 - y.^5) .* exp(-x.^2 - y.^2) - 1/3 * exp(-((x + 1).^2) - y.^2);

% Imprime los resultados de la funcion objetivo evaluada en los valores
% reales
% fprintf('Funcion objetivo: ');
% disp(fx);


% ------------- METODO DE LA RULETA -----------
% 1. Calcular el acumulado de la funcion objetivo acumulado=sumatoria(fx)
acumulado = sum(fx);

% fprintf("Acumulado de fx: ");
% disp(acumulado);

% ¿se requieren ngeativos?
%  pi2 = negativosPositivos(fx); 

% 2. Calcular la posibilidad de seleccion de cada individuo
pii = fx/acumulado;

% fprintf("Posibilidad de seleccion: ");
% disp(pii);

% 3. Calcular la probabilidad acumulada de cada individuo
qi =zeros(length(pii),1);
qi(1) = pii(1) ;

for i = 2:length(pii)
    qi(i) = qi(i - 1) + pii(i);
end

% fprintf("Probabilidad acumulada: ");
% disp(qi);


% 4. Determinar los padres mediante el método de la ruleta
padres = 6;  % número de padres que se quiere seleccionar 
elegidos = zeros(padres, 1);  % arreglo con los indices de los padres
i = 1;  % Inicializar i en 1
matPadres = zeros(padres,num_bits_totales);

while i <= padres
    nuevo_padre = elegirPadre(qi);
    
    % verificar si ya se seleccionó
    if ~ismember(nuevo_padre, elegidos)
        elegidos(i) = nuevo_padre;
        i = i + 1;  % se aumenta cuando se añade un padre
    end
end

% fprintf("Padres seleccionados:");
% disp(elegidos);

% se muestran los padres elegidos
for i = 1:padres
    indice = elegidos(i);
    valor_q = qi(indice);
    fprintf('I: %d, Q: %.3f\n', indice, valor_q);
    matPadres(i,:) = matriz(indice,:);
end

disp(matPadres);
