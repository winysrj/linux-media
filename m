Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44963 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752426AbdB1P7n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:59:43 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Subject: [PATCH v3 6/8] v4l: vsp1: Add HGO support
Date: Tue, 28 Feb 2017 17:56:46 +0200
Message-Id: <20170228155648.12051-7-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170228155648.12051-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HGO is a Histogram Generator One-Dimension. It computes per-channel
histograms over a configurable region of the image with optional
subsampling.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/Makefile      |   2 +-
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_drv.c    |  42 ++++--
 drivers/media/platform/vsp1/vsp1_entity.c |  16 +++
 drivers/media/platform/vsp1/vsp1_hgo.c    | 228 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h    |  45 ++++++
 drivers/media/platform/vsp1/vsp1_pipe.c   |  16 +++
 drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h   |  20 ++-
 drivers/media/platform/vsp1/vsp1_video.c  |   6 +
 10 files changed, 367 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h

diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index c559536f7867..8ab6a063569e 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -3,7 +3,7 @@ vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_clu.o vsp1_hsit.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
-vsp1-y					+= vsp1_histo.o
+vsp1-y					+= vsp1_hgo.o vsp1_histo.o
 vsp1-y					+= vsp1_lif.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index b23fa879a9aa..0ba7521c01b4 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -32,6 +32,7 @@ struct vsp1_entity;
 struct vsp1_platform_data;
 struct vsp1_bru;
 struct vsp1_clu;
+struct vsp1_hgo;
 struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_lut;
@@ -50,6 +51,7 @@ struct vsp1_uds;
 #define VSP1_HAS_CLU		(1 << 4)
 #define VSP1_HAS_WPF_VFLIP	(1 << 5)
 #define VSP1_HAS_WPF_HFLIP	(1 << 6)
