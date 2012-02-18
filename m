Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:28838 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2BRGZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 01:25:08 -0500
From: Kyle Strickland <kyle@kyle.strickland.name>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.com, Kyle Strickland <kyle@kyle.strickland.name>
Subject: [PATCH] Add support for KWorld PC150-U ATSC hybrid tuner card.
Date: Sat, 18 Feb 2012 01:24:53 -0500
Message-Id: <1329546293-23288-1-git-send-email-kyle@kyle.strickland.name>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kyle Strickland <kyle@kyle.strickland.name>
---
 Documentation/dvb/cards.txt                 |    1 +
 drivers/media/rc/keymaps/Makefile           |    1 +
 drivers/media/rc/keymaps/rc-kworld-pc150u.c |  102 +++++++++++++++++++++++++++
 drivers/media/video/saa7134/saa7134-cards.c |   59 +++++++++++++++
 drivers/media/video/saa7134/saa7134-dvb.c   |   43 +++++++++++
 drivers/media/video/saa7134/saa7134-i2c.c   |   12 +++-
 drivers/media/video/saa7134/saa7134-input.c |   63 ++++++++++++++++
 drivers/media/video/saa7134/saa7134.h       |    1 +
 include/media/rc-map.h                      |    1 +
 9 files changed, 282 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/rc/keymaps/rc-kworld-pc150u.c

diff --git a/Documentation/dvb/cards.txt b/Documentation/dvb/cards.txt
index cc09187..97709e9 100644
--- a/Documentation/dvb/cards.txt
+++ b/Documentation/dvb/cards.txt
@@ -119,4 +119,5 @@ o Cards based on the Phillips saa7134 PCI bridge:
   - Compro Videomate DVB-T300
   - Compro Videomate DVB-T200
   - AVerMedia AVerTVHD MCE A180
+  - KWorld PC150-U ATSC Hybrid
 
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index 9514d82..49ce266 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -45,6 +45,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-it913x-v2.o \
 			rc-kaiomy.o \
 			rc-kworld-315u.o \
+			rc-kworld-pc150u.o \
 			rc-kworld-plus-tv-analog.o \
 			rc-leadtek-y04g0051.o \
 			rc-lirc.o \
diff --git a/drivers/media/rc/keymaps/rc-kworld-pc150u.c b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
new file mode 100644
index 0000000..233bb5e
--- /dev/null
+++ b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
@@ -0,0 +1,102 @@
+/* kworld-pc150u.c - Keytable for kworld_pc150u Remote Controller
+ *
+ * keymap imported from ir-keymaps.c
+ *
+ * Copyright (c) 2010 by Kyle Strickland
+ *   (based on kworld-plus-tv-analog.c by
+ *    Mauro Carvalho Chehab <mchehab@redhat.com>)
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
+/* Kworld PC150-U
+   Kyle Strickland <kyle@kyle.strickland.name>
+ */
+
+static struct rc_map_table kworld_pc150u[] = {
+	{ 0x0c, KEY_MEDIA },		/* Kworld key */
+	{ 0x16, KEY_EJECTCLOSECD },	/* -> ) */
+	{ 0x1d, KEY_POWER2 },
+
+	{ 0x00, KEY_1 },
+	{ 0x01, KEY_2 },
+	{ 0x02, KEY_3 },
+	{ 0x03, KEY_4 },
+	{ 0x04, KEY_5 },
+	{ 0x05, KEY_6 },
+	{ 0x06, KEY_7 },
+	{ 0x07, KEY_8 },
+	{ 0x08, KEY_9 },
+	{ 0x0a, KEY_0 },
+
+	{ 0x09, KEY_AGAIN },
+	{ 0x14, KEY_MUTE },
+
+	{ 0x1e, KEY_LAST },
+	{ 0x17, KEY_ZOOM },
+	{ 0x1f, KEY_HOMEPAGE },
+	{ 0x0e, KEY_ESC },
+
+	{ 0x20, KEY_UP },
+	{ 0x21, KEY_DOWN },
+	{ 0x42, KEY_LEFT },
+	{ 0x43, KEY_RIGHT },
+	{ 0x0b, KEY_ENTER },
+
+	{ 0x10, KEY_CHANNELUP },
+	{ 0x11, KEY_CHANNELDOWN },
+
+	{ 0x13, KEY_VOLUMEUP },
+	{ 0x12, KEY_VOLUMEDOWN },
+
+	{ 0x19, KEY_TIME},		/* Timeshift */
+	{ 0x1a, KEY_STOP},
+	{ 0x1b, KEY_RECORD},
+	{ 0x4b, KEY_EMAIL},
+
+	{ 0x40, KEY_REWIND},
+	{ 0x44, KEY_PLAYPAUSE},
+	{ 0x41, KEY_FORWARD},
+	{ 0x22, KEY_TEXT},
+
+	{ 0x15, KEY_AUDIO},		/* ((*)) */
+	{ 0x0f, KEY_MODE},		/* display ratio */
+	{ 0x1c, KEY_SYSRQ},		/* snapshot */
+	{ 0x4a, KEY_SLEEP},		/* sleep timer */
+
+	{ 0x48, KEY_SOUND},		/* switch theater mode */
+	{ 0x49, KEY_BLUE},		/* A */
+	{ 0x18, KEY_RED},		/* B */
+	{ 0x23, KEY_GREEN},		/* C */
+};
+
+static struct rc_map_list kworld_pc150u_map = {
+	.map = {
+		.scan    = kworld_pc150u,
+		.size    = ARRAY_SIZE(kworld_pc150u),
+		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_KWORLD_PC150U,
+	}
+};
+
+static int __init init_rc_map_kworld_pc150u(void)
+{
+	return rc_map_register(&kworld_pc150u_map);
+}
+
+static void __exit exit_rc_map_kworld_pc150u(void)
+{
+	rc_map_unregister(&kworld_pc150u_map);
+}
+
+module_init(init_rc_map_kworld_pc150u)
+module_exit(exit_rc_map_kworld_pc150u)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kyle Strickland <kyle@kyle.strickland.name>");
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 065d0f6..24b9201 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -33,6 +33,7 @@
 #include "tea5767.h"
 #include "tda18271.h"
 #include "xc5000.h"
