Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56074 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab0BPRJf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 12:09:35 -0500
Received: by bwz5 with SMTP id 5so2121554bwz.1
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 09:09:32 -0800 (PST)
From: Kash <123kash@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Twinhan 1027 + IR Port support
Date: Tue, 16 Feb 2010 20:09:05 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002162009.05841.123kash@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok. 4th try (and i hope the last) to submit this stupid patch. This
patch applies correctly to current mercurial revision (tried 2 times.
patch -p 1 vp1027+ir.patch).
Now about changes. Patch add support of TwinHan 1027 DVB-S card.
Original author is Manu Abraham (abraham dot manu at gmail dot com).
IR Port support is my job.


diff -r 14021dfc00f3 linux/drivers/media/IR/ir-keymaps.c
--- a/linux/drivers/media/IR/ir-keymaps.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/IR/ir-keymaps.c	Mon Feb 15 12:52:54 2010 +0300
@@ -3552,3 +3552,72 @@
 	.ir_type = IR_TYPE_NEC,
 };
 EXPORT_SYMBOL_GPL(ir_codes_kworld_315u_table);
+
+/* Twinhan vp1027 DVB-S remote
+   Sergey _Kash_ Ivanov 123kash@gmail.com
+*/
+static struct ir_scancode ir_codes_twinhan_vp1027_dvbs[] = {
+	{ 0x16, KEY_POWER2 },
+	{ 0x17, KEY_FAVORITES },
+	{ 0x0f, KEY_TEXT },
+	{ 0x48, KEY_INFO},
+	{ 0x1c, KEY_EPG },
+	{ 0x04, KEY_LIST },
+
+	{ 0x03, KEY_1 },
+	{ 0x01, KEY_2 },
+	{ 0x06, KEY_3 },
+	{ 0x09, KEY_4 },
+	{ 0x1d, KEY_5 },
+	{ 0x1f, KEY_6 },
+	{ 0x0d, KEY_7 },
+	{ 0x19, KEY_8 },
+	{ 0x1b, KEY_9 },
+	{ 0x15, KEY_0 },
+
+	{ 0x0c, KEY_CANCEL },
+	{ 0x4a, KEY_CLEAR },
+	{ 0x13, KEY_BACKSPACE },
+	{ 0x00, KEY_TAB },
+
+	{ 0x4b, KEY_UP },
+	{ 0x51, KEY_DOWN },
+	{ 0x4e, KEY_LEFT },
+	{ 0x52, KEY_RIGHT },
+	{ 0x4f, KEY_ENTER },
+
+	{ 0x1e, KEY_VOLUMEUP },
+	{ 0x0a, KEY_VOLUMEDOWN },
+	{ 0x02, KEY_CHANNELDOWN },
+	{ 0x05, KEY_CHANNELUP },
+	{ 0x11, KEY_RECORD },
+
+	{ 0x14, KEY_PLAY },
+	{ 0x4c, KEY_PAUSE },
+	{ 0x1a, KEY_STOP },
+	{ 0x40, KEY_REWIND },
+	{ 0x12, KEY_FASTFORWARD },
+	{ 0x41, KEY_PREVIOUSSONG },
+	{ 0x42, KEY_NEXTSONG },
+	{ 0x54, KEY_SAVE },
+	{ 0x50, KEY_LANGUAGE },
+	{ 0x47, KEY_MEDIA },
+	{ 0x4d, KEY_SCREEN },
+	{ 0x43, KEY_SUBTITLE },
+	{ 0x10, KEY_MUTE },
+	{ 0x49, KEY_AUDIO },
+	{ 0x07, KEY_SLEEP },
+	{ 0x08, KEY_VIDEO },
+	{ 0x0e, KEY_AGAIN },
+	{ 0x45, KEY_EQUAL },
+	{ 0x46, KEY_MINUS },
+	{ 0x18, KEY_RED },
+	{ 0x53, KEY_GREEN },
+	{ 0x5e, KEY_YELLOW },
+	{ 0x5f, KEY_BLUE },
+};
+struct ir_scancode_table ir_codes_twinhan_vp1027_dvbs_table = {
+	.scan = ir_codes_twinhan_vp1027_dvbs,
+	.size = ARRAY_SIZE(ir_codes_twinhan_vp1027_dvbs),
+};
+EXPORT_SYMBOL_GPL(ir_codes_twinhan_vp1027_dvbs_table);
diff -r 14021dfc00f3 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Mon Feb 15 12:52:54 2010 +0300
@@ -2120,6 +2120,18 @@
 		} },
 		.mpeg           = CX88_MPEG_DVB,
 	},
+	[CX88_BOARD_TWINHAN_VP1027_DVBS] = {
+		.name		= "Twinhan VP-1027 DVB-S",
+		.tuner_type     = TUNER_ABSENT,
+		.radio_type     = UNSET,
+		.tuner_addr     = ADDR_UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = {{
+		       .type   = CX88_VMUX_DVB,
+		       .vmux   = 0,
+		} },
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 
 /* ------------------------------------------------------------------ */
@@ -2584,6 +2596,10 @@
 		.subvendor = 0xb034,
 		.subdevice = 0x3034,
 		.card      = CX88_BOARD_PROF_7301,
+	}, {
+		.subvendor = 0x1822,
+		.subdevice = 0x0023,
+		.card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
 	},
 };
 
