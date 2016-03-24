Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbcCXX2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:22 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 32/51] v4l: vsp1: Create a new configure operation to setup modules
Date: Fri, 25 Mar 2016 01:27:28 +0200
Message-Id: <1458862067-19525-33-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subdev s_stream operation is abused as a generic way to setup
modules at every frame. Move the code out to a new VSP1 entity configure
operation.

Most modules now have an empty s_stream operation that can be removed.
The only exception is the WPF module that needs to perform hardware
configuration when stopping the stream. The code can be simplified
accordingly as we know that that operation never fails.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 231 ++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_drm.c    |  14 +-
 drivers/media/platform/vsp1/vsp1_entity.h |   3 +
 drivers/media/platform/vsp1/vsp1_hsit.c   |  50 +++----
 drivers/media/platform/vsp1/vsp1_lif.c    |  77 +++++-----
 drivers/media/platform/vsp1/vsp1_lut.c    |  41 +++---
 drivers/media/platform/vsp1/vsp1_pipe.c   |   4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  83 +++++------
 drivers/media/platform/vsp1/vsp1_sru.c    |  91 ++++++------
 drivers/media/platform/vsp1/vsp1_uds.c    | 117 ++++++++-------
 drivers/media/platform/vsp1/vsp1_video.c  |  15 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 168 +++++++++++-----------
 12 files changed, 418 insertions(+), 476 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index d3b63056450a..df57ab6d7e3e 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -56,117 +56,7 @@ static const struct v4l2_ctrl_ops bru_ctrl_ops = {
 };
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
-static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
-	struct vsp1_bru *bru = to_bru(subdev);
-	struct v4l2_mbus_framefmt *format;
-	unsigned int flags;
-	unsigned int i;
-
-	if (!enable)
-		return 0;
-
-	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
-					    bru->entity.source_pad);
-
-	/* The hardware is extremely flexible but we have no userspace API to
-	 * expose all the parameters, nor is it clear whether we would have use
-	 * cases for all the supported modes. Let's just harcode the parameters
-	 * to sane default values for now.
-	 */
-
-	/* Disable dithering and enable color data normalization unless the
-	 * format at the pipeline output is premultiplied.
-	 */
-	flags = pipe->output ? pipe->output->format.flags : 0;
-	vsp1_bru_write(bru, VI6_BRU_INCTRL,
-		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
-		       0 : VI6_BRU_INCTRL_NRM);
-
-	/* Set the background position to cover the whole output image and
-	 * configure its color.
-	 */
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_SIZE,
-		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
-		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_LOC, 0);
-
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, bru->bgcolor |
-		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
-
-	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
-	 * unit with a NOP operation to make BRU input 1 available as the
-	 * Blend/ROP unit B SRC input.
-	 */
-	vsp1_bru_write(bru, VI6_BRU_ROP, VI6_BRU_ROP_DSTSEL_BRUIN(1) |
-		       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
-		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
-
-	for (i = 0; i < bru->entity.source_pad; ++i) {
-		bool premultiplied = false;
-		u32 ctrl = 0;
-
-		/* Configure all Blend/ROP units corresponding to an enabled BRU
-		 * input for alpha blending. Blend/ROP units corresponding to
-		 * disabled BRU inputs are used in ROP NOP mode to ignore the
-		 * SRC input.
-		 */
-		if (bru->inputs[i].rpf) {
-			ctrl |= VI6_BRU_CTRL_RBC;
-
-			premultiplied = bru->inputs[i].rpf->format.flags
-				      & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
-		} else {
-			ctrl |= VI6_BRU_CTRL_CROP(VI6_ROP_NOP)
-			     |  VI6_BRU_CTRL_AROP(VI6_ROP_NOP);
-		}
-
-		/* Select the virtual RPF as the Blend/ROP unit A DST input to
-		 * serve as a background color.
-		 */
-		if (i == 0)
-			ctrl |= VI6_BRU_CTRL_DSTSEL_VRPF;
-
-		/* Route BRU inputs 0 to 3 as SRC inputs to Blend/ROP units A to
-		 * D in that order. The Blend/ROP unit B SRC is hardwired to the
-		 * ROP unit output, the corresponding register bits must be set
-		 * to 0.
-		 */
-		if (i != 1)
-			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
-
-		vsp1_bru_write(bru, VI6_BRU_CTRL(i), ctrl);
-
-		/* Harcode the blending formula to
-		 *
-		 *	DSTc = DSTc * (1 - SRCa) + SRCc * SRCa
-		 *	DSTa = DSTa * (1 - SRCa) + SRCa
-		 *
-		 * when the SRC input isn't premultiplied, and to
-		 *
-		 *	DSTc = DSTc * (1 - SRCa) + SRCc
-		 *	DSTa = DSTa * (1 - SRCa) + SRCa
-		 *
-		 * otherwise.
-		 */
-		vsp1_bru_write(bru, VI6_BRU_BLD(i),
-			       VI6_BRU_BLD_CCMDX_255_SRC_A |
-			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
-						VI6_BRU_BLD_CCMDY_SRC_A) |
-			       VI6_BRU_BLD_ACMDX_255_SRC_A |
-			       VI6_BRU_BLD_ACMDY_COEFY |
-			       (0xff << VI6_BRU_BLD_COEFY_SHIFT));
-	}
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Pad Operations
+ * V4L2 Subdevice Operations
  */
 
 /*
@@ -395,14 +285,6 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops bru_video_ops = {
-	.s_stream = bru_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops bru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = bru_enum_mbus_code,
@@ -414,11 +296,119 @@ static struct v4l2_subdev_pad_ops bru_pad_ops = {
 };
 
 static struct v4l2_subdev_ops bru_ops = {
-	.video	= &bru_video_ops,
 	.pad    = &bru_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void bru_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
+	struct vsp1_bru *bru = to_bru(&entity->subdev);
+	struct v4l2_mbus_framefmt *format;
+	unsigned int flags;
+	unsigned int i;
+
+	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
+					    bru->entity.source_pad);
+
+	/* The hardware is extremely flexible but we have no userspace API to
+	 * expose all the parameters, nor is it clear whether we would have use
+	 * cases for all the supported modes. Let's just harcode the parameters
+	 * to sane default values for now.
+	 */
+
+	/* Disable dithering and enable color data normalization unless the
+	 * format at the pipeline output is premultiplied.
+	 */
+	flags = pipe->output ? pipe->output->format.flags : 0;
+	vsp1_bru_write(bru, VI6_BRU_INCTRL,
+		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
+		       0 : VI6_BRU_INCTRL_NRM);
+
+	/* Set the background position to cover the whole output image and
+	 * configure its color.
+	 */
+	vsp1_bru_write(bru, VI6_BRU_VIRRPF_SIZE,
+		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
+		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
+	vsp1_bru_write(bru, VI6_BRU_VIRRPF_LOC, 0);
+
+	vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, bru->bgcolor |
+		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
+
+	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
+	 * unit with a NOP operation to make BRU input 1 available as the
+	 * Blend/ROP unit B SRC input.
+	 */
+	vsp1_bru_write(bru, VI6_BRU_ROP, VI6_BRU_ROP_DSTSEL_BRUIN(1) |
+		       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
+		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
+
+	for (i = 0; i < bru->entity.source_pad; ++i) {
+		bool premultiplied = false;
+		u32 ctrl = 0;
+
+		/* Configure all Blend/ROP units corresponding to an enabled BRU
+		 * input for alpha blending. Blend/ROP units corresponding to
+		 * disabled BRU inputs are used in ROP NOP mode to ignore the
+		 * SRC input.
+		 */
+		if (bru->inputs[i].rpf) {
+			ctrl |= VI6_BRU_CTRL_RBC;
+
+			premultiplied = bru->inputs[i].rpf->format.flags
+				      & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
+		} else {
+			ctrl |= VI6_BRU_CTRL_CROP(VI6_ROP_NOP)
+			     |  VI6_BRU_CTRL_AROP(VI6_ROP_NOP);
+		}
+
+		/* Select the virtual RPF as the Blend/ROP unit A DST input to
+		 * serve as a background color.
+		 */
+		if (i == 0)
+			ctrl |= VI6_BRU_CTRL_DSTSEL_VRPF;
+
+		/* Route BRU inputs 0 to 3 as SRC inputs to Blend/ROP units A to
+		 * D in that order. The Blend/ROP unit B SRC is hardwired to the
+		 * ROP unit output, the corresponding register bits must be set
+		 * to 0.
+		 */
+		if (i != 1)
+			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
+
+		vsp1_bru_write(bru, VI6_BRU_CTRL(i), ctrl);
+
+		/* Harcode the blending formula to
+		 *
+		 *	DSTc = DSTc * (1 - SRCa) + SRCc * SRCa
+		 *	DSTa = DSTa * (1 - SRCa) + SRCa
+		 *
+		 * when the SRC input isn't premultiplied, and to
+		 *
+		 *	DSTc = DSTc * (1 - SRCa) + SRCc
+		 *	DSTa = DSTa * (1 - SRCa) + SRCa
+		 *
+		 * otherwise.
+		 */
+		vsp1_bru_write(bru, VI6_BRU_BLD(i),
+			       VI6_BRU_BLD_CCMDX_255_SRC_A |
+			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
+						VI6_BRU_BLD_CCMDY_SRC_A) |
+			       VI6_BRU_BLD_ACMDX_255_SRC_A |
+			       VI6_BRU_BLD_ACMDY_COEFY |
+			       (0xff << VI6_BRU_BLD_COEFY_SHIFT));
+	}
+}
+
+static const struct vsp1_entity_operations bru_entity_ops = {
+	.configure = bru_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -431,6 +421,7 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	if (bru == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	bru->entity.ops = &bru_entity_ops;
 	bru->entity.type = VSP1_ENTITY_BRU;
 
 	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index acbf36d315b9..bec7a651d152 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -448,7 +448,6 @@ void vsp1_du_atomic_flush(struct device *dev)
 	struct vsp1_entity *entity;
 	unsigned long flags;
 	bool stop = false;
-	int ret;
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		/* Disconnect unused RPFs from the pipeline. */
@@ -464,19 +463,16 @@ void vsp1_du_atomic_flush(struct device *dev)
 
 		vsp1_entity_route_setup(entity);
 
-		ret = v4l2_subdev_call(&entity->subdev, video,
-				       s_stream, 1);
-		if (ret < 0) {
-			dev_err(vsp1->dev,
-				"DRM pipeline start failure on entity %s\n",
-				entity->subdev.name);
-			return;
-		}
+		if (entity->ops->configure)
+			entity->ops->configure(entity);
 
 		if (entity->type == VSP1_ENTITY_RPF)
 			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev));
 	}
 
