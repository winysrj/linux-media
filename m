Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753842AbdGNQIt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:08:49 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 2/6] v4l: vsp1: Calculate partition sizes at stream start.
Date: Fri, 14 Jul 2017 17:08:33 +0100
Message-Id: <dc42fcf5e6be3c5951d00df56df732e37aab6de5.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
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
v2:
 - Partition table allocated dynamically as required.
 - loop uses unsigned int
 - rebase on top of suspend-resume fix commits
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |  3 ++-
 drivers/media/platform/vsp1/vsp1_video.c | 32 +++++++++++++++++++++----
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index c5d01a365370..d345cc6d0d69 100644
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
index 03e139f40dcf..4155c06e9b42 100644
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
@@ -274,9 +275,15 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 
 	/* Gen2 hardware doesn't require image partitioning. */
 	if (vsp1->info->gen == 2) {
+		pipe->part_table = kcalloc(1, sizeof(*pipe->part_table),
+					   GFP_ATOMIC);
+		if (pipe->part_table == NULL)
+			return -ENOMEM;
+
 		pipe->div_size = div_size;
 		pipe->partitions = 1;
-		return;
+		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
+		return 0;
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
@@ -291,6 +298,16 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 
 	pipe->div_size = div_size;
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
+
+	pipe->part_table = kcalloc(pipe->partitions, sizeof(*pipe->part_table),
+				   GFP_ATOMIC);
+	if (pipe->part_table == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < pipe->partitions; i++)
+		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
+
+	return 0;
 }
 /* -----------------------------------------------------------------------------
  * Pipeline Management
@@ -372,8 +389,7 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = vsp1_video_partition(pipe, pipe->div_size,
-					       pipe->current_partition);
+	pipe->partition = pipe->part_table[pipe->current_partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
@@ -801,9 +817,12 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_entity *entity;
+	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
-	vsp1_video_pipeline_setup_partitions(pipe);
+	ret = vsp1_video_pipeline_setup_partitions(pipe);
+	if (ret)
+		return ret;
 
 	/* Prepare the display list. */
 	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
@@ -908,6 +927,9 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 		vsp1_dl_list_put(pipe->dl);
 		pipe->dl = NULL;
 	}
+
+	kfree(pipe->part_table);
+	pipe->part_table = NULL;
 	mutex_unlock(&pipe->lock);
 
 	media_pipeline_stop(&video->video.entity);
-- 
git-series 0.9.1
