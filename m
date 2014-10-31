Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51711 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbaJaPJr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:47 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id D962C217D4
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:34 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 04/10] uvcvideo: Separate video and queue enable/disable operations
Date: Fri, 31 Oct 2014 17:09:45 +0200
Message-Id: <1414768191-4536-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to make use of the vb2 queue start/stop_streaming operations
the video and queue enable/disable operations need to be split, as the
vb2 queue will need to enable and disable video instead of the other way
around.

Also move buffer queue disable outside of uvc_video_resume() to remove
all queue disable operations out of uvc_video.c.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 ++++++++++++----
 drivers/media/usb/uvc/uvc_v4l2.c   | 15 ++++++++++++---
 drivers/media/usb/uvc/uvc_video.c  | 22 ++--------------------
 3 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 30163432..ab1e2fd 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1734,6 +1734,11 @@ static int uvc_register_video(struct uvc_device *dev,
 	struct video_device *vdev;
 	int ret;
 
+	/* Initialize the video buffers queue. */
+	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
+	if (ret)
+		return ret;
+
 	/* Initialize the streaming interface with default streaming
 	 * parameters.
 	 */
@@ -2008,14 +2013,13 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 {
 	struct uvc_device *dev = usb_get_intfdata(intf);
 	struct uvc_streaming *stream;
+	int ret = 0;
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
 		intf->cur_altsetting->desc.bInterfaceNumber);
 
 	if (intf->cur_altsetting->desc.bInterfaceSubClass ==
 	    UVC_SC_VIDEOCONTROL) {
-		int ret = 0;
-
 		if (reset) {
 			ret = uvc_ctrl_restore_values(dev);
 			if (ret < 0)
@@ -2031,8 +2035,12 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 	}
 
 	list_for_each_entry(stream, &dev->streams, list) {
-		if (stream->intf == intf)
-			return uvc_video_resume(stream, reset);
+		if (stream->intf == intf) {
+			ret = uvc_video_resume(stream, reset);
+			if (ret < 0)
+				uvc_queue_enable(&stream->queue, 0);
+			return ret;
+		}
 	}
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index a16fe21..e8bf4f1 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -532,6 +532,7 @@ static int uvc_v4l2_release(struct file *file)
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle)) {
 		uvc_video_enable(stream, 0);
+		uvc_queue_enable(&stream->queue, 0);
 		uvc_free_buffers(&stream->queue);
 	}
 
@@ -766,7 +767,15 @@ static int uvc_ioctl_streamon(struct file *file, void *fh,
 		return -EBUSY;
 
 	mutex_lock(&stream->mutex);
+	ret = uvc_queue_enable(&stream->queue, 1);
+	if (ret < 0)
+		goto done;
+
 	ret = uvc_video_enable(stream, 1);
+	if (ret < 0)
+		uvc_queue_enable(&stream->queue, 0);
+
+done:
 	mutex_unlock(&stream->mutex);
 
 	return ret;
@@ -777,7 +786,6 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 {
 	struct uvc_fh *handle = fh;
 	struct uvc_streaming *stream = handle->stream;
-	int ret;
 
 	if (type != stream->type)
 		return -EINVAL;
@@ -786,10 +794,11 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 		return -EBUSY;
 
 	mutex_lock(&stream->mutex);
-	ret = uvc_video_enable(stream, 0);
+	uvc_video_enable(stream, 0);
+	uvc_queue_enable(&stream->queue, 0);
 	mutex_unlock(&stream->mutex);
 
-	return ret;
+	return 0;
 }
 
 static int uvc_ioctl_enum_input(struct file *file, void *fh,
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b9c7dee..9637e8b 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1735,19 +1735,13 @@ int uvc_video_resume(struct uvc_streaming *stream, int reset)
 	uvc_video_clock_reset(stream);
 
 	ret = uvc_commit_video(stream, &stream->ctrl);
-	if (ret < 0) {
-		uvc_queue_enable(&stream->queue, 0);
+	if (ret < 0)
 		return ret;
-	}
 
 	if (!uvc_queue_streaming(&stream->queue))
 		return 0;
 
-	ret = uvc_init_video(stream, GFP_NOIO);
-	if (ret < 0)
-		uvc_queue_enable(&stream->queue, 0);
-
-	return ret;
+	return uvc_init_video(stream, GFP_NOIO);
 }
 
 /* ------------------------------------------------------------------------
@@ -1779,11 +1773,6 @@ int uvc_video_init(struct uvc_streaming *stream)
 
 	atomic_set(&stream->active, 0);
 
-	/* Initialize the video buffers queue. */
-	ret = uvc_queue_init(&stream->queue, stream->type, !uvc_no_drop_param);
-	if (ret)
-		return ret;
-
 	/* Alternate setting 0 should be the default, yet the XBox Live Vision
 	 * Cam (and possibly other devices) crash or otherwise misbehave if
 	 * they don't receive a SET_INTERFACE request before any other video
@@ -1890,7 +1879,6 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 			usb_clear_halt(stream->dev->udev, pipe);
 		}
 
-		uvc_queue_enable(&stream->queue, 0);
 		uvc_video_clock_cleanup(stream);
 		return 0;
 	}
@@ -1899,10 +1887,6 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 	if (ret < 0)
 		return ret;
 
-	ret = uvc_queue_enable(&stream->queue, 1);
-	if (ret < 0)
-		goto error_queue;
-
 	/* Commit the streaming parameters. */
 	ret = uvc_commit_video(stream, &stream->ctrl);
 	if (ret < 0)
@@ -1917,8 +1901,6 @@ int uvc_video_enable(struct uvc_streaming *stream, int enable)
 error_video:
 	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 error_commit:
-	uvc_queue_enable(&stream->queue, 0);
-error_queue:
 	uvc_video_clock_cleanup(stream);
 
 	return ret;
-- 
2.0.4

