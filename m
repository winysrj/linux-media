Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab3K2WvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:51:02 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 6/6] v4l: vsp1: Add LUT support
Date: Fri, 29 Nov 2013 23:50:52 +0100
Message-Id: <1385765452-25754-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Look-Up Table looks up values in 8-bit indexed tables separately for
each color component.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   4 +-
 drivers/media/platform/vsp1/vsp1.h        |   2 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  11 ++
 drivers/media/platform/vsp1/vsp1_entity.c |   1 +
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_lut.c    | 252 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_lut.h    |  38 +++++
 drivers/media/platform/vsp1/vsp1_regs.h   |   1 +
 include/linux/platform_data/vsp1.h        |   3 +-
 include/uapi/linux/vsp1.h                 |  34 ++++
 10 files changed, 344 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_lut.h
 create mode 100644 include/uapi/linux/vsp1.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 45621cb..151cecd 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,6 +1,6 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
-vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_sru.o
-vsp1-y					+= vsp1_uds.o
+vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
+vsp1-y					+= vsp1_sru.o vsp1_uds.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 84327fa..1df2be6 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -30,6 +30,7 @@ struct device;
 struct vsp1_platform_data;
 struct vsp1_hsit;
 struct vsp1_lif;
+struct vsp1_lut;
 struct vsp1_rwpf;
 struct vsp1_sru;
 struct vsp1_uds;
@@ -52,6 +53,7 @@ struct vsp1_device {
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
+	struct vsp1_lut *lut;
 	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
 	struct vsp1_sru *sru;
 	struct vsp1_uds *uds[VPS1_MAX_UDS];
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 9753074..f3116d0 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -22,6 +22,7 @@
 #include "vsp1.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
+#include "vsp1_lut.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_sru.h"
 #include "vsp1_uds.h"
@@ -180,6 +181,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->lif->entity.list_dev, &vsp1->entities);
 	}
 
