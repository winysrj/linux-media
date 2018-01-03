Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbeACUda (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 15:33:30 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Cc: Olivier BRAUN <olivier.braun@stereolabs.com>,
        kieran.bingham@ideasonboard.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jaejoong Kim <climbbb.kim@gmail.com>,
        Baoyou Xie <baoyou.xie@linaro.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jim Lin <jilin@nvidia.com>,
        Daniel Patrick Johnson <teknotus@teknot.us>
Subject: [RFC/RFT PATCH 3/6] uvcvideo: Protect queue internals with helper
Date: Wed,  3 Jan 2018 20:32:53 +0000
Message-Id: <fc4bbb70ea8937f7a09fc404520eec0f908e43d2.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
In-Reply-To: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
References: <cover.67dff754d6d314373ac0a04777b3b1d785fc5dd4.1515010476.git-series.kieran.bingham@ideasonboard.com>
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
 drivers/media/usb/uvc/uvc_queue.c | 34 +++++++++++++++++++++++++++-----
 drivers/media/usb/uvc/uvc_video.c |  7 +------
 drivers/media/usb/uvc/uvcvideo.h  |  2 ++-
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c8d78b2f3de4..0711e3d9ff76 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -399,6 +399,34 @@ void uvc_queue_cancel(struct uvc_video_queue *queue, int disconnect)
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
+	if (!list_empty(&queue->irqqueue))
+		return list_first_entry(&queue->irqqueue, struct uvc_buffer,
+					queue);
+	else
+		return NULL;
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
@@ -415,11 +443,7 @@ struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 
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
index 17a40c9a1fa3..045ac655313c 100644
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
index e4bd3d68a273..f274c685087d 100644
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
