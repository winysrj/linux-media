Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbcCYKpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 39/54] v4l: vsp1: video: Reorder functions
Date: Fri, 25 Mar 2016 12:44:13 +0200
Message-Id: <1458902668-1141-40-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the pipeline initialization and cleanup functions to prepare for
the next commit. No functional code change is performed here.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 266 +++++++++++++++----------------
 1 file changed, 133 insertions(+), 133 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 2c642726a259..4396018d1408 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -172,6 +172,139 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
  * Pipeline Management
  */
 
+/*
+ * vsp1_video_complete_buffer - Complete the current buffer
+ * @video: the video node
+ *
+ * This function completes the current buffer by filling its sequence number,
+ * time stamp and payload size, and hands it back to the videobuf core.
+ *
+ * When operating in DU output mode (deep pipeline to the DU through the LIF),
+ * the VSP1 needs to constantly supply frames to the display. In that case, if
+ * no other buffer is queued, reuse the one that has just been processed instead
+ * of handing it back to the videobuf core.
+ *
+ * Return the next queued buffer or NULL if the queue is empty.
+ */
+static struct vsp1_vb2_buffer *
+vsp1_video_complete_buffer(struct vsp1_video *video)
+{
+	struct vsp1_pipeline *pipe = video->rwpf->pipe;
+	struct vsp1_vb2_buffer *next = NULL;
+	struct vsp1_vb2_buffer *done;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&video->irqlock, flags);
+
+	if (list_empty(&video->irqqueue)) {
+		spin_unlock_irqrestore(&video->irqlock, flags);
+		return NULL;
+	}
+
+	done = list_first_entry(&video->irqqueue,
+				struct vsp1_vb2_buffer, queue);
+
+	/* In DU output mode reuse the buffer if the list is singular. */
+	if (pipe->lif && list_is_singular(&video->irqqueue)) {
+		spin_unlock_irqrestore(&video->irqlock, flags);
+		return done;
+	}
+
+	list_del(&done->queue);
+
+	if (!list_empty(&video->irqqueue))
+		next = list_first_entry(&video->irqqueue,
+					struct vsp1_vb2_buffer, queue);
+
+	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	done->buf.sequence = video->sequence++;
+	done->buf.vb2_buf.timestamp = ktime_get_ns();
+	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
+		vb2_set_plane_payload(&done->buf.vb2_buf, i,
+				      vb2_plane_size(&done->buf.vb2_buf, i));
+	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
+
+	return next;
+}
+
+static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
+				 struct vsp1_rwpf *rwpf)
+{
+	struct vsp1_video *video = rwpf->video;
+	struct vsp1_vb2_buffer *buf;
+	unsigned long flags;
+
+	buf = vsp1_video_complete_buffer(video);
+	if (buf == NULL)
+		return;
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	video->rwpf->mem = buf->mem;
+	pipe->buffers_ready |= 1 << video->pipe_index;
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
+static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	unsigned int i;
+
+	if (!pipe->dl)
+		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
+
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
+		struct vsp1_rwpf *rwpf = pipe->inputs[i];
+
+		if (rwpf)
+			vsp1_rwpf_set_memory(rwpf, pipe->dl);
+	}
+
+	if (!pipe->lif)
+		vsp1_rwpf_set_memory(pipe->output, pipe->dl);
+
+	vsp1_dl_list_commit(pipe->dl);
+	pipe->dl = NULL;
+
+	vsp1_pipeline_run(pipe);
+}
+
+static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	enum vsp1_pipeline_state state;
+	unsigned long flags;
+	unsigned int i;
+
+	/* Complete buffers on all video nodes. */
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
+		if (!pipe->inputs[i])
+			continue;
+
+		vsp1_video_frame_end(pipe, pipe->inputs[i]);
+	}
+
+	vsp1_video_frame_end(pipe, pipe->output);
+
+	spin_lock_irqsave(&pipe->irqlock, flags);
+
+	state = pipe->state;
+	pipe->state = VSP1_PIPELINE_STOPPED;
+
+	/* If a stop has been requested, mark the pipeline as stopped and
+	 * return. Otherwise restart the pipeline if ready.
+	 */
+	if (state == VSP1_PIPELINE_STOPPING)
+		wake_up(&pipe->wq);
+	else if (vsp1_pipeline_ready(pipe))
+		vsp1_video_pipeline_run(pipe);
+
+	spin_unlock_irqrestore(&pipe->irqlock, flags);
+}
+
 static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 					    struct vsp1_rwpf *input,
 					    struct vsp1_rwpf *output)
