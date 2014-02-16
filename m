Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36775 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 11:46:47 -0500
Received: by mail-la0-f48.google.com with SMTP id mc6so10595228lab.35
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 08:46:46 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 2/3] ir-rc5-sz: Add ir encoding support
Date: Sun, 16 Feb 2014 18:45:54 +0200
Message-Id: <1392569155-27659-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
References: <CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
 <1392569155-27659-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoding in rc5-sz first inserts a pulse and then simply utilizes the
generic Manchester encoder available in rc-core.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/ir-rc5-sz-decoder.c | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 984e5b9..dff609e 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -127,9 +127,48 @@ out:
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
+	.trailer_space		= RC5_UNIT * 10,
+};
+
+/*
+ * ir_rc5_sz_encode() - Encode a scancode as a stream of raw events
+ *
+ * @protocols:  allowed protocols
+ * @scancode:   scancode filter describing scancode (helps distinguish between
+ *              protocol subtypes when scancode is ambiguous)
+ * @events:     array of raw ir events to write into
+ * @max:        maximum size of @events
+ *
+ * This function returns -EINVAL if the scancode filter is invalid or matches
+ * multiple scancodes. Otherwise the number of ir_raw_events generated is
+ * returned.
+ */
+static int ir_rc5_sz_encode(u64 protocols,
+			    const struct rc_scancode_filter *scancode,
+			    struct ir_raw_event *events, unsigned int max)
+{
+	int ret;
+	struct ir_raw_event *e = events;
+
+	if (scancode->mask != 0xffff)
+		return -EINVAL;
+
+	/* RC5-SZ scancode is raw enough for manchester as it is */
+	ret = ir_raw_gen_manchester(&e, max, &ir_rc5_sz_timings, RC5_SZ_NBITS,
+				    scancode->data);
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

