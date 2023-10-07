% 6 - octubre - 2023
% Valeria Jahzeel Castañon Hernandez
% Prorgama de un algoritmo genético finalizado

clc; % para limpiar la consola cada iteracion

% se definen las variables
poblacion = 20;
variables = 2;
ls = [3,3];
li = [-3,-3];
press = [3,3];
generaciones = 5;

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

 % Imprimir el número total de bits utilizados
 fprintf("Número total de bits utilizados: %d\n", num_bits_totales);
    
% --------------- EMPIEZAN LAS GENERACIONES --------------------
for g = 1:generaciones
    fprintf("Generacion: %d \n", g);
    disp(matriz);   % con los valores binarios


%     % Imprimir la matriz de valores reales
%     fprintf("Matriz de valores reales:\n");
%     disp(valores_reales);
%     
%     % Imprimir la matriz de arreglos binarios
%     fprintf("Matriz de arreglos binarios:\n");
%     disp(matriz);
    
   
    fprintf("-------------------------------------------------------------------------------------------------------------------------------------+\n")
    
    
    % ***********************************************************************
    % -------------------- PARTE 2 / SELECCION DE PADRES --------------------
    % ***********************************************************************


    % separa las columnas (variables) de los valores reales
    x = valores_reales(:, 1);
    y = valores_reales(:, 2);
    
    % funcion objetivo
    fx = 3 * (1 - x).^2 .* exp(-x.^2 - (y + 1).^2) + 10 * (x / 5 - x.^3 - y.^5) .* exp(-x.^2 - y.^2) - 1/3 * exp(-((x + 1).^2) - y.^2);
    
    % Imprime los resultados de la funcion objetivo evaluada en los valores reales
    % fprintf('Funcion objetivo: ');
    % disp(fx);
    
    % ¿se requieren ngeativos?
    qi = metodoRuleta(fx); 
    
    
    % continuacion del metodo de la ruleta .....
    % 4. Determinar los padres mediante el método de la ruleta
    padres = poblacion/2;  % número de padres que se quiere seleccionar 
    elegidos = zeros(padres, 1);  % arreglo con los indices de los padres
    i = 1;  % Inicializar i en 1
    
    while i <= padres
        nuevo_padre = elegirPadre(qi);
        
        % verificar si ya se seleccionó
        if ~ismember(nuevo_padre, elegidos)
            elegidos(i) = nuevo_padre;  % se guarda la posicion del padre
            i = i + 1;  % se aumenta cuando se añade un padre
        end
    end
    
    % ************************************************************************
    % ------------------------- PARTE 3 / CRUZA ------------------------------
    % ************************************************************************
    hijos = zeros(poblacion, num_bits_totales);
    matPadres = zeros(padres,2);

    for i = 1:2:padres
        % elige los padres aleatoriamente
        indices = randi([1,padres],2,1);    % elige 2 indices para los padres
        if indices(1) == indices(2)
            indices = randi([1,padres],2,1);    % elige 2 indices para los padres
        elseif indices(1) ~= indices(2) 
            padre1 = elegidos(indices(1));
            padre2 = elegidos(indices(2));
            matPadres(i,:) = [indices(1), indices(2)];   % guarda los indices en la matriz
        end      
        
        if ~ismember(indices(1), matPadres(:,1)) && ~ismember(indices(2), matPadres(:,2))   % para que no se repitan los padres
            punto_cruza = randi([1, num_bits_totales - 1]); % calcula aleatoriamente el punto de cruza
    
            hijo1 = [matriz(padre1, 1:punto_cruza), matriz(padre2, punto_cruza + 1:end)];
            hijo2 = [matriz(padre2, 1:punto_cruza), matriz(padre1, punto_cruza + 1:end)];
            
            hijos(i, :) = hijo1; 
            hijos(i + 1, :) = hijo2;
        end
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
            if rand < probabilidad_mutacion % si el valor es menor a la probabilidad
                if matriz(i,j) == 0 % muta a los hijos
                    matriz(i,j) = 1;
                else
                    matriz(i,j) = 0;
                end
            end
        end
    end
    
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
function qi = metodoRuleta(fx)
 % ------------- METODO DE LA RULETA -----------
 % 0. Aplicar la formula de normalizacion
    positivos = abs(fx/(min(fx+1)));

% 1. Calcular el acumulado de la funcion objetivo acumulado=sumatoria(fx)
    acumulado = sum(positivos);

% 2. Calcular la posibilidad de seleccion de cada individuo
    pii = positivos/acumulado;

% 3. Calcular la probabilidad acumulada de cada individuo
    qi =zeros(length(pii),1);
    qi(1) = pii(1) ;
    for i = 2:length(pii)
        qi(i) = qi(i - 1) + pii(i);
    end

% sigue en la parte principal ....
end


