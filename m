Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:45979 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751723AbcLFKT1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:27 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 08/13] [media] rc: ir-rc5-decoder: Add encode capability
Date: Tue,  6 Dec 2016 10:19:16 +0000
Message-Id: <fa6f2a6113768d2d0db3e5ee97aff5e849170b2c.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add the capability to encode RC-5, RC-5X and RC-5-SZ scancodes as raw
events. The protocol is chosen based on the specified protocol mask,
and whether all the required bits are set in the scancode mask, and
none of the unused bits are set in the scancode data. For example a
scancode filter with bit 16 set in both data and mask is unambiguously
RC-5X.

The Manchester modulation helper is used, and for RC-5X it is used twice
with two sets of timings, the first with a short trailer space for the
space in the middle, and the second with no leader so that it can
continue the space.

The encoding in RC-5-SZ first inserts a pulse and then simply utilizes
the generic Manchester encoder available in rc-core.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc5-decoder.c | 116 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a0fd4e6..c405459 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -181,9 +181,125 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc5_timings = {
+	.leader			= RC5_UNIT,
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
+	.trailer_space		= RC5_UNIT * 10,
+};
+
+static struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
+	{
+		.leader			= RC5_UNIT,
+		.pulse_space_start	= 0,
+		.clock			= RC5_UNIT,
+		.trailer_space		= RC5X_SPACE,
+	},
+	{
+		.clock			= RC5_UNIT,
+		.trailer_space		= RC5_UNIT * 10,
+	},
+};
+
+static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
+	.leader				= RC5_UNIT,
+	.pulse_space_start		= 0,
+	.clock				= RC5_UNIT,
+	.trailer_space			= RC5_UNIT * 10,
+};
+
+static int ir_rc5_validate_filter(const struct rc_scancode_filter *scancode,
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
+ * ir_rc5_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:	protocol variant to encode
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
+static int ir_rc5_encode(enum rc_type protocol,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+	unsigned int data, xdata, command, commandx, system;
+
+	/* Detect protocol and convert scancode to raw data */
+	if (protocol == RC_TYPE_RC5 &&
+	    !ir_rc5_validate_filter(scancode, 0x1f7f)) {
+		/* decode scancode */
+		command  = (scancode->data & 0x003f) >> 0;
+		commandx = (scancode->data & 0x0040) >> 6;
+		system   = (scancode->data & 0x1f00) >> 8;
+		/* encode data */
+		data = !commandx << 12 | system << 6 | command;
+
+		/* Modulate the data */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_timings, RC5_NBITS,
+					    data);
+		if (ret < 0)
+			return ret;
+	} else if (protocol == RC_TYPE_RC5X &&
+		   !ir_rc5_validate_filter(scancode, 0x1f7f3f)) {
+		/* decode scancode */
+		xdata    = (scancode->data & 0x00003f) >> 0;
+		command  = (scancode->data & 0x003f00) >> 8;
+		commandx = (scancode->data & 0x004000) >> 14;
+		system   = (scancode->data & 0x1f0000) >> 16;
+		/* commandx and system overlap, bits must match when encoded */
+		if (commandx == (system & 0x1))
+			return -EINVAL;
+		/* encode data */
+		data = 1 << 18 | system << 12 | command << 6 | xdata;
+
+		/* Modulate the data */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5x_timings[0],
+					CHECK_RC5X_NBITS,
+					data >> (RC5X_NBITS-CHECK_RC5X_NBITS));
+		if (ret < 0)
+			return ret;
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					&ir_rc5x_timings[1],
+					RC5X_NBITS - CHECK_RC5X_NBITS,
+					data);
+		if (ret < 0)
+			return ret;
+	} else if (protocol == RC_TYPE_RC5_SZ &&
+		   !ir_rc5_validate_filter(scancode, 0x2fff)) {
+		/* RC5-SZ scancode is raw enough for Manchester as it is */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
+					RC5_SZ_NBITS, scancode->data & 0x2fff);
+		if (ret < 0)
+			return ret;
+	} else {
+		return -EINVAL;
+	}
+
+	return e - events;
+}
+
 static struct ir_raw_handler rc5_handler = {
 	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
+	.encode		= ir_rc5_encode,
 };
 
 static int __init ir_rc5_decode_init(void)
-- 
2.9.3

