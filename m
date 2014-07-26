Return-path: <linux-media-owner@vger.kernel.org>
Received: from doortje.mesa.nl ([83.161.67.157]:45852 "EHLO mesa.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaGZUoh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 16:44:37 -0400
Received: from joshua.mesa.nl (localhost.localdomain [127.0.0.1])
	by mesa.nl (8.12.11/8.12.8) with ESMTP id s6QKSQ51009284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 26 Jul 2014 22:28:26 +0200
Received: (from marcel@localhost)
	by joshua.mesa.nl (8.12.11/8.12.8/Submit) id s6QKSQgi009282
	for linux-media@vger.kernel.org; Sat, 26 Jul 2014 22:28:26 +0200
Date: Sat, 26 Jul 2014 22:28:26 +0200
From: "Marcel J.E. Mol" <marcel@mesa.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] rc: Add support for decoding XMP protocol
Message-ID: <20140726202826.GA19338@joshua.mesa.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

    This protocol is found on Dreambox remotes

Signed-off-by: Marcel Mol <marcel@mesa.nl>
---
 drivers/media/rc/Kconfig          |  10 ++
 drivers/media/rc/Makefile         |   1 +
 drivers/media/rc/ir-xmp-decoder.c | 226 ++++++++++++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h   |  12 ++
 drivers/media/rc/rc-ir-raw.c      |   1 +
 drivers/media/rc/rc-main.c        |   1 +
 include/media/rc-map.h            |   6 +-
 7 files changed, 256 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/rc/ir-xmp-decoder.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 9d15a57..5e626af 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -113,6 +113,16 @@ config IR_MCE_KBD_DECODER
 	   Enable this option if you have a Microsoft Remote Keyboard for
 	   Windows Media Center Edition, which you would like to use with
 	   a raw IR receiver in your system.
+
+config IR_XMP_DECODER
+	tristate "Enable IR raw decoder for the XMP protocol"
+	depends on RC_CORE
+	select BITREVERSE
+	default y
+
+	---help---
+	   Enable this option if you have IR with XMP protocol, and
+	   if the IR is decoded in software
 endif #RC_DECODERS
 
 menuconfig RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 096eb06..9f9843a1 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
 obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_LIRC_CODEC) += ir-lirc-codec.o
+obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
diff --git a/drivers/media/rc/ir-xmp-decoder.c b/drivers/media/rc/ir-xmp-decoder.c
new file mode 100644
index 0000000..e717765
--- /dev/null
+++ b/drivers/media/rc/ir-xmp-decoder.c
@@ -0,0 +1,226 @@
+/* ir-xmp-decoder.c - handle XMP IR Pulse/Space protocol
+ *
+ * Copyright (C) 2014 by Marcel Mol
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ * - Based on info from http://www.hifi-remote.com
+ * - Ignore Toggle=9 frames
+ * - Ignore XMP-1 XMP-2 difference, always store 16 bit OBC
+ */
+
+#include <linux/bitrev.h>
+#include <linux/module.h>
+#include "rc-core-priv.h"
+
+#define XMP_UNIT		  136000 /* ns */
+#define XMP_LEADER		  210000 /* ns */
+#define XMP_NIBBLE_PREFIX	  760000 /* ns */
+#define	XMP_HALFFRAME_SPACE	13800000 /* ns */
+#define	XMP_TRAILER_SPACE	20000000 /* should be 80ms but not all dureation supliers can go that high */
+
+enum xmp_state {
+	STATE_INACTIVE,
+	STATE_LEADER_PULSE,
+	STATE_NIBBLE_SPACE,
+};
+
+/**
+ * ir_xmp_decode() - Decode one XMP pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @duration:	the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_xmp_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct xmp_dec *data = &dev->raw->xmp;
+
+	if (!rc_protocols_enabled(dev, RC_BIT_XMP))
+		return 0;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	IR_dprintk(2, "XMP decode started at state %d %d (%uus %s)\n",
+		   data->state, data->count, TO_US(ev.duration), TO_STR(ev.pulse));
+
+	switch (data->state) {
+
+	case STATE_INACTIVE:
+		if (!ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, XMP_LEADER, XMP_UNIT / 2)) {
+			data->count = 0;
+			data->state = STATE_NIBBLE_SPACE;
+		}
+
+		return 0;
+
+	case STATE_LEADER_PULSE:
+		if (!ev.pulse)
+			break;
+
+		if (eq_margin(ev.duration, XMP_LEADER, XMP_UNIT / 2))
+			data->state = STATE_NIBBLE_SPACE;
+
+		return 0;
+
+	case STATE_NIBBLE_SPACE:
+		if (ev.pulse)
+			break;
+
+		if (geq_margin(ev.duration, XMP_TRAILER_SPACE, XMP_NIBBLE_PREFIX )) {
+			int divider, i;
+			u8 addr, subaddr, subaddr2, toggle, oem, obc1, obc2, sum1, sum2;
+			u32 *n;
+			u32 scancode;
+
+			if (data->count != 16) {
+				IR_dprintk(2, "received TRAILER period at index %d: %u\n",
+					data->count, ev.duration);
+				data->state = STATE_INACTIVE;
+				return -EINVAL;
+			}
+
+			n = data->durations;
+			/*
+			 * the 4th nibble should be 15 so base the divider on this
+			 * to transform durations into nibbles. Substract 2000 from
+			 * the divider to compensate for fluctuations in the signal
+			 */
+			divider = (n[3] - XMP_NIBBLE_PREFIX) / 15 - 2000;
+			if (divider < 50) {
+				IR_dprintk(2, "divider to small %d.\n", divider);
+				data->state = STATE_INACTIVE;
+				return -EINVAL;
+			}
+
+			/* convert to nibbles and do some sanity checks */
+			for(i = 0; i < 16; i++)
+				n[i] = (n[i] - XMP_NIBBLE_PREFIX) / divider;
+			sum1 = (15 + n[0] + n[1] + n[2] + n[3] +
+				n[4] + n[5] + n[6] + n[7]) % 16;
+			sum2 = (15 + n[8] + n[9] + n[10] + n[11] +
+				n[12] + n[13] + n[14] + n[15]) % 16;
+
+			if (sum1 != 15 || sum2 != 15) {
+				IR_dprintk(2, "checksum errors sum1=0x%X sum2=0x%X\n",
+					sum1, sum2);
+				data->state = STATE_INACTIVE;
+				return -EINVAL;
+			}
+
+			subaddr  = n[0] << 4 | n[2];
+			subaddr2 = n[8] << 4 | n[11];
+			oem      = n[4] << 4 | n[5];
+			addr     = n[6] << 4 | n[7];
+			toggle   = n[10];
+			obc1 = n[12] << 4 | n[13];
+			obc2 = n[14] << 4 | n[15];
+			if (subaddr != subaddr2) {
+				IR_dprintk(2, "subaddress nibbles mismatch 0x%02X != 0x%02X\n",
+					subaddr, subaddr2);
+				data->state = STATE_INACTIVE;
+				return -EINVAL;
+			}
+			if (oem != 0x44)
+				IR_dprintk(1, "Warning: OEM nibbles 0x%02X. Expected 0x44\n",
+					oem);
+
+			scancode = addr << 24 | subaddr << 16 | obc1 << 8 | obc2;
+			IR_dprintk(1, "XMP scancode 0x%06x\n", scancode);
+
+			if (toggle == 0) {
+				rc_keydown(dev, scancode, 0);
+			}
+			else {
+				rc_repeat(dev);
+				IR_dprintk(1, "Repeat last key\n");
+			}
+			data->state = STATE_INACTIVE;
+
+			return 0;
+
+		}
+		else if (geq_margin(ev.duration, XMP_HALFFRAME_SPACE, XMP_NIBBLE_PREFIX)) {
+			/* Expect 8 or 16 nibble pulses. 16 in case of 'final' frame */
+			if (data->count == 16) {
+				IR_dprintk(2, "received half frame pulse at index %d."
+					" Probably a final frame key-up event: %u\n",
+					data->count, ev.duration);
+				/* TODO: for now go back to half frame position so
+				 *       trailer can be found and key press can be handled
+				 */
+				data->count = 8;
+			}
+
+			else if (data->count != 8)
+				IR_dprintk(2, "received half frame pulse at index %d: %u\n",
+					data->count, ev.duration);
+			data->state = STATE_LEADER_PULSE;
+
+			return 0;
+
+		}
+		else if (geq_margin(ev.duration, XMP_NIBBLE_PREFIX, XMP_UNIT)) {
+			/* store nibble raw data, decode after trailer */
+			if (data->count == 16) {
+				IR_dprintk(2, "to many pulses (%d) ignoring: %u\n",
+					data->count, ev.duration);
+				data->state = STATE_INACTIVE;
+				return -EINVAL;
+			}
+			data->durations[data->count] = ev.duration;
+			data->count++;
+			data->state = STATE_LEADER_PULSE;
+
+			return 0;
+
+		}
+
+		break;
+	}
+
+	IR_dprintk(1, "XMP decode failed at count %d state %d (%uus %s)\n",
+		   data->count, data->state, TO_US(ev.duration), TO_STR(ev.pulse));
+	data->state = STATE_INACTIVE;
+	return -EINVAL;
+}
+
+static struct ir_raw_handler xmp_handler = {
+	.protocols	= RC_BIT_XMP,
+	.decode		= ir_xmp_decode,
+};
+
+static int __init ir_xmp_decode_init(void)
+{
+	ir_raw_handler_register(&xmp_handler);
+
+	printk(KERN_INFO "IR XMP protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_xmp_decode_exit(void)
+{
+	ir_raw_handler_unregister(&xmp_handler);
+}
+
+module_init(ir_xmp_decode_init);
+module_exit(ir_xmp_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marcel Mol <marcel@mesa.nl>");
+MODULE_AUTHOR("MESA Consulting (http://www.mesa.nl)");
+MODULE_DESCRIPTION("XMP IR protocol decoder");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index dea7aff..b68d4f76 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -110,6 +110,11 @@ struct ir_raw_event_ctrl {
 		bool send_timeout_reports;
 
 	} lirc;
+	struct xmp_dec {
+		int state;
+		unsigned count;
+		u32 durations[16];
+	} xmp;
 };
 
 /* macros for IR decoders */
@@ -225,5 +230,12 @@ static inline void load_mce_kbd_decode(void) { }
 static inline void load_lirc_codec(void) { }
 #endif
 
+/* from ir-xmp-decoder.c */
+#ifdef CONFIG_IR_XMP_DECODER_MODULE
+#define load_xmp_decode()      request_module_nowait("ir-xmp-decoder")
+#else
+static inline void load_xmp_decode(void) { }
+#endif
+
 
 #endif /* _RC_CORE_PRIV */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index e772c4c..e8fff2a 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -362,6 +362,7 @@ void ir_raw_init(void)
 	load_sharp_decode();
 	load_mce_kbd_decode();
 	load_lirc_codec();
+	load_xmp_decode();
 
 	/* If needed, we may later add some init code. In this case,
 	   it is needed to change the CONFIG_MODULE test at rc-core.h
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 39e4b5f..dfceeb4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -800,6 +800,7 @@ static struct {
 	{ RC_BIT_SHARP,		"sharp"		},
 	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
 	{ RC_BIT_LIRC,		"lirc"		},
+	{ RC_BIT_XMP,		"xmp"		},
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 894c7e4..80f9518 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -31,6 +31,7 @@ enum rc_type {
 	RC_TYPE_RC6_6A_32	= 16,	/* Philips RC6-6A-32 protocol */
 	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
 	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
+	RC_TYPE_XMP		= 19,	/* XMP protocol */
 };
 
 #define RC_BIT_NONE		0
@@ -53,6 +54,7 @@ enum rc_type {
 #define RC_BIT_RC6_6A_32	(1 << RC_TYPE_RC6_6A_32)
 #define RC_BIT_RC6_MCE		(1 << RC_TYPE_RC6_MCE)
 #define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
+#define RC_BIT_XMP		(1 << RC_TYPE_XMP)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
 			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
@@ -60,7 +62,9 @@ enum rc_type {
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
-			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP)
+			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
+			 RC_BIT_XMP)
+
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
-- 
1.9.3

