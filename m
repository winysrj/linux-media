Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49621 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932532AbcLLVN6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:58 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v5 14/18] [media] rc: ir-sharp-decoder: Add encode capability
Date: Mon, 12 Dec 2016 21:13:50 +0000
Message-Id: <fcf27e766db3af7dab1b0068cae4508d528b2d79.1481575826.git.sean@mess.org>
In-Reply-To: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
References: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode Sharp scancodes as raw events.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-sharp-decoder.c | 50 +++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 317677f..d37af7c 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -173,9 +173,59 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_pd ir_sharp_timings = {
+	.header_pulse  = 0,
+	.header_space  = 0,
+	.bit_pulse     = SHARP_BIT_PULSE,
+	.bit_space[0]  = SHARP_BIT_0_PERIOD,
+	.bit_space[1]  = SHARP_BIT_1_PERIOD,
+	.trailer_pulse = SHARP_BIT_PULSE,
+	.trailer_space = SHARP_ECHO_SPACE,
+	.msb_first     = 1,
+};
+
+/**
+ * ir_sharp_encode() - Encode a scancode as a stream of raw events
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
+static int ir_sharp_encode(enum rc_type protocol, u32 scancode,
+			   struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u32 raw;
+
+	raw = (((bitrev8(scancode >> 8) >> 3) << 8) & 0x1f00) |
+		bitrev8(scancode);
+	ret = ir_raw_gen_pd(&e, max, &ir_sharp_timings, SHARP_NBITS,
+			    (raw << 2) | 2);
+	if (ret < 0)
+		return ret;
+
+	max -= ret;
+
+	raw = (((bitrev8(scancode >> 8) >> 3) << 8) & 0x1f00) |
+		bitrev8(~scancode);
+	ret = ir_raw_gen_pd(&e, max, &ir_sharp_timings, SHARP_NBITS,
+			    (raw << 2) | 1);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler sharp_handler = {
 	.protocols	= RC_BIT_SHARP,
 	.decode		= ir_sharp_decode,
+	.encode		= ir_sharp_encode,
 };
 
 static int __init ir_sharp_decode_init(void)
-- 
2.9.3

