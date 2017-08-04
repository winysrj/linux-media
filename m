Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753042AbdHDQc7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 12:32:59 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        hans.verkuil@cisco.com
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4 7/7] v4l: vsp1: Allow entities to participate in the partition algorithm
Date: Fri,  4 Aug 2017 17:32:44 +0100
Message-Id: <e63664c935c09947e72533477ab8ddb676686138.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.b619f10db4b4618832ca73df5688ce9f2f36596b.1501864274.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The configuration of the pipeline and entities directly affects the
inputs required to each entity for the partition algorithm. Thus it
makes sense to involve those entities in the decision making process.

Extend the entity ops API to provide an optional .partition() operation.
This allows entities that affect the partition window to adapt the
window based on their configuration.

Entities implementing this operation must update the window parameter in
place, which will then be passed up the pipeline. This creates a process
whereby each entity describes what is required to satisfy the required
output to its predecessor in the pipeline.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.h |  7 ++++-
 drivers/media/platform/vsp1/vsp1_pipe.c   | 22 +++++++++++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   | 30 ++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_rpf.c    | 27 +++++++---------
 drivers/media/platform/vsp1/vsp1_sru.c    | 26 +++++++++++++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 41 +++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.c  | 22 ++++++++-----
 drivers/media/platform/vsp1/vsp1_wpf.c    | 24 +++++++++-----
 8 files changed, 166 insertions(+), 33 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c169a060b6d2..05c616883f4a 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -21,6 +21,8 @@
 struct vsp1_device;
 struct vsp1_dl_list;
 struct vsp1_pipeline;
+struct vsp1_partition;
+struct vsp1_partition_window;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -81,12 +83,17 @@ struct vsp1_route {
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
+	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
+			  struct vsp1_partition *, unsigned int,
+			  struct vsp1_partition_window *);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index e817623b84e0..eff346727c72 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -382,6 +382,28 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
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
+				       struct vsp1_partition_window *window)
+{
+	struct vsp1_entity *entity;
+
+	list_for_each_entry_reverse(entity, &pipe->entities, list_pipe) {
+		if (entity->ops->partition)
+			entity->ops->partition(entity, pipe, partition, index,
+					       window);
+	}
+}
+
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 {
 	unsigned long flags;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 4e9fd96108be..424e43fafaa5 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -58,17 +58,33 @@ enum vsp1_pipeline_state {
 };
 
 /*
- * struct vsp1_partition - A description of a slice for the partition algorithm
+ * struct vsp1_partition_window - Partition window coordinates
  * @left: horizontal coordinate of the partition start in pixels relative to the
  *	  left edge of the image
  * @width: partition width in pixels
  */
-struct vsp1_partition {
+struct vsp1_partition_window {
 	unsigned int left;
 	unsigned int width;
 };
 
 /*
+ * struct vsp1_partition - A description of a slice for the partition algorithm
+ * @rpf: The RPF partition window configuration
+ * @uds_sink: The UDS input partition window configuration
+ * @uds_source: The UDS output partition window configuration
+ * @sru: The SRU partition window configuration
+ * @wpf: The WPF partition window configuration
+ */
+struct vsp1_partition {
+	struct vsp1_partition_window rpf;
+	struct vsp1_partition_window uds_sink;
+	struct vsp1_partition_window uds_source;
+	struct vsp1_partition_window sru;
+	struct vsp1_partition_window wpf;
+};
+
+/*
  * struct vsp1_pipeline - A VSP1 hardware pipeline
  * @pipe: the media pipeline
  * @irqlock: protects the pipeline state
@@ -120,6 +136,11 @@ struct vsp1_pipeline {
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
 
+	/*
+	 * The order of this list must be identical to the order of the entities
+	 * in the pipeline, as it is assumed by the partition algorithm that we
+	 * can walk this list in sequence.
+	 */
 	struct list_head entities;
 
 	struct vsp1_dl_list *dl;
@@ -142,6 +163,11 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_dl_list *dl, unsigned int alpha);
 
+void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
+				       struct vsp1_partition *partition,
+				       unsigned int index,
+				       struct vsp1_partition_window *window);
+
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
 void vsp1_pipelines_resume(struct vsp1_device *vsp1);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 126741f00ae3..fe0633da5a5f 100644
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
-			crop.width = pipe->partition->width * input_width
-				   / output->width;
-			crop.left += pipe->partition->left * input_width
-				   / output->width;
+			crop.width = pipe->partition->rpf.width;
+			crop.left += pipe->partition->rpf.left;
 		}
 
 		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
@@ -260,8 +247,18 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 }
 
