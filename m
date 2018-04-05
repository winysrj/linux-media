Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54331 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeDEJSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 05:18:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 15/15] v4l: vsp1: Rename BRU to BRx
Date: Thu,  5 Apr 2018 12:18:40 +0300
Message-Id: <20180405091840.30728-16-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180405091840.30728-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some VSP instances have two blending units named BRU (Blend/ROP Unit)
and BRS (Blend/ROP Sub unit). The BRS is a smaller version of the BRU
with only two inputs, but otherwise offers similar features and offers
the same register interface. The BRU and BRS can be used exchangeably in
VSP pipelines (provided no more than two inputs are needed).

Due to historical reasons, the VSP1 driver implements support for both
the BRU and BRS through objects named vsp1_bru. The code uses the name
BRU to refer to either the BRU or the BRS, except in a few places where
noted explicitly. This creates confusion.

In an effort to avoid confusion, rename the vsp1_bru object and the
corresponding API to vsp1_brx, and use BRx to refer to blend unit
instances regardless of their type. The names BRU and BRS are retained
where reference to a particular blend unit type is needed, as well as in
hardware registers to stay close to the datasheet.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile               |   2 +-
 drivers/media/platform/vsp1/vsp1.h                 |   6 +-
 .../media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} | 202 ++++++++++-----------
 .../media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} |  18 +-
 drivers/media/platform/vsp1/vsp1_drm.c             | 174 +++++++++---------
 drivers/media/platform/vsp1/vsp1_drm.h             |   6 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   6 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |  12 +-
 drivers/media/platform/vsp1/vsp1_pipe.h            |   4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |  12 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h            |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  16 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   8 +-
 13 files changed, 234 insertions(+), 234 deletions(-)
 rename drivers/media/platform/vsp1/{vsp1_bru.c => vsp1_brx.c} (63%)
 rename drivers/media/platform/vsp1/{vsp1_bru.h => vsp1_brx.h} (66%)

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index f5cd6f0491cb..596775f932c0 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -3,7 +3,7 @@ vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_pipe.o
 vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
-vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
+vsp1-y					+= vsp1_brx.o vsp1_sru.o vsp1_uds.o
 vsp1-y					+= vsp1_hgo.o vsp1_hgt.o vsp1_histo.o
 vsp1-y					+= vsp1_lif.o
 
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 78ef838416b3..894cc725c2d4 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -30,7 +30,7 @@ struct rcar_fcp_device;
 struct vsp1_drm;
 struct vsp1_entity;
 struct vsp1_platform_data;
-struct vsp1_bru;
+struct vsp1_brx;
 struct vsp1_clu;
 struct vsp1_hgo;
 struct vsp1_hgt;
