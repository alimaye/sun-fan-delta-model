
    function grid=slopeAlongFlow(grid)
        % slopeAlongFlow: retrieves cell-to-cell slope values along flow
        % paths
        
        grid.S.alongFlow = nan(grid.size); 
     
        for k=1:numel(grid.channelFlag)
            if grid.channelFlag(k) 
                if isempty(grid.flowsTo{k})
                    grid.S.alongFlow(k) = 0; % define slope as zero for any cell that does not flow elsewhere. 
                    % Other conditions should kick into effect to treat
                    % these cells, namely: (1) Qs_out is set to zero for all
                    % cells that don't flow to other cells; and (2) a zero
                    % value of slope causes an undefined value of flow
                    % depth, and flow depth influences the avulsion
                    % criterion (eqn. 13). For cases with negative/NaN flow
                    % depths, the depth used in the avulsion criterion
                    % (eqn. 13) is set to zero so that it does not affect
                    % avulsion susceptibility.

                    % an alternative implementation: use the slope of the
                    % cell fromsFrom
                    if k == 4950 % no upstream node to the inlet at t=0, could be avoided by defining a flowsTo before time loop?
                        grid.S.alongFlow(k) = 0;
                    else % other cells, use the upstream contributing slopes
                        upstreamSlopes = grid.S.alongFlow(grid.flowsFrom{k});
                        grid.S.alongFlow(k) = mean(upstreamSlopes); % mean() ensures scalar
                    end
                else
                    % if this cell is a channel cell, look up the cell(s) it
                    % flows to
                    flowsTo = grid.flowsTo{k};
                    [ri,ci] = ind2sub(grid.size, k); % row,col of cell i
                    S_temp = nan(size(flowsTo));
                    for l=1:numel(flowsTo)
                        [rj,cj] = ind2sub(grid.size, flowsTo(l)); % row,col of cell j
                        distance = sqrt((rj-ri)^2 + (cj-ci)^2) * grid.dx;  % distance along flow
                        S_temp(l) = -(grid.z(flowsTo(l)) - grid.z(k)) / distance; % downhill slopes are defined as positive
                    end
                    grid.S.alongFlow(k) = max(S_temp); % if there are multiple flowsTo cells, treat slope as the maximum of slopes to each cell
                end         
            end
        end        
    end % end nested function slopeAlongFlow