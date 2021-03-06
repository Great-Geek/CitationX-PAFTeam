#==========================================================
# Citation X - PFD Canvas
# Christian Le Moigne (clm76) Feb 2019
# =========================================================

var AltDiff = "instrumentation/pfd/target-altitude-diff";
var AltFt = "/instrumentation/altimeter/indicated-altitude-ft";
var AltMeters = "/instrumentation/efis/alt-meters";
var AltTrd = "/instrumentation/pfd/alt-trend-ft";
var ApAlt = "/autopilot/locks/altitude";
var ApHarmed = "/autopilot/locks/heading-arm";
var ApHeading = "/autopilot/locks/heading";
var ApStatus = "/autopilot/locks/AP-status";
var ApVarmed = "/autopilot/locks/altitude-arm";
var Asel = "/autopilot/settings/asel";
var Baro = "/instrumentation/altimeter/setting-inhg";
var BaroMode = "/instrumentation/efis/baro-hpa";
var crsDefl_fms = "autopilot/internal/course-deflection";
var crsDefl_nav = ["instrumentation/nav/heading-needle-deflection",
                   "instrumentation/nav[1]/heading-needle-deflection"];
var crsOffset = "autopilot/internal/course-offset";
var DmeDst = ["/instrumentation/dme/indicated-distance-nm",
              "/instrumentation/dme[1]/indicated-distance-nm"];
var DmeID = ["/instrumentation/dme/dme-id",
             "/instrumentation/dme[1]/dme-id"];
var DmeIR = ["/instrumentation/dme/in-range",
             "/instrumentation/dme[1]/in-range"];
var dispCtrl = ["/systems/electrical/outputs/disp-cont1",
                "/systems/electrical/outputs/disp-cont2"];
var fmsSet = "autopilot/settings/fms";
var FmsAltDsp = "/autopilot/settings/tg-alt-ft";
var FromFlag = ["instrumentation/nav/from-flag",
                 "instrumentation/nav[1]/from-flag"];
var GsDefl = "/autopilot/internal/gs-deflection";
var GsInRange = "/autopilot/internal/gs-in-range";
var Hdg = "/autopilot/settings/heading-bug-deg";
var Heading = "/orientation/heading-magnetic-deg";
var HeadingBug = "/autopilot/internal/heading-bug-error-deg";
var hold_active = "autopilot/locks/hold/active";
var Iac = ["/systems/electrical/outputs/iac1",
           "/systems/electrical/outputs/iac2"];
var Ias = "/velocities/airspeed-kt";
var InRange = "/autopilot/internal/in-range";
var Mach = "/velocities/mach";
var Marker_i = "/instrumentation/marker-beacon/inner";
var Marker_m = "/instrumentation/marker-beacon/middle";
var Marker_o = "/instrumentation/marker-beacon/outer";
var MinDiff = "/instrumentation/pfd/minimum-diff";
var MinimumsMode = "/autopilot/settings/minimums-mode";
var MinimumsValue = "/autopilot/settings/minimums";
var navErr = ["autopilot/internal/nav1-heading-error-deg",
              "autopilot/internal/nav2-heading-error-deg"];
var NavDist = "/autopilot/internal/nav-distance";
var NavId = "/autopilot/internal/nav-id";
var nav_inRange = ["instrumentation/nav/in-range",
                   "instrumentation/nav[1]/in-range"];
var Nav1Ptr = "/autopilot/internal/nav1-pointer";
var Nav2Ptr = "/autopilot/internal/nav2-pointer";
var NavPtr1 = "/instrumentation/sc840/nav1ptr";
var NavPtr2 = "/instrumentation/sc840/nav2ptr";
var NavSrc = "/autopilot/settings/nav-source";
var NavType = "/autopilot/internal/nav-type";
var PfdHsi = ["/instrumentation/dc840/hsi",
              "/instrumentation/dc840[1]/hsi"];
var pfdOffset = ["instrumentation/pfd/course-offset",
                 "instrumentation/pfd[1]/course-offset"];
var PfdSel = "instrumentation/pfd/madc";
var PitchBars = "/autopilot/internal/pitch-bars";
var PitchDeg = "/orientation/pitch-deg";
var RollBars = "/autopilot/internal/roll-bars";
var RollDeg = "/orientation/roll-deg";
var SelAlt = "/autopilot/settings/altitude-setting-ft";
var SelCrs = ["instrumentation/nav/radials/selected-deg",
              "instrumentation/nav[1]/radials/selected-deg"];
