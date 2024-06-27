function [mu,mask]=kmeans(ima,k)
copy=ima;       
ima=ima(:);     
mi=min(ima);     
ima=ima-mi+1;   
s=length(ima);

m=max(ima)+1;
h=zeros(1,m);
hc=zeros(1,m);

for i=1:s
  if(ima(i)>0) h(ima(i))=h(ima(i))+1;end;
end
ind=find(h);
hl=length(ind);

mu=(1:k)*m/(k+1);

while(true)
  
  oldmu=mu;
 
  for i=1:hl
      c=abs(ind(i)-mu);
      cc=find(c==min(c));
      hc(ind(i))=cc(1);
  end
  
  for i=1:k, 
      a=find(hc==i);
      mu(i)=sum(a.*h(a))/sum(h(a));
disp(mu(i));
  end
  
  if(mu==oldmu) break;end;
  
end
s=size(copy);
mask=zeros(s);
for i=1:s(1),
for j=1:s(2),
  c=abs(copy(i,j)-mu);
  a=find(c==min(c)); 
disp(a); 
  mask(i,j)=a(1);
end
end

mu=mu+mi-1;   % recover real range
disp(mu);
%msgbox(strcat('Cluster Prediction Range',num2str(mu)));
%d\f1
%}