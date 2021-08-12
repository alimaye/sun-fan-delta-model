function [flag,indLoop] = findFlowLoops(grid)
% findFlowLoops.m: debugging function to identify flow loops
flag = false;
indLoop = [];
for i=1:numel(grid.flowsTo)
    for j=1:numel(grid.flowsTo{i})
        indFlowsTo = grid.flowsTo{i}(j);
        if ismember(i,grid.flowsTo{indFlowsTo})
            flag = true;
            indLoop = [i,indFlowsTo];
            break
        end
    end
    if flag
        break
    end
end  
end