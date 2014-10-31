Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51648 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760633AbaJaNy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:54:58 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id C9FBF217D8
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 14:52:43 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 10/11] uvcvideo: Rename and split uvc_queue_enable to uvc_queue_stream(on|off)
Date: Fri, 31 Oct 2014 15:54:56 +0200
Message-Id: <1414763697-21166-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings the function name in line with the V4L2 API terminology and
allows removing the duplicate queue type check.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c |  3 ++-
 drivers/media/usb/uvc/uvc_queue.c  | 53 ++++++++++++++++----------------------
 drivers/media/usb/uvc/uvc_v4l2.c   | 10 ++-----
 drivers/media/usb/uvc/uvcvideo.h   |  5 +++-
 4 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index a0b163a..71f85ed 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2040,7 +2040,8 @@ static int __uvc_resume(struct usb_interface *intf, int reset)
 		if (stream->intf == intf) {
 			ret = uvc_video_resume(stream, reset);
 			if (ret < 0)
-				uvc_queue_enable(&stream->queue, 0);
+				uvc_queue_streamoff(&stream->queue,
+						    stream->queue.queue.type);
 			return ret;
 		}
 	}
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 5c11de0..c295c5c 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -263,6 +263,28 @@ int uvc_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 	return ret;
 }
 
+int uvc_queue_streamon(struct uvc_video_queue *queue, enum v4l2_buf_type type)
+{
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_streamon(&queue->queue, type);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
+int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
+{
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_streamoff(&queue->queue, type);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
 int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
 	int ret;
@@ -318,37 +340,6 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
 }
 
 /*
- * Enable or disable the video buffers queue.
- *
- * The queue must be enabled before starting video acquisition and must be
- * disabled after stopping it. This ensures that the video buffers queue
- * state can be properly initialized before buffers are accessed from the
- * interrupt handler.
- *
- * Enabling the video queue returns -EBUSY if the queue is already enabled.
- *
- * Disabling the video queue cancels the queue and removes all buffers from
- * the main queue.
- *
- * This function can't be called from interrupt context. Use
- * uvc_queue_cancel() instead.
- */
-int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
-{
-	int ret;
-
-	mutex_lock(&queue->mutex);
-
-	if (enable)
-		ret = vb2_streamon(&queue->queue, queue->queue.type);
-	else
-		ret = vb2_streamoff(&queue->queue, queue->queue.type);
-
-	mutex_unlock(&queue->mutex);
-	return ret;
-}
-
-/*
  * Cancel the video buffers queue.
  *
  * Cancelling the queue marks all buffers on the irq queue as erroneous,
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 5ba023b..9c5cbcf 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -757,14 +757,11 @@ static int uvc_ioctl_streamon(struct file *file, void *fh,
 	struct uvc_streaming *stream = handle->stream;
 	int ret;
 
-	if (type != stream->type)
-		return -EINVAL;
-
 	if (!uvc_has_privileges(handle))
 		return -EBUSY;
 
 	mutex_lock(&stream->mutex);
-	ret = uvc_queue_enable(&stream->queue, 1);
+	ret = uvc_queue_streamon(&stream->queue, type);
 	mutex_unlock(&stream->mutex);
 
 	return ret;
@@ -776,14 +773,11 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 	struct uvc_fh *handle = fh;
 	struct uvc_streaming *stream = handle->stream;
 
-	if (type != stream->type)
-		return -EINVAL;
-
 	if (!uvc_has_privileges(handle))
 		return -EBUSY;
 
 	mutex_lock(&stream->mutex);
-	uvc_queue_enable(&stream->queue, 0);
+	uvc_queue_streamoff(&stream->queue, type);
 	mutex_unlock(&stream->mutex);
 
 	return 0;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2dc247a..f0a04b5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -634,7 +634,10 @@ extern int uvc_queue_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
 extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf, int nonblocking);
-extern int uvc_queue_enable(struct uvc_video_queue *queue, int enable);
+extern int uvc_queue_streamon(struct uvc_video_queue *queue,
+			      enum v4l2_buf_type type);
+extern int uvc_queue_streamoff(struct uvc_video_queue *queue,
+			       enum v4l2_buf_type type);
 extern void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
 extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf);
-- 
2.0.4

