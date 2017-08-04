Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752612AbdHDP5W (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 11:57:22 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 5/7] v4l: vsp1: Move partition rectangles to struct and operate directly
Date: Fri,  4 Aug 2017 16:57:09 +0100
Message-Id: <f15506e25b4de0c44dbc1e71730f45d42f82c668.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.109dff74bad8730bc9559578df79f47dae253305.1501861813.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we develop the partition algorithm, we need to store more information
per partition to describe the phase and other parameters.

To keep this data together, further abstract the existing v4l2_rect
into a partition specific structure. As partitions only have horizontal
coordinates, store the left and width values only.

When generating the partition windows, operate directly on the partition
struct rather than copying and duplicating the processed data

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  | 15 +++++++--
 drivers/media/platform/vsp1/vsp1_rpf.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_uds.c   | 18 +++++-----
 drivers/media/platform/vsp1/vsp1_video.c | 43 +++++++++++--------------
 drivers/media/platform/vsp1/vsp1_wpf.c   | 14 ++++----
 5 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 9653ef5cfb0c..4e9fd96108be 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -58,6 +58,17 @@ enum vsp1_pipeline_state {
 };
 
 /*
+ * struct vsp1_partition - A description of a slice for the partition algorithm
+ * @left: horizontal coordinate of the partition start in pixels relative to the
+ *	  left edge of the image
+ * @width: partition width in pixels
+ */
+struct vsp1_partition {
+	unsigned int left;
+	unsigned int width;
+};
+
+/*
  * struct vsp1_pipeline - A VSP1 hardware pipeline
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
@@ -114,8 +125,8 @@ struct vsp1_pipeline {
 	struct vsp1_dl_list *dl;
 
 	unsigned int partitions;
-	struct v4l2_rect partition;
-	struct v4l2_rect *part_table;
+	struct vsp1_partition *partition;
+	struct vsp1_partition *part_table;
 };
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 8feddd59cf8d..126741f00ae3 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -108,9 +108,9 @@ static void rpf_configure(struct vsp1_entity *entity,
 			output = vsp1_entity_get_pad_format(wpf, wpf->config,
 							    RWPF_PAD_SINK);
 
-			crop.width = pipe->partition.width * input_width
+			crop.width = pipe->partition->width * input_width
 				   / output->width;
-			crop.left += pipe->partition.left * input_width
+			crop.left += pipe->partition->left * input_width
 				   / output->width;
 		}
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 4226403ad235..4a43e7413b68 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -271,23 +271,25 @@ static void uds_configure(struct vsp1_entity *entity,
 	unsigned int vscale;
 	bool multitap;
 
+	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					   UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
+
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		const struct v4l2_rect *clip = &pipe->partition;
+		struct vsp1_partition *partition = pipe->partition;
 
 		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-			       (clip->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-			       (clip->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+			       (partition->width
+					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+			       (output->height
+					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 		return;
 	}
 
 	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
-	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
-					   UDS_PAD_SINK);
-	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
-					    UDS_PAD_SOURCE);
-
 	hscale = uds_compute_ratio(input->width, output->width);
 	vscale = uds_compute_ratio(input->height, output->height);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f8c3186c0fb6..5522595e9323 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -183,19 +183,19 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
  */
 
 /**
- * vsp1_video_partition - Calculate the active partition output window
+ * vsp1_video_calculate_partition - Calculate the active partition output window
  *
+ * @pipe: the pipeline
+ * @partition: partition that will hold the calculated values
  * @div_size: pre-determined maximum partition division size
  * @index: partition index
- *
- * Returns a v4l2_rect describing the partition window.
  */
-static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
-					     unsigned int div_size,
-					     unsigned int index)
+static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
+					   struct vsp1_partition *partition,
+					   unsigned int div_size,
+					   unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect partition;
 	unsigned int modulus;
 
 	/*
@@ -208,18 +208,14 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
-		partition.left = 0;
-		partition.top = 0;
-		partition.width = format->width;
-		partition.height = format->height;
-		return partition;
+		partition->left = 0;
+		partition->width = format->width;
+		return;
 	}
 
 	/* Initialise the partition with sane starting conditions. */
-	partition.left = index * div_size;
-	partition.top = 0;
-	partition.width = div_size;
-	partition.height = format->height;
+	partition->left = index * div_size;
+	partition->width = div_size;
 
 	modulus = format->width % div_size;
 
@@ -242,18 +238,16 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 		if (modulus < div_size / 2) {
 			if (index == partitions - 1) {
 				/* Halve the penultimate partition. */
-				partition.width = div_size / 2;
+				partition->width = div_size / 2;
 			} else if (index == partitions) {
 				/* Increase the final partition. */
-				partition.width = (div_size / 2) + modulus;
-				partition.left -= div_size / 2;
+				partition->width = (div_size / 2) + modulus;
+				partition->left -= div_size / 2;
 			}
 		} else if (index == partitions) {
-			partition.width = modulus;
+			partition->width = modulus;
 		}
 	}
-
-	return partition;
 }
 
 static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
@@ -297,7 +291,8 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 		return -ENOMEM;
 
 	for (i = 0; i < pipe->partitions; ++i)
-		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
+		vsp1_video_calculate_partition(pipe, &pipe->part_table[i],
+					       div_size, i);
 
 	return 0;
 }
@@ -383,7 +378,7 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = pipe->part_table[partition];
+	pipe->partition = &pipe->part_table[partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 32df109b119f..c8f7cf048841 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -291,7 +291,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * multiple slices.
 		 */
 		if (pipe->partitions > 1)
-			width = pipe->partition.width;
+			width = pipe->partition->width;
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -320,13 +320,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * is applied horizontally or vertically accordingly.
 		 */
 		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-			offset = format->width - pipe->partition.left
-				- pipe->partition.width;
+			offset = format->width - pipe->partition->left
+				- pipe->partition->width;
 		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-			offset = format->height - pipe->partition.left
-				- pipe->partition.width;
+			offset = format->height - pipe->partition->left
+				- pipe->partition->width;
 		else
-			offset = pipe->partition.left;
+			offset = pipe->partition->left;
 
 		for (i = 0; i < format->num_planes; ++i) {
 			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
@@ -348,7 +348,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 			 * image height.
 			 */
 			if (wpf->flip.rotate)
-				height = pipe->partition.width;
+				height = pipe->partition->width;
 			else
 				height = format->height;
 
-- 
git-series 0.9.1
