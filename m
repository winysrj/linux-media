Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46919 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759217AbcIMXQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 09/13] v4l: vsp1: Replace .set_memory() with VSP1_ENTITY_PARAMS_PARTITION
Date: Wed, 14 Sep 2016 02:17:02 +0300
Message-Id: <1473808626-19488-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new VSP1_ENTITY_PARAMS_PARTITION configuration parameters type
covers all registers that need to be configured for every partition.
This prepares for support of image partitioning, and replaces the
.set_memory() operation as the memory registers take different values
for every partition.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_clu.c    |  3 ++
 drivers/media/platform/vsp1/vsp1_drm.c    |  9 +---
 drivers/media/platform/vsp1/vsp1_entity.h |  6 +--
 drivers/media/platform/vsp1/vsp1_lut.c    |  3 ++
 drivers/media/platform/vsp1/vsp1_rpf.c    | 78 ++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_rwpf.h   | 13 -----
 drivers/media/platform/vsp1/vsp1_video.c  | 17 ++-----
 drivers/media/platform/vsp1/vsp1_wpf.c    | 85 +++++++++++++++++--------------
 8 files changed, 100 insertions(+), 114 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index a0a69dfc38fc..f052abd05166 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -237,6 +237,9 @@ static void clu_configure(struct vsp1_entity *entity,
 		break;
 	}
 
+	case VSP1_ENTITY_PARAMS_PARTITION:
+		break;
+
 	case VSP1_ENTITY_PARAMS_RUNTIME:
 		/* 2D mode can only be used with the YCbCr pixel encoding. */
 		if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 6cbd3aeedbe3..832286975e71 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -496,14 +496,9 @@ void vsp1_du_atomic_flush(struct device *dev)
 					       VSP1_ENTITY_PARAMS_INIT);
 			entity->ops->configure(entity, pipe, pipe->dl,
 					       VSP1_ENTITY_PARAMS_RUNTIME);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_PARTITION);
 		}
-
-		/* The memory buffer address must be applied after configuring
-		 * the RPF to make sure the crop offset are computed.
-		 */
-		if (entity->type == VSP1_ENTITY_RPF)
-			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev),
-					     pipe->dl);
 	}
 
 	vsp1_dl_list_commit(pipe->dl);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 51835e73308d..0e3e394c44cd 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -38,10 +38,12 @@ enum vsp1_entity_type {
 /*
  * enum vsp1_entity_params - Entity configuration parameters class
  * @VSP1_ENTITY_PARAMS_INIT - Initial parameters
+ * @VSP1_ENTITY_PARAMS_PARTITION - Per-image partition parameters
  * @VSP1_ENTITY_PARAMS_RUNTIME - Runtime-configurable parameters
  */
 enum vsp1_entity_params {
 	VSP1_ENTITY_PARAMS_INIT,
+	VSP1_ENTITY_PARAMS_PARTITION,
 	VSP1_ENTITY_PARAMS_RUNTIME,
 };
 
@@ -73,15 +75,11 @@ struct vsp1_route {
 /**
  * struct vsp1_entity_operations - Entity operations
  * @destroy:	Destroy the entity.
- * @set_memory:	Setup memory buffer access. This operation applies the settings
- *		stored in the rwpf mem field to the display list. Valid for RPF
- *		and WPF only.
  * @configure:	Setup the hardware based on the entity state (pipeline, formats,
  *		selection rectangles, ...)
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
-	void (*set_memory)(struct vsp1_entity *, struct vsp1_dl_list *dl);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_dl_list *, enum vsp1_entity_params);
 };
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index ace8acce2076..c67cc60db0db 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -202,6 +202,9 @@ static void lut_configure(struct vsp1_entity *entity,
 		vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 		break;
 
+	case VSP1_ENTITY_PARAMS_PARTITION:
+		break;
+
 	case VSP1_ENTITY_PARAMS_RUNTIME:
 		spin_lock_irqsave(&lut->lock, flags);
 		dlb = lut->lut;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 795bf0fd1761..de5ef76c5004 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -46,18 +46,6 @@ static const struct v4l2_subdev_ops rpf_ops = {
  * VSP1 Entity Operations
  */
 
-static void rpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
-{
-	struct vsp1_rwpf *rpf = entity_to_rwpf(entity);
-
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y,
-		       rpf->mem.addr[0] + rpf->offsets[0]);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0,
-		       rpf->mem.addr[1] + rpf->offsets[1]);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1,
-		       rpf->mem.addr[2] + rpf->offsets[1]);
-}
-
 static void rpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
