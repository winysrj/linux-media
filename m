Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54833 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaCNXHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:00 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so2644167wes.21
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:06:59 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 4/9] rc: ir-nec-decoder: Add encode capability
Date: Fri, 14 Mar 2014 23:04:14 +0000
Message-Id: <1394838259-14260-5-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the capability to encode NEC scancodes as raw events. The
scancode_to_raw is pretty much taken from the img-ir NEC filter()
callback, and modulation uses the pulse distance helper added in a
previous commit.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
Changes in v2:
 - Update kerneldoc return values to reflect new API with -ENOBUFS
   return value when buffer is full and only a partial message was
   encoded.
---
 drivers/media/rc/ir-nec-decoder.c | 93 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 9de1791..813fa6b 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -203,9 +203,102 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
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
+	.msb_first	= 0,
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
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ *		-EINVAL if the scancode is ambiguous or invalid.
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

