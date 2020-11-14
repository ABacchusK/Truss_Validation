%Create C, store j and M
j = input('Enter number of joints: ');
M = input('Enter number of members: ');
C = false(j,M);
for i = 1:M
    str1 = sprintf('Enter first joint number for member %d: ', i);
    joint1 = input(str1);
    str2 = sprintf('Enter second joint number for member %d: ', i);
    joint2 = input(str2);
    C(joint1, i) = true;
    C(joint2, i) = true;
    fprintf('\n');
end

%Create Sx and Sy
joint1 = input('Which joint has an x and y reaction? ');
joint2 = input('Which joint has only a y reaction? ');
fprintf('\n');
Sx = false(j,3);
Sx(joint1,1) = true;
Sy = false(j,3);
Sy(joint1,2) = true;
Sy(joint2,3) = true;


%Create X and Y vectors
X = zeros(1,j);
Y = zeros(1,j);
for i = 1:j
    str1 = sprintf('Enter x component of position for joint (m or in) %d: ', i);
    X(i) = input(str1);
    str2 = sprintf('Enter y component of position for joint %d: ', i);
    Y(i) = input(str2);
    fprintf('\n');
end


jload = input('Which joint is being loaded? ');
m = input('What is the load (oz)? ');
L = zeros(2*j,1);
L(j + jload) = m;

clear str1 str2 joint1 joint2 jload i choice