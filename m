Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54472 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751664AbeD1UuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 16:50:21 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v3 6/8] v4l: vsp1: Add support for the DISCOM entity
Date: Sat, 28 Apr 2018 23:50:25 +0300
Message-Id: <20180428205027.18025-7-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180428205027.18025-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DISCOM calculates a CRC on a configurable window of the frame. It
interfaces to the VSP through the UIF glue, hence the name used in the
code.

The module supports configuration of the CRC window through the crop
rectangle on the sink pad of the corresponding entity. However, unlike
the traditional V4L2 subdevice model, the crop rectangle does not
influence the format on the source pad.

Modeling the DISCOM as a sink-only entity would allow adhering to the
V4L2 subdevice model at the expense of more complex code in the driver,
as at the hardware level the UIF is handled as a sink+source entity. As
the DISCOM is only present in R-Car Gen3 VSP-D and VSP-DL instances it
is not exposed to userspace through V4L2 but controlled through the DU
driver. We can thus change this model later if needed without fear of
affecting userspace.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Changes since v2:

- Change comparison to NULL to the ! operator
- Clarify M3-W quirk handling
- Fix typo in commit message

Changes since v1:

- Don't return uninitialized value from uif_set_selection()
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   4 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  20 +++
 drivers/media/platform/vsp1/vsp1_entity.c |   6 +
 drivers/media/platform/vsp1/vsp1_entity.h |   1 +
 drivers/media/platform/vsp1/vsp1_regs.h   |  41 +++++
 drivers/media/platform/vsp1/vsp1_uif.c    | 271 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_uif.h    |  32 ++++
 8 files changed, 376 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_uif.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 596775f932c0..4bb4dcbef7b5 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -5,6 +5,6 @@ vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
 vsp1-y					+= vsp1_brx.o vsp1_sru.o vsp1_uds.o
 vsp1-y					+= vsp1_hgo.o vsp1_hgt.o vsp1_histo.o
-vsp1-y					+= vsp1_lif.o
+vsp1-y					+= vsp1_lif.o vsp1_uif.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 9cf4e1c4b036..33f632331474 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -36,10 +36,12 @@ struct vsp1_lut;
 struct vsp1_rwpf;
 struct vsp1_sru;
 struct vsp1_uds;
+struct vsp1_uif;
 
 #define VSP1_MAX_LIF		2
 #define VSP1_MAX_RPF		5
 #define VSP1_MAX_UDS		3
+#define VSP1_MAX_UIF		2
 #define VSP1_MAX_WPF		4
 
 #define VSP1_HAS_LUT		(1 << 1)
