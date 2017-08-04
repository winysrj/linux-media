Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbdHDP5S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 11:57:18 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 2/7] v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
Date: Fri,  4 Aug 2017 16:57:06 +0100
Message-Id: <209eb8c59020c341c745a39ce87b2ae78993726f.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Separate the code change from the function move so that code changes can
be clearly identified. This commit has no functional change.

The partition algorithm functions will be changed, and
vsp1_video_pipeline_setup_partitions() will call vsp1_video_partition().
To prepare for that, move the function without any code change.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 74 ++++++++++++-------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a24033429cd7..097e4db572a9 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -182,43 +182,6 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
  * VSP1 Partition Algorithm support
  */
 
-static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
-{
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
-	const struct v4l2_mbus_framefmt *format;
-	struct vsp1_entity *entity;
-	unsigned int div_size;
-
-	/*
-	 * Partitions are computed on the size before rotation, use the format
-	 * at the WPF sink.
-	 */
-	format = vsp1_entity_get_pad_format(&pipe->output->entity,
-					    pipe->output->entity.config,
-					    RWPF_PAD_SINK);
-	div_size = format->width;
-
-	/* Gen2 hardware doesn't require image partitioning. */
-	if (vsp1->info->gen == 2) {
-		pipe->div_size = div_size;
-		pipe->partitions = 1;
-		return;
-	}
-
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		unsigned int entity_max = VSP1_VIDEO_MAX_WIDTH;
-
-		if (entity->ops->max_width) {
-			entity_max = entity->ops->max_width(entity, pipe);
-			if (entity_max)
-				div_size = min(div_size, entity_max);
-		}
-	}
-
-	pipe->div_size = div_size;
-	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
-}
-
 /**
  * vsp1_video_partition - Calculate the active partition output window
  *
@@ -293,6 +256,43 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 	return partition;
 }
 
+static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
+{
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_entity *entity;
+	unsigned int div_size;
+
+	/*
+	 * Partitions are computed on the size before rotation, use the format
+	 * at the WPF sink.
+	 */
+	format = vsp1_entity_get_pad_format(&pipe->output->entity,
+					    pipe->output->entity.config,
+					    RWPF_PAD_SINK);
+	div_size = format->width;
+
+	/* Gen2 hardware doesn't require image partitioning. */
+	if (vsp1->info->gen == 2) {
+		pipe->div_size = div_size;
+		pipe->partitions = 1;
+		return;
+	}
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		unsigned int entity_max = VSP1_VIDEO_MAX_WIDTH;
+
+		if (entity->ops->max_width) {
+			entity_max = entity->ops->max_width(entity, pipe);
+			if (entity_max)
+				div_size = min(div_size, entity_max);
+		}
+	}
+
+	pipe->div_size = div_size;
+	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
+}
+
 /* -----------------------------------------------------------------------------
  * Pipeline Management
  */
-- 
git-series 0.9.1
