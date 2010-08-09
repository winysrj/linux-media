Return-path: <123kash@gmail.com>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38084 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0HINSd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 09:18:33 -0400
Received: by bwz3 with SMTP id 3so1209150bwz.19
        for <linux-media@vger.kernel.org>; Mon, 09 Aug 2010 06:18:32 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Aug 2010 17:18:32 +0400
Message-ID: <AANLkTinUTTW4T0u9SwCbuxDfSE8ddfzmyy82JxL3yvgV@mail.gmail.com>
Subject: [PATCH] Twinhan 1027 + IR Port support
From: Sergey Ivanov <123kash@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refreshed version of https://patchwork.kernel.org/patch/79753/ patch
(adapted for the new IR system), still works...

diff --git a/drivers/media/IR/keymaps/Makefile
b/drivers/media/IR/keymaps/Makefile
index aea649f..7393d31 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-terratec-cinergy-xs.o \
 			rc-tevii-nec.o \
 			rc-tt-1500.o \
+			rc-twinhan1027.o \
 			rc-videomate-s350.o \
 			rc-videomate-tv-pvr.o \
 			rc-winfast.o \
diff --git a/drivers/media/IR/keymaps/rc-twinhan1027.c
b/drivers/media/IR/keymaps/rc-twinhan1027.c
new file mode 100644
index 0000000..15da792
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-twinhan1027.c
@@ -0,0 +1,87 @@
+#include <media/rc-map.h>
+
+static struct ir_scancode twinhan_vp1027[] = {
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
+
+static struct rc_keymap twinhan_vp1027_map = {
+	.map = {
+		.scan    = twinhan_vp1027,
+		.size    = ARRAY_SIZE(twinhan_vp1027),
+		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.name    = RC_MAP_TWINHAN_VP1027_DVBS,
+	}
+};
+
+static int __init init_rc_map_twinhan_vp1027(void)
+{
+	return ir_register_map(&twinhan_vp1027_map);
+}
+
+static void __exit exit_rc_map_twinhan_vp1027(void)
+{
+	ir_unregister_map(&twinhan_vp1027_map);
+}
+
+module_init(init_rc_map_twinhan_vp1027)
+module_exit(exit_rc_map_twinhan_vp1027)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sergey Ivanov <123kash@gmail.com>");
diff --git a/drivers/media/video/cx88/cx88-cards.c
b/drivers/media/video/cx88/cx88-cards.c
index 2918a6e..03fdbad 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -2100,6 +2100,18 @@ static const struct cx88_board cx88_boards[] = {
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
@@ -2572,6 +2584,10 @@ static const struct cx88_subid cx88_subids[] = {
 		.subvendor = 0xb034,
 		.subdevice = 0x3034,
 		.card      = CX88_BOARD_PROF_7301,
+	}, {
+		.subvendor = 0x1822,
+		.subdevice = 0x0023,
+		.card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
 	},
 };

@@ -3066,6 +3082,13 @@ static void cx88_card_setup_pre_i2c(struct
cx88_core *core)
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

diff --git a/drivers/media/video/cx88/cx88-dvb.c
b/drivers/media/video/cx88/cx88-dvb.c
index faa8e81..4ddd109 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -56,6 +56,7 @@
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
+#include "mb86a16.h"

 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -250,6 +251,10 @@ static struct zl10353_config
cx88_terratec_cinergy_ht_pci_mkii_config = {
 	.if2           = 45600,
 };

+static struct mb86a16_config twinhan_vp1027 = {
+	.demod_address  = 0x08,
+};
+
 #if defined(CONFIG_VIDEO_CX88_VP3054) ||
(defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
@@ -429,15 +434,41 @@ static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,

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
@@ -1416,6 +1447,18 @@ static int dvb_register(struct cx8802_dev *dev)
 		}

 		break;
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

 	default:
 		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't
supported yet\n",
diff --git a/drivers/media/video/cx88/cx88-input.c
b/drivers/media/video/cx88/cx88-input.c
index e185289..3b6e2c7 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -413,6 +413,11 @@ int cx88_ir_init(struct cx88_core *core, struct
pci_dev *pci)
 		ir->mask_keycode = 0x7e;
 		ir->polling      = 100; /* ms */
 		break;
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
+		ir_codes         = RC_MAP_TWINHAN_VP1027_DVBS;
+		ir_type          = IR_TYPE_NEC;
+		ir->sampling     = 0xff00; /* address */
+		break;
 	}

 	if (NULL == ir_codes) {
@@ -542,6 +547,7 @@ void cx88_ir_irq(struct cx88_core *core)
 	case CX88_BOARD_PROF_7300:
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
+	case CX88_BOARD_TWINHAN_VP1027_DVBS:
 		ircode = ir_decode_pulsedistance(ir->samples, ir->scount, 1, 4);

 		if (ircode == 0xffffffff) { /* decoding error */
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index bdb03d3..9e8fea1 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -240,6 +240,7 @@ extern struct sram_channel cx88_sram_channels[];
 #define CX88_BOARD_WINFAST_DTV2000H_J      82
 #define CX88_BOARD_PROF_7301               83
 #define CX88_BOARD_SAMSUNG_SMT_7020        84
+#define CX88_BOARD_TWINHAN_VP1027_DVBS     85

 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index c78e99a..29efb5d 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -112,6 +112,7 @@ void rc_map_init(void);
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
 #define RC_MAP_TT_1500                   "rc-tt-1500"
+#define RC_MAP_TWINHAN_VP1027_DVBS       "rc-twinhan1027"
 #define RC_MAP_VIDEOMATE_S350            "rc-videomate-s350"
 #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
 #define RC_MAP_WINFAST                   "rc-winfast"
