Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:55690 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbeKGGyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2018 01:54:43 -0500
From: Kieran Bingham <kieran@ksquared.org.uk>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v5 3/9] media: uvcvideo: Protect queue internals with helper
Date: Tue,  6 Nov 2018 21:27:14 +0000
Message-Id: <eb1273df174234111a73f2ef6f2a05834175a086.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
References: <cover.dd42d667a7f7505b3639149635ef3a0b1431f280.1541534872.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham@ideasonboard.com>

The URB completion operation obtains the current buffer by reading
directly into the queue internal interface.

Protect this queue abstraction by providing a helper
uvc_queue_get_current_buffer() which can be used by both the decode
task, and the uvc_queue_next_buffer() functions.

Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---

v2:
 - Fix coding style of conditional statements

v3:
 - No change

v4:
 - Rebase on top of linux-media/master (v4.16-rc4, metadata additions)

 drivers/media/usb/uvc/uvc_queue.c | 33 +++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvc_video.c |  6 +-----
 drivers/media/usb/uvc/uvcvideo.h  |  1 +-
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 8964e16f2b22..74f9483911d0 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -430,6 +430,33 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 }
 
+/*
+ * uvc_queue_get_current_buffer: Obtain the current working output buffer
+ *
+ * Buffers may span multiple packets, and even URBs, therefore the active buffer
+ * remains on the queue until the EOF marker.
+ */
+static struct uvc_buffer *
+__uvc_queue_get_current_buffer(struct uvc_video_queue *queue)
+{
+	if (list_empty(&queue->irqqueue))
+		return NULL;
+
+	return list_first_entry(&queue->irqqueue, struct uvc_buffer, queue);
+}
+
+struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue)
+{
+	struct uvc_buffer *nextbuf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	nextbuf = __uvc_queue_get_current_buffer(queue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+
+	return nextbuf;
+}
+
 struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf)
 {
@@ -446,11 +473,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
-	if (!list_empty(&queue->irqqueue))
-		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-					   queue);
-	else
-		nextbuf = NULL;
+	nextbuf = __uvc_queue_get_current_buffer(queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->state = buf->error ? UVC_BUF_STATE_ERROR : UVC_BUF_STATE_DONE;
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 6d4384695964..7a7779e1b466 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1484,11 +1484,7 @@ static void uvc_video_complete(struct urb *urb)
 		return;
 	}
 
-	spin_lock_irqsave(&queue->irqlock, flags);
-	if (!list_empty(&queue->irqqueue))
-		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-				       queue);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	buf = uvc_queue_get_current_buffer(queue);
 
 	if (vb2_qmeta) {
 		spin_lock_irqsave(&qmeta->irqlock, flags);
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f7f8db6fc91a..bdb6d8daedab 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -725,6 +725,7 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type);
 void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
 struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 					 struct uvc_buffer *buf);
+struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
 int uvc_queue_mmap(struct uvc_video_queue *queue,
 		   struct vm_area_struct *vma);
 __poll_t uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
-- 
git-series 0.9.1
