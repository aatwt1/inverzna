N=4;

P= izlaz(:, 1); %izlaz je izlazni rezultat iz simulinka
T = izlaz(:, 2);
minulaz = min(P); 
maxulaz = max(P); %opseg ulaznih vrijednosti
minizlaz = min(T); 
maxizlaz = max(T);%opseg moguceg izlaza
 
net = newff([zeros(2*N,1)-1 zeros(2*N,1)+1], ... 
[15 5 1],{'tansig','tansig', 'purelin'}, 'trainlm');
 
net.trainParam.epochs = 2000;
net.trainParam.goal = 2e-9;
net.trainParam.show = 10;
net.trainParam.time = Inf;

fprintf('Opseg ulaza mreže je: [%g, %g].\n',minulaz,maxizlaz);

P=2*(P-minulaz) ./(maxulaz-minulaz)-1;
T=2*(T-minizlaz) ./ (maxizlaz-minizlaz)-1;

vel=length(T);
ulaz=zeros(2*N,vel-N);
izlaz1=zeros(1,vel-N);

for k=N : vel-1
    t=flipud(T(k-N+1:k+1));
    p=flipud(P(k-N+1:k-1));
    ulaz(:,k)=[t; p];
    izlaz1(k)=P(k);
end

fprintf('Pocetak treniranja\n');
tic
net=train(net,ulaz,izlaz1);
toc

izlaz1=sim(net,ulaz);
izlaz1=(izlaz1+1)*(maxulaz-minulaz)./2+minulaz;

figure
subplot(211), plot(izlaz(:,1));
title('Izlazni podaci iz sistema');
xlabel('uzorci')
ylabel('amplituda')

subplot(212), plot(izlaz1,'r')
title('Podaci dobiveni sa treniranom mrežom');
xlabel('uzorci')
ylabel('amplituda')
gensim(net)
