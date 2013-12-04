Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3LDA4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:42 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C7594366B0
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 24/25] v4l: omap4iss: Cancel streaming when a fatal error occurs
Date: Wed,  4 Dec 2013 01:56:24 +0100
Message-Id: <1386118585-12449-25-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a fatal error that prevents any further video streaming occurs in a
pipeline, all queued buffers must be marked as erroneous and new buffers
must be prevented from being queued. Implement this behaviour with a new
omap4iss_pipeline_cancel_stream() function that can be used by
submodules to cancel streaming.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c         | 17 ++++++++++
 drivers/staging/media/omap4iss/iss.h         |  1 +
 drivers/staging/media/omap4iss/iss_resizer.c |  2 +-
 drivers/staging/media/omap4iss/iss_video.c   | 47 +++++++++++++++++++++++++++-
 drivers/staging/media/omap4iss/iss_video.h   |  4 ++-
 5 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 5ad604d..61fbfcd 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -693,6 +693,23 @@ int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
 }
 
 /*
+ * omap4iss_pipeline_cancel_stream - Cancel stream on a pipeline
+ * @pipe: ISS pipeline
+ *
+ * Cancelling a stream mark all buffers on all video nodes in the pipeline as
+ * erroneous and makes sure no new buffer can be queued. This function is called
+ * when a fatal error that prevents any further operation on the pipeline
+ * occurs.
+ */
+void omap4iss_pipeline_cancel_stream(struct iss_pipeline *pipe)
+{
+	if (pipe->input)
+		omap4iss_video_cancel_stream(pipe->input);
+	if (pipe->output)
+		omap4iss_video_cancel_stream(pipe->output);
+}
+
+/*
  * iss_pipeline_is_last - Verify if entity has an enabled link to the output
  *			  video node
  * @me: ISS module's media entity
diff --git a/drivers/staging/media/omap4iss/iss.h b/drivers/staging/media/omap4iss/iss.h
index 3c1e920..346db92 100644
--- a/drivers/staging/media/omap4iss/iss.h
+++ b/drivers/staging/media/omap4iss/iss.h
@@ -131,6 +131,7 @@ int omap4iss_module_sync_is_stopping(wait_queue_head_t *wait,
 
 int omap4iss_pipeline_set_stream(struct iss_pipeline *pipe,
 				 enum iss_pipeline_stream_state state);
+void omap4iss_pipeline_cancel_stream(struct iss_pipeline *pipe);
 
 void omap4iss_configure_bridge(struct iss_device *iss,
 			       enum ipipeif_input_entity input);
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 4673c05..c6225d8 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -312,7 +312,7 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 		dev_dbg(iss->dev, "RSZ Err: FIFO_IN_BLK:%d, FIFO_OVF:%d\n",
 			events & ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR ? 1 : 0,
 			events & ISP5_IRQ_RSZ_FIFO_OVF ? 1 : 0);
-		pipe->error = true;
+		omap4iss_pipeline_cancel_stream(pipe);
 	}
 
 	if (omap4iss_module_sync_is_stopping(&resizer->wait,
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 9106487..482b72f 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -328,6 +328,15 @@ static int iss_video_buf_prepare(struct vb2_buffer *vb)
 	if (vb2_plane_size(vb, 0) < size)
 		return -ENOBUFS;
 
+	/* Refuse to prepare the buffer is the video node has registered an
+	 * error. We don't need to take any lock here as the operation is
+	 * inherently racy. The authoritative check will be performed in the
+	 * queue handler, which can't return an error, this check is just a best
+	 * effort to notify userspace as early as possible.
+	 */
+	if (unlikely(video->error))
+		return -EIO;
+
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED(addr, 32)) {
 		dev_dbg(video->iss->dev,
@@ -346,12 +355,20 @@ static void iss_video_buf_queue(struct vb2_buffer *vb)
 	struct iss_video *video = vfh->video;
 	struct iss_buffer *buffer = container_of(vb, struct iss_buffer, vb);
 	struct iss_pipeline *pipe = to_iss_pipeline(&video->video.entity);
-	unsigned int empty;
 	unsigned long flags;
+	bool empty;
 
 	spin_lock_irqsave(&video->qlock, flags);
+
+	if (unlikely(video->error)) {
+		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		spin_unlock_irqrestore(&video->qlock, flags);
+		return;
+	}
+
 	empty = list_empty(&video->dmaqueue);
 	list_add_tail(&buffer->list, &video->dmaqueue);
+
 	spin_unlock_irqrestore(&video->qlock, flags);
 
 	if (empty) {
@@ -471,6 +488,33 @@ struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video)
 	return buf;
 }
 
+/*
+ * omap4iss_video_cancel_stream - Cancel stream on a video node
+ * @video: ISS video object
+ *
+ * Cancelling a stream mark all buffers on the video node as erroneous and makes
+ * sure no new buffer can be queued.
+ */
+void omap4iss_video_cancel_stream(struct iss_video *video)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&video->qlock, flags);
+
+	while (!list_empty(&video->dmaqueue)) {
+		struct iss_buffer *buf;
+
+		buf = list_first_entry(&video->dmaqueue, struct iss_buffer,
+				       list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	video->error = true;
+
+	spin_unlock_irqrestore(&video->qlock, flags);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 ioctls
  */
@@ -852,6 +896,7 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	video->queue = &vfh->queue;
 	INIT_LIST_HEAD(&video->dmaqueue);
 	spin_lock_init(&video->qlock);
+	video->error = false;
 	atomic_set(&pipe->frame_number, -1);
 
 	ret = vb2_streamon(&vfh->queue, type);
diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 73e1a34..878e4a3 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -163,10 +163,11 @@ struct iss_video {
 	/* Pipeline state */
 	struct iss_pipeline pipe;
 	struct mutex stream_lock;	/* pipeline and stream states */
+	bool error;
 
 	/* Video buffers queue */
 	struct vb2_queue *queue;
-	spinlock_t qlock;	/* Spinlock for dmaqueue */
+	spinlock_t qlock;		/* protects dmaqueue and error */
 	struct list_head dmaqueue;
 	enum iss_video_dmaqueue_flags dmaqueue_flags;
 	struct vb2_alloc_ctx *alloc_ctx;
@@ -194,6 +195,7 @@ int omap4iss_video_register(struct iss_video *video,
 			    struct v4l2_device *vdev);
 void omap4iss_video_unregister(struct iss_video *video);
 struct iss_buffer *omap4iss_video_buffer_next(struct iss_video *video);
+void omap4iss_video_cancel_stream(struct iss_video *video);
 struct media_pad *omap4iss_video_remote_pad(struct iss_video *video);
 
 const struct iss_format_info *
-- 
1.8.3.2

