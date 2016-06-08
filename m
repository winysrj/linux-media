Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:43859 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbcFHX6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 19:58:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/5] v4l: vsp1: Add Cubic Look Up Table (CLU) support
Date: Thu,  9 Jun 2016 02:58:16 +0300
Message-Id: <1465430296-22644-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1465430296-22644-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CLU processing block is a 2D/3D lookup table that converts the input
three color component data into desired three color components using a
lookup table.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_clu.c    | 276 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h    |  44 +++++
 drivers/media/platform/vsp1/vsp1_drv.c    |  25 ++-
 drivers/media/platform/vsp1/vsp1_entity.c |   1 +
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h   |   9 +
 8 files changed, 354 insertions(+), 7 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index a12356bf2135..8ab6a063569e 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,7 +1,7 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_pipe.o
 vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
-vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
+vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
 vsp1-y					+= vsp1_hgo.o vsp1_histo.o
 vsp1-y					+= vsp1_lif.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 6bf6d54c0ae4..f5e58cea36cc 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -31,6 +31,7 @@ struct vsp1_drm;
 struct vsp1_entity;
 struct vsp1_platform_data;
 struct vsp1_bru;
+struct vsp1_clu;
 struct vsp1_hgo;
 struct vsp1_hsit;
 struct vsp1_lif;
@@ -48,6 +49,7 @@ struct vsp1_uds;
 #define VSP1_HAS_SRU		(1 << 2)
 #define VSP1_HAS_BRU		(1 << 3)
 #define VSP1_HAS_HGO		(1 << 4)
