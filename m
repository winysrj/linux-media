Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63455 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2DEJks (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2012 05:40:48 -0400
Received: by bkcik5 with SMTP id ik5so1177550bkc.19
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2012 02:40:46 -0700 (PDT)
To: linux-media@vger.kernel.org
Subject: patch for Asus My Cinema PS3-100 (1043:48cd)
From: remi schwartz <remi.schwartz@gmail.com>
Date: Thu, 5 Apr 2012 11:40:43 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ciWfPV3mlBbxuaC"
Message-Id: <201204051140.44241.remi.schwartz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_ciWfPV3mlBbxuaC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

This is the patch against kernel 2.6.32 I used to get my TV card Asus=20
My Cinema PS3-100 (1043:48cd) to work.

More information on this card can be found on this page :

http://www.0xf8.org/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card/

This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
SAA7134 module, so I gave it the temporary number of 1470.

DVB-T and remote have been tested and work fine.
DVB-S, FM and Composite input haven't been tested.

Hope that will help some of you.

R=C3=A9mi


Signed-off-by: Remi Schwartz <remi.schwartz@gmail.com>

=2D-- ./include/media/ir-common.h.orig	2009-12-03 04:51:21.000000000 +0100
+++ ./include/media/ir-common.h	2012-03-09 20:23:09.325249426 +0100
@@ -155,6 +155,7 @@ extern struct ir_scancode_table ir_codes
 extern struct ir_scancode_table ir_codes_proteus_2309_table;
 extern struct ir_scancode_table ir_codes_budget_ci_old_table;
 extern struct ir_scancode_table ir_codes_asus_pc39_table;
+extern struct ir_scancode_table ir_codes_asus_ps3_100_table;
 extern struct ir_scancode_table ir_codes_encore_enltv_table;
 extern struct ir_scancode_table ir_codes_encore_enltv2_table;
 extern struct ir_scancode_table ir_codes_tt_1500_table;
=2D-- ./drivers/media/common/ir-keymaps.c.orig	2009-12-03 04:51:21.00000000=
0=20
+0100
+++ ./drivers/media/common/ir-keymaps.c	2012-03-29 18:43:59.170879721 +0200
@@ -2064,6 +2064,70 @@ struct ir_scancode_table ir_codes_asus_p
 EXPORT_SYMBOL_GPL(ir_codes_asus_pc39_table);
=20
=20
+/*
+ * Remi Schwartz <remi.schwartz@gmail.com>
+ * this is the remote control that comes with the asus my cinema ps3-100
+ * base taken from pc39 one
+ */
+static struct ir_scancode ir_codes_asus_ps3_100[] =3D {
+	{ 0x23, KEY_HOME },		/* home */
+	{ 0x21, KEY_TV },		/* tv */
+	{ 0x3c, KEY_TEXT },		/* teletext */
+	{ 0x16, KEY_POWER },		/* close */
+=09
+	{ 0x34, KEY_RED },		/* red */
+	{ 0x32, KEY_YELLOW },		/* yellow */
+	{ 0x39, KEY_BLUE },		/* blue */
+	{ 0x38, KEY_GREEN },		/* green */
+
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
+	{ 0x2a, KEY_VOLUMEUP },
+	{ 0x19, KEY_VOLUMEDOWN },
+	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
+=09
+	{ 0x37, KEY_UP },
+	{ 0x3b, KEY_DOWN },
+	{ 0x27, KEY_LEFT },
+	{ 0x2f, KEY_RIGHT },
+	{ 0x1a, KEY_ENTER },		/* enter */
+=09
+	{ 0x1d, KEY_EXIT },		/* back */
+	{ 0x13, KEY_AB },		/* recall */
+=09
+	{ 0x1f, KEY_AUDIO },		/* TV audio */
+	{ 0x08, KEY_SCREEN },		/* snapshot */
+	{ 0x11, KEY_ZOOM },		/* full screen */
+	{ 0x3d, KEY_MUTE },		/* mute */
+
+	{ 0x0e, KEY_REWIND },		/* backward << */
+	{ 0x2e, KEY_RECORD },		/* recording */
+	{ 0x36, KEY_STOP },
+	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x1e, KEY_PREVIOUS },		/* rew */
+	{ 0x25, KEY_PAUSE },		/* pause */
+	{ 0x06, KEY_PLAY },		/* play */
+	{ 0x26, KEY_NEXT },		/* forward */
+};
+
+struct ir_scancode_table ir_codes_asus_ps3_100_table =3D {
+	.scan =3D ir_codes_asus_ps3_100,
+	.size =3D ARRAY_SIZE(ir_codes_asus_ps3_100),
+};
+EXPORT_SYMBOL_GPL(ir_codes_asus_ps3_100_table);
+
+
 /* Encore ENLTV-FM  - black plastic, white front cover with white glowing=
=20
buttons
     Juan Pablo Sormani <sorman@gmail.com> */
 static struct ir_scancode ir_codes_encore_enltv[] =3D {
=2D-- ./drivers/media/video/saa7134/saa7134-input.c.orig	2009-12-03=20
04:51:21.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-input.c	2012-03-09 20:23:09.33724=
4873=20
+0100
@@ -575,6 +575,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keydown =3D 0x0040000;
 		rc5_gpio =3D 1;
 		break;
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+		ir_codes     =3D &ir_codes_asus_ps3_100_table;
+		mask_keydown =3D 0x0040000;
+		rc5_gpio =3D 1;
+		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
 		ir_codes     =3D &ir_codes_encore_enltv_table;
=2D-- ./drivers/media/video/saa7134/saa7134-dvb.c.orig	2012-01-15=20
06:52:12.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-dvb.c	2012-03-09 20:23:09.3372448=
73=20
+0100
@@ -824,6 +824,20 @@ static struct tda1004x_config asus_tiger
 	.request_firmware =3D philips_tda1004x_request_firmware
 };
