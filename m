Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:50616 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1GNJ2a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 05:28:30 -0400
Received: from hp6830s.localnet (ARouen-553-1-217-17.w90-22.abo.wanadoo.fr [90.22.57.17])
	(Authenticated sender: remzouille)
	by smtp3-g21.free.fr (Postfix) with ESMTPA id 3F39DA621F
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 11:28:25 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: patch for Asus My Cinema PS3-100 (1043:48cd)
From: remzouille <remzouille@free.fr>
Date: Thu, 14 Jul 2011 11:28:23 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_3arHOl0h86H4/nM"
Message-Id: <201107141128.23344.remzouille@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_3arHOl0h86H4/nM
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

Hi all,

This is the patch against kernel 2.6.32 I used to get to work my TV card Asus 
My Cinema PS3-100 (1043:48cd).

More information on this card can be found on this page :

http://techblog.hollants.com/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card/

This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
SAA7134 module, so I gave it the temporary number of 1470.

It has in addition a remote controller that works fine with the
ir_codes_asus_pc39_table. I haven't finished the work on all keys but the
most usefull ones are working.

DVB-T and remote have been tested and work fine.
DVB-S, FM and Composite input haven't been tested.

Hope that will help some of you.

--Boundary-00=_3arHOl0h86H4/nM
Content-Type: text/x-patch;
  charset="utf-8";
  name="saa7134_ps3_100_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="saa7134_ps3_100_patch"

--- ./include/media/ir-common.h.orig	2011-07-10 15:21:59.000000000 +0200
+++ ./include/media/ir-common.h	2011-07-11 13:27:54.628502044 +0200
@@ -155,6 +155,7 @@
 extern struct ir_scancode_table ir_codes_proteus_2309_table;
 extern struct ir_scancode_table ir_codes_budget_ci_old_table;
 extern struct ir_scancode_table ir_codes_asus_pc39_table;
+extern struct ir_scancode_table ir_codes_asus_ps3_100_table;
 extern struct ir_scancode_table ir_codes_encore_enltv_table;
 extern struct ir_scancode_table ir_codes_encore_enltv2_table;
 extern struct ir_scancode_table ir_codes_tt_1500_table;

--- ./drivers/media/common/ir-keymaps.c.orig	2009-12-03 04:51:21.000000000 +0100
+++ ./drivers/media/common/ir-keymaps.c	2011-07-11 13:10:25.308503366 +0200
@@ -2064,6 +2064,70 @@
 EXPORT_SYMBOL_GPL(ir_codes_asus_pc39_table);
 
 
+/*
+ * Remzouille <remzouille@free.fr>
+ * this is the remote control that comes with the asus my cinema ps3-100
+ * base taken from pc39 one, to be completed
+ */
+static struct ir_scancode ir_codes_asus_ps3_100[] = {
+	/* Keys 0 to 9 */
+	{ 0x15, KEY_0 },
+	{ 0x29, KEY_1 },
+	{ 0x2d, KEY_2 },
+	{ 0x2b, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x0d, KEY_5 },
+	{ 0x0b, KEY_6 },
+	{ 0x31, KEY_7 },
+	{ 0x35, KEY_8 },
+	{ 0x33, KEY_9 },
+
+	{ 0x3e, KEY_RADIO },		/* radio */
+	{ 0x03, KEY_MENU },		/* dvd/menu */
+	{ 0x2a, KEY_VOLUMEUP },
+	{ 0x19, KEY_VOLUMEDOWN },
+	{ 0x37, KEY_UP },
+	{ 0x3b, KEY_DOWN },
+	{ 0x27, KEY_LEFT },
+	{ 0x2f, KEY_RIGHT },
+	{ 0x25, KEY_VIDEO },		/* video */
+	{ 0x1f, KEY_AUDIO },		/* music */
+
+	{ 0x34, KEY_RED },		/* music */
+	{ 0x32, KEY_YELLOW },		/* music */
+	{ 0x39, KEY_BLUE },		/* music */
+	{ 0x38, KEY_GREEN },		/* music */
+
+	{ 0x21, KEY_TV },		/* tv */
+	{ 0x1d, KEY_EXIT },		/* back */
+	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x1a, KEY_ENTER },		/* enter */
+
+	{ 0x06, KEY_PAUSE },		/* play/pause */
+	{ 0x1e, KEY_PREVIOUS },		/* rew */
+	{ 0x26, KEY_NEXT },		/* forward */
+	{ 0x0e, KEY_REWIND },		/* backward << */
+	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x36, KEY_STOP },
+	{ 0x2e, KEY_RECORD },		/* recording */
+	{ 0x16, KEY_POWER },		/* the button that reads "close" */
+
+	{ 0x11, KEY_ZOOM },		/* full screen */
+	{ 0x13, KEY_MACRO },		/* recall */
+	{ 0x23, KEY_HOME },		/* home */
+	{ 0x05, KEY_PVR },		/* picture */
+	{ 0x3d, KEY_MUTE },		/* mute */
+	{ 0x01, KEY_DVD },		/* dvd */
+};
+
+struct ir_scancode_table ir_codes_asus_ps3_100_table = {
+	.scan = ir_codes_asus_ps3_100,
+	.size = ARRAY_SIZE(ir_codes_asus_ps3_100),
+};
+EXPORT_SYMBOL_GPL(ir_codes_asus_ps3_100_table);
+
+
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
     Juan Pablo Sormani <sorman@gmail.com> */
 static struct ir_scancode ir_codes_encore_enltv[] = {

--- ./drivers/media/video/saa7134/saa7134-input.c.orig	2011-07-09 18:03:34.266782811 +0200
+++ ./drivers/media/video/saa7134/saa7134-input.c	2011-07-11 13:37:50.591502324 +0200
@@ -575,6 +575,11 @@
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;
 		break;
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+		ir_codes     = &ir_codes_asus_ps3_100_table;
+		mask_keydown = 0x0040000;
+		rc5_gpio = 1;
+		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
 		ir_codes     = &ir_codes_encore_enltv_table;

--- ./drivers/media/video/saa7134/saa7134-dvb.c.orig	2011-06-11 21:08:41.000000000 +0200
+++ ./drivers/media/video/saa7134/saa7134-dvb.c	2011-07-11 14:46:12.860508881 +0200
@@ -824,6 +824,20 @@
 	.request_firmware = philips_tda1004x_request_firmware
 };
 
