Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46041 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbeCGLzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 06:55:33 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] media: rc: add new imon protocol decoder and encoder
Date: Wed,  7 Mar 2018 11:55:31 +0000
Message-Id: <20180307115532.8196-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes it possible to use the various iMON remotes with any raw IR
RC device.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig               |   9 ++
 drivers/media/rc/Makefile              |   1 +
 drivers/media/rc/ir-imon-codec.c       | 192 +++++++++++++++++++++++++++++++++
 drivers/media/rc/keymaps/rc-imon-pad.c |   2 +-
 drivers/media/rc/rc-core-priv.h        |   6 ++
 drivers/media/rc/rc-main.c             |   8 ++
 include/media/rc-map.h                 |   8 +-
 include/uapi/linux/lirc.h              |   2 +
 8 files changed, 224 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/rc/ir-imon-codec.c

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 7ad05a6ef350..00df4779736c 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -111,6 +111,15 @@ config IR_XMP_DECODER
 	---help---
 	   Enable this option if you have IR with XMP protocol, and
 	   if the IR is decoded in software
+
+config IR_IMON_CODEC
+	tristate "Enable IR raw codec for the iMON protocol"
+	depends on RC_CORE
+	---help---
+	   Enable this option if you have IR with iMON PAD protocol, and
+	   would like to use it with a raw IR receiver, or if you wish
+	   to use an encoder to transmit this IR.
+
 endif #RC_DECODERS
 
 menuconfig RC_DEVICES
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index e098e127b26a..72e029af1669 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_IR_SANYO_DECODER) += ir-sanyo-decoder.o
 obj-$(CONFIG_IR_SHARP_DECODER) += ir-sharp-decoder.o
 obj-$(CONFIG_IR_MCE_KBD_DECODER) += ir-mce_kbd-decoder.o
 obj-$(CONFIG_IR_XMP_DECODER) += ir-xmp-decoder.o
+obj-$(CONFIG_IR_IMON_CODEC) += ir-imon-codec.o
 
 # stand-alone IR receivers/transmitters
 obj-$(CONFIG_RC_ATI_REMOTE) += ati_remote.o