+	if (vsp1->pdata->features & VSP1_HAS_LUT) {
+		vsp1->lut = vsp1_lut_create(vsp1);
+		if (IS_ERR(vsp1->lut)) {
+			ret = PTR_ERR(vsp1->lut);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->lut->entity.list_dev, &vsp1->entities);
+	}
+
 	for (i = 0; i < vsp1->pdata->rpf_count; ++i) {
 		struct vsp1_rwpf *rpf;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index b11e5a6..0226e47 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -126,6 +126,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		{ VI6_DPR_NODE_HSI, VI6_DPR_HSI_ROUTE },
 		{ VI6_DPR_NODE_HST, VI6_DPR_HST_ROUTE },
 		{ VI6_DPR_NODE_LIF, 0 },
+		{ VI6_DPR_NODE_LUT, VI6_DPR_LUT_ROUTE },
 		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
 		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
 		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 08e4480..e152798 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -23,6 +23,7 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_HSI,
 	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
+	VSP1_ENTITY_LUT,
 	VSP1_ENTITY_RPF,
 	VSP1_ENTITY_SRU,
 	VSP1_ENTITY_UDS,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
new file mode 100644
index 0000000..4e9dc7c
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -0,0 +1,252 @@
+/*
+ * vsp1_lut.c  --  R-Car VSP1 Look-Up Table
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
+#include <linux/vsp1.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_lut.h"
+
+#define LUT_MIN_SIZE				4U
+#define LUT_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_lut_read(struct vsp1_lut *lut, u32 reg)
+{
+	return vsp1_read(lut->entity.vsp1, reg);
+}
+
+static inline void vsp1_lut_write(struct vsp1_lut *lut, u32 reg, u32 data)
+{
+	vsp1_write(lut->entity.vsp1, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static void lut_configure(struct vsp1_lut *lut, struct vsp1_lut_config *config)
+{
+	memcpy_toio(lut->entity.vsp1->mmio + VI6_LUT_TABLE, config->lut,
+		    sizeof(config->lut));
+}
+
+static long lut_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
+{
+	struct vsp1_lut *lut = to_lut(subdev);
+
+	switch (cmd) {
+	case VIDIOC_VSP1_LUT_CONFIG:
+		lut_configure(lut, arg);
+		return 0;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Video Operations
+ */
+
+static int lut_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_lut *lut = to_lut(subdev);
+
+	if (!enable)
+		return 0;
+
+	vsp1_lut_write(lut, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		V4L2_MBUS_FMT_ARGB8888_1X32,
+		V4L2_MBUS_FMT_AHSV8888_1X32,
+		V4L2_MBUS_FMT_AYUV8_1X32,
+	};
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == LUT_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(codes))
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		/* The LUT can't perform format conversion, the sink format is
+		 * always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		format = v4l2_subdev_get_try_format(fh, LUT_PAD_SINK);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int lut_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, fse->pad);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == LUT_PAD_SINK) {
+		fse->min_width = LUT_MIN_SIZE;
+		fse->max_width = LUT_MAX_SIZE;
+		fse->min_height = LUT_MIN_SIZE;
+		fse->max_height = LUT_MAX_SIZE;
+	} else {
+		/* The size on the source pad are fixed and always identical to
+		 * the size on the sink pad.
+		 */
+		fse->min_width = format->width;
+		fse->max_width = format->width;
+		fse->min_height = format->height;
+		fse->max_height = format->height;
+	}
+
+	return 0;
+}
+
+static int lut_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_lut *lut = to_lut(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_lut *lut = to_lut(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != V4L2_MBUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != V4L2_MBUS_FMT_AHSV8888_1X32 &&
+	    fmt->format.code != V4L2_MBUS_FMT_AYUV8_1X32)
+		fmt->format.code = V4L2_MBUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&lut->entity, fh, fmt->pad,
+					    fmt->which);
+
+	if (fmt->pad == LUT_PAD_SOURCE) {
+		/* The LUT output format can't be modified. */
+		fmt->format = *format;
+		return 0;
+	}
+
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				LUT_MIN_SIZE, LUT_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 LUT_MIN_SIZE, LUT_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&lut->entity, fh, LUT_PAD_SOURCE,
+					    fmt->which);
+	*format = fmt->format;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_core_ops lut_core_ops = {
+	.ioctl = lut_ioctl,
+};
+
+static struct v4l2_subdev_video_ops lut_video_ops = {
+	.s_stream = lut_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops lut_pad_ops = {
+	.enum_mbus_code = lut_enum_mbus_code,
+	.enum_frame_size = lut_enum_frame_size,
+	.get_fmt = lut_get_format,
+	.set_fmt = lut_set_format,
+};
+
+static struct v4l2_subdev_ops lut_ops = {
+	.core	= &lut_core_ops,
+	.video	= &lut_video_ops,
+	.pad    = &lut_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_lut *lut;
+	int ret;
+
+	lut = devm_kzalloc(vsp1->dev, sizeof(*lut), GFP_KERNEL);
+	if (lut == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	lut->entity.type = VSP1_ENTITY_LUT;
+	lut->entity.id = VI6_DPR_NODE_LUT;
+
+	ret = vsp1_entity_init(vsp1, &lut->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &lut->entity.subdev;
+	v4l2_subdev_init(subdev, &lut_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s lut",
+		 dev_name(vsp1->dev));
+	v4l2_set_subdevdata(subdev, lut);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return lut;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
new file mode 100644
index 0000000..f92ffb8
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -0,0 +1,38 @@
+/*
+ * vsp1_lut.h  --  R-Car VSP1 Look-Up Table
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
+#ifndef __VSP1_LUT_H__
+#define __VSP1_LUT_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define LUT_PAD_SINK				0
+#define LUT_PAD_SOURCE				1
+
+struct vsp1_lut {
+	struct vsp1_entity entity;
+	u32 lut[256];
+};
+
+static inline struct vsp1_lut *to_lut(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_lut, entity.subdev);
+}
+
+struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1);
+
+#endif /* __VSP1_LUT_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 530cc61..2865080 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -425,6 +425,7 @@
  */
 
 #define VI6_LUT_CTRL			0x2800
+#define VI6_LUT_CTRL_EN			(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * CLU Control Registers
diff --git a/include/linux/platform_data/vsp1.h b/include/linux/platform_data/vsp1.h
index 27c0ede..63170e26 100644
--- a/include/linux/platform_data/vsp1.h
+++ b/include/linux/platform_data/vsp1.h
@@ -14,7 +14,8 @@
 #define __PLATFORM_VSP1_H__
 
 #define VSP1_HAS_LIF		(1 << 0)
-#define VSP1_HAS_SRU		(1 << 1)
+#define VSP1_HAS_LUT		(1 << 1)
+#define VSP1_HAS_SRU		(1 << 2)
 
 struct vsp1_platform_data {
 	unsigned int features;
diff --git a/include/uapi/linux/vsp1.h b/include/uapi/linux/vsp1.h
new file mode 100644
index 0000000..e18858f
--- /dev/null
+++ b/include/uapi/linux/vsp1.h
@@ -0,0 +1,34 @@
+/*
+ * vsp1.h
+ *
+ * Renesas R-Car VSP1 - User-space API
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __VSP1_USER_H__
+#define __VSP1_USER_H__
+
+#include <linux/types.h>
+#include <linux/videodev2.h>
+
+/*
+ * Private IOCTLs
+ *
+ * VIDIOC_VSP1_LUT_CONFIG - Configure the lookup table
+ */
+
+#define VIDIOC_VSP1_LUT_CONFIG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct vsp1_lut_config)
+
+struct vsp1_lut_config {
+	u32 lut[256];
+};
+
+#endif	/* __VSP1_USER_H__ */
-- 
1.8.3.2