var SelHdg = "/autopilot/settings/heading-bug-deg";
var SgRev = "/instrumentation/eicas/sg-rev";
var sgTest = ["instrumentation/reversionary/sg-test",
              "instrumentation/reversionary/sg-test[1]"];
var spd_ctrl = "/autopilot/locks/speed-ctrl";
var SpdTgKt = "/autopilot/settings/target-speed-kt";
var SpdTgMc = "/autopilot/settings/target-speed-mach";
var SpdTrd = "/instrumentation/pfd/speed-trend-kt";
var StallDiff = "/instrumentation/pfd/stall-diff";
var ToFlag = ["instrumentation/nav/to-flag",
                 "instrumentation/nav[1]/to-flag"];
var V1 = "/controls/flight/v1";
var V2 = "/controls/flight/v2";
var VA = "/controls/flight/va";
var VE = "/controls/flight/ve";
var VR = "/controls/flight/vr";
var Vf = "/controls/flight/flaps-select";
var Vne = "/instrumentation/pfd/max-airspeed-kts";
var Vref = "/controls/flight/vref";
var Vert_spd = "/autopilot/internal/vert-speed-fpm";
var alt = nil;
var alt_corr = nil;
var alt_diff = nil;
var alt_trend = nil;
var crs_defl = nil;
var crs_offset = nil;
var disp_cont = [nil,nil];
var dme_ind = nil;
var fms = 0;
var from_flag = [0,0];
var gs_defl = nil;
var hdg = nil;
var hdg_bug = nil;
var ias = nil;
var ias_corr = nil;
var loc_defl = nil;
var min_diff = nil;
var n = nil;
var pfd_hsi = [0,0];
var spd_trend = nil;
var to_flag = [0,0];
var v_dis = nil;
var Vflaps = nil;
var v_ind = nil;
var v_spd = nil;
var wow = nil;

var roundToNearest = func(n, m) {
	var x = int(n/m)*m;
	if((math.fmod(n,m)) > (m/2))
			x = x + m;
	return x;
}

