Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752955AbdHDQcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 12:32:53 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 3/7] v4l: vsp1: Calculate partition sizes at stream start
Date: Fri,  4 Aug 2017 17:32:40 +0100
Message-Id: <d6bac3ee449c7b12d8216d3e33809767ec65e2cf.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously the active window and partition sizes for each partition were
calculated for each partition every frame. This data is constant and
only needs to be calculated once at the start of the stream.

Extend the vsp1_pipe object to dynamically store the number of partitions
required and pre-calculate the partition sizes into this table.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |  3 ++-
 drivers/media/platform/vsp1/vsp1_video.c | 44 +++++++++++++++++--------
 2 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 91a784a13422..0cfd07a187a2 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -82,7 +82,9 @@ enum vsp1_pipeline_state {
  * @dl: display list associated with the pipeline
  * @div_size: The maximum allowed partition size for the pipeline
  * @partitions: The number of partitions used to process one frame
+ * @partition: The current partition for configuration to process
  * @current_partition: The partition number currently being configured
+ * @part_table: The pre-calculated partitions used by the pipeline
  */
 struct vsp1_pipeline {
 	struct media_pipeline pipe;
@@ -117,6 +119,7 @@ struct vsp1_pipeline {
 	unsigned int partitions;
 	struct v4l2_rect partition;
 	unsigned int current_partition;
+	struct v4l2_rect *part_table;
 };
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index e4c0bfa0f864..2ac57a436811 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -256,12 +256,13 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 	return partition;
 }
 
-static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
+static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_entity *entity;
 	unsigned int div_size;
+	unsigned int i;
 
 	/*
 	 * Partitions are computed on the size before rotation, use the format
@@ -272,17 +273,17 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 					    RWPF_PAD_SINK);
 	div_size = format->width;
 
-	/* Gen2 hardware doesn't require image partitioning. */
-	if (vsp1->info->gen == 2) {
-		pipe->div_size = div_size;
-		pipe->partitions = 1;
-		return;
-	}
+	/*
+	 * Only Gen3 hardware requires image partitioning, Gen2 will operate
+	 * with a single partition that covers the whole output.
+	 */
+	if (vsp1->info->gen == 3) {
+		list_for_each_entry(entity, &pipe->entities, list_pipe) {
+			unsigned int entity_max;
 
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		unsigned int entity_max = VSP1_VIDEO_MAX_WIDTH;
+			if (!entity->ops->max_width)
+				continue;
 
-		if (entity->ops->max_width) {
 			entity_max = entity->ops->max_width(entity, pipe);
 			if (entity_max)
 				div_size = min(div_size, entity_max);
@@ -291,6 +292,15 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 
 	pipe->div_size = div_size;
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
+	pipe->part_table = kcalloc(pipe->partitions, sizeof(*pipe->part_table),
+				   GFP_KERNEL);
+	if (!pipe->part_table)
+		return -ENOMEM;
+
+	for (i = 0; i < pipe->partitions; ++i)
+		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
+
+	return 0;
 }
 
 /* -----------------------------------------------------------------------------
@@ -373,8 +383,7 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = vsp1_video_partition(pipe, pipe->div_size,
-					       pipe->current_partition);
+	pipe->partition = pipe->part_table[pipe->current_partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
@@ -783,9 +792,12 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_entity *entity;
+	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
-	vsp1_video_pipeline_setup_partitions(pipe);
+	ret = vsp1_video_pipeline_setup_partitions(pipe);
+	if (ret < 0)
+		return ret;
 
 	/* Prepare the display list. */
 	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
@@ -834,6 +846,12 @@ static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
 		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
+
+	/* Release our partition table allocation */
+	mutex_lock(&pipe->lock);
+	kfree(pipe->part_table);
+	pipe->part_table = NULL;
+	mutex_unlock(&pipe->lock);
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
-- 
git-series 0.9.1
