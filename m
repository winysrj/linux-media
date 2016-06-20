Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbcFTTLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:11:43 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 03/24] v4l: vsp1: Add HGO support
Date: Mon, 20 Jun 2016 22:10:21 +0300
Message-Id: <1466449842-29502-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HGO is a Histogram Generator One-Dimension. It computes per-channel
histograms over a configurable region of the image with optional
subsampling.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/Kconfig            |   1 +
 drivers/media/platform/vsp1/Makefile      |   2 +
 drivers/media/platform/vsp1/vsp1.h        |   3 +
 drivers/media/platform/vsp1/vsp1_drm.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |  37 ++-
 drivers/media/platform/vsp1/vsp1_entity.c | 136 +++++++-
 drivers/media/platform/vsp1/vsp1_entity.h |   7 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    | 496 ++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_hgo.h    |  50 +++
 drivers/media/platform/vsp1/vsp1_histo.c  | 307 ++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_histo.h  |  68 ++++
 drivers/media/platform/vsp1/vsp1_pipe.c   |  30 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   2 +
 drivers/media/platform/vsp1/vsp1_regs.h   |  24 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  22 +-
 15 files changed, 1148 insertions(+), 39 deletions(-)
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_hgo.h
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.c
 create mode 100644 drivers/media/platform/vsp1/vsp1_histo.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index a3304466e628..0141af8cfdbc 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -266,6 +266,7 @@ config VIDEO_RENESAS_VSP1
 	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
 	depends on !ARM64 || VIDEO_RENESAS_FCP
 	select VIDEOBUF2_DMA_CONTIG
+	select VIDEOBUF2_VMALLOC
 	---help---
 	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
 
diff --git a/drivers/media/platform/vsp1/Makefile b/drivers/media/platform/vsp1/Makefile
index 95b3ac2ea7ef..a12356bf2135 100644
--- a/drivers/media/platform/vsp1/Makefile
+++ b/drivers/media/platform/vsp1/Makefile
@@ -3,5 +3,7 @@ vsp1-y					+= vsp1_dl.o vsp1_drm.o vsp1_video.o
 vsp1-y					+= vsp1_rpf.o vsp1_rwpf.o vsp1_wpf.o
 vsp1-y					+= vsp1_hsit.o vsp1_lif.o vsp1_lut.o
 vsp1-y					+= vsp1_bru.o vsp1_sru.o vsp1_uds.o
+vsp1-y					+= vsp1_hgo.o vsp1_histo.o
+vsp1-y					+= vsp1_lif.o
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1.o
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 7cb0f5e428df..6bf6d54c0ae4 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -31,6 +31,7 @@ struct vsp1_drm;
 struct vsp1_entity;
 struct vsp1_platform_data;
 struct vsp1_bru;
+struct vsp1_hgo;
 struct vsp1_hsit;
 struct vsp1_lif;
 struct vsp1_lut;
@@ -46,6 +47,7 @@ struct vsp1_uds;
 #define VSP1_HAS_LUT		(1 << 1)
 #define VSP1_HAS_SRU		(1 << 2)
 #define VSP1_HAS_BRU		(1 << 3)
+#define VSP1_HAS_HGO		(1 << 4)
 
 struct vsp1_device_info {
 	u32 version;
@@ -66,6 +68,7 @@ struct vsp1_device {
 	struct rcar_fcp_device *fcp;
 
 	struct vsp1_bru *bru;
+	struct vsp1_hgo *hgo;
 	struct vsp1_hsit *hsi;
 	struct vsp1_hsit *hst;
 	struct vsp1_lif *lif;
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 14730119687f..ff961b2c084e 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -489,7 +489,7 @@ void vsp1_du_atomic_flush(struct device *dev)
 			}
 		}
 
-		vsp1_entity_route_setup(entity, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, pipe->dl);
 
 		if (entity->ops->configure)
 			entity->ops->configure(entity, pipe, pipe->dl);
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 70e7a81e8255..3e94e1921656 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -29,6 +29,7 @@
 #include "vsp1_bru.h"
 #include "vsp1_dl.h"
 #include "vsp1_drm.h"
+#include "vsp1_hgo.h"
 #include "vsp1_hsit.h"
 #include "vsp1_lif.h"
 #include "vsp1_lut.h"
