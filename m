Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45872 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbDNHVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2015 03:21:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Bin Chen <bin.chen@linaro.org>
Subject: [PATCH] uvcvideo: Implement DMABUF exporter role
Date: Tue, 14 Apr 2015 10:21:52 +0300
Message-Id: <1428996112-9895-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that videobuf2-vmalloc supports exporting buffers, add support for
the DMABUF exporter role by plugging in the videobuf2 ioctl helper.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 12 ++++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c  | 13 +++++++++++++
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index efb9828..61a47bbe 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -272,6 +272,18 @@ int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	return ret;
 }
 
+int uvc_export_buffer(struct uvc_video_queue *queue,
+		      struct v4l2_exportbuffer *exp)
+{
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_expbuf(&queue->queue, exp);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
 int uvc_dequeue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf,
 		       int nonblocking)
 {
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index c4b1ac6..69d0180 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -723,6 +723,18 @@ static int uvc_ioctl_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	return uvc_queue_buffer(&stream->queue, buf);
 }
 
+static int uvc_ioctl_expbuf(struct file *file, void *fh,
+			    struct v4l2_exportbuffer *exp)
+{
+	struct uvc_fh *handle = fh;
+	struct uvc_streaming *stream = handle->stream;
+
+	if (!uvc_has_privileges(handle))
+		return -EBUSY;
+
+	return uvc_export_buffer(&stream->queue, exp);
+}
+
 static int uvc_ioctl_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 {
 	struct uvc_fh *handle = fh;
@@ -1478,6 +1490,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
 	.vidioc_reqbufs = uvc_ioctl_reqbufs,
 	.vidioc_querybuf = uvc_ioctl_querybuf,
 	.vidioc_qbuf = uvc_ioctl_qbuf,
+	.vidioc_expbuf = uvc_ioctl_expbuf,
 	.vidioc_dqbuf = uvc_ioctl_dqbuf,
 	.vidioc_create_bufs = uvc_ioctl_create_bufs,
 	.vidioc_streamon = uvc_ioctl_streamon,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2bd895c..180efb2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -641,6 +641,8 @@ extern int uvc_create_buffers(struct uvc_video_queue *queue,
 		struct v4l2_create_buffers *v4l2_cb);
 extern int uvc_queue_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
+extern int uvc_export_buffer(struct uvc_video_queue *queue,
+		struct v4l2_exportbuffer *exp);
 extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf, int nonblocking);
 extern int uvc_queue_streamon(struct uvc_video_queue *queue,
-- 
2.0.5

