% 22 - septiembre - 2023
% Valeria Jahzeel Castañon Hernandez
% Prorgama que genera una poblacion binaria aleatoria

clc();  % para limpiar la consola

poblacion = 5;
variables = 3;
ls = [10,100,1];
li = [0,-100,-1];
press = [3,10,2];

% poblacion = input("Dame el tamaño de la población (individuos): "); % no. de individuos
% variables = input("Dame el número de variables: "); % variables x individuo

valores_finales = zeros(poblacion, variables);
matriz = zeros(poblacion, variables);
num_bits_totales = 0;



for j = 1:variables    
    % ----------- CALCULOS ------------
    Nb = ceil(log((ls(j) - li(j)) * 10^press(j)) + 0.9); % calcula Nb con la formula
    bits = (2^Nb) - 1;    % numero total en un areglo de Nb bits
    num_bits_totales = num_bits_totales + Nb;

    for i = 1:poblacion
        binario = randi([0, 1], 1, Nb); % obtiene el binario aleatoriamente
        decimal = binarioDecimal(binario);  % pasa de binario a decimal
        matriz(i, 1:Nb) = binario;  % concatena los binarios
        real = li(j) + (decimal / bits) * (ls(j) - li(j)); % valor real en base a lo anterior
        valores_finales(i, j) = real;
    end
end

suma_individuo = zeros(poblacion, 1);  % para almacenar las sumas

for i = 1:poblacion
    for j = 1:variables
        suma_individuo(i) = suma_individuo(i) + valores_finales(i, j)^2;
    end
end

% Imprimir la matriz de valores finales
fprintf("Matriz de valores finales:\n");
disp(valores_finales);

% Imprimir la matriz de arreglos binarios
fprintf("Matriz de arreglos binarios:\n");
    disp(matriz);

% Imprimir la suma de cuadrados de cada individuo
% fprintf("Suma de cuadrados de cada individuo:\n");
% disp(suma_individuo);

final = cat(2,valores_finales, suma_individuo);
fprintf("Nueva matriz generada: \n");
disp(final);

% Imprimir el número total de bits utilizados
fprintf("Número total de bits utilizados: %d\n", num_bits_totales);


function decimal = binarioDecimal(binario)
    decimal = 0;
    for i = 1:length(binario)
        decimal = decimal + binario(i) * 2^(length(binario) - i);
    end 
end

