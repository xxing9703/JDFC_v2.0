%Code below is to reproduce Figure results
f1=figure;
ax=axes;
% AA final concentration
selected={'Leu','Phe','Ile','Met','Val','Pro','Tyr','Ala','Thr',...
    'Gln','Gly','Glu','Ser','Asp','Lys','His'};
ind=[];
for i=1:length(selected)
    ind=[ind,find(strcmp(aa_abbv,selected{i}))]; %systhesis]
end
bar(AAin(end,ind),'facecolor','#9CD69C')
set(ax,'XTick',[1:length(selected)],'XTickLabel', aa_abbv(ind));
set(ax,'Yscale','log','Ytick',2.^(0:15),'YMinorTick','off');
ylim([2^6.7,2^14.2])