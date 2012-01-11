Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:21587 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933993Ab2AKV1U (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:20 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 16/23] media: Add link_validate op to check links to the sink pad
Date: Wed, 11 Jan 2012 23:26:53 +0200
Message-Id: <1326317220-15339-16-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/media-entity.c |   73 ++++++++++++++++++++++++++++++++++++++++-
 include/media/media-entity.h |    5 ++-
 2 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 056138f..62ef4b8 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -196,6 +196,35 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
+struct media_link_enum {
+	int i;
+	struct media_entity *entity;
+	unsigned long flags, mask;
+};
+
+static struct media_link
+*media_link_walk_next(struct media_link_enum *link_enum)
+{
+	do {
+		link_enum->i++;
+		if (link_enum->i >= link_enum->entity->num_links)
+			return NULL;
+	} while ((link_enum->entity->links[link_enum->i].flags
+		  & link_enum->mask) != link_enum->flags);
+
+	return &link_enum->entity->links[link_enum->i];
+}
+
+static void media_link_walk_start(struct media_link_enum *link_enum,
+				  struct media_entity *entity,
+				  unsigned long flags, unsigned long mask)
+{
+	link_enum->i = -1;
+	link_enum->entity = entity;
+	link_enum->flags = flags;
+	link_enum->mask = mask;
+}
+
 /* -----------------------------------------------------------------------------
  * Pipeline management
  */
@@ -214,23 +243,63 @@ EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
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
+	struct media_entity *tmp = entity;
+	int ret = 0;
 
 	mutex_lock(&mdev->graph_mutex);
 
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
+		struct media_entity_graph tmp_graph;
+		struct media_link_enum link_enum;
+		struct media_link *link;
+
 		entity->stream_count++;
 		WARN_ON(entity->pipe && entity->pipe != pipe);
 		entity->pipe = pipe;
+
+		if (!entity->ops || !entity->ops->link_validate)
+			continue;
+
+		media_link_walk_start(&link_enum, entity,
+				      MEDIA_LNK_FL_ENABLED,
+				      MEDIA_LNK_FL_ENABLED);
+
+		while ((link = media_link_walk_next(&link_enum))) {
+			if (link->sink->entity != entity)
+				continue;
+
+			ret = entity->ops->link_validate(link);
+			if (ret < 0 && ret != -ENOIOCTLCMD)
+				break;
+		}
+		if (!ret || ret == -ENOIOCTLCMD)
+			continue;
+
+		/*
+		 * Link validation on graph failed. We revert what we
+		 * did and return the error.
+		 */
+		media_entity_graph_walk_start(&tmp_graph, tmp);
+		do {
+			tmp = media_entity_graph_walk_next(&tmp_graph);
+			tmp->stream_count--;
+			if (entity->stream_count == 0)
+				entity->pipe = NULL;
+		} while (tmp != entity);
+
+		break;
 	}
 
 	mutex_unlock(&mdev->graph_mutex);
+
+	return ret == 0 || ret == -ENOIOCTLCMD ? 0 : ret;
 }
 EXPORT_SYMBOL_GPL(media_entity_pipeline_start);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index cd8bca6..f7ba80a 100644
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