@@ -60,6 +62,7 @@ struct vsp1_device_info {
 	unsigned int lif_count;
 	unsigned int rpf_count;
 	unsigned int uds_count;
+	unsigned int uif_count;
 	unsigned int wpf_count;
 	unsigned int num_bru_inputs;
 	bool uapi;
@@ -86,6 +89,7 @@ struct vsp1_device {
 	struct vsp1_rwpf *rpf[VSP1_MAX_RPF];
 	struct vsp1_sru *sru;
 	struct vsp1_uds *uds[VSP1_MAX_UDS];
+	struct vsp1_uif *uif[VSP1_MAX_UIF];
 	struct vsp1_rwpf *wpf[VSP1_MAX_WPF];
 
 	struct list_head entities;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 331a2e0af0d3..d29f9c4baebe 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -35,6 +35,7 @@
 #include "vsp1_rwpf.h"
 #include "vsp1_sru.h"
 #include "vsp1_uds.h"
+#include "vsp1_uif.h"
 #include "vsp1_video.h"
 
 /* -----------------------------------------------------------------------------
@@ -409,6 +410,19 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&uds->entity.list_dev, &vsp1->entities);
 	}
 
+	for (i = 0; i < vsp1->info->uif_count; ++i) {
+		struct vsp1_uif *uif;
+
+		uif = vsp1_uif_create(vsp1, i);
+		if (IS_ERR(uif)) {
+			ret = PTR_ERR(uif);
+			goto done;
+		}
+
+		vsp1->uif[i] = uif;
+		list_add_tail(&uif->entity.list_dev, &vsp1->entities);
+	}
+
 	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf;
 
@@ -513,6 +527,9 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	for (i = 0; i < vsp1->info->uds_count; ++i)
 		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
 
+	for (i = 0; i < vsp1->info->uif_count; ++i)
+		vsp1_write(vsp1, VI6_DPR_UIF_ROUTE(i), VI6_DPR_NODE_UNUSED);
+
 	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
 	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
 	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, VI6_DPR_NODE_UNUSED);
@@ -740,6 +757,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.features = VSP1_HAS_BRU | VSP1_HAS_WPF_VFLIP,
 		.lif_count = 1,
 		.rpf_count = 5,
+		.uif_count = 1,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
 	}, {
@@ -749,6 +767,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
 		.lif_count = 1,
 		.rpf_count = 5,
+		.uif_count = 1,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
 	}, {
@@ -758,6 +777,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.features = VSP1_HAS_BRS | VSP1_HAS_BRU,
 		.lif_count = 2,
 		.rpf_count = 5,
+		.uif_count = 2,
 		.wpf_count = 2,
 		.num_bru_inputs = 5,
 	},
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index f10c61339d46..c411643695e4 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -539,6 +539,10 @@ struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad)
 	{ VSP1_ENTITY_UDS, idx, VI6_DPR_UDS_ROUTE(idx),			\
 	  { VI6_DPR_NODE_UDS(idx) }, VI6_DPR_NODE_UDS(idx) }
 
+#define VSP1_ENTITY_ROUTE_UIF(idx)					\
+	{ VSP1_ENTITY_UIF, idx, VI6_DPR_UIF_ROUTE(idx),			\
+	  { VI6_DPR_NODE_UIF(idx) }, VI6_DPR_NODE_UIF(idx) }
+
 #define VSP1_ENTITY_ROUTE_WPF(idx)					\
 	{ VSP1_ENTITY_WPF, idx, 0,					\
 	  { VI6_DPR_NODE_WPF(idx) }, VI6_DPR_NODE_WPF(idx) }
@@ -567,6 +571,8 @@ static const struct vsp1_route vsp1_routes[] = {
 	VSP1_ENTITY_ROUTE_UDS(0),
 	VSP1_ENTITY_ROUTE_UDS(1),
 	VSP1_ENTITY_ROUTE_UDS(2),
+	VSP1_ENTITY_ROUTE_UIF(0),	/* Named UIF4 in the documentation */
+	VSP1_ENTITY_ROUTE_UIF(1),	/* Named UIF5 in the documentation */
 	VSP1_ENTITY_ROUTE_WPF(0),
 	VSP1_ENTITY_ROUTE_WPF(1),
 	VSP1_ENTITY_ROUTE_WPF(2),
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 0839a62cfa71..94490d697dcf 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -33,6 +33,7 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_RPF,
 	VSP1_ENTITY_SRU,
 	VSP1_ENTITY_UDS,
+	VSP1_ENTITY_UIF,
 	VSP1_ENTITY_WPF,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 3201ad4b77d4..0d249ff9f564 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -307,6 +307,44 @@
 #define VI6_WPF_WRBCK_CTRL		0x1034
 #define VI6_WPF_WRBCK_CTRL_WBMD		(1 << 0)
 
+/* -----------------------------------------------------------------------------
+ * UIF Control Registers
+ */
+
+#define VI6_UIF_OFFSET			0x100
+
+#define VI6_UIF_DISCOM_DOCMCR		0x1c00
+#define VI6_UIF_DISCOM_DOCMCR_CMPRU	(1 << 16)
+#define VI6_UIF_DISCOM_DOCMCR_CMPR	(1 << 0)
+
+#define VI6_UIF_DISCOM_DOCMSTR		0x1c04
+#define VI6_UIF_DISCOM_DOCMSTR_CMPPRE	(1 << 1)
+#define VI6_UIF_DISCOM_DOCMSTR_CMPST	(1 << 0)
+
+#define VI6_UIF_DISCOM_DOCMCLSTR	0x1c08
+#define VI6_UIF_DISCOM_DOCMCLSTR_CMPCLPRE	(1 << 1)
+#define VI6_UIF_DISCOM_DOCMCLSTR_CMPCLST	(1 << 0)
+
+#define VI6_UIF_DISCOM_DOCMIENR		0x1c0c
+#define VI6_UIF_DISCOM_DOCMIENR_CMPPREIEN	(1 << 1)
+#define VI6_UIF_DISCOM_DOCMIENR_CMPIEN		(1 << 0)
+
+#define VI6_UIF_DISCOM_DOCMMDR		0x1c10
+#define VI6_UIF_DISCOM_DOCMMDR_INTHRH(n)	((n) << 16)
+
+#define VI6_UIF_DISCOM_DOCMPMR		0x1c14
+#define VI6_UIF_DISCOM_DOCMPMR_CMPDFF(n)	((n) << 17)
+#define VI6_UIF_DISCOM_DOCMPMR_CMPDFA(n)	((n) << 8)
+#define VI6_UIF_DISCOM_DOCMPMR_CMPDAUF		(1 << 7)
+#define VI6_UIF_DISCOM_DOCMPMR_SEL(n)		((n) << 0)
+
+#define VI6_UIF_DISCOM_DOCMECRCR	0x1c18
+#define VI6_UIF_DISCOM_DOCMCCRCR	0x1c1c
+#define VI6_UIF_DISCOM_DOCMSPXR		0x1c20
+#define VI6_UIF_DISCOM_DOCMSPYR		0x1c24
+#define VI6_UIF_DISCOM_DOCMSZXR		0x1c28
+#define VI6_UIF_DISCOM_DOCMSZYR		0x1c2c
+
 /* -----------------------------------------------------------------------------
  * DPR Control Registers
  */
@@ -339,7 +377,10 @@
 #define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
 #define VI6_DPR_SMPPT_PT_SHIFT		0
 
+#define VI6_DPR_UIF_ROUTE(n)		(0x2074 + (n) * 4)
+
 #define VI6_DPR_NODE_RPF(n)		(n)
+#define VI6_DPR_NODE_UIF(n)		(12 + (n))
 #define VI6_DPR_NODE_SRU		16
 #define VI6_DPR_NODE_UDS(n)		(17 + (n))
 #define VI6_DPR_NODE_LUT		22
diff --git a/drivers/media/platform/vsp1/vsp1_uif.c b/drivers/media/platform/vsp1/vsp1_uif.c
new file mode 100644
index 000000000000..c219165b15b9
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_uif.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * vsp1_uif.c  --  R-Car VSP1 User Logic Interface
+ *
+ * Copyright (C) 2017-2018 Laurent Pinchart
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ */
+
+#include <linux/device.h>
+#include <linux/gfp.h>
+#include <linux/sys_soc.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1.h"
+#include "vsp1_dl.h"
+#include "vsp1_entity.h"
+#include "vsp1_uif.h"
+
+#define UIF_MIN_SIZE				4U
+#define UIF_MAX_SIZE				8190U
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_uif_read(struct vsp1_uif *uif, u32 reg)
+{
+	return vsp1_read(uif->entity.vsp1,
+			 uif->entity.index * VI6_UIF_OFFSET + reg);
+}
+static inline void vsp1_uif_write(struct vsp1_uif *uif, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
+{
+	vsp1_dl_list_write(dl, reg + uif->entity.index * VI6_UIF_OFFSET, data);
+}
+
+u32 vsp1_uif_get_crc(struct vsp1_uif *uif)
+{
+	return vsp1_uif_read(uif, VI6_UIF_DISCOM_DOCMCCRCR);
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Pad Operations
+ */
+
+static const unsigned int uif_codes[] = {
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+	MEDIA_BUS_FMT_AYUV8_1X32,
+};
+
+static int uif_enum_mbus_code(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_pad_config *cfg,
+			      struct v4l2_subdev_mbus_code_enum *code)
+{
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, uif_codes,
+					  ARRAY_SIZE(uif_codes));
+}
+
+static int uif_enum_frame_size(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_frame_size_enum *fse)
+{
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, UIF_MIN_SIZE,
+					   UIF_MIN_SIZE, UIF_MAX_SIZE,
+					   UIF_MAX_SIZE);
+}
+
+static int uif_set_format(struct v4l2_subdev *subdev,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *fmt)
+{
+	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, uif_codes,
+					  ARRAY_SIZE(uif_codes),
+					  UIF_MIN_SIZE, UIF_MIN_SIZE,
+					  UIF_MAX_SIZE, UIF_MAX_SIZE);
+}
+
+static int uif_get_selection(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_uif *uif = to_uif(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	int ret = 0;
+
+	if (sel->pad != UIF_PAD_SINK)
+		return -EINVAL;
+
+	mutex_lock(&uif->entity.lock);
+
+	config = vsp1_entity_get_pad_config(&uif->entity, cfg, sel->which);
+	if (!config) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		format = vsp1_entity_get_pad_format(&uif->entity, config,
+						    UIF_PAD_SINK);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = format->width;
+		sel->r.height = format->height;
+		break;
+
+	case V4L2_SEL_TGT_CROP:
+		sel->r = *vsp1_entity_get_pad_selection(&uif->entity, config,
+							sel->pad, sel->target);
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+done:
+	mutex_unlock(&uif->entity.lock);
+	return ret;
+}
+
+static int uif_set_selection(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_uif *uif = to_uif(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
+	int ret = 0;
+
+	if (sel->pad != UIF_PAD_SINK ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	mutex_lock(&uif->entity.lock);
+
+	config = vsp1_entity_get_pad_config(&uif->entity, cfg, sel->which);
+	if (!config) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	/* The crop rectangle must be inside the input frame. */
+	format = vsp1_entity_get_pad_format(&uif->entity, config, UIF_PAD_SINK);
+
+	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
+	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
+	sel->r.width = clamp_t(unsigned int, sel->r.width, UIF_MIN_SIZE,
+			       format->width - sel->r.left);
+	sel->r.height = clamp_t(unsigned int, sel->r.height, UIF_MIN_SIZE,
+				format->height - sel->r.top);
+
+	/* Store the crop rectangle. */
+	selection = vsp1_entity_get_pad_selection(&uif->entity, config,
+						  sel->pad, V4L2_SEL_TGT_CROP);
+	*selection = sel->r;
+
+done:
+	mutex_unlock(&uif->entity.lock);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 Subdevice Operations
+ */
+
+static const struct v4l2_subdev_pad_ops uif_pad_ops = {
+	.init_cfg = vsp1_entity_init_cfg,
+	.enum_mbus_code = uif_enum_mbus_code,
+	.enum_frame_size = uif_enum_frame_size,
+	.get_fmt = vsp1_subdev_get_pad_format,
+	.set_fmt = uif_set_format,
+	.get_selection = uif_get_selection,
+	.set_selection = uif_set_selection,
+};
+
+static const struct v4l2_subdev_ops uif_ops = {
+	.pad    = &uif_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void uif_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
+{
+	struct vsp1_uif *uif = to_uif(&entity->subdev);
+	const struct v4l2_rect *crop;
+	unsigned int left;
+	unsigned int width;
+
+	/*
+	 * Per-partition configuration isn't needed as the DISCOM is used in
+	 * display pipelines only.
+	 */
+	if (params != VSP1_ENTITY_PARAMS_INIT)
+		return;
+
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMPMR,
+		       VI6_UIF_DISCOM_DOCMPMR_SEL(9));
+
+	crop = vsp1_entity_get_pad_selection(entity, entity->config,
+					     UIF_PAD_SINK, V4L2_SEL_TGT_CROP);
+
+	left = crop->left;
+	width = crop->width;
+
+	/* On M3-W the horizontal coordinates are twice the register value. */
+	if (uif->m3w_quirk) {
+		left /= 2;
+		width /= 2;
+	}
+
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPXR, left);
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPYR, crop->top);
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZXR, width);
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZYR, crop->height);
+
+	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMCR,
+		       VI6_UIF_DISCOM_DOCMCR_CMPR);
+}
+
+static const struct vsp1_entity_operations uif_entity_ops = {
+	.configure = uif_configure,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+static const struct soc_device_attribute vsp1_r8a7796[] = {
+	{ .soc_id = "r8a7796" },
+	{ /* sentinel */ }
+};
+
+struct vsp1_uif *vsp1_uif_create(struct vsp1_device *vsp1, unsigned int index)
+{
+	struct vsp1_uif *uif;
+	char name[6];
+	int ret;
+
+	uif = devm_kzalloc(vsp1->dev, sizeof(*uif), GFP_KERNEL);
+	if (!uif)
+		return ERR_PTR(-ENOMEM);
+
+	if (soc_device_match(vsp1_r8a7796))
+		uif->m3w_quirk = true;
+
+	uif->entity.ops = &uif_entity_ops;
+	uif->entity.type = VSP1_ENTITY_UIF;
+	uif->entity.index = index;
+
+	/* The datasheet names the two UIF instances UIF4 and UIF5. */
+	sprintf(name, "uif.%u", index + 4);
+	ret = vsp1_entity_init(vsp1, &uif->entity, name, 2, &uif_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	return uif;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_uif.h b/drivers/media/platform/vsp1/vsp1_uif.h
new file mode 100644
index 000000000000..c71ab5f6a6f8
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_uif.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * vsp1_uif.h  --  R-Car VSP1 User Logic Interface
+ *
+ * Copyright (C) 2017-2018 Laurent Pinchart
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ */
+#ifndef __VSP1_UIF_H__
+#define __VSP1_UIF_H__
+
+#include "vsp1_entity.h"
+
+struct vsp1_device;
+
+#define UIF_PAD_SINK				0
+#define UIF_PAD_SOURCE				1
+
+struct vsp1_uif {
+	struct vsp1_entity entity;
+	bool m3w_quirk;
+};
+
+static inline struct vsp1_uif *to_uif(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_uif, entity.subdev);
+}
+
+struct vsp1_uif *vsp1_uif_create(struct vsp1_device *vsp1, unsigned int index);
+u32 vsp1_uif_get_crc(struct vsp1_uif *uif);
+
+#endif /* __VSP1_UIF_H__ */
-- 
Regards,

Laurent Pinchart
