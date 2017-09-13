Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752418AbdIMLTC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 07:19:02 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 6/9] v4l: vsp1: Refactor display list configure operations
Date: Wed, 13 Sep 2017 12:18:45 +0100
Message-Id: <f9ec8f4ee61d9e2eec3f42b60819d64b3352f3e1.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entities provide a single .configure operation which configures the
object into the target display list, based on the vsp1_entity_params
selection.

This restricts us to a single function prototype for both static
configuration (the pre-stream INIT stage) and the dynamic runtime stages
for both each frame - and each partition therein.

Split the configure function into two parts, '.prepare()' and
'.configure()', merging both the VSP1_ENTITY_PARAMS_RUNTIME and
VSP1_ENTITY_PARAMS_PARTITION stages into a single call through the
.configure(). The configuration for individual partitions is handled by
passing the partition number to the configure call, and processing any
runtime stage actions on the first partition only.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_clu.c    |  42 +--
 drivers/media/platform/vsp1/vsp1_drm.c    |  11 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  15 +-
 drivers/media/platform/vsp1/vsp1_entity.h |  27 +--
 drivers/media/platform/vsp1/vsp1_hgo.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_hgt.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  12 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  24 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 162 ++++++-------
 drivers/media/platform/vsp1/vsp1_sru.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |  55 ++--
 drivers/media/platform/vsp1/vsp1_video.c  |  24 +--
 drivers/media/platform/vsp1/vsp1_wpf.c    | 297 ++++++++++++-----------
 15 files changed, 358 insertions(+), 371 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index e8fd2ae3b3eb..b9ff96f76b3e 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -285,19 +285,15 @@ static const struct v4l2_subdev_ops bru_ops = {
  * VSP1 Entity Operations
  */
 
-static void bru_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void bru_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
 					    bru->entity.source_pad);
 
@@ -404,7 +400,7 @@ static void bru_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations bru_entity_ops = {
-	.configure = bru_configure,
+	.prepare = bru_prepare,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index b2a39a6ef7e4..2e4af93a053f 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -213,37 +213,36 @@ static const struct v4l2_subdev_ops clu_ops = {
 /* -----------------------------------------------------------------------------
  * VSP1 Entity Operations
  */
+static void clu_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+
+	/*
+	 * The format can't be changed during streaming. Cache it internally
+	 * for future runtime configuration calls.
+	 */
+	struct v4l2_mbus_framefmt *format;
+
+	format = vsp1_entity_get_pad_format(&clu->entity,
+					    clu->entity.config,
+					    CLU_PAD_SINK);
+	clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
+}
 
 static void clu_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+			  unsigned int partition)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
 	struct vsp1_dl_body *dlb;
 	unsigned long flags;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
-	switch (params) {
-	case VSP1_ENTITY_PARAMS_INIT: {
-		/*
-		 * The format can't be changed during streaming, only verify it
-		 * at setup time and store the information internally for future
-		 * runtime configuration calls.
-		 */
-		struct v4l2_mbus_framefmt *format;
-
-		format = vsp1_entity_get_pad_format(&clu->entity,
-						    clu->entity.config,
-						    CLU_PAD_SINK);
-		clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
-		break;
-	}
 
-	case VSP1_ENTITY_PARAMS_PARTITION:
-		break;
-
-	case VSP1_ENTITY_PARAMS_RUNTIME:
+	if (partition == 0) {
 		/* 2D mode can only be used with the YCbCr pixel encoding. */
 		if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
 			ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
@@ -263,8 +262,6 @@ static void clu_configure(struct vsp1_entity *entity,
 			/* release our local reference */
 			vsp1_dl_body_put(dlb);
 		}
-
-		break;
 	}
 }
 
@@ -276,6 +273,7 @@ static void clu_destroy(struct vsp1_entity *entity)
 }
 
 static const struct vsp1_entity_operations clu_entity_ops = {
+	.prepare = clu_prepare,
 	.configure = clu_configure,
 	.destroy = clu_destroy,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 4dfbeac8f42c..2a4fcb866629 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -558,15 +558,8 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 		}
 
 		vsp1_entity_route_setup(entity, pipe, dl);
