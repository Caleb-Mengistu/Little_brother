clearvars;
close all;

% Declare length and angle arrays
constLen = [24.0, 20.0, 38.0, 25.0, 95.0, 122.7];
varLen = [0.0, 0.0];

constAng = [135];
varAng = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

% linkLen = [24, 20, 38, 25, 95, 95, 120.0, 25, NaN, NaN, NaN]; % [24, 20, 35, 25, 95, 115, 154.3, 20, NaN, NaN, NaN];
% linkAng = [NaN, NaN, NaN, 0.0, NaN, NaN, NaN, NaN, NaN, 135.74, NaN, NaN]; % [NaN, NaN, NaN, 0.0, NaN, NaN, NaN, NaN, NaN, 95.74, NaN, NaN];

motor2 = [-20, -20];

footPosition = [10, -160];

function [length] = getLength(xArr, yArr)
    length = 0;
    % length = (yArr(2) - yArr(1))/(xArr(2) - xArr(1));
end


function [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition)
    
    linkX = [];
    linkY = [];

    % General Calculations

    varLen(1) = sqrt(footPosition(1)^2 + footPosition(2)^2);
    varAng(1) = atand(abs(footPosition(2))/abs(footPosition(1)));
    if footPosition(1) > 0
        varAng(1) = 180-varAng(1);
    end
    varAng(2) = acosd((constLen(5)^2 - constLen(6)^2 - varLen(1)^2)/(-2*constLen(6)*varLen(1)));
    varAng(3) = varAng(1) - varAng(2);
    varAng(4) = 180 - constAng(1) - varAng(3);
    
    x2 = -constLen(3)*cosd(varAng(4)) - motor2(1);
    y2 = constLen(3)*sind(varAng(4)) - motor2(2);
   
    varLen(2) = sqrt(x2^2+y2^2);
    varAng(5) = atand(abs(y2)/abs(x2));
    varAng(6) = acosd((constLen(2)^2 - varLen(2)^2 - constLen(1)^2)/(-2*constLen(1)*varLen(2)));
    varAng(7) = varAng(5) - varAng(6);

    if isreal(varAng(3))
        M1Angle = atan2d(footPosition(2)+constLen(6)*sind(varAng(3)), footPosition(1)+constLen(6)*cosd(varAng(3)));
    else
        linkX = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
        linkY = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
        return
    end
    disp(varAng(4))
    
    if M1Angle > -10 || M1Angle < -120 || varAng(4) < -20
        linkX = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
        linkY = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
        return
    end

    % motor1Angle = atand(abs(footPosition(2)+constLen(6)*sind(varAng(3)))/abs(footPosition(1)+constLen(5)*cosd(varAng(3))));

    % linkLen(9) = sqrt(footPosition(1)^2 + footPosition(2)^2);
    % 
    % linkAng(5) = acosd((linkLen(9)^2 - linkLen(5)^2 - linkLen(7)^2)/(-2*linkLen(5)*linkLen(7)));
    % 
    % linkAng(7) = asind((linkLen(7)/linkLen(9))*sind(linkAng(5)));
    % 
    % linkAng(8) = atand(footPosition(1)/footPosition(2));
    % 
    % linkAng(1) = 90 - linkAng(7) + linkAng(8);
    % 
    % linkAng(3) = linkAng(5) - linkAng(1) - linkAng(4);
    % 
    % x1 = linkLen(5)*cosd(linkAng(1)) + linkLen(8)*cosd(linkAng(3));
    % y1 = -linkLen(5)*sind(linkAng(1)) + linkLen(8)*sind(linkAng(3));
    % 
    % linkLen(10) = sqrt(x1^2 + y1^2);
    % 
    % linkAng(9) = atand(abs(y1/x1));
    % 
    % temp = acosd((linkLen(6)^2 - linkLen(4)^2 - linkLen(10)^2)/(-2*linkLen(4)*linkLen(10)));
    % 
    % linkAng(2) = 90 - acosd((linkLen(6)^2 - linkLen(4)^2 - linkLen(10)^2)/(-2*linkLen(4)*linkLen(10))) + linkAng(9);
    % linkAng(11) = linkAng(10) - linkAng(2);
    % 
    % x2 = -linkLen(3) * sind(linkAng(11)) - motor2(1);
    % y2 =  linkLen(3) * cosd(linkAng(11)) - motor2(2);
    % 
    % fprintf("X: %f, Y: %f\n", x2, y2);
    % 
    % linkLen(11) = sqrt(x2^2 + y2^2);
    % 
    % linkAng(12) = acosd((linkLen(2)^2 - linkLen(1)^2 - linkLen(11)^2)/(-2*linkLen(1)*linkLen(11)));
    % 
    % linkAng(13) = atand(abs(y2/x2));
    % 
    % linkAng(6) = linkAng(13) - linkAng(12);
    
    % Link 1 Calculations
    linkX(1, :) = [motor2(1), motor2(1) - constLen(1) * cosd(varAng(7))];
    linkY(1, :) = [motor2(2), motor2(2) + constLen(1) * sind(varAng(7))];
    
    % disp("L1");
    % disp(getLength(linkX(1, :), linkY(1, :)));
    
    % Link 3 Calculations
    linkX(3, :) = [0, -constLen(3) * cosd(varAng(4))];
    linkY(3, :) = [0, constLen(3) * sind(varAng(4))];
    
    % disp("L3");
    % disp(getLength(linkX(3, :), linkY(3, :)));

    % Link 2 Calculations
    linkX(2, :) = [linkX(1, 2), linkX(3, 2)];
    linkY(2, :) = [linkY(1, 2), linkY(3, 2)];

    % disp("L2");
    % disp(getLength(linkX(:, 2), linkY(:, 2)));

    % Link 4 Calculations
    linkX(4, :) = [0, constLen(4) * cosd(varAng(3))];
    linkY(4, :) = [0, constLen(4) * sind(varAng(3))];

    % disp("L4");
    % disp(getLength(linkX(:, 4), linkY(:, 4)));

    % Link 5 Calculations
    linkX(5, :) = [0, footPosition(1) + constLen(6) * cosd(varAng(3))];
    linkY(5, :) = [0, footPosition(2) + constLen(6) * sind(varAng(3))];

    % disp("L5");
    % disp(getLength(linkX(:, 5), linkY(:, 5)));

    % Link 8 Calculations
    linkX(8, :) = [linkX(5, 2), linkX(5, 2) + constLen(4) * cosd(varAng(3))];
    linkY(8, :) = [linkY(5, 2), linkY(5, 2) + constLen(4) * sind(varAng(3))];

    % disp("L8");
    % disp(getLength(linkX(:, 8), linkY(:, 8)));

    % Link 7 Calculations
    linkX(7, :) = [footPosition(1), linkX(5, 2)];
    linkY(7, :) = [footPosition(2), linkY(5, 2)];

    % disp("L7");
    % disp(getLength(linkX(:, 7), linkY(:, 7)));

    % Link 6 Calculations
    linkX(6, :) = [linkX(4, 2), linkX(8, 2)];
    linkY(6, :) = [linkY(4, 2), linkY(8, 2)];

    % disp("L6");
    % disp(getLength(linkX(6, :), linkY(6, :))); 
