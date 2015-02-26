Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:53328 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754578AbbBZWdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 17:33:18 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, Julia.Lawall@lip6.fr
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 - embed vdev and vbi_dev structs in au0828_dev
Date: Thu, 26 Feb 2015 15:33:13 -0700
Message-Id: <1424989993-8458-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Embed video_device structs vdev and vbi_dev in au0828_dev.
With this change, dynamic allocation and error path logic
in au0828_analog_register() is removed as it doesn't need
to allocate and handle allocation errors. Unregister path
doesn't need to free the now static video_device structures,
hence, changed video_device.release in au0828_video_template
to point to video_device_release_empty.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/usb/au0828/au0828-video.c | 66 +++++++++++----------------------
 drivers/media/usb/au0828/au0828.h       |  4 +-
 2 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index a27cb5f..f47ee90 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -900,10 +900,8 @@ void au0828_analog_unregister(struct au0828_dev *dev)
 	dprintk(1, "au0828_analog_unregister called\n");
 	mutex_lock(&au0828_sysfs_lock);
 
-	if (dev->vdev)
-		video_unregister_device(dev->vdev);
-	if (dev->vbi_dev)
-		video_unregister_device(dev->vbi_dev);
+	video_unregister_device(&dev->vdev);
+	video_unregister_device(&dev->vbi_dev);
 
 	mutex_unlock(&au0828_sysfs_lock);
 }
@@ -1286,7 +1284,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		input->audioset = 2;
 	}
 
-	input->std = dev->vdev->tvnorms;
+	input->std = dev->vdev.tvnorms;
 
 	return 0;
 }
@@ -1704,7 +1702,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 
 static const struct video_device au0828_video_template = {
 	.fops                       = &au0828_v4l_fops,
-	.release                    = video_device_release,
+	.release                    = video_device_release_empty,
 	.ioctl_ops 		    = &video_ioctl_ops,
 	.tvnorms                    = V4L2_STD_NTSC_M | V4L2_STD_PAL_M,
 };
@@ -1814,52 +1812,36 @@ int au0828_analog_register(struct au0828_dev *dev,
 	dev->std = V4L2_STD_NTSC_M;
 	au0828_s_input(dev, 0);
 
-	/* allocate and fill v4l2 video struct */
-	dev->vdev = video_device_alloc();
-	if (NULL == dev->vdev) {
-		dprintk(1, "Can't allocate video_device.\n");
-		return -ENOMEM;
-	}
-
-	/* allocate the VBI struct */
-	dev->vbi_dev = video_device_alloc();
-	if (NULL == dev->vbi_dev) {
-		dprintk(1, "Can't allocate vbi_device.\n");
-		ret = -ENOMEM;
-		goto err_vdev;
-	}
-
 	mutex_init(&dev->vb_queue_lock);
 	mutex_init(&dev->vb_vbi_queue_lock);
 
 	/* Fill the video capture device struct */
-	*dev->vdev = au0828_video_template;
-	dev->vdev->v4l2_dev = &dev->v4l2_dev;
-	dev->vdev->lock = &dev->lock;
-	dev->vdev->queue = &dev->vb_vidq;
-	dev->vdev->queue->lock = &dev->vb_queue_lock;
-	strcpy(dev->vdev->name, "au0828a video");
+	dev->vdev = au0828_video_template;
+	dev->vdev.v4l2_dev = &dev->v4l2_dev;
+	dev->vdev.lock = &dev->lock;
+	dev->vdev.queue = &dev->vb_vidq;
+	dev->vdev.queue->lock = &dev->vb_queue_lock;
+	strcpy(dev->vdev.name, "au0828a video");
 
 	/* Setup the VBI device */
-	*dev->vbi_dev = au0828_video_template;
-	dev->vbi_dev->v4l2_dev = &dev->v4l2_dev;
-	dev->vbi_dev->lock = &dev->lock;
-	dev->vbi_dev->queue = &dev->vb_vbiq;
-	dev->vbi_dev->queue->lock = &dev->vb_vbi_queue_lock;
-	strcpy(dev->vbi_dev->name, "au0828a vbi");
+	dev->vbi_dev = au0828_video_template;
+	dev->vbi_dev.v4l2_dev = &dev->v4l2_dev;
+	dev->vbi_dev.lock = &dev->lock;
+	dev->vbi_dev.queue = &dev->vb_vbiq;
+	dev->vbi_dev.queue->lock = &dev->vb_vbi_queue_lock;
+	strcpy(dev->vbi_dev.name, "au0828a vbi");
 
 	/* initialize videobuf2 stuff */
 	retval = au0828_vb2_setup(dev);
 	if (retval != 0) {
 		dprintk(1, "unable to setup videobuf2 queues (error = %d).\n",
 			retval);
-		ret = -ENODEV;
-		goto err_vbi_dev;
+		return -ENODEV;
 	}
 
 	/* Register the v4l2 device */
-	video_set_drvdata(dev->vdev, dev);
-	retval = video_register_device(dev->vdev, VFL_TYPE_GRABBER, -1);
+	video_set_drvdata(&dev->vdev, dev);
+	retval = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (retval != 0) {
 		dprintk(1, "unable to register video device (error = %d).\n",
 			retval);
@@ -1868,8 +1850,8 @@ int au0828_analog_register(struct au0828_dev *dev,
 	}
 
 	/* Register the vbi device */
-	video_set_drvdata(dev->vbi_dev, dev);
-	retval = video_register_device(dev->vbi_dev, VFL_TYPE_VBI, -1);
+	video_set_drvdata(&dev->vbi_dev, dev);
+	retval = video_register_device(&dev->vbi_dev, VFL_TYPE_VBI, -1);
 	if (retval != 0) {
 		dprintk(1, "unable to register vbi device (error = %d).\n",
 			retval);
@@ -1882,14 +1864,10 @@ int au0828_analog_register(struct au0828_dev *dev,
 	return 0;
 
 err_reg_vbi_dev:
-	video_unregister_device(dev->vdev);
+	video_unregister_device(&dev->vdev);
 err_reg_vdev:
 	vb2_queue_release(&dev->vb_vidq);
 	vb2_queue_release(&dev->vb_vbiq);
-err_vbi_dev:
-	video_device_release(dev->vbi_dev);
-err_vdev:
-	video_device_release(dev->vdev);
 	return ret;
 }
 
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index eb15187..3b48000 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -209,8 +209,8 @@ struct au0828_dev {
 	struct au0828_rc *ir;
 #endif
 
-	struct video_device *vdev;
-	struct video_device *vbi_dev;
+	struct video_device vdev;
+	struct video_device vbi_dev;
 
 	/* Videobuf2 */
 	struct vb2_queue vb_vidq;
-- 
2.1.0

