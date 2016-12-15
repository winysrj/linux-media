Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40121 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755810AbcLOMuY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:24 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v6 12/18] [media] rc: ir-jvc-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:05 +0000
Message-Id: <978c660d3271cc30eb4276c889814acd4630769b.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode JVC scancodes as raw events.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-jvc-decoder.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/rc/ir-jvc-decoder.c b/drivers/media/rc/ir-jvc-decoder.c
index 182402f..674bf15 100644
--- a/drivers/media/rc/ir-jvc-decoder.c
+++ b/drivers/media/rc/ir-jvc-decoder.c
@@ -170,9 +170,48 @@ static int ir_jvc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static const struct ir_raw_timings_pd ir_jvc_timings = {
+	.header_pulse  = JVC_HEADER_PULSE,
+	.header_space  = JVC_HEADER_SPACE,
+	.bit_pulse     = JVC_BIT_PULSE,
+	.bit_space[0]  = JVC_BIT_0_SPACE,
+	.bit_space[1]  = JVC_BIT_1_SPACE,
+	.trailer_pulse = JVC_TRAILER_PULSE,
+	.trailer_space = JVC_TRAILER_SPACE,
+	.msb_first     = 1,
+};
+
+/**
+ * ir_jvc_encode() - Encode a scancode as a stream of raw events
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
+static int ir_jvc_encode(enum rc_type protocol, u32 scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u32 raw = (bitrev8((scancode >> 8) & 0xff) << 8) |
+		  (bitrev8((scancode >> 0) & 0xff) << 0);
+
+	ret = ir_raw_gen_pd(&e, max, &ir_jvc_timings, JVC_NBITS, raw);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler jvc_handler = {
 	.protocols	= RC_BIT_JVC,
 	.decode		= ir_jvc_decode,
+	.encode		= ir_jvc_encode,
 };
 
 static int __init ir_jvc_decode_init(void)
-- 
2.9.3

