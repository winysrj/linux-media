Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932758AbbCIQgq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:36:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 17/19] uvc: embed video_device
Date: Mon,  9 Mar 2015 17:34:11 +0100
Message-Id: <1425918853-12371-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
References: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 22 ++++------------------
 drivers/media/usb/uvc/uvc_v4l2.c   |  2 +-
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index cf27006..8dd3f7b 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1669,10 +1669,6 @@ static void uvc_delete(struct uvc_device *dev)
 #ifdef CONFIG_MEDIA_CONTROLLER
 		uvc_mc_cleanup_entity(entity);
 #endif
-		if (entity->vdev) {
-			video_device_release(entity->vdev);
-			entity->vdev = NULL;
-		}
 		kfree(entity);
 	}
 
@@ -1717,11 +1713,10 @@ static void uvc_unregister_video(struct uvc_device *dev)
 	atomic_inc(&dev->nstreams);
 
 	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->vdev == NULL)
+		if (!video_is_registered(&stream->vdev))
 			continue;
 
-		video_unregister_device(stream->vdev);
-		stream->vdev = NULL;
+		video_unregister_device(&stream->vdev);
 
 		uvc_debugfs_cleanup_stream(stream);
 	}
@@ -1736,7 +1731,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 static int uvc_register_video(struct uvc_device *dev,
 		struct uvc_streaming *stream)
 {
-	struct video_device *vdev;
+	struct video_device *vdev = &stream->vdev;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -1757,12 +1752,6 @@ static int uvc_register_video(struct uvc_device *dev,
 	uvc_debugfs_init_stream(stream);
 
 	/* Register the device with V4L. */
-	vdev = video_device_alloc();
-	if (vdev == NULL) {
-		uvc_printk(KERN_ERR, "Failed to allocate video device (%d).\n",
-			   ret);
-		return -ENOMEM;
-	}
 
 	/* We already hold a reference to dev->udev. The video device will be
 	 * unregistered before the reference is released, so we don't need to
@@ -1780,15 +1769,12 @@ static int uvc_register_video(struct uvc_device *dev,
 	/* Set the driver data before calling video_register_device, otherwise
 	 * uvc_v4l2_open might race us.
 	 */
-	stream->vdev = vdev;
 	video_set_drvdata(vdev, stream);
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		uvc_printk(KERN_ERR, "Failed to register video device (%d).\n",
 			   ret);
-		stream->vdev = NULL;
-		video_device_release(vdev);
 		return ret;
 	}
 
@@ -1827,7 +1813,7 @@ static int uvc_register_terms(struct uvc_device *dev,
 		if (ret < 0)
 			return ret;
 
-		term->vdev = stream->vdev;
+		term->vdev = &stream->vdev;
 	}
 
 	return 0;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 43e953f..c08b202 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -511,7 +511,7 @@ static int uvc_v4l2_open(struct file *file)
 	stream->dev->users++;
 	mutex_unlock(&stream->dev->lock);
 
-	v4l2_fh_init(&handle->vfh, stream->vdev);
+	v4l2_fh_init(&handle->vfh, &stream->vdev);
 	v4l2_fh_add(&handle->vfh);
 	handle->chain = stream->chain;
 	handle->stream = stream;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c63e5b5..1b594c2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -443,7 +443,7 @@ struct uvc_stats_stream {
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
-	struct video_device *vdev;
+	struct video_device vdev;
 	struct uvc_video_chain *chain;
 	atomic_t active;
 
-- 
2.1.4