+	/* We know that the WPF s_stream operation never fails. */
+	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 1);
+
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 1935ae9289ba..3ce74c6f12e1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -59,10 +59,13 @@ struct vsp1_route {
  * @set_memory:	Setup memory buffer access. This operation applies the settings
  *		stored in the rwpf mem field to the hardware. Valid for RPF and
  *		WPF only.
+ * @configure:	Setup the hardware based on the entity state (pipeline, formats,
+ *		selection rectangles, ...)
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*set_memory)(struct vsp1_entity *);
+	void (*configure)(struct vsp1_entity *);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 6565ef62c376..b935a62e6399 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -32,26 +32,7 @@ static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
-static int hsit_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	struct vsp1_hsit *hsit = to_hsit(subdev);
-
-	if (!enable)
-		return 0;
-
-	if (hsit->inverse)
-		vsp1_hsit_write(hsit, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
-	else
-		vsp1_hsit_write(hsit, VI6_HST_CTRL, VI6_HST_CTRL_EN);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Pad Operations
+ * V4L2 Subdevice Operations
  */
 
 static int hsit_enum_mbus_code(struct v4l2_subdev *subdev,
@@ -167,14 +148,6 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops hsit_video_ops = {
-	.s_stream = hsit_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops hsit_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = hsit_enum_mbus_code,
@@ -184,11 +157,28 @@ static struct v4l2_subdev_pad_ops hsit_pad_ops = {
 };
 
 static struct v4l2_subdev_ops hsit_ops = {
-	.video	= &hsit_video_ops,
 	.pad    = &hsit_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void hsit_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
+
+	if (hsit->inverse)
+		vsp1_hsit_write(hsit, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
+	else
+		vsp1_hsit_write(hsit, VI6_HST_CTRL, VI6_HST_CTRL_EN);
+}
+
+static const struct vsp1_entity_operations hsit_entity_ops = {
+	.configure = hsit_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -203,6 +193,8 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 
 	hsit->inverse = inverse;
 
+	hsit->entity.ops = &hsit_entity_ops;
+
 	if (inverse)
 		hsit->entity.type = VSP1_ENTITY_HSI;
 	else
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 9ab40d843578..d3b94055f23c 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -32,41 +32,7 @@ static inline void vsp1_lif_write(struct vsp1_lif *lif, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
-static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	const struct v4l2_mbus_framefmt *format;
-	struct vsp1_lif *lif = to_lif(subdev);
-	unsigned int hbth = 1300;
-	unsigned int obth = 400;
-	unsigned int lbth = 200;
-
-	if (!enable) {
-		vsp1_write(lif->entity.vsp1, VI6_LIF_CTRL, 0);
-		return 0;
-	}
-
-	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
-					    LIF_PAD_SOURCE);
-
-	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
-
-	vsp1_lif_write(lif, VI6_LIF_CSBTH,
-			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
-			(lbth << VI6_LIF_CSBTH_LBTH_SHIFT));
-
-	vsp1_lif_write(lif, VI6_LIF_CTRL,
-			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
-			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
-			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Pad Operations
+ * V4L2 Subdevice Operations
  */
 
 static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
@@ -201,14 +167,6 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops lif_video_ops = {
-	.s_stream = lif_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops lif_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lif_enum_mbus_code,
@@ -218,11 +176,41 @@ static struct v4l2_subdev_pad_ops lif_pad_ops = {
 };
 
 static struct v4l2_subdev_ops lif_ops = {
-	.video	= &lif_video_ops,
 	.pad    = &lif_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void lif_configure(struct vsp1_entity *entity)
+{
+	const struct v4l2_mbus_framefmt *format;
+	struct vsp1_lif *lif = to_lif(&entity->subdev);
+	unsigned int hbth = 1300;
+	unsigned int obth = 400;
+	unsigned int lbth = 200;
+
+	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
+					    LIF_PAD_SOURCE);
+
+	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
+
+	vsp1_lif_write(lif, VI6_LIF_CSBTH,
+			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
+			(lbth << VI6_LIF_CSBTH_LBTH_SHIFT));
+
+	vsp1_lif_write(lif, VI6_LIF_CTRL,
+			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
+			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
+			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
+}
+
+static const struct vsp1_entity_operations lif_entity_ops = {
+	.configure = lif_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -235,6 +223,7 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 	if (lif == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	lif->entity.ops = &lif_entity_ops;
 	lif->entity.type = VSP1_ENTITY_LIF;
 
 	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 9510424113b2..1e8d43460d49 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -36,7 +36,7 @@ static inline void vsp1_lut_write(struct vsp1_lut *lut, u32 reg, u32 data)
  * V4L2 Subdevice Core Operations
  */
 
-static void lut_configure(struct vsp1_lut *lut, struct vsp1_lut_config *config)
+static void lut_set_table(struct vsp1_lut *lut, struct vsp1_lut_config *config)
 {
 	memcpy_toio(lut->entity.vsp1->mmio + VI6_LUT_TABLE, config->lut,
 		    sizeof(config->lut));
@@ -48,7 +48,7 @@ static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
 
 	switch (cmd) {
 	case VIDIOC_VSP1_LUT_CONFIG:
-		lut_configure(lut, arg);
+		lut_set_table(lut, arg);
 		return 0;
 
 	default:
@@ -57,22 +57,6 @@ static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Video Operations
- */
-
-static int lut_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	struct vsp1_lut *lut = to_lut(subdev);
-
-	if (!enable)
-		return 0;
-
-	vsp1_lut_write(lut, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Pad Operations
  */
 
@@ -218,10 +202,6 @@ static struct v4l2_subdev_core_ops lut_core_ops = {
 	.ioctl = lut_ioctl,
 };
 
-static struct v4l2_subdev_video_ops lut_video_ops = {
-	.s_stream = lut_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops lut_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lut_enum_mbus_code,
@@ -232,11 +212,25 @@ static struct v4l2_subdev_pad_ops lut_pad_ops = {
 
 static struct v4l2_subdev_ops lut_ops = {
 	.core	= &lut_core_ops,
-	.video	= &lut_video_ops,
 	.pad    = &lut_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void lut_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_lut *lut = to_lut(&entity->subdev);
+
+	vsp1_lut_write(lut, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+}
+
+static const struct vsp1_entity_operations lut_entity_ops = {
+	.configure = lut_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -249,6 +243,7 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (lut == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	lut->entity.ops = &lut_entity_ops;
 	lut->entity.type = VSP1_ENTITY_LUT;
 
 	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops,
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 3311db18f40b..fe2538d5bed1 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -253,10 +253,10 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 		if (entity->route && entity->route->reg)
 			vsp1_write(entity->vsp1, entity->route->reg,
 				   VI6_DPR_NODE_UNUSED);
-
-		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
 	}
 
+	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 0);
+
 	return ret;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 198487952418..acc88b4a449b 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -33,13 +33,43 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
+ * V4L2 Subdevice Operations
  */
 
-static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
+static struct v4l2_subdev_pad_ops rpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_rwpf_get_format,
+	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
+};
+
+static struct v4l2_subdev_ops rpf_ops = {
+	.pad    = &rpf_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void rpf_set_memory(struct vsp1_entity *entity)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
-	struct vsp1_rwpf *rpf = to_rwpf(subdev);
+	struct vsp1_rwpf *rpf = entity_to_rwpf(entity);
+
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
+		       rpf->mem.addr[0] + rpf->offsets[0]);
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
+		       rpf->mem.addr[1] + rpf->offsets[1]);
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
+		       rpf->mem.addr[2] + rpf->offsets[1]);
+}
+
+static void rpf_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_mbus_framefmt *source_format;
@@ -50,9 +80,6 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	u32 pstride;
 	u32 infmt;
 
-	if (!enable)
-		return 0;
-
 	/* Source size, stride and crop offsets.
 	 *
 	 * The crop offsets correspond to the location of the crop rectangle top
@@ -136,51 +163,11 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops rpf_video_ops = {
-	.s_stream = rpf_s_stream,
-};
-
-static struct v4l2_subdev_pad_ops rpf_pad_ops = {
-	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
-	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_rwpf_get_format,
-	.set_fmt = vsp1_rwpf_set_format,
-	.get_selection = vsp1_rwpf_get_selection,
-	.set_selection = vsp1_rwpf_set_selection,
-};
-
-static struct v4l2_subdev_ops rpf_ops = {
-	.video	= &rpf_video_ops,
-	.pad    = &rpf_pad_ops,
-};
-
-/* -----------------------------------------------------------------------------
- * VSP1 Entity Operations
- */
-
-static void rpf_set_memory(struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *rpf = entity_to_rwpf(entity);
-
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
-		       rpf->mem.addr[0] + rpf->offsets[0]);
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
-		       rpf->mem.addr[1] + rpf->offsets[1]);
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
-		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
 	.set_memory = rpf_set_memory,
+	.configure = rpf_configure,
 };
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index a67fa0c9fe3b..82a8ee202f1a 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -103,47 +103,7 @@ static const struct v4l2_ctrl_config sru_intensity_control = {
 };
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
-static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	const struct vsp1_sru_param *param;
-	struct vsp1_sru *sru = to_sru(subdev);
-	struct v4l2_mbus_framefmt *input;
-	struct v4l2_mbus_framefmt *output;
-	u32 ctrl0;
-
-	if (!enable)
-		return 0;
-
-	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
-					   SRU_PAD_SINK);
-	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
-					    SRU_PAD_SOURCE);
-
-	if (input->code == MEDIA_BUS_FMT_ARGB8888_1X32)
-		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
-		      | VI6_SRU_CTRL0_PARAM4;
-	else
-		ctrl0 = VI6_SRU_CTRL0_PARAM3;
-
-	if (input->width != output->width)
-		ctrl0 |= VI6_SRU_CTRL0_MODE_UPSCALE;
-
-	param = &vsp1_sru_params[sru->intensity - 1];
-
-	ctrl0 |= param->ctrl0;
-
-	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
-	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
-	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Pad Operations
+ * V4L2 Subdevice Operations
  */
 
 static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
@@ -319,14 +279,6 @@ static int sru_set_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops sru_video_ops = {
-	.s_stream = sru_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops sru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = sru_enum_mbus_code,
@@ -336,11 +288,49 @@ static struct v4l2_subdev_pad_ops sru_pad_ops = {
 };
 
 static struct v4l2_subdev_ops sru_ops = {
-	.video	= &sru_video_ops,
 	.pad    = &sru_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void sru_configure(struct vsp1_entity *entity)
+{
+	const struct vsp1_sru_param *param;
+	struct vsp1_sru *sru = to_sru(&entity->subdev);
+	struct v4l2_mbus_framefmt *input;
+	struct v4l2_mbus_framefmt *output;
+	u32 ctrl0;
+
+	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					   SRU_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					    SRU_PAD_SOURCE);
+
+	if (input->code == MEDIA_BUS_FMT_ARGB8888_1X32)
+		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
+		      | VI6_SRU_CTRL0_PARAM4;
+	else
+		ctrl0 = VI6_SRU_CTRL0_PARAM3;
+
+	if (input->width != output->width)
+		ctrl0 |= VI6_SRU_CTRL0_MODE_UPSCALE;
+
+	param = &vsp1_sru_params[sru->intensity - 1];
+
+	ctrl0 |= param->ctrl0;
+
+	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
+	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
+	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
+}
+
+static const struct vsp1_entity_operations sru_entity_ops = {
+	.configure = sru_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -353,6 +343,7 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	if (sru == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	sru->entity.ops = &sru_entity_ops;
 	sru->entity.type = VSP1_ENTITY_SRU;
 
 	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index c2209823140e..88c44f450f88 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -105,62 +105,6 @@ static unsigned int uds_compute_ratio(unsigned int input, unsigned int output)
 }
 
 /* -----------------------------------------------------------------------------
- * V4L2 Subdevice Core Operations
- */
-
-static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
-{
-	struct vsp1_uds *uds = to_uds(subdev);
-	const struct v4l2_mbus_framefmt *output;
-	const struct v4l2_mbus_framefmt *input;
-	unsigned int hscale;
-	unsigned int vscale;
-	bool multitap;
-
-	if (!enable)
-		return 0;
-
-	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
-					   UDS_PAD_SINK);
-	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
-					    UDS_PAD_SOURCE);
-
-	hscale = uds_compute_ratio(input->width, output->width);
-	vscale = uds_compute_ratio(input->height, output->height);
-
-	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n", hscale, vscale);
-
-	/* Multi-tap scaling can't be enabled along with alpha scaling when
-	 * scaling down with a factor lower than or equal to 1/2 in either
-	 * direction.
-	 */
-	if (uds->scale_alpha && (hscale >= 8192 || vscale >= 8192))
-		multitap = false;
-	else
-		multitap = true;
-
-	vsp1_uds_write(uds, VI6_UDS_CTRL,
-		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
-		       (multitap ? VI6_UDS_CTRL_BC : 0));
-
-	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
-		       (uds_passband_width(hscale)
-				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
-		       (uds_passband_width(vscale)
-				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
-
-	/* Set the scaling ratios and the output size. */
-	vsp1_uds_write(uds, VI6_UDS_SCALE,
-		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
-		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
-	vsp1_uds_write(uds, VI6_UDS_CLIP_SIZE,
-		       (output->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Pad Operations
  */
 
@@ -321,10 +265,6 @@ static int uds_set_format(struct v4l2_subdev *subdev,
  * V4L2 Subdevice Operations
  */
 
-static struct v4l2_subdev_video_ops uds_video_ops = {
-	.s_stream = uds_s_stream,
-};
-
 static struct v4l2_subdev_pad_ops uds_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = uds_enum_mbus_code,
@@ -334,11 +274,65 @@ static struct v4l2_subdev_pad_ops uds_pad_ops = {
 };
 
 static struct v4l2_subdev_ops uds_ops = {
-	.video	= &uds_video_ops,
 	.pad    = &uds_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void uds_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_uds *uds = to_uds(&entity->subdev);
+	const struct v4l2_mbus_framefmt *output;
+	const struct v4l2_mbus_framefmt *input;
+	unsigned int hscale;
+	unsigned int vscale;
+	bool multitap;
+
+	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					   UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
+
+	hscale = uds_compute_ratio(input->width, output->width);
+	vscale = uds_compute_ratio(input->height, output->height);
+
+	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n", hscale, vscale);
+
+	/* Multi-tap scaling can't be enabled along with alpha scaling when
+	 * scaling down with a factor lower than or equal to 1/2 in either
+	 * direction.
+	 */
+	if (uds->scale_alpha && (hscale >= 8192 || vscale >= 8192))
+		multitap = false;
+	else
+		multitap = true;
+
+	vsp1_uds_write(uds, VI6_UDS_CTRL,
+		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
+		       (multitap ? VI6_UDS_CTRL_BC : 0));
+
+	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
+		       (uds_passband_width(hscale)
+				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
+		       (uds_passband_width(vscale)
+				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
+
+	/* Set the scaling ratios and the output size. */
+	vsp1_uds_write(uds, VI6_UDS_SCALE,
+		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
+		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
+	vsp1_uds_write(uds, VI6_UDS_CLIP_SIZE,
+		       (output->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+}
+
+static const struct vsp1_entity_operations uds_entity_ops = {
+	.configure = uds_configure,
+};
+
+/* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
@@ -352,6 +346,7 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	if (uds == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	uds->entity.ops = &uds_entity_ops;
 	uds->entity.type = VSP1_ENTITY_UDS;
 	uds->entity.index = index;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d4a092c8ece3..a3f1145c8a79 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -591,7 +591,6 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_entity *entity;
-	int ret;
 
 	/* Prepare the display list. */
 	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
@@ -619,18 +618,14 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		vsp1_entity_route_setup(entity);
 
-		ret = v4l2_subdev_call(&entity->subdev, video, s_stream, 1);
-		if (ret < 0)
-			goto error;
+		if (entity->ops->configure)
+			entity->ops->configure(entity);
 	}
 
-	return 0;
+	/* We know that the WPF s_stream operation never fails. */
+	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 1);
 
-error:
-	vsp1_dl_list_put(pipe->dl);
-	pipe->dl = NULL;
-
-	return ret;
+	return 0;
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 962b43b7f99e..65481930b218 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -39,55 +39,78 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
 
 static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
 	struct vsp1_rwpf *wpf = to_rwpf(subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
-	const struct v4l2_mbus_framefmt *source_format;
-	const struct v4l2_mbus_framefmt *sink_format;
-	const struct v4l2_rect *crop;
-	unsigned int i;
-	u32 srcrpf = 0;
-	u32 outfmt = 0;
 
-	if (!enable) {
-		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
-		vsp1_write(vsp1, wpf->entity.index * VI6_WPF_OFFSET +
-			   VI6_WPF_SRCRPF, 0);
+	if (enable)
 		return 0;
-	}
 
-	/* Sources. If the pipeline has a single input and BRU is not used,
-	 * configure it as the master layer. Otherwise configure all
-	 * inputs as sub-layers and select the virtual RPF as the master
-	 * layer.
+	/* Write to registers directly when stopping the stream as there will be
+	 * no pipeline run to apply the display list.
 	 */
-	for (i = 0; i < vsp1->info->rpf_count; ++i) {
-		struct vsp1_rwpf *input = pipe->inputs[i];
+	vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
+	vsp1_write(vsp1, wpf->entity.index * VI6_WPF_OFFSET +
+		   VI6_WPF_SRCRPF, 0);
 
-		if (!input)
-			continue;
+	return 0;
+}
 
-		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
-			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
-			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
-	}
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
 
-	if (pipe->bru || pipe->num_inputs > 1)
-		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
+static struct v4l2_subdev_video_ops wpf_video_ops = {
+	.s_stream = wpf_s_stream,
+};
 
-	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
+static struct v4l2_subdev_pad_ops wpf_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
+	.enum_frame_size = vsp1_rwpf_enum_frame_size,
+	.get_fmt = vsp1_rwpf_get_format,
+	.set_fmt = vsp1_rwpf_set_format,
+	.get_selection = vsp1_rwpf_get_selection,
+	.set_selection = vsp1_rwpf_set_selection,
+};
 
-	/* Destination stride. */
-	if (!pipe->lif) {
-		struct v4l2_pix_format_mplane *format = &wpf->format;
+static struct v4l2_subdev_ops wpf_ops = {
+	.video	= &wpf_video_ops,
+	.pad    = &wpf_pad_ops,
+};
 
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
-			       format->plane_fmt[0].bytesperline);
-		if (format->num_planes > 1)
-			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
-				       format->plane_fmt[1].bytesperline);
-	}
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void vsp1_wpf_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+
+	vsp1_dlm_destroy(wpf->dlm);
+}
+
+static void wpf_set_memory(struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
+	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
+}
+
+static void wpf_configure(struct vsp1_entity *entity)
+{
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
+	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+	struct vsp1_device *vsp1 = wpf->entity.vsp1;
+	const struct v4l2_mbus_framefmt *source_format;
+	const struct v4l2_mbus_framefmt *sink_format;
+	const struct v4l2_rect *crop;
+	unsigned int i;
+	u32 outfmt = 0;
+	u32 srcrpf = 0;
 
+	/* Cropping */
 	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
 
 	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
@@ -106,6 +129,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 						   RWPF_PAD_SOURCE);
 
 	if (!pipe->lif) {
+		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
 		outfmt = fmtinfo->hwfmt << VI6_WPF_OUTFMT_WRFMT_SHIFT;
@@ -117,6 +141,13 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		if (fmtinfo->swap_uv)
 			outfmt |= VI6_WPF_OUTFMT_SPUVS;
 
+		/* Destination stride and byte swapping. */
+		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
+			       format->plane_fmt[0].bytesperline);
+		if (format->num_planes > 1)
+			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
+				       format->plane_fmt[1].bytesperline);
+
 		vsp1_wpf_write(wpf, VI6_WPF_DSWAP, fmtinfo->swap);
 	}
 
@@ -131,60 +162,37 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 
 	vsp1_mod_write(&wpf->entity, VI6_WPF_WRBCK_CTRL, 0);
 
-	/* Enable interrupts */
-	vsp1_write(vsp1, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index),
-		   VI6_WFP_IRQ_ENB_FREE);
-
-	return 0;
-}
-
-/* -----------------------------------------------------------------------------
- * V4L2 Subdevice Operations
- */
-
-static struct v4l2_subdev_video_ops wpf_video_ops = {
-	.s_stream = wpf_s_stream,
-};
-
-static struct v4l2_subdev_pad_ops wpf_pad_ops = {
-	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
-	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_rwpf_get_format,
-	.set_fmt = vsp1_rwpf_set_format,
-	.get_selection = vsp1_rwpf_get_selection,
-	.set_selection = vsp1_rwpf_set_selection,
-};
-
-static struct v4l2_subdev_ops wpf_ops = {
-	.video	= &wpf_video_ops,
-	.pad    = &wpf_pad_ops,
-};
+	/* Sources. If the pipeline has a single input and BRU is not used,
+	 * configure it as the master layer. Otherwise configure all
+	 * inputs as sub-layers and select the virtual RPF as the master
+	 * layer.
+	 */
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
+		struct vsp1_rwpf *input = pipe->inputs[i];
 
-/* -----------------------------------------------------------------------------
- * VSP1 Entity Operations
- */
+		if (!input)
+			continue;
 
-static void vsp1_wpf_destroy(struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
+			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
+			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
+	}
 
-	vsp1_dlm_destroy(wpf->dlm);
-}
+	if (pipe->bru || pipe->num_inputs > 1)
+		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
 
-static void wpf_set_memory(struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
+	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
 
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
+	/* Enable interrupts */
+	vsp1_mod_write(&wpf->entity, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
+	vsp1_mod_write(&wpf->entity, VI6_WPF_IRQ_ENB(wpf->entity.index),
+		       VI6_WFP_IRQ_ENB_FREE);
 }
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
 	.destroy = vsp1_wpf_destroy,
 	.set_memory = wpf_set_memory,
+	.configure = wpf_configure,
 };
 
 /* -----------------------------------------------------------------------------
-- 
2.7.3