@@ -3075,6 +3091,13 @@
 		cx_set(MO_GP1_IO, 0x10);
 		mdelay(50);
 		break;
+
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
+		cx_write(MO_GP0_IO, 0x00003230);
+		cx_write(MO_GP0_IO, 0x00003210);
+		msleep(1);
+		cx_write(MO_GP0_IO, 0x00001230);
+		break;
 	}
 }
 
diff -r 14021dfc00f3 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Mon Feb 15 12:52:54 2010 +0300
@@ -57,6 +57,7 @@
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
+#include "mb86a16.h"
 
 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -251,6 +252,10 @@
 	.if2           = 45600,
 };
 
+static struct mb86a16_config twinhan_vp1027 = {
+	.demod_address  = 0x08,
+};
+
 #if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
@@ -430,15 +435,41 @@
 
 	cx_set(MO_GP0_IO, 0x6040);
 	switch (voltage) {
-		case SEC_VOLTAGE_13:
-			cx_clear(MO_GP0_IO, 0x20);
-			break;
-		case SEC_VOLTAGE_18:
-			cx_set(MO_GP0_IO, 0x20);
-			break;
-		case SEC_VOLTAGE_OFF:
-			cx_clear(MO_GP0_IO, 0x20);
-			break;
+	case SEC_VOLTAGE_13:
+		cx_clear(MO_GP0_IO, 0x20);
+		break;
+	case SEC_VOLTAGE_18:
+		cx_set(MO_GP0_IO, 0x20);
+		break;
+	case SEC_VOLTAGE_OFF:
+		cx_clear(MO_GP0_IO, 0x20);
+		break;
+	}
+
+	if (core->prev_set_voltage)
+		return core->prev_set_voltage(fe, voltage);
+	return 0;
+}
+
+static int vp1027_set_voltage(struct dvb_frontend *fe,
+				    fe_sec_voltage_t voltage)
+{
+	struct cx8802_dev *dev = fe->dvb->priv;
+	struct cx88_core *core = dev->core;
+
+	switch (voltage) {
+	case SEC_VOLTAGE_13:
+		dprintk(1, "LNB SEC Voltage=13\n");
+		cx_write(MO_GP0_IO, 0x00001220);
+		break;
+	case SEC_VOLTAGE_18:
+		dprintk(1, "LNB SEC Voltage=18\n");
+		cx_write(MO_GP0_IO, 0x00001222);
+		break;
+	case SEC_VOLTAGE_OFF:
+		dprintk(1, "LNB Voltage OFF\n");
+		cx_write(MO_GP0_IO, 0x00001230);
+		break;
 	}
 
 	if (core->prev_set_voltage)
@@ -1210,6 +1241,19 @@
 		}
 		break;
 		}
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
+		dev->ts_gen_cntrl = 0x00;
+		fe0->dvb.frontend = dvb_attach(mb86a16_attach,
+						&twinhan_vp1027,
+						&core->i2c_adap);
+		if (fe0->dvb.frontend) {
+			core->prev_set_voltage =
+					fe0->dvb.frontend->ops.set_voltage;
+			fe0->dvb.frontend->ops.set_voltage =
+					vp1027_set_voltage;
+		}
+		break;
+
 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
 		       core->name);
diff -r 14021dfc00f3 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Mon Feb 15 12:52:54 2010 +0300
@@ -350,6 +350,11 @@
 		ir->mask_keycode = 0x7e;
 		ir->polling      = 100; /* ms */
 		break;
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
+		ir_codes         = &ir_codes_twinhan_vp1027_dvbs_table;
+		ir_type          = IR_TYPE_PD;
+		ir->sampling     = 0xff00; /* address */
+		break;
 	}
 
 	if (NULL == ir_codes) {
@@ -467,6 +472,7 @@
 	case CX88_BOARD_PROF_7300:
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);
 
 		if (ircode == 0xffffffff) { /* decoding error */
diff -r 14021dfc00f3 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Mon Feb 15 12:52:54 2010 +0300
@@ -240,6 +240,7 @@
 #define CX88_BOARD_WINFAST_DTV1800H        81
 #define CX88_BOARD_WINFAST_DTV2000H_J      82
 #define CX88_BOARD_PROF_7301               83
+#define CX88_BOARD_TWINHAN_VP1027_DVBS     84
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
diff -r 14021dfc00f3 linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h	Thu Feb 11 23:11:30 2010 -0200
+++ b/linux/include/media/ir-common.h	Mon Feb 15 12:52:54 2010 +0300
@@ -163,4 +163,5 @@
 extern struct ir_scancode_table ir_codes_gadmei_rm008z_table;
 extern struct ir_scancode_table ir_codes_nec_terratec_cinergy_xs_table;
 extern struct ir_scancode_table ir_codes_winfast_usbii_deluxe_table;
+extern struct ir_scancode_table ir_codes_twinhan_vp1027_dvbs_table;
 #endif


-- 
WBR Sergey Kash Ivanov.
