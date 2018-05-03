Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34714 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbeECNgA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 09:36:00 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v9 6/8] media: vsp1: Refactor display list configure operations
Date: Thu,  3 May 2018 14:35:45 +0100
Message-Id: <3c526da2424dda10560a0d40dc258263b54e122f.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.76b8251c2457cea047ecba892cf0d7a351644051.1525354160.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entities provide a single .configure operation which configures the
object into the target display list, based on the vsp1_entity_params
selection.

Split the configure function into three parts, '.configure_stream()',
'.configure_frame()', and '.configure_partition()' to facilitate
splitting the configuration of each parameter class into separate
display list bodies.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
The checkpatch warning:

WARNING: function definition argument 'struct vsp1_dl_list *' should
also have an identifier name

has been ignored to match the existing code style.

v8:
 - Add support for the UIF
 - Remove unrelated whitespace change
 - Fix comment location for clu_configure_stream()
 - Update configure documentations
 - Implement configure_partition separation.

v7
 - Fix formatting and white space
 - s/prepare/configure_stream/
 - s/configure/configure_frame/
---
 drivers/media/platform/vsp1/vsp1_brx.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_clu.c    |  77 ++----
 drivers/media/platform/vsp1/vsp1_drm.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_entity.c |  24 ++-
 drivers/media/platform/vsp1/vsp1_entity.h |  39 +--
 drivers/media/platform/vsp1/vsp1_hgo.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_hgt.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  12 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_lut.c    |  47 +---
 drivers/media/platform/vsp1/vsp1_rpf.c    | 168 ++++++-------
 drivers/media/platform/vsp1/vsp1_sru.c    |  12 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |  56 ++--
 drivers/media/platform/vsp1/vsp1_uif.c    |  16 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  28 +--
 drivers/media/platform/vsp1/vsp1_wpf.c    | 303 ++++++++++++-----------
 16 files changed, 422 insertions(+), 420 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_brx.c b/drivers/media/platform/vsp1/vsp1_brx.c
index 3beec18fd863..011edac5ebc1 100644
--- a/drivers/media/platform/vsp1/vsp1_brx.c
+++ b/drivers/media/platform/vsp1/vsp1_brx.c
@@ -281,19 +281,15 @@ static const struct v4l2_subdev_ops brx_ops = {
  * VSP1 Entity Operations
  */
 
-static void brx_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void brx_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_brx *brx = to_brx(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	format = vsp1_entity_get_pad_format(&brx->entity, brx->entity.config,
 					    brx->entity.source_pad);
 
@@ -400,7 +396,7 @@ static void brx_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations brx_entity_ops = {
-	.configure = brx_configure,
+	.configure_stream = brx_configure_stream,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index ea83f1b7d125..0a978980d447 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -168,58 +168,50 @@ static const struct v4l2_subdev_ops clu_ops = {
 /* -----------------------------------------------------------------------------
  * VSP1 Entity Operations
  */
+static void clu_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+	struct v4l2_mbus_framefmt *format;
 
-static void clu_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+	/*
+	 * The yuv_mode can't be changed during streaming. Cache it internally
+	 * for future runtime configuration calls.
+	 */
+	format = vsp1_entity_get_pad_format(&clu->entity,
+					    clu->entity.config,
+					    CLU_PAD_SINK);
+	clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
+}
+
+static void clu_configure_frame(struct vsp1_entity *entity,
+				struct vsp1_pipeline *pipe,
+				struct vsp1_dl_list *dl)
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
-
-	case VSP1_ENTITY_PARAMS_PARTITION:
-		break;
+	/* 2D mode can only be used with the YCbCr pixel encoding. */
+	if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
+		ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
+		     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
+		     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
 
-	case VSP1_ENTITY_PARAMS_RUNTIME:
-		/* 2D mode can only be used with the YCbCr pixel encoding. */
-		if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
-			ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
-			     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
-			     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
+	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
 
-		vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+	spin_lock_irqsave(&clu->lock, flags);
+	dlb = clu->clu;
+	clu->clu = NULL;
+	spin_unlock_irqrestore(&clu->lock, flags);
 
-		spin_lock_irqsave(&clu->lock, flags);
-		dlb = clu->clu;
-		clu->clu = NULL;
-		spin_unlock_irqrestore(&clu->lock, flags);
+	if (dlb) {
+		vsp1_dl_list_add_body(dl, dlb);
 
-		if (dlb) {
-			vsp1_dl_list_add_body(dl, dlb);
-
-			/* Release our local reference. */
-			vsp1_dl_body_put(dlb);
-		}
-
-		break;
+		/* Release our local reference. */
+		vsp1_dl_body_put(dlb);
 	}
 }
 
@@ -231,7 +223,8 @@ static void clu_destroy(struct vsp1_entity *entity)
 }
 
 static const struct vsp1_entity_operations clu_entity_ops = {
-	.configure = clu_configure,
+	.configure_stream = clu_configure_stream,
+	.configure_frame = clu_configure_frame,
 	.destroy = clu_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 08667e3640b2..99db8a418f9d 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -552,15 +552,9 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
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
+		vsp1_entity_configure_stream(entity, pipe, dl);
+		vsp1_entity_configure_frame(entity, pipe, dl);
+		vsp1_entity_configure_partition(entity, pipe, dl);
 	}
 
 	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index c411643695e4..73f6611ec279 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -69,6 +69,30 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 	vsp1_dl_list_write(dl, source->route->reg, route);
 }
 
