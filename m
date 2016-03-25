Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbcCYKpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:02 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 38/54] v4l: vsp1: Store pipeline pointer in rwpf
Date: Fri, 25 Mar 2016 12:44:12 +0200
Message-Id: <1458902668-1141-39-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prepares for dynamic pipeline allocation by providing a field that
can be used to store the pipeline pointer atomically under driver
control.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c   |  4 +---
 drivers/media/platform/vsp1/vsp1_pipe.c  | 14 +++++++++-----
 drivers/media/platform/vsp1/vsp1_pipe.h  |  8 --------
 drivers/media/platform/vsp1/vsp1_rwpf.h  |  2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 13 +++++++------
 5 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index bfdc01c9172d..f1be2680013d 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -49,17 +49,15 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 
 	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		struct vsp1_pipeline *pipe;
 
 		if (wpf == NULL)
 			continue;
 
-		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
 		status = vsp1_read(vsp1, VI6_WPF_IRQ_STA(i));
 		vsp1_write(vsp1, VI6_WPF_IRQ_STA(i), ~status & mask);
 
 		if (status & VI6_WFP_IRQ_STA_FRE) {
-			vsp1_pipeline_frame_end(pipe);
+			vsp1_pipeline_frame_end(wpf->pipe);
 			ret = IRQ_HANDLED;
 		}
 	}
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 4d06519f717d..8ac080f87b08 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -172,14 +172,18 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 			bru->inputs[i].rpf = NULL;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i)
+	for (i = 0; i < pipe->num_inputs; ++i) {
+		pipe->inputs[i]->pipe = NULL;
 		pipe->inputs[i] = NULL;
+	}
+
+	pipe->output->pipe = NULL;
+	pipe->output = NULL;
 
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
 	pipe->num_inputs = 0;
-	pipe->output = NULL;
 	pipe->bru = NULL;
 	pipe->lif = NULL;
 	pipe->uds = NULL;
@@ -344,7 +348,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 		if (wpf == NULL)
 			continue;
 
-		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		pipe = wpf->pipe;
 		if (pipe == NULL)
 			continue;
 
@@ -361,7 +365,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 		if (wpf == NULL)
 			continue;
 
-		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		pipe = wpf->pipe;
 		if (pipe == NULL)
 			continue;
 
@@ -385,7 +389,7 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 		if (wpf == NULL)
 			continue;
 
-		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
+		pipe = wpf->pipe;
 		if (pipe == NULL)
 			continue;
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 1100229a1ed2..9fd688bfe638 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -103,14 +103,6 @@ struct vsp1_pipeline {
 	struct vsp1_dl_list *dl;
 };
 
-static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
-{
-	if (likely(e->pipe))
-		return container_of(e->pipe, struct vsp1_pipeline, pipe);
-	else
-		return NULL;
-}
-
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_init(struct vsp1_pipeline *pipe);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 38c8c902db52..9ff7c78f239e 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -25,6 +25,7 @@
 
 struct v4l2_ctrl;
 struct vsp1_dl_manager;
+struct vsp1_pipeline;
 struct vsp1_rwpf;
 struct vsp1_video;
 
@@ -36,6 +37,7 @@ struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct v4l2_ctrl_handler ctrls;
 
+	struct vsp1_pipeline *pipe;
 	struct vsp1_video *video;
 
 	unsigned int max_width;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a16a661e5b69..2c642726a259 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -293,10 +293,12 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 			rwpf = to_rwpf(subdev);
 			pipe->inputs[rwpf->entity.index] = rwpf;
 			rwpf->video->pipe_index = ++pipe->num_inputs;
+			rwpf->pipe = pipe;
 		} else if (e->type == VSP1_ENTITY_WPF) {
 			rwpf = to_rwpf(subdev);
 			pipe->output = rwpf;
 			rwpf->video->pipe_index = 0;
+			rwpf->pipe = pipe;
 		} else if (e->type == VSP1_ENTITY_LIF) {
 			pipe->lif = e;
 		} else if (e->type == VSP1_ENTITY_BRU) {
@@ -384,7 +386,7 @@ static void vsp1_video_pipeline_cleanup(struct vsp1_pipeline *pipe)
 static struct vsp1_vb2_buffer *
 vsp1_video_complete_buffer(struct vsp1_video *video)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	struct vsp1_vb2_buffer *next = NULL;
 	struct vsp1_vb2_buffer *done;
 	unsigned long flags;
@@ -563,7 +565,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
 	unsigned long flags;
 	bool empty;
@@ -628,7 +630,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	unsigned long flags;
 	int ret;
 
@@ -655,7 +657,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_pipeline *pipe = video->rwpf->pipe;
 	struct vsp1_vb2_buffer *buffer;
 	unsigned long flags;
 	int ret;
@@ -802,8 +804,7 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	 * FIXME: This is racy, the ioctl is only protected by the video node
 	 * lock.
 	 */
-	pipe = video->video.entity.pipe
-	     ? to_vsp1_pipeline(&video->video.entity) : &video->pipe;
+	pipe = video->rwpf->pipe ? video->rwpf->pipe : &video->pipe;
 
 	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
 	if (ret < 0)
-- 
2.7.3

