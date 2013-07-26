Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63216 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab3GZJdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:33:05 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so3070437pad.22
        for <linux-media@vger.kernel.org>; Fri, 26 Jul 2013 02:33:04 -0700 (PDT)
From: Katsuya Matsubara <matsu@igel.co.jp>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH 4/7] [media] vsp1: Rewrite the value definitions for DPR routing as enum and arrays
Date: Fri, 26 Jul 2013 18:32:14 +0900
Message-Id: <1374831137-9219-5-git-send-email-matsu@igel.co.jp>
In-Reply-To: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
References: <1374831137-9219-1-git-send-email-matsu@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This rewrites the value definitions for DPR routing as enum and arrays
rather than macros to support multiple versions of the H/W IP.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1.h        |    6 ++++
 drivers/media/platform/vsp1/vsp1_drv.c    |   49 +++++++++++++++++++++++------
 drivers/media/platform/vsp1/vsp1_entity.c |   31 +-----------------
 drivers/media/platform/vsp1/vsp1_entity.h |    3 +-
 drivers/media/platform/vsp1/vsp1_lif.c    |    2 +-
 drivers/media/platform/vsp1/vsp1_regs.h   |   39 ++++++++++++++++-------
 drivers/media/platform/vsp1/vsp1_rpf.c    |    2 +-
 drivers/media/platform/vsp1/vsp1_uds.c    |    2 +-
 drivers/media/platform/vsp1/vsp1_video.c  |   15 ++++++---
 drivers/media/platform/vsp1/vsp1_wpf.c    |    2 +-
 10 files changed, 88 insertions(+), 63 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 8db5bbb..4d9b6c8 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -36,6 +36,11 @@ struct vsp1_uds;
 #define VPS1_MAX_UDS		3
 #define VPS1_MAX_WPF		4
 
+struct vsp1_dpr_route {
+	unsigned int id;
+	int reg;
+};
+
 struct vsp1_device {
 	struct device *dev;
 	struct vsp1_platform_data *pdata;
@@ -57,6 +62,7 @@ struct vsp1_device {
 	struct media_device media_dev;
 
 	const unsigned int *reg_offs;
+	const struct vsp1_dpr_route *routes;
 };
 
 struct vsp1_device *vsp1_device_get(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 42f51d8..920edb1 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -239,6 +239,7 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 {
 	unsigned int i;
 	u32 status;
+	u32 route_unused = vsp1->routes[VI6_DPR_NODE_UNUSED].id;
 
 	/* Reset any channel that might be running. */
 	status = vsp1_read(vsp1, VI6_STATUS);
@@ -266,22 +267,22 @@ static void vsp1_device_init(struct vsp1_device *vsp1)
 		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
 
 	for (i = 0; i < vsp1->pdata->rpf_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE0 + i, VI6_DPR_NODE_UNUSED);
+		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE0 + i, route_unused);
 
 	for (i = 0; i < vsp1->pdata->uds_count; ++i)
-		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE0 + i, VI6_DPR_NODE_UNUSED);
+		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE0 + i, route_unused);
 
