Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37871 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdLMJfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 04:35:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH v2 1/2] uvcvideo: Factor out video device registration to a function
Date: Wed, 13 Dec 2017 11:35:08 +0200
Message-Id: <20171213093509.25563-2-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20171213093509.25563-1-laurent.pinchart@ideasonboard.com>
References: <20171213093509.25563-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function will then be used to register the video device for metadata
capture.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Tested-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 68 ++++++++++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h   |  8 +++++
 2 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 07e427d36516..f6fbfc122871 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -24,6 +24,7 @@
 #include <asm/unaligned.h>
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
 
 #include "uvcvideo.h"
 
@@ -1889,52 +1890,65 @@ static void uvc_unregister_video(struct uvc_device *dev)
 	kref_put(&dev->ref, uvc_delete);
 }
 
-static int uvc_register_video(struct uvc_device *dev,
-		struct uvc_streaming *stream)
+int uvc_register_video_device(struct uvc_device *dev,
+			      struct uvc_streaming *stream,
+			      struct video_device *vdev,
+			      struct uvc_video_queue *queue,
+			      enum v4l2_buf_type type,
+			      const struct v4l2_file_operations *fops,
+			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
-	struct video_device *vdev = &stream->vdev;
 	int ret;
 
 	/* Initialize the video buffers queue. */
-	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
+	ret = uvc_queue_init(queue, type, !uvc_no_drop_param);
 	if (ret)
 		return ret;
 
-	/* Initialize the streaming interface with default streaming
-	 * parameters.
-	 */
-	ret = uvc_video_init(stream);
-	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
-		return ret;
-	}
-
-	uvc_debugfs_init_stream(stream);
-
 	/* Register the device with V4L. */
 
-	/* We already hold a reference to dev->udev. The video device will be
+	/*
+	 * We already hold a reference to dev->udev. The video device will be
 	 * unregistered before the reference is released, so we don't need to
 	 * get another one.
 	 */
 	vdev->v4l2_dev = &dev->vdev;
-	vdev->fops = &uvc_fops;
-	vdev->ioctl_ops = &uvc_ioctl_ops;
+	vdev->fops = fops;
+	vdev->ioctl_ops = ioctl_ops;
 	vdev->release = uvc_release;
 	vdev->prio = &stream->chain->prio;
-	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		vdev->vfl_dir = VFL_DIR_TX;
+	else
+		vdev->vfl_dir = VFL_DIR_RX;
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
 
-	/* Set the driver data before calling video_register_device, otherwise
-	 * uvc_v4l2_open might race us.
+	/*
+	 * Set the driver data before calling video_register_device, otherwise
+	 * the file open() handler might race us.
 	 */
 	video_set_drvdata(vdev, stream);
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
-		uvc_printk(KERN_ERR, "Failed to register video device (%d).\n",
+		uvc_printk(KERN_ERR, "Failed to register %s device (%d).\n",
+			   v4l2_type_names[type], ret);
+		return ret;
+	}
+
+	kref_get(&dev->ref);
+	return 0;
+}
+
+static int uvc_register_video(struct uvc_device *dev,
+		struct uvc_streaming *stream)
+{
+	int ret;
+
+	/* Initialize the streaming interface with default parameters. */
+	ret = uvc_video_init(stream);
+	if (ret < 0) {
+		uvc_printk(KERN_ERR, "Failed to initialize the device (%d).\n",
 			   ret);
 		return ret;
 	}
@@ -1944,8 +1958,12 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	kref_get(&dev->ref);
-	return 0;
+	uvc_debugfs_init_stream(stream);
+
+	/* Register the device with V4L. */
+	return uvc_register_video_device(dev, stream, &stream->vdev,
+					 &stream->queue, stream->type,
+					 &uvc_fops, &uvc_ioctl_ops);
 }
 
 /*
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index dd9c79a92622..c36fa0991141 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -716,6 +716,14 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
 
+int uvc_register_video_device(struct uvc_device *dev,
+			      struct uvc_streaming *stream,
+			      struct video_device *vdev,
+			      struct uvc_video_queue *queue,
+			      enum v4l2_buf_type type,
+			      const struct v4l2_file_operations *fops,
+			      const struct v4l2_ioctl_ops *ioctl_ops);
+
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
 extern void uvc_status_cleanup(struct uvc_device *dev);
-- 
Regards,

Laurent Pinchart
