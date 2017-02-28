Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44730 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752000AbdB1POM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:14:12 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 3/3] v4l: vsp1: wpf: Implement rotation support
Date: Tue, 28 Feb 2017 17:03:20 +0200
Message-Id: <20170228150320.10104-4-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some WPF instances, on Gen3 devices, can perform 90° rotation when
writing frames to memory. Implement support for this using the
V4L2_CID_ROTATE control.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   |   2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c  |   5 +
 drivers/media/platform/vsp1/vsp1_rwpf.h  |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c |  12 +-
 drivers/media/platform/vsp1/vsp1_wpf.c   | 205 +++++++++++++++++++++++--------
 5 files changed, 175 insertions(+), 52 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index f5a9a4c8c74d..8feddd59cf8d 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -106,7 +106,7 @@ static void rpf_configure(struct vsp1_entity *entity,
 			 * of the pipeline.
 			 */
 			output = vsp1_entity_get_pad_format(wpf, wpf->config,
-							    RWPF_PAD_SOURCE);
+							    RWPF_PAD_SINK);
 
 			crop.width = pipe->partition.width * input_width
 				   / output->width;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 7d52c88a583e..cfd8f1904fa6 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -121,6 +121,11 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 					    RWPF_PAD_SOURCE);
 	*format = fmt->format;
 
+	if (rwpf->flip.rotate) {
+		format->width = fmt->format.height;
+		format->height = fmt->format.width;
+	}
+
 done:
 	mutex_unlock(&rwpf->entity.lock);
 	return ret;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 1c98aff3da5d..b4ffc38f48af 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -56,9 +56,10 @@ struct vsp1_rwpf {
 
 	struct {
 		spinlock_t lock;
-		struct v4l2_ctrl *ctrls[2];
+		struct v4l2_ctrl *ctrls[3];
 		unsigned int pending;
 		unsigned int active;
+		bool rotate;
 	} flip;
 
 	struct vsp1_rwpf_memory mem;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 5239e08fabc3..795a3ca9ca03 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -187,9 +187,13 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 	struct vsp1_entity *entity;
 	unsigned int div_size;
 
+	/*
+	 * Partitions are computed on the size before rotation, use the format
+	 * at the WPF sink.
+	 */
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
 					    pipe->output->entity.config,
-					    RWPF_PAD_SOURCE);
+					    RWPF_PAD_SINK);
 	div_size = format->width;
 
 	/* Gen2 hardware doesn't require image partitioning. */
@@ -229,9 +233,13 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 	struct v4l2_rect partition;
 	unsigned int modulus;
 
+	/*
+	 * Partitions are computed on the size before rotation, use the format
+	 * at the WPF sink.
+	 */
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
 					    pipe->output->entity.config,
-					    RWPF_PAD_SOURCE);
+					    RWPF_PAD_SINK);
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 25a2ed6e2e18..82935d97cad9 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -43,32 +43,94 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
 enum wpf_flip_ctrl {
 	WPF_CTRL_VFLIP = 0,
 	WPF_CTRL_HFLIP = 1,
-	WPF_CTRL_MAX,
+	WPF_CTRL_ROTATE = 2,
 };
 
+static int vsp1_wpf_set_rotation(struct vsp1_rwpf *wpf, unsigned int rotation)
+{
+	struct vsp1_video *video = wpf->video;
+	struct v4l2_mbus_framefmt *sink_format;
+	struct v4l2_mbus_framefmt *source_format;
+	bool rotate;
+	int ret = 0;
+
+	/*
+	 * Only consider the 0°/180° from/to 90°/270° modifications, the rest
+	 * is taken care of by the flipping configuration.
+	 */
+	rotate = rotation == 90 || rotation == 270;
+	if (rotate == wpf->flip.rotate)
+		return 0;
+
+	/* Changing rotation isn't allowed when buffers are allocated. */
+	mutex_lock(&video->lock);
+
+	if (vb2_is_busy(&video->queue)) {
+		ret = -EBUSY;
+		goto done;
+	}
+
+	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
+						 wpf->entity.config,
+						 RWPF_PAD_SINK);
+	source_format = vsp1_entity_get_pad_format(&wpf->entity,
+						   wpf->entity.config,
+						   RWPF_PAD_SOURCE);
+
+	mutex_lock(&wpf->entity.lock);
+
+	if (rotate) {
+		source_format->width = sink_format->height;
+		source_format->height = sink_format->width;
+	} else {
+		source_format->width = sink_format->width;
+		source_format->height = sink_format->height;
+	}
+
+	wpf->flip.rotate = rotate;
+
+	mutex_unlock(&wpf->entity.lock);
+
+done:
+	mutex_unlock(&video->lock);
+	return ret;
+}
+
 static int vsp1_wpf_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vsp1_rwpf *wpf =
 		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
