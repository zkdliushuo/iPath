% �ļ������������


% �ļ�����ģ���Ȳ�ʵ��
% ��ʱ�ü򵥵ĳ�ʼ���ݴ���
global matched;
global G_E;
global V_min_set;
% ����P G O
% test1
% G_V_num = 7;
% G_O_num = 4;
% G_E = [0,1,1,0,0,0,0;1,0,1,1,1,0,0;1,1,0,0,0,0,0;0,1,0,0,0,1,0;0,1,0,0,0,0,1;0,0,0,1,0,0,1;0,0,0,0,1,1,0];
% test2
% G_V_num = 7;
% G_O_num = 4;
% G_E = [0,0,1,0,0,0,0;0,0,1,0,0,0,0;1,1,0,1,1,0,0;0,0,1,0,0,0,0;0,0,1,0,0,1,1;0,0,0,0,1,0,1;0,0,0,0,1,1,0];
% test3
G_V_num = 8;
G_O_num = 3;
G_E = [0,1,1,0,0,0,0,0;1,0,1,1,1,1,0,0;1,1,0,1,0,0,0,0;...
    0,1,1,0,0,1,0,0;0,1,0,0,0,1,0,0;0,1,0,1,1,0,1,1;...
    0,0,0,0,0,1,0,0;0,0,0,0,0,1,0,0];


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
G_E
max_matching();

% �������ս��
V_min_set
matched
C = setdiff(setdiff(G_V,V_min_set),matched)
f = int64((length(G_V)+length(O) - 1)/2);
need_num = int64(2*(f-delta)+1-length(O))
% ע���п��ܸ����Ͳ���Ҫ��ͻͼ����Ľڵ�
if(need_num<=0)
    best_path = O(1:length(O)+need_num);
else
    best_path = union(C(1:need_num),O);
end

% ���ӻ� ע����ӻ�ֻ����������е�һ��(����)��
% ֻ������ֽ��ԭ�������ƥ�䲻��Ψһ��
mGraph = graph(E);
mGraph = addnode(mGraph,length(O));
h = plot(mGraph);
h.NodeColor = 'black';
highlight(h,V_min_set,'NodeColor','b');
highlight(h,best_path,'NodeColor','r');
title("��ɫ��ʾ����·��");