var PFDDisplay = {
  COLORS : {
      green : [0, 1, 0],
      white : [1, 1, 1],
      black : [0, 0, 0],
      lightblue : [0, 1, 1],
      darkblue : [0, 0, 1],
      red : [1, 0, 0],
      magenta : [1, 0, 1],
      orange : [1,0.4,0],
      yellow : [1,1,0]
  },

	new: func(x) {
		var m = {parents: [PFDDisplay]};
    var font_mapper = func (family, weight) {
      if (weight == "bold") return "LiberationFonts/LiberationSans-Bold.ttf";
      else return "LiberationFonts/LiberationSansNarrow-Bold.ttf";
		}
    if(!x) {
	    m.canvas = canvas.new({
		    "name": "PFD_L", 
		    "size": [1024, 1024],
		    "view": [900, 1024],
		    "mipmapping": 1 
	    });
	    m.canvas.addPlacement({"node": "screenL"});
    } else {
	    m.canvas = canvas.new({
		    "name": "PFD_R", 
		    "size": [1024, 1024],
		    "view": [900, 1024],
		    "mipmapping": 1 
	    });
	    m.canvas.addPlacement({"node": "screenR"});
    }
	    m.pfd = m.canvas.createGroup();
		  canvas.parsesvg(m.pfd, "/Models/Instruments/PFD/pfd.svg", {'font-mapper': font_mapper});

    m.AltTrend = m.pfd.createChild("path");
    m.AltTrend.setColorFill(me.COLORS.magenta);

    m.Alt = {};
    m.Alt_keys = ["Alt11100","AltTape","AltLadder","BAROtext",
                  "AltSelText","AltSel00","MinMode","MinValue",
                  "MinBug","AltBug","IaBg"];
    foreach(var i;m.Alt_keys) m.Alt[i] = m.pfd.getElementById(i);

    m.Hor = {};
    m.Hor_keys = ["Horizon","Vbars","BankPtr","GsIls","GsScale",
                  "LocDefl","LocScale"];
    foreach(var i;m.Hor_keys) m.Hor[i] = m.pfd.getElementById(i);

    m.SpdTrend = m.pfd.createChild("path");
    m.SpdTrend.setColorFill(me.COLORS.green);

    m.Spd = {};
    m.Spd_keys = ["SpdTape","CurSpd","CurSpdTen","TgSpd","Vmo",
                  "Vstall","LocScale","IasBg","BottomRect","ER21",
                  "Ind1","Ind2","IndR","IndE","SPEED","SpdBackground"];
    foreach(var i;m.Spd_keys) m.Spd[i] = m.pfd.getElementById(i);

    m.Hsi = {};
    m.Hsi_keys = ["Rose","Ptr1","Ptr2","CrsDeflect","CrsNeedle","scale",
                  "HdgBug","To","From","COMPASS","Lh","Lb","Fl"];
    foreach(var i;m.Hsi_keys) m.Hsi[i] = m.pfd.getElementById(i);

    m.Hsi1 = {};
    m.Hsi1_keys = ["Rose1","Ptr11","Ptr21","CrsDeflect1","CrsNeedle1","scale1",
                  "HdgBug1","To1","From1","COMPASS1","ArrowL","ArrowR",
                  "Lh1","Lb1","Fl1"];
    foreach(var i;m.Hsi1_keys) m.Hsi1[i] = m.pfd.getElementById(i);

    m.Txt = {};
    m.Txt_keys = ["NavType","NavId","NavDst","Ptr1Ind","Ptr1Txt",
                  "Ptr2Ind","Ptr2Txt","HdgVal","DtkVal","McVal",
                  "AltMet","ApStat","ApVert","ApLat","ApVarm",
                  "ApLarm","MarkerI","MarkerM","MarkerO","Dme","DmeId",
                  "DmeDist","FmsAlt"];
    foreach(var i;m.Txt_keys) m.Txt[i] = m.pfd.getElementById(i);

    m.Fail  = {};
    m.Fail_keys = ["HorizScale","HorizGnd","AttFail","HdgFail","HdgFailCross",
                   "HdgFailCross1","MadcFail"];
    foreach(var i;m.Fail_keys) m.Fail[i] = m.pfd.getElementById(i);

    m.Vspd = {};
    m.Vspd_keys = ["Arrow","VSpdVal","VSpdInd"];
    foreach(var i;m.Vspd_keys) m.Vspd[i] = m.pfd.getElementById(i);
    m.Vspd.Arrow.setCenter(900,792);

    m.Sg = {};
    m.Sg_keys = ["sg","sgTxt","sgCdr"];
    foreach(var i;m.Sg_keys) m.Sg[i] = m.pfd.getElementById(i);
    m.Sg.sg.hide();

    m.SpdVal = [V1,V2,VR,VA,VE,Vref,Vflaps];
    m.SpdInks = [];
      append(m.SpdInks,m.pfd.getElementById("v1"));
      append(m.SpdInks,m.pfd.getElementById("v2"));
      append(m.SpdInks,m.pfd.getElementById("vr"));
      append(m.SpdInks,m.pfd.getElementById("va"));
      append(m.SpdInks,m.pfd.getElementById("ve"));
      append(m.SpdInks,m.pfd.getElementById("vref"));
      append(m.SpdInks,m.pfd.getElementById("vf"));
      append(m.SpdInks,m.pfd.getElementById("vfTxt"));

    m.pfdSelL = m.pfd.getElementById("pfdSelL");
    m.pfdSelR = m.pfd.getElementById("pfdSelR");

    m.Nav1Ptr = ["","VOR1","ADF1","FMS1"];
    m.Nav2Ptr = ["","VOR2","ADF2","FMS2"];

    ### Horizon center ###
		m.h_trans = m.Hor.Horizon.createTransform();
		m.h_rot = m.Hor.Horizon.createTransform();

    ### Clips : top, right, bottom, left ###
    m.Alt.AltTape.set("clip", "rect(113,850,564,710)");
    m.Alt.AltLadder.set("clip", "rect(297,845,382,800)");
		m.Hor.Horizon.set("clip", "rect(150, 610, 525, 270)");
    m.Spd.SpdTape.set("clip", "rect(113, 200, 560, 10)");
    m.Spd.CurSpdTen.set ("clip", "rect(288, 200, 388, 100)");
    m.Spd.Vmo.set ("clip", "rect(113, 200, 340, 100)");
    m.Spd.Vstall.set ("clip", "rect(300, 200, 561, 100)");

    ### Electrical init ###
    me.radioAlt_enabled = 1;
    me.dme_enabled = 1;    
    me.atthdg_enabled = 1;
    me.atthdgAux_enabled = 1;
    me.madc_enabled = 1;

    nav_dev = getprop("autopilot/internal/nav1-course-error");

    return m;
  }, # end of new

  listen : func(x) {

      ##### Electrical #####
		setlistener("systems/electrical/outputs/radio-alt1",func (n) {
      me.radioAlt_enabled = n.getValue();
    },0,0);

		setlistener("systems/electrical/outputs/att-hdg"~(x+1),func (n) {
      me.atthdg_enabled = n.getValue();
    },0,0);

		setlistener("systems/electrical/outputs/att-hdg-aux"~(x+1),func (n) {
      me.atthdgAux_enabled = n.getValue();
    },0,0);

		setlistener("systems/electrical/outputs/madc"~(x+1),func (n) {
      me.madc_enabled = n.getValue();
      me.Fail.MadcFail.setVisible(!me.madc_enabled or getprop(sgTest[x]));
      me.Alt.AltTape.setVisible(me.madc_enabled);
      me.Alt.AltBug.setVisible(me.madc_enabled);
      me.Alt.IaBg.setVisible(me.madc_enabled);
      me.Alt.Alt11100.setVisible(me.madc_enabled);
      me.Alt.AltLadder.setVisible(me.madc_enabled);
      me.Spd.SPEED.setVisible(me.madc_enabled);
      me.Spd.SpdBackground.show();
    },0,0);

		setlistener("systems/electrical/outputs/dme"~(x+1),func (n) {
      me.dme_enabled = n.getValue();
      me.dme_color = n.getValue() ? [1,0,0] : [1,0,1];
    },0,0);

      ##### Others #####

		setlistener(MinimumsMode, func(n) {	
			me.Alt.MinMode.setText(n.getValue());
		},1,0);

		setlistener(MinimumsValue, func(n) {	
			me.Alt.MinValue.setText(sprintf("%.0f",n.getValue()));
		},1,0);

		setlistener(BaroMode, func(n) {
      if (n.getValue()) me.Alt.BAROtext.setText(sprintf("%.2f", getprop("instrumentation/altimeter/setting-inhg")));
      else me.Alt.BAROtext.setText(sprintf("%.0f", getprop("instrumentation/altimeter/setting-hpa")));
		},1,0);

		setlistener(Asel, func(n) {
      me.Alt.AltSelText.setText(sprintf("%.0f",n.getValue()));
		},1,0);

		setlistener("/gear/gear[1]/wow", func(n) {
      wow = n.getValue();
		},1,0);

		setlistener(Vf, func(n) {
      if (n.getValue() == 2) {
        me.SpdVal[6] = 180; me.SpdInks[7].setText("FS5");
      } else if (n.getValue() == 3) {
          me.SpdVal[6] = 160; me.SpdInks[7].setText("F15");
      } else if (n.getValue() == 4) {
          me.SpdVal[6] = 140; me.SpdInks[7].setText("F35");
      } else {
          me.SpdVal[6] = 500; me.SpdInks[7].hide # to be out of display range
      }
		},1,0);

    setlistener(fmsSet,func(n) {
      fms = n.getValue();
    },1,0);

		setlistener(ToFlag[x], func(n) {
      to_flag[x] = n.getValue();
    },1,0);

		setlistener(FromFlag[x], func(n) {
      from_flag[x] = n.getValue();
    },1,0);

		setlistener(PfdHsi[x], func(n) {
      pfd_hsi[x] = n.getValue();
    },1,0);

		setlistener(NavType, func(n) {
      me.Txt.NavType.setText(n.getValue());
    },1,0);

		setlistener(NavId, func(n) {
      me.Txt.NavId.setText(n.getValue());
    },1,0);

		setlistener(SelCrs[x], func(n) {
      me.Txt.DtkVal.setText(sprintf("%03i",n.getValue()));
    },1,0);

		setlistener(Hdg, func(n) {
      me.Txt.HdgVal.setText(sprintf("%03i",n.getValue()));
    },1,0);

		setlistener(ApStatus, func(n) {
      if (n.getValue()!="") me.Txt.ApStat.setText(n.getValue()).show();
      else me.Txt.ApStat.setText(n.getValue()).hide();
    },1,0);

		setlistener(ApHeading, func(n) {
      me.Txt.ApLat.setText(n.getValue());
    },1,0);

		setlistener(ApAlt, func(n) {
      me.Txt.ApVert.setText(n.getValue());
    },1,0);

		setlistener(ApHarmed, func(n) {
      me.Txt.ApLarm.setText(n.getValue());
    },1,0);

		setlistener(ApVarmed, func(n) {
      me.Txt.ApVarm.setText(n.getValue());
    },1,0);

		setlistener(dispCtrl[x], func(n) {
      disp_cont[x] = n.getValue();
    },0,0);

		setlistener(NavSrc, func(n) {
      if (!fms) {
        me.Hsi.CrsNeedle.setColor(me.COLORS.green);
        me.Hsi.Fl.setColorFill(me.COLORS.green);
        me.Hsi.To.setColorFill(me.COLORS.green);
        me.Hsi.From.setColorFill(me.COLORS.green);
        me.Hsi1.CrsNeedle1.setColor(me.COLORS.green);
        me.Hsi1.Fl1.setColorFill(me.COLORS.green);
        me.Hsi1.To1.setColorFill(me.COLORS.green);
        me.Hsi1.From1.setColorFill(me.COLORS.green);
      } else {
        me.Hsi.CrsNeedle.setColor(me.COLORS.magenta);
        me.Hsi.Fl.setColorFill(me.COLORS.magenta);
        me.Hsi1.CrsNeedle1.setColor(me.COLORS.magenta);
        me.Hsi1.Fl1.setColorFill(me.COLORS.magenta);
      }
    },1,0);

    setlistener(PfdSel,func(n) {
      me.pfdSelL.setVisible(!n.getValue());
      me.pfdSelR.setVisible(n.getValue());
    },1,0);

    setlistener(sgTest[x],func(n) {
      me.Txt.ApStat.setText("AP").setVisible(n.getValue());
      me.Fail.MadcFail.setVisible(n.getValue());
    },0,0);
  }, # end of listen

  update_PFD : func(x) {
    if (fms) setprop(pfdOffset[x],getprop(crsOffset) or 0);
    else if (getprop(ApHeading) == "LOC") setprop(pfdOffset[x],getprop(navErr[x]));
    else setprop(pfdOffset[x],geo.normdeg(getprop(SelCrs[x])-getprop(Heading)));
    me.update_ALT();
    me.update_HOR(x);
    me.update_SPD();
    me.update_HSI(x);
    me.update_VSP();
    me.update_DME();
    me.update_Markers(x);
    me.update_Iac(x);
		settimer(func {me.update_PFD(x);},0.1);
  }, # end of update_PFD

  update_ALT : func {
    if (!me.madc_enabled) return;
    else {
      alt = getprop(AltFt);
      alt_corr = int(roundToNearest(alt/100,0.1));
      if (me.radioAlt_enabled) {
        me.Alt.Alt11100.setText(sprintf("%03.0f",alt_corr)).setColor(0,1,0);
        me.Alt.IaBg.setColor(1,1,1);
      } else {
        me.Alt.Alt11100.setText("RA").setColor(1,0,0);
        me.Alt.IaBg.setColor(1,0,0);
      }
	    me.Alt.AltTape.setTranslation(0,alt*0.284)
                    .setVisible(me.radioAlt_enabled);
      me.Alt.AltLadder.setTranslation(0,math.fmod(alt,100) * 1.24)
                      .setVisible(me.radioAlt_enabled);

      ### Altitude Diff ###
      alt_diff = -0.280 * (getprop(AltDiff) or 0);
      alt_diff = math.clamp(alt_diff,-170,170);
	    me.Alt.AltBug.setTranslation(0,alt_diff)
                   .setVisible(me.radioAlt_enabled);
      ### Altitude Trend (look ahead 6s) ###
      alt_trend = 0.36 * (getprop(AltTrd) or 0);
      alt_trend = math.clamp(alt_trend, -225, 225);
      me.AltTrend.reset()
                 .rect(705,338,12,-alt_trend)
                 .setVisible(me.radioAlt_enabled);
      ### Minimums ###
      min_diff = getprop(MinDiff) or 0;
      me.Alt.MinBug.setColor(min_diff > 0 ? me.COLORS.orange : me.COLORS.green);
      me.Alt.MinBug.setTranslation(0, min_diff * -0.174);
      if (min_diff <= -600) me.Alt.MinBug.hide();
      else me.Alt.MinBug.setVisible(me.radioAlt_enabled);

      ### Alt Meters ###
      if (getprop(AltMeters)) {
        me.Txt.AltMet.setText(sprintf("%03i",alt*0.3048)~"M")
                     .setVisible(me.radioAlt_enabled);
      } else me.Txt.AltMet.hide();

       ### Fms Target Altitude ###
      if (getprop(NavSrc) == "FMS1" or getprop(NavSrc) == "FMS2") {
          me.Txt.FmsAlt.setText(sprintf("%.0f",getprop(FmsAltDsp))).show();
      } else me.Txt.FmsAlt.hide();

    }
     ### Baro ###
      if (getprop(BaroMode)) me.Alt.BAROtext.setText(sprintf("%.2f", getprop(Baro)));
      else me.Alt.BAROtext.setText(sprintf("%.0f", getprop("instrumentation/altimeter/setting-hpa")));

  }, # end of update_ALT

  update_HOR : func(x) {
    if (me.atthdg_enabled and me.atthdgAux_enabled) {
      me.Fail.AttFail.setVisible(getprop(sgTest[x]));
      me.Fail.HorizScale.show();
      me.Fail.HorizGnd.show();
		  me.h_trans.setTranslation(0,getprop(PitchDeg)*7.5);
		  me.h_rot.setRotation(-getprop(RollDeg)*D2R,me.Hor.Horizon.getCenter());
      me.Hor.BankPtr.setRotation(-getprop(RollDeg)*D2R);
      if (getprop("/autopilot/locks/FD-status")) {
        me.Hor.Vbars.show();
        me.Hor.Vbars.setTranslation(0,(getprop(PitchBars)-getprop(PitchDeg))*-5.711);
        me.Hor.Vbars.setRotation((getprop(RollBars)-getprop(RollDeg))*D2R);
      } else me.Hor.Vbars.hide();

      if (getprop(GsInRange) and getprop(InRange) and !getprop("/gear/gear[1]/wow")) {
        me.Hor.GsScale.show();
        gs_defl = math.clamp(getprop(GsDefl),-1.25,1.25);
        me.Hor.GsIls.setTranslation(0,gs_defl* -115);
        me.Hor.LocScale.show();
        loc_defl = math.clamp(getprop(pfdOffset[x]), -2.5, 2.5);
        me.Hor.LocDefl.setTranslation(loc_defl * 45, 0);
      } else {
        me.Hor.GsScale.setVisible(getprop(sgTest[x]));
        me.Hor.LocScale.setVisible(getprop(sgTest[x]));
      }
    } else {
      me.Fail.AttFail.show();
      me.Fail.HorizScale.hide();
      me.Fail.HorizGnd.hide();
    }

  }, # end of update_HOR

  update_SPD : func {
    if (!me.madc_enabled) return;
    else {
      if (getprop(ApAlt) == "FLC" or getprop(ApAlt) == "VFLC" 
          or fms or getprop(spd_ctrl) or getprop(hold_active)) {
        me.Spd.TgSpd.show();
        if (getprop(AltFt)  <= 30650) {
          me.Spd.TgSpd.setText(sprintf("%.0f",getprop(SpdTgKt)));
        } else me.Spd.TgSpd.setText(sprintf("%.2f",getprop(SpdTgMc)));
      } else me.Spd.TgSpd.hide();
      ias = getprop(Ias);
      ias_corr = ias/10;
      ias_corr = int(roundToNearest(ias/10,0.1));
      me.Spd.CurSpd.setText(sprintf("%02i",ias_corr));
      me.Spd.CurSpdTen.setTranslation(0,(sprintf("%.2f",math.fmod(ias,10))* 32));
#      me.Spd.CurSpdTen.setTranslation(0,(roundToNearest(math.fmod(ias,10),0.01)* 32));
      me.Spd.SpdTape.setTranslation(0,ias * 5.143);
      me.Spd.Vmo.setTranslation(0,(ias-(getprop(Vne) or 0)) * 5.143);
      if (!wow) {
        me.Spd.Vstall.setTranslation(0,(getprop(StallDiff) or 0) * -5.143);
        me.Spd.Vstall.show();
      } else me.Spd.Vstall.hide();

      n=0;
      foreach (var v;["V1","V2","VR","VA","VE","Vref","VF"]) {
        if (v == "VF") spd = me.SpdVal[n];
        else spd = getprop(me.SpdVal[n]);
        v_dis = ias-spd > 0 ? 0 : 1;
        if (abs(ias-spd) < 38) {
          if (v == "VA" or v == "VE" or v == "Vref" or v== "VF") {
            if (wow) {me.SpdInks[n].hide(); me.SpdInks[7].hide()}
            else {
              me.SpdInks[n].setTranslation(0,(ias-spd) * 5.143).show();
              me.SpdInks[7].show();
            }
          } else me.SpdInks[n].setTranslation(0,(ias-spd) * 5.143)
                              .setVisible(v_dis);
        } else {me.SpdInks[n].hide();me.SpdInks[7].hide()}
        n+=1;
      }

      vne = getprop(Vne) ? getprop(Vne) : 210;
      if (ias > vne) me.Spd.IasBg.setColorFill(1,0,0);
      else me.Spd.IasBg.setColorFill(0,0,0);

      ### Speed Trend (look ahead 6s) ###
      spd_trend = 6 * (getprop(SpdTrd) or 0);
      spd_trend = math.clamp(spd_trend, -228, 228);
      me.SpdTrend.reset();
      me.SpdTrend.rect(180,338,12,-spd_trend);              

      ### V markers ###
      if (ias < 30) {    
        v_ind = 1;
        me.Spd.Ind1.setText(sprintf("%.0f",getprop(V1)));
        me.Spd.Ind2.setText(sprintf("%.0f",getprop(V2)));
        me.Spd.IndE.setText(sprintf("%.0f",getprop(VE)));
        me.Spd.IndR.setText(sprintf("%.0f",getprop(VR)));
      } else v_ind = 0;
      me.Spd.BottomRect.setVisible(v_ind);
      me.Spd.ER21.setVisible(v_ind);
      me.Spd.Ind1.setVisible(v_ind);
      me.Spd.Ind2.setVisible(v_ind);
      me.Spd.IndR.setVisible(v_ind);
      me.Spd.IndE.setVisible(v_ind);

      ### Mach ###
      me.Txt.McVal.setText(sprintf("%.3f",getprop(Mach))~" M");
    }
  }, # end of update_SPD

  update_HSI : func(x) {
    hdg = getprop(Heading) or 0;
    hdg_bug = getprop(HeadingBug) or 0;
    crs_offset = getprop(pfdOffset[x]) or 0;
    me.Hsi.To.setVisible(to_flag[x] and !fms and !pfd_hsi[x]);
    me.Hsi.From.setVisible(from_flag[x] and !fms and !pfd_hsi[x]);
    me.Hsi1.To1.setVisible(to_flag[x] and !fms and pfd_hsi[x]);
    me.Hsi1.From1.setVisible(from_flag[x] and !fms and pfd_hsi[x]);
    if (fms) crs_defl = getprop(crsDefl_fms);
    else {
      crs_defl = getprop(nav_inRange[x]) ? getprop(crsDefl_nav[x]) : -10;
      crs_defl = math.clamp(crs_defl,-10,10);
    }
    me.Txt.Ptr1Txt.setText(me.Nav1Ptr[getprop(NavPtr1)])
                  .setVisible(disp_cont[x]);
    me.Txt.Ptr1Ind.setVisible(getprop(NavPtr1) and disp_cont[x]);
    me.Txt.Ptr2Txt.setText(me.Nav2Ptr[getprop(NavPtr2)])
                  .setVisible(disp_cont[x]);
    me.Txt.Ptr2Ind.setVisible(getprop(NavPtr2) and disp_cont[x]);
    if (me.atthdg_enabled and me.atthdgAux_enabled) { # attHdg-attHdgAux fuses
      me.Fail.HdgFail.setVisible(getprop(sgTest[x]));
      me.Fail.HdgFailCross.setVisible(getprop(sgTest[x]));
      me.Fail.HdgFailCross1.setVisible(getprop(sgTest[x]));
      if (!pfd_hsi[x]) { # Button PFD HSI
        me.Hsi.Rose.setRotation(-hdg * D2R);
        me.Hsi.HdgBug.setRotation(hdg_bug * D2R);
        me.Hsi.CrsNeedle.setRotation(crs_offset * D2R).show();
        me.Hsi.scale.setRotation(crs_offset * D2R).show();
        me.Hsi.CrsDeflect.setTranslation(crs_defl * 10.5,0);
        ### Vor Adf Fms ###
        me.Hsi.Ptr1.setRotation((getprop(Nav1Ptr) or 0) * D2R);
        me.Hsi.Ptr2.setRotation((getprop(Nav2Ptr) or 0) * D2R);
      } else {
        me.Hsi1.Rose1.setRotation(-hdg * D2R);
        me.Hsi1.HdgBug1.setRotation(hdg_bug * D2R);
        me.Hsi1.CrsNeedle1.setRotation(crs_offset * D2R).show();
        me.Hsi1.scale1.setRotation(crs_offset * D2R).show();
        me.Hsi1.CrsDeflect1.setTranslation(crs_defl * 10.5,0);
        me.Hsi1.ArrowL.setVisible(hdg_bug < -53);
        me.Hsi1.ArrowR.setVisible(hdg_bug > 53);
        ### Vor Adf Fms ###
        me.Hsi1.Ptr11.setRotation((getprop(Nav1Ptr) or 0) * D2R);
        me.Hsi1.Ptr21.setRotation((getprop(Nav2Ptr) or 0) * D2R);
      }
      me.Hsi.COMPASS.setVisible(!pfd_hsi[x]);
      me.Hsi1.COMPASS1.setVisible(pfd_hsi[x]);
      if (getprop(NavPtr1)) {
        if (pfd_hsi[x]) {me.Hsi.Ptr1.hide();me.Hsi1.Ptr11.show()}
        else {me.Hsi.Ptr1.show();me.Hsi1.Ptr11.hide()}
      } else {me.Hsi.Ptr1.hide();me.Hsi1.Ptr11.hide()}
      if (getprop(NavPtr2)) {
        if (pfd_hsi[x]) {me.Hsi.Ptr2.hide();me.Hsi1.Ptr21.show()}
        else {me.Hsi.Ptr2.show();me.Hsi1.Ptr21.hide()}
      } else {me.Hsi.Ptr2.hide();me.Hsi1.Ptr21.hide()}
      me.Txt.NavDst.setText(sprintf("%.1f",getprop(NavDist))~" NM");
    } else {    # atthdg (IAC) fail
      me.Fail.HdgFail.show();
      if (!pfd_hsi[x]) {
        me.Fail.HdgFailCross.show();
        me.Fail.HdgFailCross1.setVisible(getprop(sgTest[x]));
        me.Hsi.Ptr1.hide();
        me.Hsi.Ptr2.hide();
        me.Hsi.CrsNeedle.hide();
      } else {
        me.Fail.HdgFailCross1.show();
        me.Fail.HdgFailCross.setVisible(getprop(sgTest[x]));
        me.Hsi1.Ptr11.hide();
        me.Hsi1.Ptr21.hide();
        me.Hsi1.CrsNeedle1.hide();
      }
    }
  }, # end of update_HSI

  update_VSP : func {
    v_spd = getprop(Vert_spd) or 0;
    me.Vspd.VSpdVal.setText(sprintf("%+.0f",v_spd)).setVisible(me.madc_enabled);
    me.Vspd.Arrow.setRotation(v_spd * 0.0188 * D2R).setVisible(me.madc_enabled);
    me.Vspd.VSpdInd.setVisible(me.madc_enabled);
  }, # end of update_VSP

  update_DME : func {
    if (!me.dme_enabled) {
      me.Txt.Dme.show().setColor(1,0,0);
      me.Txt.DmeId.setText("");
      me.Txt.DmeDist.setText("");
    } else {
      if (getprop(NavSrc) == "NAV1" and getprop(DmeID[0]) != "") {
        me.Txt.Dme.show().setColor(1,0,1);
        me.Txt.DmeId.setText(getprop(DmeID[0]));
        if (getprop(DmeIR[0]) > 0) {
          me.Txt.DmeDist.setText(sprintf("%.1f",getprop(DmeDst[0]))~" NM");
        } else me.Txt.DmeDist.setText("--- NM");
      } else if (getprop(NavSrc) == "NAV2" and getprop(DmeID[1]) != "") {
        me.Txt.Dme.show().setColor(1,0,1);
        me.Txt.DmeId.setText(getprop(DmeID[1]));
        if (getprop(DmeIR[1]) > 0) {
          me.Txt.DmeDist.setText(sprintf("%.1f",getprop(DmeDst[1]))~" NM");
        } else me.Txt.DmeDist.setText("--- NM");
      } else me.Txt.Dme.hide();
    }
  }, # end of update_DME

  update_Markers : func(x) {
    me.Txt.MarkerO.setVisible(getprop(Marker_o) or getprop(sgTest[x]));
    me.Txt.MarkerM.setVisible(getprop(Marker_m));
    me.Txt.MarkerI.setVisible(getprop(Marker_i));
  },

  update_Iac : func(x) {
    if (!getprop(Iac[0])) {me.Sg.sg.show();me.Sg.sgTxt.setText("SG2")}
    else if (!getprop(Iac[1])) {me.Sg.sg.show();me.Sg.sgTxt.setText("SG1")}
    else {
      if (getprop(SgRev) == 0) me.Sg.sg.setVisible(getprop(sgTest[x]));
      if (getprop(SgRev) == -1) {me.Sg.sg.show();me.Sg.sgTxt.setText("SG1")}
      if (getprop(SgRev) == 1) {me.Sg.sg.show();me.Sg.sgTxt.setText("SG2")}
    }
  },

}; # end of PFDDisplay

###### Main #####
var pfd_setl = setlistener("sim/signals/fdm-initialized", func() {
  for (var x=0;x<2;x+=1) {
    var pfd = PFDDisplay.new(x);
    pfd.listen(x);
    pfd.update_PFD(x);
  }
	print('PFD Canvas ... Ok');
	removelistener(pfd_setl); 
},0,0);



