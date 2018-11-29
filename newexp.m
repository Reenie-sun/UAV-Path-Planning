clear all
close all
clc
NP=40; %/* The number of colony size (employed bees+onlooker bees)*/
FoodNumber=NP/2; %/*The number of food sources equals the half of the colony size*/
maxCycle=150; %/*The number of cycles for foraging {a stopping criteria}*/
limit=0.1*maxCycle; %/*A food source which could not be improved through "limit" trials is abandoned by its employed bee*/
D= 40;
ub=ones(1,D).*55; %/*lower bounds of the parameters. */
lb=ones(1,D).*-90;%/*upper bound of the parameters.*/
runtime=1;%/*Algorithm can be run many times in order to see its robustness*/
GlobalMins=zeros(1,runtime);
Range = repmat((ub-lb),[FoodNumber 1]);
Lower = repmat(lb, [FoodNumber 1]);
Foods = rand(FoodNumber,D) .* Range + Lower;

for r=1:runtime
for i = 1:FoodNumber
    ObjVal(i) = calcu(Foods(i,:));
end
Fitness = calculateFitness(ObjVal);
trial=zeros(1,FoodNumber);
BestInd=find(ObjVal==min(ObjVal));
BestInd=BestInd(end);
GlobalMin = ObjVal(BestInd);
GlobalParams=Foods(BestInd,:);
iter=1;



while ((iter <= maxCycle)),
    for i=1:(FoodNumber)
        Param2Change=fix(rand*D)+1;
        neighbour=fix(rand*(FoodNumber))+1;     
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;  
       sol=Foods(i,:);
       sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
        %
        ind=find(sol<lb);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        ind=find(sol>ub);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        %
        ObjValSol = calcu(sol);
        FitnessSol=calculateFitness(ObjValSol);
       if (FitnessSol>Fitness(i)) 
            Foods(i,:)=sol;
            Fitness(i)=FitnessSol;
            ObjVal(i)=ObjValSol;
            trial(i)=0;
        else
            trial(i)=trial(i)+1;
       end;
     end;
prob=(0.9.*Fitness./max(Fitness))+0.1;
i=1;
t=0;
while(t<FoodNumber)
    if(rand<prob(i))
        t=t+1;
        Param2Change=fix(rand*D)+1;
        neighbour=fix(rand*(FoodNumber))+1;     
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;
        
       sol=Foods(i,:);
       sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
        %
        ind=find(sol<lb);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        ind=find(sol>ub);
        libai = rand(1,D).*(ub-lb)+lb;
        sol(ind)=libai(ind);
        %
        ObjValSol = calcu(sol);
        FitnessSol=calculateFitness(ObjValSol);
       if (FitnessSol>Fitness(i)) 
            Foods(i,:)=sol;
            Fitness(i)=FitnessSol;
            ObjVal(i)=ObjValSol;
            trial(i)=0;
        else
            trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
       end;
    end;
    
    i=i+1;
    if (i==(FoodNumber)+1) 
        i=1;
    end;   
end; 
         ind=find(ObjVal==min(ObjVal));
         ind=ind(end);
         if (ObjVal(ind)<GlobalMin)
         GlobalMin=ObjVal(ind);
         GlobalParams=Foods(ind,:);
         end;

         
         

ind=find(trial==max(trial));
ind=ind(end);
if (trial(ind)>limit)
    trial(ind)=0;
    sol=(ub-lb).*rand(1,D)+lb;
    ObjValSol = calcu(sol);
    FitnessSol=calculateFitness(ObjValSol);
    Foods(ind,:)=sol;
    Fitness(ind)=FitnessSol;
    ObjVal(ind)=ObjValSol;
end;
fprintf('iteration = %d ObjVal=%g\n',iter,GlobalMin);
aaaaa(iter) = GlobalMin;
iter=iter+1;
end % End of ABC
storeer(r,:) = aaaaa;
end

radar1 = [100,200,300,120,220,320,70,170,270,140,240,390,420];
radar2 = [0,0,0,-50,-50,-50,40,40,40,70,20,40,-30];
r = [24,24,24,24,24,24,24,24,24,24,24,24,30];
fenmu = [71.8976   71.8976   71.8976   71.8976   71.8976   71.8976   71.8976   71.8976   71.8976 71.8976   71.8976   71.8976   89.8720];


figure (1)
a = mean(storeer);
plot(a)

figure (2)
hold on
plot(0,0,'k*')
plot(500,0,'ks')

for i = 1:13
hold on
plot(radar1(i),radar2(i),'ko');
cir_plot([radar1(i),radar2(i)],r(i));
end
legend('starting point','target point','threat center')
axis equal

for i = 1:(D-1)
    plot([500/(D+1)*i,500/(D+1)*(i+1)],[GlobalParams(i),GlobalParams(i+1)],'LineWidth',2);
    hold on
end
plot([0,500/(D+1)*(1)],[0,GlobalParams(1)],'LineWidth',2);
plot([500/(D+1)*D,500],[GlobalParams(D),0],'LineWidth',2);