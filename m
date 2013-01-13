Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21059 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab3AMMai (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 07:30:38 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGK00I0IDEUZJ00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:37 +0900 (KST)
Received: from chrome-ubuntu.sisodomain.com ([107.108.73.106])
 by mmp2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MGK00B86DEGTC60@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 13 Jan 2013 21:30:36 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: tomi.valkeinen@ti.com, laurent.pinchart@ideasonboard.com,
	inki.dae@samsung.com, r.sh.open@gmail.com, joshi@samsung.com
Subject: [RFC PATCH 2/4] drm/edid: temporarily exposing generic edid-read
 interface from drm
Date: Sun, 13 Jan 2013 07:52:12 -0500
Message-id: <1358081534-21372-3-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
References: <1358081534-21372-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It exposes generic interface from drm_edid.c to get the edid data and length
by any display entity. Once I get clear idea about edid handling in CDF, I need
to revert these temporary changes.

Signed-off-by: Rahul Sharma <rahul.sharma@samsung.com>
---
 drivers/gpu/drm/drm_edid.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 5a3770f..567a565 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
+#include <video/display.h>
 #include <drm/drmP.h>
 #include <drm/drm_edid.h>
 #include "drm_edid_modes.h"
@@ -386,6 +387,93 @@ out:
 	return NULL;
 }
 
+int generic_drm_do_get_edid(struct i2c_adapter *adapter,
+	struct display_entity_edid *edid)
+{
+	int i, j = 0, valid_extensions = 0;
+	u8 *block, *new;
+	bool print_bad_edid = 0;
+
+	block = kmalloc(EDID_LENGTH, GFP_KERNEL);
+	if (!block)
+		return -ENOMEM;
+
+	/* base block fetch */
+	for (i = 0; i < 4; i++) {
+		if (drm_do_probe_ddc_edid(adapter, block, 0, EDID_LENGTH))
+			goto out;
+		if (drm_edid_block_valid(block, 0, print_bad_edid))
+			break;
+		if (i == 0 && drm_edid_is_zero(block, EDID_LENGTH))
+			goto carp;
+	}
+	if (i == 4)
+		goto carp;
+
+	/* if there's no extensions, we're done */
+	if (block[0x7e] == 0) {
+		edid->edid = block;
+		edid->len = EDID_LENGTH;
+		return 0;
+	}
+
+	new = krealloc(block, (block[0x7e] + 1) * EDID_LENGTH, GFP_KERNEL);
+	if (!new)
+		goto out;
+	block = new;
+	edid->len = (block[0x7e] + 1) * EDID_LENGTH;
+
+	for (j = 1; j <= block[0x7e]; j++) {
+		for (i = 0; i < 4; i++) {
+			if (drm_do_probe_ddc_edid(adapter,
+				  block + (valid_extensions + 1) * EDID_LENGTH,
+				  j, EDID_LENGTH))
+				goto out;
+			if (drm_edid_block_valid(block + (valid_extensions + 1)*
+				EDID_LENGTH, j, print_bad_edid)) {
+				valid_extensions++;
+				break;
+			}
+		}
+		if (i == 4)
+			DRM_DEBUG_KMS("Ignoring inv lock %d.\n", j);
+	}
+
+	if (valid_extensions != block[0x7e]) {
+		block[EDID_LENGTH-1] += block[0x7e] - valid_extensions;
+		block[0x7e] = valid_extensions;
+		new = krealloc(block, (valid_extensions + 1)*
+			EDID_LENGTH, GFP_KERNEL);
+		if (!new)
+			goto out;
+		block = new;
+		edid->len = (valid_extensions + 1) * EDID_LENGTH;
+	}
+
+	edid->edid = block;
+	return 0;
+
+carp:
+	if (print_bad_edid)
+		DRM_DEBUG_KMS("[ERROR]: EDID block %d invalid.\n", j);
+
+out:
+	kfree(block);
+	return -ENOMEM;
+}
+
+
+int generic_drm_get_edid(struct i2c_adapter *adapter,
+	struct display_entity_edid *edid)
+{
+	int ret = -EINVAL;
+	if (drm_probe_ddc(adapter))
+		ret = generic_drm_do_get_edid(adapter, edid);
+
+	return ret;
+}
+EXPORT_SYMBOL(generic_drm_get_edid);
+
 /**
  * Probe DDC presence.
  *
-- 
1.8.0

