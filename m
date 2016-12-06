Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56195 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752016AbcLFKT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:28 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 10/13] [media] rc: ir-nec-decoder: Add encode capability
Date: Tue,  6 Dec 2016 10:19:18 +0000
Message-Id: <1c96905f16268817af54a7f0d4d74bc8525f4eb3.1481019109.git.sean@mess.org>
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

Add the capability to encode NEC scancodes as raw events. The
scancode_to_raw is pretty much taken from the img-ir NEC filter()
callback, and modulation uses the pulse distance helper added in a
previous commit.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-nec-decoder.c | 94 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 2a9d155..898cf65 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -201,9 +201,103 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+/**
+ * ir_nec_scancode_to_raw() - encode an NEC scancode ready for modulation.
+ * @protocol:	specific protocol to use
+ * @in:		scancode filter describing a single NEC scancode.
+ * @raw:	raw data to be modulated.
+ */
+static int ir_nec_scancode_to_raw(enum rc_type protocol,
+				  const struct rc_scancode_filter *in, u32 *raw)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+
+	data = in->data & 0xff;
+
+	if (protocol == RC_TYPE_NEC32) {
+		/* 32-bit NEC (used by Apple and TiVo remotes) */
+		/* scan encoding: aaAAddDD */
+		if (in->mask != 0xffffffff)
+			return -EINVAL;
+		addr_inv   = (in->data >> 24) & 0xff;
+		addr       = (in->data >> 16) & 0xff;
+		data_inv   = (in->data >>  8) & 0xff;
+	} else if (protocol == RC_TYPE_NECX) {
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
+ * @protocol:	protocol
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
+static int ir_nec_encode(enum rc_type protocol,
+			 const struct rc_scancode_filter *scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u32 raw;
+
+	/* Convert a NEC scancode to raw NEC data */
+	ret = ir_nec_scancode_to_raw(protocol, scancode, &raw);
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
 	.protocols	= RC_BIT_NEC | RC_BIT_NECX | RC_BIT_NEC32,
 	.decode		= ir_nec_decode,
+	.encode		= ir_nec_encode,
 };
 
 static int __init ir_nec_decode_init(void)
-- 
2.9.3

