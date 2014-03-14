Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:48025 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaCNXHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:03 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so2676657wgh.31
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:07:02 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
Date: Fri, 14 Mar 2014 23:04:16 +0000
Message-Id: <1394838259-14260-7-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Antti Seppälä <a.seppala@gmail.com>

The encoding in rc5-sz first inserts a pulse and then simply utilizes the
generic Manchester encoder available in rc-core.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: David Härdeman <david@hardeman.nu>
---
Changes in v2 (James Hogan):
 - Turn ir_rc5_sz_encode() comment into kerneldoc and update to reflect
   new API, with the -ENOBUFS return value for when the buffer is full
   and only a partial message was encoded.
 - Be more flexible around accepted scancode masks, as long as all the
   important bits are set (0x2fff) and none of the unimportant bits are
   set in the data. Also mask off the unimportant bits before passing to
   ir_raw_gen_manchester().
 - Explicitly enable leader bit in Manchester modulation timings.
---
 drivers/media/rc/ir-rc5-sz-decoder.c | 45 ++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index dc18b74..a342a4f 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -127,9 +127,54 @@ out:
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
+	.leader			= 1,
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
+	.trailer_space		= RC5_UNIT * 10,
+};
+
+/**
+ * ir_rc5_sz_encode() - Encode a scancode as a stream of raw events
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
+static int ir_rc5_sz_encode(u64 protocols,
+			    const struct rc_scancode_filter *scancode,
+			    struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+
+	/* all important bits of scancode should be set in mask */
+	if (~scancode->mask & 0x2fff)
+		return -EINVAL;
+	/* extra bits in mask should be zero in data */
+	if (scancode->mask & scancode->data & ~0x2fff)
+		return -EINVAL;
+
+	/* RC5-SZ scancode is raw enough for Manchester as it is */
+	ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings, RC5_SZ_NBITS,
+				    scancode->data & 0x2fff);
+	if (ret < 0)
+		return ret;
+
+	return e - events;
+}
+
 static struct ir_raw_handler rc5_sz_handler = {
 	.protocols	= RC_BIT_RC5_SZ,
 	.decode		= ir_rc5_sz_decode,
+	.encode		= ir_rc5_sz_encode,
 };
 
 static int __init ir_rc5_sz_decode_init(void)
-- 
1.8.3.2