-	unsigned int i;
+	unsigned int rotation;
 	u32 flip = 0;
+	int ret;
 
-	switch (ctrl->id) {
-	case V4L2_CID_HFLIP:
-	case V4L2_CID_VFLIP:
-		for (i = 0; i < WPF_CTRL_MAX; ++i) {
-			if (wpf->flip.ctrls[i])
-				flip |= wpf->flip.ctrls[i]->val ? BIT(i) : 0;
-		}
+	/* Update the rotation. */
+	rotation = wpf->flip.ctrls[WPF_CTRL_ROTATE]
+		 ? wpf->flip.ctrls[WPF_CTRL_ROTATE]->val : 0;
 
-		spin_lock_irq(&wpf->flip.lock);
-		wpf->flip.pending = flip;
-		spin_unlock_irq(&wpf->flip.lock);
-		break;
+	ret = vsp1_wpf_set_rotation(wpf, rotation);
+	if (ret < 0)
+		return ret;
 
-	default:
-		return -EINVAL;
-	}
+	/*
+	 * Compute the flip value resulting from all three controls, with
+	 * rotation by 180° flipping the image in both directions. Store the
+	 * result in the pending flip field for the next frame that will be
+	 * processed.
+	 */
+	if (wpf->flip.ctrls[WPF_CTRL_VFLIP]->val)
+		flip |= BIT(WPF_CTRL_VFLIP);
+
+	if (wpf->flip.ctrls[WPF_CTRL_HFLIP] &&
+	    wpf->flip.ctrls[WPF_CTRL_HFLIP]->val)
+		flip |= BIT(WPF_CTRL_HFLIP);
+
+	if (rotation == 180 || rotation == 270)
+		flip ^= BIT(WPF_CTRL_VFLIP) | BIT(WPF_CTRL_HFLIP);
+
+	spin_lock_irq(&wpf->flip.lock);
+	wpf->flip.pending = flip;
+	spin_unlock_irq(&wpf->flip.lock);
 
 	return 0;
 }
