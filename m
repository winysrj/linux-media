Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52434 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaDCWiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 18:38:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 21/25] omap3isp: Move queue irqlock to isp_video structure
Date: Fri,  4 Apr 2014 00:39:51 +0200
Message-Id: <1396564795-27192-22-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396564795-27192-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares for the move to videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c      |  6 +++---
 drivers/media/platform/omap3isp/ispqueue.c | 13 +------------
 drivers/media/platform/omap3isp/ispqueue.h |  5 +----
 drivers/media/platform/omap3isp/ispvideo.c | 21 +++++++++++++--------
 drivers/media/platform/omap3isp/ispvideo.h |  1 +
 5 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index af8bd21..4395027 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1399,14 +1399,14 @@ int omap3isp_module_sync_idle(struct media_entity *me, wait_queue_head_t *wait,
 	if (isp_pipeline_is_last(me)) {
 		struct isp_video *video = pipe->output;
 		unsigned long flags;
-		spin_lock_irqsave(&video->queue->irqlock, flags);
+		spin_lock_irqsave(&video->irqlock, flags);
 		if (video->dmaqueue_flags & ISP_VIDEO_DMAQUEUE_UNDERRUN) {
-			spin_unlock_irqrestore(&video->queue->irqlock, flags);
+			spin_unlock_irqrestore(&video->irqlock, flags);
 			atomic_set(stopping, 0);
 			smp_mb();
 			return 0;
 		}
-		spin_unlock_irqrestore(&video->queue->irqlock, flags);
+		spin_unlock_irqrestore(&video->irqlock, flags);
 		if (!wait_event_timeout(*wait, !atomic_read(stopping),
 					msecs_to_jiffies(1000))) {
 			atomic_set(stopping, 0);
diff --git a/drivers/media/platform/omap3isp/ispqueue.c b/drivers/media/platform/omap3isp/ispqueue.c
index dcd9446..77afb63 100644
--- a/drivers/media/platform/omap3isp/ispqueue.c
+++ b/drivers/media/platform/omap3isp/ispqueue.c
@@ -660,7 +660,6 @@ int omap3isp_video_queue_init(struct isp_video_queue *queue,
 			      struct device *dev, unsigned int bufsize)
 {
 	INIT_LIST_HEAD(&queue->queue);
-	spin_lock_init(&queue->irqlock);
 
 	queue->type = type;
 	queue->ops = ops;
@@ -761,7 +760,6 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 			      struct v4l2_buffer *vbuf)
 {
 	struct isp_video_buffer *buf;
-	unsigned long flags;
 	int ret;
 
 	if (vbuf->type != queue->type)
@@ -801,11 +799,8 @@ int omap3isp_video_queue_qbuf(struct isp_video_queue *queue,
 	buf->state = ISP_BUF_STATE_QUEUED;
 	list_add_tail(&buf->stream, &queue->queue);
 
-	if (queue->streaming) {
-		spin_lock_irqsave(&queue->irqlock, flags);
+	if (queue->streaming)
 		queue->ops->buffer_queue(buf);
-		spin_unlock_irqrestore(&queue->irqlock, flags);
-	}
 
 	return 0;
 }
@@ -862,17 +857,14 @@ int omap3isp_video_queue_dqbuf(struct isp_video_queue *queue,
 int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
 {
 	struct isp_video_buffer *buf;
-	unsigned long flags;
 
 	if (queue->streaming)
 		return 0;
 
 	queue->streaming = 1;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
 	list_for_each_entry(buf, &queue->queue, stream)
 		queue->ops->buffer_queue(buf);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	return 0;
 }
@@ -890,7 +882,6 @@ int omap3isp_video_queue_streamon(struct isp_video_queue *queue)
 void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
 {
 	struct isp_video_buffer *buf;
-	unsigned long flags;
 	unsigned int i;
 
 	if (!queue->streaming)
@@ -898,7 +889,6 @@ void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
 
 	queue->streaming = 0;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
 	for (i = 0; i < queue->count; ++i) {
 		buf = queue->buffers[i];
 
@@ -907,7 +897,6 @@ void omap3isp_video_queue_streamoff(struct isp_video_queue *queue)
 
 		buf->state = ISP_BUF_STATE_IDLE;
 	}
-	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	INIT_LIST_HEAD(&queue->queue);
 }
diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index ecff055..ecf3309 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -114,8 +114,7 @@ struct isp_video_buffer {
  *	the userspace memory address for a USERPTR buffer, with the queue lock
  *	held. Drivers should perform device-specific buffer preparation (such as
  *	mapping the buffer memory in an IOMMU). This operation is optional.
- * @buffer_queue: Called when a buffer is being added to the queue with the
- *	queue irqlock spinlock held.
+ * @buffer_queue: Called when a buffer is being added.
  */
 struct isp_video_queue_operations {
 	void (*queue_prepare)(struct isp_video_queue *queue,
@@ -132,7 +131,6 @@ struct isp_video_queue_operations {
  * @bufsize: Size of a driver-specific buffer object
  * @count: Number of currently allocated buffers
  * @buffers: ISP video buffers
- * @irqlock: Spinlock to protect access to the IRQ queue
  * @streaming: Queue state, indicates whether the queue is streaming
  * @queue: List of all queued buffers
  */
@@ -144,7 +142,6 @@ struct isp_video_queue {
 
 	unsigned int count;
 	struct isp_video_buffer *buffers[ISP_VIDEO_MAX_BUFFERS];
-	spinlock_t irqlock;
 
 	unsigned int streaming:1;
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 12b0f8c..85338d3 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -381,15 +381,20 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	unsigned int empty;
 	unsigned int start;
 
+	spin_lock_irqsave(&video->irqlock, flags);
+
 	if (unlikely(video->error)) {
 		buf->state = ISP_BUF_STATE_ERROR;
 		wake_up(&buf->wait);
+		spin_unlock_irqrestore(&video->irqlock, flags);
 		return;
 	}
 
 	empty = list_empty(&video->dmaqueue);
 	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
 
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
 	if (empty) {
 		if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			state = ISP_PIPELINE_QUEUE_OUTPUT;
@@ -445,16 +450,16 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	unsigned long flags;
 	struct timespec ts;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irqsave(&video->irqlock, flags);
 	if (WARN_ON(list_empty(&video->dmaqueue))) {
-		spin_unlock_irqrestore(&queue->irqlock, flags);
+		spin_unlock_irqrestore(&video->irqlock, flags);
 		return NULL;
 	}
 
 	buf = list_first_entry(&video->dmaqueue, struct isp_video_buffer,
 			       irqlist);
 	list_del(&buf->irqlist);
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irqrestore(&video->irqlock, flags);
 
 	buf->vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
 
@@ -520,10 +525,9 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
  */
 void omap3isp_video_cancel_stream(struct isp_video *video)
 {
-	struct isp_video_queue *queue = video->queue;
 	unsigned long flags;
 
-	spin_lock_irqsave(&queue->irqlock, flags);
+	spin_lock_irqsave(&video->irqlock, flags);
 
 	while (!list_empty(&video->dmaqueue)) {
 		struct isp_video_buffer *buf;
@@ -538,7 +542,7 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 
 	video->error = true;
 
-	spin_unlock_irqrestore(&queue->irqlock, flags);
+	spin_unlock_irqrestore(&video->irqlock, flags);
 }
 
 /*
@@ -1039,10 +1043,10 @@ isp_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 					      ISP_PIPELINE_STREAM_CONTINUOUS);
 		if (ret < 0)
 			goto err_set_stream;
-		spin_lock_irqsave(&video->queue->irqlock, flags);
+		spin_lock_irqsave(&video->irqlock, flags);
 		if (list_empty(&video->dmaqueue))
 			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
-		spin_unlock_irqrestore(&video->queue->irqlock, flags);
+		spin_unlock_irqrestore(&video->irqlock, flags);
 	}
 
 	video->streaming = 1;
@@ -1324,6 +1328,7 @@ int omap3isp_video_init(struct isp_video *video, const char *name)
 	spin_lock_init(&video->pipe.lock);
 	mutex_init(&video->stream_lock);
 	mutex_init(&video->queue_lock);
+	spin_lock_init(&video->irqlock);
 
 	/* Initialize the video device. */
 	if (video->ops == NULL)
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 254e7d2..0fa098c 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -183,6 +183,7 @@ struct isp_video {
 	/* Video buffers queue */
 	struct isp_video_queue *queue;
 	struct mutex queue_lock;	/* protects the queue */
+	spinlock_t irqlock;		/* protects dmaqueue */
 	struct list_head dmaqueue;
 	enum isp_video_dmaqueue_flags dmaqueue_flags;
 
-- 
1.8.3.2

