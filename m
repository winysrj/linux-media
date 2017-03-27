Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:36111 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751922AbdC0IhQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 04:37:16 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fix g_edid implementation
Message-ID: <0cf930b6-9bc2-a563-e272-2f57fae935de@xs4all.nl>
Date: Mon, 27 Mar 2017 10:36:53 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VIDIOC_G_EDID implementation in vivid didn't take edid->start_block into account when
copying the EDID data.

Make sure that the internal EDID is updated with the correct CEC physical address. Currently
the returned EDID is updated, but that will only work well if edid->start_block is 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index 5fc010f6ce67..f0f423c7ca41 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -858,7 +858,7 @@ int vidioc_g_edid(struct file *file, void *_fh,
 		return -EINVAL;
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
-	memcpy(edid->edid, dev->edid, edid->blocks * 128);
-	cec_set_edid_phys_addr(edid->edid, edid->blocks * 128, adap->phys_addr);
+	cec_set_edid_phys_addr(dev->edid, dev->edid_blocks * 128, adap->phys_addr);
+	memcpy(edid->edid, dev->edid + edid->start_block * 128, edid->blocks * 128);
 	return 0;
 }
