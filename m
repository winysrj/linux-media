Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab0HPP4J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 11:56:09 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o7GFu8Jv012963
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 11:56:09 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o7GFu8i1021308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 11:56:08 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o7GFu7R0023414
	for <linux-media@vger.kernel.org>; Mon, 16 Aug 2010 11:56:07 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o7GFu7jl023412
	for linux-media@vger.kernel.org; Mon, 16 Aug 2010 11:56:07 -0400
Date: Mon, 16 Aug 2010 11:56:06 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR/streamzap: enable functional in-kernel decoding
Message-ID: <20100816155606.GA23390@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch makes in-kernel decoding with the stock Streamzap PC Remote
work out of the box. There are quite a few things going on in this
patch, all (mostly) related to getting this working:

1) I had to enable reporting of a long space at the end of each signal,
   or I had weird buffering and keybounce issues.

2) The keymap has been reworked slightly to match actual decoded values,
   the first edition was missing the pre-data bits present in the lirc
   config file for this remote.

3) There's a whole new decoder included, specifically for the
   not-quite-RC5 15-bit protocol variant used by the Streamzap PC
   Remote. The decoder, while usable with other recievers (tested with
   an mceusb receiver), will only be loaded by the streamzap driver, as
   its likely not of use in almost all other situations. This can be
   revisited if/when all keytable loading (and disabling of unneeded
   protocol decoder engines) is moved to userspace, but for now, I think
   this makes the most sense.

