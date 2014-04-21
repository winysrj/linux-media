Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbaDUM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 22/26] omap3isp: Move buffer irqlist to isp_buffer structure
Date: Mon, 21 Apr 2014 14:29:08 +0200
Message-Id: <1398083352-8451-23-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares for the move to videobuf2.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispqueue.h |  2 --
 drivers/media/platform/omap3isp/ispvideo.c | 39 +++++++++++++++---------------
 drivers/media/platform/omap3isp/ispvideo.h |  2 ++
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispqueue.h b/drivers/media/platform/omap3isp/ispqueue.h
index ecf3309..ff18208 100644
--- a/drivers/media/platform/omap3isp/ispqueue.h
+++ b/drivers/media/platform/omap3isp/ispqueue.h
@@ -73,7 +73,6 @@ enum isp_video_buffer_state {
  * @sgt: Scatter gather table (for userspace buffers)
  * @pages: Pages table (for userspace non-VM_PFNMAP buffers)
  * @vbuf: V4L2 buffer
- * @irqlist: List head for insertion into IRQ queue
  * @state: Current buffer state
  * @wait: Wait queue to signal buffer completion
  */
@@ -97,7 +96,6 @@ struct isp_video_buffer {
 
 	/* Touched by the interrupt handler. */
 	struct v4l2_buffer vbuf;
-	struct list_head irqlist;
 	enum isp_video_buffer_state state;
 	wait_queue_head_t wait;
 	dma_addr_t dma;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 85338d3..e1f9983 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -391,7 +391,7 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	}
 
 	empty = list_empty(&video->dmaqueue);
-	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
+	list_add_tail(&buffer->irqlist, &video->dmaqueue);
 
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
@@ -446,7 +446,7 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	struct isp_video_fh *vfh =
 		container_of(queue, struct isp_video_fh, queue);
 	enum isp_pipeline_state state;
-	struct isp_video_buffer *buf;
+	struct isp_buffer *buf;
 	unsigned long flags;
 	struct timespec ts;
 
@@ -456,16 +456,16 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		return NULL;
 	}
 
-	buf = list_first_entry(&video->dmaqueue, struct isp_video_buffer,
+	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
 			       irqlist);
 	list_del(&buf->irqlist);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 
-	buf->vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
+	buf->buffer.vbuf.bytesused = vfh->format.fmt.pix.sizeimage;
 
 	ktime_get_ts(&ts);
-	buf->vbuf.timestamp.tv_sec = ts.tv_sec;
-	buf->vbuf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
+	buf->buffer.vbuf.timestamp.tv_sec = ts.tv_sec;
+	buf->buffer.vbuf.timestamp.tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 
 	/* Do frame number propagation only if this is the output video node.
 	 * Frame number either comes from the CSI receivers or it gets
@@ -474,19 +474,20 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 	 * first, so the input number might lag behind by 1 in some cases.
 	 */
 	if (video == pipe->output && !pipe->do_propagation)
-		buf->vbuf.sequence = atomic_inc_return(&pipe->frame_number);
+		buf->buffer.vbuf.sequence =
+			atomic_inc_return(&pipe->frame_number);
 	else
-		buf->vbuf.sequence = atomic_read(&pipe->frame_number);
+		buf->buffer.vbuf.sequence = atomic_read(&pipe->frame_number);
 
 	/* Report pipeline errors to userspace on the capture device side. */
 	if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && pipe->error) {
-		buf->state = ISP_BUF_STATE_ERROR;
+		buf->buffer.state = ISP_BUF_STATE_ERROR;
 		pipe->error = false;
 	} else {
-		buf->state = ISP_BUF_STATE_DONE;
+		buf->buffer.state = ISP_BUF_STATE_DONE;
 	}
 
-	wake_up(&buf->wait);
+	wake_up(&buf->buffer.wait);
 
 	if (list_empty(&video->dmaqueue)) {
 		if (queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -510,10 +511,10 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 		spin_unlock_irqrestore(&pipe->lock, flags);
 	}
 
-	buf = list_first_entry(&video->dmaqueue, struct isp_video_buffer,
+	buf = list_first_entry(&video->dmaqueue, struct isp_buffer,
 			       irqlist);
-	buf->state = ISP_BUF_STATE_ACTIVE;
-	return to_isp_buffer(buf);
+	buf->buffer.state = ISP_BUF_STATE_ACTIVE;
+	return buf;
 }
 
 /*
@@ -530,14 +531,14 @@ void omap3isp_video_cancel_stream(struct isp_video *video)
 	spin_lock_irqsave(&video->irqlock, flags);
 
 	while (!list_empty(&video->dmaqueue)) {
-		struct isp_video_buffer *buf;
+		struct isp_buffer *buf;
 
 		buf = list_first_entry(&video->dmaqueue,
-				       struct isp_video_buffer, irqlist);
+				       struct isp_buffer, irqlist);
 		list_del(&buf->irqlist);
 
-		buf->state = ISP_BUF_STATE_ERROR;
-		wake_up(&buf->wait);
+		buf->buffer.state = ISP_BUF_STATE_ERROR;
+		wake_up(&buf->buffer.wait);
 	}
 
 	video->error = true;
@@ -567,7 +568,7 @@ void omap3isp_video_resume(struct isp_video *video, int continuous)
 
 	if (!list_empty(&video->dmaqueue)) {
 		buf = list_first_entry(&video->dmaqueue,
-				       struct isp_buffer, buffer.irqlist);
+				       struct isp_buffer, irqlist);
 		video->ops->queue(video, buf);
 		video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_QUEUED;
 	} else {
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 0fa098c..1e3d17a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -127,10 +127,12 @@ static inline int isp_pipeline_ready(struct isp_pipeline *pipe)
 /*
  * struct isp_buffer - ISP buffer
  * @buffer: ISP video buffer
+ * @irqlist: List head for insertion into IRQ queue
  * @isp_addr: MMU mapped address (a.k.a. device address) of the buffer.
  */
 struct isp_buffer {
 	struct isp_video_buffer buffer;
+	struct list_head irqlist;
 	dma_addr_t isp_addr;
 };
 
-- 
1.8.3.2

