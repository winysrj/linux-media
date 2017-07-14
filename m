Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753842AbdGNQIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 12:08:54 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 6/6] v4l: vsp1: Allow entities to participate in the partition algorithm
Date: Fri, 14 Jul 2017 17:08:37 +0100
Message-Id: <5fee73960b9a0ceb0ccf746dfeb06bdb07199670.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.525a94c41c3857a3f4bb8b8bbbccf78cf0c1dc78.1500048373.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The configuration of the pipeline and entities directly affects the
inputs required to each entity for the partition algorithm. Thus it
makes sense to involve those entities in the decision making process.

Extend the entity ops API to provide an optional '.partition' operation.
This allows entities that effect the partition window to adapt the
window based on their configuration.

Entities implementing this operation must return their required input
parameters, which will be passed up the pipeline. This creates a process
whereby each entity describes what is required to satisfy the required
output to its predecessor in the pipeline.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - vsp1_partition_rect renamed as vsp1_partition_window
 - destination vsp1_partition_window made const to prevent change
 - (currently) unused 'offset' removed.
 - partition functions made static
---
 drivers/media/platform/vsp1/vsp1_entity.h |  8 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.c   | 22 ++++++++++++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   | 35 ++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_rpf.c    | 31 +++++++++----------
 drivers/media/platform/vsp1/vsp1_sru.c    | 30 ++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 39 ++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_video.c  | 30 ++++++++++--------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 33 ++++++++++++++------
 8 files changed, 188 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 11f8363fa6b0..7475b504ca3b 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -21,6 +21,7 @@
 struct vsp1_device;
 struct vsp1_dl_list;
 struct vsp1_pipeline;
+struct vsp1_partition;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRS,
@@ -82,12 +83,19 @@ struct vsp1_route {
  *		selection rectangles, ...)
  * @max_width:	Return the max supported width of data that the entity can
  *		process in a single operation.
+ * @partition:	Process the partition construction based on this entity's
+ *		configuration.
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_dl_list *, enum vsp1_entity_params);
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
+	struct vsp1_partition_window *(*partition)(struct vsp1_entity *,
+					struct vsp1_pipeline *,
+					struct vsp1_partition *,
+					unsigned int,
+					const struct vsp1_partition_window *);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 4f4b732df84b..8e16f901ab80 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -383,6 +383,28 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
 }
 
+/*
+ * Propagate the partition calculations through the pipeline
+ *
+ * Work backwards through the pipe, allowing each entity to update the partition
+ * parameters based on its configuration, and the entity connected to its
+ * source. Each entity must produce the partition required for the previous
+ * entity in the pipeline.
+ */
+void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
+				       struct vsp1_partition *partition,
+				       unsigned int index,
+				       struct vsp1_partition_window *rect)
+{
+	struct vsp1_entity *entity;
+
+	list_for_each_entry_reverse(entity, &pipe->entities, list_pipe) {
+		if (entity->ops->partition)
+			rect = entity->ops->partition(entity, pipe, partition,
+						      index, rect);
+	}
+}
+
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 {
 	unsigned long flags;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 44506a315b5d..d5858a308ec0 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -58,11 +58,32 @@ enum vsp1_pipeline_state {
 };
 
 /*
+ * struct vsp1_partition_window
+ *
+ * replicates struct v4l2_rect, but allows us to extend on the needs of each
+ * partition.
+ */
+struct vsp1_partition_window {
+	__s32   left;
+	__s32   top;
+	__u32   width;
+	__u32   height;
+};
+
+/*
  * struct vsp1_partition - A description of each partition slice performed by HW
- * @dest: The position and dimension of this partition in the destination image
+ * @rpf: The RPF partition window configuration
+ * @uds_sink: The UDS input partition window configuration
+ * @uds_source: The UDS output partition window configuration
+ * @sru: The SRU partition window configuration
+ * @wpf: The WPF partition window configuration
  */
 struct vsp1_partition {
-	struct v4l2_rect dest;
+	struct vsp1_partition_window rpf;
+	struct vsp1_partition_window uds_sink;
+	struct vsp1_partition_window uds_source;
+	struct vsp1_partition_window sru;
+	struct vsp1_partition_window wpf;
 };
 
 /*
@@ -117,6 +138,11 @@ struct vsp1_pipeline {
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
 
+	/*
+	 * The order of this list must be identical to the order of the entities
+	 * in the pipeline, as it is assumed by the partition algorithm that we
+	 * can walk this list in sequence.
+	 */
 	struct list_head entities;
 
 	struct vsp1_dl_list *dl;
@@ -139,6 +165,11 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_dl_list *dl, unsigned int alpha);
 
