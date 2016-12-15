Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:57927 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936175AbcLOMuT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:19 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v6 13/18] [media] rc: ir-sanyo-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:06 +0000
Message-Id: <20a1355946e47a85ac3de26eed329b9f71b11748.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode Sanyo scancodes as raw events.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-sanyo-decoder.c | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index b07d9ca..520bb77 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -176,9 +176,52 @@ static int ir_sanyo_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static const struct ir_raw_timings_pd ir_sanyo_timings = {
+	.header_pulse  = SANYO_HEADER_PULSE,
+	.header_space  = SANYO_HEADER_SPACE,
+	.bit_pulse     = SANYO_BIT_PULSE,
+	.bit_space[0]  = SANYO_BIT_0_SPACE,
+	.bit_space[1]  = SANYO_BIT_1_SPACE,
+	.trailer_pulse = SANYO_TRAILER_PULSE,
+	.trailer_space = SANYO_TRAILER_SPACE,
+	.msb_first     = 1,
+};
+
+/**
+ * ir_sanyo_encode() - Encode a scancode as a stream of raw events
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
+static int ir_sanyo_encode(enum rc_type protocol, u32 scancode,
+			   struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u64 raw;
+
+	raw = ((u64)(bitrev16(scancode >> 8) & 0xfff8) << (8 + 8 + 13 - 3)) |
+	      ((u64)(bitrev16(~scancode >> 8) & 0xfff8) << (8 + 8 +  0 - 3)) |
+	      ((bitrev8(scancode) & 0xff) << 8) |
+	      (bitrev8(~scancode) & 0xff);
+
+	ret = ir_raw_gen_pd(&e, max, &ir_sanyo_timings, SANYO_NBITS, raw);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler sanyo_handler = {
 	.protocols	= RC_BIT_SANYO,
 	.decode		= ir_sanyo_decode,
+	.encode		= ir_sanyo_encode,
 };
 
 static int __init ir_sanyo_decode_init(void)
-- 
2.9.3

