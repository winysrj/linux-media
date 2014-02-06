Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39328 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbaBFUAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 15:00:01 -0500
Received: by mail-wi0-f174.google.com with SMTP id f8so181701wiw.13
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 12:00:00 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [RFC 4/4] DEBUG: rc: img-ir: raw: Add loopback on s_filter
Date: Thu,  6 Feb 2014 19:59:23 +0000
Message-Id: <1391716763-2689-5-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
References: <1391716763-2689-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Purely for the purposes of debugging the raw IR encode, add the s_filter
callback to the img-ir-raw driver, which instead of setting the filter
just feeds it back through the input device so that it can be verified.
---
 drivers/media/rc/img-ir/img-ir-raw.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/rc/img-ir/img-ir-raw.c b/drivers/media/rc/img-ir/img-ir-raw.c
index cfb01d9..272767a 100644
--- a/drivers/media/rc/img-ir/img-ir-raw.c
+++ b/drivers/media/rc/img-ir/img-ir-raw.c
@@ -7,6 +7,7 @@
  * signal edges are reported and decoded by generic software decoders.
  */
 
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <media/rc-core.h>
 #include "img-ir.h"
@@ -95,6 +96,34 @@ void img_ir_setup_raw(struct img_ir_priv *priv)
 	spin_unlock_irq(&priv->lock);
 }
 
+static int img_ir_raw_set_filter(struct rc_dev *dev, enum rc_filter_type type,
+				 struct rc_scancode_filter *sc_filter)
+{
+	struct ir_raw_event *raw;
+	int ret;
+	int i;
+
+	/* fine to disable filter */
+	if (!sc_filter->mask)
+		return 0;
+	
+	raw = kmalloc(512 * sizeof(*raw), GFP_KERNEL);
+	ret = ir_raw_encode_scancode(dev->enabled_protocols, sc_filter, raw,
+				     512);
+	if (ret >= 0) {
+		/* loop back the scancode just for fun! */
+		for (i = 0; i < ret; ++i)
+			ir_raw_event_store(dev, &raw[i]);
+		ir_raw_event_handle(dev);
+
+		ret = 0;
+	}
+
+	kfree(raw);
+
+	return ret;
+}
+
 int img_ir_probe_raw(struct img_ir_priv *priv)
 {
 	struct img_ir_priv_raw *raw = &priv->raw;
@@ -114,6 +143,7 @@ int img_ir_probe_raw(struct img_ir_priv *priv)
 	rdev->map_name = RC_MAP_EMPTY;
 	rdev->input_name = "IMG Infrared Decoder Raw";
 	rdev->driver_type = RC_DRIVER_IR_RAW;
+	rdev->s_filter = img_ir_raw_set_filter;
 
 	/* Register raw decoder */
 	error = rc_register_device(rdev);
-- 
1.8.3.2

