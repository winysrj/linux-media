Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51649 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394AbaJaNy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:54:56 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id BA6892000F
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 14:52:42 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 07/11] uvcvideo: Implement vb2 queue start and stop stream operations
Date: Fri, 31 Oct 2014 15:54:53 +0200
Message-Id: <1414763697-21166-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To work propertly the videobuf2 core code needs to be in charge of
stream start/stop control. Implement the start_streaming and
stop_streaming vb2 operations and move video enable/disable code to
them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 43 +++++++++++++++++++++++++--------------
 drivers/media/usb/uvc/uvc_v4l2.c  | 10 ---------
 2 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 9703655..7582470 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -135,6 +135,29 @@ static void uvc_wait_finish(struct vb2_queue *vq)
 	mutex_lock(&queue->mutex);
 }
 
+static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
+
+	queue->buf_used = 0;
+
+	return uvc_video_enable(stream, 1);
+}
+
+static void uvc_stop_streaming(struct vb2_queue *vq)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
+	unsigned long flags;
+
+	uvc_video_enable(stream, 0);
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	INIT_LIST_HEAD(&queue->irqqueue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
 static struct vb2_ops uvc_queue_qops = {
 	.queue_setup = uvc_queue_setup,
 	.buf_prepare = uvc_buffer_prepare,
@@ -142,6 +165,8 @@ static struct vb2_ops uvc_queue_qops = {
 	.buf_finish = uvc_buffer_finish,
 	.wait_prepare = uvc_wait_prepare,
 	.wait_finish = uvc_wait_finish,
+	.start_streaming = uvc_start_streaming,
+	.stop_streaming = uvc_stop_streaming,
 };
 
 int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
@@ -310,27 +335,15 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
  */
 int uvc_queue_enable(struct uvc_video_queue *queue, int enable)
 {
-	unsigned long flags;
 	int ret;
 
 	mutex_lock(&queue->mutex);
-	if (enable) {
-		ret = vb2_streamon(&queue->queue, queue->queue.type);
-		if (ret < 0)
-			goto done;
 
-		queue->buf_used = 0;
-	} else {
+	if (enable)
+		ret = vb2_streamon(&queue->queue, queue->queue.type);
+	else
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
-		if (ret < 0)
-			goto done;
-
-		spin_lock_irqsave(&queue->irqlock, flags);
-		INIT_LIST_HEAD(&queue->irqqueue);
-		spin_unlock_irqrestore(&queue->irqlock, flags);
-	}
 
-done:
 	mutex_unlock(&queue->mutex);
 	return ret;
 }
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index e8bf4f1..4619fd6 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -531,7 +531,6 @@ static int uvc_v4l2_release(struct file *file)
 
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle)) {
-		uvc_video_enable(stream, 0);
 		uvc_queue_enable(&stream->queue, 0);
 		uvc_free_buffers(&stream->queue);
 	}
@@ -768,14 +767,6 @@ static int uvc_ioctl_streamon(struct file *file, void *fh,
 
 	mutex_lock(&stream->mutex);
 	ret = uvc_queue_enable(&stream->queue, 1);
-	if (ret < 0)
-		goto done;
-
-	ret = uvc_video_enable(stream, 1);
-	if (ret < 0)
-		uvc_queue_enable(&stream->queue, 0);
-
-done:
 	mutex_unlock(&stream->mutex);
 
 	return ret;
@@ -794,7 +785,6 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 		return -EBUSY;
 
 	mutex_lock(&stream->mutex);
-	uvc_video_enable(stream, 0);
 	uvc_queue_enable(&stream->queue, 0);
 	mutex_unlock(&stream->mutex);
 
-- 
2.0.4