@@ -369,139 +502,6 @@ static void vsp1_video_pipeline_cleanup(struct vsp1_pipeline *pipe)
 	mutex_unlock(&pipe->lock);
 }
 
-/*
- * vsp1_video_complete_buffer - Complete the current buffer
- * @video: the video node
- *
- * This function completes the current buffer by filling its sequence number,
- * time stamp and payload size, and hands it back to the videobuf core.
- *
- * When operating in DU output mode (deep pipeline to the DU through the LIF),
- * the VSP1 needs to constantly supply frames to the display. In that case, if
- * no other buffer is queued, reuse the one that has just been processed instead
- * of handing it back to the videobuf core.
- *
- * Return the next queued buffer or NULL if the queue is empty.
- */
-static struct vsp1_vb2_buffer *
-vsp1_video_complete_buffer(struct vsp1_video *video)
-{
-	struct vsp1_pipeline *pipe = video->rwpf->pipe;
-	struct vsp1_vb2_buffer *next = NULL;
-	struct vsp1_vb2_buffer *done;
-	unsigned long flags;
-	unsigned int i;
-
-	spin_lock_irqsave(&video->irqlock, flags);
-
-	if (list_empty(&video->irqqueue)) {
-		spin_unlock_irqrestore(&video->irqlock, flags);
-		return NULL;
-	}
-
-	done = list_first_entry(&video->irqqueue,
-				struct vsp1_vb2_buffer, queue);
-
-	/* In DU output mode reuse the buffer if the list is singular. */
-	if (pipe->lif && list_is_singular(&video->irqqueue)) {
-		spin_unlock_irqrestore(&video->irqlock, flags);
-		return done;
-	}
-
-	list_del(&done->queue);
-
-	if (!list_empty(&video->irqqueue))
-		next = list_first_entry(&video->irqqueue,
-					struct vsp1_vb2_buffer, queue);
-
-	spin_unlock_irqrestore(&video->irqlock, flags);
-
-	done->buf.sequence = video->sequence++;
-	done->buf.vb2_buf.timestamp = ktime_get_ns();
-	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
-		vb2_set_plane_payload(&done->buf.vb2_buf, i,
-				      vb2_plane_size(&done->buf.vb2_buf, i));
-	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
-
-	return next;
-}
-
-static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
-				 struct vsp1_rwpf *rwpf)
-{
-	struct vsp1_video *video = rwpf->video;
-	struct vsp1_vb2_buffer *buf;
-	unsigned long flags;
-
-	buf = vsp1_video_complete_buffer(video);
-	if (buf == NULL)
-		return;
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
-	video->rwpf->mem = buf->mem;
-	pipe->buffers_ready |= 1 << video->pipe_index;
-
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-}
-
-static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
-	unsigned int i;
-
-	if (!pipe->dl)
-		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
-
-	for (i = 0; i < vsp1->info->rpf_count; ++i) {
-		struct vsp1_rwpf *rwpf = pipe->inputs[i];
-
-		if (rwpf)
-			vsp1_rwpf_set_memory(rwpf, pipe->dl);
-	}
-
-	if (!pipe->lif)
-		vsp1_rwpf_set_memory(pipe->output, pipe->dl);
-
-	vsp1_dl_list_commit(pipe->dl);
-	pipe->dl = NULL;
-
-	vsp1_pipeline_run(pipe);
-}
-
-static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
-	enum vsp1_pipeline_state state;
-	unsigned long flags;
-	unsigned int i;
-
-	/* Complete buffers on all video nodes. */
-	for (i = 0; i < vsp1->info->rpf_count; ++i) {
-		if (!pipe->inputs[i])
-			continue;
-
-		vsp1_video_frame_end(pipe, pipe->inputs[i]);
-	}
-
-	vsp1_video_frame_end(pipe, pipe->output);
-
-	spin_lock_irqsave(&pipe->irqlock, flags);
-
-	state = pipe->state;
-	pipe->state = VSP1_PIPELINE_STOPPED;
-
-	/* If a stop has been requested, mark the pipeline as stopped and
-	 * return. Otherwise restart the pipeline if ready.
-	 */
-	if (state == VSP1_PIPELINE_STOPPING)
-		wake_up(&pipe->wq);
-	else if (vsp1_pipeline_ready(pipe))
-		vsp1_video_pipeline_run(pipe);
-
-	spin_unlock_irqrestore(&pipe->irqlock, flags);
-}
-
 /* -----------------------------------------------------------------------------
  * videobuf2 Queue Operations
  */
-- 
2.7.3

