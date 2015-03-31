Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35587 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbCaRtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:49:02 -0400
Received: by lbdc10 with SMTP id c10so18198284lbd.2
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:49:00 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 4/7] rc: ir-rc6-decoder: Add encode capability
Date: Tue, 31 Mar 2015 20:48:09 +0300
Message-Id: <1427824092-23163-5-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode RC-6 and RC-6A scancodes as raw events.
The protocol is chosen based on the specified protocol mask, and
whether all the required bits are set in the scancode mask, and none of
the unused bits are set in the scancode data.

The Manchester modulation helper is used several times with various
timings so that RC-6 header preamble, the header, header trailing bit
and the data itself can be modulated correctly.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Cc: James Hogan <james@albanarts.com>
Cc: David Härdeman <david@hardeman.nu>
---

Notes:
    Changes in v3:
     - New patch

 drivers/media/rc/ir-rc6-decoder.c | 122 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index d16bc67..f9c70ba 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -291,11 +291,133 @@ out:
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
+ * @protocols:	allowed protocols
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
+static int ir_rc6_encode(u64 protocols,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+
+	if (protocols & RC_BIT_RC6_0 &&
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
+	} else if (protocols & (RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
+				RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE) &&
+		   !ir_rc6_validate_filter(scancode, 0x8fffffff)) {
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
2.0.5

