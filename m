Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:52568 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbbGTTQs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 15:16:48 -0400
Subject: [PATCH 4/7] [PATCH FIXES] Revert "[media] rc: ir-rc6-decoder: Add
 encode capability"
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Mon, 20 Jul 2015 21:16:46 +0200
Message-ID: <20150720191646.24633.3638.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
References: <20150720191238.24633.85293.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit cf257e288ad3a134d4bb809c542a3ae6c87ddfa3.

The current code is not mature enough, the API should allow a single
protocol to be specified. Also, the current code contains heuristics
that will depend on module load order.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-rc6-decoder.c |  122 -------------------------------------
 1 file changed, 122 deletions(-)

diff --git a/drivers/media/rc/ir-rc6-decoder.c b/drivers/media/rc/ir-rc6-decoder.c
index f9c70ba..d16bc67 100644
--- a/drivers/media/rc/ir-rc6-decoder.c
+++ b/drivers/media/rc/ir-rc6-decoder.c
@@ -291,133 +291,11 @@ out:
 	return -EINVAL;
 }
 
-static struct ir_raw_timings_manchester ir_rc6_timings[4] = {
-	{
-		.leader			= RC6_PREFIX_PULSE,
-		.pulse_space_start	= 0,
-		.clock			= RC6_UNIT,
-		.invert			= 1,
-		.trailer_space		= RC6_PREFIX_SPACE,
-	},
-	{
-		.clock			= RC6_UNIT,
-		.invert			= 1,
-	},
-	{
-		.clock			= RC6_UNIT * 2,
-		.invert			= 1,
-	},
-	{
-		.clock			= RC6_UNIT,
-		.invert			= 1,
-		.trailer_space		= RC6_SUFFIX_SPACE,
-	},
-};
-
-static int ir_rc6_validate_filter(const struct rc_scancode_filter *scancode,
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
- * ir_rc6_encode() - Encode a scancode as a stream of raw events
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
-static int ir_rc6_encode(u64 protocols,
-			 const struct rc_scancode_filter *scancode,
-			 struct ir_raw_event *events, unsigned int max)
-{
-	int ret;
-	struct ir_raw_event *e = events;
-
-	if (protocols & RC_BIT_RC6_0 &&
-	    !ir_rc6_validate_filter(scancode, 0xffff)) {
-
-		/* Modulate the preamble */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
-		if (ret < 0)
-			return ret;
-
-		/* Modulate the header (Start Bit & Mode-0) */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[1],
-					    RC6_HEADER_NBITS, (1 << 3));
-		if (ret < 0)
-			return ret;
-
-		/* Modulate Trailer Bit */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[2], 1, 0);
-		if (ret < 0)
-			return ret;
-
-		/* Modulate rest of the data */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[3], RC6_0_NBITS,
-					    scancode->data);
-		if (ret < 0)
-			return ret;
-
-	} else if (protocols & (RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 |
-				RC_BIT_RC6_6A_32 | RC_BIT_RC6_MCE) &&
-		   !ir_rc6_validate_filter(scancode, 0x8fffffff)) {
-
-		/* Modulate the preamble */
-		ret = ir_raw_gen_manchester(&e, max, &ir_rc6_timings[0], 0, 0);
-		if (ret < 0)
-			return ret;
-
-		/* Modulate the header (Start Bit & Header-version 6 */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[1],
-					    RC6_HEADER_NBITS, (1 << 3 | 6));
-		if (ret < 0)
-			return ret;
-
-		/* Modulate Trailer Bit */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[2], 1, 0);
-		if (ret < 0)
-			return ret;
-
-		/* Modulate rest of the data */
-		ret = ir_raw_gen_manchester(&e, max - (e - events),
-					    &ir_rc6_timings[3],
-					    fls(scancode->mask),
-					    scancode->data);
-		if (ret < 0)
-			return ret;
-
-	} else {
-		return -EINVAL;
-	}
-
-	return e - events;
-}
-
 static struct ir_raw_handler rc6_handler = {
 	.protocols	= RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 |
 			  RC_BIT_RC6_6A_24 | RC_BIT_RC6_6A_32 |
 			  RC_BIT_RC6_MCE,
 	.decode		= ir_rc6_decode,
-	.encode		= ir_rc6_encode,
 };
 
 static int __init ir_rc6_decode_init(void)

