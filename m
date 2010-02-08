Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55068 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751607Ab0BHJtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 04:49:42 -0500
Date: Mon, 8 Feb 2010 10:50:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-pm@lists.linux-foundation.org
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH/RESEND] soc-camera: add runtime pm support for subdevices
Message-ID: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To save power soc-camera powers subdevices down, when they are not in use, 
if this is supported by the platform. However, the V4L standard dictates, 
that video nodes shall preserve configuration between uses. This requires 
runtime power management, which is implemented by this patch. It allows 
subdevice drivers to specify their runtime power-management methods, by 
assigning a type to the video device.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

I've posted this patch to linux-media earlier, but I'd also like to get 
comments on linux-pm, sorry to linux-media falks for a duplicate. To 
explain a bit - soc_camera.c is a management module, that binds video 
interfaces on SoCs and sensor drivers. The calls, that I am adding to 
soc_camera.c shall save and restore sensor registers before they are 
powered down and after they are powered up.

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 6b3fbcc..53201f3 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
@@ -387,6 +388,11 @@ static int soc_camera_open(struct file *file)
 			goto eiciadd;
 		}
 
+		pm_runtime_enable(&icd->vdev->dev);
+		ret = pm_runtime_resume(&icd->vdev->dev);
+		if (ret < 0 && ret != -ENOSYS)
+			goto eresume;
+
 		/*
 		 * Try to configure with default parameters. Notice: this is the
 		 * very first open, so, we cannot race against other calls,
@@ -408,10 +414,12 @@ static int soc_camera_open(struct file *file)
 	return 0;
 
 	/*
-	 * First five errors are entered with the .video_lock held
+	 * First four errors are entered with the .video_lock held
 	 * and use_count == 1
 	 */
 esfmt:
+	pm_runtime_disable(&icd->vdev->dev);
+eresume:
 	ici->ops->remove(icd);
 eiciadd:
 	if (icl->power)
@@ -436,7 +444,11 @@ static int soc_camera_close(struct file *file)
 	if (!icd->use_count) {
 		struct soc_camera_link *icl = to_soc_camera_link(icd);
 
+		pm_runtime_suspend(&icd->vdev->dev);
+		pm_runtime_disable(&icd->vdev->dev);
+
 		ici->ops->remove(icd);
+
 		if (icl->power)
 			icl->power(icd->pdev, 0);
 	}
@@ -1294,6 +1306,7 @@ static int video_dev_create(struct soc_camera_device *icd)
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
+	struct device_type *type = icd->vdev->dev.type;
 	int ret;
 
 	if (!icd->dev.parent)
@@ -1310,6 +1323,9 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 		return ret;
 	}
 
+	/* Restore device type, possibly set by the subdevice driver */
+	icd->vdev->dev.type = type;
+
 	return 0;
 }
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index dcc5b86..58b39a9 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -282,4 +282,12 @@ static inline void soc_camera_limit_side(unsigned int *start,
 extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
 						   unsigned long flags);
 
+/* This is only temporary here - until v4l2-subdev begins to link to video_device */
+#include <linux/i2c.h>
+static inline struct video_device *soc_camera_i2c_to_vdev(struct i2c_client *client)
+{
+	struct soc_camera_device *icd = client->dev.platform_data;
+	return icd->vdev;
+}
+
 #endif
