Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51710 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933817AbaJaPJt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:49 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id C55D1217D7
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:35 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 07/10] uvcvideo: Don't stop the stream twice at file handle release
Date: Fri, 31 Oct 2014 17:09:48 +0200
Message-Id: <1414768191-4536-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When releasing the file handle the driver calls the vb2_queue_release
which turns the stream off. There's thus no need to turn the stream off
explicitly beforehand.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 14 +++++++-------
 drivers/media/usb/uvc/uvc_v4l2.c  |  6 ++----
 drivers/media/usb/uvc/uvcvideo.h  |  2 +-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 7582470..708478f 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -194,6 +194,13 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	return 0;
 }
 
+void uvc_queue_release(struct uvc_video_queue *queue)
+{
+	mutex_lock(&queue->mutex);
+	vb2_queue_release(&queue->queue);
+	mutex_unlock(&queue->mutex);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 queue operations
  */
@@ -210,13 +217,6 @@ int uvc_alloc_buffers(struct uvc_video_queue *queue,
 	return ret ? ret : rb->count;
 }
 
-void uvc_free_buffers(struct uvc_video_queue *queue)
-{
-	mutex_lock(&queue->mutex);
-	vb2_queue_release(&queue->queue);
-	mutex_unlock(&queue->mutex);
-}
-
 int uvc_query_buffer(struct uvc_video_queue *queue, struct v4l2_buffer *buf)
 {
 	int ret;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 4619fd6..1b6b6db 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -530,10 +530,8 @@ static int uvc_v4l2_release(struct file *file)
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
 
 	/* Only free resources if this is a privileged handle. */
-	if (uvc_has_privileges(handle)) {
-		uvc_queue_enable(&stream->queue, 0);
-		uvc_free_buffers(&stream->queue);
-	}
+	if (uvc_has_privileges(handle))
+		uvc_queue_release(&stream->queue);
 
 	/* Release the file handle. */
 	uvc_dismiss_privileges(handle);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 53db7ed..344aede 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -623,9 +623,9 @@ extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
 /* Video buffers queue management. */
 extern int uvc_queue_init(struct uvc_video_queue *queue,
 		enum v4l2_buf_type type, int drop_corrupted);
+extern void uvc_queue_release(struct uvc_video_queue *queue);
 extern int uvc_alloc_buffers(struct uvc_video_queue *queue,
 		struct v4l2_requestbuffers *rb);
-extern void uvc_free_buffers(struct uvc_video_queue *queue);
 extern int uvc_query_buffer(struct uvc_video_queue *queue,
 		struct v4l2_buffer *v4l2_buf);
 extern int uvc_create_buffers(struct uvc_video_queue *queue,
-- 
2.0.4

