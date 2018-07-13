function [h]=plot_annots(j,tot_leads,S_hat4,Q_hat4,QRS_old,T_on_GUI,T_off_GUI,T_peak_GUI,P_peak_GUI,ecg_sig,Fs,handles)
                 tempT=1/Fs;
                 dT=size(ecg_sig,2)*tempT;
                 timeline=0:tempT:dT-tempT;                 
                 h(j)=subplot(tot_leads,1,j,'Parent',handles.uipanel15);
                 p=get(h(j),'pos');
                 p = p + [-0.05 0.02 0.08 0.01];
                 set(h(j), 'pos', p);
                 set(gca,'FontSize',5)
                 plot(timeline,ecg_sig(j,:));axis tight;
                 hold on;
                 plot(timeline(S_hat4),ecg_sig(j,S_hat4),'Ko','MarkerFaceColor','g','Markersize',3)
                 plot(timeline(Q_hat4),ecg_sig(j,Q_hat4),'Ko','MarkerFaceColor','g','Markersize',3)
                 plot(timeline(QRS_old),ecg_sig(j,QRS_old),'Ko','MarkerFaceColor','r','Markersize',3)
                 plot(timeline(T_on_GUI),ecg_sig(j,T_on_GUI),'K+')
                 plot(timeline(T_off_GUI),ecg_sig(j,T_off_GUI),'K+')
                 plot(timeline(T_peak_GUI),ecg_sig(j,T_peak_GUI),'Ko','MarkerFaceColor','k','Markersize',3)
                 plot(timeline(P_peak_GUI),ecg_sig(j,P_peak_GUI),'Ko','MarkerFaceColor','k','Markersize',3)
%                  set(h(j),'xticklabel',[])
                 hold off