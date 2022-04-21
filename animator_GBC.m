 function animator_GBC(action,isAnimation)
if nargin<2, isAnimation=true; end
get(gcf,'userdata');
axis manual
switch(action) 
%cases START and MOVE are the default to animate a point.
      case 'start'
          ud = get(gcf,'userdata');
          seltype = get(gcf,'SelectionType');
          if strcmpi(seltype,'normal') %'left mouse button pressed
             ud.deformPol{ud.indexFound}.Selected = 0;
             set(ud.figure,'WindowButtonMotionFcn','animator_GBC move')
             set(ud.figure,'WindowButtonUpFcn','animator_GBC stop');
             set(ud.figure,'userdata',ud);
         elseif strcmpi(seltype,'open') %right mouse button pressed
             set(ud.figure,'WindowButtonMotionFcn','');
             set(ud.figure,'windowButtonUpFcn','');
             set(ud.figure,'windowButtonDownFcn','');
         end
set(gcf,'userdata',ud);
     case 'move'         
         ud = get(gcf,'userdata');
         for i = 1: ud.index
              ud.A(i,1)= ud.deformPol{i}.Selected;
         end
          ud.indexFound = find(ud.A==1);
          Deformed_output =  [ud.xqq,ud.yqq];
              if find(ud.s{ud.indexFound}==1 )
                  x = find(ud.s{ud.indexFound}==1);
                 for i=1:length(x)
                     Deformed_output(x(i,1),:) = [sum(ud.WC{ud.indexFound}(:,i).*ud.deformPol{ud.indexFound}.Position(:,1)),...
                     sum(ud.WC{ud.indexFound}(:,i).*ud.deformPol{ud.indexFound}.Position(:,2))];
                 end                  
              end
         ud.xqq = Deformed_output(:,1);
         ud.yqq = Deformed_output(:,2);
         vv = reshape(Deformed_output,[size(ud.xq),2]);
         Vx = vv(:,:,1);Vy = vv(:,:,2);
         set(ud.hpatch,'xdata',Vx,'ydata',Vy); 
         set(gcf,'userdata',ud);
    case'stop'
% Button unpressed so end animation and set everything back to normal.
        ud = get(gcf,'userdata');
        set(ud.figure,'WindowButtonMotionFcn','');
        set(ud.figure,'windowButtonUpFcn','');
        set(ud.figure,'windowButtonDownFcn','animator_GBC start');
        set(gcf,'userdata',ud);
end