diff --git a/drivers/media/rc/ir-imon-codec.c b/drivers/media/rc/ir-imon-codec.c
new file mode 100644
index 000000000000..f906196a5160
--- /dev/null
+++ b/drivers/media/rc/ir-imon-codec.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0+
+// ir-imon-codec.c - handle iMon protocol
+//
+// Copyright (C) 2018 by Sean Young <sean@mess.org>
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include "rc-core-priv.h"
+
+#define IMON_UNIT		415662 /* ns */
+#define IMON_BITS		30
+#define IMON_CHKBITS		(BIT(30) | BIT(25) | BIT(24) | BIT(22) | \
+				 BIT(21) | BIT(20) | BIT(19) | BIT(18) | \
+				 BIT(17) | BIT(16) | BIT(14) | BIT(13) | \
+				 BIT(12) | BIT(11) | BIT(10) | BIT(9))
+
+/*
+ * This protocol has 30 bits. The format is one IMON_UNIT header pulse,
+ * followed by 30 bits. Each bit is one IMON_UNIT check field, and then
+ * one IMON_UNIT field with the actual bit (space=1, pulse=0).
+ * The check field is space for some bits, for others it is pulse if both the
+ * preceding and current bit are set, else space. IMON_CHKBITS defines
+ * which bits are of type check.
+ *
+ * If an incomplete message is received, then all the remaining bits
+ * are assumed to be 1. This is a problem in the protocol itself.
+ */
+enum imon_state {
+	STATE_INACTIVE,
+	STATE_BIT_CHK,
+	STATE_BIT_START,
+	STATE_FINISHED
+};
+
+/**
+ * ir_imon_decode() - Decode one iMON pulse or space
+ * @dev:	the struct rc_dev descriptor of the device
+ * @ev:		the struct ir_raw_event descriptor of the pulse/space
+ *
+ * This function returns -EINVAL if the pulse violates the state machine
+ */
+static int ir_imon_decode(struct rc_dev *dev, struct ir_raw_event ev)
+{
+	struct imon_dec *data = &dev->raw->imon;
+
+	if (!is_timing_event(ev)) {
+		if (ev.reset)
+			data->state = STATE_INACTIVE;
+		return 0;
+	}
+
+	dev_dbg(&dev->dev,
+		"iMON decode started at state %d bits %d (%uus %s)\n",
+		data->state, data->count, TO_US(ev.duration),
+		TO_STR(ev.pulse));
+
+	for (;;) {
+		if (!geq_margin(ev.duration, IMON_UNIT, IMON_UNIT / 2))
+			return 0;
+
+		decrease_duration(&ev, IMON_UNIT);
+
+		switch (data->state) {
+		case STATE_INACTIVE:
+			if (ev.pulse) {
+				data->state = STATE_BIT_CHK;
+				data->bits = 0;
+				data->count = IMON_BITS;
+			}
+			break;
+		case STATE_BIT_CHK:
+			if (IMON_CHKBITS & BIT(data->count))
+				data->last_chk = ev.pulse;
+			else if (ev.pulse)
+				goto err_out;
+			data->state = STATE_BIT_START;
+			break;
+		case STATE_BIT_START:
+			if (!ev.pulse)
+				data->bits |= 1;
+
+			if (IMON_CHKBITS & BIT(data->count)) {
+				if (data->last_chk != !(data->bits & 3))
+					goto err_out;
+			}
+
+			data->bits <<= 1;
+			data->count--;
+
+			if (!data->count)
+				data->state = STATE_FINISHED;
+			else
+				data->state = STATE_BIT_CHK;
+			break;
+		case STATE_FINISHED:
+			if (ev.pulse)
+				goto err_out;
+			rc_keydown(dev, RC_PROTO_IMON, data->bits | 1, 0);
+			data->state = STATE_INACTIVE;
+			break;
+		}
+	}
+
+err_out:
+	dev_dbg(&dev->dev,
+		"iMON decode failed at state %d bits %d (%uus %s)\n",
+		data->state, data->count, TO_US(ev.duration),
+		TO_STR(ev.pulse));
+
+	data->state = STATE_INACTIVE;
+
+	return -EINVAL;
+}
+
+/**
+ * ir_imon_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:	protocol to encode
+ * @scancode:	scancode to encode
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ */
+static int ir_imon_encode(enum rc_proto protocol, u32 scancode,
+			  struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int i, pulse;
+
+	init_ir_raw_event_duration(e, 1, IMON_UNIT);
+
+	for (i = IMON_BITS; i >= 0; i--) {
+		if (BIT(i) & IMON_CHKBITS)
+			pulse = !(scancode & (BIT(i) | BIT(i + 1)));
+		else
+			pulse = 0;
+
+		if (pulse == e->pulse) {
+			e->duration += IMON_UNIT;
+		} else {
+			if (!max--)
+				return -ENOBUFS;
+			init_ir_raw_event_duration(++e, pulse, IMON_UNIT);
+		}
+
+		pulse = !(scancode & BIT(i));
+
+		if (pulse == e->pulse) {
+			e->duration += IMON_UNIT;
+		} else {
+			if (!max--)
+				return -ENOBUFS;
+			init_ir_raw_event_duration(++e, pulse, IMON_UNIT);
+		}
+	}
+
+	if (e->pulse)
+		e++;
+
+	return e - events;
+}
+
+static struct ir_raw_handler imon_handler = {
+	.protocols	= RC_PROTO_BIT_IMON,
+	.decode		= ir_imon_decode,
+	.encode		= ir_imon_encode,
+	.carrier	= 38000,
+};
+
+static int __init ir_imon_decode_init(void)
+{
+	ir_raw_handler_register(&imon_handler);
+
+	pr_info("IR iMON protocol handler initialized\n");
+	return 0;
+}
+
+static void __exit ir_imon_decode_exit(void)
+{
+	ir_raw_handler_unregister(&imon_handler);
+}
+
+module_init(ir_imon_decode_init);
+module_exit(ir_imon_decode_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sean Young <sean@mess.org>");
+MODULE_DESCRIPTION("iMON IR protocol decoder");
diff --git a/drivers/media/rc/keymaps/rc-imon-pad.c b/drivers/media/rc/keymaps/rc-imon-pad.c
index a7296ffbf218..0761bc8b4b38 100644
--- a/drivers/media/rc/keymaps/rc-imon-pad.c
+++ b/drivers/media/rc/keymaps/rc-imon-pad.c
@@ -135,7 +135,7 @@ static struct rc_map_list imon_pad_map = {
 		.scan     = imon_pad,
 		.size     = ARRAY_SIZE(imon_pad),
 		/* actual protocol details unknown, hardware decoder */
-		.rc_proto = RC_PROTO_OTHER,
+		.rc_proto = RC_PROTO_IMON,
 		.name     = RC_MAP_IMON_PAD,
 	}
 };
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 5e80b4273e2d..e0e6a17460f6 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -118,6 +118,12 @@ struct ir_raw_event_ctrl {
 		unsigned count;
 		u32 durations[16];
 	} xmp;
