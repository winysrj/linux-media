Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1GMVKI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 17:10:08 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Florian Demski <fdemski@users.sourceforge.net>
Subject: [PATCH v2] [media] rc-core support for Microsoft IR keyboard/mouse
Date: Wed, 13 Jul 2011 17:09:48 -0400
Message-Id: <1310591388-10722-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1307136508-19455-1-git-send-email-jarod@redhat.com>
References: <1307136508-19455-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a custom IR protocol decoder, for the RC-6-ish protocol used by
the Microsoft Remote Keyboard, apparently developed internally at
Microsoft, and officially dubbed MCIR-2, per their March 2011 remote and
transceiver requirements and specifications document, which also touches
on this IR keyboard/mouse device.

http://www.amazon.com/Microsoft-Remote-Keyboard-Windows-ZV1-00004/dp/B000AOAAN8

Its a standard keyboard with embedded thumb stick mouse pointer and
mouse buttons, along with a number of media keys. The media keys are
standard RC-6, identical to the signals from the stock MCE remotes, and
will be handled as such. The keyboard and mouse signals will be decoded
and delivered to the system by an input device registered specifically
by this driver.

Successfully tested with multiple mceusb-driven transceivers, as well as
with fintek-cir and redrat3 hardware. Essentially, any raw IR hardware
with enough sampling resolution should be able to use this decoder,
nothing about it is at all receiver-hardware-specific.

This work is inspired by lirc_mod_mce:

http://mod-mce.sourceforge.net/

The documentation there and code aided in understanding and decoding the
protocol, but the bulk of the code is actually borrowed more from the
existing in-kernel decoders than anything. I did recycle the keyboard
keycode table, a few defines, and some of the keyboard and mouse data
parsing bits from lirc_mod_mce though.

Special thanks to James Meyer for providing the hardware, and being
patient with me as I took forever to get around to writing this.

v2: now know its MCIR-2, updated accordingly, added a key release timer
callback routine to ensure we don't get any stuck keys, and used
symbolic names for the keytable. Also cc'ing Florian this time, who I
believe is the original mod-mce author...

