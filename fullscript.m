%CREATE A
[row col] = size(C);
Ax = zeros(row, col);
Ay = zeros(row, col);
materiallength = 0;
M = col;
j = row;
trusslengths = zeros(M,1);
for i = 1:col
    index = find(C(:,i) == true); %Storing which joints are connected to member
    numerator = [X(index(2))-X(index(1)) Y(index(2))-Y(index(1))]; %distance components
    r = sqrt(sum(numerator.^2)); %total distance
    Ax(index(1),i) = numerator(1)/r;
    Ax(index(2),i) = -numerator(1)/r;
    Ay(index(1),i) = numerator(2)/r;
    Ay(index(2),i) = -numerator(2)/r;
    materiallength = materiallength + r;
    trusslengths(i) = r;
end
A = [Ax, Sx; Ay, Sy];
T = inv(A)*L;
indices = find(abs(T) < .00001);
T(indices) = 0;

%OUTPUT
costjoint = 10;
costinch = 1;
cost = costjoint*j + costinch*materiallength;
pcrit = 2242*trusslengths.^-1.868;
SR = -T(1:end-3)./pcrit;
maxload = 1/max(SR);
fprintf('EK301, Section A2, GRizzly Khanstruction Co.: Gavin Rosen, Rizwan Sardar, Aaron Khan, 10/30/20\n');
fprintf('Load: %.2f\n', m)
fprintf('Member %d will fail at a load of %.3f oz\n', find(SR == max(SR)), maxload);
fprintf('Member forces in ounces\n')
for i = 1:length(T)-3
    prefix = sprintf('m%s: ', int2str(i));
    if T(i) == 0
        fprintf('%s%.3f\n', prefix, abs(T(i)));
    elseif T(i) < 0
        fprintf('%s%.3f (C)\n', prefix, abs(T(i)));
    else
        fprintf('%s%.3f (T)\n', prefix, abs(T(i)));
    end
end
fprintf('Reaction forces in ounces:\n')
prefix = {'Sx1: ', 'Sy1: ', 'Sy2: '};
counter = 0;
for i = length(T)-2:length(T)
    counter = counter + 1;
    fprintf('%s%.3f\n', prefix{counter}, T(i));
end
fprintf('Cost of truss: $%.2f\n', cost);
fprintf('Theoretical max load/cost ratio in oz/$: %.4f\n', maxload/cost);

%TABLE AND FIGURE
for i = M:-1:1
    trusslength_string = sprintf("%.2f in",trusslengths(i));
    force_string = sprintf("%.2f oz %c 18.72 oz", abs(T(i)*maxload), char(177));
    if SR(i) <= 0
        SR(i) = 0;
        buckles = "N/A";
    else
        buckles = sprintf("%.2f %c 18.72 oz", 1/abs(SR(i)), char(177));
    end
    if T(i) < 0
        indicator = sprintf("C");
    elseif T(i) > 0
        indicator = sprintf("T");
    else
        indicator = sprintf("ZFM");
    end
    infotable(i) = struct("Member", i, "Length", trusslength_string,...
        "C_or_T", indicator, "Buckling_Strength", buckles, "Force_at_Max_Load", force_string);
end
letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',...
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}; %Did it all on my own
disp(struct2table(infotable)) %Made a struct just to make a table!
for i = 1:M
    index = find(C(:,i) == true);
    if find(SR == max(SR)) == i %If member is the same one that will fail
        linespecs = 'r-';
        textcolor = 'red';
        membernumber = sprintf('M %d FAILS', i);
    else
        linespecs = 'k-';
        textcolor = 'black';
        membernumber = sprintf('M %d', i);
    end
    figure(1)
    xpos = [X(index(2)) X(index(1))];
    ypos = [Y(index(2)) Y(index(1))];
    plot(xpos, ypos, linespecs, 'LineWidth', 2); %Plotting member
    text(mean(xpos)+.2, mean(ypos)+.35, membernumber, 'Color', textcolor, 'FontSize', 14); %Member labels made in loop while we have midpoints available
    hold on
end
text(X+.25,Y+.25,letters(1:j),'Color', 'blue', 'FontSize', 16); %Joint labels
axis('equal'); %Square up the axes to make figure to scale
quiver(X(find(L)-j), Y(find(L)-j), 0, -1, 8, 'k-'); %Add load arrow
text(X(find(L)-j)+1, Y(find(L)-j)-3, sprintf('Joint %c Loaded', letters{find(L)-j}), 'Color', 'black', 'FontSize', 14); %Text for load arrow
hold off    %Stop next plot from overlaying
%clear ypos xpos textcolor trusslength_string row r prefix numerator membernumber linespecs
%clear letters M m j indices index infotable indicator i force_string counter col buckles