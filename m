Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41972 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbaBRO0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 09:26:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 3/3] uvcvideo: Enable VIDIOC_CREATE_BUFS
Date: Tue, 18 Feb 2014 15:27:49 +0100
Message-Id: <1392733669-5281-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1392733669-5281-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <p.zabel@pengutronix.de>

This patch enables the ioctl to create additional buffers on the
videobuf2 capture queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 12 ++++++++++++
 drivers/media/usb/uvc/uvc_v4l2.c  | 10 ++++++++++
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index d46dd70..ff7be97 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -198,6 +198,18 @@ int uvc_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 	return ret;
 }
 
+int uvc_create_buffers(struct uvc_video_queue *queue,
+		       struct v4l2_create_buffers *cb)
+{
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = vb2_create_bufs(&queue->queue, cb);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
 int uvc_queue_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
 	int ret;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3afff92..fa58131 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -1000,6 +1000,16 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		return uvc_query_buffer(&stream->queue, buf);
 	}
 
+	case VIDIOC_CREATE_BUFS:
+	{
+		struct v4l2_create_buffers *cb = arg;
+
+		if (!uvc_has_privileges(handle))
+			return -EBUSY;
+
+		return uvc_create_buffers(&stream->queue, cb);
+	}
+
 	case VIDIOC_QBUF:
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 6173632..143d5e5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -614,6 +614,8 @@ extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
 extern void uvc_free_buffers(struct uvc_video_queue *queue);
 extern int uvc_query_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
+extern int uvc_create_buffers(struct uvc_video_queue *queue,
+		struct v4l2_create_buffers *v4l2_cb);
 extern int uvc_queue_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
 extern int uvc_dequeue_buffer(struct uvc_video_queue *queue,
-- 
1.8.3.2

