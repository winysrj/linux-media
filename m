Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44963 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbdB1P7p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:59:45 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH v3 8/8] v4l: vsp1: Add HGT support
Date: Tue, 28 Feb 2017 17:56:48 +0200
Message-Id: <20170228155648.12051-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The HGT is a Histogram Generator Two-Dimensions. It computes a weighted
frequency histograms for hue and saturation areas over a configurable
region of the image with optional subsampling.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  32 ++++-
 drivers/media/platform/vsp1/vsp1_entity.c |  14 ++
 drivers/media/platform/vsp1/vsp1_hgt.c    | 222 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgt.h    |  42 ++++++
 drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +++
 drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h   |   9 ++
 drivers/media/platform/vsp1/vsp1_video.c  |   6 +
 10 files changed, 343 insertions(+), 5 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgt.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 8ab6a063569e..a33afc385a48 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -3,7 +3,7 @@ vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
-vsp1-y					+= vsp1_hgo.o vsp1_histo.o
+vsp1-y					+= vsp1_hgo.o vsp1_hgt.o vsp1_histo.o
 vsp1-y					+= vsp1_lif.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 0ba7521c01b4..85387a64179a 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -33,6 +33,7 @@ struct vsp1_platform_data;
 struct vsp1_bru;
 struct vsp1_clu;
 struct vsp1_hgo;
+struct vsp1_hgt;
 struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_lut;
@@ -52,6 +53,7 @@ struct vsp1_uds;
 #define VSP1_HAS_WPF_VFLIP	(1 << 5)
 #define VSP1_HAS_WPF_HFLIP	(1 << 6)
 #define VSP1_HAS_HGO		(1 << 7)
+#define VSP1_HAS_HGT		(1 << 8)
 
 struct vsp1_device_info {
 	u32 version;
@@ -76,6 +78,7 @@ struct vsp1_device {
 	struct vsp1_bru *bru;
 	struct vsp1_clu *clu;
 	struct vsp1_hgo *hgo;
+	struct vsp1_hgt *hgt;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 0acc8ed6ac59..048446af5ae7 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -31,6 +31,7 @@
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
 #include "vsp1_hgo.h"
+#include "vsp1_hgt.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
@@ -161,6 +162,16 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
+	if (vsp1->hgt) {
+		ret = media_create_pad_link(&vsp1->hgt->histo.entity.subdev.entity,
+					    HISTO_PAD_SOURCE,
+					    &vsp1->hgt->histo.video.entity, 0,
+					    MEDIA_LNK_FL_ENABLED |
+					    MEDIA_LNK_FL_IMMUTABLE);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (vsp1->lif) {
 		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
 					    RWPF_PAD_SOURCE,
@@ -305,6 +316,17 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			      &vsp1->entities);
 	}
 
+	if (vsp1->info->features & VSP1_HAS_HGT && vsp1->info->uapi) {
+		vsp1->hgt = vsp1_hgt_create(vsp1);
+		if (IS_ERR(vsp1->hgt)) {
+			ret = PTR_ERR(vsp1->hgt);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->hgt->histo.entity.list_dev,
+			      &vsp1->entities);
+	}
+
 	/*
 	 * The LIF is only supported when used in conjunction with the DU, in
 	 * which case the userspace API is disabled. If the userspace API is
@@ -591,7 +613,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
-			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
+			  | VSP1_HAS_HGT | VSP1_HAS_LUT | VSP1_HAS_SRU
+			  | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -623,7 +646,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.model = "VSP1-S",
 		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
-			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
+			  | VSP1_HAS_HGT | VSP1_HAS_LUT | VSP1_HAS_SRU
+			  | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 1,
 		.wpf_count = 4,
@@ -655,8 +679,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.model = "VSP2-I",
 		.gen = 3,
-		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU | VSP1_HAS_WPF_HFLIP
+		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_HGT
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_HFLIP
 			  | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 1,
 		.uds_count = 1,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index c1587e3f01cb..4bdb3b141611 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -50,6 +50,19 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 
 		vsp1_dl_list_write(dl, VI6_DPR_HGO_SMPPT, smppt);
 		return;
+	} else if (entity->type == VSP1_ENTITY_HGT) {
+		u32 smppt;
+
+		/*
+		 * The HGT is a special case, its routing is configured on the
+		 * sink pad.
+		 */
+		source = media_entity_to_vsp1_entity(entity->sources[0]);
+		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
+		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
+
+		vsp1_dl_list_write(dl, VI6_DPR_HGT_SMPPT, smppt);
+		return;
 	}
 
 	source = entity;
@@ -443,6 +456,7 @@ static const struct vsp1_route vsp1_routes[] = {
 	    VI6_DPR_NODE_BRU_IN(4) }, VI6_DPR_NODE_BRU_OUT },
 	VSP1_ENTITY_ROUTE(CLU),
 	{ VSP1_ENTITY_HGO, 0, 0, { 0, }, 0 },
