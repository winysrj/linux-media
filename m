Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753842AbdGNQIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:08:51 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 4/6] v4l: vsp1: Move partition rectangles to struct and operate directly
Date: Fri, 14 Jul 2017 17:08:35 +0100
Message-Id: <a93681e586837f8ba28febb89cdbeeca8ae98353.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we develop the partition algorithm, we need to store more information
per partition to describe the phase and other parameters.

To keep this data together, further abstract the existing v4l2_rect
into a partition specific structure

When generating the partition windows, operate directly on the partition
struct rather than copying and duplicating the processed data

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  | 12 +++++-
 drivers/media/platform/vsp1/vsp1_rpf.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_uds.c   |  8 ++--
 drivers/media/platform/vsp1/vsp1_video.c | 50 +++++++++++++------------
 drivers/media/platform/vsp1/vsp1_wpf.c   | 14 +++----
 5 files changed, 50 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index f440d0891bea..44506a315b5d 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -58,6 +58,14 @@ enum vsp1_pipeline_state {
 };
 
 /*
+ * struct vsp1_partition - A description of each partition slice performed by HW
+ * @dest: The position and dimension of this partition in the destination image
+ */
+struct vsp1_partition {
+	struct v4l2_rect dest;
+};
+
+/*
  * struct vsp1_pipeline - A VSP1 hardware pipeline
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
@@ -114,8 +122,8 @@ struct vsp1_pipeline {
 	struct vsp1_dl_list *dl;
 
 	unsigned int partitions;
-	struct v4l2_rect partition;
-	struct v4l2_rect *part_table;
+	struct vsp1_partition *partition;
+	struct vsp1_partition *part_table;
 };
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 8feddd59cf8d..48b3e89c0e87 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -108,9 +108,9 @@ static void rpf_configure(struct vsp1_entity *entity,
 			output = vsp1_entity_get_pad_format(wpf, wpf->config,
 							    RWPF_PAD_SINK);
 
-			crop.width = pipe->partition.width * input_width
+			crop.width = pipe->partition->dest.width * input_width
 				   / output->width;
-			crop.left += pipe->partition.left * input_width
+			crop.left += pipe->partition->dest.left * input_width
 				   / output->width;
 		}
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 4226403ad235..ea37ff5aee57 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -272,11 +272,13 @@ static void uds_configure(struct vsp1_entity *entity,
 	bool multitap;
 
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		const struct v4l2_rect *clip = &pipe->partition;
+		struct vsp1_partition *partition = pipe->partition;
 
 		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-			       (clip->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-			       (clip->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+			       (partition->dest.width
+					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+			       (partition->dest.height
+					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 		return;
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index dd94968d0044..42e5608d1ddf 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -185,17 +185,17 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 /**
  * vsp1_video_partition - Calculate the active partition output window
  *
+ * @partition: The active partition data
  * @div_size: pre-determined maximum partition division size
  * @index: partition index
  *
- * Returns a v4l2_rect describing the partition window.
+ * Generates the output partitioning positions.
  */
-static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
-					     unsigned int div_size,
-					     unsigned int index)
+static void vsp1_video_partition(struct vsp1_pipeline *pipe,
+				 struct vsp1_partition *partition,
+				 unsigned int div_size, unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect partition;
 	unsigned int modulus;
 
 	/*
@@ -208,18 +208,19 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
-		partition.left = 0;
-		partition.top = 0;
-		partition.width = format->width;
-		partition.height = format->height;
-		return partition;
+		partition->dest.left = 0;
+		partition->dest.top = 0;
+		partition->dest.width = format->width;
+		partition->dest.height = format->height;
+
+		return;
 	}
 
 	/* Initialise the partition with sane starting conditions. */
-	partition.left = index * div_size;
-	partition.top = 0;
-	partition.width = div_size;
-	partition.height = format->height;
+	partition->dest.left = index * div_size;
+	partition->dest.top = 0;
+	partition->dest.width = div_size;
+	partition->dest.height = format->height;
 
 	modulus = format->width % div_size;
 
@@ -242,18 +243,16 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 		if (modulus < div_size / 2) {
 			if (index == partitions - 1) {
 				/* Halve the penultimate partition. */
-				partition.width = div_size / 2;
+				partition->dest.width = div_size / 2;
 			} else if (index == partitions) {
 				/* Increase the final partition. */
-				partition.width = (div_size / 2) + modulus;
-				partition.left -= div_size / 2;
+				partition->dest.width = div_size / 2 + modulus;
+				partition->dest.left -= div_size / 2;
 			}
 		} else if (index == partitions) {
-			partition.width = modulus;
+			partition->dest.width = modulus;
 		}
 	}
-
-	return partition;
 }
 
 static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
@@ -281,7 +280,7 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 			return -ENOMEM;
 
 		pipe->partitions = 1;
-		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
+		vsp1_video_partition(pipe, &pipe->part_table[0], div_size, 0);
 		return 0;
 	}
 
@@ -302,8 +301,11 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 	if (pipe->part_table == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < pipe->partitions; i++)
-		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
+	for (i = 0; i < pipe->partitions; i++) {
+		struct vsp1_partition *partition = &pipe->part_table[i];
+
+		vsp1_video_partition(pipe, partition, div_size, i);
+	}
 
 	return 0;
 }
@@ -388,7 +390,7 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_entity *entity;
 
-	pipe->partition = pipe->part_table[partition];
+	pipe->partition = &pipe->part_table[partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index b6c902be225b..75610475bc92 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -291,7 +291,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * multiple slices.
 		 */
 		if (pipe->partitions > 1)
-			width = pipe->partition.width;
+			width = pipe->partition->dest.width;
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -320,13 +320,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * is applied horizontally or vertically accordingly.
 		 */
 		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-			offset = format->width - pipe->partition.left
-				- pipe->partition.width;
+			offset = format->width - pipe->partition->dest.left
+				- pipe->partition->dest.width;
 		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-			offset = format->height - pipe->partition.left
-				- pipe->partition.width;
+			offset = format->height - pipe->partition->dest.left
+				- pipe->partition->dest.width;
 		else
-			offset = pipe->partition.left;
+			offset = pipe->partition->dest.left;
 
 		for (i = 0; i < format->num_planes; ++i) {
 			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
@@ -348,7 +348,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 			 * image height.
 			 */
 			if (wpf->flip.rotate)
-				height = pipe->partition.width;
+				height = pipe->partition->dest.width;
 			else
 				height = format->height;
 
-- 
git-series 0.9.1
