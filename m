Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:21:11 -0400
Date: Sun, 1 Aug 2010 17:21:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Udi Atar <udia@siano-ms.com>
Subject: [PATCH 6/6] V4L/DVB: sms: Convert IR support to use the Remote
 Controller core
Message-ID: <20100801172134.014ecec3@pedra>
In-Reply-To: <cover.1280693675.git.mchehab@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rewrites the siano IR implementation. The previous implementation were
non-standard. As such, it has issues if more than one device registers IR,
as there used to have some static constants used during protocol decoding
phase. Also, it used to implement its on RAW decoder, and only for RC5.

The new code uses RC core subsystem for handling IR. This brings several
new features to the driver, including:
	- Allow to dynamically replace the IR keycodes;
	- Supports all existing raw decoders (JVC, NEC, RC-5, RC-6, SONY);
	- Supports lirc dev;
	- Doesn't have race conditions when more than one sms IR is
	  registered;
	- The code size for the IR implementation is very small;
	- it exports the IR features via /sys/class/rc.

Cc: Udi Atar <udia@siano-ms.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 94a8577..15a0f19 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -497,8 +497,9 @@ int __ir_input_register(struct input_dev *input_dev,
 				goto out_event;
 		}
 
-	IR_dprintk(1, "Registered input device on %s for %s remote.\n",
-		   driver_name, rc_tab->name);
+	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
+		   driver_name, rc_tab->name,
+		   ir_dev->props->driver_type == RC_DRIVER_IR_RAW ? " in raw mode" : "");
 
 	return 0;
 
diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index dcde606..25b43e5 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -64,6 +64,7 @@ static struct sms_board sms_boards[] = {
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.rc_codes = RC_MAP_RC5_HAUPPAUGE_NEW,
 		.board_cfg.leds_power = 26,
 		.board_cfg.led0 = 27,
 		.board_cfg.led1 = 28,
diff --git a/drivers/media/dvb/siano/sms-cards.h b/drivers/media/dvb/siano/sms-cards.h
index 8f19fc0..d8cdf75 100644
--- a/drivers/media/dvb/siano/sms-cards.h
+++ b/drivers/media/dvb/siano/sms-cards.h
@@ -75,7 +75,7 @@ struct sms_board {
 	enum sms_device_type_st type;
 	char *name, *fw[DEVICE_MODE_MAX];
 	struct sms_board_gpio_cfg board_cfg;
-	enum ir_kb_type ir_kb_type;
+	char *rc_codes;				/* Name of IR codes table */
 
 	/* gpios */
 	int led_power, led_hi, led_lo, lna_ctrl, rf_switch;
diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index f8a4fd6..fbb6742 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -4,6 +4,11 @@
  MDTV receiver kernel modules.
  Copyright (C) 2006-2009, Uri Shkolnik
 
+ Copyright (c) 2010 - Mauro Carvalho Chehab
+	- Ported the driver to use rc-core
+	- IR raw event decoding is now done at rc-core
+	- Code almost re-written
+
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 2 of the License, or
@@ -22,227 +27,27 @@
 
 #include <linux/types.h>
 #include <linux/input.h>
-#include <media/ir-core.h>
 
 #include "smscoreapi.h"
 #include "smsir.h"
 #include "sms-cards.h"
 
-/* In order to add new IR remote control -
- * 1) Add it to the <enum ir_kb_type> @ smsir,h,
- * 2) Add its map to keyboard_layout_maps below
- * 3) Set your board (sms-cards sub-module) to use it
- */
-
-static struct keyboard_layout_map_t keyboard_layout_maps[] = {
-		[SMS_IR_KB_DEFAULT_TV] = {
-			.ir_protocol = IR_RC5,
-			.rc5_kbd_address = KEYBOARD_ADDRESS_TV1,
-			.keyboard_layout_map = {
-					KEY_0, KEY_1, KEY_2,
-					KEY_3, KEY_4, KEY_5,
-					KEY_6, KEY_7, KEY_8,
-					KEY_9, 0, 0, KEY_POWER,
-					KEY_MUTE, 0, 0,
-					KEY_VOLUMEUP, KEY_VOLUMEDOWN,
-					KEY_BRIGHTNESSUP,
-					KEY_BRIGHTNESSDOWN, KEY_CHANNELUP,
-					KEY_CHANNELDOWN,
-					0, 0, 0, 0, 0, 0, 0, 0,
-					0, 0, 0, 0, 0, 0, 0, 0,
-					0, 0, 0, 0, 0, 0, 0, 0,
-					0, 0, 0, 0, 0, 0, 0, 0,
-					0, 0, 0, 0, 0, 0, 0, 0, 0, 0
-			}
-		},
-		[SMS_IR_KB_HCW_SILVER] = {
-			.ir_protocol = IR_RC5,
-			.rc5_kbd_address = KEYBOARD_ADDRESS_LIGHTING1,
-			.keyboard_layout_map = {
-					KEY_0, KEY_1, KEY_2,
-					KEY_3, KEY_4, KEY_5,
-					KEY_6, KEY_7, KEY_8,
-					KEY_9, KEY_TEXT, KEY_RED,
-					KEY_RADIO, KEY_MENU,
-					KEY_SUBTITLE,
-					KEY_MUTE, KEY_VOLUMEUP,
-					KEY_VOLUMEDOWN, KEY_PREVIOUS, 0,
-					KEY_UP, KEY_DOWN, KEY_LEFT,
-					KEY_RIGHT, KEY_VIDEO, KEY_AUDIO,
-					KEY_MHP, KEY_EPG, KEY_TV,
-					0, KEY_NEXTSONG, KEY_EXIT,
-					KEY_CHANNELUP, 	KEY_CHANNELDOWN,
-					KEY_CHANNEL, 0,
-					KEY_PREVIOUSSONG, KEY_ENTER,
-					KEY_SLEEP, 0, 0, KEY_BLUE,
-					0, 0, 0, 0, KEY_GREEN, 0,
-					KEY_PAUSE, 0, KEY_REWIND,
-					0, KEY_FASTFORWARD, KEY_PLAY,
-					KEY_STOP, KEY_RECORD,
-					KEY_YELLOW, 0, 0, KEY_SELECT,
-					KEY_ZOOM, KEY_POWER, 0, 0
-			}
-		},
-		{ } /* Terminating entry */
-};
-
-static u32 ir_pos;
-static u32 ir_word;
-static u32 ir_toggle;
-
-#define RC5_PUSH_BIT(dst, bit, pos)	\
-	{ dst <<= 1; dst |= bit; pos++; }
-
-
-static void sms_ir_rc5_event(struct smscore_device_t *coredev,
-				u32 toggle, u32 addr, u32 cmd)
-{
-	bool toggle_changed;
-	u16 keycode;
-
-	sms_log("IR RC5 word: address %d, command %d, toggle %d",
-				addr, cmd, toggle);
-
-	toggle_changed = ir_toggle != toggle;
-	/* keep toggle */
-	ir_toggle = toggle;
-
-	if (addr !=
-		keyboard_layout_maps[coredev->ir.ir_kb_type].rc5_kbd_address)
-		return; /* Check for valid address */
-
-	keycode =
-		keyboard_layout_maps
-		[coredev->ir.ir_kb_type].keyboard_layout_map[cmd];
-
-	if (!toggle_changed &&
-			(keycode != KEY_VOLUMEUP && keycode != KEY_VOLUMEDOWN))
-		return; /* accept only repeated volume, reject other keys */
-
-	sms_log("kernel input keycode (from ir) %d", keycode);
-	input_report_key(coredev->ir.input_dev, keycode, 1);
-	input_sync(coredev->ir.input_dev);
-
-}
-
-/* decode raw bit pattern to RC5 code */
-/* taken from ir-functions.c */
-static u32 ir_rc5_decode(unsigned int code)
-{
-/*	unsigned int org_code = code;*/
-	unsigned int pair;
-	unsigned int rc5 = 0;
-	int i;
-
-	for (i = 0; i < 14; ++i) {
-		pair = code & 0x3;
-		code >>= 2;
-
-		rc5 <<= 1;
-		switch (pair) {
-		case 0:
-		case 2:
-			break;
-		case 1:
-			rc5 |= 1;
-			break;
-		case 3:
-/*	dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);*/
-			sms_log("bad code");
-			return 0;
-		}
-	}
-/*
-	dprintk(1, "ir-common: code=%x, rc5=%x, start=%x,
-		toggle=%x, address=%x, "
-		"instr=%x\n", rc5, org_code, RC5_START(rc5),
-		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
-*/
-	return rc5;
-}
-
-static void sms_rc5_parse_word(struct smscore_device_t *coredev)
-{
-	#define RC5_START(x)    (((x)>>12)&3)
-	#define RC5_TOGGLE(x)   (((x)>>11)&1)
-	#define RC5_ADDR(x)     (((x)>>6)&0x1F)
-	#define RC5_INSTR(x)    ((x)&0x3F)
-
-	int i, j;
-	u32 rc5_word = 0;
-
-	/* Reverse the IR word direction */
-	for (i = 0 ; i < 28 ; i++)
-		RC5_PUSH_BIT(rc5_word, (ir_word>>i)&1, j)
-
-	rc5_word = ir_rc5_decode(rc5_word);
-	/* sms_log("temp = 0x%x, rc5_code = 0x%x", ir_word, rc5_word); */
-
-	sms_ir_rc5_event(coredev,
-				RC5_TOGGLE(rc5_word),
-				RC5_ADDR(rc5_word),
-				RC5_INSTR(rc5_word));
-}
-
-
-static void sms_rc5_accumulate_bits(struct smscore_device_t *coredev,
-		s32 ir_sample)
-{
-	#define RC5_TIME_GRANULARITY	200
-	#define RC5_DEF_BIT_TIME		889
-	#define RC5_MAX_SAME_BIT_CONT	4
-	#define RC5_WORD_LEN			27 /* 28 bit */
-
-	u32 i, j;
-	s32 delta_time;
-	u32 time = (ir_sample > 0) ? ir_sample : (0-ir_sample);
-	u32 level = (ir_sample < 0) ? 0 : 1;
-
-	for (i = RC5_MAX_SAME_BIT_CONT; i > 0; i--) {
-		delta_time = time - (i*RC5_DEF_BIT_TIME) + RC5_TIME_GRANULARITY;
-		if (delta_time < 0)
-			continue; /* not so many consecutive bits */
-		if (delta_time > (2 * RC5_TIME_GRANULARITY)) {
-			/* timeout */
-			if (ir_pos == (RC5_WORD_LEN-1))
-				/* complete last bit */
-				RC5_PUSH_BIT(ir_word, level, ir_pos)
-
-			if (ir_pos == RC5_WORD_LEN)
-				sms_rc5_parse_word(coredev);
-			else if (ir_pos) /* timeout within a word */
-				sms_log("IR error parsing a word");
-
-			ir_pos = 0;
-			ir_word = 0;
-			/* sms_log("timeout %d", time); */
-			break;
-		}
-		/* The time is within the range of this number of bits */
-		for (j = 0 ; j < i ; j++)
-			RC5_PUSH_BIT(ir_word, level, ir_pos)
-
-		break;
-	}
-}
+#define MODULE_NAME "smsmdtv"
 
 void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 {
-	#define IR_DATA_RECEIVE_MAX_LEN	520 /* 128*4 + 4 + 4 */
-	u32 i;
-	enum ir_protocol ir_protocol =
-			keyboard_layout_maps[coredev->ir.ir_kb_type]
-					     .ir_protocol;
-	s32 *samples;
-	int count = len>>2;
+	int i;
+	const s32 *samples = (const void *)buf;
 
-	samples = (s32 *)buf;
-/*	sms_log("IR buffer received, length = %d", count);*/
+	for (i = 0; i < len >> 2; i++) {
+		struct ir_raw_event ev;
 
-	for (i = 0; i < count; i++)
-		if (ir_protocol == IR_RC5)
-			sms_rc5_accumulate_bits(coredev, samples[i]);
-	/*  IR_RCMM not implemented */
+		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
+		ev.pulse = (samples[i] > 0) ? false : true;
+
+		ir_raw_event_store(coredev->ir.input_dev, &ev);
+	}
+	ir_raw_event_handle(coredev->ir.input_dev);
 }
 
 int sms_ir_init(struct smscore_device_t *coredev)
@@ -258,21 +63,14 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	}
 
 	coredev->ir.input_dev = input_dev;
-	coredev->ir.ir_kb_type = sms_get_board(board_id)->ir_kb_type;
-	coredev->ir.keyboard_layout_map =
-		keyboard_layout_maps[coredev->ir.ir_kb_type].
-				keyboard_layout_map;
-	sms_log("IR remote keyboard type is %d", coredev->ir.ir_kb_type);
 
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
 	sms_log("IR port %d, timeout %d ms",
 			coredev->ir.controller, coredev->ir.timeout);
 
-	snprintf(coredev->ir.name,
-				sizeof(coredev->ir.name),
-				"SMS IR (%s)",
-				sms_get_board(board_id)->name);
+	snprintf(coredev->ir.name, sizeof(coredev->ir.name),
+		 "SMS IR (%s)", sms_get_board(board_id)->name);
 
 	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
 	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
@@ -281,13 +79,22 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	input_dev->phys = coredev->ir.phys;
 	input_dev->dev.parent = coredev->device;
 
-	/* Key press events only */
-	input_dev->evbit[0] = BIT_MASK(EV_KEY);
-	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+#if 0
+	/* TODO: properly initialize the parameters bellow */
+	input_dev->id.bustype = BUS_USB;
+	input_dev->id.version = 1;
+	input_dev->id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
+	input_dev->id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
+#endif
+
+	coredev->ir.props.priv = coredev;
+	coredev->ir.props.driver_type = RC_DRIVER_IR_RAW;
+	coredev->ir.props.allowed_protos = IR_TYPE_ALL;
 
 	sms_log("Input device (IR) %s is set for key events", input_dev->name);
 
-	if (input_register_device(input_dev)) {
+	if (ir_input_register(input_dev, sms_get_board(board_id)->rc_codes,
+			      &coredev->ir.props, MODULE_NAME)) {
 		sms_err("Failed to register device");
 		input_free_device(input_dev);
 		return -EACCES;
@@ -299,8 +106,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 void sms_ir_exit(struct smscore_device_t *coredev)
 {
 	if (coredev->ir.input_dev)
-		input_unregister_device(coredev->ir.input_dev);
+		ir_input_unregister(coredev->ir.input_dev);
 
 	sms_log("");
-}
-
+}
\ No newline at end of file
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/dvb/siano/smsir.h
index 77e6505..926e247 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -4,6 +4,11 @@ Siano Mobile Silicon, Inc.
 MDTV receiver kernel modules.
 Copyright (C) 2006-2009, Uri Shkolnik
 
+ Copyright (c) 2010 - Mauro Carvalho Chehab
+	- Ported the driver to use rc-core
+	- IR raw event decoding is now done at rc-core
+	- Code almost re-written
+
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 2 of the License, or
@@ -23,64 +28,21 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define __SMS_IR_H__
 
 #include <linux/input.h>
+#include <media/ir-core.h>
 
-#define IR_DEV_NAME_MAX_LEN		40
-#define IR_KEYBOARD_LAYOUT_SIZE	64
 #define IR_DEFAULT_TIMEOUT		100
 
-enum ir_kb_type {
-	SMS_IR_KB_DEFAULT_TV,
-	SMS_IR_KB_HCW_SILVER
-};
-
-enum rc5_keyboard_address {
-	KEYBOARD_ADDRESS_TV1 = 0,
-	KEYBOARD_ADDRESS_TV2 = 1,
-	KEYBOARD_ADDRESS_TELETEXT = 2,
-	KEYBOARD_ADDRESS_VIDEO = 3,
-	KEYBOARD_ADDRESS_LV1 = 4,
-	KEYBOARD_ADDRESS_VCR1 = 5,
-	KEYBOARD_ADDRESS_VCR2 = 6,
-	KEYBOARD_ADDRESS_EXPERIMENTAL = 7,
-	KEYBOARD_ADDRESS_SAT1 = 8,
-	KEYBOARD_ADDRESS_CAMERA = 9,
-	KEYBOARD_ADDRESS_SAT2 = 10,
-	KEYBOARD_ADDRESS_CDV = 12,
-	KEYBOARD_ADDRESS_CAMCORDER = 13,
-	KEYBOARD_ADDRESS_PRE_AMP = 16,
-	KEYBOARD_ADDRESS_TUNER = 17,
-	KEYBOARD_ADDRESS_RECORDER1 = 18,
-	KEYBOARD_ADDRESS_PRE_AMP1 = 19,
-	KEYBOARD_ADDRESS_CD_PLAYER = 20,
-	KEYBOARD_ADDRESS_PHONO = 21,
-	KEYBOARD_ADDRESS_SATA = 22,
-	KEYBOARD_ADDRESS_RECORDER2 = 23,
-	KEYBOARD_ADDRESS_CDR = 26,
-	KEYBOARD_ADDRESS_LIGHTING = 29,
-	KEYBOARD_ADDRESS_LIGHTING1 = 30, /* KEYBOARD_ADDRESS_HCW_SILVER */
-	KEYBOARD_ADDRESS_PHONE = 31,
-	KEYBOARD_ADDRESS_NOT_RC5 = 0xFFFF
-};
-
-enum ir_protocol {
-	IR_RC5,
-	IR_RCMM
-};
-
-struct keyboard_layout_map_t {
-	enum ir_protocol ir_protocol;
-	enum rc5_keyboard_address rc5_kbd_address;
-	u16 keyboard_layout_map[IR_KEYBOARD_LAYOUT_SIZE];
-};
-
 struct smscore_device_t;
 
 struct ir_t {
 	struct input_dev *input_dev;
-	enum ir_kb_type ir_kb_type;
-	char name[IR_DEV_NAME_MAX_LEN + 1];
+	char name[40];
 	char phys[32];
-	u16 *keyboard_layout_map;
+
+	char *rc_codes;
+	u64 protocol;
+	struct ir_dev_props props;
+
 	u32 timeout;
 	u32 controller;
 };
-- 
1.7.1

