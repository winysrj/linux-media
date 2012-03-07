Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54460 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab2CGJBh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 04:01:37 -0500
From: Archit Taneja <archit@ti.com>
To: <hvaibhav@ti.com>
CC: <tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>,
	<linux-media@vger.kernel.org>, Archit Taneja <archit@ti.com>
Subject: [PATCH] omap_vout: Set DSS overlay_info only if paddr is non zero
Date: Wed, 7 Mar 2012 14:31:16 +0530
Message-ID: <1331110876-11895-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap_vout driver tries to set the DSS overlay_info using set_overlay_info()
when the physical address for the overlay is still not configured. This happens
in omap_vout_probe() and vidioc_s_fmt_vid_out().

The calls to omapvid_init(which internally calls set_overlay_info()) are removed
from these functions. They don't need to be called as the omap_vout_device
struct anyway maintains the overlay related changes made. Also, remove the
explicit call to set_overlay_info() in vidioc_streamon(), this was used to set
the paddr, this isn't needed as omapvid_init() does the same thing later.

These changes are required as the DSS2 driver since 3.3 kernel doesn't let you
set the overlay info with paddr as 0.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/video/omap/omap_vout.c |   36 ++++-----------------------------
 1 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 1fb7d5b..dffcf66 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1157,13 +1157,6 @@ static int vidioc_s_fmt_vid_out(struct file *file, void *fh,
 	/* set default crop and win */
 	omap_vout_new_format(&vout->pix, &vout->fbuf, &vout->crop, &vout->win);
 
-	/* Save the changes in the overlay strcuture */
-	ret = omapvid_init(vout, 0);
-	if (ret) {
-		v4l2_err(&vout->vid_dev->v4l2_dev, "failed to change mode\n");
-		goto s_fmt_vid_out_exit;
-	}
-
 	ret = 0;
 
 s_fmt_vid_out_exit:
@@ -1664,20 +1657,6 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 
 	omap_dispc_register_isr(omap_vout_isr, vout, mask);
 
-	for (j = 0; j < ovid->num_overlays; j++) {
-		struct omap_overlay *ovl = ovid->overlays[j];
-
-		if (ovl->manager && ovl->manager->device) {
-			struct omap_overlay_info info;
-			ovl->get_overlay_info(ovl, &info);
-			info.paddr = addr;
-			if (ovl->set_overlay_info(ovl, &info)) {
-				ret = -EINVAL;
-				goto streamon_err1;
-			}
-		}
-	}
-
 	/* First save the configuration in ovelray structure */
 	ret = omapvid_init(vout, addr);
 	if (ret)
@@ -2071,11 +2050,12 @@ static int __init omap_vout_create_video_devices(struct platform_device *pdev)
 		}
 		video_set_drvdata(vfd, vout);
 
-		/* Configure the overlay structure */
-		ret = omapvid_init(vid_dev->vouts[k], 0);
-		if (!ret)
-			goto success;
+		dev_info(&pdev->dev, ": registered and initialized"
+				" video device %d\n", vfd->minor);
+		if (k == (pdev->num_resources - 1))
+			return 0;
 
+		continue;
 error2:
 		if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
 			omap_vout_release_vrfb(vout);
@@ -2085,12 +2065,6 @@ error1:
 error:
 		kfree(vout);
 		return ret;
-
-success:
-		dev_info(&pdev->dev, ": registered and initialized"
-				" video device %d\n", vfd->minor);
-		if (k == (pdev->num_resources - 1))
-			return 0;
 	}
 
 	return -ENODEV;
-- 
1.7.5.4

