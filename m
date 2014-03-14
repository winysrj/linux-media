Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:41205 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbaCNXHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:02 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so2715081wes.30
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:07:00 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 5/9] rc: ir-rc5-decoder: Add encode capability
Date: Fri, 14 Mar 2014 23:04:15 +0000
Message-Id: <1394838259-14260-6-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode RC-5 and RC-5X scancodes as raw events. The
protocol is chosen based on the specified protocol mask, and whether all
the required bits are set in the scancode mask, and none of the unused
bits are set in the scancode data. For example a scancode filter with
bit 16 set in both data and mask is unambiguously RC-5X.

The Manchester modulation helper is used, and for RC-5X it is used twice
with two sets of timings, the first with a short trailer space for the
space in the middle, and the second with no leader so that it can
continue the space.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
I've mostly reverse engineered RC-5X from the decoder, but it seems to
work in loopback. Here's some debug output:

RC-5X:
evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 65793
evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
 _   __   _   _   _   _    _      _   _   _   _   _    __   _   _   _   _    _
| | |  | | | | | | | | |  | |    | | | | | | | | | |  |  | | | | | | | | |  | |          |
| |_|  |_| |_| |_| |_| |__| |____| |_| |_| |_| |_| |__|  |_| |_| |_| |_| |__| |__________|
      1                  1      3                    1  1                  1            8
 8 8  7 8 8 8 8 8 8 8 8  7 8    5 8 8 8 8 8 8 8 8 8  7  7 8 8 8 8 8 8 8 8  7 8          8
 8 8  7 8 8 8 8 8 8 8 8  7 8    5 8 8 8 8 8 8 8 8 8  7  7 8 8 8 8 8 8 8 8  7 8          8
 9 9  8 9 9 9 9 9 9 9 9  8 9    6 9 9 9 9 9 9 9 9 9  8  8 9 9 9 9 9 9 9 9  8 9          9
   1  0   0   0   0   0  1      X 0   0   0   0   0  1  0   0   0   0   0  1            E rc-5

RC-5:
evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 257
evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
 _   __   _   _   _   _    __   _   _   _   _    _
| | |  | | | | | | | | |  |  | | | | | | | | |  | |          |
| |_|  |_| |_| |_| |_| |__|  |_| |_| |_| |_| |__| |__________|
      1                  1  1                  1            8
 8 8  7 8 8 8 8 8 8 8 8  7  7 8 8 8 8 8 8 8 8  7 8          8
 8 8  7 8 8 8 8 8 8 8 8  7  7 8 8 8 8 8 8 8 8  7 8          8
 9 9  8 9 9 9 9 9 9 9 9  8  8 9 9 9 9 9 9 9 9  8 9          9
   1  0   0   0   0   0  1  0   0   0   0   0  1            E rc-5
---
 drivers/media/rc/ir-rc5-decoder.c | 103 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 4295d9b..2eed2fe 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -171,9 +171,112 @@ out:
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc5_timings = {
+	.leader			= 1,
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
+	.trailer_space		= RC5_UNIT * 10,
+};
+
+static struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
+	{
+		.leader			= 1,
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
+static int ir_rc5_encode(u64 protocols,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+	unsigned int data, xdata, command, commandx, system;
+
+	/* Detect protocol and convert scancode to raw data */
+	if (protocols & RC_BIT_RC5 &&
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
+	} else if (protocols & RC_BIT_RC5X &&
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
+
+	} else {
+		return -EINVAL;
+	}
+
+	return e - events;
+}
+
 static struct ir_raw_handler rc5_handler = {
 	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X,
 	.decode		= ir_rc5_decode,
+	.encode		= ir_rc5_encode,
 };
 
 static int __init ir_rc5_decode_init(void)
-- 
1.8.3.2

