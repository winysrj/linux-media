Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3K2WvA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:51:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 4/6] v4l: vsp1: Add HST and HSI support
Date: Fri, 29 Nov 2013 23:50:50 +0100
Message-Id: <1385765452-25754-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Hue Saturation value Transform and Hue Saturation value Inverse
transform entities convert from RGB to HSV and back.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  17 +++
 drivers/media/platform/vsp1/vsp1_entity.c |   2 +
 drivers/media/platform/vsp1/vsp1_entity.h |   2 +
 drivers/media/platform/vsp1/vsp1_hsit.c   | 222 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hsit.h   |  38 +++++
 drivers/media/platform/vsp1/vsp1_regs.h   |   2 +
 8 files changed, 287 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hsit.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 4da2261..587b800 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,5 +1,5 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
-vsp1-y					+= vsp1_lif.o vsp1_uds.o
+vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_uds.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 7dab256..9ab0b74 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -28,6 +28,7 @@ struct clk;
 struct device;
 
 struct vsp1_platform_data;
+struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_rwpf;
 struct vsp1_uds;
@@ -47,6 +48,8 @@ struct vsp1_device {
 	struct mutex lock;
 	int ref_count;
 
+	struct vsp1_hsit *hsi;
+	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
 	struct vsp1_rwpf *rpf[VPS1_MAX_RPF];
 	struct vsp1_uds *uds[VPS1_MAX_UDS];
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 1c9e771..bdc32c8 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -20,6 +20,7 @@
 #include <linux/videodev2.h>
 
 #include "vsp1.h"
+#include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
@@ -152,6 +153,22 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Instantiate all the entities. */
+	vsp1->hsi = vsp1_hsit_create(vsp1, true);
+	if (IS_ERR(vsp1->hsi)) {
+		ret = PTR_ERR(vsp1->hsi);
+		goto done;
+	}
+
+	list_add_tail(&vsp1->hsi->entity.list_dev, &vsp1->entities);
+
+	vsp1->hst = vsp1_hsit_create(vsp1, false);
+	if (IS_ERR(vsp1->hst)) {
+		ret = PTR_ERR(vsp1->hst);
+		goto done;
+	}
+
+	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
+
 	if (vsp1->pdata->features & VSP1_HAS_LIF) {
 		vsp1->lif = vsp1_lif_create(vsp1);
 		if (IS_ERR(vsp1->lif)) {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 9028f9d..3798ef4 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -122,6 +122,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		unsigned int id;
 		unsigned int reg;
 	} routes[] = {
+		{ VI6_DPR_NODE_HSI, VI6_DPR_HSI_ROUTE },
+		{ VI6_DPR_NODE_HST, VI6_DPR_HST_ROUTE },
 		{ VI6_DPR_NODE_LIF, 0 },
 		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
 		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c4feab2c..0d61746 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -20,6 +20,8 @@
 struct vsp1_device;
 
 enum vsp1_entity_type {
+	VSP1_ENTITY_HSI,
+	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
 	VSP1_ENTITY_RPF,
 	VSP1_ENTITY_UDS,
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
new file mode 100644
index 0000000..28548535
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -0,0 +1,222 @@
+/*
+ * vsp1_hsit.c  --  R-Car VSP1 Hue Saturation value (Inverse) Transform
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
+#include "vsp1_hsit.h"
+
+#define HSIT_MIN_SIZE				4U
+#define HSIT_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_hsit_read(struct vsp1_hsit *hsit, u32 reg)
+{
+	return vsp1_read(hsit->entity.vsp1, reg);
+}
+
+static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32 data)
+{
+	vsp1_write(hsit->entity.vsp1, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int hsit_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_hsit *hsit = to_hsit(subdev);
+
+	if (!enable)
+		return 0;
+
+	if (hsit->inverse)
+		vsp1_hsit_write(hsit, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
+	else
+		vsp1_hsit_write(hsit, VI6_HST_CTRL, VI6_HST_CTRL_EN);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static int hsit_enum_mbus_code(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct vsp1_hsit *hsit = to_hsit(subdev);
+
+	if (code->index > 0)
+		return -EINVAL;
+
+	if ((code->pad == HSIT_PAD_SINK && !hsit->inverse) |
+	    (code->pad == HSIT_PAD_SOURCE && hsit->inverse))
+		code->code = V4L2_MBUS_FMT_ARGB8888_1X32;
+	else
+		code->code = V4L2_MBUS_FMT_AHSV8888_1X32;
+
+	return 0;
+}
+
+static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct v4l2_mbus_framefmt *format;
+
+	format = v4l2_subdev_get_try_format(fh, fse->pad);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == HSIT_PAD_SINK) {
+		fse->min_width = HSIT_MIN_SIZE;
+		fse->max_width = HSIT_MAX_SIZE;
+		fse->min_height = HSIT_MIN_SIZE;
+		fse->max_height = HSIT_MAX_SIZE;
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
+static int hsit_get_format(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_hsit *hsit = to_hsit(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, fh, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static int hsit_set_format(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_hsit *hsit = to_hsit(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	format = vsp1_entity_get_pad_format(&hsit->entity, fh, fmt->pad,
+					    fmt->which);
+
+	if (fmt->pad == HSIT_PAD_SOURCE) {
+		/* The HST and HSI output format code and resolution can't be
+		 * modified.
+		 */
+		fmt->format = *format;
+		return 0;
+	}
+
+	format->code = hsit->inverse ? V4L2_MBUS_FMT_AHSV8888_1X32
+		     : V4L2_MBUS_FMT_ARGB8888_1X32;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				HSIT_MIN_SIZE, HSIT_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 HSIT_MIN_SIZE, HSIT_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Propagate the format to the source pad. */
+	format = vsp1_entity_get_pad_format(&hsit->entity, fh, HSIT_PAD_SOURCE,
+					    fmt->which);
+	*format = fmt->format;
+	format->code = hsit->inverse ? V4L2_MBUS_FMT_ARGB8888_1X32
+		     : V4L2_MBUS_FMT_AHSV8888_1X32;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static struct v4l2_subdev_video_ops hsit_video_ops = {
+	.s_stream = hsit_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops hsit_pad_ops = {
+	.enum_mbus_code = hsit_enum_mbus_code,
+	.enum_frame_size = hsit_enum_frame_size,
+	.get_fmt = hsit_get_format,
+	.set_fmt = hsit_set_format,
+};
+
+static struct v4l2_subdev_ops hsit_ops = {
+	.video	= &hsit_video_ops,
+	.pad    = &hsit_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_hsit *hsit;
+	int ret;
+
+	hsit = devm_kzalloc(vsp1->dev, sizeof(*hsit), GFP_KERNEL);
+	if (hsit == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	hsit->inverse = inverse;
+
+	if (inverse) {
+		hsit->entity.type = VSP1_ENTITY_HSI;
+		hsit->entity.id = VI6_DPR_NODE_HSI;
+	} else {
+		hsit->entity.type = VSP1_ENTITY_HST;
+		hsit->entity.id = VI6_DPR_NODE_HST;
+	}
+
+	ret = vsp1_entity_init(vsp1, &hsit->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &hsit->entity.subdev;
+	v4l2_subdev_init(subdev, &hsit_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
+		 dev_name(vsp1->dev), inverse ? "hsi" : "hst");
+	v4l2_set_subdevdata(subdev, hsit);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return hsit;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.h b/drivers/media/platform/vsp1/vsp1_hsit.h
new file mode 100644
index 0000000..82f1c8426
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hsit.h
@@ -0,0 +1,38 @@
+/*
+ * vsp1_hsit.h  --  R-Car VSP1 Hue Saturation value (Inverse) Transform
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
+#ifndef __VSP1_HSIT_H__
+#define __VSP1_HSIT_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define HSIT_PAD_SINK				0
+#define HSIT_PAD_SOURCE				1
+
+struct vsp1_hsit {
+	struct vsp1_entity entity;
+	bool inverse;
+};
+
+static inline struct vsp1_hsit *to_hsit(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_hsit, entity.subdev);
+}
+
+struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse);
+
+#endif /* __VSP1_HSIT_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 1d3304f..0b93f88 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -424,12 +424,14 @@
  */
 
 #define VI6_HST_CTRL			0x2a00
+#define VI6_HST_CTRL_EN			(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * HSI Control Registers
  */
 
 #define VI6_HSI_CTRL			0x2b00
+#define VI6_HSI_CTRL_EN			(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * BRU Control Registers
-- 
1.8.3.2