@@ -68,7 +56,6 @@ static void rpf_configure(struct vsp1_entity *entity,
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
-	const struct v4l2_rect *crop;
 	unsigned int left = 0;
 	unsigned int top = 0;
 	u32 pstride;
@@ -84,35 +71,51 @@ static void rpf_configure(struct vsp1_entity *entity,
 		return;
 	}
 
-	/* Source size, stride and crop offsets.
-	 *
-	 * The crop offsets correspond to the location of the crop rectangle top
-	 * left corner in the plane buffer. Only two offsets are needed, as
-	 * planes 2 and 3 always have identical strides.
-	 */
-	crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
-
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
-		       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
-		       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
-		       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
-		       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
+		const struct v4l2_rect *crop;
+		unsigned int offsets[2];
+
+		/* Source size and crop offsets.
+		 *
+		 * The crop offsets correspond to the location of the crop
+		 * rectangle top left corner in the plane buffer. Only two
+		 * offsets are needed, as planes 2 and 3 always have identical
+		 * strides.
+		 */
+		crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
+			       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
+			       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
+			       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
+			       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+
+		offsets[0] = crop->top * format->plane_fmt[0].bytesperline
+			   + crop->left * fmtinfo->bpp[0] / 8;
+
+		if (format->num_planes > 1)
+			offsets[1] = crop->top * format->plane_fmt[1].bytesperline
+				   + crop->left / fmtinfo->hsub
+				   * fmtinfo->bpp[1] / 8;
+		else
+			offsets[1] = 0;
+
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y,
+			       rpf->mem.addr[0] + offsets[0]);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0,
+			       rpf->mem.addr[1] + offsets[1]);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1,
+			       rpf->mem.addr[2] + offsets[1]);
+		return;
+	}
 
-	rpf->offsets[0] = crop->top * format->plane_fmt[0].bytesperline
-			+ crop->left * fmtinfo->bpp[0] / 8;
+	/* Stride */
 	pstride = format->plane_fmt[0].bytesperline
 		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
-
-	if (format->num_planes > 1) {
-		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
-				+ crop->left / fmtinfo->hsub * fmtinfo->bpp[1]
-				/ 8;
+	if (format->num_planes > 1)
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
-	} else {
-		rpf->offsets[1] = 0;
-	}
 
 	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_PSTRIDE, pstride);
 
@@ -217,7 +220,6 @@ static void rpf_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
-	.set_memory = rpf_set_memory,
 	.configure = rpf_configure,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index cb20484e80da..1c98aff3da5d 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -61,7 +61,6 @@ struct vsp1_rwpf {
 		unsigned int active;
 	} flip;
 
-	unsigned int offsets[2];
 	struct vsp1_rwpf_memory mem;
 
 	struct vsp1_dl_manager *dlm;
@@ -86,17 +85,5 @@ extern const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops;
 
 struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 				     struct v4l2_subdev_pad_config *config);
-/**
- * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
- * @rwpf: the [RW]PF instance
- * @dl: the display list
- *
- * This function applies the cached memory buffer address to the display list.
- */
-static inline void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf,
-					struct vsp1_dl_list *dl)
-{
-	rwpf->entity.ops->set_memory(&rwpf->entity, dl);
-}
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c66f0b480989..b8339d874df4 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -245,29 +245,20 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
-	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
-	unsigned int i;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->ops->configure)
+		if (entity->ops->configure) {
 			entity->ops->configure(entity, pipe, pipe->dl,
 					       VSP1_ENTITY_PARAMS_RUNTIME);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_PARTITION);
