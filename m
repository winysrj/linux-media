Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33912 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbbCaRs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:48:59 -0400
Received: by lboc7 with SMTP id c7so18251371lbo.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:48:58 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 3/7] rc: ir-rc5-decoder: Add encode capability
Date: Tue, 31 Mar 2015 20:48:08 +0300
Message-Id: <1427824092-23163-4-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
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
Cc: David Härdeman <david@hardeman.nu>
---

Notes:
    Changes in v3:
     - Ported to apply with latest media-tree
     - Merged with an encoder for rc-5-sz variant
    
    I've mostly reverse engineered RC-5X from the decoder, but it seems to
    work in loopback. Here's some debug output:
    
    RC-5X:
    evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 65793
    evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
     _   __   _   _   _   _    _      _   _   _   _   _    __   _   _   _   _    _
    | | |  | | | | | | | | |  | |    | | | | | | | | | |  |  | | | | | | | | |  | |
              |
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

 drivers/media/rc/ir-rc5-decoder.c | 116 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 84fa6e9..8939ebd 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -184,9 +184,125 @@ out:
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
+	} else if (protocols & RC_BIT_RC5_SZ &&
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
2.0.5

