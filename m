Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40007 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCETWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:22:41 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/6] v4l: vsp1: Support multi-input entities
Date: Wed,  5 Mar 2014 20:23:59 +0100
Message-Id: <1394047444-30077-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rework the route configuration code to support entities with multiple
sink pads.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 54 +++++++++++++++----------------
 drivers/media/platform/vsp1/vsp1_entity.h | 23 +++++++++++--
 drivers/media/platform/vsp1/vsp1_hsit.c   |  7 ++--
 drivers/media/platform/vsp1/vsp1_lif.c    |  1 -
 drivers/media/platform/vsp1/vsp1_lut.c    |  1 -
 drivers/media/platform/vsp1/vsp1_rpf.c    |  1 -
 drivers/media/platform/vsp1/vsp1_sru.c    |  1 -
 drivers/media/platform/vsp1/vsp1_uds.c    |  1 -
 drivers/media/platform/vsp1/vsp1_video.c  |  7 ++--
 drivers/media/platform/vsp1/vsp1_wpf.c    |  1 -
 10 files changed, 54 insertions(+), 43 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 0226e47..966b185 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -100,8 +100,10 @@ static int vsp1_entity_link_setup(struct media_entity *entity,
 		if (source->sink)
 			return -EBUSY;
 		source->sink = remote->entity;
+		source->sink_pad = remote->index;
 	} else {
 		source->sink = NULL;
+		source->sink_pad = 0;
 	}
 
 	return 0;
