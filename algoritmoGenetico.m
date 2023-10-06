clc; % para limpiar la consola cada iteracion

% se definen las variables
poblacion = 10;
variables = 2;
ls = [1,1];
li = [-1,-1];
press = [3,3];
generaciones = 3;

% ******************************************************************************
% -------------------- PARTE 1 / GENERACION DE LOS INDIVIDUOS ------------------
% ******************************************************************************
valores_reales = zeros(poblacion, variables);
num_bits_totales = calculoBits(li,ls,press);
matriz = zeros(poblacion, num_bits_totales);

% calcula la matriz de la primera generacion
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

for g = 1:generaciones
    fprintf("Generacion: %d \n", g);



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
        disp(matPadres(i,:));
    end
    
    
    
    % ************************************************************************
    % ------------------------- PARTE 3 / CRUZA ------------------------------
    % ************************************************************************
    hijos = zeros(poblacion, num_bits_totales);
    
    
    for i = 1:2:padres
        % elige los padres aleatoriamente
        indices = randi([1,padres],2,1);    % elige 2 indices para los padres
        if(indices(1) == indices(2))
            indices = randi([1,padres],2,1);    % elige 2 indices para los padres
        else
            padre1 = elegidos(indices(1));
            padre2 = elegidos(indices(2));
        end
    
        
    
        punto_cruza = randi([1, num_bits_totales - 1]);
        
        fprintf("Punto de cruza \n")
        disp(punto_cruza)
        
        fprintf("Matriz del padre 1 y del padre 2 \n")
        disp(matriz(padre1,:));
        disp(matriz(padre2,:));

        hijo1 = [matriz(padre1, 1:punto_cruza), matriz(padre2, punto_cruza + 1:end)];
        hijo2 = [matriz(padre2, 1:punto_cruza), matriz(padre1, punto_cruza + 1:end)];
        
        hijos(i, :) = hijo1; 
        hijos(i + 1, :) = hijo2;
      
    end
    
    % ahora la matriz corresponde a la nueva generacion
    matriz = hijos;
    %     disp(matriz)
    
    % **************************************************************************
    % ------------------------- PARTE 3 / MUTACION -----------------------------
    % **************************************************************************
    probabilidad_mutacion = 0.1;  % Define la probabilidad de mutación
    
    for i = 1:poblacion
        for j = 1:num_bits_totales
            if rand < probabilidad_mutacion
                if matriz(i,j) == 0
                    matriz(i,j) = 1;
                else
                    matriz(i,j) = 0;
                end
            end
        end
    end
    
    % La poblacion final final
    disp(matriz);

    valores_reales = calcularValoresReales(matriz,li,ls,press, valores_reales);
end





% ************************************************************************
% -------------------------- FUNCIONES EXTRAS-----------------------------
% ************************************************************************
% para saber los bits totales
function bitsTotales = calculoBits(li, ls, press)
    bitsTotales = 0;  % Inicializa bitsTotales en 0
    for j = 1:length(li)
        Nb = ceil(log((ls(j) - li(j)) * 10^press(j)) + 0.9);
        bitsTotales = bitsTotales + Nb;
    end
end

function valores_reales = calcularValoresReales(matriz, li, ls, press, valores_reales)
    bits = calculoBits(li,ls,press);
    [poblacion, bits] = size(matriz);
    variables = length(li);

    columna_actual = 1;

    for j = 1:variables
        Nb = ceil(log((ls(j) - li(j)) * 10^press(j)) + 0.9);

        for i = 1:poblacion
            binario = matriz(i, columna_actual:columna_actual + Nb - 1);
            decimal = binarioDecimal(binario);
            real = li(j) + (decimal / ((2^Nb) - 1)) * (ls(j) - li(j));
            valores_reales(i, j) = real;
        end

        columna_actual = columna_actual + Nb;
    end
end





function indice = elegirPadre(qi)
    r = rand;  % valor de aptitud
    for j = 1:length(qi)
        if qi(j) >= r
            indice = j;
            return;  % Sale de la función cuando se elija un padre
        end
    end
end

function decimal = binarioDecimal(binario)
    decimal = 0;
    for i = 1:length(binario)
        decimal = decimal + binario(i) * 2^(length(binario) - i);
    end 
end

% por si no se quieren negativos
function positivos = negativosPositivos(fx)
    fprintf("****************************");
    positivos = abs(fx/(min(fx+1)));
    fprintf("Valores de fx positivos: ");
    disp(positivos);
    acumulado = sum(positivos);
    fprintf("Acumulado de fx: ");
    disp(acumulado);
    pii = positivos/acumulado;
    fprintf("Posibilidad de seleccion ");
    disp(pii);
    qi =zeros(length(pii),1);
    qi(1) = pii(1) ;
    for i = 2:length(pii)
        qi(i) = qi(i - 1) + pii(i);
    end
    fprintf("Probabilidad acumulada: ");
    disp(qi);
    fprintf("****************************");
end


