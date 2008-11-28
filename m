Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thunder.m@email.cz>) id 1L61nf-0006Zd-S5
	for linux-dvb@linuxtv.org; Fri, 28 Nov 2008 12:46:21 +0100
Message-ID: <492FD9E8.9070600@email.cz>
Date: Fri, 28 Nov 2008 12:45:44 +0100
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4675AD3E.3090608@email.cz>
In-Reply-To: <4675AD3E.3090608@email.cz>
Content-Type: multipart/mixed; boundary="------------060200090109000506080609"
Subject: [linux-dvb] Patch for Leadtek DTV1800H, DTV2000H (rev I, J),
 and (not working yet)  DTV2000H Plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------060200090109000506080609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi, all 3 patches are in one file, they depend on each other.

All GPIOs spoted from Windows with original APs

DTV1800H - there is patch pending in this thread from Miroslav Sustek,
this is only modification of his patch, difference should be only in
GPIOs (I think it is better to use GPIOs from Windows).

DTV2000H (rev. I) - Only renamed from original old DTV2000H

DTV2000H (rev. J) - Almost everything is working, I have problem only
with FM radio (no sound).

DTV2000H Plus - added pci id, GPIOs, sadly Tuner is XC4000, so it is not
working yet.

Mirek Slugen


--------------060200090109000506080609
Content-Type: text/x-patch;
 name="dtv2000h_plus.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dtv2000h_plus.diff"

diff -Naur v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-cards.c v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-cards.c
--- v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-cards.c	2008-11-28 11:46:34.000000000 +0100
+++ v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-cards.c	2008-11-28 11:41:06.000000000 +0100
@@ -1269,8 +1269,45 @@
 			 .gpio0 = 0x074a,
 		},
 	},
-	[CX88_BOARD_WINFAST_DTV2000H] = {
-		.name           = "WinFast DTV2000 H",
+	[CX88_BOARD_WINFAST_DTV1800H] = {
+		.name           = "WinFast DTV1800 H",
+		.tuner_type     = TUNER_XC2028,
+		.radio_type     = TUNER_XC2028,
+		.tuner_addr     = 0x61,
+		.radio_addr     = 0x61,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x0403,
+			.gpio1  = 0xf0d7,
+			.gpio2  = 0x0001,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0407,
+			.gpio1  = 0xf0f7,
+			.gpio2  = 0x0001,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x0407,
+			.gpio1  = 0xf0f7,
+			.gpio2  = 0x0001,
+			.gpio3  = 0x0000,
+		}},
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0403,
+			.gpio1  = 0xf097,
+			.gpio2  = 0x0001,
+			.gpio3  = 0x0000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	[CX88_BOARD_WINFAST_DTV2000H_I] = {
+		.name           = "WinFast DTV2000 H (ver. I)",
 		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
@@ -1306,11 +1343,100 @@
 			.gpio3  = 0x02000000,
 		}},
 		.radio = {
-			 .type  = CX88_RADIO,
-			 .gpio0 = 0x00015702,
-			 .gpio1 = 0x0000f207,
-			 .gpio2 = 0x00015702,
-			 .gpio3 = 0x02000000,
+			.type   = CX88_RADIO,
+			.gpio0  = 0x00015702,
+			.gpio1  = 0x0000f207,
+			.gpio2  = 0x00015702,
+			.gpio3  = 0x02000000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	[CX88_BOARD_WINFAST_DTV2000H_J] = {
+		.name           = "WinFast DTV2000 H (ver. J)",
+		.tuner_type     = TUNER_PHILIPS_FMD1216ME_MK3,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tda9887_conf   = TDA9887_PRESENT,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x00013704,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x00013704,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_CABLE,
+			.vmux   = 0,
+			.gpio0  = 0x0001b701,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x0001b701,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0001b701,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x0001b701,
+			.gpio3  = 0x02000000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x0001b701,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x0001b701,
+			.gpio3  = 0x02000000,
+		}},
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0001b702,
+			.gpio1  = 0x00008207,
+			.gpio2  = 0x0001b702,
+			.gpio3  = 0x02000000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
+	[CX88_BOARD_WINFAST_DTV2000H_PLUS] = {
+		.name           = "WinFast DTV2000 H PLUS",
+		.tuner_type     = TUNER_XC2028,
+		.radio_type     = TUNER_XC2028,
+		.tuner_addr     = 0x61,
+		.radio_addr     = 0x61,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x0403,
+			.gpio1  = 0xF0D7,
+			.gpio2  = 0x0101,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_CABLE,
+			.vmux   = 0,
+			.gpio0  = 0x0403,
+			.gpio1  = 0xF0D7,
+			.gpio2  = 0x0100,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0407,
+			.gpio1  = 0xF0F7,
+			.gpio2  = 0x0101,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x0407,
+			.gpio1  = 0xF0F7,
+			.gpio2  = 0x0101,
+			.gpio3  = 0x0000,
+		}},
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0403,
+			.gpio1  = 0xF097,
+			.gpio2  = 0x0100,
+			.gpio3  = 0x0000,
 		},
 		.mpeg           = CX88_MPEG_DVB,
 	},
