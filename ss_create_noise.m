function w=ss_create_noise(Q,~)
%find the noise vector w subject to the covariance matrix Q;
%Q must be a sysmetric matrix which has positive eigenvalue;
%Author: WangChen     Date: 2014-4-02
if nargin==1 & Q==Q'
    [V,D]=eig(Q);
     r=sqrt(D)*randn(size(Q,1),1);
     w=V*r;
else
    fprintf('Input of ss_create_noise must be sysmetric!\n');    
end
end