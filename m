Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab3LXMcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 07:32:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] omap3isp: Cancel streaming when a fatal error occurs
Date: Tue, 24 Dec 2013 13:32:42 +0100
Message-Id: <1387888364-21631-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a fatal error that prevents any further video streaming occurs in a
pipeline, all queued buffers must be marked as erroneous and new buffers
must be prevented from being queued. Implement this behaviour with a new
omap3isp_pipeline_cancel_stream() function that can be used by
submodules to cancel streaming.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c      | 17 +++++++++++
 drivers/media/platform/omap3isp/isp.h      |  1 +
 drivers/media/platform/omap3isp/ispvideo.c | 46 ++++++++++++++++++++++++++++++
 drivers/media/platform/omap3isp/ispvideo.h |  2 ++
 4 files changed, 66 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index bb4e0a7..7e09c1d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1057,6 +1057,23 @@ int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 }
 
 /*
+ * omap3isp_pipeline_cancel_stream - Cancel stream on a pipeline
+ * @pipe: ISP pipeline
+ *
+ * Cancelling a stream mark all buffers on all video nodes in the pipeline as
+ * erroneous and makes sure no new buffer can be queued. This function is called
+ * when a fatal error that prevents any further operation on the pipeline
+ * occurs.
+ */
+void omap3isp_pipeline_cancel_stream(struct isp_pipeline *pipe)
+{
+	if (pipe->input)
+		omap3isp_video_cancel_stream(pipe->input);
+	if (pipe->output)
+		omap3isp_video_cancel_stream(pipe->output);
+}
+
+/*
  * isp_pipeline_resume - Resume streaming on a pipeline
  * @pipe: ISP pipeline
  *
diff --git a/drivers/media/platform/omap3isp/isp.h b/drivers/media/platform/omap3isp/isp.h
index 72685ad..5b91f86 100644
--- a/drivers/media/platform/omap3isp/isp.h
+++ b/drivers/media/platform/omap3isp/isp.h
@@ -236,6 +236,7 @@ int omap3isp_module_sync_is_stopping(wait_queue_head_t *wait,
 
 int omap3isp_pipeline_set_stream(struct isp_pipeline *pipe,
 				 enum isp_pipeline_stream_state state);
+void omap3isp_pipeline_cancel_stream(struct isp_pipeline *pipe);
 void omap3isp_configure_bridge(struct isp_device *isp,
 			       enum ccdc_input_entity input,
 			       const struct isp_parallel_platform_data *pdata,
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 3953aec..856fdf5 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -411,6 +411,15 @@ static int isp_video_buffer_prepare(struct isp_video_buffer *buf)
 	struct isp_video *video = vfh->video;
 	unsigned long addr;
 
+	/* Refuse to prepare the buffer is the video node has registered an
+	 * error. We don't need to take any lock here as the operation is
+	 * inherently racy. The authoritative check will be performed in the
+	 * queue handler, which can't return an error, this check is just a best
+	 * effort to notify userspace as early as possible.
+	 */
+	if (unlikely(video->error))
+		return -EIO;
+
 	addr = ispmmu_vmap(video->isp, buf->sglist, buf->sglen);
 	if (IS_ERR_VALUE(addr))
 		return -EIO;
@@ -447,6 +456,12 @@ static void isp_video_buffer_queue(struct isp_video_buffer *buf)
 	unsigned int empty;
 	unsigned int start;
 
+	if (unlikely(video->error)) {
+		buf->state = ISP_BUF_STATE_ERROR;
+		wake_up(&buf->wait);
+		return;
+	}
+
 	empty = list_empty(&video->dmaqueue);
 	list_add_tail(&buffer->buffer.irqlist, &video->dmaqueue);
 
@@ -569,6 +584,36 @@ struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video)
 }
 
 /*
+ * omap3isp_video_cancel_stream - Cancel stream on a video node
+ * @video: ISP video object
+ *
+ * Cancelling a stream mark all buffers on the video node as erroneous and makes
+ * sure no new buffer can be queued.
+ */
+void omap3isp_video_cancel_stream(struct isp_video *video)
+{
+	struct isp_video_queue *queue = video->queue;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+
+	while (!list_empty(&video->dmaqueue)) {
+		struct isp_video_buffer *buf;
+
+		buf = list_first_entry(&video->dmaqueue,
+				       struct isp_video_buffer, irqlist);
+		list_del(&buf->irqlist);
+
+		buf->state = ISP_BUF_STATE_ERROR;
+		wake_up(&buf->wait);
+	}
+
+	video->error = true;
+
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
+/*
  * omap3isp_video_resume - Perform resume operation on the buffers
  * @video: ISP video object
  * @continuous: Pipeline is in single shot mode if 0 or continuous mode otherwise
@@ -1105,6 +1150,7 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 	omap3isp_video_queue_streamoff(&vfh->queue);
 	video->queue = NULL;
 	video->streaming = 0;
+	video->error = false;
 
 	if (video->isp->pdata->set_constraints)
 		video->isp->pdata->set_constraints(video->isp, false);
diff --git a/drivers/media/platform/omap3isp/ispvideo.h b/drivers/media/platform/omap3isp/ispvideo.h
index 1ad470ec..4e19407 100644
--- a/drivers/media/platform/omap3isp/ispvideo.h
+++ b/drivers/media/platform/omap3isp/ispvideo.h
@@ -178,6 +178,7 @@ struct isp_video {
 	/* Pipeline state */
 	struct isp_pipeline pipe;
 	struct mutex stream_lock;	/* pipeline and stream states */
+	bool error;
 
 	/* Video buffers queue */
 	struct isp_video_queue *queue;
@@ -207,6 +208,7 @@ int omap3isp_video_register(struct isp_video *video,
 			    struct v4l2_device *vdev);
 void omap3isp_video_unregister(struct isp_video *video);
 struct isp_buffer *omap3isp_video_buffer_next(struct isp_video *video);
+void omap3isp_video_cancel_stream(struct isp_video *video);
 void omap3isp_video_resume(struct isp_video *video, int continuous);
 struct media_pad *omap3isp_video_remote_pad(struct isp_video *video);
 
-- 
1.8.3.2

