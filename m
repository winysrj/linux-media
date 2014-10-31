Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51649 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264AbaJaNy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:54:58 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 2E893217D3
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 14:52:44 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 11/11] uvcvideo: Give back all buffers to userspace when stopping the stream
Date: Fri, 31 Oct 2014 15:54:57 +0200
Message-Id: <1414763697-21166-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 requires drivers to give back ownership of all queue buffers
in the stop_streaming operation. Mark all queued buffers as done in the
error state.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c295c5c..0ad442c 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -42,6 +42,23 @@ uvc_queue_to_stream(struct uvc_video_queue *queue)
 	return container_of(queue, struct uvc_streaming, queue);
 }
 
+/*
+ * Give back all queued buffers to videobuf2 and userspace in the error state.
+ *
+ * This function must be called with the queue spinlock held.
+ */
+static void __uvc_queue_cancel(struct uvc_video_queue *queue)
+{
+	while (!list_empty(&queue->irqqueue)) {
+		struct uvc_buffer *buf = list_first_entry(&queue->irqqueue,
+							  struct uvc_buffer,
+							  queue);
+		list_del(&buf->queue);
+		buf->state = UVC_BUF_STATE_ERROR;
+		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
+	}
+}
+
 /* -----------------------------------------------------------------------------
  * videobuf2 queue operations
  */
@@ -154,7 +171,7 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	uvc_video_enable(stream, 0);
 
 	spin_lock_irqsave(&queue->irqlock, flags);
-	INIT_LIST_HEAD(&queue->irqqueue);
+	__uvc_queue_cancel(queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
@@ -353,17 +370,10 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
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
+	__uvc_queue_cancel(queue);
 	/* This must be protected by the irqlock spinlock to avoid race
 	 * conditions between uvc_buffer_queue and the disconnection event that
 	 * could result in an interruptible wait in uvc_dequeue_buffer. Do not
-- 
2.0.4