@@ -2217,8 +2343,20 @@
 		.card      = CX88_BOARD_NPGTECH_REALTV_TOP10FM,
 	},{
 		.subvendor = 0x107d,
+		.subdevice = 0x6654,
+		.card      = CX88_BOARD_WINFAST_DTV1800H,
+	},{
+		.subvendor = 0x107d,
 		.subdevice = 0x665e,
-		.card      = CX88_BOARD_WINFAST_DTV2000H,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_I,
+	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f2b,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_J,
+	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6f42,
+		.card      = CX88_BOARD_WINFAST_DTV2000H_PLUS,
 	},{
 		.subvendor = 0x18ac,
 		.subdevice = 0xd800, /* FusionHDTV 3 Gold (original revision) */
@@ -2573,6 +2711,23 @@
 	return -EINVAL;
 }
 
+static int cx88_xc3028_winfast1800h_callback(struct cx88_core *core,
+						int command, int mode)
+{
+	switch (command) {
+	case XC2028_TUNER_RESET:
+		/* GPIO 12 (xc3028 tuner reset) */
+		cx_set(MO_GP1_IO, 0x1010);
+		mdelay(50);
+		cx_clear(MO_GP1_IO, 0x10);
+		mdelay(50);
+		cx_set(MO_GP1_IO, 0x10);
+		mdelay(50);
+		return 0;
+	}
+	return -EINVAL;
+}
+
 /* ------------------------------------------------------------------- */
 /* some Divco specific stuff                                           */
 static int cx88_pv_8000gt_callback(struct cx88_core *core,
@@ -2645,6 +2800,10 @@
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
 	case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
 		return cx88_dvico_xc2028_callback(core, command, arg);
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_WINFAST_DTV1800H:
+		return cx88_xc3028_winfast1800h_callback(core, command, arg);
+	
 	}
 
 	switch (command) {
@@ -2819,6 +2978,17 @@
 		cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
 		udelay(1000);
 		break;
+
+        case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_WINFAST_DTV1800H:
+		/* GPIO 12 (xc3028 tuner reset) */
+		cx_set(MO_GP1_IO, 0x1010);
+		mdelay(50);
+		cx_clear(MO_GP1_IO, 0x10);
+		mdelay(50);
+		cx_set(MO_GP1_IO, 0x10);
+		mdelay(50);
+		break;
 	}
 }
 
@@ -2838,7 +3008,9 @@
 		if (core->i2c_algo.udelay < 16)
 			core->i2c_algo.udelay = 16;
 		break;
-	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
+        case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_PINNACLE_HYBRID_PCTV:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		break;
 	case CX88_BOARD_KWORLD_ATSC_120:
@@ -2851,7 +3023,7 @@
 		 * Those boards uses non-MTS firmware
 		 */
 		break;
