Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:16381 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbeKBIh5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:37:57 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 04/30] v4l: mc: Start walk from a specific pad in use count calculation
Date: Fri,  2 Nov 2018 00:31:18 +0100
Message-Id: <20181101233144.31507-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

With the addition of the recent has_route() media entity op, the pads of a
media entity are no longer all interconnected. This has to be taken into
account in power management.

Prepare for the addition of a helper function supporting S_ROUTING.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-mc.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index 98edd47b2f0ae747..208cd91ce57ff211 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -332,17 +332,16 @@ EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
 
 /*
  * pipeline_pm_use_count - Count the number of users of a pipeline
- * @entity: The entity
+ * @pad: The pad
  *
  * Return the total number of users of all video device nodes in the pipeline.
  */
-static int pipeline_pm_use_count(struct media_entity *entity,
-	struct media_graph *graph)
+static int pipeline_pm_use_count(struct media_pad *pad,
+				 struct media_graph *graph)
 {
-	struct media_pad *pad;
 	int use = 0;
 
-	media_graph_walk_start(graph, entity->pads);
+	media_graph_walk_start(graph, pad);
 
 	while ((pad = media_graph_walk_next(graph))) {
 		if (is_media_entity_v4l2_video_device(pad->entity))
@@ -388,7 +387,7 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
 
 /*
  * pipeline_pm_power - Apply power change to all entities in a pipeline
- * @entity: The entity
+ * @pad: The pad
  * @change: Use count change
  *
  * Walk the pipeline to update the use count and the power state of all non-node
@@ -396,16 +395,16 @@ static int pipeline_pm_power_one(struct media_entity *entity, int change)
  *
  * Return 0 on success or a negative error code on failure.
  */
-static int pipeline_pm_power(struct media_entity *entity, int change,
+static int pipeline_pm_power(struct media_pad *pad, int change,
 	struct media_graph *graph)
 {
-	struct media_pad *tmp_pad, *pad;
+	struct media_pad *tmp_pad, *first = pad;
 	int ret = 0;
 
 	if (!change)
 		return 0;
 
-	media_graph_walk_start(graph, entity->pads);
+	media_graph_walk_start(graph, pad);
 
 	while (!ret && (pad = media_graph_walk_next(graph)))
 		if (is_media_entity_v4l2_subdev(pad->entity))
@@ -414,7 +413,7 @@ static int pipeline_pm_power(struct media_entity *entity, int change,
 	if (!ret)
 		return ret;
 
-	media_graph_walk_start(graph, entity->pads);
+	media_graph_walk_start(graph, first);
 
 	while ((tmp_pad = media_graph_walk_next(graph))
 	       && tmp_pad != pad)
@@ -437,7 +436,7 @@ int v4l2_pipeline_pm_use(struct media_entity *entity, int use)
 	WARN_ON(entity->use_count < 0);
 
 	/* Apply power change to connected non-nodes. */
-	ret = pipeline_pm_power(entity, change, &mdev->pm_count_walk);
+	ret = pipeline_pm_power(entity->pads, change, &mdev->pm_count_walk);
 	if (ret < 0)
 		entity->use_count -= change;
 
@@ -451,8 +450,8 @@ int v4l2_pipeline_link_notify(struct media_link *link, u32 flags,
 			      unsigned int notification)
 {
 	struct media_graph *graph = &link->graph_obj.mdev->pm_count_walk;
-	struct media_entity *source = link->source->entity;
-	struct media_entity *sink = link->sink->entity;
+	struct media_pad *source = link->source;
+	struct media_pad *sink = link->sink;
 	int source_use;
 	int sink_use;
 	int ret = 0;
-- 
2.19.1
