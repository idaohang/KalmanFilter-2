
clc
close all
x1=[0;0];
x2=[5;-5];
y1=[0;0];
y2=[0;0];
u1=0.2/sqrt(2);
u2=0;
A1=eye(2,2);
A2=A1;
B1=ones(2,1);
B2=B1;
C1=eye(2,2);
C2=C1;

D1=zeros(2,1);
D2=D1;

Q=0.04*eye(2,2);
Ruwb=0.01*eye(2,2);
Rgps=25*eye(2,2);

xe1=zeros(size(x1));
xe2=xe1;
P1=25*eye(2,2);
P2=P1;

T=500;
for i=1:T
     
    if mod(i,5)==0
        x1(:,i+1)=A1*x1(:,i)+B1*u1+ss_create_noise(Q);
        y1(:,i+1)=C1*x1(:,i+1)+ss_create_noise(Rgps);  
       [xe1(:,i+1),P1(:,:,i+1)]=ss_kf(A1,B1,C1,D1,xe1(:,i),u1,y1(:,i+1),P1(:,:,i),Q,Rgps);
       
        x2(:,i+1)=A2*x2(:,i)+B2*u2+ss_create_noise(Q);
        y2(:,i+1)=C2*x2(:,i+1)+ss_create_noise(Rgps);
        [xe2(:,i+1),P2(:,:,i+1)]=ss_kf(A2,B2,C2,D2,xe2(:,i),u2,y2(:,i+1),P2(:,:,i),Q,Rgps);
    else
        x2(:,i+1)   = A2*x2(:,i)+B2*u2+ss_create_noise(Q);
        xe2(:,i+1)  = A2*xe2(:,i)+B2*u2;
        P2(:,:,i+1) = P2(:,:,i)+Q;
        
        
        x1(:,i+1)=A1*x1(:,i)+B1*u1+ss_create_noise(Q);
        y1(:,i+1)=C1*(x2(:,i+1)-x1(:,i+1))+ss_create_noise(Ruwb);  %y=x2-x1 -->  y-x2=-x1;
        y1(:,i+1)=y1(:,i+1)-xe2(:,i+1);
       [xe1(:,i+1),P1(:,:,i+1)]=ss_kf(A1,B1,-C1,D2,xe1(:,i),u1,y1(:,i+1),P1(:,:,i),Q,Ruwb+P2(:,:,i+1));
    end
         
end


%plot(x1,'b')
subplot(1,2,1)
plot(x1(1,:),x1(2,:),'r');hold on;
plot(x2(1,:),x2(2,:),'b');

plot(xe1(1,:),xe1(2,:),'k');
plot(xe2(1,:),xe2(2,:),'k');

subplot(1,2,2)
e1=abs(x1-xe1);
e2=abs(x2-xe2);
plot(e1(1,:),'r');hold on;
plot(e2(1,:),'b');
E1=mean(e1(:))
E2=mean(e2(:))
p1=mean(P1(:))
p2=mean(P2(:))