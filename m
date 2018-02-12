Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41532 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934059AbeBLLpf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 06:45:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: check if the cec_adapter is valid
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <80f88bb9-68fc-a95f-3d4e-4401c7dfc528@xs4all.nl>
Date: Mon, 12 Feb 2018 12:45:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CEC is not enabled for the vivid driver, then the adap pointer is NULL
and 'adap->phys_addr' will fail.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.12 and up
---
diff --git a/drivers/media/platform/vivid/vivid-vid-common.c b/drivers/media/platform/vivid/vivid-vid-common.c
index a651527d80db..23888fdb94fb 100644
--- a/drivers/media/platform/vivid/vivid-vid-common.c
+++ b/drivers/media/platform/vivid/vivid-vid-common.c
@@ -874,7 +874,8 @@ int vidioc_g_edid(struct file *file, void *_fh,
 		return -EINVAL;
 	if (edid->start_block + edid->blocks > dev->edid_blocks)
 		edid->blocks = dev->edid_blocks - edid->start_block;
-	cec_set_edid_phys_addr(dev->edid, dev->edid_blocks * 128, adap->phys_addr);
+	if (adap)
+		cec_set_edid_phys_addr(dev->edid, dev->edid_blocks * 128, adap->phys_addr);
 	memcpy(edid->edid, dev->edid + edid->start_block * 128, edid->blocks * 128);
 	return 0;
 }
