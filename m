Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:17430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab1AXPVP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 10:21:15 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFLEor026123
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:21:15 -0500
Received: from pedra (vpn-236-9.phx2.redhat.com [10.3.236.9])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p0OFJARn027064
	for <linux-media@vger.kernel.org>; Mon, 24 Jan 2011 10:21:13 -0500
Date: Mon, 24 Jan 2011 13:18:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/13] [media] remove the old RC_MAP_HAUPPAUGE_NEW RC map
Message-ID: <20110124131848.59f438d3@pedra>
In-Reply-To: <cover.1295882104.git.mchehab@redhat.com>
References: <cover.1295882104.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The rc-hauppauge-new map is a messy thing, as it bundles 3
different remote controllers as if they were just one,
discarding the address byte. Also, some key maps are wrong.

With the conversion to the new rc-core, it is likely that
most of the devices won't be working properly, as the i2c
driver and the raw decoders are now providing 16 bits for
the remote, instead of just 8.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c

diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index b82756d..1d79ada 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -26,7 +26,7 @@
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at http://www.linuxtv.org/
  */
 
 #include <linux/module.h>
@@ -102,6 +102,7 @@ struct budget_ci_ir {
 	int rc5_device;
 	u32 ir_key;
 	bool have_command;
+	bool full_rc5;		/* Outputs a full RC5 code */
 };
 
 struct budget_ci {
@@ -154,11 +155,18 @@ static void msp430_ir_interrupt(unsigned long data)
 		return;
 	budget_ci->ir.have_command = false;
 
-	/* FIXME: We should generate complete scancodes with device info */
 	if (budget_ci->ir.rc5_device != IR_DEVICE_ANY &&
 	    budget_ci->ir.rc5_device != (command & 0x1f))
 		return;
 
+	if (budget_ci->ir.full_rc5) {
+		rc_keydown(dev,
+			   budget_ci->ir.rc5_device <<8 | budget_ci->ir.ir_key,
+			   (command & 0x20) ? 1 : 0);
+		return;
+	}
+
+	/* FIXME: We should generate complete scancodes for all devices */
 	rc_keydown(dev, budget_ci->ir.ir_key, (command & 0x20) ? 1 : 0);
 }
 
@@ -206,7 +214,8 @@ static int msp430_ir_init(struct budget_ci *budget_ci)
 	case 0x1011:
 	case 0x1012:
 		/* The hauppauge keymap is a superset of these remotes */
-		dev->map_name = RC_MAP_HAUPPAUGE_NEW;
+		dev->map_name = RC_MAP_HAUPPAUGE;
+		budget_ci->ir.full_rc5 = true;
 
 		if (rc5_device < 0)
 			budget_ci->ir.rc5_device = 0x1f;
diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index c79e192..e6bd958 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-gadmei-rm008z.o \
 			rc-genius-tvgo-a11mce.o \
 			rc-gotview7135.o \
-			rc-hauppauge-new.o \
 			rc-imon-mce.o \
 			rc-imon-pad.o \
 			rc-iodata-bctv7e.o \
diff --git a/drivers/media/rc/keymaps/rc-hauppauge-new.c b/drivers/media/rc/keymaps/rc-hauppauge-new.c
deleted file mode 100644
index 44f3283..0000000
--- a/drivers/media/rc/keymaps/rc-hauppauge-new.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/* hauppauge-new.h - Keytable for hauppauge_new Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-
-/* Hauppauge: the newer, gray remotes (seems there are multiple
- * slightly different versions), shipped with cx88+ivtv cards.
- * almost rc5 coding, but some non-standard keys */
-
-static struct rc_map_table hauppauge_new[] = {
-	/* Keys 0 to 9 */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0a, KEY_TEXT },		/* keypad asterisk as well */
-	{ 0x0b, KEY_RED },		/* red button */
-	{ 0x0c, KEY_RADIO },
-	{ 0x0d, KEY_MENU },
-	{ 0x0e, KEY_SUBTITLE },		/* also the # key */
-	{ 0x0f, KEY_MUTE },
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x12, KEY_PREVIOUS },		/* previous channel */
-	{ 0x14, KEY_UP },
-	{ 0x15, KEY_DOWN },
-	{ 0x16, KEY_LEFT },
-	{ 0x17, KEY_RIGHT },
-	{ 0x18, KEY_VCR },		/* Videos */
-	{ 0x19, KEY_AUDIO },		/* Music */
-	/* 0x1a: Pictures - presume this means
-	   "Multimedia Home Platform" -
-	   no "PICTURES" key in input.h
-	 */
-	{ 0x1a, KEY_CAMERA },
-
-	{ 0x1b, KEY_EPG },		/* Guide */
-	{ 0x1c, KEY_TV },
-	{ 0x1e, KEY_NEXTSONG },		/* skip >| */
-	{ 0x1f, KEY_EXIT },		/* back/exit */
-	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x22, KEY_VIDEO },		/* source (old black remote) */
-	{ 0x24, KEY_PREVIOUSSONG },	/* replay |< */
-	{ 0x25, KEY_ENTER },		/* OK */
-	{ 0x26, KEY_SLEEP },		/* minimize (old black remote) */
-	{ 0x29, KEY_BLUE },		/* blue key */
-	{ 0x2e, KEY_GREEN },		/* green button */
-	{ 0x30, KEY_PAUSE },		/* pause */
-	{ 0x32, KEY_REWIND },		/* backward << */
-	{ 0x34, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x35, KEY_PLAY },
-	{ 0x36, KEY_STOP },
-	{ 0x37, KEY_RECORD },		/* recording */
-	{ 0x38, KEY_YELLOW },		/* yellow key */
-	{ 0x3b, KEY_SELECT },		/* top right button */
-	{ 0x3c, KEY_ZOOM },		/* full */
-	{ 0x3d, KEY_POWER },		/* system power (green button) */
-};
-
-static struct rc_map_list hauppauge_new_map = {
-	.map = {
-		.scan    = hauppauge_new,
-		.size    = ARRAY_SIZE(hauppauge_new),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_HAUPPAUGE_NEW,
-	}
-};
-
-static int __init init_rc_map_hauppauge_new(void)
-{
-	return rc_map_register(&hauppauge_new_map);
-}
-
-static void __exit exit_rc_map_hauppauge_new(void)
-{
-	rc_map_unregister(&hauppauge_new_map);
-}
-
-module_init(init_rc_map_hauppauge_new)
-module_exit(exit_rc_map_hauppauge_new)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index c330fb9..040aaa8 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -96,7 +96,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
 	case CX18_HW_Z8F0811_IR_RX_HAUP:
