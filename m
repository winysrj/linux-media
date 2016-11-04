Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938695AbcKDSTv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 14:19:51 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 4/4] v4l: vsp1: Remove redundant context variables
Date: Fri,  4 Nov 2016 18:19:30 +0000
Message-Id: <1478283570-19688-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_pipe object context variables for div_size and
current_partition allowed state to be maintained through processing the
partitions during processing.

Now that the partition tables are calculated during stream on, there is
no requirement to store these variables in the pipe object.

Utilise local variables for the processing as required.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |  4 ----
 drivers/media/platform/vsp1/vsp1_video.c | 19 +++++++++----------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 3af96c4ea244..9e108ddcceb6 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -82,10 +82,8 @@ enum vsp1_pipeline_state {
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
  * @dl: display list associated with the pipeline
- * @div_size: The maximum allowed partition size for the pipeline
  * @partitions: The number of partitions used to process one frame
  * @partition: The current partition for configuration to process
- * @current_partition: The partition number currently being configured
  * @part_table: The pre-calculated partitions used by the pipeline
  */
 struct vsp1_pipeline {
@@ -117,10 +115,8 @@ struct vsp1_pipeline {
 
 	struct vsp1_dl_list *dl;
 
-	unsigned int div_size;
 	unsigned int partitions;
 	struct v4l2_rect partition;
-	unsigned int current_partition;
 	struct v4l2_rect part_table[VSP1_PIPE_MAX_PARTITIONS];
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c4a8c30df108..9efaab2cc982 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -268,7 +268,6 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 
 	/* Gen2 hardware doesn't require image partitioning. */
 	if (vsp1->info->gen == 2) {
-		pipe->div_size = div_size;
 		pipe->partitions = 1;
 		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
 		return;
@@ -284,7 +283,6 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 		}
 	}
 
-	pipe->div_size = div_size;
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
 
 	for (i = 0; i < pipe->partitions; i++)
@@ -356,11 +354,12 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 }
 
 static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
-					      struct vsp1_dl_list *dl)
+					      struct vsp1_dl_list *dl,
+					      unsigned int partition_number)
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = pipe->part_table[pipe->current_partition];
+	pipe->partition = pipe->part_table[partition_number];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
@@ -373,6 +372,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
+	unsigned int current_partition = 0;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
@@ -389,13 +389,12 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	}
 
 	/* Run the first partition */
-	pipe->current_partition = 0;
-	vsp1_video_pipeline_run_partition(pipe, pipe->dl);
+	vsp1_video_pipeline_run_partition(pipe, pipe->dl, current_partition);
 
 	/* Process consecutive partitions as necessary */
-	for (pipe->current_partition = 1;
-	     pipe->current_partition < pipe->partitions;
-	     pipe->current_partition++) {
+	for (current_partition = 1;
+	     current_partition < pipe->partitions;
+	     current_partition++) {
 		struct vsp1_dl_list *dl;
 
 		/*
@@ -415,7 +414,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 			break;
 		}
 
-		vsp1_video_pipeline_run_partition(pipe, dl);
+		vsp1_video_pipeline_run_partition(pipe, dl, current_partition);
 		vsp1_dl_list_add_chain(pipe->dl, dl);
 	}
 
-- 
2.7.4

