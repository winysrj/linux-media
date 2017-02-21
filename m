Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:55037 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753805AbdBUUnt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:49 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 09/19] [media] mce_kbd: add encoder
Date: Tue, 21 Feb 2017 20:43:33 +0000
Message-Id: <9e944325a27c3a77c21d92b0557c0d1d88fc46d8.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Split the protocol into two variants, one for keyboard and one for mouse
data.

Note that the mce_kbd protocol cannot be used on the igorplugusb, since
the IR is too long.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/igorplugusb.c        |  2 +-
 drivers/media/rc/ir-mce_kbd-decoder.c | 49 +++++++++++++++++++++-
 drivers/media/rc/rc-core-priv.h       |  2 +-
 drivers/media/rc/rc-ir-raw.c          |  6 +--
 drivers/media/rc/rc-main.c            |  8 +++-
 include/media/rc-map.h                | 78 ++++++++++++++++++-----------------
 6 files changed, 99 insertions(+), 46 deletions(-)

diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
index 0f0ed4e..cb6d4f1 100644
--- a/drivers/media/rc/igorplugusb.c
+++ b/drivers/media/rc/igorplugusb.c
@@ -205,7 +205,7 @@ static int igorplugusb_probe(struct usb_interface *intf,
 	rc->allowed_protocols = RC_BIT_ALL_IR_DECODER & ~(RC_BIT_NEC |
 			RC_BIT_NECX | RC_BIT_NEC32 | RC_BIT_RC6_6A_20 |
 			RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE |
-			RC_BIT_SONY20 | RC_BIT_MCE_KBD | RC_BIT_SANYO);
+			RC_BIT_SONY20 | RC_BIT_SANYO);
 
 	rc->priv = ir;
 	rc->driver_name = DRIVER_NAME;
diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 5226d51..6a4d58b 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -23,7 +23,7 @@
  * - MCIR-2 29-bit IR signals used for mouse movement and buttons
  * - MCIR-2 32-bit IR signals used for standard keyboard keys
  *
- * The media keys on the keyboard send RC-6 signals that are inditinguishable
+ * The media keys on the keyboard send RC-6 signals that are indistinguishable
  * from the keys of the same name on the stock MCE remote, and will be handled
  * by the standard RC-6 decoder, and be made available to the system via the
  * input device for the remote, rather than the keyboard/mouse one.
@@ -339,6 +339,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 		}
 
 		data->state = STATE_INACTIVE;
+		input_event(data->idev, EV_MSC, MSC_SCAN, scancode);
 		input_sync(data->idev);
 		return 0;
 	}
@@ -418,9 +419,53 @@ static int ir_mce_kbd_unregister(struct rc_dev *dev)
 	return 0;
 }
 
