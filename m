Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39273 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936195AbcLOMuP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:15 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v6 14/18] [media] rc: ir-sharp-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:07 +0000
Message-Id: <add976fad4d4ff1ad612d561a6a124a1e61e3d8b.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode Sharp scancodes as raw events.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-sharp-decoder.c | 50 +++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/media/rc/ir-sharp-decoder.c b/drivers/media/rc/ir-sharp-decoder.c
index 317677f..b47e89e 100644
--- a/drivers/media/rc/ir-sharp-decoder.c
+++ b/drivers/media/rc/ir-sharp-decoder.c
@@ -173,9 +173,59 @@ static int ir_sharp_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static const struct ir_raw_timings_pd ir_sharp_timings = {
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