Note that I did try to enable handling the streamzap RC5-ish protocol in
the current RC5 decoder, but there's no particularly easy way to tell if
its 14-bit RC5 or 15-bit Streamzap until we see bit 14, and even then,
in testing an attempted decoder merge, only 2/3 of the keys were
properly recognized as being the 15-bit variant and decoded correctly,
the rest were close enough to compliant with 14-bit that they were
decoded as such (but they have overlap with one another, and thus we
can't just shrug and use the 14-bit decoded values).

Also of note in this patch is the removal of the streamzap driver's
internal delay buffer. Per discussion w/Christoph, it shouldn't be
needed by lirc any longer anyway, and it doesn't seem to make any
difference to the in-kernel decoder engine. That being the case, I'm
yanking it all out, as it greatly simplifies the driver code (net result
is that streamzap.c is now 252 lines less than lirc_streamzap.c was).

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig                    |   12 +
 drivers/media/IR/Makefile                   |    1 +
 drivers/media/IR/ir-core-priv.h             |    6 +
 drivers/media/IR/ir-rc5-sz-decoder.c        |  153 ++++++++++++
 drivers/media/IR/ir-sysfs.c                 |    1 +
 drivers/media/IR/keymaps/Makefile           |    2 +-
 drivers/media/IR/keymaps/rc-rc5-streamzap.c |   81 ------
 drivers/media/IR/keymaps/rc-streamzap.c     |   82 ++++++
 drivers/media/IR/streamzap.c                |  358 +++++++--------------------
 include/media/rc-map.h                      |    5 +-
 10 files changed, 352 insertions(+), 349 deletions(-)
 create mode 100644 drivers/media/IR/ir-rc5-sz-decoder.c
 delete mode 100644 drivers/media/IR/keymaps/rc-rc5-streamzap.c
 create mode 100644 drivers/media/IR/keymaps/rc-streamzap.c

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 490c57c..152000d 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -79,6 +79,18 @@ config IR_SONY_DECODER
 	   Enable this option if you have an infrared remote control which
 	   uses the Sony protocol, and you need software decoding support.
 
+config IR_RC5_SZ_DECODER
+	tristate "Enable IR raw decoder for the RC-5 (streamzap) protocol"
+	depends on IR_CORE
+	select BITREVERSE
+	default y
+
+	---help---
+	   Enable this option if you have IR with RC-5 (streamzap) protocol,
+	   and if the IR is decoded in software. (The Streamzap PC Remote
+	   uses an IR protocol that is almost standard RC-5, but not quite,
+	   as it uses an additional bit).
+
 config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
 	depends on IR_CORE
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index 5367683..953c6c4 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
+obj-$(CONFIG_IR_RC5_SZ_DECODER) += ir-rc5-sz-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
 # stand-alone IR receivers/transmitters
diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index a85a8c7..0ad8ea3 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -76,6 +76,12 @@ struct ir_raw_event_ctrl {
 		bool first;
 		bool toggle;
 	} jvc;
+	struct rc5_sz_dec {
+		int state;
+		u32 bits;
+		unsigned count;
+		unsigned wanted_bits;
+	} rc5_sz;
 	struct lirc_codec {
 		struct ir_input_dev *ir_dev;
 		struct lirc_driver *drv;
diff --git a/drivers/media/IR/ir-rc5-sz-decoder.c b/drivers/media/IR/ir-rc5-sz-decoder.c
new file mode 100644
index 0000000..68f11d6
--- /dev/null
+++ b/drivers/media/IR/ir-rc5-sz-decoder.c
@@ -0,0 +1,153 @@
+/* ir-rc5-sz-decoder.c - handle RC5 Streamzap IR Pulse/Space protocol
+ *
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+/*
+ * This code handles the 15 bit RC5-ish protocol used by the Streamzap
+ * PC Remote.
+ * It considers a carrier of 36 kHz, with a total of 15 bits, where
+ * the first two bits are start bits, and a third one is a filing bit
+ */
+
+#include "ir-core-priv.h"
+
+#define RC5_SZ_NBITS		15
+#define RC5_UNIT		888888 /* ns */
+#define RC5_BIT_START		(1 * RC5_UNIT)
+#define RC5_BIT_END		(1 * RC5_UNIT)
+
+enum rc5_sz_state {
+	STATE_INACTIVE,
+	STATE_BIT_START,
+	STATE_BIT_END,
+	STATE_FINISHED,
+};
+
+/**
+ * ir_rc5_sz_decode() - Decode one RC-5 Streamzap pulse or space
+ * @input_dev:	the struct input_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_rc5_sz_decode(struct input_dev *input_dev, struct ir_raw_event ev)
+{
+	struct ir_input_dev *ir_dev = input_get_drvdata(input_dev);
+	struct rc5_sz_dec *data = &ir_dev->raw->rc5_sz;
+	u8 toggle, command, system;
+	u32 scancode;
+
+        if (!(ir_dev->raw->enabled_protocols & IR_TYPE_RC5_SZ))
+                return 0;
+
+	if (IS_RESET(ev)) {
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
+		goto out;
+
+again:
+	IR_dprintk(2, "RC5-sz decode started at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
+		return 0;
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		data->state = STATE_BIT_START;
+		data->count = 1;
+		data->wanted_bits = RC5_SZ_NBITS;
+		decrease_duration(&ev, RC5_BIT_START);
+		goto again;
+
+	case STATE_BIT_START:
+		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
+			break;
+
+		data->bits <<= 1;
+		if (!ev.pulse)
+			data->bits |= 1;
+		data->count++;
+		data->state = STATE_BIT_END;
+		return 0;
+
+	case STATE_BIT_END:
+		if (!is_transition(&ev, &ir_dev->raw->prev_ev))
+			break;
+
+		if (data->count == data->wanted_bits)
+			data->state = STATE_FINISHED;
+		else
+			data->state = STATE_BIT_START;
+
+		decrease_duration(&ev, RC5_BIT_END);
+		goto again;
+
+	case STATE_FINISHED:
+		if (ev.pulse)
+			break;
+
+		/* RC5-sz */
+		command  = (data->bits & 0x0003F) >> 0;
+		system   = (data->bits & 0x02FC0) >> 6;
+		toggle   = (data->bits & 0x01000) ? 1 : 0;
+		scancode = system << 6 | command;
+
+		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
+			   scancode, toggle);
+
+		ir_keydown(input_dev, scancode, toggle);
+		data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+out:
+	IR_dprintk(1, "RC5-sz decode failed at state %i (%uus %s)\n",
+		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static struct ir_raw_handler rc5_sz_handler = {
+	.protocols	= IR_TYPE_RC5_SZ,
+	.decode		= ir_rc5_sz_decode,
+};
+
+static int __init ir_rc5_sz_decode_init(void)
+{
+	ir_raw_handler_register(&rc5_sz_handler);
+
+	printk(KERN_INFO "IR RC5 (streamzap) protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_rc5_sz_decode_exit(void)
+{
+	ir_raw_handler_unregister(&rc5_sz_handler);
+}
+
+module_init(ir_rc5_sz_decode_init);
+module_exit(ir_rc5_sz_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("RC5 (streamzap) IR protocol decoder");
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 96dafc4..72403cd 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -43,6 +43,7 @@ static struct {
 	{ IR_TYPE_RC6,		"rc-6"		},
 	{ IR_TYPE_JVC,		"jvc"		},
 	{ IR_TYPE_SONY,		"sony"		},
+	{ IR_TYPE_RC5_SZ,	"rc-5-sz"	},
 	{ IR_TYPE_LIRC,		"lirc"		},
 };
 
diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
index 950e5d9..c032b9d 100644
--- a/drivers/media/IR/keymaps/Makefile
+++ b/drivers/media/IR/keymaps/Makefile
@@ -58,10 +58,10 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-purpletv.o \
 			rc-pv951.o \
 			rc-rc5-hauppauge-new.o \
-			rc-rc5-streamzap.o \
 			rc-rc5-tv.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
+			rc-streamzap.o \
 			rc-tbs-nec.o \
 			rc-terratec-cinergy-xs.o \
 			rc-tevii-nec.o \
diff --git a/drivers/media/IR/keymaps/rc-rc5-streamzap.c b/drivers/media/IR/keymaps/rc-rc5-streamzap.c
deleted file mode 100644
index 4c19c58..0000000
--- a/drivers/media/IR/keymaps/rc-rc5-streamzap.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/* rc-rc5-streamzap.c - Keytable for Streamzap PC Remote, for use
- * with the Streamzap PC Remote IR Receiver.
- *
- * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-
-static struct ir_scancode rc5_streamzap[] = {
-/*
- * FIXME: The Streamzap remote isn't actually true RC-5, it has an extra
- * bit in it, which presently throws the in-kernel RC-5 decoder for a loop.
- * We either have to enhance the decoder to support it, add a new decoder,
- * or just rely on lirc userspace decoding.
- */
-	{ 0x00, KEY_NUMERIC_0 },
-	{ 0x01, KEY_NUMERIC_1 },
-	{ 0x02, KEY_NUMERIC_2 },
-	{ 0x03, KEY_NUMERIC_3 },
-	{ 0x04, KEY_NUMERIC_4 },
-	{ 0x05, KEY_NUMERIC_5 },
-	{ 0x06, KEY_NUMERIC_6 },
-	{ 0x07, KEY_NUMERIC_7 },
-	{ 0x08, KEY_NUMERIC_8 },
-	{ 0x0a, KEY_POWER },
-	{ 0x0b, KEY_MUTE },
-	{ 0x0c, KEY_CHANNELUP },
-	{ 0x0d, KEY_VOLUMEUP },
-	{ 0x0e, KEY_CHANNELDOWN },
-	{ 0x0f, KEY_VOLUMEDOWN },
-	{ 0x10, KEY_UP },
-	{ 0x11, KEY_LEFT },
-	{ 0x12, KEY_OK },
-	{ 0x13, KEY_RIGHT },
-	{ 0x14, KEY_DOWN },
-	{ 0x15, KEY_MENU },
-	{ 0x16, KEY_EXIT },
-	{ 0x17, KEY_PLAY },
-	{ 0x18, KEY_PAUSE },
-	{ 0x19, KEY_STOP },
-	{ 0x1a, KEY_BACK },
-	{ 0x1b, KEY_FORWARD },
-	{ 0x1c, KEY_RECORD },
-	{ 0x1d, KEY_REWIND },
-	{ 0x1e, KEY_FASTFORWARD },
-	{ 0x20, KEY_RED },
-	{ 0x21, KEY_GREEN },
-	{ 0x22, KEY_YELLOW },
-	{ 0x23, KEY_BLUE },
-
-};
-
-static struct rc_keymap rc5_streamzap_map = {
-	.map = {
-		.scan    = rc5_streamzap,
-		.size    = ARRAY_SIZE(rc5_streamzap),
-		.ir_type = IR_TYPE_RC5,
-		.name    = RC_MAP_RC5_STREAMZAP,
-	}
-};
-
-static int __init init_rc_map_rc5_streamzap(void)
-{
-	return ir_register_map(&rc5_streamzap_map);
-}
-
-static void __exit exit_rc_map_rc5_streamzap(void)
-{
-	ir_unregister_map(&rc5_streamzap_map);
-}
-
-module_init(init_rc_map_rc5_streamzap)
-module_exit(exit_rc_map_rc5_streamzap)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/IR/keymaps/rc-streamzap.c b/drivers/media/IR/keymaps/rc-streamzap.c
new file mode 100644
index 0000000..df32013
--- /dev/null
+++ b/drivers/media/IR/keymaps/rc-streamzap.c
@@ -0,0 +1,82 @@
+/* rc-streamzap.c - Keytable for Streamzap PC Remote, for use
+ * with the Streamzap PC Remote IR Receiver.
+ *
+ * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <media/rc-map.h>
+
+static struct ir_scancode streamzap[] = {
+/*
+ * The Streamzap remote is almost, but not quite, RC-5, as it has an extra
+ * bit in it, which throws the in-kernel RC-5 decoder for a loop. Currently,
+ * an additional RC-5-sz decoder is being deployed to support it, but it
+ * may be possible to merge it back with the standard RC-5 decoder.
+ */
+	{ 0x28c0, KEY_NUMERIC_0 },
+	{ 0x28c1, KEY_NUMERIC_1 },
+	{ 0x28c2, KEY_NUMERIC_2 },
+	{ 0x28c3, KEY_NUMERIC_3 },
+	{ 0x28c4, KEY_NUMERIC_4 },
+	{ 0x28c5, KEY_NUMERIC_5 },
+	{ 0x28c6, KEY_NUMERIC_6 },
+	{ 0x28c7, KEY_NUMERIC_7 },
+	{ 0x28c8, KEY_NUMERIC_8 },
+	{ 0x28c9, KEY_NUMERIC_9 },
+	{ 0x28ca, KEY_POWER },
+	{ 0x28cb, KEY_MUTE },
+	{ 0x28cc, KEY_CHANNELUP },
+	{ 0x28cd, KEY_VOLUMEUP },
+	{ 0x28ce, KEY_CHANNELDOWN },
+	{ 0x28cf, KEY_VOLUMEDOWN },
+	{ 0x28d0, KEY_UP },
+	{ 0x28d1, KEY_LEFT },
+	{ 0x28d2, KEY_OK },
+	{ 0x28d3, KEY_RIGHT },
+	{ 0x28d4, KEY_DOWN },
+	{ 0x28d5, KEY_MENU },
+	{ 0x28d6, KEY_EXIT },
+	{ 0x28d7, KEY_PLAY },
+	{ 0x28d8, KEY_PAUSE },
+	{ 0x28d9, KEY_STOP },
+	{ 0x28da, KEY_BACK },
+	{ 0x28db, KEY_FORWARD },
+	{ 0x28dc, KEY_RECORD },
+	{ 0x28dd, KEY_REWIND },
+	{ 0x28de, KEY_FASTFORWARD },
+	{ 0x28e0, KEY_RED },
+	{ 0x28e1, KEY_GREEN },
+	{ 0x28e2, KEY_YELLOW },
+	{ 0x28e3, KEY_BLUE },
+
+};
+
+static struct rc_keymap streamzap_map = {
+	.map = {
+		.scan    = streamzap,
+		.size    = ARRAY_SIZE(streamzap),
+		.ir_type = IR_TYPE_RC5_SZ,
+		.name    = RC_MAP_STREAMZAP,
+	}
+};
+
+static int __init init_rc_map_streamzap(void)
+{
+	return ir_register_map(&streamzap_map);
+}
+
+static void __exit exit_rc_map_streamzap(void)
+{
+	ir_unregister_map(&streamzap_map);
+}
+
+module_init(init_rc_map_streamzap)
+module_exit(exit_rc_map_streamzap)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
diff --git a/drivers/media/IR/streamzap.c b/drivers/media/IR/streamzap.c
index 058e29f..2cf57e6 100644
--- a/drivers/media/IR/streamzap.c
+++ b/drivers/media/IR/streamzap.c
@@ -38,7 +38,7 @@
 #include <linux/input.h>
 #include <media/ir-core.h>
 
-#define DRIVER_VERSION	"1.60"
+#define DRIVER_VERSION	"1.61"
 #define DRIVER_NAME	"streamzap"
 #define DRIVER_DESC	"Streamzap Remote Control driver"
 
@@ -69,6 +69,13 @@ MODULE_DEVICE_TABLE(usb, streamzap_table);
 /* number of samples buffered */
 #define SZ_BUF_LEN 128
 
+/* from ir-rc5-sz-decoder.c */
+#ifdef CONFIG_IR_RC5_SZ_DECODER_MODULE
+#define load_rc5_sz_decode()    request_module("ir-rc5-sz-decoder")
+#else
+#define load_rc5_sz_decode()    0
+#endif
+
 enum StreamzapDecoderState {
 	PulseSpace,
 	FullPulse,
@@ -81,7 +88,6 @@ struct streamzap_ir {
 
 	/* ir-core */
 	struct ir_dev_props *props;
-	struct ir_raw_event rawir;
 
 	/* core device info */
 	struct device *dev;
@@ -98,17 +104,6 @@ struct streamzap_ir {
 	dma_addr_t		dma_in;
 	unsigned int		buf_in_len;
 
-	/* timer used to support delay buffering */
-	struct timer_list	delay_timer;
-	bool			timer_running;
-	spinlock_t		timer_lock;
-	struct timer_list	flush_timer;
-	bool			flush;
-
-	/* delay buffer */
-	struct kfifo fifo;
-	bool fifo_initialized;
-
 	/* track what state we're in */
 	enum StreamzapDecoderState decoder_state;
 	/* tracks whether we are currently receiving some signal */
@@ -118,7 +113,7 @@ struct streamzap_ir {
 	/* start time of signal; necessary for gap tracking */
 	struct timeval		signal_last;
 	struct timeval		signal_start;
-	/* bool			timeout_enabled; */
+	bool			timeout_enabled;
 
 	char			name[128];
 	char			phys[64];
@@ -143,122 +138,16 @@ static struct usb_driver streamzap_driver = {
 	.id_table =	streamzap_table,
 };
 
-static void streamzap_stop_timer(struct streamzap_ir *sz)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&sz->timer_lock, flags);
-	if (sz->timer_running) {
-		sz->timer_running = false;
-		spin_unlock_irqrestore(&sz->timer_lock, flags);
-		del_timer_sync(&sz->delay_timer);
-	} else {
-		spin_unlock_irqrestore(&sz->timer_lock, flags);
-	}
-}
-
-static void streamzap_flush_timeout(unsigned long arg)
-{
-	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
-
-	dev_info(sz->dev, "%s: callback firing\n", __func__);
-
-	/* finally start accepting data */
-	sz->flush = false;
-}
-
-static void streamzap_delay_timeout(unsigned long arg)
-{
-	struct streamzap_ir *sz = (struct streamzap_ir *)arg;
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
-	unsigned long flags;
-	int len, ret;
-	static unsigned long delay;
-	bool wake = false;
-
-	/* deliver data every 10 ms */
-	delay = msecs_to_jiffies(10);
-
-	spin_lock_irqsave(&sz->timer_lock, flags);
-
-	if (kfifo_len(&sz->fifo) > 0) {
-		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
-		if (ret != sizeof(rawir))
-			dev_err(sz->dev, "Problem w/kfifo_out...\n");
-		ir_raw_event_store(sz->idev, &rawir);
-		wake = true;
-	}
-
-	len = kfifo_len(&sz->fifo);
-	if (len > 0) {
-		while ((len < SZ_BUF_LEN / 2) &&
-		       (len < SZ_BUF_LEN * sizeof(int))) {
-			ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
-			if (ret != sizeof(rawir))
-				dev_err(sz->dev, "Problem w/kfifo_out...\n");
-			ir_raw_event_store(sz->idev, &rawir);
-			wake = true;
-			len = kfifo_len(&sz->fifo);
-		}
-		if (sz->timer_running)
-			mod_timer(&sz->delay_timer, jiffies + delay);
-
-	} else {
-		sz->timer_running = false;
-	}
-
-	if (wake)
-		ir_raw_event_handle(sz->idev);
-
-	spin_unlock_irqrestore(&sz->timer_lock, flags);
-}
-
-static void streamzap_flush_delay_buffer(struct streamzap_ir *sz)
+static void sz_push(struct streamzap_ir *sz, struct ir_raw_event rawir)
 {
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
-	bool wake = false;
-	int ret;
-
-	while (kfifo_len(&sz->fifo) > 0) {
-		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
-		if (ret != sizeof(rawir))
-			dev_err(sz->dev, "Problem w/kfifo_out...\n");
-		ir_raw_event_store(sz->idev, &rawir);
-		wake = true;
-	}
-
-	if (wake)
-		ir_raw_event_handle(sz->idev);
-}
-
-static void sz_push(struct streamzap_ir *sz)
-{
-	struct ir_raw_event rawir = { .pulse = false, .duration = 0 };
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&sz->timer_lock, flags);
-	if (kfifo_len(&sz->fifo) >= sizeof(int) * SZ_BUF_LEN) {
-		ret = kfifo_out(&sz->fifo, &rawir, sizeof(rawir));
-		if (ret != sizeof(rawir))
-			dev_err(sz->dev, "Problem w/kfifo_out...\n");
-		ir_raw_event_store(sz->idev, &rawir);
-	}
-
-	kfifo_in(&sz->fifo, &sz->rawir, sizeof(rawir));
-
-	if (!sz->timer_running) {
-		sz->delay_timer.expires = jiffies + (HZ / 10);
-		add_timer(&sz->delay_timer);
-		sz->timer_running = true;
-	}
-
-	spin_unlock_irqrestore(&sz->timer_lock, flags);
+	ir_raw_event_store(sz->idev, &rawir);
 }
 
 static void sz_push_full_pulse(struct streamzap_ir *sz,
 			       unsigned char value)
 {
+	struct ir_raw_event rawir;
+
 	if (sz->idle) {
 		long deltv;
 
@@ -266,33 +155,33 @@ static void sz_push_full_pulse(struct streamzap_ir *sz,
 		do_gettimeofday(&sz->signal_start);
 
 		deltv = sz->signal_start.tv_sec - sz->signal_last.tv_sec;
-		sz->rawir.pulse = false;
+		rawir.pulse = false;
 		if (deltv > 15) {
 			/* really long time */
-			sz->rawir.duration = IR_MAX_DURATION;
+			rawir.duration = IR_MAX_DURATION;
 		} else {
-			sz->rawir.duration = (int)(deltv * 1000000 +
+			rawir.duration = (int)(deltv * 1000000 +
 				sz->signal_start.tv_usec -
 				sz->signal_last.tv_usec);
-			sz->rawir.duration -= sz->sum;
-			sz->rawir.duration *= 1000;
-			sz->rawir.duration &= IR_MAX_DURATION;
+			rawir.duration -= sz->sum;
+			rawir.duration *= 1000;
+			rawir.duration &= IR_MAX_DURATION;
 		}
-		dev_dbg(sz->dev, "ls %u\n", sz->rawir.duration);
-		sz_push(sz);
+		dev_dbg(sz->dev, "ls %u\n", rawir.duration);
+		sz_push(sz, rawir);
 
-		sz->idle = 0;
+		sz->idle = false;
 		sz->sum = 0;
 	}
 
-	sz->rawir.pulse = true;
-	sz->rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
-	sz->rawir.duration += STREAMZAP_RESOLUTION / 2;
-	sz->sum += sz->rawir.duration;
-	sz->rawir.duration *= 1000;
-	sz->rawir.duration &= IR_MAX_DURATION;
-	dev_dbg(sz->dev, "p %u\n", sz->rawir.duration);
-	sz_push(sz);
+	rawir.pulse = true;
+	rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
+	rawir.duration += STREAMZAP_RESOLUTION / 2;
+	sz->sum += rawir.duration;
+	rawir.duration *= 1000;
+	rawir.duration &= IR_MAX_DURATION;
+	dev_dbg(sz->dev, "p %u\n", rawir.duration);
+	sz_push(sz, rawir);
 }
 
 static void sz_push_half_pulse(struct streamzap_ir *sz,
@@ -304,13 +193,15 @@ static void sz_push_half_pulse(struct streamzap_ir *sz,
 static void sz_push_full_space(struct streamzap_ir *sz,
 			       unsigned char value)
 {
-	sz->rawir.pulse = false;
-	sz->rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
-	sz->rawir.duration += STREAMZAP_RESOLUTION / 2;
-	sz->sum += sz->rawir.duration;
-	sz->rawir.duration *= 1000;
-	dev_dbg(sz->dev, "s %u\n", sz->rawir.duration);
-	sz_push(sz);
+	struct ir_raw_event rawir;
+
+	rawir.pulse = false;
+	rawir.duration = ((int) value) * STREAMZAP_RESOLUTION;
+	rawir.duration += STREAMZAP_RESOLUTION / 2;
+	sz->sum += rawir.duration;
+	rawir.duration *= 1000;
+	dev_dbg(sz->dev, "s %u\n", rawir.duration);
+	sz_push(sz, rawir);
 }
 
 static void sz_push_half_space(struct streamzap_ir *sz,
@@ -330,10 +221,8 @@ static void streamzap_callback(struct urb *urb)
 	struct streamzap_ir *sz;
 	unsigned int i;
 	int len;
-	#if 0
 	static int timeout = (((STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION) &
 				IR_MAX_DURATION) | 0x03000000);
-	#endif
 
 	if (!urb)
 		return;
@@ -356,57 +245,53 @@ static void streamzap_callback(struct urb *urb)
 	}
 
 	dev_dbg(sz->dev, "%s: received urb, len %d\n", __func__, len);
-	if (!sz->flush) {
-		for (i = 0; i < urb->actual_length; i++) {
-			dev_dbg(sz->dev, "%d: %x\n", i,
-				(unsigned char)sz->buf_in[i]);
-			switch (sz->decoder_state) {
-			case PulseSpace:
-				if ((sz->buf_in[i] & STREAMZAP_PULSE_MASK) ==
-				    STREAMZAP_PULSE_MASK) {
-					sz->decoder_state = FullPulse;
-					continue;
-				} else if ((sz->buf_in[i] & STREAMZAP_SPACE_MASK)
-					   == STREAMZAP_SPACE_MASK) {
-					sz_push_half_pulse(sz, sz->buf_in[i]);
-					sz->decoder_state = FullSpace;
-					continue;
-				} else {
-					sz_push_half_pulse(sz, sz->buf_in[i]);
-					sz_push_half_space(sz, sz->buf_in[i]);
-				}
-				break;
-			case FullPulse:
-				sz_push_full_pulse(sz, sz->buf_in[i]);
-				sz->decoder_state = IgnorePulse;
-				break;
-			case FullSpace:
-				if (sz->buf_in[i] == STREAMZAP_TIMEOUT) {
-					sz->idle = 1;
-					streamzap_stop_timer(sz);
-					#if 0
-					if (sz->timeout_enabled) {
-						sz->rawir.pulse = false;
-						sz->rawir.duration = timeout;
-						sz->rawir.duration *= 1000;
-						sz_push(sz);
-					}
-					#endif
-					streamzap_flush_delay_buffer(sz);
-				} else
-					sz_push_full_space(sz, sz->buf_in[i]);
-				sz->decoder_state = PulseSpace;
-				break;
-			case IgnorePulse:
-				if ((sz->buf_in[i]&STREAMZAP_SPACE_MASK) ==
-				    STREAMZAP_SPACE_MASK) {
-					sz->decoder_state = FullSpace;
-					continue;
-				}
+	for (i = 0; i < len; i++) {
+		dev_dbg(sz->dev, "sz idx %d: %x\n",
+			i, (unsigned char)sz->buf_in[i]);
+		switch (sz->decoder_state) {
+		case PulseSpace:
+			if ((sz->buf_in[i] & STREAMZAP_PULSE_MASK) ==
+				STREAMZAP_PULSE_MASK) {
+				sz->decoder_state = FullPulse;
+				continue;
+			} else if ((sz->buf_in[i] & STREAMZAP_SPACE_MASK)
+					== STREAMZAP_SPACE_MASK) {
+				sz_push_half_pulse(sz, sz->buf_in[i]);
+				sz->decoder_state = FullSpace;
+				continue;
+			} else {
+				sz_push_half_pulse(sz, sz->buf_in[i]);
 				sz_push_half_space(sz, sz->buf_in[i]);
-				sz->decoder_state = PulseSpace;
-				break;
 			}
+			break;
+		case FullPulse:
+			sz_push_full_pulse(sz, sz->buf_in[i]);
+			sz->decoder_state = IgnorePulse;
+			break;
+		case FullSpace:
+			if (sz->buf_in[i] == STREAMZAP_TIMEOUT) {
+				struct ir_raw_event rawir;
+
+				rawir.pulse = false;
+				rawir.duration = timeout * 1000;
+				sz->idle = true;
+				if (sz->timeout_enabled)
+					sz_push(sz, rawir);
+				ir_raw_event_handle(sz->idev);
+			} else {
+				sz_push_full_space(sz, sz->buf_in[i]);
+			}
+			sz->decoder_state = PulseSpace;
+			break;
+		case IgnorePulse:
+			if ((sz->buf_in[i] & STREAMZAP_SPACE_MASK) ==
+				STREAMZAP_SPACE_MASK) {
+				sz->decoder_state = FullSpace;
+				continue;
+			}
+			sz_push_half_space(sz, sz->buf_in[i]);
+			sz->decoder_state = PulseSpace;
+			break;
 		}
 	}
 
@@ -446,12 +331,11 @@ static struct input_dev *streamzap_init_input_dev(struct streamzap_ir *sz)
 
 	props->priv = sz;
 	props->driver_type = RC_DRIVER_IR_RAW;
-	/* FIXME: not sure about supported protocols, check on this */
-	props->allowed_protos = IR_TYPE_RC5 | IR_TYPE_RC6;
+	props->allowed_protos = IR_TYPE_ALL;
 
 	sz->props = props;
 
-	ret = ir_input_register(idev, RC_MAP_RC5_STREAMZAP, props, DRIVER_NAME);
+	ret = ir_input_register(idev, RC_MAP_STREAMZAP, props, DRIVER_NAME);
 	if (ret < 0) {
 		dev_err(dev, "remote input device register failed\n");
 		goto irdev_failed;
@@ -467,29 +351,6 @@ idev_alloc_failed:
 	return NULL;
 }
 
-static int streamzap_delay_buf_init(struct streamzap_ir *sz)
-{
-	int ret;
-
-	ret = kfifo_alloc(&sz->fifo, sizeof(int) * SZ_BUF_LEN,
-			  GFP_KERNEL);
-	if (ret == 0)
-		sz->fifo_initialized = 1;
-
-	return ret;
-}
-
-static void streamzap_start_flush_timer(struct streamzap_ir *sz)
-{
-	sz->flush_timer.expires = jiffies + HZ;
-	sz->flush = true;
-	add_timer(&sz->flush_timer);
-
-	sz->urb_in->dev = sz->usbdev;
-	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
-		dev_err(sz->dev, "urb submit failed\n");
-}
-
 /**
  *	streamzap_probe
  *
@@ -575,35 +436,21 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	retval = streamzap_delay_buf_init(sz);
-	if (retval) {
-		dev_err(&intf->dev, "%s: delay buffer init failed\n", __func__);
-		goto free_urb_in;
-	}
-
 	sz->idev = streamzap_init_input_dev(sz);
 	if (!sz->idev)
 		goto input_dev_fail;
 
 	sz->idle = true;
 	sz->decoder_state = PulseSpace;
+	/* FIXME: don't yet have a way to set this */
+	sz->timeout_enabled = true;
 	#if 0
 	/* not yet supported, depends on patches from maxim */
 	/* see also: LIRC_GET_REC_RESOLUTION and LIRC_SET_REC_TIMEOUT */
-	sz->timeout_enabled = false;
 	sz->min_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION * 1000;
 	sz->max_timeout = STREAMZAP_TIMEOUT * STREAMZAP_RESOLUTION * 1000;
 	#endif
 
-	init_timer(&sz->delay_timer);
-	sz->delay_timer.function = streamzap_delay_timeout;
-	sz->delay_timer.data = (unsigned long)sz;
-	spin_lock_init(&sz->timer_lock);
-
-	init_timer(&sz->flush_timer);
-	sz->flush_timer.function = streamzap_flush_timeout;
-	sz->flush_timer.data = (unsigned long)sz;
-
 	do_gettimeofday(&sz->signal_start);
 
 	/* Complete final initialisations */
@@ -615,16 +462,18 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 
 	usb_set_intfdata(intf, sz);
 
-	streamzap_start_flush_timer(sz);
+	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC))
+		dev_err(sz->dev, "urb submit failed\n");
 
 	dev_info(sz->dev, "Registered %s on usb%d:%d\n", name,
 		 usbdev->bus->busnum, usbdev->devnum);
 
+	/* Load the streamzap not-quite-rc5 decoder too */
+	load_rc5_sz_decode();
+
 	return 0;
 
 input_dev_fail:
-	kfifo_free(&sz->fifo);
-free_urb_in:
 	usb_free_urb(sz->urb_in);
 free_buf_in:
 	usb_free_coherent(usbdev, maxp, sz->buf_in, sz->dma_in);
@@ -654,13 +503,6 @@ static void streamzap_disconnect(struct usb_interface *interface)
 	if (!sz)
 		return;
 
-	if (sz->flush) {
-		sz->flush = false;
-		del_timer_sync(&sz->flush_timer);
-	}
-
-	streamzap_stop_timer(sz);
-
 	sz->usbdev = NULL;
 	ir_input_unregister(sz->idev);
 	usb_kill_urb(sz->urb_in);
@@ -674,13 +516,6 @@ static int streamzap_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct streamzap_ir *sz = usb_get_intfdata(intf);
 
-	if (sz->flush) {
-		sz->flush = false;
-		del_timer_sync(&sz->flush_timer);
-	}
-
-	streamzap_stop_timer(sz);
-
 	usb_kill_urb(sz->urb_in);
 
 	return 0;
@@ -690,13 +525,6 @@ static int streamzap_resume(struct usb_interface *intf)
 {
 	struct streamzap_ir *sz = usb_get_intfdata(intf);
 
-	if (sz->fifo_initialized)
-		kfifo_reset(&sz->fifo);
-
-	sz->flush_timer.expires = jiffies + HZ;
-	sz->flush = true;
-	add_timer(&sz->flush_timer);
-
 	if (usb_submit_urb(sz->urb_in, GFP_ATOMIC)) {
 		dev_err(sz->dev, "Error sumbiting urb\n");
 		return -EIO;
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index a9c041d..6c0324e 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -17,12 +17,13 @@
 #define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
 #define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
 #define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
+#define IR_TYPE_RC5_SZ	(1  << 5)	/* RC5 variant used by Streamzap */
 #define IR_TYPE_LIRC	(1  << 30)	/* Pass raw IR to lirc userspace */
 #define IR_TYPE_OTHER	(1u << 31)
 
 #define IR_TYPE_ALL (IR_TYPE_RC5 | IR_TYPE_NEC  | IR_TYPE_RC6  | \
 		     IR_TYPE_JVC | IR_TYPE_SONY | IR_TYPE_LIRC | \
-		     IR_TYPE_OTHER)
+		     IR_TYPE_RC5_SZ | IR_TYPE_OTHER)
 
 struct ir_scancode {
 	u32	scancode;
@@ -114,10 +115,10 @@ void rc_map_init(void);
 #define RC_MAP_PURPLETV                  "rc-purpletv"
 #define RC_MAP_PV951                     "rc-pv951"
 #define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
-#define RC_MAP_RC5_STREAMZAP             "rc-rc5-streamzap"
 #define RC_MAP_RC5_TV                    "rc-rc5-tv"
 #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
 #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"
+#define RC_MAP_STREAMZAP                 "rc-streamzap"
 #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
 #define RC_MAP_TERRATEC_CINERGY_XS       "rc-terratec-cinergy-xs"
 #define RC_MAP_TEVII_NEC                 "rc-tevii-nec"
-- 
1.7.2.1

-- 
Jarod Wilson
jarod@redhat.com

