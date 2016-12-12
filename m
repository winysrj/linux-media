Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48947 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932515AbcLLVN6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 16:13:58 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v5 11/18] [media] rc: ir-nec-decoder: Add encode capability
Date: Mon, 12 Dec 2016 21:13:47 +0000
Message-Id: <7069c3e49049557c380f5fe5c8145c749916b42f.1481575826.git.sean@mess.org>
In-Reply-To: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
References: <1669f6c54c34e5a78ce114c633c98b331e58e8c7.1481575826.git.sean@mess.org>
In-Reply-To: <cover.1481575826.git.sean@mess.org>
References: <cover.1481575826.git.sean@mess.org>
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
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-nec-decoder.c | 81 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 2a9d155..22aab8a 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -201,9 +201,90 @@ static int ir_nec_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	return -EINVAL;
 }
 
+/**
+ * ir_nec_scancode_to_raw() - encode an NEC scancode ready for modulation.
+ * @protocol:	specific protocol to use
+ * @scancode:	a single NEC scancode.
+ * @raw:	raw data to be modulated.
+ */
+static u32 ir_nec_scancode_to_raw(enum rc_type protocol, u32 scancode)
+{
+	unsigned int addr, addr_inv, data, data_inv;
+
+	data = scancode & 0xff;
+
+	if (protocol == RC_TYPE_NEC32) {
+		/* 32-bit NEC (used by Apple and TiVo remotes) */
+		/* scan encoding: aaAAddDD */
+		addr_inv   = (scancode >> 24) & 0xff;
+		addr       = (scancode >> 16) & 0xff;
+		data_inv   = (scancode >>  8) & 0xff;
+	} else if (protocol == RC_TYPE_NECX) {
+		/* Extended NEC */
+		/* scan encoding AAaaDD */
+		addr       = (scancode >> 16) & 0xff;
+		addr_inv   = (scancode >>  8) & 0xff;
+		data_inv   = data ^ 0xff;
+	} else {
+		/* Normal NEC */
+		/* scan encoding: AADD */
+		addr       = (scancode >>  8) & 0xff;
+		addr_inv   = addr ^ 0xff;
+		data_inv   = data ^ 0xff;
+	}
+
+	/* raw encoding: ddDDaaAA */
+	return data_inv << 24 |
+	       data     << 16 |
+	       addr_inv <<  8 |
+	       addr;
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
+ * @protocol:	protocol to encode
+ * @scancode:	scancode to encode
+ * @events:	array of raw ir events to write into
+ * @max:	maximum size of @events
+ *
+ * Returns:	The number of events written.
+ *		-ENOBUFS if there isn't enough space in the array to fit the
+ *		encoding. In this case all @max events will have been written.
+ */
+static int ir_nec_encode(enum rc_type protocol, u32 scancode,
+			 struct ir_raw_event *events, unsigned int max)
+{
+	struct ir_raw_event *e = events;
+	int ret;
+	u32 raw;
+
+	/* Convert a NEC scancode to raw NEC data */
+	raw = ir_nec_scancode_to_raw(protocol, scancode);
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

