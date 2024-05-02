clear all;
clc;

%Constants
a = 6e-7;%m^2/s
dt = 2;%s
dx = 2e-3;%m
F = a*dt/dx^2;
Ti = 100;%Arbitrary Value
T5 = 50;%Arbitrary Value,Same as Ts,r
Tf = (Ti+T5)/2;%Target Temperature of node 0
tolerance = 0.1;

X = [Ti;Ti;Ti;Ti;Ti];%Initial temperature of nodes T[m,0], m = 0-4

for i = 1:100
    TDistribution_a(:,i) = X; %Temperature distribution of nodes T[m,0], m = 0-4
    A = [              
        1+2*F -2*F 0 0 0;
        -F 1+2*F -F 0 0;
        0 -F 1+2*F -F 0;
        0 0 -F 1+2*F -F;
        0 0 0 -F 1+2*F;
        ];%Matrix obtained after substituting values in equations given in the proposal

    B = X +[0;0;0;0;F*T5];

    X = A \B;
    if abs(TDistribution_a(1,i)-Tf) <= tolerance
        break;
    end
end


T_50percent = (i-1)*dt;
fprintf('(a)Time taken for a temperature reduction of 50%% = %ds\n',T_50percent);

plot(0:dt:(i-1)*dt,TDistribution_a(1,:),LineWidth=2)
xlabel('Time(s)')
ylabel('Temperature')
title('Temperature variation of left face')
grid on;


Tf = 0.8*Ti+0.2*T5;
T5 = Ti;
X = TDistribution_a(:,i);

for i = 1:100
    TDistribution_b(:,i) = X;
    A = [
        1+2*F -2*F 0 0 0;
        -F 1+2*F -F 0 0;
        0 -F 1+2*F -F 0;
        0 0 -F 1+2*F -F;
        0 0 0 -F 1+2*F;
        ];

    B = X +[0;0;0;0;F*T5];

    X = A \B;
    if abs(TDistribution_b(1,i)-Tf) <= tolerance
        break;
    end
end

fprintf('(b)Further time taken to recover to initial 20%% reduction = %ds\n',(i-1)*dt);

hold on;
plot(0+T_50percent:dt:T_50percent+(i-1)*dt,TDistribution_b(1,:),LineWidth=2)
legend('Part(a)','Part(b)')
hold off;

print('MM218_project','-dpng')