+static struct tda1004x_config asus_ps3_100_config = {
+	.demod_address = 0x0b,
+	.invert        = 1,
+	.invert_oclk   = 0,
+	.xtal_freq     = TDA10046_XTAL_16M,
+	.agc_config    = TDA10046_AGC_TDA827X,
+	.gpio_config   = TDA10046_GP11_I,
+	.if_freq       = TDA10046_FREQ_045,
+	.i2c_gate      = 0x4b,
+	.tuner_address = 0x61,
+	.antenna_switch = 1,
+	.request_firmware = philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1465,6 +1479,31 @@
 						" found!\n", __func__);
 					goto dettach_frontend;
 				}
+			}
+		}
+		break;
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+		if (!use_frontend) {     /* terrestrial */
+			if (configure_tda827x_fe(dev, &asus_ps3_100_config,
+							&tda827x_cfg_2) < 0)
+				goto dettach_frontend;
+		} else {  		/* satellite */
+			fe0->dvb.frontend = dvb_attach(tda10086_attach,
+						&flydvbs, &dev->i2c_adap);
+			if (fe0->dvb.frontend) {
+				if (dvb_attach(tda826x_attach,
+						fe0->dvb.frontend, 0x60,
+						&dev->i2c_adap, 0) == NULL) {
+					wprintk("%s: Asus My Cinema PS3-100, no "
+						"tda826x found!\n", __func__);
+					goto dettach_frontend;
+				}
+				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
+						&dev->i2c_adap, 0, 0) == NULL) {
+					wprintk("%s: Asus My Cinema PS3-100, no lnbp21"
+						" found!\n", __func__);
+					goto dettach_frontend;
+				}
 			}
 		}
 		break;

--- ./drivers/media/video/saa7134/saa7134-cards.c.orig	2011-07-09 18:02:24.118778760 +0200
+++ ./drivers/media/video/saa7134/saa7134-cards.c	2011-07-11 14:45:20.060505704 +0200
@@ -5012,6 +5012,36 @@
 			.gpio = 0x0200000,
 		},
 	},
+	[SAA7134_BOARD_ASUSTeK_PS3_100] = {
+		.name           = "Asus My Cinema PS3-100",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.tuner_config   = 2,
+		.gpiomask       = 1 << 21,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+		}, {
+			.name = name_comp,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
+	},
 	[SAA7134_BOARD_REAL_ANGEL_220] = {
 		.name           = "Zogis Real Angel 220",
 		.audio_clock    = 0x00187de7,
@@ -6407,6 +6437,12 @@
 		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x48cd, /* REV:1.02G */
+		.driver_data  = SAA7134_BOARD_ASUSTeK_PS3_100,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x17de,
 		.subdevice    = 0x7128,
@@ -6753,6 +6789,7 @@
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -7181,6 +7218,14 @@
 	{
 		u8 data[] = { 0x3c, 0x33, 0x60};
 		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
+							.len = sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		break;
+	}
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+	{
+		u8 data[] = { 0x3c, 0x33, 0x60};
+		struct i2c_msg msg = {.addr = 0x0b, .flags = 0, .buf = data,
 							.len = sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;

--- ./drivers/media/video/saa7134/saa7134.h.orig	2011-06-11 21:08:41.000000000 +0200
+++ ./drivers/media/video/saa7134/saa7134.h	2011-07-11 13:19:48.875655674 +0200
@@ -271,6 +271,7 @@
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
 #define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
+#define SAA7134_BOARD_ASUSTeK_PS3_100   1470
 #define SAA7134_BOARD_ENCORE_ENLTV_FM53 148
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150

--Boundary-00=_3arHOl0h86H4/nM--
