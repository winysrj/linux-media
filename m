Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38888 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbeKJCrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 21:47:08 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Tomasz Figa <tfiga@google.com>,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: [PATCH v6 03/10] media: uvcvideo: Protect queue internals with helper
Date: Fri,  9 Nov 2018 17:05:26 +0000
Message-Id: <d4ae5bded282436d0776f733187987c986d4daa3.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
References: <cover.cae3e85316d733416db58566a05055b6f30785a8.1541782862.git-series.kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index fecccb5e7628..adcc4928fae4 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -429,6 +429,33 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
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
@@ -445,11 +472,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 
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
index 7c83185c5b87..16b8348f7ff0 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -727,6 +727,7 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type);
 void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
 struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 					 struct uvc_buffer *buf);
+struct uvc_buffer *uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
 int uvc_queue_mmap(struct uvc_video_queue *queue,
 		   struct vm_area_struct *vma);
 __poll_t uvc_queue_poll(struct uvc_video_queue *queue, struct file *file,
-- 
git-series 0.9.1
