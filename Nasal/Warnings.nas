### Citation X ###
### Christian Le Moigne - 2015 ###

### msg level 0 = white 					###
### msg level 1 = cyan 						###
### msg level 2 = caution = amber ###
### msg level 3 = alert = red 		###

### ANNUNCIATORS ###
var Annun = props.globals.getNode("instrumentation/annunciators",1);
var MstrWarning =Annun.getNode("master-warning",1);
var WarningAck = Annun.getNode("ack-warning",1);
var MstrCaution = Annun.getNode("master-caution",1);
var Warn = Annun.getNode("warning",1);
var Caution = Annun.getNode("caution",1);
var CautionAck = Annun.getNode("ack-caution",1);
aircraft.light.new("instrumentation/annunciators", [0.5, 0.5], MstrCaution);
aircraft.light.new("instrumentation/annunciators", [0.5, 0.5], MstrWarning);

var annun_init = func {
	  MstrWarning.setBoolValue(0);
    MstrCaution.setBoolValue(0);
		WarningAck.setBoolValue(0);
		CautionAck.setBoolValue(0);
		Caution.setBoolValue(0);
		Warn.setBoolValue(0);
};
	
setlistener("/sim/signals/fdm-initialized", func {
    annun_init();
});

setlistener("/sim/signals/reinit", func {
    annun_init();
},0,0);

