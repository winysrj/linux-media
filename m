Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:47943 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab1D1POx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2011 11:14:53 -0400
Subject: [PATCH 08/10] rc-core: merge rc5 and streamzap decoders
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@redhat.com
Date: Thu, 28 Apr 2011 17:13:53 +0200
Message-ID: <20110428151353.8272.81582.stgit@felix.hardeman.nu>
In-Reply-To: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
References: <20110428151311.8272.17290.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Now that the protocol is part of the scancode, it is pretty easy to merge
the rc5 and streamzap decoders. An additional advantage is that the decoder
is now stricter as it waits for the trailing silence before determining that
a command is a valid rc5/streamzap command (which avoids collisions that I've
seen with e.g. Sony protocols).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/Kconfig                |   12 --
 drivers/media/rc/Makefile               |    1 
 drivers/media/rc/ir-rc5-decoder.c       |   51 ++++++----
 drivers/media/rc/ir-rc5-sz-decoder.c    |  153 -------------------------------
 drivers/media/rc/keymaps/rc-streamzap.c |    4 -
 drivers/media/rc/rc-core-priv.h         |    8 --
 drivers/media/rc/streamzap.c            |   10 --
 7 files changed, 31 insertions(+), 208 deletions(-)
 delete mode 100644 drivers/media/rc/ir-rc5-sz-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 7f03142..7242b0d 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -75,18 +75,6 @@ config IR_SONY_DECODER
 	   Enable this option if you have an infrared remote control which
 	   uses the Sony protocol, and you need software decoding support.
 
-config IR_RC5_SZ_DECODER
-	tristate "Enable IR raw decoder for the RC-5 (streamzap) protocol"
-	depends on RC_CORE
-	select BITREVERSE
-	default y
-
-	---help---
-	   Enable this option if you have IR with RC-5 (streamzap) protocol,
-	   and if the IR is decoded in software. (The Streamzap PC Remote
-	   uses an IR protocol that is almost standard RC-5, but not quite,
-	   as it uses an additional bit).
-
 config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
 	depends on RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index c6cfe70..2d9ddde 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
 obj-$(CONFIG_IR_JVC_DECODER) += ir-jvc-decoder.o
 obj-$(CONFIG_IR_SONY_DECODER) += ir-sony-decoder.o
-obj-$(CONFIG_IR_RC5_SZ_DECODER) += ir-rc5-sz-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
 
 # stand-alone IR receivers/transmitters
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index ed726ca..159e57f 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -1,6 +1,7 @@
-/* ir-rc5-decoder.c - handle RC5(x) IR Pulse/Space protocol
+/* ir-rc5-decoder.c - decoder for RC5(x) and StreamZap protocols
  *
  * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -13,22 +14,21 @@
  */
 
 /*
- * This code handles 14 bits RC5 protocols and 20 bits RC5x protocols.
- * There are other variants that use a different number of bits.
- * This is currently unsupported.
- * It considers a carrier of 36 kHz, with a total of 14/20 bits, where
- * the first two bits are start bits, and a third one is a filing bit
+ * This decoder handles the 14 bit RC5 protocol, 15 bit "StreamZap" protocol
+ * and 20 bit RC5x protocol.
  */
 
 #include "rc-core-priv.h"
 
 #define RC5_NBITS		14
+#define RC5_SZ_NBITS		15
 #define RC5X_NBITS		20
 #define CHECK_RC5X_NBITS	8
 #define RC5_UNIT		888888 /* ns */
 #define RC5_BIT_START		(1 * RC5_UNIT)
 #define RC5_BIT_END		(1 * RC5_UNIT)
 #define RC5X_SPACE		(4 * RC5_UNIT)
+#define RC5_TRAILER		(10 * RC5_UNIT) /* In reality, approx 100 */
 
 enum rc5_state {
 	STATE_INACTIVE,
@@ -79,12 +79,15 @@ again:
 
 		data->state = STATE_BIT_START;
 		data->count = 1;
-		/* We just need enough bits to get to STATE_CHECK_RC5X */
-		data->wanted_bits = RC5X_NBITS;
 		decrease_duration(&ev, RC5_BIT_START);
 		goto again;
 
 	case STATE_BIT_START:
+		if (!ev.pulse && geq_margin(ev.duration, RC5_TRAILER, RC5_UNIT / 2)) {
+			data->state = STATE_FINISHED;
+			goto again;
+		}
+
 		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
 			break;
 
@@ -99,9 +102,7 @@ again:
 		if (!is_transition(&ev, &dev->raw->prev_ev))
 			break;
 
-		if (data->count == data->wanted_bits)
-			data->state = STATE_FINISHED;
-		else if (data->count == CHECK_RC5X_NBITS)
+		if (data->count == CHECK_RC5X_NBITS)
 			data->state = STATE_CHECK_RC5X;
 		else
 			data->state = STATE_BIT_START;
@@ -111,13 +112,10 @@ again:
 
 	case STATE_CHECK_RC5X:
 		if (!ev.pulse && geq_margin(ev.duration, RC5X_SPACE, RC5_UNIT / 2)) {
-			/* RC5X */
-			data->wanted_bits = RC5X_NBITS;
+			data->is_rc5x = true;
 			decrease_duration(&ev, RC5X_SPACE);
-		} else {
-			/* RC5 */
-			data->wanted_bits = RC5_NBITS;
-		}
+		} else
+			data->is_rc5x = false;
 		data->state = STATE_BIT_START;
 		goto again;
 
