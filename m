Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51711 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaJaPJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:09:51 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id BB464217D8
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:07:36 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 10/10] uvcvideo: Return all buffers to vb2 at stream stop and start failure
Date: Fri, 31 Oct 2014 17:09:51 +0200
Message-Id: <1414768191-4536-11-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768191-4536-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 requires drivers to give back ownership of all queue buffers
in the stop_streaming operation, as well as in the start_streaming
operation in case of failure. Mark all queued buffers as done in the
error or queued state.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
Changes since v2:

- Return buffers on start streaming failure
- Rename __uvc_queue_cancel to uvc_queue_return_buffers
---
 drivers/media/usb/uvc/uvc_queue.c | 45 ++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c295c5c..cc96072 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -42,6 +42,28 @@ uvc_queue_to_stream(struct uvc_video_queue *queue)
 	return container_of(queue, struct uvc_streaming, queue);
 }
 
+/*
+ * Return all queued buffers to videobuf2 in the requested state.
+ *
+ * This function must be called with the queue spinlock held.
+ */
+static void uvc_queue_return_buffers(struct uvc_video_queue *queue,
+			       enum uvc_buffer_state state)
+{
+	enum vb2_buffer_state vb2_state = state == UVC_BUF_STATE_ERROR
+					? VB2_BUF_STATE_ERROR
+					: VB2_BUF_STATE_QUEUED;
+
+	while (!list_empty(&queue->irqqueue)) {
+		struct uvc_buffer *buf = list_first_entry(&queue->irqqueue,
+							  struct uvc_buffer,
+							  queue);
+		list_del(&buf->queue);
+		buf->state = state;
+		vb2_buffer_done(&buf->buf, vb2_state);
+	}
+}
+
 /* -----------------------------------------------------------------------------
  * videobuf2 queue operations
  */
@@ -139,10 +161,20 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
 	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
+	unsigned long flags;
+	int ret;
 
 	queue->buf_used = 0;
 
-	return uvc_video_enable(stream, 1);
+	ret = uvc_video_enable(stream, 1);
+	if (ret == 0)
+		return 0;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	uvc_queue_return_buffers(queue, UVC_BUF_STATE_QUEUED);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	return ret;
 }
 
 static void uvc_stop_streaming(struct vb2_queue *vq)
@@ -154,7 +186,7 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	uvc_video_enable(stream, 0);
 
 	spin_lock_irqsave(&queue->irqlock, flags);
-	INIT_LIST_HEAD(&queue->irqqueue);
+	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
@@ -353,17 +385,10 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
  */
 void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 {
-	struct uvc_buffer *buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&queue->irqlock, flags);
-	while (!list_empty(&queue->irqqueue)) {
-		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-				       queue);
-		list_del(&buf->queue);
-		buf->state = UVC_BUF_STATE_ERROR;
-		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
-	}
+	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_buffer_queue and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
-- 
2.0.4

