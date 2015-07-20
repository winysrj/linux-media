Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52570 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbbGTTQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:53 -0400
Subject: [PATCH 5/7] [PATCH FIXES] Revert "[media] rc: ir-rc5-decoder: Add
 encode capability"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:51 +0200
Message-ID: <20150720191651.24633.63217.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit a0466f15b4654cf1ac9e387d7c1a401eff494b4f.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc5-decoder.c |  116 -------------------------------------
 1 file changed, 116 deletions(-)

diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 8939ebd..84fa6e9 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -184,125 +184,9 @@ out:
 	return -EINVAL;
 }
 
-static struct ir_raw_timings_manchester ir_rc5_timings = {
-	.leader			= RC5_UNIT,
-	.pulse_space_start	= 0,
-	.clock			= RC5_UNIT,
-	.trailer_space		= RC5_UNIT * 10,
-};
-
-static struct ir_raw_timings_manchester ir_rc5x_timings[2] = {
-	{
-		.leader			= RC5_UNIT,
-		.pulse_space_start	= 0,
-		.clock			= RC5_UNIT,
-		.trailer_space		= RC5X_SPACE,
-	},
-	{
-		.clock			= RC5_UNIT,
-		.trailer_space		= RC5_UNIT * 10,
-	},
-};
-
-static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
-	.leader				= RC5_UNIT,
-	.pulse_space_start		= 0,
-	.clock				= RC5_UNIT,
-	.trailer_space			= RC5_UNIT * 10,
-};
-
-static int ir_rc5_validate_filter(const struct rc_scancode_filter *scancode,
-				  unsigned int important_bits)
-{
-	/* all important bits of scancode should be set in mask */
-	if (~scancode->mask & important_bits)
-		return -EINVAL;
-	/* extra bits in mask should be zero in data */
-	if (scancode->mask & scancode->data & ~important_bits)
-		return -EINVAL;
-	return 0;
-}
-
-/**
- * ir_rc5_encode() - Encode a scancode as a stream of raw events
- *
- * @protocols:	allowed protocols
- * @scancode:	scancode filter describing scancode (helps distinguish between
- *		protocol subtypes when scancode is ambiguous)
- * @events:	array of raw ir events to write into
- * @max:	maximum size of @events
- *
- * Returns:	The number of events written.
- *		-ENOBUFS if there isn't enough space in the array to fit the
- *		encoding. In this case all @max events will have been written.
- *		-EINVAL if the scancode is ambiguous or invalid.
- */
-static int ir_rc5_encode(u64 protocols,
-			 const struct rc_scancode_filter *scancode,
-			 struct ir_raw_event *events, unsigned int max)
-{
-	int ret;
-	struct ir_raw_event *e = events;
-	unsigned int data, xdata, command, commandx, system;
-
-	/* Detect protocol and convert scancode to raw data */
-	if (protocols & RC_BIT_RC5 &&
-	    !ir_rc5_validate_filter(scancode, 0x1f7f)) {
-		/* decode scancode */
-		command  = (scancode->data & 0x003f) >> 0;
-		commandx = (scancode->data & 0x0040) >> 6;
-		system   = (scancode->data & 0x1f00) >> 8;
-		/* encode data */
-		data = !commandx << 12 | system << 6 | command;
-
-		/* Modulate the data */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_timings, RC5_NBITS,
-					    data);
-		if (ret < 0)
-			return ret;
-	} else if (protocols & RC_BIT_RC5X &&
-		   !ir_rc5_validate_filter(scancode, 0x1f7f3f)) {
-		/* decode scancode */
-		xdata    = (scancode->data & 0x00003f) >> 0;
-		command  = (scancode->data & 0x003f00) >> 8;
-		commandx = (scancode->data & 0x004000) >> 14;
-		system   = (scancode->data & 0x1f0000) >> 16;
-		/* commandx and system overlap, bits must match when encoded */
-		if (commandx == (system & 0x1))
-			return -EINVAL;
-		/* encode data */
-		data = 1 << 18 | system << 12 | command << 6 | xdata;
-
-		/* Modulate the data */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc5x_timings[0],
-					CHECK_RC5X_NBITS,
-					data >> (RC5X_NBITS-CHECK_RC5X_NBITS));
-		if (ret < 0)
-			return ret;
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					&ir_rc5x_timings[1],
-					RC5X_NBITS - CHECK_RC5X_NBITS,
-					data);
-		if (ret < 0)
-			return ret;
-	} else if (protocols & RC_BIT_RC5_SZ &&
-		   !ir_rc5_validate_filter(scancode, 0x2fff)) {
-		/* RC5-SZ scancode is raw enough for Manchester as it is */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings,
-					RC5_SZ_NBITS, scancode->data & 0x2fff);
-		if (ret < 0)
-			return ret;
-	} else {
-		return -EINVAL;
-	}
-
-	return e - events;
-}
-
 static struct ir_raw_handler rc5_handler = {
 	.protocols	= RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_decode,
-	.encode		= ir_rc5_encode,
 };
 
 static int __init ir_rc5_decode_init(void)

