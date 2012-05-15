Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932282Ab2EONRK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 09:17:10 -0400
Message-ID: <4FB25752.7040108@redhat.com>
Date: Tue, 15 May 2012 10:17:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: remi schwartz <remi.schwartz@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: patch for Asus My Cinema PS3-100 (1043:48cd)
References: <201204051140.44241.remi.schwartz@gmail.com>
In-Reply-To: <201204051140.44241.remi.schwartz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-04-2012 06:40, remi schwartz escreveu:
> Hi all,
> 
> This is the patch against kernel 2.6.32 I used to get my TV card Asus 
> My Cinema PS3-100 (1043:48cd) to work.

Please, don't sent patches against older kernel versions, as they won't
apply anymore upstream. In particular, since kernel 2.6.32, the entire
RC code were re-written.

You can test the very latest media code using the media-build tree,
available at:
	http://git.linuxtv.org/media_build.git

It compiles against old kernels (although won't compile the gspca driver
since yesterday, as I'm applying a massive amount of patches those days
and didn't have any time yet to fix gspca build).

> 
> More information on this card can be found on this page :
> 
> http://www.0xf8.org/2009/09/asus-mycinema-ps3-100-3-in-1-tv-card/
> 
> This card seems to be a clone of the Asus Tiger 3in1, numbered 147 in the
> SAA7134 module, so I gave it the temporary number of 1470.
> 
> DVB-T and remote have been tested and work fine.
> DVB-S, FM and Composite input haven't been tested.
> 
> Hope that will help some of you.

In order to help adding support for this board, I re-wrote your code to
apply it against the latest build.

I suspect that your RC keycode table is incomplete, as it is getting just
the 8 least significant bits. So, you'll need to test it and fix the
IR keytable.

Please test. Feel free to modify it, as I suspect that you'll need to
re-work with the RC part of it.

Regards,
Mauro

- 

Add support for Asus My Cinema PS3-100 (1043:48cd)

Based on a previous patch from remi schwartz <remi.schwartz@gmail.com>

Thanks-to: Remi Schwartz <remi.schwartz@gmail.com>
Signed-off-to: Mauro Carvalho Chehab <mchehab@redhat.com>


Index: patchwork/drivers/media/video/saa7134/saa7134-input.c
===================================================================
--- patchwork.orig/drivers/media/video/saa7134/saa7134-input.c
+++ patchwork/drivers/media/video/saa7134/saa7134-input.c
@@ -753,6 +753,11 @@ int saa7134_input_init1(struct saa7134_d
 		mask_keycode = 0xffff;
 		raw_decode   = true;
 		break;
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
+		ir_codes     = RC_MAP_ASUS_PS3_100;
+		mask_keydown = 0x0040000;
+		raw_decode   = true;
+		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
 		ir_codes     = RC_MAP_ENCORE_ENLTV;
Index: patchwork/drivers/media/video/saa7134/saa7134-dvb.c
===================================================================
--- patchwork.orig/drivers/media/video/saa7134/saa7134-dvb.c
+++ patchwork/drivers/media/video/saa7134/saa7134-dvb.c
@@ -881,6 +881,20 @@ static struct tda1004x_config asus_tiger
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
@@ -1649,6 +1663,31 @@ static int dvb_init(struct saa7134_dev *
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
Index: patchwork/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- patchwork.orig/drivers/media/video/saa7134/saa7134-cards.c
+++ patchwork/drivers/media/video/saa7134/saa7134-cards.c
@@ -5080,6 +5080,36 @@ struct saa7134_board saa7134_boards[] =
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
@@ -6877,6 +6907,12 @@ struct pci_device_id saa7134_pci_tbl[] =
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
@@ -7350,6 +7386,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
+	case SAA7134_BOARD_ASUSTeK_PS3_100:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -7807,6 +7844,14 @@ int saa7134_board_init2(struct saa7134_d
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
Index: patchwork/drivers/media/video/saa7134/saa7134.h
===================================================================
--- patchwork.orig/drivers/media/video/saa7134/saa7134.h
+++ patchwork/drivers/media/video/saa7134/saa7134.h
@@ -332,6 +332,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_BEHOLD_503FM          187
 #define SAA7134_BOARD_SENSORAY811_911       188
 #define SAA7134_BOARD_KWORLD_PC150U         189
+#define SAA7134_BOARD_ASUSTeK_PS3_100	    190
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
Index: patchwork/drivers/media/rc/keymaps/rc-asus-ps3-100.c
===================================================================
--- /dev/null
+++ patchwork/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -0,0 +1,91 @@
+/* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
+ *
+ * Copyright (c) 2012 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+#include <linux/module.h>
+
+static struct rc_map_table asus_ps3_100[] = {
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
+static struct rc_map_list asus_ps3_100_map = {
+	.map = {
+		.scan    = asus_ps3_100,
+		.size    = ARRAY_SIZE(asus_ps3_100),
+		.rc_type = RC_TYPE_RC5,
+		.name    = RC_MAP_ASUS_PS3_100,
+	}
+};
+
+static int __init init_rc_map_asus_ps3_100(void)
+{
+	return rc_map_register(&asus_ps3_100_map);
+}
+
+static void __exit exit_rc_map_asus_ps3_100(void)
+{
+	rc_map_unregister(&asus_ps3_100_map);
+}
+
+module_init(init_rc_map_asus_ps3_100)
+module_exit(exit_rc_map_asus_ps3_100)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
