Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51131 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936229AbcLOMu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:28 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v6 10/18] [media] rc: ir-rc6-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:03 +0000
Message-Id: <ff1050b335470e99693e058476644eb96fa55c93.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

Add the capability to encode RC-6 and RC-6A scancodes as raw events.

The Manchester modulation helper is used several times with various
timings so that RC-6 header preamble, the header, header trailing bit
and the data itself can be modulated correctly.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: James Hogan <james@albanarts.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc6-decoder.c | 117 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 5cc54c9..6fe2268 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -286,11 +286,128 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static const struct ir_raw_timings_manchester ir_rc6_timings[4] = {
+	{
+		.leader			= RC6_PREFIX_PULSE,
+		.pulse_space_start	= 0,
+		.clock			= RC6_UNIT,
+		.invert			= 1,
+		.trailer_space		= RC6_PREFIX_SPACE,
+	},
+	{
+		.clock			= RC6_UNIT,
+		.invert			= 1,
+	},
+	{
+		.clock			= RC6_UNIT * 2,
+		.invert			= 1,
+	},
+	{
+		.clock			= RC6_UNIT,
+		.invert			= 1,
+		.trailer_space		= RC6_SUFFIX_SPACE,
+	},
+};
+
+/**
+ * ir_rc6_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:	protocol to encode
+ * @scancode:	scancode to encode
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid.
+ */
+static int ir_rc6_encode(enum rc_type protocol, u32 scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+
+	if (protocol == RC_TYPE_RC6_0) {
+		/* Modulate the preamble */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
+		if (ret < 0)
+			return ret;
+
+		/* Modulate the header (Start Bit & Mode-0) */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[1],
+					    RC6_HEADER_NBITS, (1 << 3));
+		if (ret < 0)
+			return ret;
+
+		/* Modulate Trailer Bit */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[2], 1, 0);
+		if (ret < 0)
+			return ret;
+
+		/* Modulate rest of the data */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[3], RC6_0_NBITS,
+					    scancode);
+		if (ret < 0)
+			return ret;
+
+	} else {
+		int bits;
+
+		switch (protocol) {
+		case RC_TYPE_RC6_MCE:
+		case RC_TYPE_RC6_6A_32:
+			bits = 32;
+			break;
+		case RC_TYPE_RC6_6A_24:
+			bits = 24;
+			break;
+		case RC_TYPE_RC6_6A_20:
+			bits = 20;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		/* Modulate the preamble */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
+		if (ret < 0)
+			return ret;
+
+		/* Modulate the header (Start Bit & Header-version 6 */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[1],
+					    RC6_HEADER_NBITS, (1 << 3 | 6));
+		if (ret < 0)
+			return ret;
+
+		/* Modulate Trailer Bit */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[2], 1, 0);
+		if (ret < 0)
+			return ret;
+
+		/* Modulate rest of the data */
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc6_timings[3],
+					    bits,
+					    scancode);
+		if (ret < 0)
+			return ret;
+	}
+
+	return e - events;
+}
+
 static struct ir_raw_handler rc6_handler = {
 	.protocols	= RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
 			  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
 			  RC_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
+	.encode		= ir_rc6_encode,
 };
 
 static int __init ir_rc6_decode_init(void)
-- 
2.9.3