=20
+static struct tda1004x_config asus_ps3_100_config =3D {
+	.demod_address =3D 0x0b,
+	.invert        =3D 1,
+	.invert_oclk   =3D 0,
+	.xtal_freq     =3D TDA10046_XTAL_16M,
+	.agc_config    =3D TDA10046_AGC_TDA827X,
+	.gpio_config   =3D TDA10046_GP11_I,
+	.if_freq       =3D TDA10046_FREQ_045,
+	.i2c_gate      =3D 0x4b,
+	.tuner_address =3D 0x61,
+	.antenna_switch =3D 1,
+	.request_firmware =3D philips_tda1004x_request_firmware
+};
+
 /* ------------------------------------------------------------------
  * special case: this card uses saa713x GPIO22 for the mode switch
  */
@@ -1465,6 +1479,31 @@ static int dvb_init(struct saa7134_dev *
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
+			fe0->dvb.frontend =3D dvb_attach(tda10086_attach,
+						&flydvbs, &dev->i2c_adap);
+			if (fe0->dvb.frontend) {
+				if (dvb_attach(tda826x_attach,
+						fe0->dvb.frontend, 0x60,
+						&dev->i2c_adap, 0) =3D=3D NULL) {
+					wprintk("%s: Asus My Cinema PS3-100, no "
+						"tda826x found!\n", __func__);
+					goto dettach_frontend;
+				}
+				if (dvb_attach(lnbp21_attach, fe0->dvb.frontend,
+						&dev->i2c_adap, 0, 0) =3D=3D NULL) {
+					wprintk("%s: Asus My Cinema PS3-100, no lnbp21"
+						" found!\n", __func__);
+					goto dettach_frontend;
+				}
 			}
 		}
 		break;
=2D-- ./drivers/media/video/saa7134/saa7134-cards.c.orig	2012-01-15=20
06:52:12.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-cards.c	2012-03-09 20:23:09.34124=
5848=20
+0100
@@ -5012,6 +5012,36 @@ struct saa7134_board saa7134_boards[] =3D
 			.gpio =3D 0x0200000,
 		},
 	},
