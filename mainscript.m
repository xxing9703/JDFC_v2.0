% this is the main code to run JDFC. Set input data/parameters before run
clear
tic
%-------- DEFINE INPUT parameters
fname='input.xlsx';
iterations=10000;
Vol=0.00001;
dt=0.001;
% ----- DEFINE CONST
aanum=22;
tpnum=42;
time=1:iterations;
psi=-0.06;
z1=1;
z2=2;
F=96500;
R=8.314;
T=310.15;
B1=exp((-z1*F*0.5*psi)/(R*T));
B2=exp((-z2*F*0.5*psi)/(R*T));
% -------Read data from input
TB1=readtable(fname,'sheet','TP');
tp_name=TB1.tp_name;
tp_fun=TB1.tp_fun;
tp_level=TB1.tp_level;
TB2=readtable(fname,'sheet','AA');
aa_symb=TB2.AA_symb(1:aanum);
aa_abbv=TB2.AA_abbv(1:aanum);
aa_name=TB2.AA_name(1:aanum); 
AAdep=TB2.AA_dep(1:aanum);
AAex=TB2.AA_ex(1:aanum);AAin=zeros(iterations,aanum); %initialize AAin matrix;
AAin(1,:)=TB2.AA_in(1:aanum); %AAin (iter=1), column 2
ionex=TB2.AA_ex(aanum+1:end); %last 4: Na,K,H,Cl
ionin=TB2.AA_in(aanum+1:end);
TB3=readtable(fname,'sheet','AAcon');
AAcon=zeros(aanum,aanum);
for i=1:length(TB3.From)
    n=find(strcmp(aa_abbv,TB3.To{i})); %systhesis
    m=find(strcmp(aa_abbv,TB3.From{i})); %deplete
    AAcon(n,m)=TB3.pct(i);
end
Kmex=xlsread(fname,'Kmex'); %HAL included
Kmin=xlsread(fname,'Kmin'); %HAL included
Vmax=xlsread(fname,'Vmax'); Vcol=1;
rVmax=xlsread(fname,'rVmax');
para_modify  % you can add code in here to adjust parameters.
% Predefine Matrices
ddt=zeros(iterations,aanum,tpnum); % 3d matrix, stores all the fluxes
%--------- RUN THROUGH EACH FUNCTION FOR AMINO ACID CONCENTRATION DETERMINATION
for i=2:iterations
    fprintf([num2str(i),'/',num2str(iterations),'\n']);
    for j=1:tpnum
      if tp_level(j)>0 %transporter expression level
        ddt(i,:,j)=tp_level(j)*mysystem(tp_fun(j),AAex,AAin(i-1,:),ionex,ionin,Kmex(j,:),Kmin(j,:),rVmax(j,:),Vmax(j,Vcol),dt,Vol,B1,B2);      
      end
    end
    %DETERMINE INTRACELLULAR CONCENTRATION GIVEN THE CHANGE IN CONCENTRATION THROUGH EACH TRANSPORTER
    AAin(i,:)=AAin(i-1,:)+sum(ddt(i,:,:),3);
    % AMINO ACID CONVERSION AND DEPLETION, where n=AA being synthesised, m=AA being depleted    
    conversion=zeros(aanum,aanum);    
    for n=1:aanum        
          conversion(n,:)=AAcon(n,:).*AAin(i,:);        
    end     
    for n=1:aanum
      usage=sum(conversion);
      synthesis=sum(conversion,2);
      AAin(i,n)=AAin(i,n)*(1-AAdep(n))-usage(n)+synthesis(n);
    end
end
%% Making plots
f=figure('units','normalized','outerposition',[.2 .2 .6 .6]);
tabgp = uitabgroup(f,'Position',[.05 .05 .9 .9]);
tab00= uitab(tabgp,'Title','Overall');
ax001 = uiaxes(tab00,'units','normalized','Position',[.05 .05 .45 .9]);
ax002 = uiaxes(tab00,'units','normalized','Position',[.55 .05 .45 .9]);
for aa=1:aanum
    plot(ax001,AAin(:,aa))
    hold(ax001,'on');
end
  xlabel(ax001,'Iterations')
  ylabel(ax001,'AA concentration')
  title(ax001,'Change in AA concentration');
  xlabel(ax002,'Iterations')
  ylabel(ax002,'AA flux')
  title(ax002,'Change in AA flux');
for aa=1:aanum
  tab{aa} = uitab(tabgp,'Title',aa_abbv{aa});
  %ax{aa} = uiaxes(tab{aa},'units','normalized','Position',[.05 .05 .9 .9]);
  ax1{aa} = uiaxes(tab{aa},'units','normalized','Position',[.05 .05 .45 .9]);
  ax2{aa} = uiaxes(tab{aa},'units','normalized','Position',[.55 .05 .45 .9]);
  % draw ax1 AA FLUX THROUGH SINGLE TRANSPORTER DSIPLAY
  str=[];
  for i=1:tpnum
    if ddt(iterations,aa,i)~=0
      plot(ax1{aa},1:iterations,ddt(:,aa,i));
      plot(ax002,1:iterations,ddt(:,aa,i));
      str=[str;tp_name(i)];
      hold(ax1{aa},'on');
      hold(ax002,'on');
    end
  end
  title(ax1{aa},['Change in ',aa_name{aa},' flux']);
  legend(ax1{aa},str);
  hold(ax1{aa},'off');
  xlabel(ax1{aa},'Iterations')
  ylabel(ax1{aa},'AA flux')
  %draw ax2, changes in AA concentration 
    plot(ax2{aa},1:iterations,AAin(:,aa))
    hold(ax2{aa},'on');
    title(ax2{aa},['Change in ',aa_name{aa},' concentration']);
    xlabel(ax2{aa},'Iterations')
    ylabel(ax2{aa},'AA concentration')
end
toc
reproduce