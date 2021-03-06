clear all
clc
close all
[serialObject] = RoombaInit(6)
         
% serialObject=Motion_k(a,serialObject)

    FileInfo=dir('C:\Users\andre\PycharmProjects\irobot\RobotWebsite\test.csv');
    TimeStamp2 = FileInfo.date;
for i = 1 : 2000
    
  % Initialize communication

     FileInfo=dir('C:\Users\andre\PycharmProjects\irobot\RobotWebsite\test.csv');
    TimeStamp = FileInfo.date;
  if TimeStamp==TimeStamp2
     pause(0.2)
  else 
    
A = csvread('C:\Users\andre\PycharmProjects\irobot\RobotWebsite\test.csv');
forward=A(1);
rotation=A(2);
% Read encoders (provides baseline)
[StartLeftCounts, StartRightCounts] = EncoderSensorsRoomba(serialObject);

%sets forward velocity [m/s] and turning radius [m]
SetFwdVelRadiusRoomba(serialObject, forward, rotation);
pause(1)
SetFwdVelRadiusRoomba(serialObject, 0, 0);
encoderCountList = zeros(80, 18);


  [encL, encR] = EncoderSensorsRoomba(serialObject);
  angle = AngleSensorRoomba(serialObject);
  cliff = CliffSignalStrengthRoomba(serialObject);
  cliff1 = cliff(1);
  cliff2 = cliff(2);
  cliff3 = cliff(3);
  cliff4 = cliff(4);
  [bumpR, bumpL, bumpFront, dropL, dropR] = BumpsWheelDropsSensorsRoomba(serialObject);
  ir = RangeSignalStrengthRoomba(serialObject);
  ir1 = ir(1);
  ir2 = ir(2);
  ir3 = ir(3);
  ir4 = ir(4);
  ir5 = ir(5);
  ir6 = ir(6);

  disp([encL, encR, angle, cliff1, cliff2, cliff3, cliff4, bumpR, bumpL, bumpFront, dropL, dropR, ir1, ir2, ir3, ir4, ir5, ir6])
  stateList(i, :) = [encL, encR, angle, cliff1, cliff2, cliff3, cliff4, bumpR, bumpL, bumpFront, dropL, dropR, ir1, ir2, ir3, ir4, ir5, ir6];
    %-----------Kevin-------------------------- 
%%begin running rover
%%rover data input into MATLAB


    %%Real Time Distance Calculations
    if i == 1
        Distance(i) = 0;
        
    elseif i > 1
    
        left_wheel = stateList(i,1) - stateList(i-1,1);
        right_wheel = stateList(i,2) - stateList(i-1,2);
    
        distance = (0.036*2*3.1415926*(left_wheel+right_wheel)/(2*508.8));
   
        Distance(i) = distance;

        end 
    
%     %% Real time angle calculations
%         step_angle_change = stateList(i,3) * 0.324956;
%         MStep_Angle_Change(i) = step_angle_change;
%         if i == 1
%             MCummulative_Angle_Change(i) = MStep_Angle_Change(i);  
%         elseif i >1 
%             MCummulative_Angle_Change(i) = MCummulative_Angle_Change(i-1) + MStep_Angle_Change(i); 
%         end 
    
    %% Real time velocity of each wheel

    if i == 1
        MLeft_Wheel_Velocity(i) = 0;
        MRight_Wheel_Velocity(i) = 0;
   
    elseif i > 1
        left_wheel = stateList(i,1) - stateList(i-1,1);
        right_wheel = stateList(i,2) - stateList(i-1,2);
    
        left_wheel_distance = (0.036*2*3.1415926*(left_wheel)/(508.8));
        right_wheel_distance = (0.036*2*3.1415926*(right_wheel)/(508.8));
    
        left_wheel_velocity = left_wheel_distance / 0.5;
        right_wheel_velocity = right_wheel_distance / 0.5;
    
        MLeft_Wheel_Velocity(i) = left_wheel_velocity;
        MRight_Wheel_Velocity(i) = right_wheel_velocity;

    end
    
    %%Real time encoder counter
    if i == 1
        left_count = 0;
        right_count = 0;
        
       
    elseif i>1 
        left_count = stateList(i,1) - stateList(i-1,1);
        right_count = stateList(i,2) - stateList(i-1,2);
    
    
    MLeft_count(i) = left_count;
    MRight_count(i) = right_count;
    
    Index(i) = i;
    end 
    
    %% Movement Tracking calculations