+	[SAA7134_BOARD_ASUSTeK_PS3_100] =3D {
+		.name           =3D "Asus My Cinema PS3-100",
+		.audio_clock    =3D 0x00187de7,
+		.tuner_type     =3D TUNER_PHILIPS_TDA8290,
+		.radio_type     =3D UNSET,
+		.tuner_addr     =3D ADDR_UNSET,
+		.radio_addr     =3D ADDR_UNSET,
+		.tuner_config   =3D 2,
+		.gpiomask       =3D 1 << 21,
+		.mpeg           =3D SAA7134_MPEG_DVB,
+		.inputs         =3D {{
+			.name =3D name_tv,
+			.vmux =3D 1,
+			.amux =3D TV,
+			.tv   =3D 1,
+		}, {
+			.name =3D name_comp,
+			.vmux =3D 0,
+			.amux =3D LINE2,
+		}, {
+			.name =3D name_svideo,
+			.vmux =3D 8,
+			.amux =3D LINE2,
+		} },
+		.radio =3D {
+			.name =3D name_radio,
+			.amux =3D TV,
+			.gpio =3D 0x0200000,
+		},
+	},
 	[SAA7134_BOARD_REAL_ANGEL_220] =3D {
 		.name           =3D "Zogis Real Angel 220",
 		.audio_clock    =3D 0x00187de7,
@@ -6407,6 +6437,12 @@ struct pci_device_id saa7134_pci_tbl[] =3D
 		.driver_data  =3D SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
+		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    =3D 0x1043,
+		.subdevice    =3D 0x48cd,
+		.driver_data  =3D SAA7134_BOARD_ASUSTeK_PS3_100,
+	}, {
+		.vendor       =3D PCI_VENDOR_ID_PHILIPS,
 		.device       =3D PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    =3D 0x17de,
 		.subdevice    =3D 0x7128,
@@ -6753,6 +6789,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -7181,6 +7218,14 @@ int saa7134_board_init2(struct saa7134_d
 	{
 		u8 data[] =3D { 0x3c, 0x33, 0x60};
 		struct i2c_msg msg =3D {.addr =3D 0x0b, .flags =3D 0, .buf =3D data,
+							.len =3D sizeof(data)};
+		i2c_transfer(&dev->i2c_adap, &msg, 1);
+		break;
+	}
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+	{
+		u8 data[] =3D { 0x3c, 0x33, 0x60};
+		struct i2c_msg msg =3D {.addr =3D 0x0b, .flags =3D 0, .buf =3D data,
 							.len =3D sizeof(data)};
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
=2D-- ./drivers/media/video/saa7134/saa7134.h.orig	2012-01-15 06:52:12.0000=
00000=20
+0100
+++ ./drivers/media/video/saa7134/saa7134.h	2012-03-09 20:23:09.341245848=20
+0100
@@ -271,6 +271,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
 #define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
+#define SAA7134_BOARD_ASUSTeK_PS3_100   1470
 #define SAA7134_BOARD_ENCORE_ENLTV_FM53 148
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150


--Boundary-00=_ciWfPV3mlBbxuaC
Content-Type: text/x-patch;
  charset="utf-8";
  name="ps3_100_patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ps3_100_patch"

--- ./include/media/ir-common.h.orig	2009-12-03 04:51:21.000000000 +0100
+++ ./include/media/ir-common.h	2012-03-09 20:23:09.325249426 +0100
@@ -155,6 +155,7 @@ extern struct ir_scancode_table ir_codes
 extern struct ir_scancode_table ir_codes_proteus_2309_table;
 extern struct ir_scancode_table ir_codes_budget_ci_old_table;
 extern struct ir_scancode_table ir_codes_asus_pc39_table;
+extern struct ir_scancode_table ir_codes_asus_ps3_100_table;
 extern struct ir_scancode_table ir_codes_encore_enltv_table;
 extern struct ir_scancode_table ir_codes_encore_enltv2_table;
 extern struct ir_scancode_table ir_codes_tt_1500_table;
--- ./drivers/media/common/ir-keymaps.c.orig	2009-12-03 04:51:21.000000000 +0100
+++ ./drivers/media/common/ir-keymaps.c	2012-03-29 18:43:59.170879721 +0200
@@ -2064,6 +2064,70 @@ struct ir_scancode_table ir_codes_asus_p
 EXPORT_SYMBOL_GPL(ir_codes_asus_pc39_table);
 
 
+/*
+ * Remi Schwartz <remi.schwartz@gmail.com>
+ * this is the remote control that comes with the asus my cinema ps3-100
+ * base taken from pc39 one
+ */
+static struct ir_scancode ir_codes_asus_ps3_100[] = {
+	{ 0x23, KEY_HOME },		/* home */
+	{ 0x21, KEY_TV },		/* tv */
+	{ 0x3c, KEY_TEXT },		/* teletext */
+	{ 0x16, KEY_POWER },		/* close */
+	
+	{ 0x34, KEY_RED },		/* red */
+	{ 0x32, KEY_YELLOW },		/* yellow */
+	{ 0x39, KEY_BLUE },		/* blue */
+	{ 0x38, KEY_GREEN },		/* green */
+
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
+	{ 0x2a, KEY_VOLUMEUP },
+	{ 0x19, KEY_VOLUMEDOWN },
+	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
+	
+	{ 0x37, KEY_UP },
+	{ 0x3b, KEY_DOWN },
+	{ 0x27, KEY_LEFT },
+	{ 0x2f, KEY_RIGHT },
+	{ 0x1a, KEY_ENTER },		/* enter */
+	
+	{ 0x1d, KEY_EXIT },		/* back */
+	{ 0x13, KEY_AB },		/* recall */
+	
+	{ 0x1f, KEY_AUDIO },		/* TV audio */
+	{ 0x08, KEY_SCREEN },		/* snapshot */
+	{ 0x11, KEY_ZOOM },		/* full screen */
+	{ 0x3d, KEY_MUTE },		/* mute */
+
+	{ 0x0e, KEY_REWIND },		/* backward << */
+	{ 0x2e, KEY_RECORD },		/* recording */
+	{ 0x36, KEY_STOP },
+	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x1e, KEY_PREVIOUS },		/* rew */
+	{ 0x25, KEY_PAUSE },		/* pause */
+	{ 0x06, KEY_PLAY },		/* play */
+	{ 0x26, KEY_NEXT },		/* forward */
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
--- ./drivers/media/video/saa7134/saa7134-input.c.orig	2009-12-03 04:51:21.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-input.c	2012-03-09 20:23:09.337244873 +0100
@@ -575,6 +575,11 @@ int saa7134_input_init1(struct saa7134_d
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
--- ./drivers/media/video/saa7134/saa7134-dvb.c.orig	2012-01-15 06:52:12.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-dvb.c	2012-03-09 20:23:09.337244873 +0100
@@ -824,6 +824,20 @@ static struct tda1004x_config asus_tiger
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
@@ -1465,6 +1479,31 @@ static int dvb_init(struct saa7134_dev *
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
--- ./drivers/media/video/saa7134/saa7134-cards.c.orig	2012-01-15 06:52:12.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134-cards.c	2012-03-09 20:23:09.341245848 +0100
@@ -5012,6 +5012,36 @@ struct saa7134_board saa7134_boards[] =
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
@@ -6407,6 +6437,12 @@ struct pci_device_id saa7134_pci_tbl[] =
 		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1043,
+		.subdevice    = 0x48cd,
+		.driver_data  = SAA7134_BOARD_ASUSTeK_PS3_100,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x17de,
 		.subdevice    = 0x7128,
@@ -6753,6 +6789,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -7181,6 +7218,14 @@ int saa7134_board_init2(struct saa7134_d
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
--- ./drivers/media/video/saa7134/saa7134.h.orig	2012-01-15 06:52:12.000000000 +0100
+++ ./drivers/media/video/saa7134/saa7134.h	2012-03-09 20:23:09.341245848 +0100
@@ -271,6 +271,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_M103    145
 #define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 146
 #define SAA7134_BOARD_ASUSTeK_TIGER_3IN1   147
+#define SAA7134_BOARD_ASUSTeK_PS3_100   1470
 #define SAA7134_BOARD_ENCORE_ENLTV_FM53 148
 #define SAA7134_BOARD_AVERMEDIA_M135A    149
 #define SAA7134_BOARD_REAL_ANGEL_220     150

--Boundary-00=_ciWfPV3mlBbxuaC--
