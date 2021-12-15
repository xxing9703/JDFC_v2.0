function out=mysystem(TP,AAex,AAin,ionex,ionin,Kmex,Kmin,rVmax,Vmax,dt,Vol,B1,B2)
aanum=length(AAex);
% Note the ordering:  Na,H,K,Cl in Km
NaKmex=Kmex(aanum+1);NaKmin=Kmin(aanum+1);
KpKmex=Kmex(aanum+3);KpKmin=Kmin(aanum+3);
HyKmex=Kmex(aanum+2);HyKmin=Kmin(aanum+2);
ClKmex=Kmex(aanum+4);ClKmin=Kmin(aanum+4);
%Na,K,H,Cl in AA,
Naex=ionex(1);Nain=ionin(1);
Kpex=ionex(2);Kpin=ionin(2);
Hyex=ionex(3);Hyin=ionin(3);
Clex=ionex(4);Clin=ionin(4);

Kmex_=Kmex(1:aanum);
Kmin_=Kmin(1:aanum);

switch TP   
  case 1
out=ComplexSym1_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmin,NaKmex,KpKmin,KpKmex,HyKmin,HyKmex,Naex,Nain,Kpin,Kpex,Hyin,Hyex,dt,Vol,B2);
  case 2
out=Antiporter_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,dt,Vol);
  case 3
out=ComplexSym3_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmin,NaKmex,ClKmin,ClKmex,Naex,Nain,Clin,Clex,dt,Vol,B2);
  case 4
out=NaSym_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmex,NaKmin,Naex,Nain,dt,Vol,B1);
  case 5
out=ComplexSym2_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmin,NaKmex,ClKmin,ClKmex,Naex,Nain,Clin,Clex,dt,Vol,B1);
  case 6
out=CatUniporter_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,dt,Vol,B1);
  case 7
out=ComplexAntiporter_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmex,NaKmin,Naex,Nain,dt,Vol);
  case 8
out=ElectrogenicAntiporter(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,dt,Vol,B1);
  case 9
out=ElectroSym_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,NaKmex,NaKmin,HyKmin,HyKmex,Naex,Nain,Hyex,Hyin,dt,Vol);
  case 10
out=Uniporter_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,dt,Vol);
  case 11
out=ProtonSym_function(AAex,AAin,Kmex_,Kmin_,rVmax,Vmax,HyKmin,HyKmex,Hyex,Hyin,dt,Vol,B1);
end