@@ -89,10 +151,10 @@ static int wpf_init_controls(struct vsp1_rwpf *wpf)
 		num_flip_ctrls = 0;
 	} else if (vsp1->info->features & VSP1_HAS_WPF_HFLIP) {
 		/*
-		 * When horizontal flip is supported the WPF implements two
-		 * controls (horizontal flip and vertical flip).
+		 * When horizontal flip is supported the WPF implements three
+		 * controls (horizontal flip, vertical flip and rotation).
 		 */
-		num_flip_ctrls = 2;
+		num_flip_ctrls = 3;
 	} else if (vsp1->info->features & VSP1_HAS_WPF_VFLIP) {
 		/*
 		 * When only vertical flip is supported the WPF implements a
@@ -112,12 +174,14 @@ static int wpf_init_controls(struct vsp1_rwpf *wpf)
 					  V4L2_CID_VFLIP, 0, 1, 1, 0);
 	}
 
-	if (num_flip_ctrls == 2) {
+	if (num_flip_ctrls == 3) {
 		wpf->flip.ctrls[WPF_CTRL_HFLIP] =
 			v4l2_ctrl_new_std(&wpf->ctrls, &vsp1_wpf_ctrl_ops,
 					  V4L2_CID_HFLIP, 0, 1, 1, 0);
-
-		v4l2_ctrl_cluster(2, wpf->flip.ctrls);
+		wpf->flip.ctrls[WPF_CTRL_ROTATE] =
+			v4l2_ctrl_new_std(&wpf->ctrls, &vsp1_wpf_ctrl_ops,
+					  V4L2_CID_ROTATE, 0, 270, 90, 0);
+		v4l2_ctrl_cluster(3, wpf->flip.ctrls);
 	}
 
 	if (wpf->ctrls.error) {
@@ -222,8 +286,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 		struct vsp1_rwpf_memory mem = wpf->mem;
 		unsigned int flip = wpf->flip.active;
-		unsigned int width = source_format->width;
-		unsigned int height = source_format->height;
+		unsigned int width = sink_format->width;
+		unsigned int height = sink_format->height;
 		unsigned int offset;
 
 		/*
@@ -246,45 +310,78 @@ static void wpf_configure(struct vsp1_entity *entity,
 		/*
 		 * Update the memory offsets based on flipping configuration.
 		 * The destination addresses point to the locations where the
-		 * VSP starts writing to memory, which can be different corners
-		 * of the image depending on vertical flipping.
+		 * VSP starts writing to memory, which can be any corner of the
+		 * image depending on the combination of flipping and rotation.
 		 */
-		if (pipe->partitions > 1) {
-			const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
-			/*
-			 * Horizontal flipping is handled through a line buffer
-			 * and doesn't modify the start address, but still needs
-			 * to be handled when image partitioning is in effect to
-			 * order the partitions correctly.
-			 */
-			if (flip & BIT(WPF_CTRL_HFLIP))
-				offset = format->width - pipe->partition.left
-					- pipe->partition.width;
+		/*
+		 * First take the partition left coordinate into account.
+		 * Compute the offset to order the partitions correctly on the
+		 * output based on whether flipping is enabled. Consider
+		 * horizontal flipping when rotation is disabled but vertical
+		 * flipping when rotation is enabled, as rotating the image
+		 * switches the horizontal and vertical directions. The offset
+		 * is applied horizontally or vertically accordingly.
+		 */
+		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
+			offset = format->width - pipe->partition.left
+				- pipe->partition.width;
+		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
+			offset = format->height - pipe->partition.left
+				- pipe->partition.width;
+		else
+			offset = pipe->partition.left;
+
+		for (i = 0; i < format->num_planes; ++i) {
+			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
+			unsigned int vsub = i > 0 ? fmtinfo->vsub : 1;
+
+			if (wpf->flip.rotate)
+				mem.addr[i] += offset / vsub
+					     * format->plane_fmt[i].bytesperline;
 			else
-				offset = pipe->partition.left;
-
-			mem.addr[0] += offset * fmtinfo->bpp[0] / 8;
-			if (format->num_planes > 1) {
-				mem.addr[1] += offset / fmtinfo->hsub
-					     * fmtinfo->bpp[1] / 8;
-				mem.addr[2] += offset / fmtinfo->hsub
-					     * fmtinfo->bpp[2] / 8;
-			}
+				mem.addr[i] += offset / hsub
+					     * fmtinfo->bpp[i] / 8;
 		}
 
 		if (flip & BIT(WPF_CTRL_VFLIP)) {
-			mem.addr[0] += (format->height - 1)
+			/*
+			 * When rotating the output (after rotation) image
+			 * height is equal to the partition width (before
+			 * rotation). Otherwise it is equal to the output
+			 * image height.
+			 */
+			if (wpf->flip.rotate)
+				height = pipe->partition.width;
+			else
+				height = format->height;
+
+			mem.addr[0] += (height - 1)
 				     * format->plane_fmt[0].bytesperline;
 
 			if (format->num_planes > 1) {
-				offset = (format->height / wpf->fmtinfo->vsub - 1)
+				offset = (height / fmtinfo->vsub - 1)
 				       * format->plane_fmt[1].bytesperline;
 				mem.addr[1] += offset;
 				mem.addr[2] += offset;
 			}
 		}
 
+		if (wpf->flip.rotate && !(flip & BIT(WPF_CTRL_HFLIP))) {
+			unsigned int hoffset = max(0, (int)format->width - 16);
+
+			/*
+			 * Compute the output coordinate. The partition
+			 * horizontal (left) offset becomes a vertical offset.
+			 */
+			for (i = 0; i < format->num_planes; ++i) {
+				unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
+
+				mem.addr[i] += hoffset / hsub
+					     * fmtinfo->bpp[i] / 8;
+			}
+		}
+
 		/*
 		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
 		 * formats. Swap the U and V planes manually in that case.
@@ -306,6 +403,9 @@ static void wpf_configure(struct vsp1_entity *entity,
 
 		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
 
+		if (wpf->flip.rotate)
+			outfmt |= VI6_WPF_OUTFMT_ROT;
+
 		if (fmtinfo->alpha)
 			outfmt |= VI6_WPF_OUTFMT_PXA;
 		if (fmtinfo->swap_yc)
@@ -367,9 +467,18 @@ static void wpf_configure(struct vsp1_entity *entity,
 			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
+static unsigned int wpf_max_width(struct vsp1_entity *entity,
+				  struct vsp1_pipeline *pipe)
+{
+	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+
+	return wpf->flip.rotate ? 256 : wpf->max_width;
+}
+
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
 	.configure = wpf_configure,
+	.max_width = wpf_max_width,
 };
 
 /* -----------------------------------------------------------------------------
-- 
Regards,

Laurent Pinchart
