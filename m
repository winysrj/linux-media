Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110813.mail.gq1.yahoo.com ([67.195.13.236]:25589 "HELO
	web110813.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755489AbZDEJBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 05:01:40 -0400
Message-ID: <893553.37435.qm@web110813.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 02:01:37 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_9] Siano: add support for infra-red (IR) controllers
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238697194 -10800
# Node ID 020ba7b31c963bd36d607848198e9e4258a6f80e
# Parent  e8d224d81e2adde182162ab156aa98725e43f5c0
[PATCH] [0904_9] Siano: add support for infra-red (IR) controllers

From: Uri Shkolnik <uris@siano-ms.com>

This patch add support for IR (infra-red)
remote controllers.
Further commits are needed in order to enable the
activation of the IR components.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r e8d224d81e2a -r 020ba7b31c96 linux/drivers/media/dvb/siano/smsir.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsir.c	Thu Apr 02 21:33:14 2009 +0300
@@ -0,0 +1,301 @@
+/****************************************************************
+
+ Siano Mobile Silicon, Inc.
+ MDTV receiver kernel modules.
+ Copyright (C) 2006-2009, Uri Shkolnik
+
+ This program is free software: you can redistribute it and/or modify
+ it under the terms of the GNU General Public License as published by
+ the Free Software Foundation, either version 2 of the License, or
+ (at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+ but WITHOUT ANY WARRANTY; without even the implied warranty of
+ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ GNU General Public License for more details.
+
+ You should have received a copy of the GNU General Public License
+ along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+ ****************************************************************/
+
+
+#include <linux/types.h>
+#include <linux/input.h>
+
+#include "smscoreapi.h"
+#include "smsir.h"
+#include "sms-cards.h"
+
+/* In order to add new IR remote control -
+ * 1) Add it to the <enum ir_kb_type> @ smsir,h,
+ * 2) Add its map to keyboard_layout_maps below
+ * 3) Set your board (sms-cards sub-module) to use it
+ */
+
+static struct keyboard_layout_map_t keyboard_layout_maps[] = {
+		[SMS_IR_KB_DEFAULT_TV] = {
+			.ir_protocol = IR_RC5,
+			.rc5_kbd_address = KEYBOARD_ADDRESS_TV1,
+			.keyboard_layout_map = {
+					KEY_0, KEY_1, KEY_2,
+					KEY_3, KEY_4, KEY_5,
+					KEY_6, KEY_7, KEY_8,
+					KEY_9, 0, 0, KEY_POWER,
+					KEY_MUTE, 0, 0,
+					KEY_VOLUMEUP, KEY_VOLUMEDOWN,
+					KEY_BRIGHTNESSUP,
+					KEY_BRIGHTNESSDOWN, KEY_CHANNELUP,
+					KEY_CHANNELDOWN,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0,
+					0, 0, 0, 0, 0, 0, 0, 0, 0, 0
+			}
+		},
+		[SMS_IR_KB_HCW_SILVER] = {
+			.ir_protocol = IR_RC5,
+			.rc5_kbd_address = KEYBOARD_ADDRESS_LIGHTING1,
+			.keyboard_layout_map = {
+					KEY_0, KEY_1, KEY_2,
+					KEY_3, KEY_4, KEY_5,
+					KEY_6, KEY_7, KEY_8,
+					KEY_9, KEY_TEXT, KEY_RED,
+					KEY_RADIO, KEY_MENU,
+					KEY_SUBTITLE,
+					KEY_MUTE, KEY_VOLUMEUP,
+					KEY_VOLUMEDOWN, KEY_PREVIOUS, 0,
+					KEY_UP, KEY_DOWN, KEY_LEFT,
+					KEY_RIGHT, KEY_VIDEO, KEY_AUDIO,
+					KEY_MHP, KEY_EPG, KEY_TV,
+					0, KEY_NEXTSONG, KEY_EXIT,
+					KEY_CHANNELUP, 	KEY_CHANNELDOWN,
+					KEY_CHANNEL, 0,
+					KEY_PREVIOUSSONG, KEY_ENTER,
+					KEY_SLEEP, 0, 0, KEY_BLUE,
+					0, 0, 0, 0, KEY_GREEN, 0,
+					KEY_PAUSE, 0, KEY_REWIND,
+					0, KEY_FASTFORWARD, KEY_PLAY,
+					KEY_STOP, KEY_RECORD,
+					KEY_YELLOW, 0, 0, KEY_SELECT,
+					KEY_ZOOM, KEY_POWER, 0, 0
+			}
+		},
+		{ } /* Terminating entry */
+};
+
+u32 ir_pos;
+u32	ir_word;
+u32 ir_toggle;
+
+#define RC5_PUSH_BIT(dst, bit, pos)	\
+	{ dst <<= 1; dst |= bit; pos++; }
+
+
+static void sms_ir_rc5_event(struct smscore_device_t *coredev,
+				u32 toggle, u32 addr, u32 cmd)
+{
+	bool toggle_changed;
+	u16 keycode;
+
+	sms_info("IR RC5 word: address %d, command %d, toggle %d",
+				addr, cmd, toggle);
+
+	toggle_changed = ir_toggle != toggle;
+	/* keep toggle */
+	ir_toggle = toggle;
+
+	if (addr !=
+		keyboard_layout_maps[coredev->ir.ir_kb_type].rc5_kbd_address)
+		return; /* Check for valid address */
+
+	keycode =
+		keyboard_layout_maps
+		[coredev->ir.ir_kb_type].keyboard_layout_map[cmd];
+
+	if (!toggle_changed &&
+			(keycode != KEY_VOLUMEUP && keycode != KEY_VOLUMEDOWN))
+		return; /* accept only repeated volume, reject other keys */
+
+	sms_info("kernel input keycode (from ir) %d", keycode);
+	input_report_key(coredev->ir.input_dev, keycode, 1);
+	input_sync(coredev->ir.input_dev);
+
+}
+
+/* decode raw bit pattern to RC5 code */
+/* taken from ir-functions.c */
+static u32 ir_rc5_decode(unsigned int code)
+{
+/*	unsigned int org_code = code;*/
+	unsigned int pair;
+	unsigned int rc5 = 0;
+	int i;
+
+	for (i = 0; i < 14; ++i) {
+		pair = code & 0x3;
+		code >>= 2;
+
+		rc5 <<= 1;
+		switch (pair) {
+		case 0:
+		case 2:
+			break;
+		case 1:
+			rc5 |= 1;
+			break;
+		case 3:
+/*	dprintk(1, "ir-common: ir_rc5_decode(%x) bad code\n", org_code);*/
+			sms_info("bad code");
+			return 0;
+		}
+	}
+/*
+	dprintk(1, "ir-common: code=%x, rc5=%x, start=%x,
+		toggle=%x, address=%x, "
+		"instr=%x\n", rc5, org_code, RC5_START(rc5),
+		RC5_TOGGLE(rc5), RC5_ADDR(rc5), RC5_INSTR(rc5));
+*/
+	return rc5;
+}
+
+static void sms_rc5_parse_word(struct smscore_device_t *coredev)
+{
+	#define RC5_START(x)    (((x)>>12)&3)
+	#define RC5_TOGGLE(x)   (((x)>>11)&1)
+	#define RC5_ADDR(x)     (((x)>>6)&0x1F)
+	#define RC5_INSTR(x)    ((x)&0x3F)
+
+	int i, j;
+	u32 rc5_word = 0;
+
+	/* Reverse the IR word direction */
+	for (i = 0 ; i < 28 ; i++)
+		RC5_PUSH_BIT(rc5_word, (ir_word>>i)&1, j)
+
+	rc5_word = ir_rc5_decode(rc5_word);
+	/* sms_info("temp = 0x%x, rc5_code = 0x%x", ir_word, rc5_word); */
+
+	sms_ir_rc5_event(coredev,
+				RC5_TOGGLE(rc5_word),
+				RC5_ADDR(rc5_word),
+				RC5_INSTR(rc5_word));
+}
+
+
+static void sms_rc5_accumulate_bits(struct smscore_device_t *coredev,
+		s32 ir_sample)
+{
+	#define RC5_TIME_GRANULARITY	200
+	#define RC5_DEF_BIT_TIME		889
+	#define RC5_MAX_SAME_BIT_CONT	4
+	#define RC5_WORD_LEN			27 /* 28 bit */
+
+	u32 i, j;
+	s32 delta_time;
+	u32 time = (ir_sample > 0) ? ir_sample : (0-ir_sample);
+	u32 level = (ir_sample < 0) ? 0 : 1;
+
+	for (i = RC5_MAX_SAME_BIT_CONT; i > 0; i--) {
+		delta_time = time - (i*RC5_DEF_BIT_TIME) + RC5_TIME_GRANULARITY;
+		if (delta_time < 0)
+			continue; /* not so many consecutive bits */
+		if (delta_time > (2 * RC5_TIME_GRANULARITY)) {
+			/* timeout */
+			if (ir_pos == (RC5_WORD_LEN-1))
+				/* complete last bit */
+				RC5_PUSH_BIT(ir_word, level, ir_pos)
+
+			if (ir_pos == RC5_WORD_LEN)
+				sms_rc5_parse_word(coredev);
+			else if (ir_pos) /* timeout within a word */
+				sms_info("IR error parsing a word");
+
+			ir_pos = 0;
+			ir_word = 0;
+			/* sms_info("timeout %d", time); */
+			break;
+		}
+		/* The time is within the range of this number of bits */
+		for (j = 0 ; j < i ; j++)
+			RC5_PUSH_BIT(ir_word, level, ir_pos)
+
+		break;
+	}
+}
+
+void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
+{
+	#define IR_DATA_RECEIVE_MAX_LEN	520 /* 128*4 + 4 + 4 */
+	u32 i;
+	enum ir_protocol ir_protocol =
+			keyboard_layout_maps[coredev->ir.ir_kb_type]
+					     .ir_protocol;
+	s32 *samples;
+	int count = len>>2;
+
+	samples = (s32 *)buf;
+/*	sms_info("IR buffer received, length = %d", count);*/
+
+	for (i = 0; i < count; i++)
+		if (ir_protocol == IR_RC5)
+			sms_rc5_accumulate_bits(coredev, samples[i]);
+	/*  IR_RCMM not implemented */
+}
+
+int sms_ir_init(struct smscore_device_t *coredev)
+{
+	struct input_dev *input_dev;
+
+	sms_info("Allocating input device");
+	input_dev = input_allocate_device();
+	if (!input_dev)	{
+		sms_err("Not enough memory");
+		return -ENOMEM;
+	}
+
+	coredev->ir.input_dev = input_dev;
+	coredev->ir.ir_kb_type =
+		sms_get_board(smscore_get_board_id(coredev))->ir_kb_type;
+	coredev->ir.keyboard_layout_map =
+		keyboard_layout_maps[coredev->ir.ir_kb_type].
+				keyboard_layout_map;
+	sms_info("IR remote keyboard type is %d", coredev->ir.ir_kb_type);
+
+	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
+	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
+	sms_info("IR port %d, timeout %d ms",
+			coredev->ir.controller, coredev->ir.timeout);
+
+	snprintf(coredev->ir.name,
+				IR_DEV_NAME_MAX_LEN,
+				"SMS IR w/kbd type %d",
+				coredev->ir.ir_kb_type);
+	input_dev->name = coredev->ir.name;
+	input_dev->phys = coredev->ir.name;
+	input_dev->dev.parent = coredev->device;
+
+	/* Key press events only */
+	input_dev->evbit[0] = BIT_MASK(EV_KEY);
+	input_dev->keybit[BIT_WORD(BTN_0)] = BIT_MASK(BTN_0);
+
+	sms_info("Input device (IR) %s is set for key events", input_dev->name);
+
+	if (input_register_device(input_dev)) {
+		sms_err("Failed to register device");
+		input_free_device(input_dev);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+void sms_ir_exit(struct smscore_device_t *coredev)
+{
+	if (coredev->ir.input_dev)
+		input_unregister_device(coredev->ir.input_dev);
+
+	sms_info("");
+}
+
diff -r e8d224d81e2a -r 020ba7b31c96 linux/drivers/media/dvb/siano/smsir.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/linux/drivers/media/dvb/siano/smsir.h	Thu Apr 02 21:33:14 2009 +0300
@@ -0,0 +1,93 @@
+/****************************************************************
+
+Siano Mobile Silicon, Inc.
+MDTV receiver kernel modules.
+Copyright (C) 2006-2009, Uri Shkolnik
+
+This program is free software: you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation, either version 2 of the License, or
+(at your option) any later version.
+
+ This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+****************************************************************/
+
+#ifndef __SMS_IR_H__
+#define __SMS_IR_H__
+
+#include <linux/input.h>
+
+#define IR_DEV_NAME_MAX_LEN		23 /* "SMS IR kbd type nn\0" */
+#define IR_KEYBOARD_LAYOUT_SIZE	64
+#define IR_DEFAULT_TIMEOUT		100
+
+enum ir_kb_type {
+	SMS_IR_KB_DEFAULT_TV,
+	SMS_IR_KB_HCW_SILVER
+};
+
+enum rc5_keyboard_address {
+	KEYBOARD_ADDRESS_TV1 = 0,
+	KEYBOARD_ADDRESS_TV2 = 1,
+	KEYBOARD_ADDRESS_TELETEXT = 2,
+	KEYBOARD_ADDRESS_VIDEO = 3,
+	KEYBOARD_ADDRESS_LV1 = 4,
+	KEYBOARD_ADDRESS_VCR1 = 5,
+	KEYBOARD_ADDRESS_VCR2 = 6,
+	KEYBOARD_ADDRESS_EXPERIMENTAL = 7,
+	KEYBOARD_ADDRESS_SAT1 = 8,
+	KEYBOARD_ADDRESS_CAMERA = 9,
+	KEYBOARD_ADDRESS_SAT2 = 10,
+	KEYBOARD_ADDRESS_CDV = 12,
+	KEYBOARD_ADDRESS_CAMCORDER = 13,
+	KEYBOARD_ADDRESS_PRE_AMP = 16,
+	KEYBOARD_ADDRESS_TUNER = 17,
+	KEYBOARD_ADDRESS_RECORDER1 = 18,
+	KEYBOARD_ADDRESS_PRE_AMP1 = 19,
+	KEYBOARD_ADDRESS_CD_PLAYER = 20,
+	KEYBOARD_ADDRESS_PHONO = 21,
+	KEYBOARD_ADDRESS_SATA = 22,
+	KEYBOARD_ADDRESS_RECORDER2 = 23,
+	KEYBOARD_ADDRESS_CDR = 26,
+	KEYBOARD_ADDRESS_LIGHTING = 29,
+	KEYBOARD_ADDRESS_LIGHTING1 = 30, /* KEYBOARD_ADDRESS_HCW_SILVER */
+	KEYBOARD_ADDRESS_PHONE = 31,
+	KEYBOARD_ADDRESS_NOT_RC5 = 0xFFFF
+};
+
+enum ir_protocol {
+	IR_RC5,
+	IR_RCMM
+};
+
+struct keyboard_layout_map_t {
+	enum ir_protocol ir_protocol;
+	enum rc5_keyboard_address rc5_kbd_address;
+	u16 keyboard_layout_map[IR_KEYBOARD_LAYOUT_SIZE];
+};
+
+struct smscore_device_t;
+
+struct ir_t {
+	struct input_dev *input_dev;
+	enum ir_kb_type ir_kb_type;
+	char name[IR_DEV_NAME_MAX_LEN+1];
+	u16 *keyboard_layout_map;
+	u32 timeout;
+	u32 controller;
+};
+
+int sms_ir_init(struct smscore_device_t *coredev);
+void sms_ir_exit(struct smscore_device_t *coredev);
+void sms_ir_event(struct smscore_device_t *coredev,
+			const char *buf, int len);
+
+#endif /* __SMS_IR_H__ */
+



      
