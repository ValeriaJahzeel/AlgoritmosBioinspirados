% 22 - septiembre - 2023
% Valeria Jahzeel Castañon Hernandez
% Prorgama que genera numeros aleatorios utilizando el algoritmo XORshift


%semilla = enteroBinario(200); % Pasa la semilla a binario, lo maximo es 256

% el numero mas grande que puede tomar es 256 ya que solo son 8 bits
num1 = enteroBinario(130);  
num2 = enteroBinario(255);

disp(num1)
disp(num2)
valor = XOR(num1,num2);
disp(valor)    
% Valores a generar
N = 7;
    
% Vector para almacenar los números aleatorios
aleatorio = zeros(1, N);

for i = 1:N
    % Aplica el algoritmo XORshift 
    valor = XOR(moverDerecha(valor, 2), valor);
    % Convierte valor a decinal y guarda el aleatorio
    aleatorio(i) = binarioDecimal(valor);
end

disp(aleatorio) % numeros decimales generados


function res = XOR(bit1, bit2)
    res = zeros(1,8);
    if length(bit1) == 8 && length(bit2)==8
        bit1 = abs(bit1);  % para evitar tener numeros negativos 
        bit2 = abs(bit2);
        %res = bitxor(bit1, bit2);   % ocupa la operacion xor en los bits
    else
        disp("error, la cadena debe ser de 8 numeros")
    end

    for i = 1:length(bit1)  % realiza las operaciones xor
        if(bit1(i)==1 && bit2(i)==0) || (bit1(i)==0 && bit2(i)==1)
           res(i) = 1;
        else
           res(i) = 0;
        end
    end
end
    
    
function derecha = moverDerecha(bits,cant)    
   derecha = zeros(1,8);    % para que mantenga los 8 bits
    
    for i = 1:abs(cant)
        if cant > 0
            for J = 2:8 % desplaza a la derecha
                derecha(J) = bits(J - 1);
            end        
        else
            for J = 1:7 % desplaza a la izqiuerda
                derecha(J) = bits(J + 1);
            end
        end
    end
end
    
function binario = enteroBinario(entero)
    %binario = [];
    binario = zeros(1, 8); % Inicializa un arreglo de 8 ceros

    for i = 8:-1:1 % Recorre los 8 bits de derecha a izquierda
        aux = mod(entero, 2); % Obtiene el módulo
        binario(i) = aux; % Asigna el dígito al elemento correspondiente
        entero = floor(entero / 2); % Mueve el número a la derecha
    end
end

function decimal = binarioDecimal(binario)
    decimal = 0;
    for i = 1:length(binario)
        decimal = decimal + binario(i) * 2^(length(binario)-i);
    end 
end
