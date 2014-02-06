Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45040 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbaBFUAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 15:00:01 -0500
Received: by mail-wi0-f180.google.com with SMTP id hm4so183838wib.13
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 12:00:00 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 3/4] rc: ir-nec-decoder: add encode capability
Date: Thu,  6 Feb 2014 19:59:22 +0000
Message-Id: <1391716763-2689-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode NEC scancodes as raw events. The
scancode_to_raw is pretty much taken from the img-ir NEC filter()
callback, and modulation uses the pulse distance helper added in a
previous commit.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/media/rc/ir-nec-decoder.c | 91 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 1bab7ea..5083ed6 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -203,9 +203,100 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+/**
+ * ir_nec_scancode_to_raw() - encode an NEC scancode ready for modulation.
+ * @in:		scancode filter describing a single NEC scancode.
+ * @raw:	raw data to be modulated.
+ */
+static int ir_nec_scancode_to_raw(const struct rc_scancode_filter *in,
+				  u32 *raw)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+
+	data = in->data & 0xff;
+
+	if ((in->data | in->mask) & 0xff000000) {
+		/* 32-bit NEC (used by Apple and TiVo remotes) */
+		/* scan encoding: aaAAddDD */
+		if (in->mask != 0xffffffff)
+			return -EINVAL;
+		addr_inv   = (in->data >> 24) & 0xff;
+		addr       = (in->data >> 16) & 0xff;
+		data_inv   = (in->data >>  8) & 0xff;
+	} else if ((in->data | in->mask) & 0x00ff0000) {
+		/* Extended NEC */
+		/* scan encoding AAaaDD */
+		if (in->mask != 0x00ffffff)
+			return -EINVAL;
+		addr       = (in->data >> 16) & 0xff;
+		addr_inv   = (in->data >>  8) & 0xff;
+		data_inv   = data ^ 0xff;
+	} else {
+		/* Normal NEC */
+		/* scan encoding: AADD */
+		if (in->mask != 0x0000ffff)
+			return -EINVAL;
+		addr       = (in->data >>  8) & 0xff;
+		addr_inv   = addr ^ 0xff;
+		data_inv   = data ^ 0xff;
+	}
+
+	/* raw encoding: ddDDaaAA */
+	*raw = data_inv << 24 |
+	       data     << 16 |
+	       addr_inv <<  8 |
+	       addr;
+	return 0;
+}
+
+static struct ir_raw_timings_pd ir_nec_timings = {
+	.header_pulse	= NEC_HEADER_PULSE,
+	.header_space	= NEC_HEADER_SPACE,
+	.bit_pulse	= NEC_BIT_PULSE,
+	.bit_space[0]	= NEC_BIT_0_SPACE,
+	.bit_space[1]	= NEC_BIT_1_SPACE,
+	.trailer_pulse	= NEC_TRAILER_PULSE,
+	.trailer_space	= NEC_TRAILER_SPACE,
+	.msb_first = 0,
+};
+
+/**
+ * ir_nec_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocols:	allowed protocols
+ * @scancode:	scancode filter describing scancode (helps distinguish between
+ *		protocol subtypes when scancode is ambiguous)
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * This function returns -EINVAL if the scancode filter is invalid or matches
+ * multiple scancodes.
+ */
+static int ir_nec_encode(u64 protocols,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u32 raw;
+
+	/* Convert a NEC scancode to raw NEC data */
+	ret = ir_nec_scancode_to_raw(scancode, &raw);
+	if (ret < 0)
+		return ret;
+
+	/* Modulate the raw data using a pulse distance modulation */
+	ret = ir_raw_gen_pd(&e, max, &ir_nec_timings, NEC_NBITS, raw);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler nec_handler = {
 	.protocols	= RC_BIT_NEC,
 	.decode		= ir_nec_decode,
+	.encode		= ir_nec_encode,
 };
 
 static int __init ir_nec_decode_init(void)
-- 
1.8.3.2

