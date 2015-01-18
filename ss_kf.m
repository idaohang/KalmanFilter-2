function [xe,P]=ss_kf(A,B,C,D,xe,u,y,P,Q,R)

        P=A*P*A'+Q;
        K=P*C'/(C*P*C'+R);
        xe=A*xe+B*u;
        xe=xe+K*(y-D*u-C*xe);
        P=(eye(size(A))-K*C)*P*(eye(size(A))-K*C)'+K*R*K';

end