-
-		if (entity->ops->configure) {
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_INIT);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_RUNTIME);
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
-		}
+		vsp1_entity_prepare(entity, pipe, dl);
+		vsp1_entity_configure(entity, pipe, dl, 0);
 	}
 
 	vsp1_dl_list_commit(dl);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 54de15095709..76f240f005af 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -73,6 +73,21 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 	vsp1_dl_list_write(dl, source->route->reg, route);
 }
 
+void vsp1_entity_prepare(struct vsp1_entity *entity, struct vsp1_pipeline *pipe,
+			 struct vsp1_dl_list *dl)
+{
+	if (entity->ops->prepare)
+		entity->ops->prepare(entity, pipe, dl);
+}
+
+void vsp1_entity_configure(struct vsp1_entity *entity,
+			   struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
+			   unsigned int partition)
+{
+	if (entity->ops->configure)
+		entity->ops->configure(entity, pipe, dl, partition);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 408602ebeb97..2f33e343ccc6 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -40,18 +40,6 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_WPF,
 };
 
-/**
- * enum vsp1_entity_params - Entity configuration parameters class
- * @VSP1_ENTITY_PARAMS_INIT - Initial parameters
- * @VSP1_ENTITY_PARAMS_PARTITION - Per-image partition parameters
- * @VSP1_ENTITY_PARAMS_RUNTIME - Runtime-configurable parameters
- */
-enum vsp1_entity_params {
-	VSP1_ENTITY_PARAMS_INIT,
-	VSP1_ENTITY_PARAMS_PARTITION,
-	VSP1_ENTITY_PARAMS_RUNTIME,
-};
-
 #define VSP1_ENTITY_MAX_INPUTS		5	/* For the BRU */
 
 /*
@@ -80,8 +68,10 @@ struct vsp1_route {
 /**
  * struct vsp1_entity_operations - Entity operations
  * @destroy:	Destroy the entity.
- * @configure:	Setup the hardware based on the entity state (pipeline, formats,
- *		selection rectangles, ...)
+ * @prepare:	Setup the initial hardware parameters for the stream (pipeline,
+ *		formats)
+ * @configure:	Configure the runtime parameters for each partition (rectangles,
+ *		buffer addresses, ...)
  * @max_width:	Return the max supported width of data that the entity can
  *		process in a single operation.
  * @partition:	Process the partition construction based on this entity's
@@ -89,8 +79,10 @@ struct vsp1_route {
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
+	void (*prepare)(struct vsp1_entity *, struct vsp1_pipeline *,
+			struct vsp1_dl_list *);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
-			  struct vsp1_dl_list *, enum vsp1_entity_params);
+			  struct vsp1_dl_list *, unsigned int partition);
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
 	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_partition *, unsigned int,
@@ -156,6 +148,11 @@ int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
 			     struct vsp1_dl_list *dl);
+void vsp1_entity_prepare(struct vsp1_entity *entity, struct vsp1_pipeline *pipe,
+			 struct vsp1_dl_list *dl);
+void vsp1_entity_configure(struct vsp1_entity *entity,
+			   struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
+			   unsigned int partition);
 
 struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 50309c053b78..5705ba67dbc8 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -133,10 +133,9 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
  * VSP1 Entity Operations
  */
 