@@ -116,42 +118,40 @@ const struct media_entity_operations vsp1_media_ops = {
  * Initialization
  */
 
+static const struct vsp1_route vsp1_routes[] = {
+	{ VSP1_ENTITY_HSI, 0, VI6_DPR_HSI_ROUTE, { VI6_DPR_NODE_HSI, } },
+	{ VSP1_ENTITY_HST, 0, VI6_DPR_HST_ROUTE, { VI6_DPR_NODE_HST, } },
+	{ VSP1_ENTITY_LIF, 0, 0, { VI6_DPR_NODE_LIF, } },
+	{ VSP1_ENTITY_LUT, 0, VI6_DPR_LUT_ROUTE, { VI6_DPR_NODE_LUT, } },
+	{ VSP1_ENTITY_RPF, 0, VI6_DPR_RPF_ROUTE(0), { VI6_DPR_NODE_RPF(0), } },
+	{ VSP1_ENTITY_RPF, 1, VI6_DPR_RPF_ROUTE(1), { VI6_DPR_NODE_RPF(1), } },
+	{ VSP1_ENTITY_RPF, 2, VI6_DPR_RPF_ROUTE(2), { VI6_DPR_NODE_RPF(2), } },
+	{ VSP1_ENTITY_RPF, 3, VI6_DPR_RPF_ROUTE(3), { VI6_DPR_NODE_RPF(3), } },
+	{ VSP1_ENTITY_RPF, 4, VI6_DPR_RPF_ROUTE(4), { VI6_DPR_NODE_RPF(4), } },
+	{ VSP1_ENTITY_SRU, 0, VI6_DPR_SRU_ROUTE, { VI6_DPR_NODE_SRU, } },
+	{ VSP1_ENTITY_UDS, 0, VI6_DPR_UDS_ROUTE(0), { VI6_DPR_NODE_UDS(0), } },
+	{ VSP1_ENTITY_UDS, 1, VI6_DPR_UDS_ROUTE(1), { VI6_DPR_NODE_UDS(1), } },
+	{ VSP1_ENTITY_UDS, 2, VI6_DPR_UDS_ROUTE(2), { VI6_DPR_NODE_UDS(2), } },
+	{ VSP1_ENTITY_WPF, 0, 0, { VI6_DPR_NODE_WPF(0), } },
+	{ VSP1_ENTITY_WPF, 1, 0, { VI6_DPR_NODE_WPF(1), } },
+	{ VSP1_ENTITY_WPF, 2, 0, { VI6_DPR_NODE_WPF(2), } },
+	{ VSP1_ENTITY_WPF, 3, 0, { VI6_DPR_NODE_WPF(3), } },
+};
+
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		     unsigned int num_pads)
 {
-	static const struct {
-		unsigned int id;
-		unsigned int reg;
-	} routes[] = {
-		{ VI6_DPR_NODE_HSI, VI6_DPR_HSI_ROUTE },
-		{ VI6_DPR_NODE_HST, VI6_DPR_HST_ROUTE },
-		{ VI6_DPR_NODE_LIF, 0 },
-		{ VI6_DPR_NODE_LUT, VI6_DPR_LUT_ROUTE },
-		{ VI6_DPR_NODE_RPF(0), VI6_DPR_RPF_ROUTE(0) },
-		{ VI6_DPR_NODE_RPF(1), VI6_DPR_RPF_ROUTE(1) },
-		{ VI6_DPR_NODE_RPF(2), VI6_DPR_RPF_ROUTE(2) },
-		{ VI6_DPR_NODE_RPF(3), VI6_DPR_RPF_ROUTE(3) },
-		{ VI6_DPR_NODE_RPF(4), VI6_DPR_RPF_ROUTE(4) },
-		{ VI6_DPR_NODE_SRU, VI6_DPR_SRU_ROUTE },
-		{ VI6_DPR_NODE_UDS(0), VI6_DPR_UDS_ROUTE(0) },
-		{ VI6_DPR_NODE_UDS(1), VI6_DPR_UDS_ROUTE(1) },
-		{ VI6_DPR_NODE_UDS(2), VI6_DPR_UDS_ROUTE(2) },
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
+	for (i = 0; i < ARRAY_SIZE(vsp1_routes); ++i) {
+		if (vsp1_routes[i].type == entity->type &&
+		    vsp1_routes[i].index == entity->index) {
+			entity->route = &vsp1_routes[i];
 			break;
 		}
 	}
 
-	if (i == ARRAY_SIZE(routes))
+	if (i == ARRAY_SIZE(vsp1_routes))
 		return -EINVAL;
 
 	entity->vsp1 = vsp1;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index e152798..dc31a31 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -30,13 +30,31 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_WPF,
 };
 
+/*
+ * struct vsp1_route - Entity routing configuration
+ * @type: Entity type this routing entry is associated with
+ * @index: Entity index this routing entry is associated with
+ * @reg: Output routing configuration register
+ * @inputs: Target node value for each input
+ *
+ * Each $vsp1_route entry describes routing configuration for the entity
+ * specified by the entry's @type and @index. @reg indicates the register that
+ * holds output routing configuration for the entity, and the @inputs array
+ * store the target node value for each input of the entity.
+ */
+struct vsp1_route {
+	enum vsp1_entity_type type;
+	unsigned int index;
+	unsigned int reg;
+	unsigned int inputs[4];
+};
+
 struct vsp1_entity {
 	struct vsp1_device *vsp1;
 
 	enum vsp1_entity_type type;
 	unsigned int index;
-	unsigned int id;
-	unsigned int route;
+	const struct vsp1_route *route;
 
 	struct list_head list_dev;
 	struct list_head list_pipe;
@@ -45,6 +63,7 @@ struct vsp1_entity {
 	unsigned int source_pad;
 
 	struct media_entity *sink;
+	unsigned int sink_pad;
 
 	struct v4l2_subdev subdev;
 	struct v4l2_mbus_framefmt *formats;
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 28548535..db2950a 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -193,13 +193,10 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 
 	hsit->inverse = inverse;
 
-	if (inverse) {
+	if (inverse)
 		hsit->entity.type = VSP1_ENTITY_HSI;
-		hsit->entity.id = VI6_DPR_NODE_HSI;
-	} else {
+	else
 		hsit->entity.type = VSP1_ENTITY_HST;
-		hsit->entity.id = VI6_DPR_NODE_HST;
-	}
 
 	ret = vsp1_entity_init(vsp1, &hsit->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 74a32e6..2b275f6 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -215,7 +215,6 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 		return ERR_PTR(-ENOMEM);
 
 	lif->entity.type = VSP1_ENTITY_LIF;
-	lif->entity.id = VI6_DPR_NODE_LIF;
 
 	ret = vsp1_entity_init(vsp1, &lif->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 4e9dc7c..fea36eb 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -229,7 +229,6 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 		return ERR_PTR(-ENOMEM);
 
 	lut->entity.type = VSP1_ENTITY_LUT;
-	lut->entity.id = VI6_DPR_NODE_LUT;
 
 	ret = vsp1_entity_init(vsp1, &lut->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index bce2be5..97088d7 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -176,7 +176,6 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	rpf->entity.type = VSP1_ENTITY_RPF;
 	rpf->entity.index = index;
-	rpf->entity.id = VI6_DPR_NODE_RPF(index);
 
 	ret = vsp1_entity_init(vsp1, &rpf->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 7ab1a0b..aa0e04c 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -327,7 +327,6 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 		return ERR_PTR(-ENOMEM);
 
 	sru->entity.type = VSP1_ENTITY_SRU;
-	sru->entity.id = VI6_DPR_NODE_SRU;
 
 	ret = vsp1_entity_init(vsp1, &sru->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 0e50b37..509c9fe 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -323,7 +323,6 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 
 	uds->entity.type = VSP1_ENTITY_UDS;
 	uds->entity.index = index;
-	uds->entity.id = VI6_DPR_NODE_UDS(index);
 
 	ret = vsp1_entity_init(vsp1, &uds->entity, 2);
 	if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b4687a8..ce83145 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -461,7 +461,7 @@ static int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->route)
-			vsp1_write(entity->vsp1, entity->route,
+			vsp1_write(entity->vsp1, entity->route->reg,
 				   VI6_DPR_NODE_UNUSED);
 
 		v4l2_subdev_call(&entity->subdev, video, s_stream, 0);
@@ -680,11 +680,12 @@ static void vsp1_entity_route_setup(struct vsp1_entity *source)
 {
 	struct vsp1_entity *sink;
 
-	if (source->route == 0)
+	if (source->route->reg == 0)
 		return;
 
 	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_write(source->vsp1, source->route, sink->id);
+	vsp1_write(source->vsp1, source->route->reg,
+		   sink->route->inputs[source->sink_pad]);
 }
 
 static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 7baed81..974af6b 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -181,7 +181,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
-	wpf->entity.id = VI6_DPR_NODE_WPF(index);
 
 	ret = vsp1_entity_init(vsp1, &wpf->entity, 2);
 	if (ret < 0)
-- 
1.8.3.2

