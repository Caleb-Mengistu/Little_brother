clearvars;
close all;

linkX = [];
linkY = [];

linkLen = [24, 20, 35, 25, 95, 115, 154.3, 20, NaN, NaN, NaN];
linkAng = [NaN, NaN, NaN, 8.9, NaN, NaN, NaN, NaN, NaN, 95.74, NaN, NaN];

motor2 = [-20, -20];

footPosition = [-80, -120];

function [length] = getLength(x, y)
    length = sqrt((x(2) - x(1))^2 + (y(2)-y(1))^2);
end 

function [linkX, linkY] = generatePositions(linkLen, linkAng, motor2, footPosition)
    
    linkX = [];
    linkY = [];

    % General Calculations
    linkLen(9) = sqrt(footPosition(1)^2 + footPosition(2)^2);
    
    linkAng(5) = acosd((linkLen(9)^2 - linkLen(5)^2 - linkLen(7)^2)/(-2*linkLen(5)*linkLen(7)));
    
    linkAng(7) = asind((linkLen(7)/linkLen(9))*sind(linkAng(5)));
    
    linkAng(8) = atand(footPosition(1)/footPosition(2));
    
    linkAng(1) = 90 - linkAng(7) + linkAng(8);
    
    linkAng(3) = linkAng(5) - linkAng(1) - linkAng(4);
    
    x1 = linkLen(5)*cosd(linkAng(1)) + linkLen(8)*cosd(linkAng(3));
    y1 = -linkLen(5)*sind(linkAng(1)) + linkLen(8)*sind(linkAng(3));
    
    linkLen(10) = sqrt(x1^2 + y1^2);
    
    linkAng(9) = atand(abs(y1/x1));
    
    temp = acosd((linkLen(6)^2 - linkLen(4)^2 - linkLen(10)^2)/(-2*linkLen(4)*linkLen(10)));
    
    linkAng(2) = 90 - acosd((linkLen(6)^2 - linkLen(4)^2 - linkLen(10)^2)/(-2*linkLen(4)*linkLen(10))) + linkAng(9);
    
    linkAng(11) = linkAng(10) - linkAng(2);
    
    x2 = -linkLen(3) * sind(linkAng(11)) - motor2(1);
    y2 =  linkLen(3) * cosd(linkAng(11)) - motor2(2);
    
    linkLen(11) = sqrt(x2^2 + y2^2);
    
    linkAng(12) = acosd((linkLen(2)^2 - linkLen(1)^2 - linkLen(11)^2)/(-2*linkLen(1)*linkLen(11)));
    
    linkAng(13) = atand(abs(y2/x2));
    
    linkAng(6) = linkAng(13) - linkAng(12);
    
    % Link 1 Calculations
    linkX(1, :) = [motor2(1), motor2(1) - linkLen(1) * cosd(linkAng(6))];
    linkY(1, :) = [motor2(2), motor2(2) + linkLen(1) * sind(linkAng(6))];
    
    % disp("L1");
    % disp(getLength(linkX(:, 1), linkY(:, 1)));
    
    % Link 3 Calculations
    linkX(3, :) = [0, -linkLen(3) * sind(linkAng(11))];
    linkY(3, :) = [0, linkLen(3) * cosd(linkAng(11))];
    
    % disp("L3");
    % disp(getLength(linkX(:, 3), linkY(:, 3)));
    
    % Link 2 Calculations
    linkX(2, :) = [linkX(1, 2), linkX(3, 2)];
    linkY(2, :) = [linkY(1, 2), linkY(3, 2)];
    
    % disp("L2");
    % disp(getLength(linkX(:, 2), linkY(:, 2)));
    
    % Link 4 Calculations
    linkX(4, :) = [0, linkLen(4) * sind(linkAng(2))];
    linkY(4, :) = [0, linkLen(4) * cosd(linkAng(2))];
    
    % disp("L4");
    % disp(getLength(linkX(:, 4), linkY(:, 4)));
    
    % Link 5 Calculations
    linkX(5, :) = [0, linkLen(5) * cosd(linkAng(1))];
    linkY(5, :) = [0, -linkLen(5) * sind(linkAng(1))];
    
    % disp("L5");
    % disp(getLength(linkX(:, 5), linkY(:, 5)));
    
    % Link 8 Calculations
    linkX(8, :) = [linkX(5, 2), x1];
    linkY(8, :) = [linkY(5, 2), y1];
    
    % disp("L8");
    % disp(getLength(linkX(:, 8), linkY(:, 8)));
    
    % Link 7 Calculations
    linkX(7, :) = [linkX(5, 2), linkX(5, 2) - linkLen(7) * cosd(linkAng(3) + linkAng(4))];
    linkY(7, :) = [linkY(5, 2), linkY(5, 2) - linkLen(7) * sind(linkAng(3) + linkAng(4))];
    
    % disp("L7");
    % disp(getLength(linkX(:, 7), linkY(:, 7)));
    
    % Link 6 Calculations
    linkX(6, :) = [linkX(4, 2), linkX(8, 2)];
    linkY(6, :) = [linkY(4, 2), linkY(8, 2)];
    
    % disp("L6");
    % disp(getLength(linkX(6, :), linkY(6, :))); 
end

[linkX, linkY] = generatePositions(linkLen, linkAng, motor2, footPosition);

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
lines(5) = line(linkX(5, :), linkY(5, :), 'LineWidth', 2);
hold on;
lines(6) = line(linkX(6, :), linkY(6, :), 'LineWidth', 2);
hold on;
lines(7) = line(linkX(7, :), linkY(7, :), 'LineWidth', 2);
hold on;
lines(8) = line(linkX(8, :), linkY(8, :), 'LineWidth', 2);

legend('L1', 'L2', 'L3', 'L4', 'L5', 'L6', 'L7', 'L8');

axis equal

ylim([-160 40]);
xlim([-140 120]);

for x = linspace(footPosition(1), -10, 80)
    footPosition = [x, -120];
    [linkX, linkY] = generatePositions(linkLen, linkAng, motor2, footPosition);

    for lineIndex = 1:size(lines, 2)
        set(lines(lineIndex), 'XData', linkX(lineIndex, :));
        set(lines(lineIndex), 'YData', linkY(lineIndex, :));
    end
    pause(0.03);
    drawnow;
end

pause(1);

for x = linspace(-10, footPosition(1), 80)
    footPosition = [x, -120];
    [linkX, linkY] = generatePositions(linkLen, linkAng, motor2, footPosition);

    for lineIndex = 1:size(lines, 2)
        set(lines(lineIndex), 'XData', linkX(lineIndex, :));
        set(lines(lineIndex), 'YData', linkY(lineIndex, :));
    end
    pause(0.03);
    drawnow;
end


% waitforbuttonpress;
% 
% set(L8Line, 'YData', [-200, -400]);
% 