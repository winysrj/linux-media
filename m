Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:18900 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2BBXzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:03 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 13/31] media: Add link_validate() op to check links to the sink pad
Date: Fri,  3 Feb 2012 01:54:33 +0200
Message-Id: <1328226891-8968-13-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The purpose of the link_validate() op is to allow an entity driver to ensure
that the properties of the pads at the both ends of the link are suitable
for starting the pipeline. link_validate is called on sink pads on active
links which belong to the active part of the graph.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/media-framework.txt |   19 +++++++++++++
 drivers/media/media-entity.c      |   53 +++++++++++++++++++++++++++++++++++-
 include/media/media-entity.h      |    5 ++-
 3 files changed, 73 insertions(+), 4 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 3a0f879..0e90169 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -335,6 +335,9 @@ the media_entity pipe field.
 Calls to media_entity_pipeline_start() can be nested. The pipeline pointer must
 be identical for all nested calls to the function.
 
+media_entity_pipeline_start() may return an error. In that case, it will
+clean up any the changes it did by itself.
+
 When stopping the stream, drivers must notify the entities with
 
 	media_entity_pipeline_stop(struct media_entity *entity);
@@ -351,3 +354,19 @@ If other operations need to be disallowed on streaming entities (such as
 changing entities configuration parameters) drivers can explicitly check the
 media_entity stream_count field to find out if an entity is streaming. This
 operation must be done with the media_device graph_mutex held.
+
+
+Link validation
+---------------
+
+Link validation is performed from media_entity_pipeline_start() for any
+entity which has sink pads in the pipeline. The
+media_entity::link_validate() callback is used for that purpose. In
+link_validate() callback, entity driver should check that the properties of
+the source pad of the connected entity and its own sink pad match. It is up
+to the type of the entity (and in the end, the properties of the hardware)
+what matching actually means.
+
+Subsystems should facilitate link validation by providing subsystem specific
+helper functions to provide easy access for commonly needed information, and
+in the end provide a way to use driver-specific callbacks.
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 056138f..678ec07 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -214,23 +214,72 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
  * pipeline pointer must be identical for all nested calls to
  * media_entity_pipeline_start().
  */
-void media_entity_pipeline_start(struct media_entity *entity,
-				 struct media_pipeline *pipe)
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe)
 {
 	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
+	struct media_entity *entity_err = entity;
+	int ret = 0;
 
 	mutex_lock(&mdev->graph_mutex);
 
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
+		int i;
+
 		entity->stream_count++;
 		WARN_ON(entity->pipe && entity->pipe != pipe);
 		entity->pipe = pipe;
+
+		/* Already streaming --- no need to check. */
+		if (entity->stream_count > 1)
+			continue;
+
+		if (!entity->ops || !entity->ops->link_validate)
+			continue;
+
+		for (i = 0; i < entity->num_links; i++) {
+			struct media_link *link = &entity->links[i];
+
+			/* Is this pad part of an enabled link? */
+			if ((link->flags & MEDIA_LNK_FL_ENABLED)
+			    != MEDIA_LNK_FL_ENABLED)
+				continue;
+
+			/* Are we the sink or not? */
+			if (link->sink->entity != entity)
+				continue;
+
+			ret = entity->ops->link_validate(link);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				break;
+		}
+		if (ret < 0 && ret != -ENOIOCTLCMD)
+			goto error;
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
+
+	return 0;
+
+error:
+	/*
+	 * Link validation on graph failed. We revert what we did and
+	 * return the error.
+	 */
+	media_entity_graph_walk_start(&graph, entity_err);
+	do {
+		entity_err = media_entity_graph_walk_next(&graph);
+		entity_err->stream_count--;
+		if (entity_err->stream_count == 0)
+			entity_err->pipe = NULL;
+	} while (entity_err != entity);
+
+	mutex_unlock(&mdev->graph_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 29e7bba..0c16f51 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -46,6 +46,7 @@ struct media_entity_operations {
 	int (*link_setup)(struct media_entity *entity,
 			  const struct media_pad *local,
 			  const struct media_pad *remote, u32 flags);
+	int (*link_validate)(struct media_link *link);
 };
 
 struct media_entity {
@@ -140,8 +141,8 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
-void media_entity_pipeline_start(struct media_entity *entity,
-		struct media_pipeline *pipe);
+__must_check int media_entity_pipeline_start(struct media_entity *entity,
+					     struct media_pipeline *pipe);
 void media_entity_pipeline_stop(struct media_entity *entity);
 
 #define media_entity_call(entity, operation, args...)			\
-- 
1.7.2.5

