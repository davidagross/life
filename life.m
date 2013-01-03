function R = life(N,R,env,skip)

if  ~exist('env','var') || isempty(env)
    env = [5,7];
end

if ~exist('R','var') || isempty(R)
    %% glider
    % r = ismember(reshape(0:8,3,3)',[2 3 5 7 8]);
    %% f-pentomino
    r = ismember(reshape(0:8,3,3)',[1 3 4 5 6]);
    R = circshift([r,zeros(3,env(2)-3);zeros(env(1)-3,env(2))],floor((env-3)/2));
end

if  ~exist('skip','var') || isempty(skip)
    skip = 1;
end

%%%%%%%%%
% cells %
%%%%%%%%%

%% vector of first 9 natural numbers
% 0:8
%% 3 x 3 reshape
% reshape(0:8,3,3)'
%% which items are members of 1 2 3 4 7 ?
% ismember(reshape(0:8,3,3)',[1 2 3 4 7])
%% call it r
% r = ismember(reshape(0:8,3,3)',[1 2 3 4 7]);
%% 5 7 take of r (padding below and on the right with zeros)
% [r , zeros(3,7-3) ; zeros(5-3,7)]
%% center vertically
% circshift([r , zeros(3,7-3) ; zeros(5-3,7)],[0,2])
%% % center horizontally
% circshift([r , zeros(3,7-3) ; zeros(5-3,7)],[1,2])
%% call it R
% R = circshift([r,zeros(3,env(2)-3);zeros(env(1)-3,env(2))],floor((env-3)/2));
%% vector of three matrics
% {R,R,R}
%% rotate individually
% cellfun(@circshift,{R,R,R},{[-1,0],[0,0],[1,0]},'UniformOutput',false)
%% we can't really "enclose" R to be copied
% 
%% outer product?  ok we can't do that either
% cellfun(@circshift,{R,R,R;R,R,R;R,R,R},{[-1,-1],[0,-1],[1,-1];[-1,0],[0,0],[1,0];[-1,1],[0,1],[1,1]},'UniformOutput',false)
%% column sum alone? can't do that
% 
%% row sum alone?  nope.  but we can do the whole thing, kind of
% sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3)
%% find the 3s and 4s
% cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false)
%% and the 4s with the original matrix
% cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false)
%% or the results to get the next generation of life
% logical(sum(cell2mat(reshape(cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false),[1,1,2])),3))

%%%%%%%%%%
% arrays %
%%%%%%%%%%

%% vector of first 9 natural numbers
% 0:8
%% 3 x 3 reshape
% reshape(0:8,3,3)'
%% which items are members of 1 2 3 4 7 ?
% ismember(reshape(0:8,3,3)',[1 2 3 4 7])
%% call it r
% r = ismember(reshape(0:8,3,3)',[1 2 3 4 7]);
%% glider
% r = ismember(reshape(0:8,3,3)',[2 3 5 7 8]);
%% f-pentomino
% r = ismember(reshape(0:8,3,3)',[1 3 4 5 6]);
%% 5 7 take of r (padding below and on the right with zeros)
% [r , zeros(3,7-3) ; zeros(5-3,7)]
%% center vertically
% circshift([r , zeros(3,7-3) ; zeros(5-3,7)],[0,2])
%% % center horizontally
% circshift([r , zeros(3,7-3) ; zeros(5-3,7)],[1,2])
%% call it R
% R = circshift([r,zeros(3,env(2)-3);zeros(env(1)-3,env(2))],floor((env-3)/2));
%% vector of three matrics
% cat(3,R,R,R)
%% rotate individually
% add extra padding (ENFORCES NON-TOROIDAL BOUNDARIES)
bigR = [zeros(1,size(R,2)+2) ; zeros(size(R,1),1) R zeros(size(R,1),1) ; zeros(1,size(R,2)+2)];
% cellfun(@circshift,{R,R,R},{[-1,0],[0,0],[1,0]},'UniformOutput',false)
%% we can't really "enclose" R to be copied
% 
%% outer product?  ok we can't do that either
% cellfun(@circshift,{R,R,R;R,R,R;R,R,R},{[-1,-1],[0,-1],[1,-1];[-1,0],[0,0],[1,0];[-1,1],[0,1],[1,1]},'UniformOutput',false)
% subsref(repmat(bigR,[3,3]),struct('type','()','subs',{{[1:env(1),env(1)+4:2*env(1)+3,2*env(1)+7:3*env(1)+6],[1:env(2),env(2)+4:2*env(2)+3,2*env(2)+7:3*env(2)+6]}}))
%% column sum alone? can't do that
% 
%% row sum alone?  nope.  but we can do the whole thing, kind of
% sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3)
% sum(reshape(permute(reshape(subsref(repmat(bigR,[3,3]),struct('type','()','subs',{{[1:env(1),env(1)+4:2*env(1)+3,2*env(1)+7:3*env(1)+6],[1:env(2),env(2)+4:2*env(2)+3,2*env(2)+7:3*env(2)+6]}})),[size(R,1),3,size(R,2),3]),[1,3,2,4]),[size(R),9]),3)
%% find the 3s and 4s
% cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false)
%% and the 4s with the original matrix
% cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false)
%% or the results to get the next generation of life
% logical(sum(cell2mat(reshape(cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false),[1,1,2])),3))

%%%%%%%%%%%
% FINALLY %
%%%%%%%%%%%

%% APL says:
% life ? {?1 ? ?.? 3 4 = +/ +? 1 0 -1 ?.? 1 0 -1 ?¨ ? ?}
%% MATLAB cellfun says:
% life = @(R) logical(sum(cell2mat(reshape(cellfun(@and,cellfun(@(num) ...
% ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},...
% {[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]}, ...
% 'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput', ...
% false),{ones(size(R)),R},'UniformOutput',false),[1,1,2])),3));
%% What if matlab commands were name with only one letter
% A = and
% C = circshfit
% f = false
% F = cellfun
% I = ismember
% L = logical
% M = cell2mat
% O = ones
% P = repmat
% R = reshape
% S = sum
% U = 'UniformOutput'
% Z = size
% life = @(R) L(S(M(R(F(@A,F(@(N)I(S(R(M(F(@C,P({R},[1,9],...
% {[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]}, ...
% U,f)),[S(R),9]),3),N),{3,4},U,f),{O(Z(R)),R},U,f),[1,1,2])),3));
%%% or in a single line:
% life = @(R) logical(sum(cell2mat(reshape(cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false),[1,1,2])),3));

%% let's plot it and play the game!

image(R)
colormap([1 1 1 ; 0 0 1]);
axis equal tight

for n = 1:N
    R = logical(sum(cell2mat(reshape(cellfun(@and,cellfun(@(num)ismember(sum(reshape(cell2mat(cellfun(@circshift,{R,R,R,R,R,R,R,R,R},{[-1,-1],[0,-1],[1,-1],[-1,0],[0,0],[1,0],[-1,1],[0,1],[1,1]},'UniformOutput',false)),[size(R),9]),3),num),{3,4},'UniformOutput',false),{ones(size(R)),R},'UniformOutput',false),[1,1,2])),3));
    imagesc(R)
    axis equal tight
    title(sprintf('%i of %i',n,N));
    if mod(n,skip)==0
        drawnow
    end
end