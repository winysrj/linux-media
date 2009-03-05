Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:57830 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZCEO1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 09:27:02 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: dongsoo.kim@gmail.com, hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, saaguirre@ti.com
Subject: [PATCH] omap34xxcam: Don't use dev_err before we have a video device
Date: Thu,  5 Mar 2009 16:26:35 +0200
Message-Id: <1236263195-22033-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427BCA20A@dbde02.ent.ti.com>
References: <19F8576C6E063C45BE387C64729E73940427BCA20A@dbde02.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Also return -ENOMEM instead of -ENODEV if kzalloc fails.

Thanks to Alexey Klimov <klimov.linux@gmail.com> for noticing this.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/omap34xxcam.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/omap34xxcam.c b/drivers/media/video/omap34xxcam.c
index 586718a..8398819 100644
--- a/drivers/media/video/omap34xxcam.c
+++ b/drivers/media/video/omap34xxcam.c
@@ -1793,8 +1793,8 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 
 	mutex_lock(&vdev->mutex);
 	if (atomic_read(&vdev->users)) {
-		dev_err(&vdev->vfd->dev, "we're open (%d), can't register\n",
-			atomic_read(&vdev->users));
+		printk(KERN_ERR "%s: we're open (%d), can't register\n",
+		       __func__, atomic_read(&vdev->users));
 		mutex_unlock(&vdev->mutex);
 		return -EBUSY;
 	}
@@ -1806,8 +1806,8 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 	if (hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR) {
 		rval = isp_get();
 		if (rval < 0) {
-			dev_err(&vdev->vfd->dev,
-				"can't get ISP, sensor init failed\n");
+			printk(KERN_ERR "%s: can't get ISP, "
+			       "sensor init failed\n", __func__);
 			goto err;
 		}
 	}
@@ -1837,8 +1837,8 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 		/* initialize the video_device struct */
 		vdev->vfd = video_device_alloc();
 		if (!vdev->vfd) {
-			dev_err(&vdev->vfd->dev,
-				"could not allocate video device struct\n");
+			printk(KERN_ERR "%s: could not allocate "
+			       "video device struct\n", __func__);
 			return -ENOMEM;
 		}
 		vdev->vfd->release	= video_device_release;
@@ -1849,8 +1849,8 @@ static int omap34xxcam_device_register(struct v4l2_int_device *s)
 
 		if (video_register_device(vdev->vfd, VFL_TYPE_GRABBER,
 					  hwc.dev_minor) < 0) {
-			dev_err(&vdev->vfd->dev,
-				"could not register V4L device\n");
+			printk(KERN_ERR "%s: could not register V4L device\n",
+				__func__);
 			vdev->vfd->minor = -1;
 			rval = -EBUSY;
 			goto err;
@@ -1919,7 +1919,7 @@ static int __init omap34xxcam_init(void)
 	cam = kzalloc(sizeof(*cam), GFP_KERNEL);
 	if (!cam) {
 		printk(KERN_ERR "%s: could not allocate memory\n", __func__);
-		goto err;
+		return -ENOMEM;
 	}
 
 	omap34xxcam = cam;
-- 
1.5.6.5

