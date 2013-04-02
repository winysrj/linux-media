Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760543Ab3DBOHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 10:07:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 6356640BB3
	for <linux-media@vger.kernel.org>; Tue,  2 Apr 2013 16:07:30 +0200 (CEST)
Date: Tue, 2 Apr 2013 16:07:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: protect against racing open(2) and rmmod
Message-ID: <Pine.LNX.4.64.1304021558400.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To protect against open() racing with rmmod, hold the list_lock also while
obtaining a reference to the camera host driver and check that the video
device hasn't been unregistered yet.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   42 ++++++++++++++++--------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 8ec9805..9cc3898 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -508,36 +508,49 @@ static int soc_camera_set_fmt(struct soc_camera_device *icd,
 static int soc_camera_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
-	struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
+	struct soc_camera_device *icd;
 	struct soc_camera_host *ici;
 	int ret;
 
-	if (!to_soc_camera_control(icd))
-		/* No device driver attached */
-		return -ENODEV;
-
 	/*
 	 * Don't mess with the host during probe: wait until the loop in
-	 * scan_add_host() completes
+	 * scan_add_host() completes. Also protect against a race with
+	 * soc_camera_host_unregister().
 	 */
 	if (mutex_lock_interruptible(&list_lock))
 		return -ERESTARTSYS;
+
+	if (!vdev || !video_is_registered(vdev)) {
+		mutex_unlock(&list_lock);
+		return -ENODEV;
+	}
+
+	icd = dev_get_drvdata(vdev->parent);
 	ici = to_soc_camera_host(icd->parent);
+
+	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
 	mutex_unlock(&list_lock);
 
-	if (mutex_lock_interruptible(&ici->host_lock))
-		return -ERESTARTSYS;
-	if (!try_module_get(ici->ops->owner)) {
+	if (ret < 0) {
 		dev_err(icd->pdev, "Couldn't lock capture bus driver.\n");
-		ret = -EINVAL;
-		goto emodule;
+		return ret;
+	}
+
+	if (!to_soc_camera_control(icd)) {
+		/* No device driver attached */
+		ret = -ENODEV;
+		goto econtrol;
 	}
 
+	if (mutex_lock_interruptible(&ici->host_lock)) {
+		ret = -ERESTARTSYS;
+		goto elockhost;
+	}
 	icd->use_count++;
 
 	/* Now we really have to activate the camera */
 	if (icd->use_count == 1) {
+		struct soc_camera_desc *sdesc = to_soc_camera_desc(icd);
 		/* Restore parameters before the last close() per V4L2 API */
 		struct v4l2_format f = {
 			.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
@@ -609,9 +622,10 @@ epower:
 	ici->ops->remove(icd);
 eiciadd:
 	icd->use_count--;
-	module_put(ici->ops->owner);
-emodule:
 	mutex_unlock(&ici->host_lock);
+elockhost:
+econtrol:
+	module_put(ici->ops->owner);
 
 	return ret;
 }
-- 
1.7.2.5