-	case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
 		ctl->demod = XC3028_FE_ZARLINK456;
 		ctl->mts = 1;
 		break;
diff -Naur v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-dvb.c v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-dvb.c
--- v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-dvb.c	2008-11-28 11:46:34.000000000 +0100
+++ v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-dvb.c	2008-11-28 11:43:24.000000000 +0100
@@ -262,6 +262,7 @@
 	.no_tuner      = 1,
 };
 
+
 static struct mt352_config dvico_fusionhdtv_mt352_xc3028 = {
 	.demod_address = 0x0f,
 	.if2 = 4560,
@@ -645,7 +646,8 @@
 				goto frontend_detach;
 		}
 		break;
-	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV2000H_I:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
 	case CX88_BOARD_HAUPPAUGE_HVR1100:
 	case CX88_BOARD_HAUPPAUGE_HVR1100LP:
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -964,7 +966,9 @@
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
 		break;
-	 case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_PINNACLE_HYBRID_PCTV:
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
 					       &cx88_pinnacle_hybrid_pctv,
 					       &core->i2c_adap);
@@ -974,7 +978,7 @@
 				goto frontend_detach;
 		}
 		break;
-	 case CX88_BOARD_GENIATECH_X8000_MT:
+	case CX88_BOARD_GENIATECH_X8000_MT:
 		dev->ts_gen_cntrl = 0x00;
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
@@ -983,7 +987,7 @@
 		if (attach_xc3028(0x61, dev) < 0)
 			goto frontend_detach;
 		break;
-	 case CX88_BOARD_KWORLD_ATSC_120:
+	case CX88_BOARD_KWORLD_ATSC_120:
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
 					       &kworld_atsc_120_config,
 					       &core->i2c_adap);
diff -Naur v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88.h v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88.h
--- v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88.h	2008-11-28 11:46:34.000000000 +0100
+++ v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88.h	2008-11-27 23:44:54.000000000 +0100
@@ -204,7 +204,7 @@
 #define CX88_BOARD_KWORLD_MCE200_DELUXE    48
 #define CX88_BOARD_PIXELVIEW_PLAYTV_P7000  49
 #define CX88_BOARD_NPGTECH_REALTV_TOP10FM  50
-#define CX88_BOARD_WINFAST_DTV2000H        51
+#define CX88_BOARD_WINFAST_DTV2000H_I      51
 #define CX88_BOARD_GENIATECH_DVBS          52
 #define CX88_BOARD_HAUPPAUGE_HVR3000       53
 #define CX88_BOARD_NORWOOD_MICRO           54
@@ -232,6 +232,9 @@
 #define CX88_BOARD_SATTRADE_ST4200         76
 #define CX88_BOARD_TBS_8910                77
 #define CX88_BOARD_PROF_6200               78
+#define CX88_BOARD_WINFAST_DTV1800H        79
+#define CX88_BOARD_WINFAST_DTV2000H_J      80
+#define CX88_BOARD_WINFAST_DTV2000H_PLUS   81
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
diff -Naur v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-input.c v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-input.c
--- v4l-dvb-57e1c3e9ec94.old/linux/drivers/media/video/cx88/cx88-input.c	2008-11-28 11:46:34.000000000 +0100
+++ v4l-dvb-57e1c3e9ec94/linux/drivers/media/video/cx88/cx88-input.c	2008-11-28 11:54:25.000000000 +0100
@@ -93,6 +93,10 @@
 		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
+	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV2000H_I:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
 		auxgpio = gpio;
 		break;
@@ -243,7 +247,10 @@
 		ir_type = IR_TYPE_RC5;
 		ir->sampling = 1;
 		break;
-	case CX88_BOARD_WINFAST_DTV2000H:
+	case CX88_BOARD_WINFAST_DTV1800H:
+	case CX88_BOARD_WINFAST_DTV2000H_I:
+	case CX88_BOARD_WINFAST_DTV2000H_J:
+	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;


--------------060200090109000506080609
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060200090109000506080609--
