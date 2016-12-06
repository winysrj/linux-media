Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48383 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752028AbcLFKT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:28 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 09/13] [media] rc: ir-rc6-decoder: Add encode capability
Date: Tue,  6 Dec 2016 10:19:17 +0000
Message-Id: <a67eaa7f070ed6cb6c8c6e71de0f02a744636881.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

Add the capability to encode RC-6 and RC-6A scancodes as raw events.
The protocol is chosen based on the specified protocol mask, and
whether all the required bits are set in the scancode mask, and none of
the unused bits are set in the scancode data.

The Manchester modulation helper is used several times with various
timings so that RC-6 header preamble, the header, header trailing bit
and the data itself can be modulated correctly.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: James Hogan <james@albanarts.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc6-decoder.c | 120 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index 5cc54c9..3667ca2 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -286,11 +286,131 @@ static int ir_rc6_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc6_timings[4] = {
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
+static int ir_rc6_validate_filter(const struct rc_scancode_filter *scancode,
+				  unsigned int important_bits)
+{
+	/* all important bits of scancode should be set in mask */
+	if (~scancode->mask & important_bits)
+		return -EINVAL;
+	/* extra bits in mask should be zero in data */
+	if (scancode->mask & scancode->data & ~important_bits)
+		return -EINVAL;
+	return 0;
+}
+
+/**
+ * ir_rc6_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:	protocol to encode
+ * @scancode:	scancode filter describing scancode (helps distinguish between
+ *		protocol subtypes when scancode is ambiguous)
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid.
+ */
+static int ir_rc6_encode(enum rc_type protocol,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+
+	if (protocol == RC_TYPE_RC6_0 &&
+	    !ir_rc6_validate_filter(scancode, 0xffff)) {
+
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
+					    scancode->data);
+		if (ret < 0)
+			return ret;
+
+	} else if (!ir_rc6_validate_filter(scancode, 0x8fffffff)) {
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
+					    fls(scancode->mask),
+					    scancode->data);
+		if (ret < 0)
+			return ret;
+
+	} else {
+		return -EINVAL;
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