+#define VSP1_HAS_CLU		(1 << 5)
 
 struct vsp1_device_info {
 	u32 version;
@@ -68,6 +70,7 @@ struct vsp1_device {
 	struct rcar_fcp_device *fcp;
 
 	struct vsp1_bru *bru;
+	struct vsp1_clu *clu;
 	struct vsp1_hgo *hgo;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
new file mode 100644
index 000000000000..5f56b3f14495
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -0,0 +1,276 @@
+/*
+ * vsp1_clu.c  --  R-Car VSP1 Cubic Look-Up Table
+ *
+ * Copyright (C) 2015-2016 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_clu.h"
+#include "vsp1_dl.h"
+
+#define CLU_MIN_SIZE				4U
+#define CLU_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline void vsp1_clu_write(struct vsp1_clu *clu, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
+{
+	vsp1_dl_list_write(dl, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+#define V4L2_CID_VSP1_CLU_TABLE			(V4L2_CID_USER_BASE + 1)
+#define V4L2_CID_VSP1_CLU_MODE			(V4L2_CID_USER_BASE + 2)
+#define V4L2_CID_VSP1_CLU_MODE_2D		0
+#define V4L2_CID_VSP1_CLU_MODE_3D		1
+
+static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_dl_body *dlb;
+	unsigned int i;
+
+	dlb = vsp1_dl_fragment_alloc(clu->entity.vsp1, 1 + 17 * 17 * 17);
+	if (!dlb)
+		return -ENOMEM;
+
+	vsp1_dl_fragment_write(dlb, VI6_CLU_ADDR, 0);
+	for (i = 0; i < 17 * 17 * 17; ++i)
+		vsp1_dl_fragment_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
+
+	swap(clu->clu, dlb);
+
+	vsp1_dl_fragment_free(dlb);
+	return 0;
+}
+
+static int clu_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_clu *clu =
+		container_of(ctrl->handler, struct vsp1_clu, ctrls);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VSP1_CLU_TABLE:
+		clu_set_table(clu, ctrl);
+		break;
+
+	case V4L2_CID_VSP1_CLU_MODE:
+		clu->mode = ctrl->val;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops clu_ctrl_ops = {
+	.s_ctrl = clu_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config clu_table_control = {
+	.ops = &clu_ctrl_ops,
+	.id = V4L2_CID_VSP1_CLU_TABLE,
+	.name = "Look-Up Table",
+	.type = V4L2_CTRL_TYPE_U32,
+	.min = 0x00000000,
+	.max = 0x00ffffff,
+	.step = 1,
+	.def = 0,
+	.dims = { 17, 17, 17 },
+};
+
+static const char * const clu_mode_menu[] = {
+	"2D",
+	"3D",
+	NULL,
+};
+
+static const struct v4l2_ctrl_config clu_mode_control = {
+	.ops = &clu_ctrl_ops,
+	.id = V4L2_CID_VSP1_CLU_MODE,
+	.name = "Mode",
+	.type = V4L2_CTRL_TYPE_MENU,
+	.min = 0,
+	.max = 1,
+	.def = 1,
+	.qmenu = clu_mode_menu,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int clu_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AHSV8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
+	};
+
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
+}
+
+static int clu_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, CLU_MIN_SIZE,
+					   CLU_MIN_SIZE, CLU_MAX_SIZE,
+					   CLU_MAX_SIZE);
+}
+
+static int clu_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+
+	config = vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&clu->entity, config, fmt->pad);
+
+	if (fmt->pad == CLU_PAD_SOURCE) {
+		/* The CLU output format can't be modified. */
+		fmt->format = *format;
+		return 0;
+	}
+
+	format->code = fmt->format.code;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				CLU_MIN_SIZE, CLU_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 CLU_MIN_SIZE, CLU_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&clu->entity, config,
+					    CLU_PAD_SOURCE);
+	*format = fmt->format;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_pad_ops clu_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = clu_enum_mbus_code,
+	.enum_frame_size = clu_enum_frame_size,
+	.get_fmt = vsp1_subdev_get_pad_format,
+	.set_fmt = clu_set_format,
+};
+
+static struct v4l2_subdev_ops clu_ops = {
+	.pad    = &clu_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void clu_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
+{
+	struct vsp1_clu *clu = to_clu(&entity->subdev);
+	struct v4l2_mbus_framefmt *format;
+	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
+
+	format = vsp1_entity_get_pad_format(&clu->entity, clu->entity.config,
+					    CLU_PAD_SINK);
+
+	mutex_lock(clu->ctrls.lock);
+
+	/* 2D mode can only be used with the YCbCr pixel encoding. */
+	if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D &&
+	    format->code == MEDIA_BUS_FMT_AYUV8_1X32)
+		ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
+		     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
+		     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
+
+	if (clu->clu) {
+		vsp1_dl_list_add_fragment(dl, clu->clu);
+		clu->clu = NULL;
+	}
+
+	mutex_unlock(clu->ctrls.lock);
+
+	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+}
+
+static const struct vsp1_entity_operations clu_entity_ops = {
+	.configure = clu_configure,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
+{
+	struct vsp1_clu *clu;
+	int ret;
+
+	clu = devm_kzalloc(vsp1->dev, sizeof(*clu), GFP_KERNEL);
+	if (clu == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	clu->entity.ops = &clu_entity_ops;
+	clu->entity.type = VSP1_ENTITY_CLU;
+
+	ret = vsp1_entity_init(vsp1, &clu->entity, "clu", 2, &clu_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_LUT);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&clu->ctrls, 2);
+	v4l2_ctrl_new_custom(&clu->ctrls, &clu_table_control, NULL);
+	v4l2_ctrl_new_custom(&clu->ctrls, &clu_mode_control, NULL);
+
+	clu->entity.subdev.ctrl_handler = &clu->ctrls;
+
+	if (clu->ctrls.error) {
+		dev_err(vsp1->dev, "clu: failed to initialize controls\n");
+		ret = clu->ctrls.error;
+		vsp1_entity_destroy(&clu->entity);
+		return ERR_PTR(ret);
+	}
+
+	return clu;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
new file mode 100644
index 000000000000..33a69029c719
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -0,0 +1,44 @@
+/*
+ * vsp1_clu.h  --  R-Car VSP1 Cubic Look-Up Table
+ *
+ * Copyright (C) 2015 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_CLU_H__
+#define __VSP1_CLU_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+struct vsp1_dl_body;
+
+#define CLU_PAD_SINK				0
+#define CLU_PAD_SOURCE				1
+
+struct vsp1_clu {
+	struct vsp1_entity entity;
+
+	struct v4l2_ctrl_handler ctrls;
+
+	unsigned int mode;
+	struct vsp1_dl_body *clu;
+};
+
+static inline struct vsp1_clu *to_clu(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_clu, entity.subdev);
+}
+
+struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1);
+
+#endif /* __VSP1_CLU_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 7f7dc2e7d214..3613fb81c905 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -27,6 +27,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_clu.h"
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
 #include "vsp1_hgo.h"
@@ -263,6 +264,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
 	}
 
+	if (vsp1->info->features & VSP1_HAS_CLU) {
+		vsp1->clu = vsp1_clu_create(vsp1);
+		if (IS_ERR(vsp1->clu)) {
+			ret = PTR_ERR(vsp1->clu);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->clu->entity.list_dev, &vsp1->entities);
+	}
+
 	vsp1->hsi = vsp1_hsit_create(vsp1, true);
 	if (IS_ERR(vsp1->hsi)) {
 		ret = PTR_ERR(vsp1->hsi);
@@ -573,8 +584,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	{
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -602,8 +613,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 1,
 		.wpf_count = 4,
@@ -612,7 +623,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_HGO | VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_LUT
+			  | VSP1_HAS_SRU,
 		.rpf_count = 1,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -628,7 +640,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT,
 		.rpf_count = 5,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 6893f9d33941..a6b7d8755329 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -421,6 +421,7 @@ static const struct vsp1_route vsp1_routes[] = {
 	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
 	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
 	    VI6_DPR_NODE_BRU_IN(4) }, VI6_DPR_NODE_BRU_OUT },
+	VSP1_ENTITY_ROUTE(CLU),
 	{ VSP1_ENTITY_HGO, 0, 0, { 0, }, 0 },
 	VSP1_ENTITY_ROUTE(HSI),
 	VSP1_ENTITY_ROUTE(HST),
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 63e3990eb495..d2e55fda5f59 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -24,6 +24,7 @@ struct vsp1_pipeline;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
+	VSP1_ENTITY_CLU,
 	VSP1_ENTITY_HGO,
 	VSP1_ENTITY_HSI,
 	VSP1_ENTITY_HST,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 684a3eff3739..517a2a6606a3 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -444,6 +444,15 @@
  */
 
 #define VI6_CLU_CTRL			0x2900
+#define VI6_CLU_CTRL_AAI		(1 << 28)
+#define VI6_CLU_CTRL_MVS		(1 << 24)
+#define VI6_CLU_CTRL_AX1I_2D		(3 << 14)
+#define VI6_CLU_CTRL_AX2I_2D		(1 << 12)
+#define VI6_CLU_CTRL_OS0_2D		(3 << 8)
+#define VI6_CLU_CTRL_OS1_2D		(1 << 6)
+#define VI6_CLU_CTRL_OS2_2D		(3 << 4)
+#define VI6_CLU_CTRL_M2D		(1 << 1)
+#define VI6_CLU_CTRL_EN			(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * HST Control Registers
-- 
Regards,

Laurent Pinchart