end

[linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);

figure;

lines = [];

lines(1) = line(linkX(1, :), linkY(1, :), 'LineWidth', 2);
hold on;
lines(2) = line(linkX(2, :), linkY(2, :), 'LineWidth', 2);
hold on;
lines(3) = line(linkX(3, :), linkY(3, :), 'LineWidth', 2);
hold on;
lines(4) = line(linkX(4, :), linkY(4, :), 'LineWidth', 2);
hold on;
plot(0, 0, 'o', 'MarkerSize', 30, 'LineWidth', 2, 'Color', "#000000", 'MarkerFaceColor', "#FFFFFF");
hold on;
lines(5) = line(linkX(5, :), linkY(5, :), 'LineWidth', 2);
hold on;
plot(0, 0, 'o', 'MarkerSize', 15, 'LineWidth', 2, 'Color', "#000000", 'MarkerFaceColor', "#FFFFFF");
hold on;
lines(6) = line(linkX(6, :), linkY(6, :), 'LineWidth', 2);
hold on;
lines(7) = line(linkX(7, :), linkY(7, :), 'LineWidth', 2);
hold on;
lines(8) = line(linkX(8, :), linkY(8, :), 'LineWidth', 2);
hold on;
plot(-20, -20, 'o', 'MarkerSize', 15, 'LineWidth', 2, 'Color', "#000000", 'MarkerFaceColor', "#FFFFFF");
% legend('L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8');

title("Leg Linkages")
xlabel("X Position")
ylabel("Y Position")

axis equal

ylim([-240 40]);
xlim([-180 180]);

footPosition = [10, -160];
[linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);

% for lineIndex = 1:size(lines, 2)
%     set(lines(lineIndex), 'XData', linkX(lineIndex, :));
%     set(lines(lineIndex), 'YData', linkY(lineIndex, :));
% end
drawnow; 

xArr = zeros(1, 1100);
yArr = zeros(1, 1100);

index = 1;