-static void hgo_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void hgo_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -144,9 +143,6 @@ static void hgo_configure(struct vsp1_entity *entity,
 	unsigned int hratio;
 	unsigned int vratio;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
 					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
@@ -178,7 +174,7 @@ static void hgo_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hgo_entity_ops = {
-	.configure = hgo_configure,
+	.prepare = hgo_prepare,
 	.destroy = vsp1_histogram_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
index b5ce305e3e6f..bdd1247e090f 100644
--- a/drivers/media/platform/vsp1/vsp1_hgt.c
+++ b/drivers/media/platform/vsp1/vsp1_hgt.c
@@ -129,10 +129,9 @@ static const struct v4l2_ctrl_config hgt_hue_areas = {
  * VSP1 Entity Operations
  */
 
-static void hgt_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void hgt_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -143,9 +142,6 @@ static void hgt_configure(struct vsp1_entity *entity,
 	u8 upper;
 	unsigned int i;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
 					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
@@ -179,7 +175,7 @@ static void hgt_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hgt_entity_ops = {
-	.configure = hgt_configure,
+	.prepare = hgt_prepare,
 	.destroy = vsp1_histogram_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 764d405345ee..cf96ce2c6da9 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -131,16 +131,12 @@ static const struct v4l2_subdev_ops hsit_ops = {
  * VSP1 Entity Operations
  */
 
-static void hsit_configure(struct vsp1_entity *entity,
-			   struct vsp1_pipeline *pipe,
-			   struct vsp1_dl_list *dl,
-			   enum vsp1_entity_params params)
+static void hsit_prepare(struct vsp1_entity *entity,
+			 struct vsp1_pipeline *pipe,
+			 struct vsp1_dl_list *dl)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	if (hsit->inverse)
 		vsp1_hsit_write(hsit, dl, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
 	else
@@ -148,7 +144,7 @@ static void hsit_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hsit_entity_ops = {
-	.configure = hsit_configure,
+	.prepare = hsit_prepare,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index e6fa16d7fda8..0141bce92c2f 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -128,10 +128,9 @@ static const struct v4l2_subdev_ops lif_ops = {
  * VSP1 Entity Operations
  */
 
-static void lif_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void lif_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -139,9 +138,6 @@ static void lif_configure(struct vsp1_entity *entity,
 	unsigned int obth = 400;
 	unsigned int lbth = 200;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
 					    LIF_PAD_SOURCE);
 
@@ -158,7 +154,7 @@ static void lif_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations lif_entity_ops = {
-	.configure = lif_configure,
+	.prepare = lif_prepare,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 77cf7137a0f2..33bfaa1df994 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -190,24 +190,25 @@ static const struct v4l2_subdev_ops lut_ops = {
  * VSP1 Entity Operations
  */
 
+static void lut_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+
+	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+}
+
 static void lut_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+			  unsigned int partition)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 	struct vsp1_dl_body *dlb;
 	unsigned long flags;
 
-	switch (params) {
-	case VSP1_ENTITY_PARAMS_INIT:
-		vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
-		break;
-
-	case VSP1_ENTITY_PARAMS_PARTITION:
-		break;
-
-	case VSP1_ENTITY_PARAMS_RUNTIME:
+	if (partition == 0) {
 		spin_lock_irqsave(&lut->lock, flags);
 		dlb = lut->lut;
 		lut->lut = NULL;
@@ -219,8 +220,6 @@ static void lut_configure(struct vsp1_entity *entity,
 			/* release our local reference */
 			vsp1_dl_body_put(dlb);
 		}
-
-		break;
 	}
 }
 
@@ -232,6 +231,7 @@ static void lut_destroy(struct vsp1_entity *entity)
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
+	.prepare = lut_prepare,
 	.configure = lut_configure,
 	.destroy = lut_destroy,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index fe0633da5a5f..87a47997a086 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -46,10 +46,9 @@ static const struct v4l2_subdev_ops rpf_ops = {
  * VSP1 Entity Operations
  */
 
-static void rpf_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void rpf_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -61,80 +60,6 @@ static void rpf_configure(struct vsp1_entity *entity,
 	u32 pstride;
 	u32 infmt;
 
-	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
-		vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
-			       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
-			       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
-
-		vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
-		return;
-	}
-
-	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		struct vsp1_device *vsp1 = rpf->entity.vsp1;
-		struct vsp1_rwpf_memory mem = rpf->mem;
-		struct v4l2_rect crop;
-
-		/*
-		 * Source size and crop offsets.
-		 *
-		 * The crop offsets correspond to the location of the crop
-		 * rectangle top left corner in the plane buffer. Only two
-		 * offsets are needed, as planes 2 and 3 always have identical
-		 * strides.
-		 */
-		crop = *vsp1_rwpf_get_crop(rpf, rpf->entity.config);
-
-		/*
-		 * Partition Algorithm Control
-		 *
-		 * The partition algorithm can split this frame into multiple
-		 * slices. We must scale our partition window based on the pipe
-		 * configuration to match the destination partition window.
-		 * To achieve this, we adjust our crop to provide a 'sub-crop'
-		 * matching the expected partition window. Only 'left' and
-		 * 'width' need to be adjusted.
-		 */
-		if (pipe->partitions > 1) {
-			crop.width = pipe->partition->rpf.width;
-			crop.left += pipe->partition->rpf.left;
-		}
-
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
-			       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
-			       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
-			       (crop.width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
-			       (crop.height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
-
-		mem.addr[0] += crop.top * format->plane_fmt[0].bytesperline
-			     + crop.left * fmtinfo->bpp[0] / 8;
-
-		if (format->num_planes > 1) {
-			unsigned int offset;
-
-			offset = crop.top * format->plane_fmt[1].bytesperline
-			       + crop.left / fmtinfo->hsub
-			       * fmtinfo->bpp[1] / 8;
-			mem.addr[1] += offset;
-			mem.addr[2] += offset;
-		}
-
-		/*
-		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
-		 * formats. Swap the U and V planes manually in that case.
-		 */
-		if (vsp1->info->gen == 3 && format->num_planes == 3 &&
-		    fmtinfo->swap_uv)
-			swap(mem.addr[1], mem.addr[2]);
-
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
-		return;
-	}
-
 	/* Stride */
 	pstride = format->plane_fmt[0].bytesperline
 		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
@@ -247,6 +172,86 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 }
 
+static void rpf_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  unsigned int partition)
+{
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+	struct vsp1_rwpf_memory mem = rpf->mem;
+	struct vsp1_device *vsp1 = rpf->entity.vsp1;
+	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
+	const struct v4l2_pix_format_mplane *format = &rpf->format;
+	struct v4l2_rect crop;
+
+	if (partition == 0) {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
+			       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
+			       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
+
+		vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
+	}
+
+
+	/*
+	 * Source size and crop offsets.
+	 *
+	 * The crop offsets correspond to the location of the crop
+	 * rectangle top left corner in the plane buffer. Only two
+	 * offsets are needed, as planes 2 and 3 always have identical
+	 * strides.
+	 */
+	crop = *vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+
+	/*
+	 * Partition Algorithm Control
+	 *
+	 * The partition algorithm can split this frame into multiple
+	 * slices. We must scale our partition window based on the pipe
+	 * configuration to match the destination partition window.
+	 * To achieve this, we adjust our crop to provide a 'sub-crop'
+	 * matching the expected partition window. Only 'left' and
+	 * 'width' need to be adjusted.
+	 */
+	if (pipe->partitions > 1) {
+		crop.width = pipe->partition->rpf.width;
+		crop.left += pipe->partition->rpf.left;
+	}
+
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
+		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
+		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
+		       (crop.width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
+		       (crop.height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
+
+	mem.addr[0] += crop.top * format->plane_fmt[0].bytesperline
+		     + crop.left * fmtinfo->bpp[0] / 8;
+
+	if (format->num_planes > 1) {
+		unsigned int offset;
+
+		offset = crop.top * format->plane_fmt[1].bytesperline
+		       + crop.left / fmtinfo->hsub
+		       * fmtinfo->bpp[1] / 8;
+		mem.addr[1] += offset;
+		mem.addr[2] += offset;
+	}
+
+	/*
+	 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
+	 * formats. Swap the U and V planes manually in that case.
+	 */
+	if (vsp1->info->gen == 3 && format->num_planes == 3 &&
+	    fmtinfo->swap_uv)
+		swap(mem.addr[1], mem.addr[2]);
+
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
+}
+
 static void rpf_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
@@ -257,6 +262,7 @@ static void rpf_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
+	.prepare = rpf_prepare,
 	.configure = rpf_configure,
 	.partition = rpf_partition,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 51e5691187c3..0a24bc59bc2f 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -271,10 +271,9 @@ static const struct v4l2_subdev_ops sru_ops = {
  * VSP1 Entity Operations
  */
 
-static void sru_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void sru_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -282,9 +281,6 @@ static void sru_configure(struct vsp1_entity *entity,
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					   SRU_PAD_SINK);
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
@@ -351,7 +347,7 @@ static void sru_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations sru_entity_ops = {
-	.configure = sru_configure,
+	.prepare = sru_prepare,
 	.max_width = sru_max_width,
 	.partition = sru_partition,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 72f72a9d2152..84be962a33b1 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -259,10 +259,9 @@ static const struct v4l2_subdev_ops uds_ops = {
  * VSP1 Entity Operations
  */
 
-static void uds_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void uds_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -276,27 +275,6 @@ static void uds_configure(struct vsp1_entity *entity,
 	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
 					    UDS_PAD_SOURCE);
 
-	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		struct vsp1_partition *partition = pipe->partition;
-
-		/* Input size clipping */
-		vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
-			       (0 << VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
-			       (partition->uds_sink.width
-					<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
-
-		/* Output size clipping */
-		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
-			       (partition->uds_source.width
-					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-			       (output->height
-					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
-		return;
-	}
-
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	hscale = uds_compute_ratio(input->width, output->width);
 	vscale = uds_compute_ratio(input->height, output->height);
 
@@ -328,6 +306,32 @@ static void uds_configure(struct vsp1_entity *entity,
 		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
 }
 
+static void uds_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  unsigned int pindex)
+{
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+	struct vsp1_partition *partition = pipe->partition;
+	const struct v4l2_mbus_framefmt *output;
+
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
+
+	/* Input size clipping */
+	vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
+		       (0 << VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
+		       (partition->uds_sink.width
+				<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
+
+	/* Output size clipping */
+	vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
+		       (partition->uds_source.width
+				<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+		       (output->height
+				<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+}
+
 static unsigned int uds_max_width(struct vsp1_entity *entity,
 				  struct vsp1_pipeline *pipe)
 {
@@ -384,6 +388,7 @@ static void uds_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations uds_entity_ops = {
+	.prepare = uds_prepare,
 	.configure = uds_configure,
 	.max_width = uds_max_width,
 	.partition = uds_partition,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c2d3b8f0f487..bd5403f24dda 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -386,33 +386,18 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 
 	pipe->partition = &pipe->part_table[partition];
 
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
-	}
+	list_for_each_entry(entity, &pipe->entities, list_pipe)
+		vsp1_entity_configure(entity, pipe, dl, partition);
 }
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
-	struct vsp1_entity *entity;
 	unsigned int partition;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
-	/*
-	 * Start with the runtime parameters as the configure operation can
-	 * compute/cache information needed when configuring partitions. This
-	 * is the case with flipping in the WPF.
-	 */
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
-					       VSP1_ENTITY_PARAMS_RUNTIME);
-	}
-
 	/* Run the first partition */
 	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
 
@@ -840,10 +825,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		vsp1_entity_route_setup(entity, pipe, pipe->dl);
-
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
-					       VSP1_ENTITY_PARAMS_INIT);
+		vsp1_entity_prepare(entity, pipe, pipe->dl);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index f7f3b4b2c2de..d6dd7e783d27 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -236,10 +236,9 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 	vsp1_dlm_destroy(wpf->dlm);
 }
 
-static void wpf_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void wpf_prepare(struct vsp1_entity *entity,
+			struct vsp1_pipeline *pipe,
+			struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -249,149 +248,12 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
 
-	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
-		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
-					| BIT(WPF_CTRL_HFLIP);
-		unsigned long flags;
-
-		spin_lock_irqsave(&wpf->flip.lock, flags);
-		wpf->flip.active = (wpf->flip.active & ~mask)
-				 | (wpf->flip.pending & mask);
-		spin_unlock_irqrestore(&wpf->flip.lock, flags);
-
-		outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
-
-		if (wpf->flip.active & BIT(WPF_CTRL_VFLIP))
-			outfmt |= VI6_WPF_OUTFMT_FLP;
-		if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
-			outfmt |= VI6_WPF_OUTFMT_HFLP;
-
-		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
-		return;
-	}
-
 	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
 						 wpf->entity.config,
 						 RWPF_PAD_SINK);
 	source_format = vsp1_entity_get_pad_format(&wpf->entity,
 						   wpf->entity.config,
 						   RWPF_PAD_SOURCE);
-
-	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		const struct v4l2_pix_format_mplane *format = &wpf->format;
-		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
-		struct vsp1_rwpf_memory mem = wpf->mem;
-		unsigned int flip = wpf->flip.active;
-		unsigned int width = sink_format->width;
-		unsigned int height = sink_format->height;
-		unsigned int offset;
-
-		/*
-		 * Cropping. The partition algorithm can split the image into
-		 * multiple slices.
-		 */
-		if (pipe->partitions > 1)
-			width = pipe->partition->wpf.width;
-
-		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
-			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
-			       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-		vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
-			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
-			       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
-
-		if (pipe->lif)
-			return;
-
-		/*
-		 * Update the memory offsets based on flipping configuration.
-		 * The destination addresses point to the locations where the
-		 * VSP starts writing to memory, which can be any corner of the
-		 * image depending on the combination of flipping and rotation.
-		 */
-
-		/*
-		 * First take the partition left coordinate into account.
-		 * Compute the offset to order the partitions correctly on the
-		 * output based on whether flipping is enabled. Consider
-		 * horizontal flipping when rotation is disabled but vertical
-		 * flipping when rotation is enabled, as rotating the image
-		 * switches the horizontal and vertical directions. The offset
-		 * is applied horizontally or vertically accordingly.
-		 */
-		if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
-			offset = format->width - pipe->partition->wpf.left
-				- pipe->partition->wpf.width;
-		else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
-			offset = format->height - pipe->partition->wpf.left
-				- pipe->partition->wpf.width;
-		else
-			offset = pipe->partition->wpf.left;
-
-		for (i = 0; i < format->num_planes; ++i) {
-			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
-			unsigned int vsub = i > 0 ? fmtinfo->vsub : 1;
-
-			if (wpf->flip.rotate)
-				mem.addr[i] += offset / vsub
-					     * format->plane_fmt[i].bytesperline;
-			else
-				mem.addr[i] += offset / hsub
-					     * fmtinfo->bpp[i] / 8;
-		}
-
-		if (flip & BIT(WPF_CTRL_VFLIP)) {
-			/*
-			 * When rotating the output (after rotation) image
-			 * height is equal to the partition width (before
-			 * rotation). Otherwise it is equal to the output
-			 * image height.
-			 */
-			if (wpf->flip.rotate)
-				height = pipe->partition->wpf.width;
-			else
-				height = format->height;
-
-			mem.addr[0] += (height - 1)
-				     * format->plane_fmt[0].bytesperline;
-
-			if (format->num_planes > 1) {
-				offset = (height / fmtinfo->vsub - 1)
-				       * format->plane_fmt[1].bytesperline;
-				mem.addr[1] += offset;
-				mem.addr[2] += offset;
-			}
-		}
-
-		if (wpf->flip.rotate && !(flip & BIT(WPF_CTRL_HFLIP))) {
-			unsigned int hoffset = max(0, (int)format->width - 16);
-
-			/*
-			 * Compute the output coordinate. The partition
-			 * horizontal (left) offset becomes a vertical offset.
-			 */
-			for (i = 0; i < format->num_planes; ++i) {
-				unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
-
-				mem.addr[i] += hoffset / hsub
-					     * fmtinfo->bpp[i] / 8;
-			}
-		}
-
-		/*
-		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
-		 * formats. Swap the U and V planes manually in that case.
-		 */
-		if (vsp1->info->gen == 3 && format->num_planes == 3 &&
-		    fmtinfo->swap_uv)
-			swap(mem.addr[1], mem.addr[2]);
-
-		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
-		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
-		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
-		return;
-	}
-
 	/* Format */
 	if (!pipe->lif) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
@@ -465,6 +327,158 @@ static void wpf_configure(struct vsp1_entity *entity,
 			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
+static void wpf_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  unsigned int partition)
+{
+	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+	struct vsp1_device *vsp1 = wpf->entity.vsp1;
+	struct vsp1_rwpf_memory mem = wpf->mem;
+	const struct v4l2_mbus_framefmt *sink_format;
+	const struct v4l2_pix_format_mplane *format = &wpf->format;
+	const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
+	unsigned int flip;
+	unsigned int i;
+	unsigned int width;
+	unsigned int height;
+	unsigned int offset;
+	u32 outfmt = 0;
+
+	/* Handle the per frame constants */
+	if (partition == 0) {
+		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
+					| BIT(WPF_CTRL_HFLIP);
+		unsigned long flags;
+
+		spin_lock_irqsave(&wpf->flip.lock, flags);
+		wpf->flip.active = (wpf->flip.active & ~mask)
+				 | (wpf->flip.pending & mask);
+		spin_unlock_irqrestore(&wpf->flip.lock, flags);
+
+		outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
+
+		if (wpf->flip.active & BIT(WPF_CTRL_VFLIP))
+			outfmt |= VI6_WPF_OUTFMT_FLP;
+		if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
+			outfmt |= VI6_WPF_OUTFMT_HFLP;
+
+		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
+	}
+
+	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
+						 wpf->entity.config,
+						 RWPF_PAD_SINK);
+	width = sink_format->width;
+	height = sink_format->height;
+
+	/*
+	 * Cropping. The partition algorithm can split the image into
+	 * multiple slices.
+	 */
+	if (pipe->partitions > 1)
+		width = pipe->partition->wpf.width;
+
+	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
+	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
+
+	if (pipe->lif)
+		return;
+
+	/*
+	 * Update the memory offsets based on flipping configuration.
+	 * The destination addresses point to the locations where the
+	 * VSP starts writing to memory, which can be any corner of the
+	 * image depending on the combination of flipping and rotation.
+	 */
+
+	/*
+	 * First take the partition left coordinate into account.
+	 * Compute the offset to order the partitions correctly on the
+	 * output based on whether flipping is enabled. Consider
+	 * horizontal flipping when rotation is disabled but vertical
+	 * flipping when rotation is enabled, as rotating the image
+	 * switches the horizontal and vertical directions. The offset
+	 * is applied horizontally or vertically accordingly.
+	 */
+	flip = wpf->flip.active;
+
+	if (flip & BIT(WPF_CTRL_HFLIP) && !wpf->flip.rotate)
+		offset = format->width - pipe->partition->wpf.left
+			- pipe->partition->wpf.width;
+	else if (flip & BIT(WPF_CTRL_VFLIP) && wpf->flip.rotate)
+		offset = format->height - pipe->partition->wpf.left
+			- pipe->partition->wpf.width;
+	else
+		offset = pipe->partition->wpf.left;
+
+	for (i = 0; i < format->num_planes; ++i) {
+		unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
+		unsigned int vsub = i > 0 ? fmtinfo->vsub : 1;
+
+		if (wpf->flip.rotate)
+			mem.addr[i] += offset / vsub
+				     * format->plane_fmt[i].bytesperline;
+		else
+			mem.addr[i] += offset / hsub
+				     * fmtinfo->bpp[i] / 8;
+	}
+
+	if (flip & BIT(WPF_CTRL_VFLIP)) {
+		/*
+		 * When rotating the output (after rotation) image
+		 * height is equal to the partition width (before
+		 * rotation). Otherwise it is equal to the output
+		 * image height.
+		 */
+		if (wpf->flip.rotate)
+			height = pipe->partition->wpf.width;
+		else
+			height = format->height;
+
+		mem.addr[0] += (height - 1)
+			     * format->plane_fmt[0].bytesperline;
+
+		if (format->num_planes > 1) {
+			offset = (height / fmtinfo->vsub - 1)
+			       * format->plane_fmt[1].bytesperline;
+			mem.addr[1] += offset;
+			mem.addr[2] += offset;
+		}
+	}
+
+	if (wpf->flip.rotate && !(flip & BIT(WPF_CTRL_HFLIP))) {
+		unsigned int hoffset = max(0, (int)format->width - 16);
+
+		/*
+		 * Compute the output coordinate. The partition
+		 * horizontal (left) offset becomes a vertical offset.
+		 */
+		for (i = 0; i < format->num_planes; ++i) {
+			unsigned int hsub = i > 0 ? fmtinfo->hsub : 1;
+
+			mem.addr[i] += hoffset / hsub
+				     * fmtinfo->bpp[i] / 8;
+		}
+	}
+
+	/*
+	 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
+	 * formats. Swap the U and V planes manually in that case.
+	 */
+	if (vsp1->info->gen == 3 && format->num_planes == 3 &&
+	    fmtinfo->swap_uv)
+		swap(mem.addr[1], mem.addr[2]);
+
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
+}
+
 static unsigned int wpf_max_width(struct vsp1_entity *entity,
 				  struct vsp1_pipeline *pipe)
 {
@@ -484,6 +498,7 @@ static void wpf_partition(struct vsp1_entity *entity,
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
+	.prepare = wpf_prepare,
 	.configure = wpf_configure,
 	.max_width = wpf_max_width,
 	.partition = wpf_partition,
-- 
git-series 0.9.1