@@ -104,7 +105,8 @@ static int vsp1_create_sink_links(struct vsp1_device *vsp1,
 		if (source->type == sink->type)
 			continue;
 
-		if (source->type == VSP1_ENTITY_LIF ||
+		if (source->type == VSP1_ENTITY_HGO ||
+		    source->type == VSP1_ENTITY_LIF ||
 		    source->type == VSP1_ENTITY_WPF)
 			continue;
 
@@ -147,6 +149,16 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
+	if (vsp1->info->features & VSP1_HAS_HGO) {
+		ret = media_create_pad_link(&vsp1->hgo->entity.subdev.entity,
+					    HGO_PAD_SOURCE,
+					    &vsp1->hgo->histo.video.entity, 0,
+					    MEDIA_LNK_FL_ENABLED |
+					    MEDIA_LNK_FL_IMMUTABLE);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (vsp1->info->features & VSP1_HAS_LIF) {
 		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
 					    RWPF_PAD_SOURCE,
@@ -270,6 +282,16 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
+	if (vsp1->info->features & VSP1_HAS_HGO) {
+		vsp1->hgo = vsp1_hgo_create(vsp1);
+		if (IS_ERR(vsp1->hgo)) {
+			ret = PTR_ERR(vsp1->hgo);
+			goto done;
+		}
+
+		list_add_tail(&vsp1->hgo->entity.list_dev, &vsp1->entities);
+	}
+
 	if (vsp1->info->features & VSP1_HAS_LIF) {
 		vsp1->lif = vsp1_lif_create(vsp1);
 		if (IS_ERR(vsp1->lif)) {
@@ -549,7 +571,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	{
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT
+			  | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 3,
 		.wpf_count = 4,
@@ -567,7 +590,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
+		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LIF
+			  | VSP1_HAS_LUT,
 		.rpf_count = 4,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -576,7 +600,8 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
 		.gen = 2,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT
+			  | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 1,
 		.wpf_count = 4,
@@ -585,7 +610,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.features = VSP1_HAS_HGO | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 1,
 		.uds_count = 1,
 		.wpf_count = 1,
@@ -601,7 +626,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
 		.gen = 3,
-		.features = VSP1_HAS_BRU | VSP1_HAS_LUT,
+		.features = VSP1_HAS_BRU | VSP1_HAS_HGO | VSP1_HAS_LUT,
 		.rpf_count = 5,
 		.wpf_count = 1,
 		.num_bru_inputs = 5,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index fd20c0d8aeea..42f9b00ffc3b 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -21,6 +21,8 @@
 #include "vsp1.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
+#include "vsp1_pipe.h"
+#include "vsp1_rwpf.h"
 
 static inline struct vsp1_entity *
 media_entity_to_vsp1_entity(struct media_entity *entity)
@@ -28,11 +30,28 @@ media_entity_to_vsp1_entity(struct media_entity *entity)
 	return container_of(entity, struct vsp1_entity, subdev.entity);
 }
 
-void vsp1_entity_route_setup(struct vsp1_entity *source,
+void vsp1_entity_route_setup(struct vsp1_entity *entity,
+			     struct vsp1_pipeline *pipe,
 			     struct vsp1_dl_list *dl)
 {
+	struct vsp1_entity *source;
 	struct vsp1_entity *sink;
 
+	if (entity->type == VSP1_ENTITY_HGO) {
+		u32 smppt;
+
+		/* The HGO is a special case, its routing is configured on the
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
+	source = entity;
 	if (source->route->reg == 0)
 		return;
 
@@ -267,25 +286,30 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
  * Media Operations
  */
 
-int vsp1_entity_link_setup(struct media_entity *entity,
-			   const struct media_pad *local,
-			   const struct media_pad *remote, u32 flags)
+static int vsp1_entity_link_setup_source(const struct media_pad *source_pad,
+					 const struct media_pad *sink_pad,
+					 u32 flags)
 {
 	struct vsp1_entity *source;
 
-	if (!(local->flags & MEDIA_PAD_FL_SOURCE))
-		return 0;
-
-	source = media_entity_to_vsp1_entity(local->entity);
+	source = media_entity_to_vsp1_entity(source_pad->entity);
 
 	if (!source->route)
 		return 0;
 
 	if (flags & MEDIA_LNK_FL_ENABLED) {
-		if (source->sink)
-			return -EBUSY;
-		source->sink = remote->entity;
-		source->sink_pad = remote->index;
+		struct vsp1_entity *sink
+			= media_entity_to_vsp1_entity(sink_pad->entity);
+
+		/* Fan-out is limited to one for the normal data path plus an
+		 * optional HGO. We ignore the HGO here.
+		 */
+		if (sink->type != VSP1_ENTITY_HGO) {
+			if (source->sink)
+				return -EBUSY;
+			source->sink = sink_pad->entity;
+			source->sink_pad = sink_pad->index;
+		}
 	} else {
 		source->sink = NULL;
 		source->sink_pad = 0;
@@ -294,6 +318,84 @@ int vsp1_entity_link_setup(struct media_entity *entity,
 	return 0;
 }
 
+static int vsp1_entity_link_setup_sink(const struct media_pad *source_pad,
+				       const struct media_pad *sink_pad,
+				       u32 flags)
+{
+	struct vsp1_entity *sink;
+
+	sink = media_entity_to_vsp1_entity(sink_pad->entity);
+
+	if (flags & MEDIA_LNK_FL_ENABLED) {
+		/* Fan-in is limited to one. */
+		if (sink->sources[sink_pad->index])
+			return -EBUSY;
+
+		sink->sources[sink_pad->index] = source_pad->entity;
+	} else {
+		sink->sources[sink_pad->index] = NULL;
+	}
+
+	return 0;
+}
+
+int vsp1_entity_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	if (local->flags & MEDIA_PAD_FL_SOURCE)
+		return vsp1_entity_link_setup_source(local, remote, flags);
+	else
+		return vsp1_entity_link_setup_sink(remote, local, flags);
+}
+
+/**
+ * vsp1_entity_remote_pad - Find the pad at the remote end of a link
+ * @pad: Pad at the local end of the link
+ *
+ * Search for a remote pad connected to the given pad by iterating over all
+ * links originating or terminating at that pad until an enabled link is found.
+ *
+ * Our link setup implementation guarantees that the output fan-out will not be
+ * higher than one for the data pipelines, except for the link to the HGO that
+ * can be enabled in addition to a regular data link. When traversing outgoing
+ * links this function ignores HGO entities and should thus be used in place of
+ * the generic media_entity_remote_pad() function when traversing data
+ * pipelines.
+ *
+ * Return a pointer to the pad at the remote end of the first found enabled
+ * link, or NULL if no enabled link has been found.
+ */
+struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad)
+{
+	struct media_link *link;
+
+	list_for_each_entry(link, &pad->entity->links, list) {
+		struct vsp1_entity *entity;
+
+		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
+			continue;
+
+		/* If we're the sink the source will never be an HGO. */
+		if (link->sink == pad)
+			return link->source;
+
+		if (link->source != pad)
+			continue;
+
+		/* If the sink isn't a subdevice it can't be an HGO. */
+		if (!is_media_entity_v4l2_subdev(link->sink->entity))
+			return link->sink;
+
+		entity = media_entity_to_vsp1_entity(link->sink->entity);
+		if (entity->type != VSP1_ENTITY_HGO)
+			return link->sink;
+	}
+
+	return NULL;
+
+}
+
 /* -----------------------------------------------------------------------------
  * Initialization
  */
@@ -319,6 +421,7 @@ static const struct vsp1_route vsp1_routes[] = {
 	  { VI6_DPR_NODE_BRU_IN(0), VI6_DPR_NODE_BRU_IN(1),
 	    VI6_DPR_NODE_BRU_IN(2), VI6_DPR_NODE_BRU_IN(3),
 	    VI6_DPR_NODE_BRU_IN(4) }, VI6_DPR_NODE_BRU_OUT },
+	{ VSP1_ENTITY_HGO, 0, 0, { 0, }, 0 },
 	VSP1_ENTITY_ROUTE(HSI),
 	VSP1_ENTITY_ROUTE(HST),
 	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, }, VI6_DPR_NODE_LIF },
@@ -369,7 +472,14 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	for (i = 0; i < num_pads - 1; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
 
-	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
+	entity->sources = devm_kcalloc(vsp1->dev, max(num_pads - 1, 1U),
+				       sizeof(*entity->sources), GFP_KERNEL);
+	if (entity->sources == NULL)
+		return -ENOMEM;
+
+	/* Single-pad entities only have a sink. */
+	entity->pads[num_pads - 1].flags = num_pads > 1 ? MEDIA_PAD_FL_SOURCE
+					 : MEDIA_PAD_FL_SINK;
 
 	/* Initialize the media entity. */
 	ret = media_entity_pads_init(&entity->subdev.entity, num_pads,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index a240fc1c59a6..d599c8cc99b7 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -24,6 +24,7 @@ struct vsp1_pipeline;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
+	VSP1_ENTITY_HGO,
 	VSP1_ENTITY_HSI,
 	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
@@ -90,6 +91,7 @@ struct vsp1_entity {
 	struct media_pad *pads;
 	unsigned int source_pad;
 
+	struct media_entity **sources;
 	struct media_entity *sink;
 	unsigned int sink_pad;
 
@@ -128,9 +130,12 @@ vsp1_entity_get_pad_selection(struct vsp1_entity *entity,
 int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_pad_config *cfg);
 
-void vsp1_entity_route_setup(struct vsp1_entity *source,
+void vsp1_entity_route_setup(struct vsp1_entity *entity,
+			     struct vsp1_pipeline *pipe,
 			     struct vsp1_dl_list *dl);
 
+struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
+
 int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt);
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
new file mode 100644
index 000000000000..a8b0d6ed00a5
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -0,0 +1,496 @@
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
+#define HGO_MIN_SIZE				4U
+#define HGO_MAX_SIZE				8192U
+#define HGO_DATA_SIZE				((2 + 256) * 4)
+
+/* -----------------------------------------------------------------------------
+ * Device Access
+ */
+
+static inline u32 vsp1_hgo_read(struct vsp1_hgo *hgo, u32 reg)
+{
+	return vsp1_read(hgo->entity.vsp1, reg);
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
+			vsp1_write(hgo->entity.vsp1, VI6_HGO_EXT_HIST_ADDR, i);
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
+ * V4L2 Subdevice Operations
+ */
+
+static int hgo_enum_mbus_code(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	static const unsigned int codes[] = {
+		MEDIA_BUS_FMT_ARGB8888_1X32,
+		MEDIA_BUS_FMT_AHSV8888_1X32,
+		MEDIA_BUS_FMT_AYUV8_1X32,
+	};
+
+	if (code->pad == HGO_PAD_SOURCE) {
+		code->code = MEDIA_BUS_FMT_FIXED;
+		return 0;
+	}
+
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
+}
+
+static int hgo_enum_frame_size(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_pad_config *cfg,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	if (fse->pad != HGO_PAD_SINK)
+		return -EINVAL;
+
+	return vsp1_subdev_enum_frame_size(subdev, cfg, fse, HGO_MIN_SIZE,
+					   HGO_MIN_SIZE, HGO_MAX_SIZE,
+					   HGO_MAX_SIZE);
+}
+
+static int hgo_get_selection(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_hgo *hgo = to_hgo(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	if (sel->pad != HGO_PAD_SINK)
+		return -EINVAL;
+
+	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+		crop = vsp1_entity_get_pad_selection(&hgo->entity, config,
+						     HGO_PAD_SINK,
+						     V4L2_SEL_TGT_CROP);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = crop->width;
+		sel->r.height = crop->height;
+		return 0;
+
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		format = vsp1_entity_get_pad_format(&hgo->entity, config,
+						    HGO_PAD_SINK);
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = format->width;
+		sel->r.height = format->height;
+		return 0;
+
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_CROP:
+		sel->r = *vsp1_entity_get_pad_selection(&hgo->entity, config,
+							sel->pad, sel->target);
+		return 0;
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int hgo_set_crop(struct v4l2_subdev *subdev,
+			struct v4l2_subdev_pad_config *config,
+			struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_hgo *hgo = to_hgo(subdev);
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
+
+	/* The crop rectangle must be inside the input frame. */
+	format = vsp1_entity_get_pad_format(&hgo->entity, config, HGO_PAD_SINK);
+	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
+	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
+	sel->r.width = clamp_t(unsigned int, sel->r.width, HGO_MIN_SIZE,
+			       format->width - sel->r.left);
+	sel->r.height = clamp_t(unsigned int, sel->r.height, HGO_MIN_SIZE,
+				format->height - sel->r.top);
+
+	/* Set the crop rectangle and reset the compose rectangle. */
+	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
+						  sel->pad, V4L2_SEL_TGT_CROP);
+	*selection = sel->r;
+
+	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
+						  sel->pad,
+						  V4L2_SEL_TGT_COMPOSE);
+	*selection = sel->r;
+
+	return 0;
+}
+
+static int hgo_set_compose(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_pad_config *config,
+			   struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_hgo *hgo = to_hgo(subdev);
+	struct v4l2_rect *compose;
+	struct v4l2_rect *crop;
+	unsigned int ratio;
+
+	/* The compose rectangle is used to configure downscaling, the top left
+	 * corner is fixed to (0,0) and the size to 1/2 or 1/4 of the crop
+	 * rectangle.
+	 */
+	sel->r.left = 0;
+	sel->r.top = 0;
+
+	crop = vsp1_entity_get_pad_selection(&hgo->entity, config, sel->pad,
+					     V4L2_SEL_TGT_CROP);
+
+	/* Clamp the width and height to acceptable values first and then
+	 * compute the closest rounded dividing ratio.
+	 *
+	 * Ratio	Rounded ratio
+	 * --------------------------
+	 * [1.0 1.5[	1
+	 * [1.5 3.0[	2
+	 * [3.0 4.0]	4
+	 *
+	 * The rounded ratio can be computed using
+	 *
+	 * 1 << (ceil(ratio * 2) / 3)
+	 */
+	sel->r.width = clamp(sel->r.width, crop->width / 4, crop->width);
+	ratio = 1 << (crop->width * 2 / sel->r.width / 3);
+	sel->r.width = crop->width / ratio;
+
+
+	sel->r.height = clamp(sel->r.height, crop->height / 4, crop->height);
+	ratio = 1 << (crop->height * 2 / sel->r.height / 3);
+	sel->r.height = crop->height / ratio;
+
+	compose = vsp1_entity_get_pad_selection(&hgo->entity, config, sel->pad,
+						V4L2_SEL_TGT_COMPOSE);
+	*compose = sel->r;
+
+	return 0;
+}
+
+static int hgo_set_selection(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_selection *sel)
+{
+	struct vsp1_hgo *hgo = to_hgo(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	if (sel->pad != HGO_PAD_SINK)
+		return -EINVAL;
+
+	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
+	if (sel->target == V4L2_SEL_TGT_CROP)
+		return hgo_set_crop(subdev, config, sel);
+	else if (sel->target == V4L2_SEL_TGT_COMPOSE)
+		return hgo_set_compose(subdev, config, sel);
+	else
+		return -EINVAL;
+}
+
+static int hgo_get_format(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *fmt)
+{
+	if (fmt->pad == HGO_PAD_SOURCE) {
+		fmt->format.code = MEDIA_BUS_FMT_FIXED;
+		fmt->format.width = 0;
+		fmt->format.height = 0;
+		fmt->format.field = V4L2_FIELD_NONE;
+		fmt->format.colorspace = V4L2_COLORSPACE_RAW;
+	}
+
+	return vsp1_subdev_get_pad_format(subdev, cfg, fmt);
+}
+
+static int hgo_set_format(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_hgo *hgo = to_hgo(subdev);
+	struct v4l2_subdev_pad_config *config;
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *selection;
+
+	if (fmt->pad != HGO_PAD_SINK)
+		return hgo_get_format(subdev, cfg, fmt);
+
+	config = vsp1_entity_get_pad_config(&hgo->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	/* Default to YUV if the requested format is not supported. */
+	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
+	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
+		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
+
+	format = vsp1_entity_get_pad_format(&hgo->entity, config, fmt->pad);
+
+	format->code = fmt->format.code;
+	format->width = clamp_t(unsigned int, fmt->format.width,
+				HGO_MIN_SIZE, HGO_MAX_SIZE);
+	format->height = clamp_t(unsigned int, fmt->format.height,
+				 HGO_MIN_SIZE, HGO_MAX_SIZE);
+	format->field = V4L2_FIELD_NONE;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+
+	fmt->format = *format;
+
+	/* Reset the crop and compose rectangles */
+	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
+						  fmt->pad, V4L2_SEL_TGT_CROP);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
+	selection = vsp1_entity_get_pad_selection(&hgo->entity, config,
+						  fmt->pad,
+						  V4L2_SEL_TGT_COMPOSE);
+	selection->left = 0;
+	selection->top = 0;
+	selection->width = format->width;
+	selection->height = format->height;
+
+	return 0;
+}
+
+static struct v4l2_subdev_pad_ops hgo_pad_ops = {
+	.enum_mbus_code = hgo_enum_mbus_code,
+	.enum_frame_size = hgo_enum_frame_size,
+	.get_fmt = hgo_get_format,
+	.set_fmt = hgo_set_format,
+	.get_selection = hgo_get_selection,
+	.set_selection = hgo_set_selection,
+};
+
+static struct v4l2_subdev_ops hgo_ops = {
+	.pad    = &hgo_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * VSP1 Entity Operations
+ */
+
+static void hgo_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
+{
+	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
+	struct v4l2_rect *compose;
+	struct v4l2_rect *crop;
+	unsigned int hratio;
+	unsigned int vratio;
+
+	crop = vsp1_entity_get_pad_selection(entity, entity->config,
+					     HGO_PAD_SINK, V4L2_SEL_TGT_CROP);
+	compose = vsp1_entity_get_pad_selection(entity, entity->config,
+						HGO_PAD_SINK,
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
+static void hgo_destroy(struct vsp1_entity *entity)
+{
+	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
+
+	vsp1_histogram_cleanup(&hgo->histo);
+}
+
+static const struct vsp1_entity_operations hgo_entity_ops = {
+	.configure = hgo_configure,
+	.destroy = hgo_destroy,
+};
+
+/* -----------------------------------------------------------------------------
+ * Initialization and Cleanup
+ */
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
+	hgo->entity.ops = &hgo_entity_ops;
+	hgo->entity.type = VSP1_ENTITY_HGO;
+
+	ret = vsp1_entity_init(vsp1, &hgo->entity, "hgo", 2, &hgo_ops);
+	if (ret < 0)
+		return ERR_PTR(ret);
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
+	hgo->entity.subdev.ctrl_handler = &hgo->ctrls.handler;
+
+	/* Initialize the video device and queue for statistics data. */
+	ret = vsp1_histogram_init(vsp1, &hgo->histo, hgo->entity.subdev.name,
+				  HGO_DATA_SIZE);
+	if (ret < 0) {
+		vsp1_entity_destroy(&hgo->entity);
+		return ERR_PTR(ret);
+	}
+
+	return hgo;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.h b/drivers/media/platform/vsp1/vsp1_hgo.h
new file mode 100644
index 000000000000..d677b3fe6023
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_hgo.h
@@ -0,0 +1,50 @@
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
+#include "vsp1_entity.h"
+#include "vsp1_histo.h"
+
+struct vsp1_device;
+
+#define HGO_PAD_SINK				0
+#define HGO_PAD_SOURCE				1
+
+struct vsp1_hgo {
+	struct vsp1_entity entity;
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
+	return container_of(subdev, struct vsp1_hgo, entity.subdev);
+}
+
+struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1);
+void vsp1_hgo_frame_end(struct vsp1_entity *hgo);
+
+#endif /* __VSP1_HGO_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
new file mode 100644
index 000000000000..e9eb22835483
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -0,0 +1,307 @@
+/*
+ * vsp1_histo.c  --  R-Car VSP1 Histogram API
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ * Copyright (C) 2016 Laurent Pinchart
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
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include "vsp1.h"
+#include "vsp1_histo.h"
+#include "vsp1_pipe.h"
+
+/* -----------------------------------------------------------------------------
+ * Buffer Operations
+ */
+
+static inline struct vsp1_histogram_buffer *
+to_vsp1_histogram_buffer(struct vb2_v4l2_buffer *vbuf)
+{
+	return container_of(vbuf, struct vsp1_histogram_buffer, buf);
+}
+
+struct vsp1_histogram_buffer *
+vsp1_histogram_buffer_get(struct vsp1_histogram *histo)
+{
+	struct vsp1_histogram_buffer *buf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&histo->irqlock, flags);
+
+	if (list_empty(&histo->irqqueue))
+		goto done;
+
+	buf = list_first_entry(&histo->irqqueue, struct vsp1_histogram_buffer,
+			       queue);
+	list_del(&buf->queue);
+	histo->readout = true;
+
+done:
+	spin_unlock_irqrestore(&histo->irqlock, flags);
+	return buf;
+}
+
+void vsp1_histogram_buffer_complete(struct vsp1_histogram *histo,
+				    struct vsp1_histogram_buffer *buf,
+				    size_t size)
+{
+	struct vsp1_pipeline *pipe = histo->pipe;
+	unsigned long flags;
+
+	/* The pipeline pointer is guaranteed to be valid as this function is
+	 * called from the frame completion interrupt handler, which can only
+	 * occur when video streaming is active.
+	 */
+	buf->buf.sequence = pipe->sequence;
+	buf->buf.vb2_buf.timestamp = ktime_get_ns();
+	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, size);
+	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
+
+	spin_lock_irqsave(&histo->irqlock, flags);
+	histo->readout = false;
+	wake_up(&histo->wait_queue);
+	spin_unlock_irqrestore(&histo->irqlock, flags);
+}
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 Queue Operations
+ */
+
+static int histo_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+			     unsigned int *nplanes, unsigned int sizes[],
+			     void *alloc_ctxs[])
+{
+	struct vsp1_histogram *histo = vb2_get_drv_priv(vq);
+
+	if (*nplanes) {
+		if (*nplanes != 1)
+			return -EINVAL;
+
+		if (sizes[0] < histo->data_size)
+			return -EINVAL;
+
+		return 0;
+	}
+
+	*nplanes = 1;
+	sizes[0] = histo->data_size;
+
+	return 0;
+}
+
+static int histo_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vsp1_histogram *histo = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_histogram_buffer *buf = to_vsp1_histogram_buffer(vbuf);
+
+	if (vb->num_planes != 1)
+		return -EINVAL;
+
+	if (vb2_plane_size(vb, 0) < histo->data_size)
+		return -EINVAL;
+
+	buf->addr = vb2_plane_vaddr(vb, 0);
+
+	return 0;
+}
+
+static void histo_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct vsp1_histogram *histo = vb2_get_drv_priv(vb->vb2_queue);
+	struct vsp1_histogram_buffer *buf = to_vsp1_histogram_buffer(vbuf);
+	unsigned long flags;
+
+	spin_lock_irqsave(&histo->irqlock, flags);
+	list_add_tail(&buf->queue, &histo->irqqueue);
+	spin_unlock_irqrestore(&histo->irqlock, flags);
+}
+
+static int histo_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	return 0;
+}
+
+static void histo_stop_streaming(struct vb2_queue *vq)
+{
+	struct vsp1_histogram *histo = vb2_get_drv_priv(vq);
+	struct vsp1_histogram_buffer *buffer;
+	unsigned long flags;
+
+	spin_lock_irqsave(&histo->irqlock, flags);
+
+	/* Remove all buffers from the IRQ queue. */
+	list_for_each_entry(buffer, &histo->irqqueue, queue)
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
+	INIT_LIST_HEAD(&histo->irqqueue);
+
+	/* Wait for the buffer being read out (if any) to complete. */
+	wait_event_lock_irq(histo->wait_queue, !histo->readout, histo->irqlock);
+
+	spin_unlock_irqrestore(&histo->irqlock, flags);
+}
+
+static struct vb2_ops histo_video_queue_qops = {
+	.queue_setup = histo_queue_setup,
+	.buf_prepare = histo_buffer_prepare,
+	.buf_queue = histo_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = histo_start_streaming,
+	.stop_streaming = histo_stop_streaming,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int histo_v4l2_querycap(struct file *file, void *fh,
+			       struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_histogram *histo = to_vsp1_histo(vfh->vdev);
+
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
+			  | V4L2_CAP_VIDEO_CAPTURE_MPLANE
+			  | V4L2_CAP_VIDEO_OUTPUT_MPLANE
+			  | V4L2_CAP_META_CAPTURE;
+	cap->device_caps = V4L2_CAP_META_CAPTURE
+			 | V4L2_CAP_STREAMING;
+
+	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
+	strlcpy(cap->card, histo->video.name, sizeof(cap->card));
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
+		 dev_name(histo->vsp1->dev));
+
+	return 0;
+}
+
+static int histo_v4l2_get_format(struct file *file, void *fh,
+				 struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct vsp1_histogram *histo = to_vsp1_histo(vfh->vdev);
+	struct v4l2_meta_format *meta = &format->fmt.meta;
+
+	if (format->type != histo->queue.type)
+		return -EINVAL;
+
+	memset(meta, 0, sizeof(*meta));
+
+	meta->dataformat = V4L2_META_FMT_VSP1_HGO;
+	meta->buffersize = histo->data_size;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops histo_v4l2_ioctl_ops = {
+	.vidioc_querycap		= histo_v4l2_querycap,
+	.vidioc_g_fmt_meta_cap		= histo_v4l2_get_format,
+	.vidioc_s_fmt_meta_cap		= histo_v4l2_get_format,
+	.vidioc_try_fmt_meta_cap	= histo_v4l2_get_format,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 File Operations
+ */
+
+static struct v4l2_file_operations histo_v4l2_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+};
+
+int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
+			const char *name, size_t data_size)
+{
+	int ret;
+
+	histo->vsp1 = vsp1;
+	histo->data_size = data_size;
+
+	histo->pad.flags = MEDIA_PAD_FL_SINK;
+	histo->video.vfl_dir = VFL_DIR_RX;
+
+	mutex_init(&histo->lock);
+	spin_lock_init(&histo->irqlock);
+	INIT_LIST_HEAD(&histo->irqqueue);
+	init_waitqueue_head(&histo->wait_queue);
+
+	/* Initialize the media entity... */
+	ret = media_entity_pads_init(&histo->video.entity, 1, &histo->pad);
+	if (ret < 0)
+		return ret;
+
+	/* ... and the video node... */
+	histo->video.v4l2_dev = &vsp1->v4l2_dev;
+	histo->video.fops = &histo_v4l2_fops;
+	snprintf(histo->video.name, sizeof(histo->video.name),
+		 "%s histo", name);
+	histo->video.vfl_type = VFL_TYPE_GRABBER;
+	histo->video.release = video_device_release_empty;
+	histo->video.ioctl_ops = &histo_v4l2_ioctl_ops;
+
+	video_set_drvdata(&histo->video, histo);
+
+	/* ... and the buffers queue... */
+	histo->queue.type = V4L2_BUF_TYPE_META_CAPTURE;
+	histo->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	histo->queue.lock = &histo->lock;
+	histo->queue.drv_priv = histo;
+	histo->queue.buf_struct_size = sizeof(struct vsp1_histogram_buffer);
+	histo->queue.ops = &histo_video_queue_qops;
+	histo->queue.mem_ops = &vb2_vmalloc_memops;
+	histo->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
+	ret = vb2_queue_init(&histo->queue);
+	if (ret < 0) {
+		dev_err(histo->vsp1->dev, "failed to initialize vb2 queue\n");
+		goto error;
+	}
+
+	/* ... and register the video device. */
+	histo->video.queue = &histo->queue;
+	ret = video_register_device(&histo->video, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		dev_err(histo->vsp1->dev, "failed to register video device\n");
+		goto error;
+	}
+
+	return 0;
+
+error:
+	vsp1_histogram_cleanup(histo);
+	return ret;
+}
+
+void vsp1_histogram_cleanup(struct vsp1_histogram *histo)
+{
+	if (video_is_registered(&histo->video))
+		video_unregister_device(&histo->video);
+
+	media_entity_cleanup(&histo->video.entity);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_histo.h b/drivers/media/platform/vsp1/vsp1_histo.h
new file mode 100644
index 000000000000..48be31dd5515
--- /dev/null
+++ b/drivers/media/platform/vsp1/vsp1_histo.h
@@ -0,0 +1,68 @@
+/*
+ * vsp1_histo.h  --  R-Car VSP1 Histogram API
+ *
+ * Copyright (C) 2016 Renesas Electronics Corporation
+ * Copyright (C) 2016 Laurent Pinchart
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef __VSP1_HISTO_H__
+#define __VSP1_HISTO_H__
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+
+#include <media/media-entity.h>
+#include <media/v4l2-dev.h>
+#include <media/videobuf2-v4l2.h>
+
+struct vsp1_device;
+struct vsp1_pipeline;
+
+struct vsp1_histogram_buffer {
+	struct vb2_v4l2_buffer buf;
+	struct list_head queue;
+	void *addr;
+};
+
+struct vsp1_histogram {
+	struct vsp1_device *vsp1;
+	struct vsp1_pipeline *pipe;
+
+	struct video_device video;
+	struct media_pad pad;
+
+	size_t data_size;
+
+	struct mutex lock;
+	struct vb2_queue queue;
+
+	spinlock_t irqlock;
+	struct list_head irqqueue;
+
+	wait_queue_head_t wait_queue;
+	bool readout;
+};
+
+static inline struct vsp1_histogram *to_vsp1_histo(struct video_device *vdev)
+{
+	return container_of(vdev, struct vsp1_histogram, video);
+}
+
+int vsp1_histogram_init(struct vsp1_device *vsp1, struct vsp1_histogram *histo,
+			const char *name, size_t data_size);
+void vsp1_histogram_cleanup(struct vsp1_histogram *histo);
+
+struct vsp1_histogram_buffer *
+vsp1_histogram_buffer_get(struct vsp1_histogram *histo);
+void vsp1_histogram_buffer_complete(struct vsp1_histogram *histo,
+				    struct vsp1_histogram_buffer *buf,
+				    size_t size);
+
+#endif /* __VSP1_HISTO_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 3c6f623f056c..b695bee9e55c 100644
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
@@ -184,11 +185,18 @@ void vsp1_pipeline_reset(struct vsp1_pipeline *pipe)
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
@@ -232,6 +240,7 @@ bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe)
 
 int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
 	unsigned long flags;
 	int ret;
@@ -240,8 +249,7 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 		/* When using display lists in continuous frame mode the only
 		 * way to stop the pipeline is to reset the hardware.
 		 */
-		ret = vsp1_reset_wpf(pipe->output->entity.vsp1,
-				     pipe->output->entity.index);
+		ret = vsp1_reset_wpf(vsp1, pipe->output->entity.index);
 		if (ret == 0) {
 			spin_lock_irqsave(&pipe->irqlock, flags);
 			pipe->state = VSP1_PIPELINE_STOPPED;
@@ -261,10 +269,15 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->route && entity->route->reg)
-			vsp1_write(entity->vsp1, entity->route->reg,
+			vsp1_write(vsp1, entity->route->reg,
 				   VI6_DPR_NODE_UNUSED);
 	}
 
+	if (pipe->hgo)
+		vsp1_write(vsp1, VI6_DPR_HGO_SMPPT,
+			   (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
+			   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+
 	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 0);
 
 	return ret;
@@ -288,6 +301,9 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
 
 	vsp1_dlm_irq_frame_end(pipe->output->dlm);
 
+	if (pipe->hgo)
+		vsp1_hgo_frame_end(pipe->hgo);
+
 	if (pipe->frame_end)
 		pipe->frame_end(pipe);
 
@@ -313,7 +329,11 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	struct vsp1_entity *entity;
 	struct media_pad *pad;
 
-	pad = media_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
+	/* The alpha value doesn't need to be propagated to the HGO, use
+	 * vsp1_entity_remote_pad() to traverse the graph.
+	 */
+
+	pad = vsp1_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
 
 	while (pad) {
 		if (!is_media_entity_v4l2_subdev(pad->entity))
@@ -335,7 +355,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 		}
 
 		pad = &entity->pads[entity->source_pad];
-		pad = media_entity_remote_pad(pad);
+		pad = vsp1_entity_remote_pad(pad);
 	}
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index febc62f99d6d..3ecd3c1794a9 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -72,6 +72,7 @@ enum vsp1_pipeline_state {
  * @inputs: array of RPFs in the pipeline (indexed by RPF index)
  * @output: WPF at the output of the pipeline
  * @bru: BRU entity, if present
+ * @hgo: HGO entity, if present
  * @lif: LIF entity, if present
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
@@ -97,6 +98,7 @@ struct vsp1_pipeline {
 	struct vsp1_rwpf *inputs[VSP1_MAX_RPF];
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
+	struct vsp1_entity *hgo;
 	struct vsp1_entity *lif;
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 7657545a75ed..684a3eff3739 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -321,8 +321,8 @@
 #define VI6_DPR_ROUTE_RT_MASK		(0x3f << 0)
 #define VI6_DPR_ROUTE_RT_SHIFT		0
 
-#define VI6_DPR_HGO_SMPPT		0x2050
-#define VI6_DPR_HGT_SMPPT		0x2054
+#define VI6_DPR_HGO_SMPPT		0x2054
+#define VI6_DPR_HGT_SMPPT		0x2058
 #define VI6_DPR_SMPPT_TGW_MASK		(7 << 8)
 #define VI6_DPR_SMPPT_TGW_SHIFT		8
 #define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
@@ -574,24 +574,38 @@
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
index 34aa6427662d..bcf47e7581b5 100644
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
@@ -319,7 +320,11 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 	if (ret < 0)
 		return ret;
 
-	pad = media_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
+	/* The main data path doesn't include the HGO, use
+	 * vsp1_entity_remote_pad() to traverse the graph.
+	 */
+
+	pad = vsp1_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
 
 	while (1) {
 		if (pad == NULL) {
@@ -371,13 +376,9 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 					: &input->entity;
 		}
 
-		/* Follow the source link. The link setup operations ensure
-		 * that the output fan-out can't be more than one, there is thus
-		 * no need to verify here that only a single source link is
-		 * activated.
-		 */
+		/* Follow the source link, ignoring any HGO. */
 		pad = &entity->pads[entity->source_pad];
-		pad = media_entity_remote_pad(pad);
+		pad = vsp1_entity_remote_pad(pad);
 	}
 
 	/* The last entity must be the output WPF. */
@@ -432,6 +433,11 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
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
 
@@ -629,7 +635,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, pipe->dl);
 
 		if (entity->ops->configure)
 			entity->ops->configure(entity, pipe, pipe->dl);
-- 
Regards,

Laurent Pinchart

