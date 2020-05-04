function max_matching()
% 需要用到计算增广路径 深度优先搜索
global G_E;
global G_V;
global V_min_set;
global visited;
global matched;
    matched(1,length(G_E))=0;
    visited(1,length(G_E))=0;
    for i = V_min_set
        if(matched(G_V==i)==0)
            visited(1,:)=0;
            argument_path(find(G_V==i));
        end
    end
    for i = 1:1:length(matched)
        if(matched(i)~=0)
            matched(i)=G_V(i);
        end
    end
end

function is_apath = argument_path(index)
global G_E;
global visited;
global matched;
global V_min_set;
    visited(index)=1;
    neighbours = G_E(index,:);
    for i = 1:1:length(neighbours)
        if(neighbours(i)==1)
            if(visited(i)==1)
                continue;
            end
            if(matched(i)==0)
                matched(i)=index;
                matched(index)=i;
                is_apath = true;
                return;
            else
                if(matched(i)~=index)
                    visited(i) = 1;
                    if(argument_path(matched(i)))
                        matched(i)=index;
                        matched(index)=i;
                        is_apath = true;
                        return;
                    end
                end
            end
        end
    end
    is_apath = false;
end
