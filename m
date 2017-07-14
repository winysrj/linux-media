Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753860AbdGNQIu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:08:50 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 3/6] v4l: vsp1: Remove redundant context variables
Date: Fri, 14 Jul 2017 17:08:34 +0100
Message-Id: <766b91eeca0df013cc31637a60227ab959ec0068.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_pipe object context variables for div_size and
current_partition allowed state to be maintained through processing the
partitions during processing.

Now that the partition tables are calculated during stream on, there is
no requirement to store these variables in the pipe object.

Utilise local variables for the processing as required.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

---
v2:
 - s/current_partition/partition/
 - s/partition_number/partition/
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |  4 ----
 drivers/media/platform/vsp1/vsp1_video.c | 22 +++++++---------------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index d345cc6d0d69..f440d0891bea 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -80,10 +80,8 @@ enum vsp1_pipeline_state {
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
@@ -115,10 +113,8 @@ struct vsp1_pipeline {
 
 	struct vsp1_dl_list *dl;
 
-	unsigned int div_size;
 	unsigned int partitions;
 	struct v4l2_rect partition;
-	unsigned int current_partition;
 	struct v4l2_rect *part_table;
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4155c06e9b42..dd94968d0044 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -280,7 +280,6 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 		if (pipe->part_table == NULL)
 			return -ENOMEM;
 
-		pipe->div_size = div_size;
 		pipe->partitions = 1;
 		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
 		return 0;
@@ -296,7 +295,6 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 		}
 	}
 
-	pipe->div_size = div_size;
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
 
 	pipe->part_table = kcalloc(pipe->partitions, sizeof(*pipe->part_table),
@@ -385,11 +383,12 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 }
 
 static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
-					      struct vsp1_dl_list *dl)
+					      struct vsp1_dl_list *dl,
+					      unsigned int partition)
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = pipe->part_table[pipe->current_partition];
+	pipe->partition = pipe->part_table[partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
@@ -402,6 +401,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
+	unsigned int partition;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
@@ -418,20 +418,12 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	}
 
 	/* Run the first partition */
-	pipe->current_partition = 0;
-	vsp1_video_pipeline_run_partition(pipe, pipe->dl);
+	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
 
 	/* Process consecutive partitions as necessary */
-	for (pipe->current_partition = 1;
-	     pipe->current_partition < pipe->partitions;
-	     pipe->current_partition++) {
+	for (partition = 1; partition < pipe->partitions; partition++) {
 		struct vsp1_dl_list *dl;
 
-		/*
-		 * Partition configuration operations will utilise
-		 * the pipe->current_partition variable to determine
-		 * the work they should complete.
-		 */
 		dl = vsp1_dl_list_get(pipe->output->dlm);
 
 		/*
@@ -444,7 +436,7 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 			break;
 		}
 
-		vsp1_video_pipeline_run_partition(pipe, dl);
+		vsp1_video_pipeline_run_partition(pipe, dl, partition);
 		vsp1_dl_list_add_chain(pipe->dl, dl);
 	}
 
-- 
git-series 0.9.1