for x = -180:2:180
    for y = -240:2:-40
        footPosition = [x, y];

        [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);
        if isreal(linkX) && isreal(linkY) && ~anynan(linkX) && ~anynan(linkY)
            plot(x, y, '*', 'MarkerSize', 1, 'LineWidth', 2, 'Color', "#00FF00", 'MarkerFaceColor', "#00FF00");
            hold on;
            % 
            xArr(index) = x;
            yArr(index) = y;
            index = index + 1;
            % for lineIndex = 1:size(lines, 2)
            %     set(lines(lineIndex), 'XData', linkX(lineIndex, :));
            %     set(lines(lineIndex), 'YData', linkY(lineIndex, :));
            % end
            % pause(0.1);
            
        end
    end
end

drawnow; 



T = table(transpose(xArr), transpose(yArr));

writetable(T,'myData.txt','Delimiter',',')  
type 'myData.txt'

% for z = 0:4
% 
%     t = linspace(0, 1, 25);
% 
%     P = [
%         30 -10;
%         60 -9;
%         75 27;
%         -65 68;
%         -35 -16;
%         -10 -10;
%     ];
% 
%     P2 = [
%        -10 -10
%        30 -10
%     ]
% 
%     % Make t a column vector
%     t = t(:);
% 
%     % Bernstein basis polynomials for n = 5
%     B0 = (1 - t).^5;
%     B1 = 5 * (1 - t).^4 .* t;
%     B2 = 10 * (1 - t).^3 .* t.^2;
%     B3 = 10 * (1 - t).^2 .* t.^3;
%     B4 = 5 * (1 - t)    .* t.^4;
%     B5 = t.^5;
% 
%     B10 = (1-t);
%     B11 = t;
% 
%     % B0 = (1 - t).^7;
%     % B1 = 7 * (1 - t).^6 .* t;
%     % B2 = 21 * (1 - t).^5 .* t.^2;
%     % B3 = 35 * (1 - t).^4 .* t.^3;
%     % B4 = 35 * (1 - t).^3 .* t.^4;
%     % B5 = 21 * (1 - t).^2 .* t.^5;
%     % B6 = 7 * (1 - t).^1 .* t.^6;
%     % B7 = (t).^7;
% 
% 
%     % Combine into one matrix
%     basis = [B0 B1 B2 B3 B4 B5];
% 
%     basis2 = [B10 B11];
% 
%     % Compute curve points
%     B = basis * P;
% 
%     B2 = basis2 * P2;
% 
%     for row = 1:25
%         x = B(row, 1) - 20;
%         y = B(row, 2) - 145;
% 
%         footPosition = [x, y];
% 
%         [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);
%         for lineIndex = 1:size(lines, 2)
%             set(lines(lineIndex), 'XData', linkX(lineIndex, :));
%             set(lines(lineIndex), 'YData', linkY(lineIndex, :));
%         end
%         pause(0.02);
%         drawnow;
%     end
% 
%     for row = 1:25
%         x = B2(row, 1) - 20;
%         y = B2(row, 2) - 145;
% 
%         footPosition = [x, y];
% 
%         [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);
%         for lineIndex = 1:size(lines, 2)
%             set(lines(lineIndex), 'XData', linkX(lineIndex, :));
%             set(lines(lineIndex), 'YData', linkY(lineIndex, :));
%         end
%         pause(0.04);
%         drawnow;
%     end
% 
% 
%     % for t = linspace(-15, 70, 30)
%     %     %footPosition = [-t, -0.025*(-t+70)^2-130];
%     %     footPosition = [-t, -0.0221*(t-27.5)^2-120]; %-116.6
%     %     [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);
%     % 
%     %     for lineIndex = 1:size(lines, 2)
%     %         set(lines(lineIndex), 'XData', linkX(lineIndex, :));
%     %         set(lines(lineIndex), 'YData', linkY(lineIndex, :));
%     %     end
%     %     pause(0.02);
%     %     drawnow;
%     % end
%     % 
%     % for x = linspace(-48-20, 18-20, 25)
%     %     footPosition = [x, -145];
%     %     [linkX, linkY] = generatePositions(constLen, varLen, constAng, varAng, motor2, footPosition);
%     % 
%     %     for lineIndex = 1:size(lines, 2)
%     %         set(lines(lineIndex), 'XData', linkX(lineIndex, :));
%     %         set(lines(lineIndex), 'YData', linkY(lineIndex, :));
%     %     end
%     %     pause(0.02);
%     %     drawnow;
%     % end
% end


% waitforbuttonpress;
% 
% set(L8Line, 'YData', [-200, -400]);
% 


% Inequalities
% 10400 >= (x+56)^2+(y+102)^2
% 8500 <= (x+120)+(y+21)^2
% 13400 <= 1.8(x-58)^2+(y+12)^2