CC: Florian Demski <fdemski@users.sourceforge.net>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/Kconfig              |   11 +
 drivers/media/rc/Makefile             |    1 +
 drivers/media/rc/ir-mce_kbd-decoder.c |  448 +++++++++++++++++++++++++++++++++
 drivers/media/rc/ir-raw.c             |    1 +
 drivers/media/rc/rc-core-priv.h       |   18 ++
 drivers/media/rc/rc-main.c            |    1 +
 include/media/rc-map.h                |    3 +-
 7 files changed, 482 insertions(+), 1 deletions(-)
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
index 0000000..fe96e54
--- /dev/null
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -0,0 +1,448 @@
+/* ir-mce_kbd-decoder.c - A decoder for the RC6-ish keyboard/mouse IR protocol
+ * used by the Microsoft Remote Keyboard for Windows Media Center Edition,
+ * referred to by Microsoft's Windows Media Center remote specification docs
+ * as "an internal protocol called MCIR-2".
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
+ * - MCIR-2 29-bit IR signals used for mouse movement and buttons
+ * - MCIR-2 32-bit IR signals used for standard keyboard keys
+ *
+ * The media keys on the keyboard send RC-6 signals that are inditinguishable
+ * from the keys of the same name on the stock MCE remote, and will be handled
+ * by the standard RC-6 decoder, and be made available to the system via the
+ * input device for the remote, rather than the keyboard/mouse one.
+ */
+
+#define MCIR2_UNIT		333333	/* ns */
+#define MCIR2_HEADER_NBITS	5
+#define MCIR2_MOUSE_NBITS	29
+#define MCIR2_KEYBOARD_NBITS	32
+#define MCIR2_PREFIX_PULSE	(8 * MCIR2_UNIT)
+#define MCIR2_PREFIX_SPACE	(1 * MCIR2_UNIT)
+#define MCIR2_MAX_LEN		(3 * MCIR2_UNIT)
+#define MCIR2_BIT_START		(1 * MCIR2_UNIT)
+#define MCIR2_BIT_END		(1 * MCIR2_UNIT)
+#define MCIR2_BIT_0		(1 * MCIR2_UNIT)
+#define MCIR2_BIT_SET		(2 * MCIR2_UNIT)
+#define MCIR2_MODE_MASK		0xf	/* for the header bits */
+#define MCIR2_KEYBOARD_HEADER	0x4
+#define MCIR2_MOUSE_HEADER	0x1
+#define MCIR2_MASK_KEYS_START	0xe0
+
+enum mce_kbd_mode {
+	MCIR2_MODE_KEYBOARD,
+	MCIR2_MODE_MOUSE,
+	MCIR2_MODE_UNKNOWN,
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
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_A,
+	KEY_B,		KEY_C,		KEY_D,		KEY_E,		KEY_F,
+	KEY_G,		KEY_H,		KEY_I,		KEY_J,		KEY_K,
+	KEY_L,		KEY_M,		KEY_N,		KEY_O,		KEY_P,
+	KEY_Q,		KEY_R,		KEY_S,		KEY_T,		KEY_U,
+	KEY_V,		KEY_W,		KEY_X,		KEY_Y,		KEY_Z,
+	KEY_1,		KEY_2,		KEY_3,		KEY_4,		KEY_5,
+	KEY_6,		KEY_7,		KEY_8,		KEY_9,		KEY_0,
+	KEY_ENTER,	KEY_ESC,	KEY_BACKSPACE,	KEY_TAB,	KEY_SPACE,
+	KEY_MINUS,	KEY_EQUAL,	KEY_LEFTBRACE,	KEY_RIGHTBRACE,	KEY_BACKSLASH,
+	KEY_RESERVED,	KEY_SEMICOLON,	KEY_APOSTROPHE,	KEY_GRAVE,	KEY_COMMA,
+	KEY_DOT,	KEY_SLASH,	KEY_CAPSLOCK,	KEY_F1,		KEY_F2,
+	KEY_F3,		KEY_F4,		KEY_F5,		KEY_F6,		KEY_F7,
+	KEY_F8,		KEY_F9,		KEY_F10,	KEY_F11,	KEY_F12,
+	KEY_SYSRQ,	KEY_SCROLLLOCK,	KEY_PAUSE,	KEY_INSERT,	KEY_HOME,
+	KEY_PAGEUP,	KEY_DELETE,	KEY_END,	KEY_PAGEDOWN,	KEY_RIGHT,
+	KEY_LEFT,	KEY_DOWN,	KEY_UP,		KEY_NUMLOCK,	KEY_KPSLASH,
+	KEY_KPASTERISK,	KEY_KPMINUS,	KEY_KPPLUS,	KEY_KPENTER,	KEY_KP1,
+	KEY_KP2,	KEY_KP3,	KEY_KP4,	KEY_KP5,	KEY_KP6,
+	KEY_KP7,	KEY_KP8,	KEY_KP9,	KEY_KP0,	KEY_KPDOT,
+	KEY_102ND,	KEY_COMPOSE,	KEY_POWER,	KEY_KPEQUAL,	KEY_F13,
+	KEY_F14,	KEY_F15,	KEY_F16,	KEY_F17,	KEY_F18,
+	KEY_F19,	KEY_F20,	KEY_F21,	KEY_F22,	KEY_F23,
+	KEY_F24,	KEY_OPEN,	KEY_HELP,	KEY_PROPS,	KEY_FRONT,
+	KEY_STOP,	KEY_AGAIN,	KEY_UNDO,	KEY_CUT,	KEY_COPY,
+	KEY_PASTE,	KEY_FIND,	KEY_MUTE,	KEY_VOLUMEUP,	KEY_VOLUMEDOWN,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_KPCOMMA,	KEY_RESERVED,
+	KEY_RO,		KEY_KATAKANAHIRAGANA, KEY_YEN,	KEY_HENKAN,	KEY_MUHENKAN,
+	KEY_KPJPCOMMA,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_HANGUEL,
+	KEY_HANJA,	KEY_KATAKANA,	KEY_HIRAGANA,	KEY_ZENKAKUHANKAKU, KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,	KEY_LEFTCTRL,
+	KEY_LEFTSHIFT,	KEY_LEFTALT,	KEY_LEFTMETA,	KEY_RIGHTCTRL,	KEY_RIGHTSHIFT,
+	KEY_RIGHTALT,	KEY_RIGHTMETA,	KEY_PLAYPAUSE,	KEY_STOPCD,	KEY_PREVIOUSSONG,
+	KEY_NEXTSONG,	KEY_EJECTCD,	KEY_VOLUMEUP,	KEY_VOLUMEDOWN,	KEY_MUTE,
+	KEY_WWW,	KEY_BACK,	KEY_FORWARD,	KEY_STOP,	KEY_FIND,
+	KEY_SCROLLUP,	KEY_SCROLLDOWN,	KEY_EDIT,	KEY_SLEEP,	KEY_COFFEE,
+	KEY_REFRESH,	KEY_CALC,	KEY_RESERVED,	KEY_RESERVED,	KEY_RESERVED,
+	KEY_RESERVED
+};
+
+static void mce_kbd_rx_timeout(unsigned long data)
+{
+	struct mce_kbd_dec *mce_kbd = (struct mce_kbd_dec *)data;
+	int i;
+	unsigned char maskcode;
+
+	IR_dprintk(2, "timer callback clearing all keys\n");
+
+	for (i = 0; i < 7; i++) {
+		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
+		input_report_key(mce_kbd->idev, maskcode, 0);
+	}
+
+	for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
+		input_report_key(mce_kbd->idev, kbd_keycodes[i], 0);
+}
+
+static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
+{
+	switch (data->header & MCIR2_MODE_MASK) {
+	case MCIR2_KEYBOARD_HEADER:
+		return MCIR2_MODE_KEYBOARD;
+	case MCIR2_MOUSE_HEADER:
+		return MCIR2_MODE_MOUSE;
+	default:
+		return MCIR2_MODE_UNKNOWN;
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
+		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
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
+		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
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
+	unsigned long delay;
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
+	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
+		goto out;
+
+again:
+	IR_dprintk(2, "started at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	if (!geq_margin(ev.duration, MCIR2_UNIT, MCIR2_UNIT / 2))
+		return 0;
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		/* Note: larger margin on first pulse since each MCIR2_UNIT
+		   is quite short and some hardware takes some time to
+		   adjust to the signal */
+		if (!eq_margin(ev.duration, MCIR2_PREFIX_PULSE, MCIR2_UNIT))
+			break;
+
+		data->state = STATE_HEADER_BIT_START;
+		data->count = 0;
+		data->header = 0;
+		return 0;
+
+	case STATE_HEADER_BIT_START:
+		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
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
+		decrease_duration(&ev, MCIR2_BIT_END);
+
+		if (data->count != MCIR2_HEADER_NBITS) {
+			data->state = STATE_HEADER_BIT_START;
+			goto again;
+		}
+
+		switch (mce_kbd_mode(data)) {
+		case MCIR2_MODE_KEYBOARD:
+			data->wanted_bits = MCIR2_KEYBOARD_NBITS;
+			break;
+		case MCIR2_MODE_MOUSE:
+			data->wanted_bits = MCIR2_MOUSE_NBITS;
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
+		if (geq_margin(ev.duration, MCIR2_MAX_LEN, MCIR2_UNIT / 2))
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
+		decrease_duration(&ev, MCIR2_BIT_END);
+		goto again;
+
+	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
+		switch (data->wanted_bits) {
+		case MCIR2_KEYBOARD_NBITS:
+			scancode = data->body & 0xffff;
+			IR_dprintk(1, "keyboard data 0x%08x\n", data->body);
+			if (dev->timeout)
+				delay = usecs_to_jiffies(dev->timeout / 1000);
+			else
+				delay = msecs_to_jiffies(100);
+			mod_timer(&data->rx_timeout, jiffies + delay);
+			/* Pass data to keyboard buffer parser */
+			ir_mce_kbd_process_keyboard_data(data->idev, scancode);
+			break;
+		case MCIR2_MOUSE_NBITS:
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
+	setup_timer(&mce_kbd->rx_timeout, mce_kbd_rx_timeout,
+		    (unsigned long)mce_kbd);
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
+	del_timer_sync(&mce_kbd->rx_timeout);
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
index 423ed45..27808bb 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -355,6 +355,7 @@ static void init_decoders(struct work_struct *work)
 	load_rc6_decode();
 	load_jvc_decode();
 	load_sony_decode();
+	load_mce_kbd_decode();
 	load_lirc_codec();
 
 	/* If needed, we may later add some init code. In this case,
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 873b387..04c2c72 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -84,6 +84,17 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		unsigned wanted_bits;
 	} rc5_sz;
+	struct mce_kbd_dec {
+		struct input_dev *idev;
+		struct timer_list rx_timeout;
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
@@ -182,6 +193,13 @@ void ir_raw_init(void);
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
index 3186ac7..e9568e4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -735,6 +735,7 @@ static struct {
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
1.7.1

