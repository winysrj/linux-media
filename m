Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031416Ab3HIXC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 05/19] video: display: Graph helpers
Date: Sat, 10 Aug 2013 01:03:04 +0200
Message-Id: <1376089398-13322-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add two graph helper functions. display_entity_build_notifier() builds
an entity notifier from an entities graph represented as a flat array,
typically passed from platform data. display_entity_link_graph() can
then be used to create media controller links between all entities in
the graph.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/video/display/display-core.c     | 107 +++++++++++++++++++++++++++++++
 drivers/video/display/display-notifier.c |  51 +++++++++++++++
 include/video/display.h                  |  20 ++++++
 3 files changed, 178 insertions(+)

diff --git a/drivers/video/display/display-core.c b/drivers/video/display/display-core.c
index bb18723..c3b47d3 100644
--- a/drivers/video/display/display-core.c
+++ b/drivers/video/display/display-core.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/device.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -313,6 +314,112 @@ void display_entity_unregister(struct display_entity *entity)
 }
 EXPORT_SYMBOL_GPL(display_entity_unregister);
 
+/* -----------------------------------------------------------------------------
+ * Graph Helpers
+ */
+
+static int display_entity_link_entity(struct device *dev,
+				      struct display_entity *entity,
+				      struct list_head *entities)
+{
+	const struct display_entity_graph_data *graph = entity->match->data;
+	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+	struct media_entity *local = &entity->entity;
+	unsigned int i;
+	int ret = 0;
+
+	dev_dbg(dev, "creating links for entity %s\n", local->name);
+
+	for (i = 0; i < entity->entity.num_pads; ++i) {
+		const struct display_entity_source_data *source;
+		struct media_pad *local_pad = &local->pads[i];
+		struct media_entity *remote = NULL;
+		struct media_pad *remote_pad;
+		struct display_entity *ent;
+
+		dev_dbg(dev, "processing pad %u\n", i);
+
+		/* Skip source pads, they will be processed from the other end
+		 * of the link.
+		 */
+		if (local_pad->flags & MEDIA_PAD_FL_SOURCE) {
+			dev_dbg(dev, "skipping source pad %s:%u\n",
+				local->name, i);
+			continue;
+		}
+
+		/* Find the remote entity. If not found, just skip the link as
+		 * it goes out of scope of the entities handled by the notifier.
+		 */
+		source = &graph->sources[i];
+		list_for_each_entry(ent, entities, list) {
+			if (strcmp(source->name, dev_name(ent->dev)) == 0) {
+				remote = &ent->entity;
+				break;
+			}
+		}
+
+		if (remote == NULL) {
+			dev_dbg(dev, "no entity found for %s\n", source->name);
+			continue;
+		}
+
+		if (source->port >= remote->num_pads) {
+			dev_err(dev, "invalid port number %u on %s\n",
+				source->port, source->name);
+			ret = -EINVAL;
+			break;
+		}
+
+		remote_pad = &remote->pads[source->port];
+
+		/* Create the media link. */
+		dev_dbg(dev, "creating %s:%u -> %s:%u link\n",
+			remote->name, remote_pad->index,
+			local->name, local_pad->index);
+
+		ret = media_entity_create_link(remote, remote_pad->index,
+					       local, local_pad->index,
+					       link_flags);
+		if (ret < 0) {
+			dev_err(dev, "failed to create %s:%u -> %s:%u link\n",
+				remote->name, remote_pad->index,
+				local->name, local_pad->index);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * display_entity_link_graph - Link all entities in a graph
+ * @dev: device used to print debugging and error messages
+ * @entities: list of display entities in the graph
+ *
+ * This function creates media controller links for all entities in a graph
+ * based on graph link data. It relies on the entities match data pointers
+ * having been initialized by the display_entity_build_notifier() function when
+ * building the notifier and thus can't be used when the notifier is built in a
+ * different way.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int display_entity_link_graph(struct device *dev, struct list_head *entities)
+{
+	struct display_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, entities, list) {
+		ret = display_entity_link_entity(dev, entity, entities);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_link_graph);
+
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("Display Core");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/display/display-notifier.c b/drivers/video/display/display-notifier.c
index c9210ec..2d752b3 100644
--- a/drivers/video/display/display-notifier.c
+++ b/drivers/video/display/display-notifier.c
@@ -220,6 +220,57 @@ void display_entity_unregister_notifier(struct display_entity_notifier *notifier
 }
 EXPORT_SYMBOL_GPL(display_entity_unregister_notifier);
 
+/**
+ * display_entity_build_notifier - build a notifier from graph data
+ * @notifier: display entity notifier to be built
+ * @graph: graph data
+ *
+ * Before registering a notifier drivers must initialize the notifier's list of
+ * entities. This helper function simplifies building the list of entities for
+ * drivers that use an array of struct display_entity_graph_data to describe the
+ * entities graph.
+ *
+ * The function allocates an array of struct display_entity_match, initialize it
+ * from graph data, and sets the notifier entities and num_entities fields.
+ *
+ * The entities array is allocated using the managed memory allocation API on
+ * the notifier device, which must be initialized before calling this function.
+ *
+ * Return 0 on success or a negative error code on error.
+ */
+int display_entity_build_notifier(struct display_entity_notifier *notifier,
+				  const struct display_entity_graph_data *graph)
+{
+	struct display_entity_match *entities;
+	unsigned int num_entities;
+	unsigned int i;
+
+	for (num_entities = 0; graph[num_entities].name; ++num_entities) {
+	}
+
+	if (num_entities == 0)
+		return -EINVAL;
+
+	entities = devm_kzalloc(notifier->dev, sizeof(*notifier->entities) *
+				num_entities, GFP_KERNEL);
+	if (entities == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < num_entities; ++i) {
+		struct display_entity_match *match = &entities[i];
+
+		match->type = DISPLAY_ENTITY_BUS_PLATFORM;
+		match->match.platform.name = graph[i].name;
+		match->data = &graph[i];
+	}
+
+	notifier->num_entities = num_entities;
+	notifier->entities = entities;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(display_entity_build_notifier);
+
 /* -----------------------------------------------------------------------------
  * Entity Registration
  */
diff --git a/include/video/display.h b/include/video/display.h
index 2063694..58ff0d1 100644
--- a/include/video/display.h
+++ b/include/video/display.h
@@ -159,6 +159,7 @@ enum display_entity_bus_type {
  * @match.platform.name: platform device name
  * @match.dt.node: DT node
  * @list: link match objects waiting to be matched
+ * @data: driver private data, not touched by the core
  */
 struct display_entity_match {
 	enum display_entity_bus_type type;
@@ -169,6 +170,7 @@ struct display_entity_match {
 	} match;
 
 	struct list_head list;
+	const void *data;
 };
 
 /**
@@ -206,4 +208,22 @@ void display_entity_unregister_notifier(struct display_entity_notifier *notifier
 int display_entity_add(struct display_entity *entity);
 void display_entity_remove(struct display_entity *entity);
 
+/* -----------------------------------------------------------------------------
+ * Graph Helpers
+ */
+
+struct display_entity_source_data {
+	const char *name;
+	unsigned int port;
+};
+
+struct display_entity_graph_data {
+	const char *name;
+	const struct display_entity_source_data *sources;
+};
+
+int display_entity_build_notifier(struct display_entity_notifier *notifier,
+				  const struct display_entity_graph_data *graph);
+int display_entity_link_graph(struct device *dev, struct list_head *entities);
+
 #endif /* __DISPLAY_H__ */
-- 
1.8.1.5

