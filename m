Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753486AbdBJU16 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:58 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 6/8] v4l: vsp1: Allow entities to participate in the partition algorithm
Date: Fri, 10 Feb 2017 20:27:34 +0000
Message-Id: <be9e5af279f5adb4d1c3ada3c9402ce202aff5c4.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The configuration of the pipeline, and entities directly affects the
inputs required to each entity for the partition algorithm. Thus it
makes sense to involve those entities in the decision making process.

Extend the entity ops API to provide an optional '.partition' call. This
allows entities which may effect the partition window, to process based
on their configuration.

Entities implementing this operation must return their required input
parameters, which will be passed down the chain. This creates a process
whereby each entity describes what is required to satisfy the required
output to it's predecessor in the pipeline.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.h |  8 ++++-
 drivers/media/platform/vsp1/vsp1_pipe.c   | 22 ++++++++++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   | 35 +++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_rpf.c    | 33 +++++++++---------
 drivers/media/platform/vsp1/vsp1_sru.c    | 29 +++++++++++++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 45 ++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_video.c  | 32 ++++++++++-------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 29 +++++++++++----
 8 files changed, 195 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 901146f807b9..08aa29dea13b 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -21,6 +21,7 @@
 struct vsp1_device;
 struct vsp1_dl_list;
 struct vsp1_pipeline;
+struct vsp1_partition;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -79,12 +80,19 @@ struct vsp1_route {
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
+	struct vsp1_partition_rect *(*partition)(struct vsp1_entity *,
+						 struct vsp1_pipeline *,
+						 struct vsp1_partition *,
+						 unsigned int,
+						 struct vsp1_partition_rect *);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 280ba0804699..16f2eada54d5 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -331,6 +331,28 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
 }
 
+/*
+ * Propagate the partition calculations through the pipeline
+ *
+ * Work backwards through the pipe, allowing each entity to update
+ * the partition parameters based on it's configuration, and the entity
+ * connected to it's source. Each entity must produce the partition
+ * required for the next entity in the routing.
+ */
+void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
+				       struct vsp1_partition *partition,
+				       unsigned int index,
+				       struct vsp1_partition_rect *rect)
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
index 6494c4c75023..718ca0a5eca7 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -60,11 +60,32 @@ enum vsp1_pipeline_state {
 };
 
 /*
+ * struct vsp1_partition_rect
+ *
+ * replicates struct v4l2_rect, but with an offset to apply
+ */
+struct vsp1_partition_rect {
+	__s32   left;
+	__s32   top;
+	__u32   width;
+	__u32   height;
+	__u32   offset;
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
+	struct vsp1_partition_rect rpf;
+	struct vsp1_partition_rect uds_sink;
+	struct vsp1_partition_rect uds_source;
+	struct vsp1_partition_rect sru;
+	struct vsp1_partition_rect wpf;
 };
 
 /*
@@ -117,6 +138,11 @@ struct vsp1_pipeline {
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
 
+	/*
+	 * The order of this list should be representative of the order and
+	 * routing of the the pipeline, as it is assumed by the partition
+	 * algorithm that we can walk this list in sequence.
+	 */
 	struct list_head entities;
 
 	struct vsp1_dl_list *dl;
@@ -139,6 +165,11 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_dl_list *dl, unsigned int alpha);
 
+void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
+				       struct vsp1_partition *partition,
+				       unsigned int index,
+				       struct vsp1_partition_rect *rect);
+
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index df380a237118..94541ab4ca36 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -96,21 +96,8 @@ static void rpf_configure(struct vsp1_entity *entity,
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
-							    RWPF_PAD_SOURCE);
-
-			crop.width = pipe->partition->dest.width * input_width
-				   / output->width;
-			crop.left += pipe->partition->dest.left * input_width
-				   / output->width;
+			crop.width = pipe->partition->rpf.width;
+			crop.left += pipe->partition->rpf.left;
 		}
 
 		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