+#include "s5h1411.h"
 
 /* commly used strings */
 static char name_mute[]    = "mute";
@@ -5712,6 +5713,36 @@ struct saa7134_board saa7134_boards[] = {
 			.amux   = LINE1,
 		} },
 	},
+	[SAA7134_BOARD_KWORLD_PC150U] = {
+		.name           = "Kworld PC150-U",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 1 << 21,
+		.ts_type	= SAA7134_MPEG_TS_PARALLEL,
+		.inputs = { {
+			.name   = name_tv,
+			.vmux   = 1,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
+			.name   = name_comp,
+			.vmux   = 3,
+			.amux   = LINE1,
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE2,
+		} },
+		.radio = {
+			.name   = name_radio,
+			.amux   = TV,
+			.gpio	= 0x0000000,
+		},
+	},
 
 };
 
@@ -6306,6 +6337,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 		.driver_data  = SAA7134_BOARD_KWORLD_ATSC110, /* ATSC 115 */
 	},{
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133, /* SAA7135HL */
+		.subvendor    = 0x17de,
+		.subdevice    = 0xa134,
+		.driver_data  = SAA7134_BOARD_KWORLD_PC150U,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
 		.subvendor    = 0x1461,
 		.subdevice    = 0x7360,
@@ -7134,6 +7171,23 @@ static inline int saa7134_kworld_sbtvd_toggle_agc(struct saa7134_dev *dev,
 	return 0;
 }
 
+static int saa7134_kworld_pc150u_toggle_agc(struct saa7134_dev *dev,
+                                            enum tda18271_mode mode)
+{
+	switch (mode) {
+	case TDA18271_ANALOG:
+		saa7134_set_gpio(dev, 18, 0);
+		break;
+	case TDA18271_DIGITAL:
+		saa7134_set_gpio(dev, 18, 1);
+		msleep(30);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int saa7134_tda8290_18271_callback(struct saa7134_dev *dev,
 					  int command, int arg)
 {
@@ -7150,6 +7204,9 @@ static int saa7134_tda8290_18271_callback(struct saa7134_dev *dev,
 		case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
 			ret = saa7134_kworld_sbtvd_toggle_agc(dev, arg);
 			break;
+		case SAA7134_BOARD_KWORLD_PC150U:
+			ret = saa7134_kworld_pc150u_toggle_agc(dev, arg);
+			break;
 		default:
 			break;
 		}
@@ -7171,6 +7228,7 @@ static int saa7134_tda8290_callback(struct saa7134_dev *dev,
 	case SAA7134_BOARD_HAUPPAUGE_HVR1120:
 	case SAA7134_BOARD_AVERMEDIA_M733A:
 	case SAA7134_BOARD_KWORLD_PCI_SBTVD_FULLSEG:
+	case SAA7134_BOARD_KWORLD_PC150U:
 	case SAA7134_BOARD_MAGICPRO_PROHDTV_PRO2:
 		/* tda8290 + tda18271 */
 		ret = saa7134_tda8290_18271_callback(dev, command, arg);
@@ -7452,6 +7510,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_BEHOLD_X7:
 	case SAA7134_BOARD_BEHOLD_H7:
 	case SAA7134_BOARD_BEHOLD_A7:
+	case SAA7134_BOARD_KWORLD_PC150U:
 		dev->has_remote = SAA7134_REMOTE_I2C;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A169_B:
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 089fa0f..831ca31 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -61,6 +61,7 @@
 #include "zl10036.h"
 #include "zl10039.h"
 #include "mt312.h"
+#include "s5h1411.h"
 
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
@@ -1158,6 +1159,33 @@ static struct tda18271_config prohdtv_pro2_tda18271_config = {
 	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
+static struct tda18271_std_map kworld_tda18271_std_map = {
+	.atsc_6   = { .if_freq = 3250, .agc_mode = 3, .std = 3,
+	              .if_lvl = 6, .rfagc_top = 0x37 },
+	.qam_6    = { .if_freq = 4000, .agc_mode = 3, .std = 0,
+	              .if_lvl = 6, .rfagc_top = 0x37 },
+};
+
+static struct tda18271_config kworld_pc150u_tda18271_config = {
+	.std_map = &kworld_tda18271_std_map,
+	.gate    = TDA18271_GATE_ANALOG,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
+	.config  = 3,	/* Use tuner callback for AGC */
+	.rf_cal_on_startup = 1
+};
+
+static struct s5h1411_config kworld_s5h1411_config = {
+	.output_mode   = S5H1411_PARALLEL_OUTPUT,
+	.gpio          = S5H1411_GPIO_OFF,
+	.qam_if        = S5H1411_IF_4000,
+	.vsb_if        = S5H1411_IF_3250,
+	.inversion     = S5H1411_INVERSION_ON,
+	.status_mode   = S5H1411_DEMODLOCKING,
+	.mpeg_timing   =
+		S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
+};
+
+
 /* ==================================================================
  * Core code
  */
@@ -1438,6 +1466,21 @@ static int dvb_init(struct saa7134_dev *dev)
 				   &dev->i2c_adap, 0x61,
 				   TUNER_PHILIPS_TUV1236D);
 		break;
+	case SAA7134_BOARD_KWORLD_PC150U:
+		saa7134_set_gpio(dev, 18, 1); /* Switch to digital mode */
+		saa7134_tuner_callback(dev, 0,
+				       TDA18271_CALLBACK_CMD_AGC_ENABLE, 1);
+		fe0->dvb.frontend = dvb_attach(s5h1411_attach, &kworld_s5h1411_config,
+					       &dev->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(tda829x_attach, fe0->dvb.frontend,
+				   &dev->i2c_adap, 0x4b,
+				   &tda829x_no_probe);
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
+				   0x60, &dev->i2c_adap,
+				   &kworld_pc150u_tda18271_config);
+		}
+		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
 		fe0->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
 					       &dev->i2c_adap);
diff --git a/drivers/media/video/saa7134/saa7134-i2c.c b/drivers/media/video/saa7134/saa7134-i2c.c
index 2d3f6d2..d175ff5 100644
--- a/drivers/media/video/saa7134/saa7134-i2c.c
+++ b/drivers/media/video/saa7134/saa7134-i2c.c
@@ -254,7 +254,7 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 			addr  = msgs[i].addr << 1;
 			if (msgs[i].flags & I2C_M_RD)
 				addr |= 1;
-			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40) {
+			if (i > 0 && msgs[i].flags & I2C_M_RD && msgs[i].addr != 0x40 && msgs[i].addr != 0x19) {
 				/* workaround for a saa7134 i2c bug
 				 * needed to talk to the mt352 demux
 				 * thanks to pinnacle for the hint */
@@ -279,6 +279,16 @@ static int saa7134_i2c_xfer(struct i2c_adapter *i2c_adap,
 				d1printk("%02x", rc);
 				msgs[i].buf[byte] = rc;
 			}
+			/* discard mysterious extra byte when reading
+                           from Samsung S5H1411.  i2c bus gets error
+			   if we do not. */
+			if(0x19 == msgs[i].addr) {
+				d1printk(" ?");
+				rc = i2c_recv_byte(dev);
+				if (rc < 0)
+					goto err;
+				d1printk("%02x", rc);
+			}
 		} else {
 			/* write bytes */
 			d2printk("write bytes\n");
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 22ecd72..12663d0 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -210,6 +210,54 @@ static int get_key_msi_tvanywhere_plus(struct IR_i2c *ir, u32 *ir_key,
 	return 1;
 }
 
+/* copied and modified from get_key_msi_tvanywhere_plus() */
+static int get_key_kworld_pc150u(struct IR_i2c *ir, u32 *ir_key,
+				        u32 *ir_raw)
+{
+	unsigned char b;
+	unsigned int gpio;
+
+	/* <dev> is needed to access GPIO. Used by the saa_readl macro. */
+	struct saa7134_dev *dev = ir->c->adapter->algo_data;
+	if (dev == NULL) {
+		i2cdprintk("get_key_kworld_pc150u: "
+			   "ir->c->adapter->algo_data is NULL!\n");
+		return -EIO;
+	}
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+
+	saa_clearb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+	saa_setb(SAA7134_GPIO_GPMODE3, SAA7134_GPIO_GPRESCAN);
+
+	gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
+
+	/* GPIO&0x100 is pulsed low when a button is pressed. Don't do
+	   I2C receive if gpio&0x100 is not low. */
+
+	if (gpio & 0x100)
+		return 0;       /* No button press */
+
+	/* GPIO says there is a button press. Get it. */
+
+	if (1 != i2c_master_recv(ir->c, &b, 1)) {
+		i2cdprintk("read error\n");
+		return -EIO;
+	}
+
+	/* No button press */
+
+	if (b == 0xff)
+		return 0;
+
+	/* Button pressed */
+
+	dprintk("get_key_kworld_pc150u: Key = 0x%02X\n", b);
+	*ir_key = b;
+	*ir_raw = b;
+	return 1;
+}
+
 static int get_key_purpletv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 {
 	unsigned char b;
@@ -901,6 +949,21 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 			msg_msi.addr, dev->i2c_adap.name,
 			(1 == rc) ? "yes" : "no");
 		break;
+	case SAA7134_BOARD_KWORLD_PC150U:
+		/* copied and modified from MSI TV@nywhere Plus */
+		dev->init_data.name = "Kworld PC150-U";
+		dev->init_data.get_key = get_key_kworld_pc150u;
+		dev->init_data.ir_codes = RC_MAP_KWORLD_PC150U;
+		info.addr = 0x30;
+		/* MSI TV@nywhere Plus controller doesn't seem to
+		   respond to probes unless we read something from
+		   an existing device. Weird...
+		   REVISIT: might no longer be needed */
+		rc = i2c_transfer(&dev->i2c_adap, &msg_msi, 1);
+		dprintk("probe 0x%02x @ %s: %s\n",
+			msg_msi.addr, dev->i2c_adap.name,
+			(1 == rc) ? "yes" : "no");
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index 42fba4f..bc2cf9a 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -331,6 +331,7 @@ struct saa7134_card_ir {
 #define SAA7134_BOARD_BEHOLD_501            186
 #define SAA7134_BOARD_BEHOLD_503FM          187
 #define SAA7134_BOARD_SENSORAY811_911       188
+#define SAA7134_BOARD_KWORLD_PC150U         189
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 5b988d7..8db6741 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -106,6 +106,7 @@ void rc_map_init(void);
 #define RC_MAP_IT913X_V2                 "rc-it913x-v2"
 #define RC_MAP_KAIOMY                    "rc-kaiomy"
 #define RC_MAP_KWORLD_315U               "rc-kworld-315u"
+#define RC_MAP_KWORLD_PC150U             "rc-kworld-pc150u"
 #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
 #define RC_MAP_LEADTEK_Y04G0051          "rc-leadtek-y04g0051"
 #define RC_MAP_LIRC                      "rc-lirc"
-- 
1.7.5.4

