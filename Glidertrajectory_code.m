close all;

% Parameters
tspan   = [0 20];
Ds      = [0, 1, sqrt(8), 4];
colours = lines(numel(Ds));

% Initial conditions
theta0 = 0.5;
s0     = 1.3;
x0     = 0;
y0     = 0;
z0 = [theta0; s0; x0; y0];

% Figure
figure('Units','inches','Position',[1 1 7.0 3.8]);
tl = tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% Phase plane
ax1 = nexttile;
hold on; grid on;
xlim(ax1,[-2 2])
ylim(ax1,[0 2])

% x-y plane
ax2 = nexttile;
hold on; grid on;
xlim(ax2,[0 8])
ylim(ax2,[-3 1])

% Plot quadrati first, then linear second
for j = 1:numel(Ds)
    D = Ds(j);

    % Quadratic drag
    [~, solQ] = ode45(@(t,z) glider_quadratic(t,z,D), tspan, z0);
    thQ = solQ(:,1); sQ = solQ(:,2); xQ = solQ(:,3); yQ = solQ(:,4);

    plot(ax1, thQ, sQ, '-', 'Color', colours(j,:), 'LineWidth', 1.6 );
    plot(ax2, xQ,  yQ,  '-', 'Color', colours(j,:), 'LineWidth', 1.6);
    % Equilibrium marker (quadratic)
    idxQ = equilibrium_index_quadratic(thQ, sQ, D, 1e-4);
    if ~isempty(idxQ)
        plot(ax1, thQ(idxQ), sQ(idxQ), 'o', ...
            'MarkerSize', 7, ...
            'MarkerFaceColor', colours(j,:), ...
            'MarkerEdgeColor', 'k', ...
            'HandleVisibility','off');
    end

    %Linear drag
    [~, solL] = ode45(@(t,z) glider_linear(t,z,D), tspan, z0);
    thL = solL(:,1); sL = solL(:,2); xL = solL(:,3); yL = solL(:,4);

    plot(ax1, thL, sL, '--', 'Color', colours(j,:), 'LineWidth', 1.6);
    plot(ax2, xL,  yL,  '--', 'Color', colours(j,:), 'LineWidth', 1.6);

    % Equilibrium marker (linear)
    idxL = equilibrium_index_linear(thL, sL, D, 1e-4);
    if ~isempty(idxL)
        plot(ax1, thL(idxL), sL(idxL), 'o', ...
            'MarkerSize', 7, ...
            'MarkerFaceColor', colours(j,:), ...
            'MarkerEdgeColor', 'k', ...
            'HandleVisibility','off');
    end
end


% Legend for the colours
hD = gobjects(numel(Ds),1);
for j = 1:numel(Ds)
    hD(j) = plot(ax1, nan, nan, '-', 'Color', colours(j,:), 'LineWidth', 1.6);
end
lgdD = legend(ax1, hD, ...
    {'$D=0$','$D=1$','$D=\sqrt{8}$','$D=4$'}, ...
    'Interpreter','latex', 'Orientation','horizontal');
lgdD.Layout.Tile = 'south';

% Making the lines solid for quad and lined for linear
hQ = plot(ax2, nan, nan, '-',  'Color','k','LineWidth',1.6);
hL = plot(ax2, nan, nan, '--', 'Color','k','LineWidth',1.6);
lgdLaw = legend(ax2, [hQ hL], {'Quadratic drag','Linear drag'}, ...
    'Orientation','horizontal');
lgdLaw.Layout.Tile = 'south';

%functions used

function dx = glider_quadratic(~, x, D)
theta = x(1); s = x(2);
dx = zeros(4,1);
dx(1) = s - cos(theta)/s;
dx(2) = -sin(theta) - D*s^2;
dx(3) = s*cos(theta);
dx(4) = s*sin(theta);
end

function dx = glider_linear(~, x, D)
theta = x(1); s = x(2);
dx = zeros(4,1);
dx(1) = s - cos(theta)/s;
dx(2) = -sin(theta) - D*s;
dx(3) = s*cos(theta);
dx(4) = s*sin(theta);
end

function [theta_star, s_star] = equilibrium_point_quadratic(D)
s_star = (1/(1 + D^2))^(1/4);  
theta_star = -atan(D);          
end

function [theta_star, s_star] = equilibrium_point_linear(D)
u = (-D^2 + sqrt(D^4 + 4))/2;   
s_star = sqrt(u);              
theta_star = atan(-D/s_star);  
end

function idx = equilibrium_index_quadratic(theta, s, D, tol)
[theta_star, s_star] = equilibrium_point_quadratic(D);
dist = (theta - theta_star).^2 + (s - s_star).^2;
idx  = find(dist < tol, 1, 'first');
end

function idx = equilibrium_index_linear(theta, s, D, tol)
[theta_star, s_star] = equilibrium_point_linear(D);
dist = (theta - theta_star).^2 + (s - s_star).^2;
idx  = find(dist < tol, 1, 'first');
end