@@ -78,8 +78,8 @@ struct vsp1_device {
 	struct rcar_fcp_device *fcp;
 	struct device *bus_master;
 
-	struct vsp1_bru *brs;
-	struct vsp1_bru *bru;
+	struct vsp1_brx *brs;
+	struct vsp1_brx *bru;
 	struct vsp1_clu *clu;
 	struct vsp1_hgo *hgo;
 	struct vsp1_hgt *hgt;
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_brx.c
similarity index 63%
rename from drivers/media/platform/vsp1/vsp1_bru.c
rename to drivers/media/platform/vsp1/vsp1_brx.c
index e8fd2ae3b3eb..b4af1d546022 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_brx.c
@@ -1,5 +1,5 @@
 /*
- * vsp1_bru.c  --  R-Car VSP1 Blend ROP Unit
+ * vsp1_brx.c  --  R-Car VSP1 Blend ROP Unit (BRU and BRS)
  *
  * Copyright (C) 2013 Renesas Corporation
  *
@@ -17,45 +17,45 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
-#include "vsp1_bru.h"
+#include "vsp1_brx.h"
 #include "vsp1_dl.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
-#define BRU_MIN_SIZE				1U
-#define BRU_MAX_SIZE				8190U
+#define BRX_MIN_SIZE				1U
+#define BRX_MAX_SIZE				8190U
 
 /* -----------------------------------------------------------------------------
  * Device Access
  */
 
-static inline void vsp1_bru_write(struct vsp1_bru *bru, struct vsp1_dl_list *dl,
+static inline void vsp1_brx_write(struct vsp1_brx *brx, struct vsp1_dl_list *dl,
 				  u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, bru->base + reg, data);
+	vsp1_dl_list_write(dl, brx->base + reg, data);
 }
 
 /* -----------------------------------------------------------------------------
  * Controls
  */
 
-static int bru_s_ctrl(struct v4l2_ctrl *ctrl)
+static int brx_s_ctrl(struct v4l2_ctrl *ctrl)
 {
-	struct vsp1_bru *bru =
-		container_of(ctrl->handler, struct vsp1_bru, ctrls);
+	struct vsp1_brx *brx =
+		container_of(ctrl->handler, struct vsp1_brx, ctrls);
 
 	switch (ctrl->id) {
 	case V4L2_CID_BG_COLOR:
-		bru->bgcolor = ctrl->val;
+		brx->bgcolor = ctrl->val;
 		break;
 	}
 
 	return 0;
 }
 
-static const struct v4l2_ctrl_ops bru_ctrl_ops = {
-	.s_ctrl = bru_s_ctrl,
+static const struct v4l2_ctrl_ops brx_ctrl_ops = {
+	.s_ctrl = brx_s_ctrl,
 };
 
 /* -----------------------------------------------------------------------------
@@ -63,12 +63,12 @@ static const struct v4l2_ctrl_ops bru_ctrl_ops = {
  */
 
 /*
- * The BRU can't perform format conversion, all sink and source formats must be
+ * The BRx can't perform format conversion, all sink and source formats must be
  * identical. We pick the format on the first sink pad (pad 0) and propagate it
  * to all other pads.
  */
 
-static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
+static int brx_enum_mbus_code(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
@@ -81,7 +81,7 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 					  ARRAY_SIZE(codes));
 }
 
-static int bru_enum_frame_size(struct v4l2_subdev *subdev,
+static int brx_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
@@ -92,29 +92,29 @@ static int bru_enum_frame_size(struct v4l2_subdev *subdev,
 	    fse->code != MEDIA_BUS_FMT_AYUV8_1X32)
 		return -EINVAL;
 
-	fse->min_width = BRU_MIN_SIZE;
-	fse->max_width = BRU_MAX_SIZE;
-	fse->min_height = BRU_MIN_SIZE;
-	fse->max_height = BRU_MAX_SIZE;
+	fse->min_width = BRX_MIN_SIZE;
+	fse->max_width = BRX_MAX_SIZE;
+	fse->min_height = BRX_MIN_SIZE;
+	fse->max_height = BRX_MAX_SIZE;
 
 	return 0;
 }
 
-static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
+static struct v4l2_rect *brx_get_compose(struct vsp1_brx *brx,
 					 struct v4l2_subdev_pad_config *cfg,
 					 unsigned int pad)
 {
-	return v4l2_subdev_get_try_compose(&bru->entity.subdev, cfg, pad);
+	return v4l2_subdev_get_try_compose(&brx->entity.subdev, cfg, pad);
 }
 
-static void bru_try_format(struct vsp1_bru *bru,
+static void brx_try_format(struct vsp1_brx *brx,
 			   struct v4l2_subdev_pad_config *config,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 
 	switch (pad) {
-	case BRU_PAD_SINK(0):
+	case BRX_PAD_SINK(0):
 		/* Default to YUV if the requested format is not supported. */
 		if (fmt->code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
 		    fmt->code != MEDIA_BUS_FMT_AYUV8_1X32)
@@ -122,46 +122,46 @@ static void bru_try_format(struct vsp1_bru *bru,
 		break;
 
 	default:
-		/* The BRU can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&bru->entity, config,
-						    BRU_PAD_SINK(0));
+		/* The BRx can't perform format conversion. */
+		format = vsp1_entity_get_pad_format(&brx->entity, config,
+						    BRX_PAD_SINK(0));
 		fmt->code = format->code;
 		break;
 	}
 
-	fmt->width = clamp(fmt->width, BRU_MIN_SIZE, BRU_MAX_SIZE);
-	fmt->height = clamp(fmt->height, BRU_MIN_SIZE, BRU_MAX_SIZE);
+	fmt->width = clamp(fmt->width, BRX_MIN_SIZE, BRX_MAX_SIZE);
+	fmt->height = clamp(fmt->height, BRX_MIN_SIZE, BRX_MAX_SIZE);
 	fmt->field = V4L2_FIELD_NONE;
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int bru_set_format(struct v4l2_subdev *subdev,
+static int brx_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
-	struct vsp1_bru *bru = to_bru(subdev);
+	struct vsp1_brx *brx = to_brx(subdev);
 	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 	int ret = 0;
 
-	mutex_lock(&bru->entity.lock);
+	mutex_lock(&brx->entity.lock);
 
-	config = vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->which);
+	config = vsp1_entity_get_pad_config(&brx->entity, cfg, fmt->which);
 	if (!config) {
 		ret = -EINVAL;
 		goto done;
 	}
 
-	bru_try_format(bru, config, fmt->pad, &fmt->format);
+	brx_try_format(brx, config, fmt->pad, &fmt->format);
 
-	format = vsp1_entity_get_pad_format(&bru->entity, config, fmt->pad);
+	format = vsp1_entity_get_pad_format(&brx->entity, config, fmt->pad);
 	*format = fmt->format;
 
 	/* Reset the compose rectangle */
-	if (fmt->pad != bru->entity.source_pad) {
+	if (fmt->pad != brx->entity.source_pad) {
 		struct v4l2_rect *compose;
 
-		compose = bru_get_compose(bru, config, fmt->pad);
+		compose = brx_get_compose(brx, config, fmt->pad);
 		compose->left = 0;
 		compose->top = 0;
 		compose->width = format->width;
@@ -169,48 +169,48 @@ static int bru_set_format(struct v4l2_subdev *subdev,
 	}
 
 	/* Propagate the format code to all pads */
-	if (fmt->pad == BRU_PAD_SINK(0)) {
+	if (fmt->pad == BRX_PAD_SINK(0)) {
 		unsigned int i;
 
-		for (i = 0; i <= bru->entity.source_pad; ++i) {
-			format = vsp1_entity_get_pad_format(&bru->entity,
+		for (i = 0; i <= brx->entity.source_pad; ++i) {
+			format = vsp1_entity_get_pad_format(&brx->entity,
 							    config, i);
 			format->code = fmt->format.code;
 		}
 	}
 
 done:
-	mutex_unlock(&bru->entity.lock);
+	mutex_unlock(&brx->entity.lock);
 	return ret;
 }
 
-static int bru_get_selection(struct v4l2_subdev *subdev,
+static int brx_get_selection(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel)
 {
-	struct vsp1_bru *bru = to_bru(subdev);
+	struct vsp1_brx *brx = to_brx(subdev);
 	struct v4l2_subdev_pad_config *config;
 
-	if (sel->pad == bru->entity.source_pad)
+	if (sel->pad == brx->entity.source_pad)
 		return -EINVAL;
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
 		sel->r.left = 0;
 		sel->r.top = 0;
-		sel->r.width = BRU_MAX_SIZE;
-		sel->r.height = BRU_MAX_SIZE;
+		sel->r.width = BRX_MAX_SIZE;
+		sel->r.height = BRX_MAX_SIZE;
 		return 0;
 
 	case V4L2_SEL_TGT_COMPOSE:
-		config = vsp1_entity_get_pad_config(&bru->entity, cfg,
+		config = vsp1_entity_get_pad_config(&brx->entity, cfg,
 						    sel->which);
 		if (!config)
 			return -EINVAL;
 
-		mutex_lock(&bru->entity.lock);
-		sel->r = *bru_get_compose(bru, config, sel->pad);
-		mutex_unlock(&bru->entity.lock);
+		mutex_lock(&brx->entity.lock);
+		sel->r = *brx_get_compose(brx, config, sel->pad);
+		mutex_unlock(&brx->entity.lock);
 		return 0;
 
 	default:
@@ -218,25 +218,25 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 	}
 }
 
-static int bru_set_selection(struct v4l2_subdev *subdev,
+static int brx_set_selection(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel)
 {
-	struct vsp1_bru *bru = to_bru(subdev);
+	struct vsp1_brx *brx = to_brx(subdev);
 	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *compose;
 	int ret = 0;
 
-	if (sel->pad == bru->entity.source_pad)
+	if (sel->pad == brx->entity.source_pad)
 		return -EINVAL;
 
 	if (sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
-	mutex_lock(&bru->entity.lock);
+	mutex_lock(&brx->entity.lock);
 
-	config = vsp1_entity_get_pad_config(&bru->entity, cfg, sel->which);
+	config = vsp1_entity_get_pad_config(&brx->entity, cfg, sel->which);
 	if (!config) {
 		ret = -EINVAL;
 		goto done;
@@ -246,8 +246,8 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	 * The compose rectangle top left corner must be inside the output
 	 * frame.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, config,
-					    bru->entity.source_pad);
+	format = vsp1_entity_get_pad_format(&brx->entity, config,
+					    brx->entity.source_pad);
 	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
 	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
 
@@ -255,42 +255,42 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	 * Scaling isn't supported, the compose rectangle size must be identical
 	 * to the sink format size.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, config, sel->pad);
+	format = vsp1_entity_get_pad_format(&brx->entity, config, sel->pad);
 	sel->r.width = format->width;
 	sel->r.height = format->height;
 
-	compose = bru_get_compose(bru, config, sel->pad);
+	compose = brx_get_compose(brx, config, sel->pad);
 	*compose = sel->r;
 
 done:
-	mutex_unlock(&bru->entity.lock);
+	mutex_unlock(&brx->entity.lock);
 	return ret;
 }
 
-static const struct v4l2_subdev_pad_ops bru_pad_ops = {
+static const struct v4l2_subdev_pad_ops brx_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
-	.enum_mbus_code = bru_enum_mbus_code,
-	.enum_frame_size = bru_enum_frame_size,
+	.enum_mbus_code = brx_enum_mbus_code,
+	.enum_frame_size = brx_enum_frame_size,
 	.get_fmt = vsp1_subdev_get_pad_format,
-	.set_fmt = bru_set_format,
-	.get_selection = bru_get_selection,
-	.set_selection = bru_set_selection,
+	.set_fmt = brx_set_format,
+	.get_selection = brx_get_selection,
+	.set_selection = brx_set_selection,
 };
 
-static const struct v4l2_subdev_ops bru_ops = {
-	.pad    = &bru_pad_ops,
+static const struct v4l2_subdev_ops brx_ops = {
+	.pad    = &brx_pad_ops,
 };
 
 /* -----------------------------------------------------------------------------
  * VSP1 Entity Operations
  */
 
-static void bru_configure(struct vsp1_entity *entity,
+static void brx_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
 			  enum vsp1_entity_params params)
 {
-	struct vsp1_bru *bru = to_bru(&entity->subdev);
+	struct vsp1_brx *brx = to_brx(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
@@ -298,8 +298,8 @@ static void bru_configure(struct vsp1_entity *entity,
 	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
-	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
-					    bru->entity.source_pad);
+	format = vsp1_entity_get_pad_format(&brx->entity, brx->entity.config,
+					    brx->entity.source_pad);
 
 	/*
 	 * The hardware is extremely flexible but we have no userspace API to
@@ -313,7 +313,7 @@ static void bru_configure(struct vsp1_entity *entity,
 	 * format at the pipeline output is premultiplied.
 	 */
 	flags = pipe->output ? pipe->output->format.flags : 0;
-	vsp1_bru_write(bru, dl, VI6_BRU_INCTRL,
+	vsp1_brx_write(brx, dl, VI6_BRU_INCTRL,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
@@ -321,12 +321,12 @@ static void bru_configure(struct vsp1_entity *entity,
 	 * Set the background position to cover the whole output image and
 	 * configure its color.
 	 */
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_SIZE,
+	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_LOC, 0);
+	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_LOC, 0);
 
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_COL, bru->bgcolor |
+	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_COL, brx->bgcolor |
 		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
 
 	/*
@@ -336,25 +336,25 @@ static void bru_configure(struct vsp1_entity *entity,
 	 * unit.
 	 */
 	if (entity->type == VSP1_ENTITY_BRU)
-		vsp1_bru_write(bru, dl, VI6_BRU_ROP,
+		vsp1_brx_write(brx, dl, VI6_BRU_ROP,
 			       VI6_BRU_ROP_DSTSEL_BRUIN(1) |
 			       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
 			       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
 
-	for (i = 0; i < bru->entity.source_pad; ++i) {
+	for (i = 0; i < brx->entity.source_pad; ++i) {
 		bool premultiplied = false;
 		u32 ctrl = 0;
 
 		/*
-		 * Configure all Blend/ROP units corresponding to an enabled BRU
+		 * Configure all Blend/ROP units corresponding to an enabled BRx
 		 * input for alpha blending. Blend/ROP units corresponding to
-		 * disabled BRU inputs are used in ROP NOP mode to ignore the
+		 * disabled BRx inputs are used in ROP NOP mode to ignore the
 		 * SRC input.
 		 */
-		if (bru->inputs[i].rpf) {
+		if (brx->inputs[i].rpf) {
 			ctrl |= VI6_BRU_CTRL_RBC;
 
-			premultiplied = bru->inputs[i].rpf->format.flags
+			premultiplied = brx->inputs[i].rpf->format.flags
 				      & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
 		} else {
 			ctrl |= VI6_BRU_CTRL_CROP(VI6_ROP_NOP)
@@ -378,7 +378,7 @@ static void bru_configure(struct vsp1_entity *entity,
 		if (!(entity->type == VSP1_ENTITY_BRU && i == 1))
 			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
 
-		vsp1_bru_write(bru, dl, VI6_BRU_CTRL(i), ctrl);
+		vsp1_brx_write(brx, dl, VI6_BRU_CTRL(i), ctrl);
 
 		/*
 		 * Harcode the blending formula to
@@ -393,7 +393,7 @@ static void bru_configure(struct vsp1_entity *entity,
 		 *
 		 * otherwise.
 		 */
-		vsp1_bru_write(bru, dl, VI6_BRU_BLD(i),
+		vsp1_brx_write(brx, dl, VI6_BRU_BLD(i),
 			       VI6_BRU_BLD_CCMDX_255_SRC_A |
 			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
 						VI6_BRU_BLD_CCMDY_SRC_A) |
@@ -403,29 +403,29 @@ static void bru_configure(struct vsp1_entity *entity,
 	}
 }
 
-static const struct vsp1_entity_operations bru_entity_ops = {
-	.configure = bru_configure,
+static const struct vsp1_entity_operations brx_entity_ops = {
+	.configure = brx_configure,
 };
 
 /* -----------------------------------------------------------------------------
  * Initialization and Cleanup
  */
 
-struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1,
+struct vsp1_brx *vsp1_brx_create(struct vsp1_device *vsp1,
 				 enum vsp1_entity_type type)
 {
-	struct vsp1_bru *bru;
+	struct vsp1_brx *brx;
 	unsigned int num_pads;
 	const char *name;
 	int ret;
 
-	bru = devm_kzalloc(vsp1->dev, sizeof(*bru), GFP_KERNEL);
-	if (bru == NULL)
+	brx = devm_kzalloc(vsp1->dev, sizeof(*brx), GFP_KERNEL);
+	if (brx == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	bru->base = type == VSP1_ENTITY_BRU ? VI6_BRU_BASE : VI6_BRS_BASE;
-	bru->entity.ops = &bru_entity_ops;
-	bru->entity.type = type;
+	brx->base = type == VSP1_ENTITY_BRU ? VI6_BRU_BASE : VI6_BRS_BASE;
+	brx->entity.ops = &brx_entity_ops;
+	brx->entity.type = type;
 
 	if (type == VSP1_ENTITY_BRU) {
 		num_pads = vsp1->info->num_bru_inputs + 1;
@@ -435,26 +435,26 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1,
 		name = "brs";
 	}
 
-	ret = vsp1_entity_init(vsp1, &bru->entity, name, num_pads, &bru_ops,
+	ret = vsp1_entity_init(vsp1, &brx->entity, name, num_pads, &brx_ops,
 			       MEDIA_ENT_F_PROC_VIDEO_COMPOSER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
 	/* Initialize the control handler. */
-	v4l2_ctrl_handler_init(&bru->ctrls, 1);
-	v4l2_ctrl_new_std(&bru->ctrls, &bru_ctrl_ops, V4L2_CID_BG_COLOR,
+	v4l2_ctrl_handler_init(&brx->ctrls, 1);
+	v4l2_ctrl_new_std(&brx->ctrls, &brx_ctrl_ops, V4L2_CID_BG_COLOR,
 			  0, 0xffffff, 1, 0);
 
-	bru->bgcolor = 0;
+	brx->bgcolor = 0;
 
-	bru->entity.subdev.ctrl_handler = &bru->ctrls;
+	brx->entity.subdev.ctrl_handler = &brx->ctrls;
 
-	if (bru->ctrls.error) {
+	if (brx->ctrls.error) {
 		dev_err(vsp1->dev, "%s: failed to initialize controls\n", name);
-		ret = bru->ctrls.error;
-		vsp1_entity_destroy(&bru->entity);
+		ret = brx->ctrls.error;
+		vsp1_entity_destroy(&brx->entity);
 		return ERR_PTR(ret);
 	}
 
-	return bru;
+	return brx;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_bru.h b/drivers/media/platform/vsp1/vsp1_brx.h
similarity index 66%
rename from drivers/media/platform/vsp1/vsp1_bru.h
rename to drivers/media/platform/vsp1/vsp1_brx.h
index c98ed96d8de6..927aa4254c0f 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.h
+++ b/drivers/media/platform/vsp1/vsp1_brx.h
@@ -1,5 +1,5 @@
 /*
- * vsp1_bru.h  --  R-Car VSP1 Blend ROP Unit
+ * vsp1_brx.h  --  R-Car VSP1 Blend ROP Unit (BRU and BRS)
  *
  * Copyright (C) 2013 Renesas Corporation
  *
@@ -10,8 +10,8 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-#ifndef __VSP1_BRU_H__
-#define __VSP1_BRU_H__
+#ifndef __VSP1_BRX_H__
+#define __VSP1_BRX_H__
 
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
@@ -22,9 +22,9 @@
 struct vsp1_device;
 struct vsp1_rwpf;
 
-#define BRU_PAD_SINK(n)				(n)
+#define BRX_PAD_SINK(n)				(n)
 
-struct vsp1_bru {
+struct vsp1_brx {
 	struct vsp1_entity entity;
 	unsigned int base;
 
@@ -37,12 +37,12 @@ struct vsp1_bru {
 	u32 bgcolor;
 };
 
-static inline struct vsp1_bru *to_bru(struct v4l2_subdev *subdev)
+static inline struct vsp1_brx *to_brx(struct v4l2_subdev *subdev)
 {
-	return container_of(subdev, struct vsp1_bru, entity.subdev);
+	return container_of(subdev, struct vsp1_brx, entity.subdev);
 }
 
-struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1,
+struct vsp1_brx *vsp1_brx_create(struct vsp1_device *vsp1,
 				 enum vsp1_entity_type type);
 
-#endif /* __VSP1_BRU_H__ */
+#endif /* __VSP1_BRX_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b43d6dc0d5f5..095dc48aa25a 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -20,14 +20,14 @@
 #include <media/vsp1.h>
 
 #include "vsp1.h"
-#include "vsp1_bru.h"
+#include "vsp1_brx.h"
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
 #include "vsp1_lif.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 
-#define BRU_NAME(e)	(e)->type == VSP1_ENTITY_BRU ? "BRU" : "BRS"
+#define BRX_NAME(e)	(e)->type == VSP1_ENTITY_BRU ? "BRU" : "BRS"
 
 /* -----------------------------------------------------------------------------
  * Interrupt Handling
@@ -43,7 +43,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
 		drm_pipe->du_complete(drm_pipe->du_private, complete);
 
 	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
-		drm_pipe->force_bru_release = false;
+		drm_pipe->force_brx_release = false;
 		wake_up(&drm_pipe->wait_queue);
 	}
 }
@@ -52,11 +52,11 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
  * Pipeline Configuration
  */
 
-/* Setup one RPF and the connected BRU sink pad. */
+/* Setup one RPF and the connected BRx sink pad. */
 static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 				      struct vsp1_pipeline *pipe,
 				      struct vsp1_rwpf *rpf,
-				      unsigned int bru_input)
+				      unsigned int brx_input)
 {
 	struct v4l2_subdev_selection sel;
 	struct v4l2_subdev_format format;
@@ -65,7 +65,7 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 
 	/*
 	 * Configure the format on the RPF sink pad and propagate it up to the
-	 * BRU sink pad.
+	 * BRx sink pad.
 	 */
 	crop = &vsp1->drm->inputs[rpf->entity.index].crop;
 
@@ -126,114 +126,114 @@ static int vsp1_du_pipeline_setup_rpf(struct vsp1_device *vsp1,
 	if (ret < 0)
 		return ret;
 
-	/* BRU sink, propagate the format from the RPF source. */
-	format.pad = bru_input;
+	/* BRx sink, propagate the format from the RPF source. */
+	format.pad = brx_input;
 
-	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
+	ret = v4l2_subdev_call(&pipe->brx->subdev, pad, set_fmt, NULL,
 			       &format);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
 		__func__, format.format.width, format.format.height,
-		format.format.code, BRU_NAME(pipe->bru), format.pad);
+		format.format.code, BRX_NAME(pipe->brx), format.pad);
 
-	sel.pad = bru_input;
+	sel.pad = brx_input;
 	sel.target = V4L2_SEL_TGT_COMPOSE;
 	sel.r = vsp1->drm->inputs[rpf->entity.index].compose;
 
-	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_selection, NULL,
+	ret = v4l2_subdev_call(&pipe->brx->subdev, pad, set_selection, NULL,
 			       &sel);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(vsp1->dev, "%s: set selection (%u,%u)/%ux%u on %s pad %u\n",
 		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
-		BRU_NAME(pipe->bru), sel.pad);
+		BRX_NAME(pipe->brx), sel.pad);
 
 	return 0;
 }
 
-/* Setup the BRU source pad. */
+/* Setup the BRx source pad. */
 static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 					 struct vsp1_pipeline *pipe);
 static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe);
 
-static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
+static int vsp1_du_pipeline_setup_brx(struct vsp1_device *vsp1,
 				      struct vsp1_pipeline *pipe)
 {
 	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
 	struct v4l2_subdev_format format = {
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 	};
-	struct vsp1_entity *bru;
+	struct vsp1_entity *brx;
 	int ret;
 
 	/*
-	 * Pick a BRU:
-	 * - If we need more than two inputs, use the main BRU.
-	 * - Otherwise, if we are not forced to release our BRU, keep it.
-	 * - Else, use any free BRU (randomly starting with the main BRU).
+	 * Pick a BRx:
+	 * - If we need more than two inputs, use the BRU.
+	 * - Otherwise, if we are not forced to release our BRx, keep it.
+	 * - Else, use any free BRx (randomly starting with the BRU).
 	 */
 	if (pipe->num_inputs > 2)
-		bru = &vsp1->bru->entity;
-	else if (pipe->bru && !drm_pipe->force_bru_release)
-		bru = pipe->bru;
+		brx = &vsp1->bru->entity;
+	else if (pipe->brx && !drm_pipe->force_brx_release)
+		brx = pipe->brx;
 	else if (!vsp1->bru->entity.pipe)
-		bru = &vsp1->bru->entity;
+		brx = &vsp1->bru->entity;
 	else
-		bru = &vsp1->brs->entity;
+		brx = &vsp1->brs->entity;
 
-	/* Switch BRU if needed. */
-	if (bru != pipe->bru) {
-		struct vsp1_entity *released_bru = NULL;
+	/* Switch BRx if needed. */
+	if (brx != pipe->brx) {
+		struct vsp1_entity *released_brx = NULL;
 
-		/* Release our BRU if we have one. */
-		if (pipe->bru) {
+		/* Release our BRx if we have one. */
+		if (pipe->brx) {
 			dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
 				__func__, pipe->lif->index,
-				BRU_NAME(pipe->bru));
+				BRX_NAME(pipe->brx));
 
 			/*
-			 * The BRU might be acquired by the other pipeline in
+			 * The BRx might be acquired by the other pipeline in
 			 * the next step. We must thus remove it from the list
 			 * of entities for this pipeline. The other pipeline's
-			 * hardware configuration will reconfigure the BRU
+			 * hardware configuration will reconfigure the BRx
 			 * routing.
 			 *
 			 * However, if the other pipeline doesn't acquire our
-			 * BRU, we need to keep it in the list, otherwise the
+			 * BRx, we need to keep it in the list, otherwise the
 			 * hardware configuration step won't disconnect it from
-			 * the pipeline. To solve this, store the released BRU
+			 * the pipeline. To solve this, store the released BRx
 			 * pointer to add it back to the list of entities later
 			 * if it isn't acquired by the other pipeline.
 			 */
-			released_bru = pipe->bru;
+			released_brx = pipe->brx;
 
-			list_del(&pipe->bru->list_pipe);
-			pipe->bru->sink = NULL;
-			pipe->bru->pipe = NULL;
-			pipe->bru = NULL;
+			list_del(&pipe->brx->list_pipe);
+			pipe->brx->sink = NULL;
+			pipe->brx->pipe = NULL;
+			pipe->brx = NULL;
 		}
 
 		/*
-		 * If the BRU we need is in use, force the owner pipeline to
-		 * switch to the other BRU and wait until the switch completes.
+		 * If the BRx we need is in use, force the owner pipeline to
+		 * switch to the other BRx and wait until the switch completes.
 		 */
-		if (bru->pipe) {
+		if (brx->pipe) {
 			struct vsp1_drm_pipeline *owner_pipe;
 
 			dev_dbg(vsp1->dev, "%s: pipe %u: waiting for %s\n",
-				__func__, pipe->lif->index, BRU_NAME(bru));
+				__func__, pipe->lif->index, BRX_NAME(brx));
 
-			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
-			owner_pipe->force_bru_release = true;
+			owner_pipe = to_vsp1_drm_pipeline(brx->pipe);
+			owner_pipe->force_brx_release = true;
 
 			vsp1_du_pipeline_setup_inputs(vsp1, &owner_pipe->pipe);
 			vsp1_du_pipeline_configure(&owner_pipe->pipe);
 
 			ret = wait_event_timeout(owner_pipe->wait_queue,
-						 !owner_pipe->force_bru_release,
+						 !owner_pipe->force_brx_release,
 						 msecs_to_jiffies(500));
 			if (ret == 0)
 				dev_warn(vsp1->dev,
@@ -242,46 +242,46 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
 		}
 
 		/*
-		 * If the BRU we have released previously hasn't been acquired
+		 * If the BRx we have released previously hasn't been acquired
 		 * by the other pipeline, add it back to the entities list (with
 		 * the pipe pointer NULL) to let vsp1_du_pipeline_configure()
 		 * disconnect it from the hardware pipeline.
 		 */
-		if (released_bru && !released_bru->pipe)
-			list_add_tail(&released_bru->list_pipe,
+		if (released_brx && !released_brx->pipe)
+			list_add_tail(&released_brx->list_pipe,
 				      &pipe->entities);
 
-		/* Add the BRU to the pipeline. */
+		/* Add the BRx to the pipeline. */
 		dev_dbg(vsp1->dev, "%s: pipe %u: acquired %s\n",
-			__func__, pipe->lif->index, BRU_NAME(bru));
+			__func__, pipe->lif->index, BRX_NAME(brx));
 
-		pipe->bru = bru;
-		pipe->bru->pipe = pipe;
-		pipe->bru->sink = &pipe->output->entity;
-		pipe->bru->sink_pad = 0;
+		pipe->brx = brx;
+		pipe->brx->pipe = pipe;
+		pipe->brx->sink = &pipe->output->entity;
+		pipe->brx->sink_pad = 0;
 
-		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
+		list_add_tail(&pipe->brx->list_pipe, &pipe->entities);
 	}
 
 	/*
-	 * Configure the format on the BRU source and verify that it matches the
+	 * Configure the format on the BRx source and verify that it matches the
 	 * requested format. We don't set the media bus code as it is configured
-	 * on the BRU sink pad 0 and propagated inside the entity, not on the
+	 * on the BRx sink pad 0 and propagated inside the entity, not on the
 	 * source pad.
 	 */
-	format.pad = pipe->bru->source_pad;
+	format.pad = pipe->brx->source_pad;
 	format.format.width = drm_pipe->width;
 	format.format.height = drm_pipe->height;
 	format.format.field = V4L2_FIELD_NONE;
 
-	ret = v4l2_subdev_call(&pipe->bru->subdev, pad, set_fmt, NULL,
+	ret = v4l2_subdev_call(&pipe->brx->subdev, pad, set_fmt, NULL,
 			       &format);
 	if (ret < 0)
 		return ret;
 
 	dev_dbg(vsp1->dev, "%s: set format %ux%u (%x) on %s pad %u\n",
 		__func__, format.format.width, format.format.height,
-		format.format.code, BRU_NAME(pipe->bru), pipe->bru->source_pad);
+		format.format.code, BRX_NAME(pipe->brx), pipe->brx->source_pad);
 
 	if (format.format.width != drm_pipe->width ||
 	    format.format.height != drm_pipe->height) {
@@ -297,12 +297,12 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
 	return vsp1->drm->inputs[rpf->entity.index].zpos;
 }
 
-/* Setup the input side of the pipeline (RPFs and BRU). */
+/* Setup the input side of the pipeline (RPFs and BRx). */
 static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
-					 struct vsp1_pipeline *pipe)
+					struct vsp1_pipeline *pipe)
 {
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF] = { NULL, };
-	struct vsp1_bru *bru;
+	struct vsp1_brx *brx;
 	unsigned int i;
 	int ret;
 
@@ -327,25 +327,25 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 	}
 
 	/*
-	 * Setup the BRU. This must be done before setting up the RPF input
-	 * pipelines as the BRU sink compose rectangles depend on the BRU source
+	 * Setup the BRx. This must be done before setting up the RPF input
+	 * pipelines as the BRx sink compose rectangles depend on the BRx source
 	 * format.
 	 */
-	ret = vsp1_du_pipeline_setup_bru(vsp1, pipe);
+	ret = vsp1_du_pipeline_setup_brx(vsp1, pipe);
 	if (ret < 0) {
 		dev_err(vsp1->dev, "%s: failed to setup %s source\n", __func__,
-			BRU_NAME(pipe->bru));
+			BRX_NAME(pipe->brx));
 		return ret;
 	}
 
-	bru = to_bru(&pipe->bru->subdev);
+	brx = to_brx(&pipe->brx->subdev);
 
 	/* Setup the RPF input pipeline for every enabled input. */
-	for (i = 0; i < pipe->bru->source_pad; ++i) {
+	for (i = 0; i < pipe->brx->source_pad; ++i) {
 		struct vsp1_rwpf *rpf = inputs[i];
 
 		if (!rpf) {
-			bru->inputs[i].rpf = NULL;
+			brx->inputs[i].rpf = NULL;
 			continue;
 		}
 
@@ -354,13 +354,13 @@ static int vsp1_du_pipeline_setup_inputs(struct vsp1_device *vsp1,
 			list_add_tail(&rpf->entity.list_pipe, &pipe->entities);
 		}
 
-		bru->inputs[i].rpf = rpf;
-		rpf->bru_input = i;
-		rpf->entity.sink = pipe->bru;
+		brx->inputs[i].rpf = rpf;
+		rpf->brx_input = i;
+		rpf->entity.sink = pipe->brx;
 		rpf->entity.sink_pad = i;
 
 		dev_dbg(vsp1->dev, "%s: connecting RPF.%u to %s:%u\n",
-			__func__, rpf->entity.index, BRU_NAME(pipe->bru), i);
+			__func__, rpf->entity.index, BRX_NAME(pipe->brx), i);
 
 		ret = vsp1_du_pipeline_setup_rpf(vsp1, pipe, rpf, i);
 		if (ret < 0) {
@@ -467,7 +467,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 		}
 	}
 
-	vsp1_dl_list_commit(dl, drm_pipe->force_bru_release);
+	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
 }
 
 /* -----------------------------------------------------------------------------
@@ -492,8 +492,8 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
  * @cfg: the LIF configuration
  *
  * Configure the output part of VSP DRM pipeline for the given frame @cfg.width
- * and @cfg.height. This sets up formats on the blend unit (BRU or BRS) source
- * pad, the WPF sink and source pads, and the LIF sink pad.
+ * and @cfg.height. This sets up formats on the BRx source pad, the WPF sink and
+ * source pads, and the LIF sink pad.
  *
  * The @pipe_index argument selects which DRM pipeline to setup. The number of
  * available pipelines depend on the VSP instance.
@@ -523,11 +523,11 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 	pipe = &drm_pipe->pipe;
 
 	if (!cfg) {
-		struct vsp1_bru *bru;
+		struct vsp1_brx *brx;
 
 		mutex_lock(&vsp1->drm->lock);
 
-		bru = to_bru(&pipe->bru->subdev);
+		brx = to_brx(&pipe->brx->subdev);
 
 		/*
 		 * NULL configuration means the CRTC is being disabled, stop
@@ -544,7 +544,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 				continue;
 
 			/*
-			 * Remove the RPF from the pipe and the list of BRU
+			 * Remove the RPF from the pipe and the list of BRx
 			 * inputs.
 			 */
 			WARN_ON(!rpf->entity.pipe);
@@ -552,7 +552,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 			list_del(&rpf->entity.list_pipe);
 			pipe->inputs[i] = NULL;
 
-			bru->inputs[rpf->bru_input].rpf = NULL;
+			brx->inputs[rpf->brx_input].rpf = NULL;
 		}
 
 		drm_pipe->du_complete = NULL;
@@ -560,11 +560,11 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 
 		dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
 			__func__, pipe->lif->index,
-			BRU_NAME(pipe->bru));
+			BRX_NAME(pipe->brx));
 
-		list_del(&pipe->bru->list_pipe);
-		pipe->bru->pipe = NULL;
-		pipe->bru = NULL;
+		list_del(&pipe->brx->list_pipe);
+		pipe->brx->pipe = NULL;
+		pipe->brx = NULL;
 
 		mutex_unlock(&vsp1->drm->lock);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index c84bc1c456c0..d738cc57f0e3 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -24,8 +24,8 @@
  * @pipe: the VSP1 pipeline used for display
  * @width: output display width
  * @height: output display height
- * @force_bru_release: when set, release the BRU during the next reconfiguration
- * @wait_queue: wait queue to wait for BRU release completion
+ * @force_brx_release: when set, release the BRx during the next reconfiguration
+ * @wait_queue: wait queue to wait for BRx release completion
  * @du_complete: frame completion callback for the DU driver (optional)
  * @du_private: data to be passed to the du_complete callback
  */
@@ -35,7 +35,7 @@ struct vsp1_drm_pipeline {
 	unsigned int width;
 	unsigned int height;
 
-	bool force_bru_release;
+	bool force_brx_release;
 	wait_queue_head_t wait_queue;
 
 	/* Frame synchronisation */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 58a7993f2306..f41cd70409db 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
-#include "vsp1_bru.h"
+#include "vsp1_brx.h"
 #include "vsp1_clu.h"
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
@@ -269,7 +269,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	/* Instantiate all the entities. */
 	if (vsp1->info->features & VSP1_HAS_BRS) {
-		vsp1->brs = vsp1_bru_create(vsp1, VSP1_ENTITY_BRS);
+		vsp1->brs = vsp1_brx_create(vsp1, VSP1_ENTITY_BRS);
 		if (IS_ERR(vsp1->brs)) {
 			ret = PTR_ERR(vsp1->brs);
 			goto done;
@@ -279,7 +279,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	if (vsp1->info->features & VSP1_HAS_BRU) {
-		vsp1->bru = vsp1_bru_create(vsp1, VSP1_ENTITY_BRU);
+		vsp1->bru = vsp1_brx_create(vsp1, VSP1_ENTITY_BRU);
 		if (IS_ERR(vsp1->bru)) {
 			ret = PTR_ERR(vsp1->bru);
 			goto done;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 1134f14ed4aa..3fc5ecfa35e8 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -20,7 +20,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
-#include "vsp1_bru.h"
+#include "vsp1_brx.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_hgo.h"
@@ -188,11 +188,11 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 	struct vsp1_entity *entity;
 	unsigned int i;
 
-	if (pipe->bru) {
-		struct vsp1_bru *bru = to_bru(&pipe->bru->subdev);
+	if (pipe->brx) {
+		struct vsp1_brx *brx = to_brx(&pipe->brx->subdev);
 
-		for (i = 0; i < ARRAY_SIZE(bru->inputs); ++i)
-			bru->inputs[i].rpf = NULL;
+		for (i = 0; i < ARRAY_SIZE(brx->inputs); ++i)
+			brx->inputs[i].rpf = NULL;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(pipe->inputs); ++i)
@@ -207,7 +207,7 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
 	pipe->num_inputs = 0;
-	pipe->bru = NULL;
+	pipe->brx = NULL;
 	pipe->hgo = NULL;
 	pipe->hgt = NULL;
 	pipe->lif = NULL;
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 412da67527c0..07ccd6b810c5 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -99,7 +99,7 @@ struct vsp1_partition {
  * @num_inputs: number of RPFs
  * @inputs: array of RPFs in the pipeline (indexed by RPF index)
  * @output: WPF at the output of the pipeline
- * @bru: BRU entity, if present
+ * @brx: BRx entity, if present
  * @hgo: HGO entity, if present
  * @hgt: HGT entity, if present
  * @lif: LIF entity, if present
@@ -129,7 +129,7 @@ struct vsp1_pipeline {
 	unsigned int num_inputs;
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
 	struct vsp1_rwpf *output;
-	struct vsp1_entity *bru;
+	struct vsp1_entity *brx;
 	struct vsp1_entity *hgo;
 	struct vsp1_entity *hgt;
 	struct vsp1_entity *lif;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index fe0633da5a5f..7e74c2015070 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -167,12 +167,12 @@ static void rpf_configure(struct vsp1_entity *entity,
 	vsp1_rpf_write(rpf, dl, VI6_RPF_DSWAP, fmtinfo->swap);
 
 	/* Output location */
-	if (pipe->bru) {
+	if (pipe->brx) {
 		const struct v4l2_rect *compose;
 
-		compose = vsp1_entity_get_pad_selection(pipe->bru,
-							pipe->bru->config,
-							rpf->bru_input,
+		compose = vsp1_entity_get_pad_selection(pipe->brx,
+							pipe->brx->config,
+							rpf->brx_input,
 							V4L2_SEL_TGT_COMPOSE);
 		left = compose->left;
 		top = compose->top;
@@ -191,10 +191,10 @@ static void rpf_configure(struct vsp1_entity *entity,
 	 * alpha channel by a fixed global alpha value, and multiply the pixel
 	 * components to convert the input to premultiplied alpha.
 	 *
-	 * As alpha premultiplication is available in the BRU for both Gen2 and
+	 * As alpha premultiplication is available in the BRx for both Gen2 and
 	 * Gen3 we handle it there and use the Gen3 alpha multiplier for global
 	 * alpha multiplication only. This however prevents conversion to
-	 * premultiplied alpha if no BRU is present in the pipeline. If that use
+	 * premultiplied alpha if no BRx is present in the pipeline. If that use
 	 * case turns out to be useful we will revisit the implementation (for
 	 * Gen3 only).
 	 *
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index c94ac89abfa7..915aeadb21dd 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -45,7 +45,7 @@ struct vsp1_rwpf {
 
 	struct v4l2_pix_format_mplane format;
 	const struct vsp1_format_info *fmtinfo;
-	unsigned int bru_input;
+	unsigned int brx_input;
 
 	unsigned int alpha;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a76a44698aff..2b1c94ffc6f5 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -28,7 +28,7 @@
 #include <media/videobuf2-dma-contig.h>
 
 #include "vsp1.h"
-#include "vsp1_bru.h"
+#include "vsp1_brx.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_hgo.h"
@@ -488,7 +488,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 	struct media_entity_enum ent_enum;
 	struct vsp1_entity *entity;
 	struct media_pad *pad;
-	struct vsp1_bru *bru = NULL;
+	struct vsp1_brx *brx = NULL;
 	int ret;
 
 	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1->media_dev);
@@ -524,14 +524,14 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 		if (entity->type == VSP1_ENTITY_BRU ||
 		    entity->type == VSP1_ENTITY_BRS) {
 			/* BRU and BRS can't be chained. */
-			if (bru) {
+			if (brx) {
 				ret = -EPIPE;
 				goto out;
 			}
 
-			bru = to_bru(&entity->subdev);
-			bru->inputs[pad->index].rpf = input;
-			input->bru_input = pad->index;
+			brx = to_brx(&entity->subdev);
+			brx->inputs[pad->index].rpf = input;
+			input->brx_input = pad->index;
 		}
 
 		/* We've reached the WPF, we're done. */
@@ -553,7 +553,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 			}
 
 			pipe->uds = entity;
-			pipe->uds_input = bru ? &bru->entity : &input->entity;
+			pipe->uds_input = brx ? &brx->entity : &input->entity;
 		}
 
 		/* Follow the source link, ignoring any HGO or HGT. */
@@ -619,7 +619,7 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 
 		case VSP1_ENTITY_BRU:
 		case VSP1_ENTITY_BRS:
-			pipe->bru = e;
+			pipe->brx = e;
 			break;
 
 		case VSP1_ENTITY_HGO:
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index f7f3b4b2c2de..76f2686e292f 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -436,7 +436,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
 
 	/*
-	 * Sources. If the pipeline has a single input and BRU is not used,
+	 * Sources. If the pipeline has a single input and BRx is not used,
 	 * configure it as the master layer. Otherwise configure all
 	 * inputs as sub-layers and select the virtual RPF as the master
 	 * layer.
@@ -447,13 +447,13 @@ static void wpf_configure(struct vsp1_entity *entity,
 		if (!input)
 			continue;
 
-		srcrpf |= (!pipe->bru && pipe->num_inputs == 1)
+		srcrpf |= (!pipe->brx && pipe->num_inputs == 1)
 			? VI6_WPF_SRCRPF_RPF_ACT_MST(input->entity.index)
 			: VI6_WPF_SRCRPF_RPF_ACT_SUB(input->entity.index);
 	}
 
-	if (pipe->bru || pipe->num_inputs > 1)
-		srcrpf |= pipe->bru->type == VSP1_ENTITY_BRU
+	if (pipe->brx || pipe->num_inputs > 1)
+		srcrpf |= pipe->brx->type == VSP1_ENTITY_BRU
 			? VI6_WPF_SRCRPF_VIRACT_MST
 			: VI6_WPF_SRCRPF_VIRACT2_MST;
 
-- 
Regards,

Laurent Pinchart
