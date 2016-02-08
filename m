Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbcBHLoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:17 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 28/35] v4l: vsp1: Make pipeline inputs array index by RPF index
Date: Mon,  8 Feb 2016 13:43:58 +0200
Message-Id: <1454931845-23864-29-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pipeline inputs array stores pointers to all RPFs contained in the
pipeline. It's currently indexed contiguously by adding RPFs in the
order they are found during graph walk. This can't easily support
dynamic addition and removal of RPFs while streaming, which will be
required for combined VSP+DU support.

Make the array indexed by RPF index instead and skip NULL elements when
iterating over RPFs.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.c  |  6 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c | 16 ++++++++++++----
 drivers/media/platform/vsp1/vsp1_wpf.c   |  5 ++++-
 4 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index b850aeb885bf..05d4c3870cff 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -161,14 +161,18 @@ const struct vsp1_format_info *vsp1_get_format_info(u32 fourcc)
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 {
+	unsigned int i;
+
 	if (pipe->bru) {
 		struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
-		unsigned int i;
 
 		for (i = 0; i < ARRAY_SIZE(bru->inputs); ++i)
 			bru->inputs[i].rpf = NULL;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i)
+		pipe->inputs[i] = NULL;
+
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index f9035c739e9a..c4c300561c5c 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -66,7 +66,7 @@ enum vsp1_pipeline_state {
  * @stream_count: number of streaming video nodes
  * @buffers_ready: bitmask of RPFs and WPFs with at least one buffer available
  * @num_inputs: number of RPFs
- * @inputs: array of RPFs in the pipeline
+ * @inputs: array of RPFs in the pipeline (indexed by RPF index)
  * @output: WPF at the output of the pipeline
  * @bru: BRU entity, if present
  * @lif: LIF entity, if present
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 92eb39c509df..b2eecabdc399 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -298,8 +298,8 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 
 		if (e->type == VSP1_ENTITY_RPF) {
 			rwpf = to_rwpf(subdev);
-			pipe->inputs[pipe->num_inputs++] = rwpf;
-			rwpf->video->pipe_index = pipe->num_inputs;
+			pipe->inputs[rwpf->entity.index] = rwpf;
+			rwpf->video->pipe_index = ++pipe->num_inputs;
 		} else if (e->type == VSP1_ENTITY_WPF) {
 			rwpf = to_rwpf(subdev);
 			pipe->output = rwpf;
@@ -324,7 +324,10 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 	/* Follow links downstream for each input and make sure the graph
 	 * contains no loop and that all branches end at the output WPF.
 	 */
-	for (i = 0; i < pipe->num_inputs; ++i) {
+	for (i = 0; i < video->vsp1->pdata.rpf_count; ++i) {
+		if (!pipe->inputs[i])
+			continue;
+
 		ret = vsp1_video_pipeline_validate_branch(pipe, pipe->inputs[i],
 							  pipe->output);
 		if (ret < 0)
@@ -449,11 +452,16 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	unsigned int i;
 
 	/* Complete buffers on all video nodes. */
-	for (i = 0; i < pipe->num_inputs; ++i)
+	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+		if (!pipe->inputs[i])
+			continue;
+
 		vsp1_video_frame_end(pipe, pipe->inputs[i]);
+	}
 
 	if (!pipe->lif)
 		vsp1_video_frame_end(pipe, pipe->output);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 184a7e01aad5..d0edcde721bd 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -97,9 +97,12 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	 * inputs as sub-layers and select the virtual RPF as the master
 	 * layer.
 	 */
-	for (i = 0; i < pipe->num_inputs; ++i) {
+	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
 		struct vsp1_rwpf *input = pipe->inputs[i];
 
+		if (!input)
+			continue;
+
 		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
 			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
 			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
-- 
2.4.10