+		}
 	}
 
-	for (i = 0; i < vsp1->info->rpf_count; ++i) {
-		struct vsp1_rwpf *rwpf = pipe->inputs[i];
-
-		if (rwpf)
-			vsp1_rwpf_set_memory(rwpf, pipe->dl);
-	}
-
-	if (!pipe->lif)
-		vsp1_rwpf_set_memory(pipe->output, pipe->dl);
-
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index adf348d08c64..717c0be58bfb 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -173,37 +173,6 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 	vsp1_dlm_destroy(wpf->dlm);
 }
 
-static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
-{
-	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
-	const struct v4l2_pix_format_mplane *format = &wpf->format;
-	struct vsp1_rwpf_memory mem = wpf->mem;
-	unsigned int flip = wpf->flip.active;
-	unsigned int offset;
-
-	/* Update the memory offsets based on flipping configuration. The
-	 * destination addresses point to the locations where the VSP starts
-	 * writing to memory, which can be different corners of the image
-	 * depending on vertical flipping. Horizontal flipping is handled
-	 * through a line buffer and doesn't modify the start address.
-	 */
-	if (flip & BIT(WPF_CTRL_VFLIP)) {
-		mem.addr[0] += (format->height - 1)
-			     * format->plane_fmt[0].bytesperline;
-
-		if (format->num_planes > 1) {
-			offset = (format->height / wpf->fmtinfo->vsub - 1)
-			       * format->plane_fmt[1].bytesperline;
-			mem.addr[1] += offset;
-			mem.addr[2] += offset;
-		}
-	}
-
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
-}
-
 static void wpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
@@ -237,7 +206,6 @@ static void wpf_configure(struct vsp1_entity *entity,
 		return;
 	}
 
-	/* Format */
 	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
 						 wpf->entity.config,
 						 RWPF_PAD_SINK);
@@ -245,13 +213,53 @@ static void wpf_configure(struct vsp1_entity *entity,
 						   wpf->entity.config,
 						   RWPF_PAD_SOURCE);
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
-		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
-		       (source_format->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
-		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
-		       (source_format->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
+	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
+		const struct v4l2_pix_format_mplane *format = &wpf->format;
+		struct vsp1_rwpf_memory mem = wpf->mem;
+		unsigned int flip = wpf->flip.active;
+		unsigned int width = source_format->width;
+		unsigned int height = source_format->height;
+		unsigned int offset;
+
+		/* Cropping. The partition algorithm can split the image into
+		 * multiple slices.
+		 */
+		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+			       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
+		vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+			       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
+
+		if (pipe->lif)
+			return;
+
+		/* Update the memory offsets based on flipping configuration.
+		 * The destination addresses point to the locations where the
+		 * VSP starts writing to memory, which can be different corners
+		 * of the image depending on vertical flipping. Horizontal
+		 * flipping is handled through a line buffer and doesn't modify
+		 * the start address.
+		 */
+		if (flip & BIT(WPF_CTRL_VFLIP)) {
+			mem.addr[0] += (format->height - 1)
+				     * format->plane_fmt[0].bytesperline;
+
+			if (format->num_planes > 1) {
+				offset = (format->height / wpf->fmtinfo->vsub - 1)
+				       * format->plane_fmt[1].bytesperline;
+				mem.addr[1] += offset;
+				mem.addr[2] += offset;
+			}
+		}
 
+		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
+		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
+		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
+		return;
+	}
+
+	/* Format */
 	if (!pipe->lif) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
@@ -320,7 +328,6 @@ static void wpf_configure(struct vsp1_entity *entity,
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
-	.set_memory = wpf_set_memory,
 	.configure = wpf_configure,
 };
 
-- 
Regards,

Laurent Pinchart