+#define VSP1_HAS_HGO		(1 << 7)
 
 struct vsp1_device_info {
 	u32 version;
@@ -73,6 +75,7 @@ struct vsp1_device {
 
 	struct vsp1_bru *bru;
 	struct vsp1_clu *clu;
+	struct vsp1_hgo *hgo;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 83a6669a6328..0acc8ed6ac59 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -30,6 +30,7 @@
 #include "vsp1_clu.h"
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
+#include "vsp1_hgo.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
@@ -150,6 +151,16 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
+	if (vsp1->hgo) {
+		ret = media_create_pad_link(&vsp1->hgo->histo.entity.subdev.entity,
+					    HISTO_PAD_SOURCE,
+					    &vsp1->hgo->histo.video.entity, 0,
+					    MEDIA_LNK_FL_ENABLED |
+					    MEDIA_LNK_FL_IMMUTABLE);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (vsp1->lif) {
 		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
 					    RWPF_PAD_SOURCE,
@@ -283,6 +294,17 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
+	if (vsp1->info->features & VSP1_HAS_HGO && vsp1->info->uapi) {
+		vsp1->hgo = vsp1_hgo_create(vsp1);
+		if (IS_ERR(vsp1->hgo)) {
+			ret = PTR_ERR(vsp1->hgo);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->hgo->histo.entity.list_dev,
+			      &vsp1->entities);
+	}
+
 	/*
 	 * The LIF is only supported when used in conjunction with the DU, in
 	 * which case the userspace API is disabled. If the userspace API is
@@ -568,8 +590,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
 		.model = "VSP1-S",
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -589,7 +611,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
 		.model = "VSP1-D",
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
+		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LIF
+			  | VSP1_HAS_LUT,
 		.rpf_count = 4,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -599,8 +622,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
 		.model = "VSP1-S",
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
-			  | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT | VSP1_HAS_SRU | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.uds_count = 1,
 		.wpf_count = 4,
@@ -632,8 +655,9 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.model = "VSP2-I",
 		.gen = 3,
-		.features = VSP1_HAS_CLU | VSP1_HAS_LUT | VSP1_HAS_SRU
-			  | VSP1_HAS_WPF_HFLIP | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_CLU | VSP1_HAS_HGO | VSP1_HAS_LUT
+			  | VSP1_HAS_SRU | VSP1_HAS_WPF_HFLIP
+			  | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 1,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -651,8 +675,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
 		.model = "VSP2-BC",
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_LUT
-			  | VSP1_HAS_WPF_VFLIP,
+		.features = VSP1_HAS_BRU | VSP1_HAS_CLU | VSP1_HAS_HGO
+			  | VSP1_HAS_LUT | VSP1_HAS_WPF_VFLIP,
 		.rpf_count = 5,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 88a2aae182ba..c1587e3f01cb 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -37,6 +37,21 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 	struct vsp1_entity *source;
 	struct vsp1_entity *sink;
 
+	if (entity->type == VSP1_ENTITY_HGO) {
+		u32 smppt;
+
+		/*
+		 * The HGO is a special case, its routing is configured on the
+		 * sink pad.
+		 */
+		source = media_entity_to_vsp1_entity(entity->sources[0]);
+		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
+		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
+
+		vsp1_dl_list_write(dl, VI6_DPR_HGO_SMPPT, smppt);
+		return;
+	}
+
 	source = entity;
 	if (source->route->reg == 0)
 		return;
@@ -427,6 +442,7 @@ static const struct vsp1_route vsp1_routes[] = {
 	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
 	    VI6_DPR_NODE_BRU_IN(4) }, VI6_DPR_NODE_BRU_OUT },
 	VSP1_ENTITY_ROUTE(CLU),
+	{ VSP1_ENTITY_HGO, 0, 0, { 0, }, 0 },
 	VSP1_ENTITY_ROUTE(HSI),
 	VSP1_ENTITY_ROUTE(HST),
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, }, VI6_DPR_NODE_LIF },
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
new file mode 100644
index 000000000000..a138c6b7fb05
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -0,0 +1,228 @@
+/*
+ * vsp1_hgo.c  --  R-Car VSP1 Histogram Generator 1D
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
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
+#include <media/videobuf2-vmalloc.h>
+
+#include "vsp1.h"
+#include "vsp1_dl.h"
+#include "vsp1_hgo.h"
+
+#define HGO_DATA_SIZE				((2 + 256) * 4)
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_hgo_read(struct vsp1_hgo *hgo, u32 reg)
+{
+	return vsp1_read(hgo->histo.entity.vsp1, reg);
+}
+
+static inline void vsp1_hgo_write(struct vsp1_hgo *hgo, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
+{
+	vsp1_dl_list_write(dl, reg, data);
+}
+
+/* -----------------------------------------------------------------------------
+ * Frame End Handler
+ */
+
+void vsp1_hgo_frame_end(struct vsp1_entity *entity)
+{
+	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
+	struct vsp1_histogram_buffer *buf;
+	unsigned int i;
+	size_t size;
+	u32 *data;
+
+	buf = vsp1_histogram_buffer_get(&hgo->histo);
+	if (!buf)
+		return;
+
+	data = buf->addr;
+
+	if (hgo->num_bins == 256) {
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_MAXMIN);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_SUM);
+
+		for (i = 0; i < 256; ++i) {
+			vsp1_write(hgo->histo.entity.vsp1,
+				   VI6_HGO_EXT_HIST_ADDR, i);
+			*data++ = vsp1_hgo_read(hgo, VI6_HGO_EXT_HIST_DATA);
+		}
+
+		size = (2 + 256) * sizeof(u32);
+	} else if (hgo->max_rgb) {
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_MAXMIN);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_SUM);
+
+		for (i = 0; i < 64; ++i)
+			*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_HISTO(i));
+
+		size = (2 + 64) * sizeof(u32);
+	} else {
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_R_MAXMIN);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_MAXMIN);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_B_MAXMIN);
+
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_R_SUM);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_G_SUM);
+		*data++ = vsp1_hgo_read(hgo, VI6_HGO_B_SUM);
+
+		for (i = 0; i < 64; ++i) {
+			data[i] = vsp1_hgo_read(hgo, VI6_HGO_R_HISTO(i));
+			data[i+64] = vsp1_hgo_read(hgo, VI6_HGO_G_HISTO(i));
+			data[i+128] = vsp1_hgo_read(hgo, VI6_HGO_B_HISTO(i));
+		}
+
+		size = (6 + 64 * 3) * sizeof(u32);
+	}
+
+	vsp1_histogram_buffer_complete(&hgo->histo, buf, size);
+}
+
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+#define V4L2_CID_VSP1_HGO_MAX_RGB		(V4L2_CID_USER_BASE | 0x1001)
+#define V4L2_CID_VSP1_HGO_NUM_BINS		(V4L2_CID_USER_BASE | 0x1002)
+
+static const struct v4l2_ctrl_config hgo_max_rgb_control = {
+	.id = V4L2_CID_VSP1_HGO_MAX_RGB,
+	.name = "Maximum RGB Mode",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.def = 0,
+	.step = 1,
+};
+
+static const s64 hgo_num_bins[] = {
+	64, 256,
+};
+
+static const struct v4l2_ctrl_config hgo_num_bins_control = {
+	.id = V4L2_CID_VSP1_HGO_NUM_BINS,
+	.name = "Number of Bins",
+	.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+	.min = 0,
+	.max = 1,
+	.def = 0,
+	.qmenu_int = hgo_num_bins,
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void hgo_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
+{
+	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
+	struct v4l2_rect *compose;
+	struct v4l2_rect *crop;
+	unsigned int hratio;
+	unsigned int vratio;
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
+	vsp1_hgo_write(hgo, dl, VI6_HGO_REGRST, VI6_HGO_REGRST_RCLEA);
+
+	vsp1_hgo_write(hgo, dl, VI6_HGO_OFFSET,
+		       (crop->left << VI6_HGO_OFFSET_HOFFSET_SHIFT) |
+		       (crop->top << VI6_HGO_OFFSET_VOFFSET_SHIFT));
+	vsp1_hgo_write(hgo, dl, VI6_HGO_SIZE,
+		       (crop->width << VI6_HGO_SIZE_HSIZE_SHIFT) |
+		       (crop->height << VI6_HGO_SIZE_VSIZE_SHIFT));
+
+	mutex_lock(hgo->ctrls.handler.lock);
+	hgo->max_rgb = hgo->ctrls.max_rgb->cur.val;
+	if (hgo->ctrls.num_bins)
+		hgo->num_bins = hgo_num_bins[hgo->ctrls.num_bins->cur.val];
+	mutex_unlock(hgo->ctrls.handler.lock);
+
+	hratio = crop->width * 2 / compose->width / 3;
+	vratio = crop->height * 2 / compose->height / 3;
+	vsp1_hgo_write(hgo, dl, VI6_HGO_MODE,
+		       (hgo->num_bins == 256 ? VI6_HGO_MODE_STEP : 0) |
+		       (hgo->max_rgb ? VI6_HGO_MODE_MAXRGB : 0) |
+		       (hratio << VI6_HGO_MODE_HRATIO_SHIFT) |
+		       (vratio << VI6_HGO_MODE_VRATIO_SHIFT));
+}
+
+static const struct vsp1_entity_operations hgo_entity_ops = {
+	.configure = hgo_configure,
+	.destroy = vsp1_histogram_destroy,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
+
+static const unsigned int hgo_mbus_formats[] = {
+	MEDIA_BUS_FMT_AYUV8_1X32,
+	MEDIA_BUS_FMT_ARGB8888_1X32,
+	MEDIA_BUS_FMT_AHSV8888_1X32,
+};
+
+struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1)
+{
+	struct vsp1_hgo *hgo;
+	int ret;
+
+	hgo = devm_kzalloc(vsp1->dev, sizeof(*hgo), GFP_KERNEL);
+	if (hgo == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&hgo->ctrls.handler,
+			       vsp1->info->gen == 3 ? 2 : 1);
+	hgo->ctrls.max_rgb = v4l2_ctrl_new_custom(&hgo->ctrls.handler,
+						  &hgo_max_rgb_control, NULL);
+	if (vsp1->info->gen == 3)
+		hgo->ctrls.num_bins =
+			v4l2_ctrl_new_custom(&hgo->ctrls.handler,
+					     &hgo_num_bins_control, NULL);
+
+	hgo->max_rgb = false;
+	hgo->num_bins = 64;
+
+	hgo->histo.entity.subdev.ctrl_handler = &hgo->ctrls.handler;
+
+	/* Initialize the video device and queue for statistics data. */
+	ret = vsp1_histogram_init(vsp1, &hgo->histo, VSP1_ENTITY_HGO, "hgo",
+				  &hgo_entity_ops, hgo_mbus_formats,
+				  ARRAY_SIZE(hgo_mbus_formats),
+				  HGO_DATA_SIZE, V4L2_META_FMT_VSP1_HGO);
+	if (ret < 0) {
+		vsp1_entity_destroy(&hgo->histo.entity);
+		return ERR_PTR(ret);
+	}
+
+	return hgo;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.h b/drivers/media/platform/vsp1/vsp1_hgo.h
new file mode 100644
index 000000000000..c6c0b7a80e0c
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgo.h
@@ -0,0 +1,45 @@
+/*
+ * vsp1_hgo.h  --  R-Car VSP1 Histogram Generator 1D
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_HGO_H__
+#define __VSP1_HGO_H__
+
+#include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+
+#include "vsp1_histo.h"
+
+struct vsp1_device;
+
+struct vsp1_hgo {
+	struct vsp1_histogram histo;
+
+	struct {
+		struct v4l2_ctrl_handler handler;
+		struct v4l2_ctrl *max_rgb;
+		struct v4l2_ctrl *num_bins;
+	} ctrls;
+
+	bool max_rgb;
+	unsigned int num_bins;
+};
+
+static inline struct vsp1_hgo *to_hgo(struct v4l2_subdev *subdev)
+{
+	return container_of(subdev, struct vsp1_hgo, histo.entity.subdev);
+}
+
+struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1);
+void vsp1_hgo_frame_end(struct vsp1_entity *hgo);
+
+#endif /* __VSP1_HGO_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 1c74f86d1d43..e8615868ab43 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -23,6 +23,7 @@
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
+#include "vsp1_hgo.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
@@ -198,11 +199,18 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
 		pipe->output = NULL;
 	}
 
+	if (pipe->hgo) {
+		struct vsp1_hgo *hgo = to_hgo(&pipe->hgo->subdev);
+
+		hgo->histo.pipe = NULL;
+	}
+
 	INIT_LIST_HEAD(&pipe->entities);
 	pipe->state = VSP1_PIPELINE_STOPPED;
 	pipe->buffers_ready = 0;
 	pipe->num_inputs = 0;
 	pipe->bru = NULL;
+	pipe->hgo = NULL;
 	pipe->lif = NULL;
 	pipe->uds = NULL;
 }
@@ -280,6 +288,11 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 				   VI6_DPR_NODE_UNUSED);
 	}
 
+	if (pipe->hgo)
+		vsp1_write(vsp1, VI6_DPR_HGO_SMPPT,
+			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+			   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+
 	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 0);
 
 	return ret;
@@ -303,6 +316,9 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	vsp1_dlm_irq_frame_end(pipe->output->dlm);
 
+	if (pipe->hgo)
+		vsp1_hgo_frame_end(pipe->hgo);
+
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 1144bf1e671a..4d91088c386b 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -73,6 +73,7 @@ enum vsp1_pipeline_state {
  * @inputs: array of RPFs in the pipeline (indexed by RPF index)
  * @output: WPF at the output of the pipeline
  * @bru: BRU entity, if present
+ * @hgo: HGO entity, if present
  * @lif: LIF entity, if present
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
@@ -101,6 +102,7 @@ struct vsp1_pipeline {
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
+	struct vsp1_entity *hgo;
 	struct vsp1_entity *lif;
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 61369e267667..5414e519f7d8 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -590,24 +590,38 @@
  */
 
 #define VI6_HGO_OFFSET			0x3000
+#define VI6_HGO_OFFSET_HOFFSET_SHIFT	16
+#define VI6_HGO_OFFSET_VOFFSET_SHIFT	0
 #define VI6_HGO_SIZE			0x3004
+#define VI6_HGO_SIZE_HSIZE_SHIFT	16
+#define VI6_HGO_SIZE_VSIZE_SHIFT	0
 #define VI6_HGO_MODE			0x3008
+#define VI6_HGO_MODE_STEP		(1 << 10)
+#define VI6_HGO_MODE_MAXRGB		(1 << 7)
+#define VI6_HGO_MODE_OFSB_R		(1 << 6)
+#define VI6_HGO_MODE_OFSB_G		(1 << 5)
+#define VI6_HGO_MODE_OFSB_B		(1 << 4)
+#define VI6_HGO_MODE_HRATIO_SHIFT	2
+#define VI6_HGO_MODE_VRATIO_SHIFT	0
 #define VI6_HGO_LB_TH			0x300c
 #define VI6_HGO_LBn_H(n)		(0x3010 + (n) * 8)
 #define VI6_HGO_LBn_V(n)		(0x3014 + (n) * 8)
-#define VI6_HGO_R_HISTO			0x3030
+#define VI6_HGO_R_HISTO(n)		(0x3030 + (n) * 4)
 #define VI6_HGO_R_MAXMIN		0x3130
 #define VI6_HGO_R_SUM			0x3134
 #define VI6_HGO_R_LB_DET		0x3138
-#define VI6_HGO_G_HISTO			0x3140
+#define VI6_HGO_G_HISTO(n)		(0x3140 + (n) * 4)
 #define VI6_HGO_G_MAXMIN		0x3240
 #define VI6_HGO_G_SUM			0x3244
 #define VI6_HGO_G_LB_DET		0x3248
-#define VI6_HGO_B_HISTO			0x3250
+#define VI6_HGO_B_HISTO(n)		(0x3250 + (n) * 4)
 #define VI6_HGO_B_MAXMIN		0x3350
 #define VI6_HGO_B_SUM			0x3354
 #define VI6_HGO_B_LB_DET		0x3358
+#define VI6_HGO_EXT_HIST_ADDR		0x335c
+#define VI6_HGO_EXT_HIST_DATA		0x3360
 #define VI6_HGO_REGRST			0x33fc
+#define VI6_HGO_REGRST_RCLEA		(1 << 0)
 
 /* -----------------------------------------------------------------------------
  * HGT Control Registers
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 86c33994468b..7bc07d438367 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -31,6 +31,7 @@
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
+#include "vsp1_hgo.h"
 #include "vsp1_pipe.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_uds.h"
@@ -601,6 +602,11 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 			pipe->lif = e;
 		} else if (e->type == VSP1_ENTITY_BRU) {
 			pipe->bru = e;
+		} else if (e->type == VSP1_ENTITY_HGO) {
+			struct vsp1_hgo *hgo = to_hgo(subdev);
+
+			pipe->hgo = e;
+			hgo->histo.pipe = pipe;
 		}
 	}
 
-- 
Regards,

Laurent Pinchart