var EICAS = {
    new : func {
         m = { parents : [EICAS]};
 
			m.eicas = props.globals.initNode("instrumentation/eicas/");
			m.serviceable = m.eicas.initNode("serviceable", 1,"BOOL");
			m.warn_l0 = m.eicas.initNode("level-0"," ","STRING");
			m.warn_l1 = m.eicas.initNode("level-1"," ","STRING");
			m.warn_l2 = m.eicas.initNode("level-2"," ","STRING");			
			m.warn_l3 = m.eicas.initNode("level-3"," ","STRING");

		return m
		},

		init : func {	
			### SET LISTENERS ###
			setlistener("controls/engines/engine[0]/cutoff", func {
					EICAS.update_listeners()},1,0);
			setlistener("controls/engines/engine[1]/cutoff", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/gear/brake-parking", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/electric/APU-generator", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/electric/external-power", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/cabin-door/open", func {
				EICAS.update_listeners()},1,0);
			setlistener("position/altitude-ft", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/fuel/tank[0]/boost-pump", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/fuel/tank[1]/boost-pump", func {
				EICAS.update_listeners()},1,0);
			setlistener("consumables/fuel/tank[0]/level-lbs", func {
				EICAS.update_listeners()},1,0);
			setlistener("consumables/fuel/tank[1]/level-lbs", func {
				EICAS.update_listeners()},1,0);
			setlistener("consumables/fuel/tank[2]/level-lbs", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/engines/engine[0]/feed_tank", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/engines/engine[1]/feed_tank", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/electric/engine[0]/generator", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/electric/engine[1]/generator", func {
				EICAS.update_listeners()},1,0);
			setlistener("systems/hydraulics/psi-norm[0]", func {
				EICAS.update_listeners()},1,0);
			setlistener("systems/hydraulics/psi-norm[1]", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/flight/speedbrake", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/electric/APU-generator", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/flight/flaps", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/engines/engine[0]/throttle", func {
				EICAS.update_listeners()},1,0);
			setlistener("controls/engines/engine[1]/throttle", func {
				EICAS.update_listeners()},1,0);
			setlistener("gear/gear[0]/wow", func {
				EICAS.update_listeners()},1,0);

				me.ann_warning = 0;
				me.ann_caution = 0;
		},

		update_listeners : func {
				me.eng0_shutdown = getprop("controls/engines/engine[0]/cutoff");
				me.eng1_shutdown = getprop("controls/engines/engine[1]/cutoff");
				me.parkbrake = getprop("controls/gear/brake-parking");
				me.apu_running = getprop("controls/electric/APU-generator");
				me.ext_pwr = getprop("controls/electric/external-power");
				me.cabin_door = getprop("controls/cabin-door/open");
				me.altitude = getprop("position/altitude-ft");
				me.boost_pump_L = getprop("controls/fuel/tank[0]/boost-pump");
				me.boost_pump_R = getprop("controls/fuel/tank[1]/boost-pump");
				me.level_tank_L = getprop("consumables/fuel/tank[0]/level-lbs");
				me.level_tank_R = getprop("consumables/fuel/tank[1]/level-lbs");
				me.level_tank_C = getprop("consumables/fuel/tank[2]/level-lbs");
				me.xfeed_L = getprop("controls/engines/engine[0]/feed_tank");
				me.xfeed_R = getprop("controls/engines/engine[1]/feed_tank");
				me.gen_L = getprop("controls/electric/engine[0]/generator");
				me.gen_R = getprop("controls/electric/engine[1]/generator");
				me.oil_L = getprop("systems/hydraulics/psi-norm[0]");
				me.oil_R = getprop("systems/hydraulics/psi-norm[1]");
				me.speedbrake = getprop("controls/flight/speedbrake");
				me.flaps = getprop("controls/flight/flaps");
				me.throttle_L = getprop("controls/engines/engine[0]/throttle");
				me.throttle_R = getprop("controls/engines/engine[1]/throttle");
				me.wow = getprop("gear/gear[0]/wow");
		},

		update : func {
	    me.enabled = (getprop("systems/electrical/outputs/efis") and
                            (getprop("sim/freeze/replay-state")!=1) and
                            me.serviceable.getValue());
			me.MWarning = "instrumentation/annunciators/master-warning";
			me.MWarn = "instrumentation/annunciators/warning";
			me.ack_warning = "instrumentation/annunciators/ack-warning";
			me.MCaution = "instrumentation/annunciators/master-caution";
			me.MCaut = "instrumentation/annunciators/caution";
			me.ack_caution = "instrumentation/annunciators/ack-caution";
			me.state = getprop("instrumentation/annunciators/state");
      me.msg_l0 = [];
			me.msg_l1 = [];
			me.msg_l2 = [];
			me.msg_l3 = [];
			me.MstrCaution = 0;
			me.MstrWarning = 0;

			if (me.enabled) {		

			### lEVEL 3 ###
				if (me.altitude > 51000) {
          append(me.msg_l3,"CABIN ALTITUDE");
					me.MstrWarning +=1;
				}
				if (!me.gen_L and !me.gen_R) {			
         	append(me.msg_l3,"GEN OFF L-R");
					me.MstrWarning +=1;
				}
				if (me.oil_L < 0.080 and me.oil_R < 0.080) {
          append(me.msg_l3,"OIL PRESS LOW L-R");
					me.MstrWarning +=2;
				}	else if(me.oil_L < 0.4) {
          append(me.msg_l3,"OIL PRESS LOW L");
					me.MstrWarning +=1;
				}	else if(me.oil_R < 0.4) {
          append(me.msg_l3,"OIL PRESS LOW R");
					me.MstrWarning +=1;
				}
				if(me.wow and !me.eng0_shutdown and !me.eng1_shutdown and (
					me.throttle_L	< 0.8
					or me.throttle_R < 0.8
					or me.ext_pwr
					or me.flaps < 0.140
					or me.flaps > 0.430
					or me.speedbrake
					or me.parkbrake
					or me.level_tank_C <=10)) {
					append(me.msg_l3,"NO TAKEOFF");
					me.MstrWarning +=1;
				}			


			### LEVEL 2 ###
				if(!me.gen_L and me.gen_R) {
         	append(me.msg_l2,"GEN OFF L");
					me.MstrCaution +=1;
				}	else if(!me.gen_R and me.gen_L) {
          append(me.msg_l2,"GEN OFF R");;
					me.MstrCaution +=1;
				}
				if (me.cabin_door) {
          append(me.msg_l2,"CABIN DOOR OPEN");
					me.MstrCaution +=1;
				}
				if (me.altitude > 50000) {
          append(me.msg_l2,"CABIN ALTITUDE");
					me.MstrCaution +=1;
				}
				if (me.level_tank_L < 500 and me.level_tank_R < 500) {
          append(me.msg_l2,"FUEL LEVEL L-R");
					me.MstrCaution +=2;
				}	else if( me.level_tank_L < 500) {
          append(me.msg_l2,"FUEL LEVEL L");
					me.MstrCaution +=1;
				}	else if( me.level_tank_R < 500) {
          append(me.msg_l2,"FUEL LEVEL R");
					me.MstrCaution +=1;
				}
				if (me.speedbrake and me.altitude < 500) {
          append(me.msg_l2,"SPEEDBRAKES");
					me.MstrCaution +=1;
				}

			### LEVEL 1 ###
				if (me.eng0_shutdown and me.eng1_shutdown){
					append(me.msg_l1,"ENG SHUTDWN L-R");
				} else if (me.eng0_shutdown) {
						append(me.msg_l1,"ENG SHUTDWN L");
				}	else if (me.eng1_shutdown) {
						append(me.msg_l1,"ENG SHUTDWN R");
				}
				if (me.parkbrake) {
					append(me.msg_l1,"PARK BRK SET");
				}
				if(me.wow and (me.throttle_L	< 0.8 or me.throttle_R < 0.8)) {
					append(me.msg_l1,"NO TAKEOFF");
				}			

			### LEVEL 0 ###
				if (me.apu_running) {
          append(me.msg_l0,"APU RUNNING");
				}
				if (me.boost_pump_L and me.boost_pump_R) {
          	append(me.msg_l0,"BOOST PUMP L-R");
				}	else if (me.boost_pump_L) {
          	append(me.msg_l0,"BOOST PUMP L");
				}	else if (me.boost_pump_R) {
          	append(me.msg_l0,"BOOST PUMP R");
				}
				if (me.xfeed_L or me.xfeed_R) {
          	append(me.msg_l0,"FUEL XFEED OPEN");
				}

		### OUTPUT TO EICAS ###
				var msg = "";
				var msg0 = "               \n";
				var msg_tmp = "";
				
				### LEVEL 3 ###
        for(var i=0; i<size(me.msg_l3); i+=1) {
            msg = msg ~ me.msg_l3[i] ~ "\n";
						msg_tmp = msg_tmp~msg0;				
        }
        me.warn_l3.setValue(msg);

				### LEVEL 2 ###
				msg = msg_tmp;
        for(var i=0; i<size(me.msg_l2); i+=1) {
            msg = msg_tmp ~ me.msg_l2[i] ~ "\n";
						msg_tmp = msg_tmp~msg0;			
        }
				me.warn_l2.setValue(msg);

				### LEVEL 1 ###
				msg = msg_tmp;
        for(var i=0; i<size(me.msg_l1); i+=1) {
            msg = msg ~ me.msg_l1[i] ~ "\n";
						msg_tmp = msg_tmp~msg0;	
        }
				me.warn_l1.setValue(msg);

				### LEVEL 0 ###
				msg = msg_tmp;
        for(var i=0; i<size(me.msg_l0); i+=1) {
            msg = msg ~ me.msg_l0[i] ~ "\n";
						msg_tmp = msg_tmp~msg0;	 
       	}
        me.warn_l0.setValue(msg);
				
		### OUTPUT TO ANNUNCIATORS ###

				### WARNING ###
				if (me.MstrWarning == 0) {
					setprop(me.MWarning,0);
					setprop(me.MWarn,0);										
					setprop(me.ack_warning,0);
				} 
				else if (me.MstrWarning > me.ann_warning) {
					setprop(me.MWarning,1);
					setprop(me.MWarn,me.state);
					setprop(me.ack_warning,0);
				} else {
					setprop(me.MWarning,1);
					setprop(me.MWarn,me.state);														
					if (getprop(me.ack_warning) ==1) {
						setprop(me.MWarn,1);
					}
				}
				me.ann_warning = me.MstrWarning;		

				### CAUTION ###
				if (me.MstrCaution == 0) {
					setprop(me.MCaution,0);
					setprop(me.MCaut,0);										
					setprop(me.ack_caution,0);
				} 
				else if (me.MstrCaution > me.ann_caution) {
					setprop(me.MCaution,1);
					setprop(me.MCaut,me.state);
					setprop(me.ack_caution,0);
				} else {
					setprop(me.MCaution,1);
					setprop(me.MCaut,me.state);														
					if (getprop(me.ack_caution) ==1) {
						setprop(me.MCaut,1);
					}
				}
				me.ann_caution = me.MstrCaution;		



			}
			settimer(func {me.update();},0);
		},

};

### STALL HORN ###
var stall_horn = func{
    var alert=0;
    var kias=getprop("velocities/airspeed-kt");
    if(kias>150){setprop("sim/sound/stall-horn",alert);return;};
    var wow1=getprop("gear/gear[1]/wow");
    var wow2=getprop("gear/gear[2]/wow");
    if(!wow1 or !wow2){
        var grdn=getprop("controls/gear/gear-down");
        var flap=getprop("controls/flight/flaps");
        if(kias<100){
            alert=1;
        }elsif(kias<120){
            if(!grdn )alert=1;
        }else{
            if(flap==0)alert=1;
        }
    }
    setprop("sim/sound/stall-horn",alert);
		settimer(stall_horn,0);
}

### MAIN ###
var alarms = EICAS.new();
	setlistener("/sim/signals/fdm-initialized", func {
		alarms.init();
		alarms.update();	
    stall_horn();
	},0,0);