-		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = RC_TYPE_RC5;
 		init_data->name = cx->card_name;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 06f7d1d..9171775 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -283,7 +283,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PCHDTV_HD3000:
 	case CX88_BOARD_PCHDTV_HD5500:
 	case CX88_BOARD_HAUPPAUGE_IRONLY:
-		ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		ir_codes = RC_MAP_HAUPPAUGE;
 		ir->sampling = 1;
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
@@ -603,7 +603,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 		if (*addrp == 0x71) {
 			/* Hauppauge XVR */
 			core->init_data.name = "cx88 Hauppauge XVR remote";
-			core->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
+			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 			core->init_data.type = RC_TYPE_RC5;
 			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index aa4f45e..69fcea8 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -834,7 +834,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware = 1,
 		.has_dvb      = 1,
 		.dvb_gpio     = hauppauge_wintv_hvr_900_digital,
-		.ir_codes     = RC_MAP_HAUPPAUGE_NEW,
+		.ir_codes     = RC_MAP_HAUPPAUGE,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -859,7 +859,7 @@ struct em28xx_board em28xx_boards[] = {
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
-		.ir_codes     = RC_MAP_HAUPPAUGE_NEW,
+		.ir_codes     = RC_MAP_HAUPPAUGE,
 		.decoder      = EM28XX_TVP5150,
 		.input        = { {
 			.type     = EM28XX_VMUX_TELEVISION,
@@ -885,7 +885,7 @@ struct em28xx_board em28xx_boards[] = {
 		.mts_firmware   = 1,
 		.has_dvb        = 1,
 		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
-		.ir_codes       = RC_MAP_HAUPPAUGE_NEW,
+		.ir_codes       = RC_MAP_HAUPPAUGE,
 		.decoder        = EM28XX_TVP5150,
 		.input          = { {
 			.type     = EM28XX_VMUX_TELEVISION,
diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/video/hdpvr/hdpvr-i2c.c
index 89b71fa..ca2c85d 100644
--- a/drivers/media/video/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/video/hdpvr/hdpvr-i2c.c
@@ -42,7 +42,7 @@ int hdpvr_register_i2c_ir(struct hdpvr_device *dev)
 	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
 
 	/* Our default information for ir-kbd-i2c.c to use */
-	init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
+	init_data->ir_codes = RC_MAP_HAUPPAUGE;
 	init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 	init_data->type = RC_TYPE_RC5;
 	init_data->name = "HD PVR";
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index d2b20ad..b18373a 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -300,7 +300,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->get_key = get_key_haup;
 		rc_type     = RC_TYPE_RC5;
 		if (hauppauge == 1) {
-			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
+			ir_codes    = RC_MAP_HAUPPAUGE;
 		} else {
 			ir_codes    = RC_MAP_RC5_TV;
 		}
@@ -327,7 +327,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
 		rc_type     = RC_TYPE_RC5;
-		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE_NEW : RC_MAP_RC5_TV;
+		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE : RC_MAP_RC5_TV;
 		break;
 	}
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 9fb86a0..3c89d6f 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -213,7 +213,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		break;
 	case IVTV_HW_Z8F0811_IR_RX_HAUP:
 		/* Default to grey remote */
-		init_data->ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
index ccc8849..1a529ef 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
@@ -578,7 +578,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 	switch (hdw->ir_scheme_active) {
 	case PVR2_IR_SCHEME_24XXX: /* FX2-controlled IR */
 	case PVR2_IR_SCHEME_29XXX: /* Original 29xxx device */
-		init_data->ir_codes              = RC_MAP_HAUPPAUGE_NEW;
+		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
 		init_data->type                  = RC_TYPE_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
@@ -593,7 +593,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 		break;
 	case PVR2_IR_SCHEME_ZILOG:     /* HVR-1950 style */
 	case PVR2_IR_SCHEME_24XXX_MCE: /* 24xxx MCE device */
-		init_data->ir_codes              = RC_MAP_HAUPPAUGE_NEW;
+		init_data->ir_codes              = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type                  = RC_TYPE_RC5;
 		init_data->name                  = hdw->hdw_desc->description;
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index c9eff03..c504c30 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -864,7 +864,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		dev->init_data.name = "HVR 1110";
 		dev->init_data.get_key = get_key_hvr1110;
-		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
+		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 		info.addr = 0x71;
 		break;
 	case SAA7134_BOARD_BEHOLD_607FM_MK3:
-- 
1.7.1

