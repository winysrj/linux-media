Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3K2WvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:51:01 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 5/6] v4l: vsp1: Add SRU support
Date: Fri, 29 Nov 2013 23:50:51 +0100
Message-Id: <1385765452-25754-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Super Resolution Unit performs super resolution processing with
optional upscaling by a factor of two.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   3 +-
 drivers/media/platform/vsp1/vsp1.h        |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  11 +
 drivers/media/platform/vsp1/vsp1_entity.c |   4 +
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h   |  13 ++
 drivers/media/platform/vsp1/vsp1_sru.c    | 356 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_sru.h    |  41 ++++
 include/linux/platform_data/vsp1.h        |   1 +
 9 files changed, 431 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_sru.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 587b800..45621cb 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,5 +1,6 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
-vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_uds.o
+vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_sru.o
+vsp1-y					+= vsp1_uds.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 9ab0b74..84327fa 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -31,6 +31,7 @@ struct vsp1_platform_data;
 struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_rwpf;
+struct vsp1_sru;
 struct vsp1_uds;
 
 #define VPS1_MAX_RPF		5
@@ -52,6 +53,7 @@ struct vsp1_device {
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
 	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
+	struct vsp1_sru *sru;
 	struct vsp1_uds *uds[VPS1_MAX_UDS];
 	struct vsp1_rwpf *wpf[VPS1_MAX_WPF];
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index bdc32c8..9753074 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -23,6 +23,7 @@
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_rwpf.h"
+#include "vsp1_sru.h"
 #include "vsp1_uds.h"
 
 /* -----------------------------------------------------------------------------
@@ -192,6 +193,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&rpf->entity.list_dev, &vsp1->entities);
 	}
 
+	if (vsp1->pdata->features & VSP1_HAS_SRU) {
+		vsp1->sru = vsp1_sru_create(vsp1);
+		if (IS_ERR(vsp1->sru)) {
+			ret = PTR_ERR(vsp1->sru);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->sru->entity.list_dev, &vsp1->entities);
+	}
+
 	for (i = 0; i < vsp1->pdata->uds_count; ++i) {
 		struct vsp1_uds *uds;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 3798ef4..b11e5a6 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
@@ -130,6 +131,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
 		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE(3) },
 		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE(4) },
+		{ VI6_DPR_NODE_SRU, VI6_DPR_SRU_ROUTE },
 		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE(0) },
 		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE(1) },
 		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE(2) },
@@ -179,5 +181,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 void vsp1_entity_destroy(struct vsp1_entity *entity)
 {
+	if (entity->subdev.ctrl_handler)
+		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
 	media_entity_cleanup(&entity->subdev.entity);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 0d61746..08e4480 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -24,6 +24,7 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
 	VSP1_ENTITY_RPF,
+	VSP1_ENTITY_SRU,
 	VSP1_ENTITY_UDS,
 	VSP1_ENTITY_WPF,
 };
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 0b93f88..530cc61 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -336,8 +336,21 @@
  */
 
 #define VI6_SRU_CTRL0			0x2200
+#define VI6_SRU_CTRL0_PARAM0_SHIFT	16
+#define VI6_SRU_CTRL0_PARAM1_SHIFT	8
+#define VI6_SRU_CTRL0_MODE_UPSCALE	(4 << 4)
+#define VI6_SRU_CTRL0_PARAM2		(1 << 3)
+#define VI6_SRU_CTRL0_PARAM3		(1 << 2)
+#define VI6_SRU_CTRL0_PARAM4		(1 << 1)
+#define VI6_SRU_CTRL0_EN		(1 << 0)
+
 #define VI6_SRU_CTRL1			0x2204
+#define VI6_SRU_CTRL1_PARAM5		0x7ff
+
 #define VI6_SRU_CTRL2			0x2208
+#define VI6_SRU_CTRL2_PARAM6_SHIFT	16
+#define VI6_SRU_CTRL2_PARAM7_SHIFT	8
+#define VI6_SRU_CTRL2_PARAM8_SHIFT	0
 
 /* -----------------------------------------------------------------------------
  * UDS Control Registers
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
new file mode 100644
index 0000000..7ab1a0b
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -0,0 +1,356 @@
+/*
+ * vsp1_sru.c  --  R-Car VSP1 Super Resolution Unit
+ *
+ * Copyright (C) 2013 Renesas Corporation
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
+#include <linux/gfp.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_sru.h"
+
+#define SRU_MIN_SIZE				4U
+#define SRU_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_sru_read(struct vsp1_sru *sru, u32 reg)
+{
+	return vsp1_read(sru->entity.vsp1, reg);
+}
+
+static inline void vsp1_sru_write(struct vsp1_sru *sru, u32 reg, u32 data)
+{
+	vsp1_write(sru->entity.vsp1, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+#define V4L2_CID_VSP1_SRU_INTENSITY		(V4L2_CID_USER_BASE + 1)
+
+static int sru_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_sru *sru =
+		container_of(ctrl->handler, struct vsp1_sru, ctrls);
+
+	switch (ctrl->id) {
+	case V4L2_CID_VSP1_SRU_INTENSITY:
+		sru->intensity = ctrl->val;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops sru_ctrl_ops = {
+	.s_ctrl = sru_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config sru_intensity_control = {
+	.ops = &sru_ctrl_ops,
+	.id = V4L2_CID_VSP1_SRU_INTENSITY,
+	.name = "Intensity",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 1,
+	.max = 6,
+	.step = 1,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+struct vsp1_sru_param {
+	u32 ctrl0;
+	u32 ctrl2;
+};
+
+#define VI6_SRU_CTRL0_PARAMS(p0, p1)			\
+	(((p0) << VI6_SRU_CTRL0_PARAM0_SHIFT) |		\
+	 ((p1) << VI6_SRU_CTRL0_PARAM1_SHIFT))
+
+#define VI6_SRU_CTRL2_PARAMS(p6, p7, p8)		\
+	(((p6) << VI6_SRU_CTRL2_PARAM6_SHIFT) |		\
+	 ((p7) << VI6_SRU_CTRL2_PARAM7_SHIFT) |		\
+	 ((p8) << VI6_SRU_CTRL2_PARAM8_SHIFT))
+
+static const struct vsp1_sru_param vsp1_sru_params[] = {
+	{
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(256, 4) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(24, 40, 255),
+	}, {
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(256, 4) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(8, 16, 255),
+	}, {
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(384, 5) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(36, 60, 255),
+	}, {
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(384, 5) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(12, 27, 255),
+	}, {
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(511, 6) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(48, 80, 255),
+	}, {
+		.ctrl0 = VI6_SRU_CTRL0_PARAMS(511, 6) | VI6_SRU_CTRL0_EN,
+		.ctrl2 = VI6_SRU_CTRL2_PARAMS(16, 36, 255),
+	},
+};
+
+static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_sru *sru = to_sru(subdev);
+	const struct vsp1_sru_param *param;
+	struct v4l2_mbus_framefmt *input;
+	struct v4l2_mbus_framefmt *output;
+	bool upscale;
+	u32 ctrl0;
+
+	if (!enable)
+		return 0;
+
+	input = &sru->entity.formats[SRU_PAD_SINK];
+	output = &sru->entity.formats[SRU_PAD_SOURCE];
+	upscale = input->width != output->width;
+	param = &vsp1_sru_params[sru->intensity];
+
+	if (input->code == V4L2_MBUS_FMT_ARGB8888_1X32)
+		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
+		      | VI6_SRU_CTRL0_PARAM4;
+	else
+		ctrl0 = VI6_SRU_CTRL0_PARAM3;
+
+	vsp1_sru_write(sru, VI6_SRU_CTRL0, param->ctrl0 | ctrl0 |
+		       (upscale ? VI6_SRU_CTRL0_MODE_UPSCALE : 0));
+	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
+	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		V4L2_MBUS_FMT_ARGB8888_1X32,
+		V4L2_MBUS_FMT_AYUV8_1X32,
+	};
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == SRU_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(codes))
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		/* The SRU can't perform format conversion, the sink format is
+		 * always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		format = v4l2_subdev_get_try_format(fh, SRU_PAD_SINK);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int sru_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, SRU_PAD_SINK);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == SRU_PAD_SINK) {
+		fse->min_width = SRU_MIN_SIZE;
+		fse->max_width = SRU_MAX_SIZE;
+		fse->min_height = SRU_MIN_SIZE;
+		fse->max_height = SRU_MAX_SIZE;
+	} else {
+		fse->min_width = format->width;
+		fse->min_height = format->height;
+		if (format->width <= SRU_MAX_SIZE / 2 &&
+		    format->height <= SRU_MAX_SIZE / 2) {
+			fse->max_width = format->width * 2;
+			fse->max_height = format->height * 2;
+		} else {
+			fse->max_width = format->width;
+			fse->max_height = format->height;
+		}
+	}
+
+	return 0;
+}
+
+static int sru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_sru *sru = to_sru(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_fh *fh,
+			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+			   enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	unsigned int input_area;
+	unsigned int output_area;
+
+	switch (pad) {
+	case SRU_PAD_SINK:
+		/* Default to YUV if the requested format is not supported. */
+		if (fmt->code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
+		    fmt->code != V4L2_MBUS_FMT_AYUV8_1X32)
+			fmt->code = V4L2_MBUS_FMT_AYUV8_1X32;
+
+		fmt->width = clamp(fmt->width, SRU_MIN_SIZE, SRU_MAX_SIZE);
+		fmt->height = clamp(fmt->height, SRU_MIN_SIZE, SRU_MAX_SIZE);
+		break;
+
+	case SRU_PAD_SOURCE:
+		/* The SRU can't perform format conversion. */
+		format = vsp1_entity_get_pad_format(&sru->entity, fh,
+						    SRU_PAD_SINK, which);
+		fmt->code = format->code;
+
+		/* We can upscale by 2 in both direction, but not independently.
+		 * Compare the input and output rectangles areas (avoiding
+		 * integer overflows on the output): if the requested output
+		 * area is larger than 1.5^2 the input area upscale by two,
+		 * otherwise don't scale.
+		 */
+		input_area = format->width * format->height;
+		output_area = min(fmt->width, SRU_MAX_SIZE)
+			    * min(fmt->height, SRU_MAX_SIZE);
+
+		if (fmt->width <= SRU_MAX_SIZE / 2 &&
+		    fmt->height <= SRU_MAX_SIZE / 2 &&
+		    output_area > input_area * 9 / 4) {
+			fmt->width = format->width * 2;
+			fmt->height = format->height * 2;
+		} else {
+			fmt->width = format->width;
+			fmt->height = format->height;
+		}
+		break;
+	}
+
+	fmt->field = V4L2_FIELD_NONE;
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+}
+
+static int sru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_sru *sru = to_sru(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	sru_try_format(sru, fh, fmt->pad, &fmt->format, fmt->which);
+
+	format = vsp1_entity_get_pad_format(&sru->entity, fh, fmt->pad,
+					    fmt->which);
+	*format = fmt->format;
+
+	if (fmt->pad == SRU_PAD_SINK) {
+		/* Propagate the format to the source pad. */
+		format = vsp1_entity_get_pad_format(&sru->entity, fh,
+						    SRU_PAD_SOURCE, fmt->which);
+		*format = fmt->format;
+
+		sru_try_format(sru, fh, SRU_PAD_SOURCE, format, fmt->which);
+	}
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops sru_video_ops = {
+	.s_stream = sru_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops sru_pad_ops = {
+	.enum_mbus_code = sru_enum_mbus_code,
+	.enum_frame_size = sru_enum_frame_size,
+	.get_fmt = sru_get_format,
+	.set_fmt = sru_set_format,
+};
+
+static struct v4l2_subdev_ops sru_ops = {
+	.video	= &sru_video_ops,
+	.pad    = &sru_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_sru *sru;
+	int ret;
+
+	sru = devm_kzalloc(vsp1->dev, sizeof(*sru), GFP_KERNEL);
+	if (sru == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	sru->entity.type = VSP1_ENTITY_SRU;
+	sru->entity.id = VI6_DPR_NODE_SRU;
+
+	ret = vsp1_entity_init(vsp1, &sru->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &sru->entity.subdev;
+	v4l2_subdev_init(subdev, &sru_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s sru",
+		 dev_name(vsp1->dev));
+	v4l2_set_subdevdata(subdev, sru);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&sru->ctrls, 1);
+	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
+	v4l2_ctrl_handler_setup(&sru->ctrls);
+	sru->entity.subdev.ctrl_handler = &sru->ctrls;
+
+	return sru;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_sru.h b/drivers/media/platform/vsp1/vsp1_sru.h
new file mode 100644
index 0000000..381870b
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_sru.h
@@ -0,0 +1,41 @@
+/*
+ * vsp1_sru.h  --  R-Car VSP1 Super Resolution Unit
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_SRU_H__
+#define __VSP1_SRU_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define SRU_PAD_SINK				0
+#define SRU_PAD_SOURCE				1
+
+struct vsp1_sru {
+	struct vsp1_entity entity;
+
+	struct v4l2_ctrl_handler ctrls;
+	unsigned int intensity;
+};
+
+static inline struct vsp1_sru *to_sru(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_sru, entity.subdev);
+}
+
+struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1);
+
+#endif /* __VSP1_SRU_H__ */
diff --git a/include/linux/platform_data/vsp1.h b/include/linux/platform_data/vsp1.h
index a73a456..27c0ede 100644
--- a/include/linux/platform_data/vsp1.h
+++ b/include/linux/platform_data/vsp1.h
@@ -14,6 +14,7 @@
 #define __PLATFORM_VSP1_H__
 
 #define VSP1_HAS_LIF		(1 << 0)
+#define VSP1_HAS_SRU		(1 << 1)
 
 struct vsp1_platform_data {
 	unsigned int features;
-- 
1.8.3.2

