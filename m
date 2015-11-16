Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54911 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbbKPEqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 23:46:43 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 2/4] v4l: vsp1: Add Cubic Look Up Table (CLU) support
Date: Mon, 16 Nov 2015 06:46:43 +0200
Message-Id: <1447649205-1560-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1447649205-1560-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CLU processing block is a 3D lookup table that converts the input
three color component data into desired three color components using a
lookup table.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt     |   3 +
 drivers/media/platform/vsp1/Makefile               |   3 +-
 drivers/media/platform/vsp1/vsp1.h                 |   3 +
 drivers/media/platform/vsp1/vsp1_clu.c             | 288 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_clu.h             |  38 +++
 drivers/media/platform/vsp1/vsp1_drv.c             |  13 +
 drivers/media/platform/vsp1/vsp1_entity.c          |   1 +
 drivers/media/platform/vsp1/vsp1_entity.h          |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h            |   9 +
 include/uapi/linux/vsp1.h                          |  25 ++
 10 files changed, 383 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_clu.h

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index 87fe08abf36d..72708515a9a6 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -19,6 +19,8 @@ Required properties:
 
 Optional properties:
 
+  - renesas,has-clu: Boolean, indicates that the Cubic Look Up Table (CLU)
+    module is available.
   - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
     available.
   - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
@@ -35,6 +37,7 @@ Example: R8A7790 (R-Car H2) VSP1-S node
 		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
 
+		renesas,has-clu;
 		renesas,has-lut;
 		renesas,has-sru;
 		renesas,#rpf = <5>;
diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 6a93f928dfde..ca79d37c160a 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -1,6 +1,7 @@
 vsp1-y					:= vsp1_drv.o vsp1_entity.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
-vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
+vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
+vsp1-y					+= vsp1_lif.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 989e96f7e360..be434b046107 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -28,6 +28,7 @@ struct device;
 
 struct vsp1_platform_data;
 struct vsp1_bru;
+struct vsp1_clu;
 struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_lut;
@@ -42,6 +43,7 @@ struct vsp1_uds;
 #define VSP1_HAS_LIF		(1 << 0)
 #define VSP1_HAS_LUT		(1 << 1)
 #define VSP1_HAS_SRU		(1 << 2)