+	{ VSP1_ENTITY_HGT, 0, 0, { 0, }, 0 },
 	VSP1_ENTITY_ROUTE(HSI),
 	VSP1_ENTITY_ROUTE(HST),
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, }, VI6_DPR_NODE_LIF },
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
new file mode 100644
index 000000000000..b5ce305e3e6f
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgt.c
@@ -0,0 +1,222 @@
+/*
+ * vsp1_hgt.c  --  R-Car VSP1 Histogram Generator 2D
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ *
+ * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
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
+#include <media/videobuf2-vmalloc.h>
+
+#include "vsp1.h"
+#include "vsp1_dl.h"
+#include "vsp1_hgt.h"
+
+#define HGT_DATA_SIZE				((2 +  6 * 32) * 4)
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_hgt_read(struct vsp1_hgt *hgt, u32 reg)
+{
+	return vsp1_read(hgt->histo.entity.vsp1, reg);
+}
+
+static inline void vsp1_hgt_write(struct vsp1_hgt *hgt, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
+{
+	vsp1_dl_list_write(dl, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * Frame End Handler
+ */
+
+void vsp1_hgt_frame_end(struct vsp1_entity *entity)
+{
+	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
+	struct vsp1_histogram_buffer *buf;
+	unsigned int m;
+	unsigned int n;
+	u32 *data;
+
+	buf = vsp1_histogram_buffer_get(&hgt->histo);
+	if (!buf)
+		return;
+
+	data = buf->addr;
+
+	*data++ = vsp1_hgt_read(hgt, VI6_HGT_MAXMIN);
+	*data++ = vsp1_hgt_read(hgt, VI6_HGT_SUM);
+
+	for (m = 0; m < 6; ++m)
+		for (n = 0; n < 32; ++n)
+			*data++ = vsp1_hgt_read(hgt, VI6_HGT_HISTO(m, n));
+
+	vsp1_histogram_buffer_complete(&hgt->histo, buf, HGT_DATA_SIZE);
+}
+
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+#define V4L2_CID_VSP1_HGT_HUE_AREAS	(V4L2_CID_USER_BASE | 0x1001)
+
+static int hgt_hue_areas_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	const u8 *values = ctrl->p_new.p_u8;
+	unsigned int i;
+
+	/*
+	 * The hardware has constraints on the hue area boundaries beyond the
+	 * control min, max and step. The values must match one of the following
+	 * expressions.
+	 *
+	 * 0L <= 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 5U
+	 * 0U <= 1L <= 1U <= 2L <= 2U <= 3L <= 3U <= 4L <= 4U <= 5L <= 5U <= 0L
+	 *
+	 * Start by verifying the common part...
+	 */
+	for (i = 1; i < (HGT_NUM_HUE_AREAS * 2) - 1; ++i) {
+		if (values[i] > values[i+1])
+			return -EINVAL;
+	}
+
+	/* ... and handle 0L separately. */
+	if (values[0] > values[1] && values[11] > values[0])
+		return -EINVAL;
+
+	return 0;
+}
+
+static int hgt_hue_areas_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_hgt *hgt = container_of(ctrl->handler, struct vsp1_hgt,
+					    ctrls);
+
+	memcpy(hgt->hue_areas, ctrl->p_new.p_u8, sizeof(hgt->hue_areas));
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops hgt_hue_areas_ctrl_ops = {
+	.try_ctrl = hgt_hue_areas_try_ctrl,
+	.s_ctrl = hgt_hue_areas_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config hgt_hue_areas = {
+	.ops = &hgt_hue_areas_ctrl_ops,
+	.id = V4L2_CID_VSP1_HGT_HUE_AREAS,
+	.name = "Boundary Values for Hue Area",
+	.type = V4L2_CTRL_TYPE_U8,
+	.min = 0,
+	.max = 255,
+	.def = 0,
+	.step = 1,
+	.dims = { 12 },
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void hgt_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
+{
+	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
+	struct v4l2_rect *compose;
+	struct v4l2_rect *crop;
+	unsigned int hratio;
+	unsigned int vratio;
+	u8 lower;
+	u8 upper;
+	unsigned int i;
+
+	if (params != VSP1_ENTITY_PARAMS_INIT)
+		return;
+
+	crop = vsp1_entity_get_pad_selection(entity, entity->config,
+					     HISTO_PAD_SINK, V4L2_SEL_TGT_CROP);
+	compose = vsp1_entity_get_pad_selection(entity, entity->config,
+						HISTO_PAD_SINK,
+						V4L2_SEL_TGT_COMPOSE);
+
+	vsp1_hgt_write(hgt, dl, VI6_HGT_REGRST, VI6_HGT_REGRST_RCLEA);
+
+	vsp1_hgt_write(hgt, dl, VI6_HGT_OFFSET,
+		       (crop->left << VI6_HGT_OFFSET_HOFFSET_SHIFT) |
+		       (crop->top << VI6_HGT_OFFSET_VOFFSET_SHIFT));
+	vsp1_hgt_write(hgt, dl, VI6_HGT_SIZE,
+		       (crop->width << VI6_HGT_SIZE_HSIZE_SHIFT) |
+		       (crop->height << VI6_HGT_SIZE_VSIZE_SHIFT));
+
+	mutex_lock(hgt->ctrls.lock);
+	for (i = 0; i < HGT_NUM_HUE_AREAS; ++i) {
+		lower = hgt->hue_areas[i*2 + 0];
+		upper = hgt->hue_areas[i*2 + 1];
+		vsp1_hgt_write(hgt, dl, VI6_HGT_HUE_AREA(i),
+			       (lower << VI6_HGT_HUE_AREA_LOWER_SHIFT) |
+			       (upper << VI6_HGT_HUE_AREA_UPPER_SHIFT));
+	}
+	mutex_unlock(hgt->ctrls.lock);
+
+	hratio = crop->width * 2 / compose->width / 3;
+	vratio = crop->height * 2 / compose->height / 3;
+	vsp1_hgt_write(hgt, dl, VI6_HGT_MODE,
+		       (hratio << VI6_HGT_MODE_HRATIO_SHIFT) |
+		       (vratio << VI6_HGT_MODE_VRATIO_SHIFT));
+}
+
+static const struct vsp1_entity_operations hgt_entity_ops = {
+	.configure = hgt_configure,
+	.destroy = vsp1_histogram_destroy,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+static const unsigned int hgt_mbus_formats[] = {
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+};
+
+struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1)
+{
+	struct vsp1_hgt *hgt;
+	int ret;
+
+	hgt = devm_kzalloc(vsp1->dev, sizeof(*hgt), GFP_KERNEL);
+	if (hgt == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&hgt->ctrls, 1);
+	v4l2_ctrl_new_custom(&hgt->ctrls, &hgt_hue_areas, NULL);
+
+	hgt->histo.entity.subdev.ctrl_handler = &hgt->ctrls;
+
+	/* Initialize the video device and queue for statistics data. */
+	ret = vsp1_histogram_init(vsp1, &hgt->histo, VSP1_ENTITY_HGT, "hgt",
+				  &hgt_entity_ops, hgt_mbus_formats,
+				  ARRAY_SIZE(hgt_mbus_formats),
+				  HGT_DATA_SIZE, V4L2_META_FMT_VSP1_HGT);
+	if (ret < 0) {
+		vsp1_entity_destroy(&hgt->histo.entity);
+		return ERR_PTR(ret);
+	}
+
+	v4l2_ctrl_handler_setup(&hgt->ctrls);
+
+	return hgt;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.h b/drivers/media/platform/vsp1/vsp1_hgt.h
new file mode 100644
index 000000000000..83f2e130942a
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgt.h
@@ -0,0 +1,42 @@
+/*
+ * vsp1_hgt.h  --  R-Car VSP1 Histogram Generator 2D
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ *
+ * Contact: Niklas Söderlund (niklas.soderlund@ragnatech.se)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_HGT_H__
+#define __VSP1_HGT_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_histo.h"
+
+struct vsp1_device;
+
+#define HGT_NUM_HUE_AREAS			6
+
+struct vsp1_hgt {
+	struct vsp1_histogram histo;
+
+	struct v4l2_ctrl_handler ctrls;
+
+	u8 hue_areas[HGT_NUM_HUE_AREAS * 2];
+};
+
+static inline struct vsp1_hgt *to_hgt(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_hgt, histo.entity.subdev);
+}
+
+struct vsp1_hgt *vsp1_hgt_create(struct vsp1_device *vsp1);
+void vsp1_hgt_frame_end(struct vsp1_entity *hgt);
+
+#endif /* __VSP1_HGT_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index e8615868ab43..7e667ebae171 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -24,6 +24,7 @@
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_hgo.h"
+#include "vsp1_hgt.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
@@ -205,12 +206,19 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 		hgo->histo.pipe = NULL;
 	}
 
+	if (pipe->hgt) {
+		struct vsp1_hgt *hgt = to_hgt(&pipe->hgt->subdev);
+
+		hgt->histo.pipe = NULL;
+	}
+
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
 	pipe->num_inputs = 0;
 	pipe->bru = NULL;
 	pipe->hgo = NULL;
+	pipe->hgt = NULL;
 	pipe->lif = NULL;
 	pipe->uds = NULL;
 }
@@ -293,6 +301,11 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
 			   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
 
+	if (pipe->hgt)
+		vsp1_write(vsp1, VI6_DPR_HGT_SMPPT,
+			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+			   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+
 	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 0);
 
 	return ret;
@@ -319,6 +332,9 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	if (pipe->hgo)
 		vsp1_hgo_frame_end(pipe->hgo);
 
+	if (pipe->hgt)
+		vsp1_hgt_frame_end(pipe->hgt);
+
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 4d91088c386b..91a784a13422 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -74,6 +74,7 @@ enum vsp1_pipeline_state {
  * @output: WPF at the output of the pipeline
  * @bru: BRU entity, if present
  * @hgo: HGO entity, if present
+ * @hgt: HGT entity, if present
  * @lif: LIF entity, if present
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
@@ -103,6 +104,7 @@ struct vsp1_pipeline {
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
 	struct vsp1_entity *hgo;
+	struct vsp1_entity *hgt;
 	struct vsp1_entity *lif;
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 5414e519f7d8..cd3e32af6e3b 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -628,9 +628,17 @@
  */
 
 #define VI6_HGT_OFFSET			0x3400
+#define VI6_HGT_OFFSET_HOFFSET_SHIFT	16
+#define VI6_HGT_OFFSET_VOFFSET_SHIFT	0
 #define VI6_HGT_SIZE			0x3404
+#define VI6_HGT_SIZE_HSIZE_SHIFT	16
+#define VI6_HGT_SIZE_VSIZE_SHIFT	0
 #define VI6_HGT_MODE			0x3408
+#define VI6_HGT_MODE_HRATIO_SHIFT	2
+#define VI6_HGT_MODE_VRATIO_SHIFT	0
 #define VI6_HGT_HUE_AREA(n)		(0x340c + (n) * 4)
+#define VI6_HGT_HUE_AREA_LOWER_SHIFT	16
+#define VI6_HGT_HUE_AREA_UPPER_SHIFT	0
 #define VI6_HGT_LB_TH			0x3424
 #define VI6_HGT_LBn_H(n)		(0x3438 + (n) * 8)
 #define VI6_HGT_LBn_V(n)		(0x342c + (n) * 8)
@@ -639,6 +647,7 @@
 #define VI6_HGT_SUM			0x3754
 #define VI6_HGT_LB_DET			0x3758
 #define VI6_HGT_REGRST			0x37fc
+#define VI6_HGT_REGRST_RCLEA		(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * LIF Control Registers
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 7bc07d438367..eab3c3ea85d7 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -32,6 +32,7 @@
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
 #include "vsp1_hgo.h"
+#include "vsp1_hgt.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
@@ -607,6 +608,11 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 
 			pipe->hgo = e;
 			hgo->histo.pipe = pipe;
+		} else if (e->type == VSP1_ENTITY_HGT) {
+			struct vsp1_hgt *hgt = to_hgt(subdev);
+
+			pipe->hgt = e;
+			hgt->histo.pipe = pipe;
 		}
 	}
 
-- 
Regards,

Laurent Pinchart