+void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
+				       struct vsp1_partition *partition,
+				       unsigned int index,
+				       struct vsp1_partition_window *rect);
+
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 48b3e89c0e87..8c068aaa8314 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -97,21 +97,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 		 * 'width' need to be adjusted.
 		 */
 		if (pipe->partitions > 1) {
-			const struct v4l2_mbus_framefmt *output;
-			struct vsp1_entity *wpf = &pipe->output->entity;
-			unsigned int input_width = crop.width;
-
-			/*
-			 * Scale the partition window based on the configuration
-			 * of the pipeline.
-			 */
-			output = vsp1_entity_get_pad_format(wpf, wpf->config,
-							    RWPF_PAD_SINK);
-
-			crop.width = pipe->partition->dest.width * input_width
-				   / output->width;
-			crop.left += pipe->partition->dest.left * input_width
-				   / output->width;
+			crop.width = pipe->partition->rpf.width;
+			crop.left += pipe->partition->rpf.left;
 		}
 
 		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
@@ -260,8 +247,22 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 }
 
+static struct vsp1_partition_window *
+rpf_partition(struct vsp1_entity *entity,
+	      struct vsp1_pipeline *pipe,
+	      struct vsp1_partition *partition,
+	      unsigned int partition_idx,
+	      const struct vsp1_partition_window *dest)
+{
+	/* Duplicate the target configuration to the RPF */
+	partition->rpf = *dest;
+
+	return &partition->rpf;
+}
+
 static const struct vsp1_entity_operations rpf_entity_ops = {
 	.configure = rpf_configure,
+	.partition = rpf_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 30142793dfcd..219673d0d73e 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_sru.h"
 
 #define SRU_MIN_SIZE				4U
@@ -325,9 +326,38 @@ static unsigned int sru_max_width(struct vsp1_entity *entity,
 		return 256;
 }
 
+static struct vsp1_partition_window *
+sru_partition(struct vsp1_entity *entity,
+	      struct vsp1_pipeline *pipe,
+	      struct vsp1_partition *partition,
+	      unsigned int partition_idx,
+	      const struct vsp1_partition_window *dest)
+{
+	struct vsp1_sru *sru = to_sru(&entity->subdev);
+	struct v4l2_mbus_framefmt *input;
+	struct v4l2_mbus_framefmt *output;
+
+	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					   SRU_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					    SRU_PAD_SOURCE);
+
+	/* Copy the destination target */
+	partition->sru = *dest;
+
+	/* Adapt if SRUx2 is enabled */
+	if (input->width != output->width) {
+		partition->sru.width /= 2;
+		partition->sru.left /= 2;
+	}
+
+	return &partition->sru;
+}
+
 static const struct vsp1_entity_operations sru_entity_ops = {
 	.configure = sru_configure,
 	.max_width = sru_max_width,
+	.partition = sru_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index ea37ff5aee57..23df8ad6af1c 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -274,10 +274,16 @@ static void uds_configure(struct vsp1_entity *entity,
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
 		struct vsp1_partition *partition = pipe->partition;
 
+		/* Input size clipping */
+		vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
+			       (partition->uds_sink.width
+					<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
+
+		/* Output size clipping */
 		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-			       (partition->dest.width
+			       (partition->uds_source.width
 					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-			       (partition->dest.height
+			       (partition->uds_source.height
 					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 		return;
 	}
@@ -345,9 +351,38 @@ static unsigned int uds_max_width(struct vsp1_entity *entity,
 		return 2048;
 }
 
+static struct vsp1_partition_window *
+uds_partition(struct vsp1_entity *entity,
+	      struct vsp1_pipeline *pipe,
+	      struct vsp1_partition *partition,
+	      unsigned int partition_idx,
+	      const struct vsp1_partition_window *dest)
+{
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+	const struct v4l2_mbus_framefmt *input;
+	const struct v4l2_mbus_framefmt *output;
+
+	/* Initialise the partition state */
+	partition->uds_sink = *dest;
+	partition->uds_source = *dest;
+
+	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					   UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
+
+	partition->uds_sink.width = dest->width * input->width
+				  / output->width;
+	partition->uds_sink.left = dest->left * input->width
+				 / output->width;
+
+	return &partition->uds_sink;
+}
+
 static const struct vsp1_entity_operations uds_entity_ops = {
 	.configure = uds_configure,
 	.max_width = uds_max_width,
+	.partition = uds_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 42e5608d1ddf..5c9f18b1d5f4 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -196,6 +196,7 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
 				 unsigned int div_size, unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_partition_window dest;
 	unsigned int modulus;
 
 	/*
@@ -208,19 +209,22 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
-		partition->dest.left = 0;
-		partition->dest.top = 0;
-		partition->dest.width = format->width;
-		partition->dest.height = format->height;
+		dest.left = 0;
+		dest.top = 0;
+		dest.width = format->width;
+		dest.height = format->height;
+
+		vsp1_pipeline_propagate_partition(pipe, partition, index,
+						  &dest);
 
 		return;
 	}
 
 	/* Initialise the partition with sane starting conditions. */
-	partition->dest.left = index * div_size;
-	partition->dest.top = 0;
-	partition->dest.width = div_size;
-	partition->dest.height = format->height;
+	dest.left = index * div_size;
+	dest.top = 0;
+	dest.width = div_size;
+	dest.height = format->height;
 
 	modulus = format->width % div_size;
 
@@ -243,16 +247,18 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
 		if (modulus < div_size / 2) {
 			if (index == partitions - 1) {
 				/* Halve the penultimate partition. */
-				partition->dest.width = div_size / 2;
+				dest.width = div_size / 2;
 			} else if (index == partitions) {
 				/* Increase the final partition. */
-				partition->dest.width = div_size / 2 + modulus;
-				partition->dest.left -= div_size / 2;
+				dest.width = div_size / 2 + modulus;
+				dest.left -= div_size / 2;
 			}
 		} else if (index == partitions) {
-			partition->dest.width = modulus;
+			dest.width = modulus;
 		}
 	}
+
+	vsp1_pipeline_propagate_partition(pipe, partition, index, &dest);
 }
 
 static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 75610475bc92..63fd3a8a6aff 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -284,14 +284,15 @@ static void wpf_configure(struct vsp1_entity *entity,
 		unsigned int flip = wpf->flip.active;
 		unsigned int width = sink_format->width;
 		unsigned int height = sink_format->height;
-		unsigned int offset;
+		unsigned int offset = 0;
 
 		/*
 		 * Cropping. The partition algorithm can split the image into
 		 * multiple slices.
 		 */
-		if (pipe->partitions > 1)
-			width = pipe->partition->dest.width;
+		if (pipe->partitions > 1) {
+			width = pipe->partition->wpf.width;
+		}
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -320,13 +321,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * is applied horizontally or vertically accordingly.
 		 */
 		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-			offset = format->width - pipe->partition->dest.left
-				- pipe->partition->dest.width;
+			offset = format->width - pipe->partition->wpf.left
+				- pipe->partition->wpf.width;
 		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-			offset = format->height - pipe->partition->dest.left
-				- pipe->partition->dest.width;
+			offset = format->height - pipe->partition->wpf.left
+				- pipe->partition->wpf.width;
 		else
-			offset = pipe->partition->dest.left;
+			offset = pipe->partition->wpf.left;
 
 		for (i = 0; i < format->num_planes; ++i) {
 			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
@@ -348,7 +349,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 			 * image height.
 			 */
 			if (wpf->flip.rotate)
-				height = pipe->partition->dest.width;
+				height = pipe->partition->wpf.width;
 			else
 				height = format->height;
 
@@ -473,10 +474,24 @@ static unsigned int wpf_max_width(struct vsp1_entity *entity,
 	return wpf->flip.rotate ? 256 : wpf->max_width;
 }
 
+static struct vsp1_partition_window *
+wpf_partition(struct vsp1_entity *entity,
+	      struct vsp1_pipeline *pipe,
+	      struct vsp1_partition *partition,
+	      unsigned int partition_idx,
+	      const struct vsp1_partition_window *dest)
+{
+	/* Initialise the WPF partition */
+	partition->wpf = *dest;
+
+	return &partition->wpf;
+}
+
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
 	.configure = wpf_configure,
 	.max_width = wpf_max_width,
+	.partition = wpf_partition,
 };
 
 /* -----------------------------------------------------------------------------
-- 
git-series 0.9.1