-	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
-	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, VI6_DPR_NODE_UNUSED);
-	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, VI6_DPR_NODE_UNUSED);
-	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, VI6_DPR_NODE_UNUSED);
-	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, VI6_DPR_NODE_UNUSED);
-	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, VI6_DPR_NODE_UNUSED);
+	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, route_unused);
+	vsp1_write(vsp1, VI6_DPR_LUT_ROUTE, route_unused);
+	vsp1_write(vsp1, VI6_DPR_CLU_ROUTE, route_unused);
+	vsp1_write(vsp1, VI6_DPR_HST_ROUTE, route_unused);
+	vsp1_write(vsp1, VI6_DPR_HSI_ROUTE, route_unused);
+	vsp1_write(vsp1, VI6_DPR_BRU_ROUTE, route_unused);
 
 	vsp1_write(vsp1, VI6_DPR_HGO_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
-		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
 	vsp1_write(vsp1, VI6_DPR_HGT_SMPPT, (7 << VI6_DPR_SMPPT_TGW_SHIFT) |
-		   (VI6_DPR_NODE_UNUSED << VI6_DPR_SMPPT_PT_SHIFT));
+		   (route_unused << VI6_DPR_SMPPT_PT_SHIFT));
 }
 
 /*
@@ -588,6 +589,33 @@ static const unsigned int vsp1_reg_offs[] = {
 	[VI6_CLU_DATA]		= 0x7404,
 };
 
+static const struct vsp1_dpr_route vsp1_routes[] = {
+	[VI6_DPR_NODE_RPF0]	= {  0, VI6_DPR_RPF_ROUTE0  },
+	[VI6_DPR_NODE_RPF1]	= {  1, VI6_DPR_RPF_ROUTE0 + 1 },
+	[VI6_DPR_NODE_RPF2]	= {  2, VI6_DPR_RPF_ROUTE0 + 2 },
+	[VI6_DPR_NODE_RPF3]	= {  3, VI6_DPR_RPF_ROUTE0 + 3 },
+	[VI6_DPR_NODE_RPF4]	= {  4, VI6_DPR_RPF_ROUTE0 + 4 },
+	[VI6_DPR_NODE_SRU]	= { 16, VI6_DPR_SRU_ROUTE },
+	[VI6_DPR_NODE_UDS0]	= { 17, VI6_DPR_UDS_ROUTE0 },
+	[VI6_DPR_NODE_UDS1]	= { 18, VI6_DPR_UDS_ROUTE0 + 1 },
+	[VI6_DPR_NODE_UDS2]	= { 19, VI6_DPR_UDS_ROUTE0 + 2 },
+	[VI6_DPR_NODE_LUT]	= { 22, VI6_DPR_LUT_ROUTE },
+	[VI6_DPR_NODE_BRU_IN0]	= { 23, 0 },
+	[VI6_DPR_NODE_BRU_IN1]	= { 24, 0 },
+	[VI6_DPR_NODE_BRU_IN2]	= { 25, 0 },
+	[VI6_DPR_NODE_BRU_IN3]	= { 26, 0 },
+	[VI6_DPR_NODE_BRU_OUT]	= { 27, VI6_DPR_BRU_ROUTE },
+	[VI6_DPR_NODE_CLU]	= { 29, VI6_DPR_CLU_ROUTE },
+	[VI6_DPR_NODE_HST]	= { 30, VI6_DPR_HST_ROUTE },
+	[VI6_DPR_NODE_HSI]	= { 31, VI6_DPR_HSI_ROUTE },
+	[VI6_DPR_NODE_LIF]	= { 55, 0 },
+	[VI6_DPR_NODE_WPF0]	= { 56, 0 },
+	[VI6_DPR_NODE_WPF1]	= { 57, 0 },
+	[VI6_DPR_NODE_WPF2]	= { 58, 0 },
+	[VI6_DPR_NODE_WPF3]	= { 59, 0 },
+	[VI6_DPR_NODE_UNUSED]	= { 63, 0 },
+};
+
 static int vsp1_probe(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1;
@@ -602,6 +630,7 @@ static int vsp1_probe(struct platform_device *pdev)
 	}
 
 	vsp1->reg_offs = vsp1_reg_offs;
+	vsp1->routes = vsp1_routes;
 
 	vsp1->dev = &pdev->dev;
 	mutex_init(&vsp1->lock);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index b8b6257..04e0e97 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -92,7 +92,7 @@ static int vsp1_entity_link_setup(struct media_entity *entity,
 
 	source = container_of(local->entity, struct vsp1_entity, subdev.entity);
 
-	if (!source->route)
+	if (!source->vsp1->routes[source->route_index].reg)
 		return 0;
 
 	if (flags & MEDIA_LNK_FL_ENABLED) {
@@ -118,37 +118,8 @@ const struct media_entity_operations vsp1_media_ops = {
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		     unsigned int num_pads)
 {
-	static const struct {
-		unsigned int id;
-		int reg;
-	} routes[] = {
-		{ VI6_DPR_NODE_LIF, 0 },
-		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE0  },
-		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE0 + 1 },
-		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE0 + 2 },
-		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE0 + 3 },
-		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE0 + 4 },
-		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE0 },
-		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE0 + 1 },
-		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE0 + 2 },
-		{ VI6_DPR_NODE_WPF(0), 0 },
-		{ VI6_DPR_NODE_WPF(1), 0 },
-		{ VI6_DPR_NODE_WPF(2), 0 },
-		{ VI6_DPR_NODE_WPF(3), 0 },
-	};
-
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(routes); ++i) {
-		if (routes[i].id == entity->id) {
-			entity->route = routes[i].reg;
-			break;
-		}
-	}
-
-	if (i == ARRAY_SIZE(routes))
-		return -EINVAL;
-
 	entity->vsp1 = vsp1;
 	entity->source_pad = num_pads - 1;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c4feab2c..7713592 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -31,8 +31,7 @@ struct vsp1_entity {
 
 	enum vsp1_entity_type type;
 	unsigned int index;
-	unsigned int id;
-	unsigned int route;
+	unsigned int route_index;
 
 	struct list_head list_dev;
 	struct list_head list_pipe;
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 74a32e6..cc4547d 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -215,7 +215,7 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 		return ERR_PTR(-ENOMEM);
 
 	lif->entity.type = VSP1_ENTITY_LIF;
-	lif->entity.id = VI6_DPR_NODE_LIF;
+	lif->entity.route_index = VI6_DPR_NODE_LIF;
 
 	ret = vsp1_entity_init(vsp1, &lif->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index a76bc31..b201202 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -521,18 +521,33 @@ enum {
 #define VI6_DPR_SMPPT_PT_MASK		(0x3f << 0)
 #define VI6_DPR_SMPPT_PT_SHIFT		0
 
-#define VI6_DPR_NODE_RPF(n)		(n)
-#define VI6_DPR_NODE_SRU		16
-#define VI6_DPR_NODE_UDS(n)		(17 + (n))
-#define VI6_DPR_NODE_LUT		22
-#define VI6_DPR_NODE_BRU_IN(n)		(23 + (n))
-#define VI6_DPR_NODE_BRU_OUT		27
-#define VI6_DPR_NODE_CLU		29
-#define VI6_DPR_NODE_HST		30
-#define VI6_DPR_NODE_HSI		31
-#define VI6_DPR_NODE_LIF		55
-#define VI6_DPR_NODE_WPF(n)		(56 + (n))
-#define VI6_DPR_NODE_UNUSED		63
+enum {
+	VI6_DPR_NODE_RPF0,
+	VI6_DPR_NODE_RPF1,
+	VI6_DPR_NODE_RPF2,
+	VI6_DPR_NODE_RPF3,
+	VI6_DPR_NODE_RPF4,
+	VI6_DPR_NODE_RPF5,
+	VI6_DPR_NODE_SRU,
+	VI6_DPR_NODE_UDS0,
+	VI6_DPR_NODE_UDS1,
+	VI6_DPR_NODE_UDS2,
+	VI6_DPR_NODE_LUT,
+	VI6_DPR_NODE_BRU_IN0,
+	VI6_DPR_NODE_BRU_IN1,
+	VI6_DPR_NODE_BRU_IN2,
+	VI6_DPR_NODE_BRU_IN3,
+	VI6_DPR_NODE_BRU_OUT,
+	VI6_DPR_NODE_CLU,
+	VI6_DPR_NODE_HST,
+	VI6_DPR_NODE_HSI,
+	VI6_DPR_NODE_LIF,
+	VI6_DPR_NODE_WPF0,
+	VI6_DPR_NODE_WPF1,
+	VI6_DPR_NODE_WPF2,
+	VI6_DPR_NODE_WPF3,
+	VI6_DPR_NODE_UNUSED,
+};
 
 /* -----------------------------------------------------------------------------
  * Macros for UDS Control Registers
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 0ba8bba..d469cc8 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -160,7 +160,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	rpf->entity.type = VSP1_ENTITY_RPF;
 	rpf->entity.index = index;
-	rpf->entity.id = VI6_DPR_NODE_RPF(index);
+	rpf->entity.route_index = VI6_DPR_NODE_RPF0 + index;
 
 	ret = vsp1_entity_init(vsp1, &rpf->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index f8fb89a..cb1a152 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -323,7 +323,7 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 
 	uds->entity.type = VSP1_ENTITY_UDS;
 	uds->entity.index = index;
-	uds->entity.id = VI6_DPR_NODE_UDS(index);
+	uds->entity.route_index = VI6_DPR_NODE_UDS0 + index;
 
 	ret = vsp1_entity_init(vsp1, &uds->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4c5dd8c..aa71ba8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -369,9 +369,12 @@ static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	ret = ret == 0 ? -ETIMEDOUT : 0;
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		if (entity->route)
-			vsp1_write(entity->vsp1, entity->route,
-				   VI6_DPR_NODE_UNUSED);
+		const struct vsp1_dpr_route *routes = entity->vsp1->routes;
+
+		if (routes[entity->route_index].reg)
+			vsp1_write(entity->vsp1,
+				   routes[entity->route_index].reg,
+				   routes[VI6_DPR_NODE_UNUSED].id);
 
 		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
 	}
@@ -569,12 +572,14 @@ static void vsp1_video_wait_finish(struct vb2_queue *vq)
 static void vsp1_entity_route_setup(struct vsp1_entity *source)
 {
 	struct vsp1_entity *sink;
+	const struct vsp1_dpr_route *routes = source->vsp1->routes;
 
-	if (source->route == 0)
+	if (routes[source->route_index].reg == 0)
 		return;
 
 	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_write(source->vsp1, source->route, sink->id);
+	vsp1_write(source->vsp1, routes[source->route_index].reg,
+		   routes[sink->route_index].id);
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 6840642..37779ef 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -178,7 +178,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
-	wpf->entity.id = VI6_DPR_NODE_WPF(index);
+	wpf->entity.route_index = VI6_DPR_NODE_WPF0 + index;
 
 	ret = vsp1_entity_init(vsp1, &wpf->entity, 2);
 	if (ret < 0)
-- 
1.7.9.5

