Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbdHDQcw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 12:32:52 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 2/7] v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
Date: Fri,  4 Aug 2017 17:32:39 +0100
Message-Id: <f413c82853df286c1d0bbff4dee75625beb1f97e.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index fdb135e45fea..e4c0bfa0f864 100644
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