%     if i == 1
%         
%         Md_x(1) = 0;
%         Md_y(1) = 0;
%         
%     elseif  i >0
%         cos_angle_theta = cos((MCummulative_Angle_Change(i) + MCummulative_Angle_Change(i-1))/2);
%         sin_angle_theta = sin((MCummulative_Angle_Change(i) + MCummulative_Angle_Change(i-1))/2);
%         
%         d_x = Distance(i) * cos_angle_theta;
%         d_y = Distance(i) * sin_angle_theta;
%     
%         Md_x(i) = Md_x(i-1) + d_x;
%         Md_y(i) = Md_y(i-1) + d_y;
%     end 
%     
%       %% Cliff Sensor calculations    
%     Cliff_Sensor1(i) = stateList(i,4);
%     Cliff_Sensor2(i) = stateList(i,5);
%     Cliff_Sensor3(i) = stateList(i,6);
%     Cliff_Sensor4(i) = stateList(i,7);
% 
%     if Cliff_Sensor1(i) <2000 | Cliff_Sensor2(i) <2000 | Cliff_Sensor3(i) <2000 | Cliff_Sensor4(i) <2000
%         Cliff(i) = 1
%     else 
%         Cliff(i) = 0
%     end 
    %% Bump and Drop Sensor calculations
    Bump_Sensor1(i) = stateList(i,8);
    Bump_Sensor2(i) = stateList(i,9);
    Bump_Sensor3(i) = stateList(i,10);
    Drop_Sensor1(i) = stateList(i,11);
    Drop_Sensor2(i) = stateList(i,12);

    if Bump_Sensor1(i) ==1 | Bump_Sensor2(i) ==1 | Bump_Sensor3(i) ==1 | Drop_Sensor1(i) == 1 | Drop_Sensor2(i) == 1
        Bump_Drop(i) = 1
    else 
        Bump_Drop(i) = 0
    end 
    
    %% Wall Sensor calculations
    Wall_Sensor1(i) = stateList(i,13);
    Wall_Sensor2(i) = stateList(i,14);
    Wall_Sensor3(i) = stateList(i,15);
    Wall_Sensor4(i) = stateList(i,16);
    Wall_Sensor5(i) = stateList(i,17);
    Wall_Sensor6(i) = stateList(i,18);

    if Wall_Sensor1(i) > 50 | Wall_Sensor2(i) > 50 |  Wall_Sensor3(i) > 50 | Wall_Sensor4(i) > 50 |  Wall_Sensor5(i) > 50 |  Wall_Sensor6(i) > 50
        Wall(i) = 1
    else 
        Wall(i) = 0
    end 



   %----------kevin end--------------------------- 
    
    
    
  FileInfo = dir('C:\Users\andre\PycharmProjects\irobot\RobotWebsite\test.csv');
    TimeStamp2 = FileInfo.date;


              
  pause(0.25)

 end
 
end

figure
plot(Index,Distance);
title('Distance moved by rover every 0.5s');

figure
plot(Index, MStep_Angle_Change);
title('Angle change per 0.5 seconds');

figure
plot(Index,MCummulative_Angle_Change);
title('Cummulative angle change');

figure
plot(Index, MLeft_Wheel_Velocity);
title('Left wheel velocity');

figure
plot(Index, MRight_Wheel_Velocity);
title('right wheel velocity');

figure
plot(Index, MRight_count);
title('Right wheel encoder count');

figure
plot(Index,MLeft_count);
title('left wheel encoder count');

figure
plot(Md_x, Md_y); 
title('Real_Time_Movement_Tracking');


figure
plot (Index,Cliff);
title('cliff sensor, if at 1 then at cliff');

figure
plot (Index,Bump_Drop);
title('Bump and Drop sensor, if at 1 then it is bumped or the wheels have falled down');

figure
plot (Index,Wall);
title('Wall sensor, if at 1 then it has detected a wall in front');

save('roomba_integrate.mat', 'stateList');

% stop the robot (turning radius doesn’t matter, inf is straight )
SetFwdVelRadiusRoomba(serialObject, 0, inf);

[FinishLeftCounts, FinishRightCounts] = EncoderSensorsRoomba(serialObject)
Distance = (0.036*2*pi)*((FinishLeftCounts - StartLeftCounts) + ...
                         (FinishRightCounts - StartRightCounts) )/( 2 *508.8);

% Power down when finished,
% note physical power button is disabled

PowerOffRoomba(serialObject)
fclose(serialObject)