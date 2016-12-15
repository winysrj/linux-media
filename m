Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:38623 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936175AbcLOMuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:50:14 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v6 09/18] [media] rc: ir-rc5-decoder: Add encode capability
Date: Thu, 15 Dec 2016 12:50:02 +0000
Message-Id: <804885764d4f3835bd880d9d8d81ab8eb64eb72a.1481805635.git.sean@mess.org>
In-Reply-To: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
References: <041be1eef913d5653b7c74ee398cf00063116d67.1481805635.git.sean@mess.org>
In-Reply-To: <cover.1481805635.git.sean@mess.org>
References: <cover.1481805635.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add the capability to encode RC-5, RC-5X and RC-5-SZ scancodes as raw
events.

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
 drivers/media/rc/ir-rc5-decoder.c | 97 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index a95477c..e2e9567 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -181,9 +181,106 @@ static int ir_rc5_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+static const struct ir_raw_timings_manchester ir_rc5_timings = {
+	.leader			= RC5_UNIT,
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
+	.trailer_space		= RC5_UNIT * 10,
+};
+
+static const struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
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
+static const struct ir_raw_timings_manchester ir_rc5_sz_timings = {
+	.leader				= RC5_UNIT,
+	.pulse_space_start		= 0,
+	.clock				= RC5_UNIT,
+	.trailer_space			= RC5_UNIT * 10,
+};
+
+/**
+ * ir_rc5_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocol:	protocol variant to encode
+ * @scancode:	scancode to encode
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid.
+ */
+static int ir_rc5_encode(enum rc_type protocol, u32 scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+	unsigned int data, xdata, command, commandx, system, pre_space_data;
+
+	/* Detect protocol and convert scancode to raw data */
+	if (protocol == RC_TYPE_RC5) {
+		/* decode scancode */
+		command  = (scancode & 0x003f) >> 0;
+		commandx = (scancode & 0x0040) >> 6;
+		system   = (scancode & 0x1f00) >> 8;
+		/* encode data */
+		data = !commandx << 12 | system << 6 | command;
+
+		/* Modulate the data */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_timings,
+					    RC5_NBITS, data);
+		if (ret < 0)
+			return ret;
+	} else if (protocol == RC_TYPE_RC5X) {
+		/* decode scancode */
+		xdata    = (scancode & 0x00003f) >> 0;
+		command  = (scancode & 0x003f00) >> 8;
+		commandx = !(scancode & 0x004000);
+		system   = (scancode & 0x1f0000) >> 16;
+
+		/* encode data */
+		data = commandx << 18 | system << 12 | command << 6 | xdata;
+
+		/* Modulate the data */
+		pre_space_data = data >> (RC5X_NBITS - CHECK_RC5X_NBITS);
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5x_timings[0],
+					    CHECK_RC5X_NBITS, pre_space_data);
+		if (ret < 0)
+			return ret;
+		ret = ir_raw_gen_manchester(&e, max - (e - events),
+					    &ir_rc5x_timings[1],
+					    RC5X_NBITS - CHECK_RC5X_NBITS,
+					    data);
+		if (ret < 0)
+			return ret;
+	} else if (protocol == RC_TYPE_RC5_SZ) {
+		/* RC5-SZ scancode is raw enough for Manchester as it is */
+		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
+					    RC5_SZ_NBITS, scancode & 0x2fff);
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