+static void rpf_partition(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_partition *partition,
+			  unsigned int partition_idx,
+			  struct vsp1_partition_window *window)
+{
+	partition->rpf = *window;
+}
+
 static const struct vsp1_entity_operations rpf_entity_ops = {
 	.configure = rpf_configure,
+	.partition = rpf_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 30142793dfcd..51e5691187c3 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_sru.h"
 
 #define SRU_MIN_SIZE				4U
@@ -325,9 +326,34 @@ static unsigned int sru_max_width(struct vsp1_entity *entity,
 		return 256;
 }
 
+static void sru_partition(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_partition *partition,
+			  unsigned int partition_idx,
+			  struct vsp1_partition_window *window)
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
+	/* Adapt if SRUx2 is enabled */
+	if (input->width != output->width) {
+		window->width /= 2;
+		window->left /= 2;
+	}
+
+	partition->sru = *window;
+}
+
 static const struct vsp1_entity_operations sru_entity_ops = {
 	.configure = sru_configure,
 	.max_width = sru_max_width,
+	.partition = sru_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 4a43e7413b68..72f72a9d2152 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -279,8 +279,15 @@ static void uds_configure(struct vsp1_entity *entity,
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
 		struct vsp1_partition *partition = pipe->partition;
 
+		/* Input size clipping */
+		vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
+			       (0 << VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
+			       (partition->uds_sink.width
+					<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
+
+		/* Output size clipping */
 		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-			       (partition->width
+			       (partition->uds_source.width
 					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
 			       (output->height
 					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
@@ -345,9 +352,41 @@ static unsigned int uds_max_width(struct vsp1_entity *entity,
 		return 2048;
 }
 
+/* -----------------------------------------------------------------------------
+ * Partition Algorithm Support
+ */
+
+static void uds_partition(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_partition *partition,
+			  unsigned int partition_idx,
+			  struct vsp1_partition_window *window)
+{
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+	const struct v4l2_mbus_framefmt *output;
+	const struct v4l2_mbus_framefmt *input;
+
+	/* Initialise the partition state */
+	partition->uds_sink = *window;
+	partition->uds_source = *window;
+
+	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					   UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
+
+	partition->uds_sink.width = window->width * input->width
+				  / output->width;
+	partition->uds_sink.left = window->left * input->width
+				 / output->width;
+
+	*window = partition->uds_sink;
+}
+
 static const struct vsp1_entity_operations uds_entity_ops = {
 	.configure = uds_configure,
 	.max_width = uds_max_width,
+	.partition = uds_partition,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index abbdcafa7c94..ab53132ad3fa 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -196,6 +196,7 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 					   unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_partition_window window;
 	unsigned int modulus;
 
 	/*
@@ -208,14 +209,17 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
-		partition->left = 0;
-		partition->width = format->width;
+		window.left = 0;
+		window.width = format->width;
+
+		vsp1_pipeline_propagate_partition(pipe, partition, index,
+						  &window);
 		return;
 	}
 
 	/* Initialise the partition with sane starting conditions. */
-	partition->left = index * div_size;
-	partition->width = div_size;
+	window.left = index * div_size;
+	window.width = div_size;
 
 	modulus = format->width % div_size;
 
@@ -238,16 +242,18 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 		if (modulus < div_size / 2) {
 			if (index == partitions - 1) {
 				/* Halve the penultimate partition. */
-				partition->width = div_size / 2;
+				window.width = div_size / 2;
 			} else if (index == partitions) {
 				/* Increase the final partition. */
-				partition->width = (div_size / 2) + modulus;
-				partition->left -= div_size / 2;
+				window.width = (div_size / 2) + modulus;
+				window.left -= div_size / 2;
 			}
 		} else if (index == partitions) {
-			partition->width = modulus;
+			window.width = modulus;
 		}
 	}
+
+	vsp1_pipeline_propagate_partition(pipe, partition, index, &window);
 }
 
 static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index c8f7cf048841..0b882074315e 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -291,7 +291,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * multiple slices.
 		 */
 		if (pipe->partitions > 1)
-			width = pipe->partition->width;
+			width = pipe->partition->wpf.width;
 
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -320,13 +320,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		 * is applied horizontally or vertically accordingly.
 		 */
 		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-			offset = format->width - pipe->partition->left
-				- pipe->partition->width;
+			offset = format->width - pipe->partition->wpf.left
+				- pipe->partition->wpf.width;
 		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-			offset = format->height - pipe->partition->left
-				- pipe->partition->width;
+			offset = format->height - pipe->partition->wpf.left
+				- pipe->partition->wpf.width;
 		else
-			offset = pipe->partition->left;
+			offset = pipe->partition->wpf.left;
 
 		for (i = 0; i < format->num_planes; ++i) {
 			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
@@ -348,7 +348,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 			 * image height.
 			 */
 			if (wpf->flip.rotate)
-				height = pipe->partition->width;
+				height = pipe->partition->wpf.width;
 			else
 				height = format->height;
 
@@ -471,10 +471,20 @@ static unsigned int wpf_max_width(struct vsp1_entity *entity,
 	return wpf->flip.rotate ? 256 : wpf->max_width;
 }
 
+static void wpf_partition(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_partition *partition,
+			  unsigned int partition_idx,
+			  struct vsp1_partition_window *window)
+{
+	partition->wpf = *window;
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
