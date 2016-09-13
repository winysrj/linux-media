Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759587AbcIMXQm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:42 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 12/13] v4l: vsp1: Support multiple partitions per frame
Date: Wed, 14 Sep 2016 02:17:05 +0300
Message-Id: <1473808626-19488-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran+renesas@bingham.xyz>

Adapt vsp1_video_pipeline_run() such that it can iterate each partition
required for constructing this frame's display list chain in the event
that multiple display lists are required to process in hardware.

The first display list is held as the head list object, whilst any
following parition display lists are linked to the head by means of
vsp1_dl_list_add_chain().

Linking the chained display list headers to process using the auto start
mechanism of the hardware is performed during the vsp1_dl_list_commit().

Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |   3 +
 drivers/media/platform/vsp1/vsp1_rpf.c   |  46 +++++++++---
 drivers/media/platform/vsp1/vsp1_uds.c   |  15 +++-
 drivers/media/platform/vsp1/vsp1_video.c | 121 ++++++++++++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_wpf.c   |  30 +++++++-
 5 files changed, 195 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index af4cd23d399b..f15b697ad999 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -79,6 +79,7 @@ enum vsp1_pipeline_state {
  * @dl: display list associated with the pipeline
  * @div_size: The maximum allowed partition size for the pipeline
  * @partitions: The number of partitions used to process one frame
+ * @current_partition: The partition number currently being configured
  */
 struct vsp1_pipeline {
 	struct media_pipeline pipe;
@@ -109,6 +110,8 @@ struct vsp1_pipeline {
 
 	unsigned int div_size;
 	unsigned int partitions;
+	struct v4l2_rect partition;
+	unsigned int current_partition;
 };
 
 void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index de5ef76c5004..e6236ff2f74a 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -72,8 +72,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 	}
 
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		const struct v4l2_rect *crop;
 		unsigned int offsets[2];
+		struct v4l2_rect crop;
 
 		/* Source size and crop offsets.
 		 *
@@ -82,21 +82,47 @@ static void rpf_configure(struct vsp1_entity *entity,
 		 * offsets are needed, as planes 2 and 3 always have identical
 		 * strides.
 		 */
-		crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+		crop = *vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+
+		/* Partition Algorithm Control
+		 *
+		 * The partition algorithm can split this frame into multiple
+		 * slices. We must scale our partition window based on the pipe
+		 * configuration to match the destination partition window.
+		 * To achieve this, we adjust our crop to provide a 'sub-crop'
+		 * matching the expected partition window. Only 'left' and
+		 * 'width' need to be adjusted.
+		 */
+		if (pipe->partitions > 1) {
+			const struct v4l2_mbus_framefmt *output;
+			struct vsp1_entity *wpf = &pipe->output->entity;
+			unsigned int input_width = crop.width;
+
+			/* Scale the partition window based on the configuration
+			 * of the pipeline.
+			 */
+			output = vsp1_entity_get_pad_format(wpf, wpf->config,
+							    RWPF_PAD_SOURCE);
+
+			crop.width = pipe->partition.width * input_width
+				   / output->width;
+			crop.left += pipe->partition.left * input_width
+				   / output->width;
+		}
 
 		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
-			       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
-			       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
+			       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
+			       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
 		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
-			       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
-			       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+			       (crop.width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
+			       (crop.height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
-		offsets[0] = crop->top * format->plane_fmt[0].bytesperline
-			   + crop->left * fmtinfo->bpp[0] / 8;
+		offsets[0] = crop.top * format->plane_fmt[0].bytesperline
+			   + crop.left * fmtinfo->bpp[0] / 8;
 
 		if (format->num_planes > 1)
-			offsets[1] = crop->top * format->plane_fmt[1].bytesperline
-				   + crop->left / fmtinfo->hsub
+			offsets[1] = crop.top * format->plane_fmt[1].bytesperline
+				   + crop.left / fmtinfo->hsub
 				   * fmtinfo->bpp[1] / 8;
 		else
 			offsets[1] = 0;
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 706b6e85f47d..da8f89a31ea4 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_dl.h"
+#include "vsp1_pipe.h"
 #include "vsp1_uds.h"
 
 #define UDS_MIN_SIZE				4U
@@ -270,6 +271,15 @@ static void uds_configure(struct vsp1_entity *entity,
 	unsigned int vscale;
 	bool multitap;
 
+	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
+		const struct v4l2_rect *clip = &pipe->partition;
+
+		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
+			       (clip->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+			       (clip->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+		return;
+	}
+
 	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
@@ -302,13 +312,10 @@ static void uds_configure(struct vsp1_entity *entity,
 		       (uds_passband_width(vscale)
 				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
 
-	/* Set the scaling ratios and the output size. */
+	/* Set the scaling ratios. */
 	vsp1_uds_write(uds, dl, VI6_UDS_SCALE,
 		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
 		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
-	vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-		       (output->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 }
 
 static unsigned int uds_max_width(struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b903cc5471e0..15d08cb50bd1 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -205,6 +205,74 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
 }
 
+/*
+ * vsp1_video_partition - Calculate the active partition output window
+ *
+ * @div_size: pre-determined maximum partition division size
+ * @index: partition index
+ *
+ * Returns a v4l2_rect describing the partition window.
+ */
+static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
+					     unsigned int div_size,
+					     unsigned int index)
+{
+	const struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect partition;
+	unsigned int modulus;
+
+	format = vsp1_entity_get_pad_format(&pipe->output->entity,
+					    pipe->output->entity.config,
+					    RWPF_PAD_SOURCE);
+
+	/* A single partition simply processes the output size in full. */
+	if (pipe->partitions <= 1) {
+		partition.left = 0;
+		partition.top = 0;
+		partition.width = format->width;
+		partition.height = format->height;
+		return partition;
+	}
+
+	/* Initialise the partition with sane starting conditions. */
+	partition.left = index * div_size;
+	partition.top = 0;
+	partition.width = div_size;
+	partition.height = format->height;
+
+	modulus = format->width % div_size;
+
+	/* We need to prevent the last partition from being smaller than the
+	 * *minimum* width of the hardware capabilities.
+	 *
+	 * If the modulus is less than half of the partition size,
+	 * the penultimate partition is reduced to half, which is added
+	 * to the final partition: |1234|1234|1234|12|341|
+	 * to prevents this:       |1234|1234|1234|1234|1|.
+	 */
+	if (modulus) {
+		/* pipe->partitions is 1 based, whilst index is a 0 based index.
+		 * Normalise this locally.
+		 */
+		unsigned int partitions = pipe->partitions - 1;
+
+		if (modulus < div_size / 2) {
+			if (index == partitions - 1) {
+				/* Halve the penultimate partition. */
+				partition.width = div_size / 2;
+			} else if (index == partitions) {
+				/* Increase the final partition. */
+				partition.width = (div_size / 2) + modulus;
+				partition.left -= div_size / 2;
+			}
+		} else if (index == partitions) {
+			partition.width = modulus;
+		}
+	}
+
+	return partition;
+}
+
 /* -----------------------------------------------------------------------------
  * Pipeline Management
  */
@@ -280,22 +348,69 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 	pipe->buffers_ready |= 1 << video->pipe_index;
 }
 
+static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
+					      struct vsp1_dl_list *dl)
+{
+	struct vsp1_entity *entity;
+
+	pipe->partition = vsp1_video_partition(pipe, pipe->div_size,
+					       pipe->current_partition);
+
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		if (entity->ops->configure)
+			entity->ops->configure(entity, pipe, dl,
+					       VSP1_ENTITY_PARAMS_PARTITION);
+	}
+}
+
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
+	/* Start with the runtime parameters as the configure operation can
+	 * compute/cache information needed when configuring partitions. This
+	 * is the case with flipping in the WPF.
+	 */
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->ops->configure) {
+		if (entity->ops->configure)
 			entity->ops->configure(entity, pipe, pipe->dl,
 					       VSP1_ENTITY_PARAMS_RUNTIME);
-			entity->ops->configure(entity, pipe, pipe->dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
+	}
+
+	/* Run the first partition */
+	pipe->current_partition = 0;
+	vsp1_video_pipeline_run_partition(pipe, pipe->dl);
+
+	/* Process consecutive partitions as necessary */
+	for (pipe->current_partition = 1;
+	     pipe->current_partition < pipe->partitions;
+	     pipe->current_partition++) {
+		struct vsp1_dl_list *dl;
+
+		/* Partition configuration operations will utilise
+		 * the pipe->current_partition variable to determine
+		 * the work they should complete.
+		 */
+		dl = vsp1_dl_list_get(pipe->output->dlm);
+
+		/* An incomplete chain will still function, but output only
+		 * the partitions that had a dl available. The frame end
+		 * interrupt will be marked on the last dl in the chain.
+		 */
+		if (!dl) {
+			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be incomplete\n");
+			break;
 		}
+
+		vsp1_video_pipeline_run_partition(pipe, dl);
+		vsp1_dl_list_add_chain(pipe->dl, dl);
 	}
 
+	/* Complete, and commit the head display list. */
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index b757d2579d6c..fdee5a891e40 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -224,6 +224,9 @@ static void wpf_configure(struct vsp1_entity *entity,
 		/* Cropping. The partition algorithm can split the image into
 		 * multiple slices.
 		 */
+		if (pipe->partitions > 1)
+			width = pipe->partition.width;
+
 		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
 			       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
@@ -237,10 +240,31 @@ static void wpf_configure(struct vsp1_entity *entity,
 		/* Update the memory offsets based on flipping configuration.
 		 * The destination addresses point to the locations where the
 		 * VSP starts writing to memory, which can be different corners
-		 * of the image depending on vertical flipping. Horizontal
-		 * flipping is handled through a line buffer and doesn't modify
-		 * the start address.
+		 * of the image depending on vertical flipping.
 		 */
+		if (pipe->partitions > 1) {
+			const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
+
+			/* Horizontal flipping is handled through a line buffer
+			 * and doesn't modify the start address, but still needs
+			 * to be handled when image partitioning is in effect to
+			 * order the partitions correctly.
+			 */
+			if (flip & BIT(WPF_CTRL_HFLIP))
+				offset = format->width - pipe->partition.left
+					- pipe->partition.width;
+			else
+				offset = pipe->partition.left;
+
+			mem.addr[0] += offset * fmtinfo->bpp[0] / 8;
+			if (format->num_planes > 1) {
+				mem.addr[1] += offset / fmtinfo->hsub
+					     * fmtinfo->bpp[1] / 8;
+				mem.addr[2] += offset / fmtinfo->hsub
+					     * fmtinfo->bpp[2] / 8;
+			}
+		}
+
 		if (flip & BIT(WPF_CTRL_VFLIP)) {
 			mem.addr[0] += (format->height - 1)
 				     * format->plane_fmt[0].bytesperline;
-- 
Regards,

Laurent Pinchart

