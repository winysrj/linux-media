Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab1FCV2j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 17:28:39 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p53LSdeQ003397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 3 Jun 2011 17:28:39 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] rc-core support for Microsoft IR keyboard/mouse
Date: Fri,  3 Jun 2011 17:28:28 -0400
Message-Id: <1307136508-19455-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a custom IR protocol decoder, for the RC-6-ish protocol used by
the Microsoft Remote Keyboard.

http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8

Its a standard keyboard with embedded thumb stick mouse pointer and
mouse buttons, along with a number of media keys. The media keys are
standard RC-6, identical to the signals from the stock MCE remotes, and
will be handled as such. The keyboard and mouse signals will be decoded
and delivered to the system by an input device registered specifically
by this driver.

Successfully tested with an mceusb-driven receiver, but this should
actually work with any raw IR rc-core receiver.

This work is inspired by lirc_mod_mce:

http://mod-mce.sourceforge.net/

The documentation there and code aided in understanding and decoding the
protocol, but the bulk of the code is actually borrowed more from the
existing in-kernel decoders than anything. I did recycle the keyboard
keycode table and a few defines from lirc_mod_mce though.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/Kconfig              |   11 +
 drivers/media/rc/Makefile             |    1 +
 drivers/media/rc/ir-mce_kbd-decoder.c |  383 +++++++++++++++++++++++++++++++++
 drivers/media/rc/ir-raw.c             |    1 +
 drivers/media/rc/rc-core-priv.h       |   17 ++
 drivers/media/rc/rc-main.c            |    1 +
 include/media/rc-map.h                |    3 +-
 7 files changed, 416 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/rc/ir-mce_kbd-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 7d4bbc2..899f783 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -87,6 +87,17 @@ config IR_RC5_SZ_DECODER
 	   uses an IR protocol that is almost standard RC-5, but not quite,
 	   as it uses an additional bit).
 
+config IR_MCE_KBD_DECODER
+	tristate "Enable IR raw decoder for the MCE keyboard/mouse protocol"
+	depends on RC_CORE
+	select BITREVERSE
+	default y
+
+	---help---
+	   Enable this option if you have a Microsoft Remote Keyboard for
+	   Windows Media Center Edition, which you would like to use with
+	   a raw IR receiver in your system.
+
 config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 52830e5..f224db0 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
 obj-$(CONFIG_IR_RC5_SZ_DECODER) += ir-rc5-sz-decoder.o
+obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
 # stand-alone IR receivers/transmitters
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
new file mode 100644
index 0000000..98d3bf5
--- /dev/null
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -0,0 +1,383 @@
+/* ir-mce_kbd-decoder.c - A decoder for the RC6-ish keyboard/mouse IR protocol
+ * used by the Microsoft Remote Keyboard for Windows Media Center Edition
+ *
+ * Copyright (C) 2011 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "rc-core-priv.h"
+
+/*
+ * This decoder currently supports:
+ * - RC6-like 29-bit IR signals used for mouse movement and buttons
+ * - RC6-like 32-bit IR signals used for standard keyboard keys
+ *
+ * The media keys on the keyboard send RC-6 signals that are inditinguishable
+ * from the keys of the same name on the stock MCE remote, and will be handled
+ * by the standard RC-6 decoder, and be made available to the system via the
+ * input device for the remote, rather than the keyboard/mouse one.
+ */
+
+#define MCE_KBD_UNIT		333333	/* ns */
+#define MCE_KBD_HEADER_NBITS	5
+#define MCE_KBD_MOUSE_NBITS	29
+#define MCE_KBD_KEYBOARD_NBITS	32
+#define MCE_KBD_PREFIX_PULSE	(8 * MCE_KBD_UNIT)
+#define MCE_KBD_PREFIX_SPACE	(1 * MCE_KBD_UNIT)
+#define MCE_KBD_MAX_LEN		(3 * MCE_KBD_UNIT)
+#define MCE_KBD_BIT_START	(1 * MCE_KBD_UNIT)
+#define MCE_KBD_BIT_END		(1 * MCE_KBD_UNIT)
+#define MCE_KBD_BIT_0		(1 * MCE_KBD_UNIT)
+#define MCE_KBD_BIT_SET		(2 * MCE_KBD_UNIT)
+#define MCE_KBD_MODE_MASK	0xf	/* for the header bits */
+#define MCE_KBD_HEADER		0x4
+#define MCE_MOUSE_HEADER	0x1
+#define MCE_KBD_MASK_KEYS_START	0xe0
+
+enum mce_kbd_mode {
+	MCE_KBD_MODE_KEYBOARD,
+	MCE_KBD_MODE_MOUSE,
+	MCE_KBD_MODE_UNKNOWN,
+};
+
+enum mce_kbd_state {
+	STATE_INACTIVE,
+	STATE_HEADER_BIT_START,
+	STATE_HEADER_BIT_END,
+	STATE_BODY_BIT_START,
+	STATE_BODY_BIT_END,
+	STATE_FINISHED,
+};
+
+static unsigned char kbd_keycodes[256] = {
+          0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,  36,  37,  38,
+         50,  49,  24,  25,  16,  19,  31,  20,  22,  47,  17,  45,  21,  44,   2,   3,
+          4,   5,   6,   7,   8,   9,  10,  11,  28,   1,  14,  15,  57,  12,  13,  26,
+         27,  43,  43,  39,  40,  41,  51,  52,  53,  58,  59,  60,  61,  62,  63,  64,
+         65,  66,  67,  68,  87,  88,  99,  70, 119, 110, 102, 104, 111, 107, 109, 106,
+        105, 108, 103,  69,  98,  55,  74,  78,  96,  79,  80,  81,  75,  76,  77,  71,
+         72,  73,  82,  83,  86, 127, 116, 117, 183, 184, 185, 186, 187, 188, 189, 190,
+        191, 192, 193, 194, 134, 138, 130, 132, 128, 129, 131, 137, 133, 135, 136, 113,
+        115, 114,   0,   0,   0, 121,   0,  89,  93, 124,  92,  94,  95,   0,   0,   0,
+        122, 123,  90,  91,  85,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+          0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+         29,  42,  56, 125,  97,  54, 100, 126, 164, 166, 165, 163, 161, 115, 114, 113,
+        150, 158, 159, 128, 136, 177, 178, 176, 142, 152, 173, 140
+};
+
+static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
+{
+	switch (data->header & MCE_KBD_MODE_MASK) {
+	case MCE_KBD_HEADER:
+		return MCE_KBD_MODE_KEYBOARD;
+	case MCE_MOUSE_HEADER:
+		return MCE_KBD_MODE_MOUSE;
+	default:
+		return MCE_KBD_MODE_UNKNOWN;
+	}
+}
+
+static void ir_mce_kbd_process_keyboard_data(struct input_dev *idev,
+					     u32 scancode)
+{
+	u8 keydata   = (scancode >> 8) & 0xff;
+	u8 shiftmask = scancode & 0xff;
+	unsigned char keycode, maskcode;
+	int i, keystate;
+
+	IR_dprintk(1, "keyboard: keydata = 0x%02x, shiftmask = 0x%02x\n",
+		   keydata, shiftmask);
+
+	for (i = 0; i < 7; i++) {
+		maskcode = kbd_keycodes[MCE_KBD_MASK_KEYS_START + i];
+		if (shiftmask & (1 << i))
+			keystate = 1;
+		else
+			keystate = 0;
+		input_report_key(idev, maskcode, keystate);
+	}
+
+	if (keydata) {
+		keycode = kbd_keycodes[keydata];
+		input_report_key(idev, keycode, 1);
+	} else {
+		for (i = 0; i < MCE_KBD_MASK_KEYS_START; i++)
+			input_report_key(idev, kbd_keycodes[i], 0);
+	}
+}
+
+static void ir_mce_kbd_process_mouse_data(struct input_dev *idev, u32 scancode)
+{
+	/* raw mouse coordinates */
+	u8 xdata = (scancode >> 7) & 0x7f;
+	u8 ydata = (scancode >> 14) & 0x7f;
+	int x, y;
+	/* mouse buttons */
+	bool right = scancode & 0x40;
+	bool left  = scancode & 0x20;
+
+	if (xdata & 0x40)
+		x = -((~xdata & 0x7f) + 1);
+	else
+		x = xdata;
+
+	if (ydata & 0x40)
+		y = -((~ydata & 0x7f) + 1);
+	else
+		y = ydata;
+
+	IR_dprintk(1, "mouse: x = %d, y = %d, btns = %s%s\n",
+		   x, y, left ? "L" : "", right ? "R" : "");
+
+	input_report_rel(idev, REL_X, x);
+	input_report_rel(idev, REL_Y, y);
+
+	input_report_key(idev, BTN_LEFT, left);
+	input_report_key(idev, BTN_RIGHT, right);
+}
+
+/**
+ * ir_mce_kbd_decode() - Decode one mce_kbd pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
+	u32 scancode;
+
+	if (!(dev->raw->enabled_protocols & RC_TYPE_MCE_KBD))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	if (!geq_margin(ev.duration, MCE_KBD_UNIT, MCE_KBD_UNIT / 2))
+		goto out;
+
+again:
+	IR_dprintk(2, "started at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	if (!geq_margin(ev.duration, MCE_KBD_UNIT, MCE_KBD_UNIT / 2))
+		return 0;
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		/* Note: larger margin on first pulse since each MCE_KBD_UNIT
+		   is quite short and some hardware takes some time to
+		   adjust to the signal */
+		if (!eq_margin(ev.duration, MCE_KBD_PREFIX_PULSE, MCE_KBD_UNIT))
+			break;
+
+		data->state = STATE_HEADER_BIT_START;
+		data->count = 0;
+		data->header = 0;
+		return 0;
+
+	case STATE_HEADER_BIT_START:
+		if (geq_margin(ev.duration, MCE_KBD_MAX_LEN, MCE_KBD_UNIT / 2))
+			break;
+
+		data->header <<= 1;
+		if (ev.pulse)
+			data->header |= 1;
+		data->count++;
+		data->state = STATE_HEADER_BIT_END;
+		return 0;
+
+	case STATE_HEADER_BIT_END:
+		if (!is_transition(&ev, &dev->raw->prev_ev))
+			break;
+
+		decrease_duration(&ev, MCE_KBD_BIT_END);
+
+		if (data->count != MCE_KBD_HEADER_NBITS) {
+			data->state = STATE_HEADER_BIT_START;
+			goto again;
+		}
+
+		switch (mce_kbd_mode(data)) {
+		case MCE_KBD_MODE_KEYBOARD:
+			data->wanted_bits = MCE_KBD_KEYBOARD_NBITS;
+			break;
+		case MCE_KBD_MODE_MOUSE:
+			data->wanted_bits = MCE_KBD_MOUSE_NBITS;
+			break;
+		default:
+			IR_dprintk(1, "not keyboard or mouse data\n");
+			goto out;
+		}
+
+		data->count = 0;
+		data->body = 0;
+		data->state = STATE_BODY_BIT_START;
+		goto again;
+
+	case STATE_BODY_BIT_START:
+		if (geq_margin(ev.duration, MCE_KBD_MAX_LEN, MCE_KBD_UNIT / 2))
+			break;
+
+		data->body <<= 1;
+		if (ev.pulse)
+			data->body |= 1;
+		data->count++;
+		data->state = STATE_BODY_BIT_END;
+		return 0;
+
+	case STATE_BODY_BIT_END:
+		if (!is_transition(&ev, &dev->raw->prev_ev))
+			break;
+
+		if (data->count == data->wanted_bits)
+			data->state = STATE_FINISHED;
+		else
+			data->state = STATE_BODY_BIT_START;
+
+		decrease_duration(&ev, MCE_KBD_BIT_END);
+		goto again;
+
+	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
+		switch (data->wanted_bits) {
+		case MCE_KBD_KEYBOARD_NBITS:
+			scancode = data->body & 0xffff;
+			IR_dprintk(1, "keyboard data 0x%08x\n", data->body);
+			/* Pass data to keyboard buffer parser */
+			ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+			break;
+		case MCE_KBD_MOUSE_NBITS:
+			scancode = data->body & 0x1fffff;
+			IR_dprintk(1, "mouse data 0x%06x\n", scancode);
+			/* Pass data to mouse buffer parser */
+			ir_mce_kbd_process_mouse_data(data->idev, scancode);
+			break;
+		default:
+			IR_dprintk(1, "not keyboard or mouse data\n");
+			goto out;
+		}
+
+		data->state = STATE_INACTIVE;
+		input_sync(data->idev);
+		return 0;
+	}
+
+out:
+	IR_dprintk(1, "failed at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	input_sync(data->idev);
+	return -EINVAL;
+}
+
+static int ir_mce_kbd_register(struct rc_dev *dev)
+{
+	struct mce_kbd_dec *mce_kbd = &dev->raw->mce_kbd;
+	struct input_dev *idev;
+	int i, ret;
+
+	idev = input_allocate_device();
+	if (!idev)
+		return -ENOMEM;
+
+	snprintf(mce_kbd->name, sizeof(mce_kbd->name),
+		 "MCE IR Keyboard/Mouse (%s)", dev->driver_name);
+	strlcat(mce_kbd->phys, "/input0", sizeof(mce_kbd->phys));
+
+	idev->name = mce_kbd->name;
+	idev->phys = mce_kbd->phys;
+
+	/* Keyboard bits */
+	set_bit(EV_KEY, idev->evbit);
+	set_bit(EV_REP, idev->evbit);
+	for (i = 0; i < sizeof(kbd_keycodes); i++)
+		set_bit(kbd_keycodes[i], idev->keybit);
+
+	/* Mouse bits */
+	set_bit(EV_REL, idev->evbit);
+	set_bit(REL_X, idev->relbit);
+	set_bit(REL_Y, idev->relbit);
+	set_bit(BTN_LEFT, idev->keybit);
+	set_bit(BTN_RIGHT, idev->keybit);
+
+	/* Report scancodes too */
+	set_bit(EV_MSC, idev->evbit);
+	set_bit(MSC_SCAN, idev->mscbit);
+
+	input_set_drvdata(idev, mce_kbd);
+
+#if 0
+	/* Adding this reference means two input devices are associated with
+	 * this rc-core device, which ir-keytable doesn't cope with yet */
+	idev->dev.parent = &dev->dev;
+#endif
+
+	ret = input_register_device(idev);
+	if (ret < 0) {
+		input_free_device(idev);
+		return -EIO;
+	}
+
+	mce_kbd->idev = idev;
+
+	return 0;
+}
+
+static int ir_mce_kbd_unregister(struct rc_dev *dev)
+{
+	struct mce_kbd_dec *mce_kbd = &dev->raw->mce_kbd;
+	struct input_dev *idev = mce_kbd->idev;
+
+	input_unregister_device(idev);
+
+	return 0;
+}
+
+static struct ir_raw_handler mce_kbd_handler = {
+	.protocols	= RC_TYPE_MCE_KBD,
+	.decode		= ir_mce_kbd_decode,
+	.raw_register	= ir_mce_kbd_register,
+	.raw_unregister	= ir_mce_kbd_unregister,
+};
+
+static int __init ir_mce_kbd_decode_init(void)
+{
+	ir_raw_handler_register(&mce_kbd_handler);
+
+	printk(KERN_INFO "IR MCE Keyboard/mouse protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_mce_kbd_decode_exit(void)
+{
+	ir_raw_handler_unregister(&mce_kbd_handler);
+}
+
+module_init(ir_mce_kbd_decode_init);
+module_exit(ir_mce_kbd_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_DESCRIPTION("MCE Keyboard/mouse IR protocol decoder");
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 11c19d8..f4efd2f 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -353,6 +353,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc6_decode();
 	load_jvc_decode();
 	load_sony_decode();
+	load_mce_kbd_decode();
 	load_lirc_codec();
 
 	/* If needed, we may later add some init code. In this case,
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 873b387..e268254 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -84,6 +84,16 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} rc5_sz;
+	struct mce_kbd_dec {
+		struct input_dev *idev;
+		char name[64];
+		char phys[64];
+		int state;
+		u8 header;
+		u32 body;
+		unsigned count;
+		unsigned wanted_bits;
+	} mce_kbd;
 	struct lirc_codec {
 		struct rc_dev *dev;
 		struct lirc_driver *drv;
@@ -182,6 +192,13 @@ void ir_raw_init(void);
 #define load_sony_decode()	0
 #endif
 
+/* from ir-mce_kbd-decoder.c */
+#ifdef CONFIG_IR_MCE_KBD_DECODER_MODULE
+#define load_mce_kbd_decode()	request_module("ir-mce_kbd-decoder")
+#else
+#define load_mce_kbd_decode()	0
+#endif
+
 /* from ir-lirc-codec.c */
 #ifdef CONFIG_IR_LIRC_CODEC_MODULE
 #define load_lirc_codec()	request_module("ir-lirc-codec")
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index f57cd56..20048c3 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -733,6 +733,7 @@ static struct {
 	{ RC_TYPE_JVC,		"jvc"		},
 	{ RC_TYPE_SONY,		"sony"		},
 	{ RC_TYPE_RC5_SZ,	"rc-5-sz"	},
+	{ RC_TYPE_MCE_KBD,	"mce_kbd"	},
 	{ RC_TYPE_LIRC,		"lirc"		},
 	{ RC_TYPE_OTHER,	"other"		},
 };
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 4e1409e..17c9759 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -18,12 +18,13 @@
 #define RC_TYPE_JVC	(1  << 3)	/* JVC protocol */
 #define RC_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
 #define RC_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
+#define RC_TYPE_MCE_KBD	(1  << 29)	/* RC6-ish MCE keyboard/mouse */
 #define RC_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
 #define RC_TYPE_OTHER	(1u << 31)
 
 #define RC_TYPE_ALL (RC_TYPE_RC5 | RC_TYPE_NEC  | RC_TYPE_RC6  | \
 		     RC_TYPE_JVC | RC_TYPE_SONY | RC_TYPE_LIRC | \
-		     RC_TYPE_RC5_SZ | RC_TYPE_OTHER)
+		     RC_TYPE_RC5_SZ | RC_TYPE_MCE_KBD | RC_TYPE_OTHER)
 
 struct rc_map_table {
 	u32	scancode;
-- 
1.7.5.2

