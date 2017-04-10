Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59413 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752844AbdDJT1b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 15:27:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCHv4 05/15] v4l: vsp1: Support histogram generators in pipeline configuration
Date: Mon, 10 Apr 2017 21:26:41 +0200
Message-Id: <20170410192651.18486-6-hverkuil@xs4all.nl>
In-Reply-To: <20170410192651.18486-1-hverkuil@xs4all.nl>
References: <20170410192651.18486-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Histogram generators are single-pad entities that branch as leaf nodes
at any point in the pipeline. Make sure that pipeline traversal and
routing configuration support them correctly.

Support for the actual HGO and HGT operation will come later.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c    |   2 +-
 drivers/media/platform/vsp1/vsp1_drv.c    |   4 +-
 drivers/media/platform/vsp1/vsp1_entity.c | 124 ++++++++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_entity.h |   8 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |   6 +-
 drivers/media/platform/vsp1/vsp1_video.c  |  18 ++---
 6 files changed, 134 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 1f88d8473b71..9d235e830f5a 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -496,7 +496,7 @@ void vsp1_du_atomic_flush(struct device *dev)
 			}
 		}
 
-		vsp1_entity_route_setup(entity, dl);
+		vsp1_entity_route_setup(entity, pipe, dl);
 
 		if (entity->ops->configure) {
 			entity->ops->configure(entity, pipe, dl,
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 8d1e61b353bb..83a6669a6328 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -105,7 +105,9 @@ static int vsp1_create_sink_links(struct vsp1_device *vsp1,
 		if (source->type == sink->type)
 			continue;
 
-		if (source->type == VSP1_ENTITY_LIF ||
+		if (source->type == VSP1_ENTITY_HGO ||
+		    source->type == VSP1_ENTITY_HGT ||
+		    source->type == VSP1_ENTITY_LIF ||
 		    source->type == VSP1_ENTITY_WPF)
 			continue;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 12eca5660d6e..88a2aae182ba 100644
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
@@ -28,11 +30,14 @@ media_entity_to_vsp1_entity(struct media_entity *entity)
 	return container_of(entity, struct vsp1_entity, subdev.entity);
 }
 
-void vsp1_entity_route_setup(struct vsp1_entity *source,
+void vsp1_entity_route_setup(struct vsp1_entity *entity,
+			     struct vsp1_pipeline *pipe,
 			     struct vsp1_dl_list *dl)
 {
+	struct vsp1_entity *source;
 	struct vsp1_entity *sink;
 
+	source = entity;
 	if (source->route->reg == 0)
 		return;
 
@@ -283,25 +288,32 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
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
+		/*
+		 * Fan-out is limited to one for the normal data path plus
+		 * optional HGO and HGT. We ignore the HGO and HGT here.
+		 */
+		if (sink->type != VSP1_ENTITY_HGO &&
+		    sink->type != VSP1_ENTITY_HGT) {
+			if (source->sink)
+				return -EBUSY;
+			source->sink = sink_pad->entity;
+			source->sink_pad = sink_pad->index;
+		}
 	} else {
 		source->sink = NULL;
 		source->sink_pad = 0;
@@ -310,6 +322,85 @@ int vsp1_entity_link_setup(struct media_entity *entity,
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
+ * higher than one for the data pipelines, except for the links to the HGO and
+ * HGT that can be enabled in addition to a regular data link. When traversing
+ * outgoing links this function ignores HGO and HGT entities and should thus be
+ * used in place of the generic media_entity_remote_pad() function to traverse
+ * data pipelines.
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
+		/* If we're the sink the source will never be an HGO or HGT. */
+		if (link->sink == pad)
+			return link->source;
+
+		if (link->source != pad)
+			continue;
+
+		/* If the sink isn't a subdevice it can't be an HGO or HGT. */
+		if (!is_media_entity_v4l2_subdev(link->sink->entity))
+			return link->sink;
+
+		entity = media_entity_to_vsp1_entity(link->sink->entity);
+		if (entity->type != VSP1_ENTITY_HGO &&
+		    entity->type != VSP1_ENTITY_HGT)
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
@@ -388,7 +479,14 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
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
index 901146f807b9..c169a060b6d2 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -25,6 +25,8 @@ struct vsp1_pipeline;
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
 	VSP1_ENTITY_CLU,
+	VSP1_ENTITY_HGO,
+	VSP1_ENTITY_HGT,
 	VSP1_ENTITY_HSI,
 	VSP1_ENTITY_HST,
 	VSP1_ENTITY_LIF,
@@ -102,6 +104,7 @@ struct vsp1_entity {
 	struct media_pad *pads;
 	unsigned int source_pad;
 
+	struct media_entity **sources;
 	struct media_entity *sink;
 	unsigned int sink_pad;
 
@@ -142,9 +145,12 @@ vsp1_entity_get_pad_selection(struct vsp1_entity *entity,
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
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 35364f594e19..b5a765cbfc86 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -252,6 +252,7 @@ bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe)
 
 int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 {
+	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
 	unsigned long flags;
 	int ret;
@@ -261,8 +262,7 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 		 * When using display lists in continuous frame mode the only
 		 * way to stop the pipeline is to reset the hardware.
 		 */
-		ret = vsp1_reset_wpf(pipe->output->entity.vsp1,
-				     pipe->output->entity.index);
+		ret = vsp1_reset_wpf(vsp1, pipe->output->entity.index);
 		if (ret == 0) {
 			spin_lock_irqsave(&pipe->irqlock, flags);
 			pipe->state = VSP1_PIPELINE_STOPPED;
@@ -282,7 +282,7 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->route && entity->route->reg)
-			vsp1_write(entity->vsp1, entity->route->reg,
+			vsp1_write(vsp1, entity->route->reg,
 				   VI6_DPR_NODE_UNUSED);
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 795a3ca9ca03..86c33994468b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -486,7 +486,12 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 	if (ret < 0)
 		return ret;
 
-	pad = media_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
+	/*
+	 * The main data path doesn't include the HGO or HGT, use
+	 * vsp1_entity_remote_pad() to traverse the graph.
+	 */
+
+	pad = vsp1_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
 
 	while (1) {
 		if (pad == NULL) {
@@ -539,14 +544,9 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 					: &input->entity;
 		}
 
-		/*
-		 * Follow the source link. The link setup operations ensure
-		 * that the output fan-out can't be more than one, there is thus
-		 * no need to verify here that only a single source link is
-		 * activated.
-		 */
+		/* Follow the source link, ignoring any HGO or HGT. */
 		pad = &entity->pads[entity->source_pad];
-		pad = media_entity_remote_pad(pad);
+		pad = vsp1_entity_remote_pad(pad);
 	}
 
 	/* The last entity must be the output WPF. */
@@ -800,7 +800,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, pipe->dl);
 
 		if (entity->ops->configure)
 			entity->ops->configure(entity, pipe, pipe->dl,
-- 
2.11.0
