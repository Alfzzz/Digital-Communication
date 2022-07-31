%Proyecto final de Comunicaciones Digitales
%%Alfredo Zhu, Juan Pablo Valverde, Luis Arturo Dan, Andrés Islas
clc
clear all
%% Teorema de muestreo pasabanda
clc 
clear all
fu=25;%frecuencia superior
fb=10;%Ancho de banda
k=floor(fu/fb);%número entero más grande si exceder fu/fb
%fs=25;%Frecuencia de muestreo
fs=45;%Frecuencia de muestreo
if(fs==(2*fu/k))
   display("Sí se puede recobrar la señal con la frecuencia de muestreo indicada y con un filtro pasabanda")
else
    display("No se puede recobrar la señal con la frecuencia de muestreo indicada y con un filtro pasabanda")
end
%% Cuantificación
clc
clear all
mp=1;%Amplitud pico
R=6;%número de bits por muestra(Resolución)
L=2^R;%número de niveles
delta=2*mp/L%Tamaño de paso
varianza=(mp^2)/(2^(2*R))/3
SNR_dB=1.8+6*R%Razón señal a ruido con carga de 1 ohm
SNR=10^(SNR_dB/10)
%% Cuantificación no lineal con ley de mu y ley de A
clc 
clear all
close all
entrada=0:0.01:1;%entrada normalizada
mu=5;
salida_mu=log10(1+mu.*entrada)/log10(1+mu)
plot(entrada,salida_mu)
xlabel("entrada normalizada")
ylabel("salida normalizada")
title("Ley mu")
A=100;
for i=1:length(entrada)
   if(entrada(i)<1/A)
       salida_A(i)=(A.*entrada(i))/(1+log10(A))
   else
       salida_A(i)=(1+log10(A*entrada(i)))./(1+log10(A))
   end
end
figure
plot(entrada,salida_A)
xlabel("entrada normalizada")
ylabel("salida normalizada")
title("Ley A")
%% BER de diferentes esquema de modulación 
A=10^-6;%Amplitud de la señal en V
N0=2*10^-20;%N0/2, ruido en W/Hz
R=2.5*10^6;%tasa de trasmisión en bps
T=1/R;%periodo
Eb=0.5*A^2/R
Pe_FSK_binaria_coherente=0.5*erfc(sqrt(Eb/(2*N0)))%FSK binaria coherente,ASK
Pe_MSK_coherente=0.5*erfc(sqrt(Eb/(N0)))%MSK coherente,QPSK coherente, PSK binaria coherente,QPSK
Pe_FSK_binaria_no_coherente=0.5*exp(-Eb/(2*N0))%FSK binaria no coherente
Pe_DPSK=0.5*exp(-Eb/N0)%DPSK
%% Curvas de desempeño de error de difernetes esquemas de modulación
%%Pe vs Eb/N0
clc
clear all
close all
Eb_N0_dB=0:0.1:12.5;%Rango de la razón señal a ruido Eb/N0
Eb_N0=10.^(Eb_N0_dB/10);%Razón señal a ruido en dB
Pe_coherent_BPSK=1/2.*erfc(sqrt(Eb_N0));%PSK binaria coherente
Pe_coherent_BFSK=1/2.*erfc(sqrt(Eb_N0/2));%FSK binaria coherente
Pe_QPSK=1/2.*erfc(sqrt(Eb_N0));%QPSK
Pe_MSK=1/2.*erfc(sqrt(Eb_N0));%MSK
Pe_DPSK=1/2.*exp(-Eb_N0);%DPSK
Pe_noncoherent_BFSK=1/2.*exp(-Eb_N0/2);%FSK binaria no coherente
semilogy(Eb_N0_dB,Pe_noncoherent_BFSK,Eb_N0_dB,Pe_coherent_BFSK,Eb_N0_dB,Pe_DPSK,Eb_N0_dB,Pe_coherent_BPSK,Eb_N0_dB,Pe_QPSK,Eb_N0_dB,Pe_MSK);
grid on
legend("Non coherent binary PSK","Coherent binary FSK","DPSK","","","Coherent binary PSK,QPSK,MSK")
ylabel("Probabilidad de error Pe");
xlabel("E_b/N_0 (dB)")
title("Comparación de diferentes esquemas de modulación Pe vs E_b/N_0 (dB)")
ylim([10^-4 1])%Establecer rango de la figura en y
%% Eficiencia de ancho de banda
clc
close all
clear all
Rb=2.5*10^6;%tasa de trasmisión en bps
Tb=5e-6;
B=1/(2*Tb);%Ancho de banda
rho=Rb/B
%% Secuencia de pseudo ruido con Flip Flops
m=4;%Numero de flip flops
modulo2_adder=[0,0,1,1];%posiciones de sumadores modulo 2 
shifter=[1,0,0,0]%Estado inicial
f1=1%inicialización de varible
for i=1:2^m
    disp(["#",i-1,",secuencia:",shifter])
    a=f1;
    f1=0;
    for j=1:length(shifter)
        if(modulo2_adder(j)==1)
            f1=xor(f1,shifter(j));%%Modulo XOR
        end
    end
    for j=0:length(shifter)-2
        shifter(length(shifter)-j)=shifter(length(shifter)-j-1);%%Recorrimiento
    end
    shifter(2)=a;%Recorrer el segundo
    shifter(1)=f1;%Recorrer el primero
end    
%% Margen de perturbación
clc
clear all
close all
Tb=4.095e-3;%duración de bit de información
Tc=1e-6;%duración del recorte del pseudo ruido
N=Tb/Tc;%Periodo o también conocido como gananca de procesamiento
PG=N%Ganancia de procesamiento
m=log2(N+1)%Longitud de registro de corrimiento
SNR=3.1;%
PJ_margenPerturbacion=10*log10(PG)-10*log10(SNR)
%% Entropia
clear all
clc
close all
probabilidades=[1/2 1/8 1/8 1/16 1/16 1/16 1/32 1/32];
L=[1 3 3 4 4 5 6 6]
H=sum(probabilidades.*log2(1./probabilidades))%bits por símbolo
L_bar=sum(probabilidades.*L)
Eficiencia=H/L_bar