+static const struct ir_raw_timings_manchester ir_mce_kbd_timings = {
+	.leader		= MCIR2_PREFIX_PULSE,
+	.invert		= 1,
+	.clock		= MCIR2_UNIT,
+	.trailer_space	= MCIR2_UNIT * 10,
+};
+
+/**
+ * ir_mce_kbd_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:   protocol to encode
+ * @scancode:   scancode to encode
+ * @events:     array of raw ir events to write into
+ * @max:        maximum size of @events
+ *
+ * Returns:     The number of events written.
+ *              -ENOBUFS if there isn't enough space in the array to fit the
+ *              encoding. In this case all @max events will have been written.
+ */
+static int ir_mce_kbd_encode(enum rc_type protocol, u32 scancode,
+			     struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int len, ret;
+	u64 raw;
+
+	if (protocol == RC_TYPE_MCIR2_KBD) {
+		raw = scancode |
+		      ((u64)MCIR2_KEYBOARD_HEADER << MCIR2_KEYBOARD_NBITS);
+		len = MCIR2_KEYBOARD_NBITS + MCIR2_HEADER_NBITS + 1;
+	} else {
+		raw = scancode |
+		      ((u64)MCIR2_MOUSE_HEADER << MCIR2_MOUSE_NBITS);
+		len = MCIR2_MOUSE_NBITS + MCIR2_HEADER_NBITS + 1;
+	}
+
+	ret = ir_raw_gen_manchester(&e, max, &ir_mce_kbd_timings, len, raw);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler mce_kbd_handler = {
-	.protocols	= RC_BIT_MCE_KBD,
+	.protocols	= RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE,
 	.decode		= ir_mce_kbd_decode,
+	.encode		= ir_mce_kbd_encode,
 	.raw_register	= ir_mce_kbd_register,
 	.raw_unregister	= ir_mce_kbd_unregister,
 };
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index a70a5c55..0455b27 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -185,7 +185,7 @@ struct ir_raw_timings_manchester {
 
 int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 			  const struct ir_raw_timings_manchester *timings,
-			  unsigned int n, unsigned int data);
+			  unsigned int n, u64 data);
 
 /**
  * ir_raw_gen_pulse_space() - generate pulse and space raw events.
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 7fa84b6..90f66dc 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -258,13 +258,13 @@ static void ir_raw_disable_protocols(struct rc_dev *dev, u64 protocols)
  */
 int ir_raw_gen_manchester(struct ir_raw_event **ev, unsigned int max,
 			  const struct ir_raw_timings_manchester *timings,
-			  unsigned int n, unsigned int data)
+			  unsigned int n, u64 data)
 {
 	bool need_pulse;
-	unsigned int i;
+	u64 i;
 	int ret = -ENOBUFS;
 
-	i = 1 << (n - 1);
+	i = BIT_ULL(n - 1);
 
 	if (timings->leader) {
 		if (!max--)
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2424946..b189f24 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -746,6 +746,8 @@ static int rc_validate_filter(struct rc_dev *dev,
 		[RC_TYPE_NECX] = 0xffffff,
 		[RC_TYPE_NEC32] = 0xffffffff,
 		[RC_TYPE_SANYO] = 0x1fffff,
+		[RC_TYPE_MCIR2_KBD] = 0xffff,
+		[RC_TYPE_MCIR2_MSE] = 0x1fffff,
 		[RC_TYPE_RC6_0] = 0xffff,
 		[RC_TYPE_RC6_6A_20] = 0xfffff,
 		[RC_TYPE_RC6_6A_24] = 0xffffff,
@@ -878,7 +880,8 @@ static const struct {
 	{ RC_BIT_RC5_SZ,	"rc-5-sz",	"ir-rc5-decoder"	},
 	{ RC_BIT_SANYO,		"sanyo",	"ir-sanyo-decoder"	},
 	{ RC_BIT_SHARP,		"sharp",	"ir-sharp-decoder"	},
-	{ RC_BIT_MCE_KBD,	"mce_kbd",	"ir-mce_kbd-decoder"	},
+	{ RC_BIT_MCIR2_KBD |
+	  RC_BIT_MCIR2_MSE,	"mce_kbd",	"ir-mce_kbd-decoder"	},
 	{ RC_BIT_XMP,		"xmp",		"ir-xmp-decoder"	},
 	{ RC_BIT_CEC,		"cec",		NULL			},
 };
@@ -1346,7 +1349,8 @@ static const char * const proto_variant_names[] = {
 	[RC_TYPE_NECX] = "nec-x",
 	[RC_TYPE_NEC32] = "nec-32",
 	[RC_TYPE_SANYO] = "sanyo",
-	[RC_TYPE_MCE_KBD] = "mce_kbd",
+	[RC_TYPE_MCIR2_KBD] = "mcir2-kbd",
+	[RC_TYPE_MCIR2_MSE] = "mcir2-mse",
 	[RC_TYPE_RC6_0] = "rc-6-0",
 	[RC_TYPE_RC6_6A_20] = "rc-6-6a-20",
 	[RC_TYPE_RC6_6A_24] = "rc-6-6a-24",
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 878d852..1a815a5 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -27,7 +27,8 @@
  * @RC_TYPE_NECX: Extended NEC protocol
  * @RC_TYPE_NEC32: NEC 32 bit protocol
  * @RC_TYPE_SANYO: Sanyo protocol
- * @RC_TYPE_MCE_KBD: RC6-ish MCE keyboard/mouse
+ * @RC_TYPE_MCIR2_KBD: RC6-ish MCE keyboard
+ * @RC_TYPE_MCIR2_MSE: RC6-ish MCE mouse
  * @RC_TYPE_RC6_0: Philips RC6-0-16 protocol
  * @RC_TYPE_RC6_6A_20: Philips RC6-6A-20 protocol
  * @RC_TYPE_RC6_6A_24: Philips RC6-6A-24 protocol
@@ -51,48 +52,51 @@ enum rc_type {
 	RC_TYPE_NECX		= 10,
 	RC_TYPE_NEC32		= 11,
 	RC_TYPE_SANYO		= 12,
-	RC_TYPE_MCE_KBD		= 13,
-	RC_TYPE_RC6_0		= 14,
-	RC_TYPE_RC6_6A_20	= 15,
-	RC_TYPE_RC6_6A_24	= 16,
-	RC_TYPE_RC6_6A_32	= 17,
-	RC_TYPE_RC6_MCE		= 18,
-	RC_TYPE_SHARP		= 19,
-	RC_TYPE_XMP		= 20,
-	RC_TYPE_CEC		= 21,
+	RC_TYPE_MCIR2_KBD	= 13,
+	RC_TYPE_MCIR2_MSE	= 14,
+	RC_TYPE_RC6_0		= 15,
+	RC_TYPE_RC6_6A_20	= 16,
+	RC_TYPE_RC6_6A_24	= 17,
+	RC_TYPE_RC6_6A_32	= 18,
+	RC_TYPE_RC6_MCE		= 19,
+	RC_TYPE_SHARP		= 20,
+	RC_TYPE_XMP		= 21,
+	RC_TYPE_CEC		= 22,
 };
 
 #define RC_BIT_NONE		0ULL
-#define RC_BIT_UNKNOWN		(1ULL << RC_TYPE_UNKNOWN)
-#define RC_BIT_OTHER		(1ULL << RC_TYPE_OTHER)
-#define RC_BIT_RC5		(1ULL << RC_TYPE_RC5)
-#define RC_BIT_RC5X_20		(1ULL << RC_TYPE_RC5X_20)
-#define RC_BIT_RC5_SZ		(1ULL << RC_TYPE_RC5_SZ)
-#define RC_BIT_JVC		(1ULL << RC_TYPE_JVC)
-#define RC_BIT_SONY12		(1ULL << RC_TYPE_SONY12)
-#define RC_BIT_SONY15		(1ULL << RC_TYPE_SONY15)
-#define RC_BIT_SONY20		(1ULL << RC_TYPE_SONY20)
-#define RC_BIT_NEC		(1ULL << RC_TYPE_NEC)
-#define RC_BIT_NECX		(1ULL << RC_TYPE_NECX)
-#define RC_BIT_NEC32		(1ULL << RC_TYPE_NEC32)
-#define RC_BIT_SANYO		(1ULL << RC_TYPE_SANYO)
-#define RC_BIT_MCE_KBD		(1ULL << RC_TYPE_MCE_KBD)
-#define RC_BIT_RC6_0		(1ULL << RC_TYPE_RC6_0)
-#define RC_BIT_RC6_6A_20	(1ULL << RC_TYPE_RC6_6A_20)
-#define RC_BIT_RC6_6A_24	(1ULL << RC_TYPE_RC6_6A_24)
-#define RC_BIT_RC6_6A_32	(1ULL << RC_TYPE_RC6_6A_32)
-#define RC_BIT_RC6_MCE		(1ULL << RC_TYPE_RC6_MCE)
-#define RC_BIT_SHARP		(1ULL << RC_TYPE_SHARP)
-#define RC_BIT_XMP		(1ULL << RC_TYPE_XMP)
-#define RC_BIT_CEC		(1ULL << RC_TYPE_CEC)
+#define RC_BIT_UNKNOWN		BIT_ULL(RC_TYPE_UNKNOWN)
+#define RC_BIT_OTHER		BIT_ULL(RC_TYPE_OTHER)
+#define RC_BIT_RC5		BIT_ULL(RC_TYPE_RC5)
+#define RC_BIT_RC5X_20		BIT_ULL(RC_TYPE_RC5X_20)
+#define RC_BIT_RC5_SZ		BIT_ULL(RC_TYPE_RC5_SZ)
+#define RC_BIT_JVC		BIT_ULL(RC_TYPE_JVC)
+#define RC_BIT_SONY12		BIT_ULL(RC_TYPE_SONY12)
+#define RC_BIT_SONY15		BIT_ULL(RC_TYPE_SONY15)
+#define RC_BIT_SONY20		BIT_ULL(RC_TYPE_SONY20)
+#define RC_BIT_NEC		BIT_ULL(RC_TYPE_NEC)
+#define RC_BIT_NECX		BIT_ULL(RC_TYPE_NECX)
+#define RC_BIT_NEC32		BIT_ULL(RC_TYPE_NEC32)
+#define RC_BIT_SANYO		BIT_ULL(RC_TYPE_SANYO)
+#define RC_BIT_MCIR2_KBD	BIT_ULL(RC_TYPE_MCIR2_KBD)
+#define RC_BIT_MCIR2_MSE	BIT_ULL(RC_TYPE_MCIR2_MSE)
+#define RC_BIT_RC6_0		BIT_ULL(RC_TYPE_RC6_0)
+#define RC_BIT_RC6_6A_20	BIT_ULL(RC_TYPE_RC6_6A_20)
+#define RC_BIT_RC6_6A_24	BIT_ULL(RC_TYPE_RC6_6A_24)
+#define RC_BIT_RC6_6A_32	BIT_ULL(RC_TYPE_RC6_6A_32)
+#define RC_BIT_RC6_MCE		BIT_ULL(RC_TYPE_RC6_MCE)
+#define RC_BIT_SHARP		BIT_ULL(RC_TYPE_SHARP)
+#define RC_BIT_XMP		BIT_ULL(RC_TYPE_XMP)
+#define RC_BIT_CEC		BIT_ULL(RC_TYPE_CEC)
 
 #define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | \
 			 RC_BIT_RC5 | RC_BIT_RC5X_20 | RC_BIT_RC5_SZ | \
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | RC_BIT_MCE_KBD | RC_BIT_RC6_0 | \
-			 RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_SANYO | \
+			 RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
+			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
 			 RC_BIT_XMP | RC_BIT_CEC)
 /* All rc protocols for which we have decoders */
@@ -101,8 +105,8 @@ enum rc_type {
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | RC_BIT_MCE_KBD | RC_BIT_RC6_0 | \
-			 RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
+			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
+			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | RC_BIT_SHARP | \
 			 RC_BIT_XMP)
 
@@ -111,7 +115,7 @@ enum rc_type {
 			 RC_BIT_JVC | \
 			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
 			 RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32 | \
-			 RC_BIT_SANYO | \
+			 RC_BIT_SANYO | RC_BIT_MCIR2_KBD | RC_BIT_MCIR2_MSE | \
 			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
 			 RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE | \
 			 RC_BIT_SHARP)
-- 
2.9.3
