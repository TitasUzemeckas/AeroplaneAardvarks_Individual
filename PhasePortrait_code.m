clear; close all; clc

Ds = [0, 3.5, 10];   % Drag value

%Phase-plane grid
theta = linspace(-pi, pi, 50);
s     = linspace(0.1, 2, 35);

% Figure and layout
figure('Units','inches','Position',[1 1 8.0 5.2]);
tl = tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

ax = gobjects(2,3); % store axes handles

% Generates the top row of figures (quadratic)
for i = 1:3
    ax(1,i) = nexttile;
    phase_portrait(theta, s, Ds(i), "quadratic");

    xlim([-pi, pi]); 
    ylim([0, 2]);

    title(ax(1,i), ['Quadratic drag, $D = ' num2str(Ds(i)) '$'], ...
        'Interpreter','latex','FontSize',11);
end

% generates the top row of figures (linear)
for i = 1:3
    ax(2,i) = nexttile;
    phase_portrait(theta, s, Ds(i), "linear");

    xlim([-pi, pi]); 
    ylim([0, 2]);

    title(ax(2,i), ['Linear drag, $D = ' num2str(Ds(i)) '$'], ...
        'Interpreter','latex','FontSize',11);
end

% Link axes
linkaxes(ax(:),'xy')

% Clean up repeated tick labels
ax(1,2).YTickLabel = [];
ax(1,3).YTickLabel = [];
ax(2,2).YTickLabel = [];
ax(2,3).YTickLabel = [];

ax(1,1).XTickLabel = [];
ax(1,2).XTickLabel = [];
ax(1,3).XTickLabel = [];

% Shared axis labels
xlabel(tl,'$\theta$','Interpreter','latex','FontSize',14)
ylabel(tl,'$s$','Interpreter','latex','FontSize',14)
set(ax, 'TickLabelInterpreter','latex','FontSize',12)


%The functions used

function phase_portrait(thetaGrid, sGrid, D, dragType)
% PHASE_PORTRAIT  Sketches the phase portrait of a dynamical system.

    [Theta, S] = meshgrid(thetaGrid, sGrid);
    [U, V] = phase_vector_field(Theta, S, D, dragType);

    h = streamslice(Theta, S, U, V, 0.35);
    set(h,'LineWidth',1.6,'Color',[0.25 0.25 0.25]);
end

function [U, V] = phase_vector_field(theta, s, D, dragType)
% PHASE_VECTOR_FIELD  Vector field for chosen drag model.

    s_safe = max(s, 1e-6);                 
    U = s_safe - cos(theta)./s_safe;       

    switch (dragType)
        case "quadratic"
            V = -sin(theta) - D.*s_safe.^2;
        case "linear"
            V = -sin(theta) - D.*s_safe;
    end
end
