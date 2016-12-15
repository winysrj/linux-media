Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:50375 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936198AbcLOMuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:15 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v6 15/18] [media] rc: ir-sony-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:08 +0000
Message-Id: <21675c2da0a69eae820f3dde661e2fc8fcae3a32.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode Sony scancodes as raw events. Sony uses
pulse length rather than pulse distance.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-sony-decoder.c | 48 ++++++++++++++++++++++++++++
 drivers/media/rc/rc-core-priv.h    | 20 ++++++++++++
 drivers/media/rc/rc-ir-raw.c       | 64 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 132 insertions(+)

diff --git a/drivers/media/rc/ir-sony-decoder.c b/drivers/media/rc/ir-sony-decoder.c
index baa972c..355fa81 100644
--- a/drivers/media/rc/ir-sony-decoder.c
+++ b/drivers/media/rc/ir-sony-decoder.c
@@ -169,9 +169,57 @@ static int ir_sony_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return 0;
 }
 
+static const struct ir_raw_timings_pl ir_sony_timings = {
+	.header_pulse  = SONY_HEADER_PULSE,
+	.bit_space     = SONY_BIT_SPACE,
+	.bit_pulse[0]  = SONY_BIT_0_PULSE,
+	.bit_pulse[1]  = SONY_BIT_1_PULSE,
+	.trailer_space = SONY_TRAILER_SPACE + SONY_BIT_SPACE,
+	.msb_first     = 0,
+};
+
+/**
+ * ir_sony_encode() - Encode a scancode as a stream of raw events
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
+static int ir_sony_encode(enum rc_type protocol, u32 scancode,
+			  struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	u32 raw, len;
+	int ret;
+
+	if (protocol == RC_TYPE_SONY12) {
+		raw = (scancode & 0x7f) | ((scancode & 0x1f0000) >> 9);
+		len = 12;
+	} else if (protocol == RC_TYPE_SONY15) {
+		raw = (scancode & 0x7f) | ((scancode & 0xff0000) >> 9);
+		len = 15;
+	} else {
+		raw = (scancode & 0x7f) | ((scancode & 0x1f0000) >> 9) |
+		       ((scancode & 0xff00) << 4);
+		len = 20;
+	}
+
+	ret = ir_raw_gen_pl(&e, max, &ir_sony_timings, len, raw);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler sony_handler = {
 	.protocols	= RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20,
 	.decode		= ir_sony_decode,
+	.encode		= ir_sony_encode,
 };
 
 static int __init ir_sony_decode_init(void)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 630f33c..0378aa9 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -241,6 +241,26 @@ int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
 		  const struct ir_raw_timings_pd *timings,
 		  unsigned int n, u64 data);
 
+/**
+ * struct ir_raw_timings_pl - pulse-length modulation timings
+ * @header_pulse:	duration of header pulse in ns (0 for none)
+ * @bit_space:		duration of bit space in ns
+ * @bit_pulse:		duration of bit pulse (for logic 0 and 1) in ns
+ * @trailer_space:	duration of trailer space in ns
+ * @msb_first:		1 if most significant bit is sent first
+ */
+struct ir_raw_timings_pl {
+	unsigned int header_pulse;
+	unsigned int bit_space;
+	unsigned int bit_pulse[2];
+	unsigned int trailer_space;
+	unsigned int msb_first:1;
+};
+
+int ir_raw_gen_pl(struct ir_raw_event **ev, unsigned int max,
+		  const struct ir_raw_timings_pl *timings,
+		  unsigned int n, u64 data);
+
 /*
  * Routines from rc-raw.c to be used internally and by decoders
  */
diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 5ce8b45..5ee7db3 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -394,6 +394,70 @@ int ir_raw_gen_pd(struct ir_raw_event **ev, unsigned int max,
 EXPORT_SYMBOL(ir_raw_gen_pd);
 
 /**
+ * ir_raw_gen_pl() - Encode data to raw events with pulse-length modulation.
+ * @ev:		Pointer to pointer to next free event. *@ev is incremented for
+ *		each raw event filled.
+ * @max:	Maximum number of raw events to fill.
+ * @timings:	Pulse distance modulation timings.
+ * @n:		Number of bits of data.
+ * @data:	Data bits to encode.
+ *
+ * Encodes the @n least significant bits of @data using space-distance
+ * modulation with the timing characteristics described by @timings, writing up
+ * to @max raw IR events using the *@ev pointer.
+ *
+ * Returns:	0 on success.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		full encoded data. In this case all @max events will have been
+ *		written.
+ */
+int ir_raw_gen_pl(struct ir_raw_event **ev, unsigned int max,
+		  const struct ir_raw_timings_pl *timings,
+		  unsigned int n, u64 data)
+{
+	int i;
+	int ret = -ENOBUFS;
+	unsigned int pulse;
+
+	if (!max--)
+		return ret;
+
+	init_ir_raw_event_duration((*ev)++, 1, timings->header_pulse);
+
+	if (timings->msb_first) {
+		for (i = n - 1; i >= 0; --i) {
+			if (!max--)
+				return ret;
+			init_ir_raw_event_duration((*ev)++, 0,
+						   timings->bit_space);
+			if (!max--)
+				return ret;
+			pulse = timings->bit_pulse[(data >> i) & 1];
+			init_ir_raw_event_duration((*ev)++, 1, pulse);
+		}
+	} else {
+		for (i = 0; i < n; ++i, data >>= 1) {
+			if (!max--)
+				return ret;
+			init_ir_raw_event_duration((*ev)++, 0,
+						   timings->bit_space);
+			if (!max--)
+				return ret;
+			pulse = timings->bit_pulse[data & 1];
+			init_ir_raw_event_duration((*ev)++, 1, pulse);
+		}
+	}
+
+	if (!max--)
+		return ret;
+
+	init_ir_raw_event_duration((*ev)++, 0, timings->trailer_space);
+
+	return 0;
+}
+EXPORT_SYMBOL(ir_raw_gen_pl);
+
+/**
  * ir_raw_encode_scancode() - Encode a scancode as raw events
  *
  * @protocol:		protocol
-- 
2.9.3