+void vsp1_entity_configure_stream(struct vsp1_entity *entity,
+				  struct vsp1_pipeline *pipe,
+				  struct vsp1_dl_list *dl)
+{
+	if (entity->ops->configure_stream)
+		entity->ops->configure_stream(entity, pipe, dl);
+}
+
+void vsp1_entity_configure_frame(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
+{
+	if (entity->ops->configure_frame)
+		entity->ops->configure_frame(entity, pipe, dl);
+}
+
+void vsp1_entity_configure_partition(struct vsp1_entity *entity,
+				     struct vsp1_pipeline *pipe,
+				     struct vsp1_dl_list *dl)
+{
+	if (entity->ops->configure_partition)
+		entity->ops->configure_partition(entity, pipe, dl);
+}
+
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 94490d697dcf..c29676671b1a 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -37,18 +37,6 @@ enum vsp1_entity_type {
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
@@ -77,8 +65,10 @@ struct vsp1_route {
 /**
  * struct vsp1_entity_operations - Entity operations
  * @destroy:	Destroy the entity.
- * @configure:	Setup the hardware based on the entity state (pipeline, formats,
- *		selection rectangles, ...)
+ * @configure_stream:	Setup the hardware parameters for the stream which do
+ *			not vary between frames (pipeline, formats).
+ * @configure_frame:	Configure the runtime parameters for each frame.
+ * @configure_partition: Configure partition specific parameters.
  * @max_width:	Return the max supported width of data that the entity can
  *		process in a single operation.
  * @partition:	Process the partition construction based on this entity's
@@ -86,8 +76,13 @@ struct vsp1_route {
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
-	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
-			  struct vsp1_dl_list *, enum vsp1_entity_params);
+	void (*configure_stream)(struct vsp1_entity *, struct vsp1_pipeline *,
+				 struct vsp1_dl_list *);
+	void (*configure_frame)(struct vsp1_entity *, struct vsp1_pipeline *,
+					struct vsp1_dl_list *);
+	void (*configure_partition)(struct vsp1_entity *,
+				    struct vsp1_pipeline *,
+				    struct vsp1_dl_list *);
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
 	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_partition *, unsigned int,
@@ -156,6 +151,18 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
 			     struct vsp1_dl_list *dl);
 
+void vsp1_entity_configure_stream(struct vsp1_entity *entity,
+				  struct vsp1_pipeline *pipe,
+				  struct vsp1_dl_list *dl);
+
+void vsp1_entity_configure_frame(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl);
+
+void vsp1_entity_configure_partition(struct vsp1_entity *entity,
+				     struct vsp1_pipeline *pipe,
+				     struct vsp1_dl_list *dl);
+
 struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
 
 int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index d514807ccdf4..8855ad15d132 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -129,10 +129,9 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
  * VSP1 Entity Operations
  */
 
-static void hgo_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void hgo_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -140,9 +139,6 @@ static void hgo_configure(struct vsp1_entity *entity,
 	unsigned int hratio;
 	unsigned int vratio;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
 					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
@@ -174,7 +170,7 @@ static void hgo_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hgo_entity_ops = {
-	.configure = hgo_configure,
+	.configure_stream = hgo_configure_stream,
 	.destroy = vsp1_histogram_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
index 18dc89f47c45..a7ec2c9fdc5c 100644
--- a/drivers/media/platform/vsp1/vsp1_hgt.c
+++ b/drivers/media/platform/vsp1/vsp1_hgt.c
@@ -125,10 +125,9 @@ static const struct v4l2_ctrl_config hgt_hue_areas = {
  * VSP1 Entity Operations
  */
 
-static void hgt_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void hgt_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -139,9 +138,6 @@ static void hgt_configure(struct vsp1_entity *entity,
 	u8 upper;
 	unsigned int i;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
 					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
@@ -175,7 +171,7 @@ static void hgt_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hgt_entity_ops = {
-	.configure = hgt_configure,
+	.configure_stream = hgt_configure_stream,
 	.destroy = vsp1_histogram_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 7ba3535f3c9b..798c1448e3dc 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -127,16 +127,12 @@ static const struct v4l2_subdev_ops hsit_ops = {
  * VSP1 Entity Operations
  */
 
-static void hsit_configure(struct vsp1_entity *entity,
-			   struct vsp1_pipeline *pipe,
-			   struct vsp1_dl_list *dl,
-			   enum vsp1_entity_params params)
+static void hsit_configure_stream(struct vsp1_entity *entity,
+				  struct vsp1_pipeline *pipe,
+				  struct vsp1_dl_list *dl)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	if (hsit->inverse)
 		vsp1_hsit_write(hsit, dl, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
 	else
@@ -144,7 +140,7 @@ static void hsit_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations hsit_entity_ops = {
-	.configure = hsit_configure,
+	.configure_stream = hsit_configure_stream,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index fbdd5715f829..5a3f3e7b9bd3 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -81,10 +81,9 @@ static const struct v4l2_subdev_ops lif_ops = {
  * VSP1 Entity Operations
  */
 
-static void lif_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void lif_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -92,9 +91,6 @@ static void lif_configure(struct vsp1_entity *entity,
 	unsigned int obth = 400;
 	unsigned int lbth = 200;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
 					    LIF_PAD_SOURCE);
 
@@ -123,7 +119,7 @@ static void lif_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations lif_entity_ops = {
-	.configure = lif_configure,
+	.configure_stream = lif_configure_stream,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index b3ea90172439..1b62f54dc302 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -145,37 +145,33 @@ static const struct v4l2_subdev_ops lut_ops = {
  * VSP1 Entity Operations
  */
 
-static void lut_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void lut_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
-	struct vsp1_dl_body *dlb;
-	unsigned long flags;
-
-	switch (params) {
-	case VSP1_ENTITY_PARAMS_INIT:
-		vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
-		break;
 
-	case VSP1_ENTITY_PARAMS_PARTITION:
-		break;
+	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+}
 
-	case VSP1_ENTITY_PARAMS_RUNTIME:
-		spin_lock_irqsave(&lut->lock, flags);
-		dlb = lut->lut;
-		lut->lut = NULL;
-		spin_unlock_irqrestore(&lut->lock, flags);
+static void lut_configure_frame(struct vsp1_entity *entity,
+				struct vsp1_pipeline *pipe,
+				struct vsp1_dl_list *dl)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+	struct vsp1_dl_body *dlb;
+	unsigned long flags;
 
-		if (dlb) {
-			vsp1_dl_list_add_body(dl, dlb);
+	spin_lock_irqsave(&lut->lock, flags);
+	dlb = lut->lut;
+	lut->lut = NULL;
+	spin_unlock_irqrestore(&lut->lock, flags);
 
-			/* Release our local reference. */
-			vsp1_dl_body_put(dlb);
-		}
+	if (dlb) {
+		vsp1_dl_list_add_body(dl, dlb);
 
-		break;
+		/* Release our local reference. */
+		vsp1_dl_body_put(dlb);
 	}
 }
 
@@ -187,7 +183,8 @@ static void lut_destroy(struct vsp1_entity *entity)
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
-	.configure = lut_configure,
+	.configure_stream = lut_configure_stream,
+	.configure_frame = lut_configure_frame,
 	.destroy = lut_destroy,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 7005a4c6aa88..deb86cc235ef 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -42,10 +42,9 @@ static const struct v4l2_subdev_ops rpf_ops = {
  * VSP1 Entity Operations
  */
 
-static void rpf_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void rpf_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -57,80 +56,6 @@ static void rpf_configure(struct vsp1_entity *entity,
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
@@ -243,6 +168,89 @@ static void rpf_configure(struct vsp1_entity *entity,
 
 }
 
+static void rpf_configure_frame(struct vsp1_entity *entity,
+				struct vsp1_pipeline *pipe,
+				struct vsp1_dl_list *dl)
+{
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+
+	vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
+		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
+		       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
+
+	vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
+}
+
+static void rpf_configure_partition(struct vsp1_entity *entity,
+				    struct vsp1_pipeline *pipe,
+				    struct vsp1_dl_list *dl)
+{
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+	struct vsp1_rwpf_memory mem = rpf->mem;
+	struct vsp1_device *vsp1 = rpf->entity.vsp1;
+	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
+	const struct v4l2_pix_format_mplane *format = &rpf->format;
+	struct v4l2_rect crop;
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
@@ -253,7 +261,9 @@ static void rpf_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
-	.configure = rpf_configure,
+	.configure_stream = rpf_configure_stream,
+	.configure_frame = rpf_configure_frame,
+	.configure_partition = rpf_configure_partition,
 	.partition = rpf_partition,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 44cb9b134a19..d29f63dfc17e 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -267,10 +267,9 @@ static const struct v4l2_subdev_ops sru_ops = {
  * VSP1 Entity Operations
  */
 
-static void sru_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void sru_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -278,9 +277,6 @@ static void sru_configure(struct vsp1_entity *entity,
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
 
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					   SRU_PAD_SINK);
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
@@ -347,7 +343,7 @@ static void sru_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations sru_entity_ops = {
-	.configure = sru_configure,
+	.configure_stream = sru_configure_stream,
 	.max_width = sru_max_width,
 	.partition = sru_partition,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index e5afd69df939..c81ce9e5bff3 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -255,10 +255,9 @@ static const struct v4l2_subdev_ops uds_ops = {
  * VSP1 Entity Operations
  */
 
-static void uds_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void uds_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -272,27 +271,6 @@ static void uds_configure(struct vsp1_entity *entity,
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
 
@@ -324,6 +302,31 @@ static void uds_configure(struct vsp1_entity *entity,
 		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
 }
 
+static void uds_configure_partition(struct vsp1_entity *entity,
+				    struct vsp1_pipeline *pipe,
+				    struct vsp1_dl_list *dl)
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
@@ -380,7 +383,8 @@ static void uds_partition(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations uds_entity_ops = {
-	.configure = uds_configure,
+	.configure_stream = uds_configure_stream,
+	.configure_partition = uds_configure_partition,
 	.max_width = uds_max_width,
 	.partition = uds_partition,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_uif.c b/drivers/media/platform/vsp1/vsp1_uif.c
index c219165b15b9..c526e484b326 100644
--- a/drivers/media/platform/vsp1/vsp1_uif.c
+++ b/drivers/media/platform/vsp1/vsp1_uif.c
@@ -189,23 +189,15 @@ static const struct v4l2_subdev_ops uif_ops = {
  * VSP1 Entity Operations
  */
 
-static void uif_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void uif_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_uif *uif = to_uif(&entity->subdev);
 	const struct v4l2_rect *crop;
 	unsigned int left;
 	unsigned int width;
 
-	/*
-	 * Per-partition configuration isn't needed as the DISCOM is used in
-	 * display pipelines only.
-	 */
-	if (params != VSP1_ENTITY_PARAMS_INIT)
-		return;
-
 	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMPMR,
 		       VI6_UIF_DISCOM_DOCMPMR_SEL(9));
 
@@ -231,7 +223,7 @@ static void uif_configure(struct vsp1_entity *entity,
 }
 
 static const struct vsp1_entity_operations uif_entity_ops = {
-	.configure = uif_configure,
+	.configure_stream = uif_configure_stream,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c8c12223a267..b96717f58a72 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -382,11 +382,8 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 
 	pipe->partition = &pipe->part_table[partition];
 
-	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, dl,
-					       VSP1_ENTITY_PARAMS_PARTITION);
-	}
+	list_for_each_entry(entity, &pipe->entities, list_pipe)
+		vsp1_entity_configure_partition(entity, pipe, dl);
 }
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
@@ -398,21 +395,13 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
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
+	list_for_each_entry(entity, &pipe->entities, list_pipe)
+		vsp1_entity_configure_frame(entity, pipe, pipe->dl);
 
-	/* Run the first partition */
+	/* Run the first partition. */
 	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
 
-	/* Process consecutive partitions as necessary */
+	/* Process consecutive partitions as necessary. */
 	for (partition = 1; partition < pipe->partitions; ++partition) {
 		struct vsp1_dl_list *dl;
 
@@ -833,10 +822,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		vsp1_entity_route_setup(entity, pipe, pipe->dl);
-
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl,
-					       VSP1_ENTITY_PARAMS_INIT);
+		vsp1_entity_configure_stream(entity, pipe, pipe->dl);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 65ed2f849551..da287c27b324 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -232,10 +232,9 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 	vsp1_dlm_destroy(wpf->dlm);
 }
 
-static void wpf_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  enum vsp1_entity_params params)
+static void wpf_configure_stream(struct vsp1_entity *entity,
+				 struct vsp1_pipeline *pipe,
+				 struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -245,149 +244,12 @@ static void wpf_configure(struct vsp1_entity *entity,
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
@@ -461,6 +323,161 @@ static void wpf_configure(struct vsp1_entity *entity,
 			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
+static void wpf_configure_frame(struct vsp1_entity *entity,
+				struct vsp1_pipeline *pipe,
+				struct vsp1_dl_list *dl)
+{
+	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+	unsigned long flags;
+	u32 outfmt = 0;
+
+	const unsigned int mask = BIT(WPF_CTRL_VFLIP)
+				| BIT(WPF_CTRL_HFLIP);
+
+	spin_lock_irqsave(&wpf->flip.lock, flags);
+	wpf->flip.active = (wpf->flip.active & ~mask)
+			 | (wpf->flip.pending & mask);
+	spin_unlock_irqrestore(&wpf->flip.lock, flags);
+
+	outfmt = (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT) | wpf->outfmt;
+
+	if (wpf->flip.active & BIT(WPF_CTRL_VFLIP))
+		outfmt |= VI6_WPF_OUTFMT_FLP;
+	if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
+		outfmt |= VI6_WPF_OUTFMT_HFLP;
+
+	vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
+}
+
+static void wpf_configure_partition(struct vsp1_entity *entity,
+				    struct vsp1_pipeline *pipe,
+				    struct vsp1_dl_list *dl)
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
@@ -480,7 +497,9 @@ static void wpf_partition(struct vsp1_entity *entity,
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
-	.configure = wpf_configure,
+	.configure_stream = wpf_configure_stream,
+	.configure_frame = wpf_configure_frame,
+	.configure_partition = wpf_configure_partition,
 	.max_width = wpf_max_width,
 	.partition = wpf_partition,
 };
-- 
git-series 0.9.1