+	struct imon_dec {
+		int state;
+		int count;
+		int last_chk;
+		unsigned int bits;
+	} imon;
 };
 
 /* macros for IR decoders */
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8621761a680f..681fbf3d9271 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -68,6 +68,7 @@ static const struct {
 		.scancode_bits = 0x1fff, .repeat_period = 250 },
 	[RC_PROTO_XMP] = { .name = "xmp", .repeat_period = 250 },
 	[RC_PROTO_CEC] = { .name = "cec", .repeat_period = 550 },
+	[RC_PROTO_IMON] = { .name = "imon", .repeat_period = 250 },
 };
 
 /* Used to keep track of known keymaps */
@@ -869,6 +870,12 @@ bool rc_validate_scancode(enum rc_proto proto, u32 scancode)
 		if ((scancode & 0xffff0000) == 0x800f0000)
 			return false;
 		break;
+	/*
+	 * iMon hardware decoder always sets some bits, so assume the same
+	 */
+	case RC_PROTO_IMON:
+		if ((scancode & 0x800000001) != 1)
+			return false;
 	default:
 		break;
 	}
@@ -1004,6 +1011,7 @@ static const struct {
 	  RC_PROTO_BIT_MCIR2_MSE, "mce_kbd",	"ir-mce_kbd-decoder"	},
 	{ RC_PROTO_BIT_XMP,	"xmp",		"ir-xmp-decoder"	},
 	{ RC_PROTO_BIT_CEC,	"cec",		NULL			},
+	{ RC_PROTO_BIT_IMON,	"imon",		"ir-imon-codec"		},
 };
 
 /**
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 7fc84991bd12..bfa3017cecba 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -36,6 +36,7 @@
 #define RC_PROTO_BIT_SHARP		BIT_ULL(RC_PROTO_SHARP)
 #define RC_PROTO_BIT_XMP		BIT_ULL(RC_PROTO_XMP)
 #define RC_PROTO_BIT_CEC		BIT_ULL(RC_PROTO_CEC)
+#define RC_PROTO_BIT_IMON		BIT_ULL(RC_PROTO_IMON)
 
 #define RC_PROTO_BIT_ALL \
 			(RC_PROTO_BIT_UNKNOWN | RC_PROTO_BIT_OTHER | \
@@ -49,7 +50,8 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 | RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
-			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC)
+			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_CEC | \
+			 RC_PROTO_BIT_IMON)
 /* All rc protocols for which we have decoders */
 #define RC_PROTO_BIT_ALL_IR_DECODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
@@ -62,7 +64,7 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 |  RC_PROTO_BIT_RC6_6A_32 | \
 			 RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_SHARP | \
-			 RC_PROTO_BIT_XMP)
+			 RC_PROTO_BIT_XMP | RC_PROTO_BIT_IMON)
 
 #define RC_PROTO_BIT_ALL_IR_ENCODER \
 			(RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC5X_20 | \
@@ -75,7 +77,7 @@
 			 RC_PROTO_BIT_RC6_0 | RC_PROTO_BIT_RC6_6A_20 | \
 			 RC_PROTO_BIT_RC6_6A_24 | \
 			 RC_PROTO_BIT_RC6_6A_32 | RC_PROTO_BIT_RC6_MCE | \
-			 RC_PROTO_BIT_SHARP)
+			 RC_PROTO_BIT_SHARP | RC_PROTO_BIT_IMON)
 
 #define RC_SCANCODE_UNKNOWN(x)			(x)
 #define RC_SCANCODE_OTHER(x)			(x)
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 4fe580d36e41..948d9a491083 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -186,6 +186,7 @@ struct lirc_scancode {
  * @RC_PROTO_SHARP: Sharp protocol
  * @RC_PROTO_XMP: XMP protocol
  * @RC_PROTO_CEC: CEC protocol
+ * @RC_PROTO_IMON: iMon Pad protocol
  */
 enum rc_proto {
 	RC_PROTO_UNKNOWN	= 0,
@@ -211,6 +212,7 @@ enum rc_proto {
 	RC_PROTO_SHARP		= 20,
 	RC_PROTO_XMP		= 21,
 	RC_PROTO_CEC		= 22,
+	RC_PROTO_IMON		= 23,
 };
 
 #endif
-- 
2.14.3