@@ -125,7 +123,7 @@ again:
 		if (ev.pulse)
 			break;
 
-		if (data->wanted_bits == RC5X_NBITS) {
+		if (data->is_rc5x && data->count == RC5X_NBITS) {
 			/* RC5X */
 			u8 xdata, command, system;
 			xdata    = (data->bits & 0x0003F) >> 0;
@@ -135,7 +133,7 @@ again:
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 16 | command << 8 | xdata;
 			protocol = RC_TYPE_RC5X;
-		} else {
+		} else if (!data->is_rc5x && data->count == RC5_NBITS) {
 			/* RC5 */
 			u8 command, system;
 			command  = (data->bits & 0x0003F) >> 0;
@@ -144,10 +142,19 @@ again:
 			command += (data->bits & 0x01000) ? 0 : 0x40;
 			scancode = system << 8 | command;
 			protocol = RC_TYPE_RC5;
-		}
+		} else if (!data->is_rc5x && data->count == RC5_SZ_NBITS) {
+			/* RC5 StreamZap */
+			u8 command, system;
+			command  = (data->bits & 0x0003F) >> 0;
+			system   = (data->bits & 0x02FC0) >> 6;
+			toggle   = (data->bits & 0x01000) ? 1 : 0;
+			scancode = system << 6 | command;
+			protocol = RC_TYPE_RC5_SZ;
+		} else
+			break;
 
 		if (dev->enabled_protocols & (1 << protocol)) {
-			IR_dprintk(1, "RC5(x) scancode 0x%06x (toggle: %u)\n",
+			IR_dprintk(1, "RC5(x/sz) scancode 0x%06x (toggle: %u)\n",
 				   scancode, toggle);
 			rc_keydown(dev, protocol, scancode, toggle);
 		}
@@ -164,7 +171,7 @@ out:
 }
 
 static struct ir_raw_handler rc5_handler = {
-	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X,
+	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
 };
 
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
deleted file mode 100644
index 7e9e9c5..0000000
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ /dev/null
@@ -1,153 +0,0 @@
-/* ir-rc5-sz-decoder.c - handle RC5 Streamzap IR Pulse/Space protocol
- *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-/*
- * This code handles the 15 bit RC5-ish protocol used by the Streamzap
- * PC Remote.
- * It considers a carrier of 36 kHz, with a total of 15 bits, where
- * the first two bits are start bits, and a third one is a filing bit
- */
-
-#include "rc-core-priv.h"
-
-#define RC5_SZ_NBITS		15
-#define RC5_UNIT		888888 /* ns */
-#define RC5_BIT_START		(1 * RC5_UNIT)
-#define RC5_BIT_END		(1 * RC5_UNIT)
-
-enum rc5_sz_state {
-	STATE_INACTIVE,
-	STATE_BIT_START,
-	STATE_BIT_END,
-	STATE_FINISHED,
-};
-
-/**
- * ir_rc5_sz_decode() - Decode one RC-5 Streamzap pulse or space
- * @dev:	the struct rc_dev descriptor of the device
- * @ev:		the struct ir_raw_event descriptor of the pulse/space
- *
- * This function returns -EINVAL if the pulse violates the state machine
- */
-static int ir_rc5_sz_decode(struct rc_dev *dev, struct ir_raw_event ev)
-{
-	struct rc5_sz_dec *data = &dev->raw->rc5_sz;
-	u8 toggle, command, system;
-	u32 scancode;
-
-        if (!(dev->enabled_protocols & RC_BIT_RC5_SZ))
-                return 0;
-
-	if (!is_timing_event(ev)) {
-		if (ev.reset)
-			data->state = STATE_INACTIVE;
-		return 0;
-	}
-
-	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
-		goto out;
-
-again:
-	IR_dprintk(2, "RC5-sz decode started at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
-
-	if (!geq_margin(ev.duration, RC5_UNIT, RC5_UNIT / 2))
-		return 0;
-
-	switch (data->state) {
-
-	case STATE_INACTIVE:
-		if (!ev.pulse)
-			break;
-
-		data->state = STATE_BIT_START;
-		data->count = 1;
-		data->wanted_bits = RC5_SZ_NBITS;
-		decrease_duration(&ev, RC5_BIT_START);
-		goto again;
-
-	case STATE_BIT_START:
-		if (!eq_margin(ev.duration, RC5_BIT_START, RC5_UNIT / 2))
-			break;
-
-		data->bits <<= 1;
-		if (!ev.pulse)
-			data->bits |= 1;
-		data->count++;
-		data->state = STATE_BIT_END;
-		return 0;
-
-	case STATE_BIT_END:
-		if (!is_transition(&ev, &dev->raw->prev_ev))
-			break;
-
-		if (data->count == data->wanted_bits)
-			data->state = STATE_FINISHED;
-		else
-			data->state = STATE_BIT_START;
-
-		decrease_duration(&ev, RC5_BIT_END);
-		goto again;
-
-	case STATE_FINISHED:
-		if (ev.pulse)
-			break;
-
-		/* RC5-sz */
-		command  = (data->bits & 0x0003F) >> 0;
-		system   = (data->bits & 0x02FC0) >> 6;
-		toggle   = (data->bits & 0x01000) ? 1 : 0;
-		scancode = system << 6 | command;
-
-		IR_dprintk(1, "RC5-sz scancode 0x%04x (toggle: %u)\n",
-			   scancode, toggle);
-
-		rc_keydown(dev, RC_TYPE_RC5_SZ, scancode, toggle);
-		data->state = STATE_INACTIVE;
-		return 0;
-	}
-
-out:
-	IR_dprintk(1, "RC5-sz decode failed at state %i (%uus %s)\n",
-		   data->state, TO_US(ev.duration), TO_STR(ev.pulse));
-	data->state = STATE_INACTIVE;
-	return -EINVAL;
-}
-
-static struct ir_raw_handler rc5_sz_handler = {
-	.protocols	= RC_BIT_RC5_SZ,
-	.decode		= ir_rc5_sz_decode,
-};
-
-static int __init ir_rc5_sz_decode_init(void)
-{
-	ir_raw_handler_register(&rc5_sz_handler);
-
-	printk(KERN_INFO "IR RC5 (streamzap) protocol handler initialized\n");
-	return 0;
-}
-
-static void __exit ir_rc5_sz_decode_exit(void)
-{
-	ir_raw_handler_unregister(&rc5_sz_handler);
-}
-
-module_init(ir_rc5_sz_decode_init);
-module_exit(ir_rc5_sz_decode_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
-MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
-MODULE_DESCRIPTION("RC5 (streamzap) IR protocol decoder");
diff --git a/drivers/media/rc/keymaps/rc-streamzap.c b/drivers/media/rc/keymaps/rc-streamzap.c
index 3e4d62f..d8d097a 100644
--- a/drivers/media/rc/keymaps/rc-streamzap.c
+++ b/drivers/media/rc/keymaps/rc-streamzap.c
@@ -14,9 +14,7 @@
 static struct rc_map_table streamzap[] = {
 /*
  * The Streamzap remote is almost, but not quite, RC-5, as it has an extra
- * bit in it, which throws the in-kernel RC-5 decoder for a loop. Currently,
- * an additional RC-5-sz decoder is being deployed to support it, but it
- * may be possible to merge it back with the standard RC-5 decoder.
+ * bit in it.
  */
 	{ RC_TYPE_RC5_SZ, RC_SCANCODE_RC5_SZ(0x28,0xc0), KEY_NUMERIC_0 },
 	{ RC_TYPE_RC5_SZ, RC_SCANCODE_RC5_SZ(0x28,0xc1), KEY_NUMERIC_1 },
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 729b6a7..bcdf7b5 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -54,7 +54,7 @@ struct ir_raw_event_ctrl {
 		int state;
 		u32 bits;
 		unsigned count;
-		unsigned wanted_bits;
+		bool is_rc5x;
 	} rc5;
 	struct rc6_dec {
 		int state;
@@ -77,12 +77,6 @@ struct ir_raw_event_ctrl {
 		bool first;
 		bool toggle;
 	} jvc;
-	struct rc5_sz_dec {
-		int state;
-		u32 bits;
-		unsigned count;
-		unsigned wanted_bits;
-	} rc5_sz;
 	struct lirc_codec {
 		struct rc_dev *dev;
 		struct lirc_driver *drv;
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 48cf47f..eccfbb4 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -69,13 +69,6 @@ MODULE_DEVICE_TABLE(usb, streamzap_table);
 /* number of samples buffered */
 #define SZ_BUF_LEN 128
 
-/* from ir-rc5-sz-decoder.c */
-#ifdef CONFIG_IR_RC5_SZ_DECODER_MODULE
-#define load_rc5_sz_decode()    request_module("ir-rc5-sz-decoder")
-#else
-#define load_rc5_sz_decode()    {}
-#endif
-
 enum StreamzapDecoderState {
 	PulseSpace,
 	FullPulse,
@@ -458,9 +451,6 @@ static int __devinit streamzap_probe(struct usb_interface *intf,
 	dev_info(sz->dev, "Registered %s on usb%d:%d\n", name,
 		 usbdev->bus->busnum, usbdev->devnum);
 
-	/* Load the streamzap not-quite-rc5 decoder too */
-	load_rc5_sz_decode();
-
 	return 0;
 
 rc_dev_fail:

