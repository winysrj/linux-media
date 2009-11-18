Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52682 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591AbZKRAit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Add video_device_node_name function
Date: Wed, 18 Nov 2009 01:38:42 +0100
Message-Id: <1258504731-8430-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many drivers access the device number (video_device::v4l2_devnode::num)
in order to print the video device node name. Add and use a helper
function to retrieve the video_device node name.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/v4l2-dev.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
@@ -619,8 +619,8 @@ static int __video_register_device(struc
 	vdev->dev.release = v4l2_device_release;
 
 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
-		printk(KERN_WARNING "%s: requested %s%d, got %s%d\n",
-				__func__, name_base, nr, name_base, vdev->num);
+		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
+			name_base, nr, video_device_node_name(vdev));
 
 	/* Part 5: Activate this minor. The char device can now be used. */
 	mutex_lock(&videodev_lock);
Index: v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/include/media/v4l2-dev.h
+++ v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
@@ -153,6 +153,15 @@ static inline void *video_drvdata(struct
 	return video_get_drvdata(video_devdata(file));
 }
 
+static inline const char *video_device_node_name(struct video_device *vdev)
+{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
+	return vdev->dev.class_id;
+#else
+	return dev_name(&vdev->dev);
+#endif
+}
+
 static inline int video_is_unregistered(struct video_device *vdev)
 {
 	return test_bit(V4L2_FL_UNREGISTERED, &vdev->flags);
