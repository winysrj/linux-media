Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43179 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754087AbbCMLR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:17:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 39/39] vivid: use v4l2_device.release to clean up the driver
Date: Fri, 13 Mar 2015 12:16:17 +0100
Message-Id: <1426245377-17704-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
References: <1426245377-17704-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the release callback of the v4l2_device to clean up the memory.
This prevents vivid from breaking if someone tries to unbind the
driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivid/vivid-core.c | 43 +++++++++++++++++--------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index d2558db..d33f164 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -619,6 +619,22 @@ static const struct v4l2_ioctl_ops vivid_ioctl_ops = {
 	Initialization and module stuff
    ------------------------------------------------------------------*/
 
+static void vivid_dev_release(struct v4l2_device *v4l2_dev)
+{
+	struct vivid_dev *dev = container_of(v4l2_dev, struct vivid_dev, v4l2_dev);
+
+	vivid_free_controls(dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+	vfree(dev->scaled_line);
+	vfree(dev->blended_line);
+	vfree(dev->edid);
+	vfree(dev->bitmap_cap);
+	vfree(dev->bitmap_out);
+	tpg_free(&dev->tpg);
+	kfree(dev->query_dv_timings_qmenu);
+	kfree(dev);
+}
+
 static int vivid_create_instance(struct platform_device *pdev, int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
@@ -648,8 +664,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name),
 			"%s-%03d", VIVID_MODULE_NAME, inst);
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
-	if (ret)
-		goto free_dev;
+	if (ret) {
+		kfree(dev);
+		return ret;
+	}
+	dev->v4l2_dev.release = vivid_dev_release;
 
 	/* start detecting feature set */
 
@@ -1257,15 +1276,8 @@ unreg_dev:
 	video_unregister_device(&dev->vbi_cap_dev);
 	video_unregister_device(&dev->vid_out_dev);
 	video_unregister_device(&dev->vid_cap_dev);
-	vivid_free_controls(dev);
-	v4l2_device_unregister(&dev->v4l2_dev);
 free_dev:
-	vfree(dev->scaled_line);
-	vfree(dev->blended_line);
-	vfree(dev->edid);
-	tpg_free(&dev->tpg);
-	kfree(dev->query_dv_timings_qmenu);
-	kfree(dev);
+	v4l2_device_put(&dev->v4l2_dev);
 	return ret;
 }
 
@@ -1359,16 +1371,7 @@ static int vivid_remove(struct platform_device *pdev)
 			unregister_framebuffer(&dev->fb_info);
 			vivid_fb_release_buffers(dev);
 		}
-		v4l2_device_unregister(&dev->v4l2_dev);
-		vivid_free_controls(dev);
-		vfree(dev->scaled_line);
-		vfree(dev->blended_line);
-		vfree(dev->edid);
-		vfree(dev->bitmap_cap);
-		vfree(dev->bitmap_out);
-		tpg_free(&dev->tpg);
-		kfree(dev->query_dv_timings_qmenu);
-		kfree(dev);
+		v4l2_device_put(&dev->v4l2_dev);
 		vivid_devs[i] = NULL;
 	}
 	return 0;
-- 
2.1.4