@@ -248,8 +235,24 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 }
 
+/*
+ * Perform RPF specific calculations for the Partition Algorithm
+ */
+struct vsp1_partition_rect *rpf_partition(struct vsp1_entity *entity,
+					  struct vsp1_pipeline *pipe,
+					  struct vsp1_partition *partition,
+					  unsigned int partition_idx,
+					  struct vsp1_partition_rect *dest)
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
index 42a3ed6d9461..d474a112483f 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_sru.h"
 
 #define SRU_MIN_SIZE				4U
@@ -326,9 +327,37 @@ static unsigned int sru_max_width(struct vsp1_entity *entity,
 		return 256;
 }
 
+struct vsp1_partition_rect *sru_partition(struct vsp1_entity *entity,
+					  struct vsp1_pipeline *pipe,
+					  struct vsp1_partition *partition,
+					  unsigned int partition_idx,
+					  struct vsp1_partition_rect *dest)
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
index 98c0836d6dcd..b274cbc2428b 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -274,10 +274,18 @@ static void uds_configure(struct vsp1_entity *entity,
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
 		struct vsp1_partition *partition = pipe->partition;
 
+		/* Input size clipping */
+		vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
+			       (partition->uds_sink.offset
+					<< VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
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
@@ -344,9 +352,42 @@ static unsigned int uds_max_width(struct vsp1_entity *entity,
 		return 2048;
 }
 
+/* -----------------------------------------------------------------------------
+ * Partition Algorithm Support
+ */
+
+/* Perform UDS specific calculations for the Partition Algorithm */
+struct vsp1_partition_rect *uds_partition(struct vsp1_entity *entity,
+					  struct vsp1_pipeline *pipe,
+					  struct vsp1_partition *partition,
+					  unsigned int partition_idx,
+					  struct vsp1_partition_rect *dest)
+{
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+	const struct v4l2_mbus_framefmt *output;
+	const struct v4l2_mbus_framefmt *input;
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
index 5f1886bfad26..99d1c69f9572 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -200,6 +200,7 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
 				 unsigned int div_size, unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_partition_rect dest;
 	unsigned int modulus;
 
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
@@ -208,19 +209,24 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
 
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
+		dest.offset = 0;
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
+	dest.offset = 0;
 
 	modulus = format->width % div_size;
 
@@ -243,16 +249,18 @@ static void vsp1_video_partition(struct vsp1_pipeline *pipe,
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
 
 static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index bd4cd2807cc6..2f83efee5d78 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -220,17 +220,19 @@ static void wpf_configure(struct vsp1_entity *entity,
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
+			offset = pipe->partition->wpf.offset;
+			width = pipe->partition->wpf.width;
+		}
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
-			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+			       (offset << VI6_WPF_SZCLIP_OFST_SHIFT) |
 			       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
 		vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -256,10 +258,10 @@ static void wpf_configure(struct vsp1_entity *entity,
 			 */
 			if (flip & BIT(WPF_CTRL_HFLIP))
 				offset = format->width
-					- pipe->partition->dest.left
-					- pipe->partition->dest.width;
+					- pipe->partition->wpf.left
+					- pipe->partition->wpf.width;
 			else
-				offset = pipe->partition->dest.left;
+				offset = pipe->partition->wpf.left;
 
 			mem.addr[0] += offset * fmtinfo->bpp[0] / 8;
 			if (format->num_planes > 1) {
@@ -355,9 +357,22 @@ static void wpf_configure(struct vsp1_entity *entity,
 			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
+struct vsp1_partition_rect *wpf_partition(struct vsp1_entity *entity,
+					  struct vsp1_pipeline *pipe,
+					  struct vsp1_partition *partition,
+					  unsigned int partition_idx,
+					  struct vsp1_partition_rect *dest)
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
+	.partition = wpf_partition,
 };
 
 /* -----------------------------------------------------------------------------
-- 
git-series 0.9.1