+#define VSP1_HAS_CLU		(1 << 3)
 
 struct vsp1_platform_data {
 	unsigned int features;
@@ -61,6 +63,7 @@ struct vsp1_device {
 	int ref_count;
 
 	struct vsp1_bru *bru;
+	struct vsp1_clu *clu;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
new file mode 100644
index 000000000000..87226059be65
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -0,0 +1,288 @@
+/*
+ * vsp1_clu.c  --  R-Car VSP1 Cubic Look-Up Table
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
+
+#include <linux/device.h>
+#include <linux/gfp.h>
+#include <linux/vsp1.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_clu.h"
+
+#define CLU_MIN_SIZE				4U
+#define CLU_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline void vsp1_clu_write(struct vsp1_clu *clu, u32 reg, u32 data)
+{
+	vsp1_write(clu->entity.vsp1, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Core Operations
+ */
+
+static int clu_configure(struct vsp1_clu *clu, struct vsp1_clu_config *config)
+{
+	struct vsp1_clu_entry *entries;
+	unsigned int i;
+	int ret;
+
+	if (config->nentries > 17*17*17)
+		return -EINVAL;
+
+	entries = kcalloc(config->nentries, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	ret = copy_from_user(entries, config->entries,
+			     config->nentries * sizeof(*entries));
+	if (ret) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	for (i = 0; i < config->nentries; ++i) {
+		u32 addr = entries[i].addr;
+		u32 value = entries[i].value;
+
+		if (((addr >> 0) & 0xff) >= 17 ||
+		    ((addr >> 8) & 0xff) >= 17 ||
+		    ((addr >> 16) & 0xff) >= 17 ||
+		    ((addr >> 24) & 0xff) != 0 ||
+		    (value & 0xff000000) != 0) {
+			ret = -EINVAL;
+			goto done;
+		}
+
+		vsp1_clu_write(clu, VI6_CLU_ADDR, addr);
+		vsp1_clu_write(clu, VI6_CLU_DATA, value);
+	}
+
+done:
+	kfree(entries);
+	return ret;
+}
+
+static long clu_ioctl(struct v4l2_subdev *subdev, unsigned int cmd, void *arg)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+
+	switch (cmd) {
+	case VIDIOC_VSP1_CLU_CONFIG:
+		return clu_configure(clu, arg);
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
+static int clu_s_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+
+	if (!enable)
+		return 0;
+
+	vsp1_clu_write(clu, VI6_CLU_CTRL, VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN);
+
+	return 0;
+}
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
+	struct vsp1_clu *clu = to_clu(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == CLU_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(codes))
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		/* The CLU can't perform format conversion, the sink format is
+		 * always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(&clu->entity, cfg,
+						    CLU_PAD_SINK, code->which);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int clu_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	format = vsp1_entity_get_pad_format(&clu->entity, cfg,
+					    fse->pad, fse->which);
+
+	if (fse->index || fse->code != format->code)
+		return -EINVAL;
+
+	if (fse->pad == CLU_PAD_SINK) {
+		fse->min_width = CLU_MIN_SIZE;
+		fse->max_width = CLU_MAX_SIZE;
+		fse->min_height = CLU_MIN_SIZE;
+		fse->max_height = CLU_MAX_SIZE;
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
+static int clu_get_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+
+	fmt->format = *vsp1_entity_get_pad_format(&clu->entity, cfg, fmt->pad,
+						  fmt->which);
+
+	return 0;
+}
+
+static int clu_set_format(struct v4l2_subdev *subdev,
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_clu *clu = to_clu(subdev);
+	struct v4l2_mbus_framefmt *format;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&clu->entity, cfg, fmt->pad,
+					    fmt->which);
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
+	format = vsp1_entity_get_pad_format(&clu->entity, cfg, CLU_PAD_SOURCE,
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
+static struct v4l2_subdev_core_ops clu_core_ops = {
+	.ioctl = clu_ioctl,
+};
+
+static struct v4l2_subdev_video_ops clu_video_ops = {
+	.s_stream = clu_s_stream,
+};
+
+static struct v4l2_subdev_pad_ops clu_pad_ops = {
+	.enum_mbus_code = clu_enum_mbus_code,
+	.enum_frame_size = clu_enum_frame_size,
+	.get_fmt = clu_get_format,
+	.set_fmt = clu_set_format,
+};
+
+static struct v4l2_subdev_ops clu_ops = {
+	.core	= &clu_core_ops,
+	.video	= &clu_video_ops,
+	.pad    = &clu_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
+{
+	struct v4l2_subdev *subdev;
+	struct vsp1_clu *clu;
+	int ret;
+
+	clu = devm_kzalloc(vsp1->dev, sizeof(*clu), GFP_KERNEL);
+	if (clu == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	clu->entity.type = VSP1_ENTITY_CLU;
+
+	ret = vsp1_entity_init(vsp1, &clu->entity, 2);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &clu->entity.subdev;
+	v4l2_subdev_init(subdev, &clu_ops);
+
+	subdev->entity.ops = &vsp1_media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	snprintf(subdev->name, sizeof(subdev->name), "%s clu",
+		 dev_name(vsp1->dev));
+	v4l2_set_subdevdata(subdev, clu);
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return clu;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
new file mode 100644
index 000000000000..4b69b7418c69
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -0,0 +1,38 @@
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
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define CLU_PAD_SINK				0
+#define CLU_PAD_SOURCE				1
+
+struct vsp1_clu {
+	struct vsp1_entity entity;
+	u32 clu[256];
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
index 4e61886384e3..d0c8812fbb7a 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -22,6 +22,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_clu.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
@@ -165,6 +166,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->bru->entity.list_dev, &vsp1->entities);
 
+	if (vsp1->pdata.features & VSP1_HAS_CLU) {
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
@@ -440,6 +451,8 @@ static int vsp1_parse_dt(struct vsp1_device *vsp1)
 	struct device_node *np = vsp1->dev->of_node;
 	struct vsp1_platform_data *pdata = &vsp1->pdata;
 
+	if (of_property_read_bool(np, "renesas,has-clu"))
+		pdata->features |= VSP1_HAS_CLU;
 	if (of_property_read_bool(np, "renesas,has-lif"))
 		pdata->features |= VSP1_HAS_LIF;
 	if (of_property_read_bool(np, "renesas,has-lut"))
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index fd95a75b04f4..08cc6caec047 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -160,6 +160,7 @@ static const struct vsp1_route vsp1_routes[] = {
 	{ VSP1_ENTITY_BRU, 0, VI6_DPR_BRU_ROUTE,
 	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
 	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3), } },
+	{ VSP1_ENTITY_CLU, 0, VI6_DPR_CLU_ROUTE, { VI6_DPR_NODE_CLU, } },
 	{ VSP1_ENTITY_HSI, 0, VI6_DPR_HSI_ROUTE, { VI6_DPR_NODE_HSI, } },
 	{ VSP1_ENTITY_HST, 0, VI6_DPR_HST_ROUTE, { VI6_DPR_NODE_HST, } },
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, } },
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 8867a5787c28..f2f8fc7f32dc 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -23,6 +23,7 @@ struct vsp1_video;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
+	VSP1_ENTITY_CLU,
 	VSP1_ENTITY_HSI,
 	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 25b48738b147..57c66bd95bbf 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -434,6 +434,15 @@
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
diff --git a/include/uapi/linux/vsp1.h b/include/uapi/linux/vsp1.h
index 9a823696d816..f8360dca0769 100644
--- a/include/uapi/linux/vsp1.h
+++ b/include/uapi/linux/vsp1.h
@@ -22,13 +22,38 @@
  * Private IOCTLs
  *
  * VIDIOC_VSP1_LUT_CONFIG - Configure the lookup table
+ *
+ * VIDIOC_VSP1_CLU_CONFIG - Configure the 3D lookup table
+ * @nentries: number of entries in the entries array
+ * @entries: CLU entries
+ *
+ * Each CLU entry is identified by an address and has a value. The address is
+ * split in 4 bytes ; the MSB must be set to 0 and all 3 other bytes set to
+ * values between 0 and 16 inclusive. The value must be in the range 0x00000000
+ * to 0x00ffffff.
+ *
+ * The number of entries is limited to 17*17*17. If the number of entries or the
+ * address or value of an entry is invalid the ioctl will return -EINVAL.
+ * Otherwise it will program the hardware with the entries and return 0.
  */
 
 #define VIDIOC_VSP1_LUT_CONFIG \
 	_IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct vsp1_lut_config)
+#define VIDIOC_VSP1_CLU_CONFIG \
+	_IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct vsp1_clu_config)
 
 struct vsp1_lut_config {
 	__u32 lut[256];
 };
 
+struct vsp1_clu_entry {
+	__u32 addr;
+	__u32 value;
+};
+
+struct vsp1_clu_config {
+	__u32 nentries;
+	struct vsp1_clu_entry __user *entries;
+};
+
 #endif	/* __VSP1_USER_H__ */
-- 
2.4.10

