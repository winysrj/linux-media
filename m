Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:52686 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbZKRAiw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 19:38:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: v4l: Replace video_is_unregistered with video_is_registered
Date: Wed, 18 Nov 2009 01:38:45 +0100
Message-Id: <1258504731-8430-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the video_is_unregistered function by a video_is_registered
function. The V4L2_FL_UNREGISTERED flag is replaced by a
V4L2_FL_REGISTERED flag.

This change makes the video_is_registered function return coherent
results when called on an initialize but not yet registered video_device
instance. The function can now be used instead of checking
video_device::minor.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Index: v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/v4l2-dev.c
+++ v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
@@ -227,7 +227,7 @@ static ssize_t v4l2_read(struct file *fi
 
 	if (!vdev->fops->read)
 		return -EINVAL;
-	if (video_is_unregistered(vdev))
+	if (!video_is_registered(vdev))
 		return -EIO;
 	return vdev->fops->read(filp, buf, sz, off);
 }
@@ -239,7 +239,7 @@ static ssize_t v4l2_write(struct file *f
 
 	if (!vdev->fops->write)
 		return -EINVAL;
-	if (video_is_unregistered(vdev))
+	if (!video_is_registered(vdev))
 		return -EIO;
 	return vdev->fops->write(filp, buf, sz, off);
 }
@@ -248,7 +248,7 @@ static unsigned int v4l2_poll(struct fil
 {
 	struct video_device *vdev = video_devdata(filp);
 
-	if (!vdev->fops->poll || video_is_unregistered(vdev))
+	if (!vdev->fops->poll || !video_is_registered(vdev))
 		return DEFAULT_POLLMASK;
 	return vdev->fops->poll(filp, poll);
 }
@@ -288,7 +288,7 @@ static unsigned long v4l2_get_unmapped_a
 
 	if (!vdev->fops->get_unmapped_area)
 		return -ENOSYS;
-	if (video_is_unregistered(vdev))
+	if (!video_is_registered(vdev))
 		return -ENODEV;
 	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
 }
@@ -298,8 +298,7 @@ static int v4l2_mmap(struct file *filp, 
 {
 	struct video_device *vdev = video_devdata(filp);
 
-	if (!vdev->fops->mmap ||
-	    video_is_unregistered(vdev))
+	if (!vdev->fops->mmap || !video_is_registered(vdev))
 		return -ENODEV;
 	return vdev->fops->mmap(filp, vm);
 }
@@ -315,7 +314,7 @@ static int v4l2_open(struct inode *inode
 	vdev = video_devdata(filp);
 	/* return ENODEV if the video device has been removed
 	   already or if it is not registered anymore. */
-	if (vdev == NULL || video_is_unregistered(vdev)) {
+	if (vdev == NULL || !video_is_registered(vdev)) {
 		mutex_unlock(&videodev_lock);
 		return -ENODEV;
 	}
@@ -623,6 +622,7 @@ static int __video_register_device(struc
 			name_base, nr, video_device_node_name(vdev));
 
 	/* Part 5: Activate this minor. The char device can now be used. */
+	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_lock(&videodev_lock);
 	video_device[vdev->minor] = vdev;
 	mutex_unlock(&videodev_lock);
@@ -661,11 +661,11 @@ EXPORT_SYMBOL(video_register_device_no_w
 void video_unregister_device(struct video_device *vdev)
 {
 	/* Check if vdev was ever registered at all */
-	if (!vdev || vdev->minor < 0)
+	if (!vdev || !video_is_registered(vdev))
 		return;
 
 	mutex_lock(&videodev_lock);
-	set_bit(V4L2_FL_UNREGISTERED, &vdev->flags);
+	clear_bit(V4L2_FL_REGISTERED, &vdev->flags);
 	mutex_unlock(&videodev_lock);
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
 	class_device_unregister(&vdev->dev);
Index: v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
===================================================================
--- v4l-dvb-mc-uvc.orig/linux/include/media/v4l2-dev.h
+++ v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
@@ -28,10 +28,10 @@ struct v4l2_ioctl_callbacks;
 struct video_device;
 struct v4l2_device;
 
-/* Flag to mark the video_device struct as unregistered.
-   Drivers can set this flag if they want to block all future
-   device access. It is set by video_unregister_device. */
-#define V4L2_FL_UNREGISTERED	(0)
+/* Flag to mark the video_device struct as registered.
+   Drivers can clear this flag if they want to block all future
+   device access. It is cleared by video_unregister_device. */
+#define V4L2_FL_REGISTERED	(0)
 
 struct v4l2_file_operations {
 	struct module *owner;
@@ -100,9 +100,7 @@ struct video_device
 /* Register video devices. Note that if video_register_device fails,
    the release() callback of the video_device structure is *not* called, so
    the caller is responsible for freeing any data. Usually that means that
-   you call video_device_release() on failure.
-
-   Also note that vdev->minor is set to -1 if the registration failed. */
+   you call video_device_release() on failure. */
 int __must_check video_register_device(struct video_device *vdev, int type, int nr);
 
 /* Same as video_register_device, but no warning is issued if the desired
@@ -110,7 +108,7 @@ int __must_check video_register_device(s
 int __must_check video_register_device_no_warn(struct video_device *vdev, int type, int nr);
 
 /* Unregister video devices. Will do nothing if vdev == NULL or
-   vdev->minor < 0. */
+   video_is_registered() returns false. */
 void video_unregister_device(struct video_device *vdev);
 
 /* helper functions to alloc/release struct video_device, the
@@ -162,9 +160,9 @@ static inline const char *video_device_n
 #endif
 }
 
-static inline int video_is_unregistered(struct video_device *vdev)
+static inline int video_is_registered(struct video_device *vdev)
 {
-	return test_bit(V4L2_FL_UNREGISTERED, &vdev->flags);
+	return test_bit(V4L2_FL_REGISTERED, &vdev->flags);
 }
 
 #endif /* _V4L2_DEV_H */
