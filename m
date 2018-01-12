Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:14578
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754569AbeALJT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 04:19:27 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [RFT PATCH v3 3/6] uvcvideo: Protect queue internals with helper
Date: Fri, 12 Jan 2018 09:19:26 +0000 (UTC)
Message-Id: <0f14323f98ca64dd828514577167dc232a33a8ad.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
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
---
 drivers/media/usb/uvc/uvc_queue.c | 33 +++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvc_video.c |  7 +------
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++-
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c8d78b2f3de4..4a581d631525 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -399,6 +399,33 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
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
@@ -415,11 +442,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 
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
index 92bd0952a66e..3878bec3276e 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1322,7 +1322,6 @@ static void uvc_video_complete(struct urb *urb)
 	struct uvc_streaming *stream = uvc_urb->stream;
 	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
-	unsigned long flags;
 	int ret;
 
 	switch (urb->status) {
@@ -1343,11 +1342,7 @@ static void uvc_video_complete(struct urb *urb)
 		return;
 	}
 
-	spin_lock_irqsave(&queue->irqlock, flags);
-	if (!list_empty(&queue->irqqueue))
-		buf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-				       queue);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	buf = uvc_queue_get_current_buffer(queue);
 
 	stream->decode(uvc_urb, buf);
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 81a9a419a423..5caa1f4de3cb 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -692,6 +692,8 @@ extern int uvc_queue_streamon(struct uvc_video_queue *queue,
 extern int uvc_queue_streamoff(struct uvc_video_queue *queue,
 			       enum v4l2_buf_type type);
 extern void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect);
+extern struct uvc_buffer *
+		uvc_queue_get_current_buffer(struct uvc_video_queue *queue);
 extern struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 		struct uvc_buffer *buf);
 extern int uvc_queue_mmap(struct uvc_video_queue *queue,
-- 
git-series 0.9.1
