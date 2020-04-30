% �ļ������������


% �ļ�����ģ���Ȳ�ʵ��
% ��ʱ�ü򵥵ĳ�ʼ���ݴ���
clc;
global matched;
global G_E;
global V_min_set;
% ����P G O
% test1
% G_V_num = 7;
% G_O_num = 4;
% G_E = [0,1,1,0,0,0,0;1,0,1,1,1,0,0;1,1,0,0,0,0,0;0,1,0,0,0,1,0;0,1,0,0,0,0,1;0,0,0,1,0,0,1;0,0,0,0,1,1,0];
% test2
G_V_num = 7;
G_O_num = 4;
G_E = [0,0,1,0,0,0,0;0,0,1,0,0,0,0;1,1,0,1,1,0,0;0,0,1,0,0,0,0;0,0,1,0,0,1,1;0,0,0,0,1,0,1;0,0,0,0,1,1,0];
% test3
% G_V_num = 8;
% G_O_num = 3;
% G_E = [0,1,1,0,0,0,0,0;1,0,1,1,1,1,0,0;1,1,0,1,0,0,0,0;...
%     0,1,1,0,0,1,0,0;0,1,0,0,0,1,0,0;0,1,0,1,1,0,1,1;...
%     0,0,0,0,0,1,0,0;0,0,0,0,0,1,0,0];


O = (G_V_num+1):1:(G_V_num+G_O_num);
G_V = 1:1:G_V_num; 
V = [];
V_adj =[];
for i = G_V
    V = [V,2.^(i-1)];
end
V = int64(V);
% (1,3),(2,3),(3,4),(3,5),(5,6),(5,7),(6,7)
temp = int64(0);
for adj_e = G_E
    for i = 1:1:length(adj_e)
        if(adj_e(i)==1)
            temp = bitor(temp,V(i));
        end
    end
    V_adj = [V_adj,temp];
    temp =0;
end
% disp(G_E);

% ��G����С���㸲��V_min_set
% �㷨���Ӷ�Ϊָ����������ʽ�������������
resulta = [V(1),V_adj(1)];
resultb = [];
for index=2:1:length(G_V)
   for i = 1:1:length(resulta)
       resultb = [resultb,bitor(resulta(i),V(index)),bitor(resulta(i),V_adj(index))];
   end
   resulta = resultb;
   resultb = [];
end
delta = length(G_V);
V_min = 2.^delta-1;
V_min_set = [];
for i=resulta
    num =i;
    count =0;
    while num~= 0
        count=count+1;
        num = bitand(num,num-1);
    end
    if(count<delta)
        delta=count;
        V_min = i;
    end
end
for i=1:1:length(V)
    if(bitand(V_min,V(i)))
       V_min_set = [V_min_set,i];
    end
end

% ����V_min��G-V_min�����ƥ��
% S1����������ͼ
E = G_E;
for i=V_min_set
   for j=V_min_set
      G_E(i,j)=0; 
   end
end
% S2: ������������������ƥ��
max_matching();

% �������ս��
C = setdiff(setdiff(G_V,V_min_set),matched);
f = int64((length(G_V)+length(O) - 1)/2);
need_num = int64(2*(f-delta)+1-length(O));

% ����G_fault_num default = f ����С�ڵ���f ͬʱ����delta
whole_G = union(G_V,O);
other_than_delta = setdiff(whole_G,V_min_set);
G_fault_num = f;
G_fault_num = G_fault_num - delta;
other_fault_set = other_than_delta(randperm(length(other_than_delta),G_fault_num));
fault_set = union(V_min_set,other_fault_set);

% ע���п��ܸ����Ͳ���Ҫ��ͻͼ����Ľڵ�
if(need_num<=0)
    best_path = O(1:length(O)+need_num);
else
    best_path = union(C(1:need_num),O);
end

% ���ӻ� ע����ӻ�ֻ����������е�һ��(����)��
% ֻ������ֽ��ԭ�������ƥ�䲻��Ψһ��
% ylist = 0:1:G_V_num+G_O_num-1;
% xlist = round(rand(1,G_V_num+G_O_num)*(G_V_num+G_O_num));
mGraph = graph(E);
% mGraph = addnode(mGraph,length(O));
mGraph = addnode(mGraph,length(O)+2);
angle = 0:2*pi/(numnodes(mGraph)-2):2*pi;
xlist = cos(angle+pi/2);
ylist = sin(angle+pi/2);

% ����G_fault_num default = f ����С�ڵ���f ͬʱ����delta
whole_G = union(G_V,O);
other_than_delta = setdiff(whole_G,V_min_set);
G_fault_num = f;
G_fault_num = G_fault_num - delta;
other_fault_set = nchoosek(other_than_delta,G_fault_num);
iter_num = size(other_fault_set,1);
if(iter_num>100)
    iter_num=100;
end
for i=1:1:iter_num
    fault_set = union(V_min_set,other_fault_set(i,:));
    
    close all;
    fig = figure(i);
    h = plot(mGraph);
    labelnode(h,[numnodes(mGraph)-1,numnodes(mGraph)],["S��Դ��","Z��Ŀ�ģ�"]);
    labelnode(h,fault_set,"����");
    h.XData =  [xlist(1:numel(xlist)-1),-2,2];
    h.YData =  [ylist(1:numel(ylist)-1),0,0];
    h.LineStyle = '--';
    h.MarkerSize = 4;
    % highlight(h,fault_set,'NodeColor','b');
    highlight(h,union(best_path,[numnodes(mGraph)-1,numnodes(mGraph)]),'NodeColor','r');
    highlight(h,[numnodes(mGraph)-1,numnodes(mGraph)]);
    hold on
    Ax = repelem(-2,numel(best_path));
    Ay = repelem(0,numel(best_path));
    Bx = xlist(best_path);
    By = ylist(best_path);
    Cx = repelem(2,numel(best_path));
    Cy = repelem(0,numel(best_path));
    X = [Ax;Bx];
    Y = [Ay;By];
    plot(X,Y,'g');
    hold on
    X = [Cx;Bx];
    Y = [Cy;By];
    plot(X,Y,'g');
    title(["��ɫ������ѡ�е�·��";"��ɫ�����ǿ��滻��·��"]);
    frame = getframe(fig); % ��ȡframe
    img = frame2im(frame); % ��frame�任��imwrite��������ʶ��ĸ�ʽ
    imwrite(img,['result',num2str(i),'.png']); % ���浽����Ŀ¼�£�����Ϊ"a.png"
end
clear variables;