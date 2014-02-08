Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33197 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBHMH5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 07:07:57 -0500
Received: by mail-lb0-f178.google.com with SMTP id u14so3538987lbd.9
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 04:07:56 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
Date: Sat,  8 Feb 2014 14:07:29 +0200
Message-Id: <1391861250-26068-3-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1391861250-26068-1-git-send-email-a.seppala@gmail.com>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
 <1391861250-26068-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoding in rc5-sz first inserts a pulse and then simply utilizes the
generic Manchester encoder available in rc-core.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/ir-rc5-sz-decoder.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 984e5b9..0d5e552 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -127,9 +127,44 @@ out:
 	return -EINVAL;
 }
 
+static struct ir_raw_timings_manchester ir_rc5_sz_timings = {
+	.pulse_space_start	= 0,
+	.clock			= RC5_UNIT,
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

