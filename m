Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:40628 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0HTP3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Aug 2010 11:29:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v4 05/11] media: Reference count and power handling
Date: Fri, 20 Aug 2010 17:29:07 +0200
Message-Id: <1282318153-18885-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Basically these are the interface functions:

media_entity_get() - acquire entity
media_entity_put() - release entity

	If the entity is of node type, the power change is distributed to
	all connected entities. For non-nodes it only affects that very
	node. A mutex is used to serialise access to the entity graph.

In the background there's a depth-first search algorithm that traverses the
active links in the graph. All these functions parse the graph to implement
whatever they're to do.

The module counters are increased/decreased in media_entity_get/put to
prevent module unloading when an entity is referenced.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 Documentation/media-framework.txt |   37 +++++++++
 drivers/media/media-device.c      |    1 +
 drivers/media/media-entity.c      |  146 +++++++++++++++++++++++++++++++++++++
 include/media/media-device.h      |    4 +
 include/media/media-entity.h      |   15 ++++
 5 files changed, 203 insertions(+), 0 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index a599824..59649e9 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -278,3 +278,40 @@ When the graph traversal is complete the function will return NULL.
 Graph traversal can be interrupted at any moment. No cleanup function call is
 required and the graph structure can be freed normally.
 
+
+Reference counting and power handling
+-------------------------------------
+
+Before accessing type-specific entities operations (such as the V4L2
+sub-device operations), drivers must acquire a reference to the entity. This
+ensures that the entity will be powered on and ready to accept requests.
+Similarly, after being done with an entity, drivers must release the
+reference.
+
+	media_entity_get(struct media_entity *entity)
+
+The function will increase the entity reference count. If the entity is a node
+(MEDIA_ENTITY_TYPE_NODE type), the reference count of all entities it is
+connected to, both directly or indirectly, through active links is increased.
+This ensures that the whole media pipeline will be ready to process
+
+Acquiring a reference to an entity increases the media device module reference
+count to prevent module unloading when an entity is being used.
+
+media_entity_get will return a pointer to the entity if successful, or NULL
+otherwise.
+
+	media_entity_put(struct media_entity *entity)
+
+The function will decrease the entity reference count and, for node entities,
+like media_entity_get, the reference count of all connected entities. Calling
+media_entity_put with a NULL argument is valid and will return immediately.
+
+When the first reference to an entity is acquired, or the last reference
+released, the entity's set_power operation is called. Entity drivers must
+implement the operation if they need to perform any power management task,
+such as turning powers or clocks on or off. If no power management is
+required, drivers don't need to provide a set_power operation. The operation
+is allowed to fail when turning power on, in which case the media_entity_get
+function will return NULL.
+
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index eeb002e..c309d3c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -71,6 +71,7 @@ int __must_check media_device_register(struct media_device *mdev)
 	mdev->entity_id = 1;
 	INIT_LIST_HEAD(&mdev->entities);
 	spin_lock_init(&mdev->lock);
+	mutex_init(&mdev->graph_mutex);
 
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c277c18..da4fef6 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <media/media-entity.h>
+#include <media/media-device.h>
 
 /**
  * media_entity_init - Initialize a media entity
@@ -194,6 +195,151 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_next);
 
 /* -----------------------------------------------------------------------------
+ * Power state handling
+ */
+
+/* Apply use count to an entity. */
+static void media_entity_use_apply_one(struct media_entity *entity, int change)
+{
+	entity->use_count += change;
+	WARN_ON(entity->use_count < 0);
+}
+
+/*
+ * Apply use count change to an entity and change power state based on
+ * new use count.
+ */
+static int media_entity_power_apply_one(struct media_entity *entity, int change)
+{
+	int ret;
+
+	if (entity->use_count == 0 && change > 0 &&
+	    entity->ops && entity->ops->set_power) {
+		ret = entity->ops->set_power(entity, 1);
+		if (ret)
+			return ret;
+	}
+
+	media_entity_use_apply_one(entity, change);
+
+	if (entity->use_count == 0 && change < 0 &&
+	    entity->ops && entity->ops->set_power)
+		entity->ops->set_power(entity, 0);
+
+	return 0;
+}
+
+/*
+ * Apply power change to all connected entities. This ignores the
+ * nodes.
+ */
+static int media_entity_power_apply(struct media_entity *entity, int change)
+{
+	struct media_entity_graph graph;
+	struct media_entity *first = entity;
+	int ret = 0;
+
+	if (!change)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, entity);
+
+	while (!ret && (entity = media_entity_graph_walk_next(&graph)))
+		if (media_entity_type(entity) != MEDIA_ENTITY_TYPE_NODE)
+			ret = media_entity_power_apply_one(entity, change);
+
+	if (!ret)
+		return 0;
+
+	media_entity_graph_walk_start(&graph, first);
+
+	while ((first = media_entity_graph_walk_next(&graph))
+	       && first != entity)
+		if (media_entity_type(first) != MEDIA_ENTITY_TYPE_NODE)
+			media_entity_power_apply_one(first, -change);
+
+	return ret;
+}
+
+/*
+ * Apply use count change to graph and change power state of entities
+ * accordingly.
+ */
+static int media_entity_node_power_change(struct media_entity *entity,
+					  int change)
+{
+	/* Apply use count to node. */
+	media_entity_use_apply_one(entity, change);
+
+	/* Apply power change to connected non-nodes. */
+	return media_entity_power_apply(entity, change);
+}
+
+/*
+ * Node entity use changes are reflected on power state of all
+ * connected (directly or indirectly) entities whereas non-node entity
+ * use count changes are limited to that very entity.
+ */
+static int media_entity_use_change(struct media_entity *entity, int change)
+{
+	if (media_entity_type(entity) == MEDIA_ENTITY_TYPE_NODE)
+		return media_entity_node_power_change(entity, change);
+	else
+		return media_entity_power_apply_one(entity, change);
+}
+
+static struct media_entity *__media_entity_get(struct media_entity *entity)
+{
+	if (media_entity_use_change(entity, 1))
+		return NULL;
+
+	return entity;
+}
+
+static void __media_entity_put(struct media_entity *entity)
+{
+	media_entity_use_change(entity, -1);
+}
+
+/* user open()s media entity */
+struct media_entity *media_entity_get(struct media_entity *entity)
+{
+	struct media_entity *e;
+
+	if (entity == NULL)
+		return NULL;
+
+	if (entity->parent->dev &&
+	    !try_module_get(entity->parent->dev->driver->owner))
+		return NULL;
+
+	mutex_lock(&entity->parent->graph_mutex);
+	e = __media_entity_get(entity);
+	mutex_unlock(&entity->parent->graph_mutex);
+
+	if (e == NULL && entity->parent->dev)
+		module_put(entity->parent->dev->driver->owner);
+
+	return e;
+}
+EXPORT_SYMBOL_GPL(media_entity_get);
+
+/* user release()s media entity */
+void media_entity_put(struct media_entity *entity)
+{
+	if (entity == NULL)
+		return;
+
+	mutex_lock(&entity->parent->graph_mutex);
+	__media_entity_put(entity);
+	mutex_unlock(&entity->parent->graph_mutex);
+
+	if (entity->parent->dev)
+		module_put(entity->parent->dev->driver->owner);
+}
+EXPORT_SYMBOL_GPL(media_entity_put);
+
+/* -----------------------------------------------------------------------------
  * Links management
  */
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 7e2dac2..3c9a5e0 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -23,6 +23,7 @@
 
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 #include <media/media-devnode.h>
@@ -40,6 +41,7 @@
  * @entity_id:	ID of the next entity to be registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
+ * @graph_mutex: Entities graph operation lock
  *
  * This structure represents an abstract high-level media device. It allows easy
  * access to entities and provides basic media device-level support. The
@@ -67,6 +69,8 @@ struct media_device {
 
 	/* Protects the entities list */
 	spinlock_t lock;
+	/* Serializes graph operations. */
+	struct mutex graph_mutex;
 };
 
 int __must_check media_device_register(struct media_device *mdev);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3a7c74d..edcafeb 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -39,6 +39,10 @@ struct media_pad {
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FLAG_*) */
 };
 
+struct media_entity_operations {
+	int (*set_power)(struct media_entity *entity, int power);
+};
+
 struct media_entity {
 	struct list_head list;
 	struct media_device *parent;	/* Media device this entity belongs to*/
@@ -59,6 +63,10 @@ struct media_entity {
 	struct media_pad *pads;		/* Pads array (num_pads elements) */
 	struct media_link *links;	/* Links array (max_links elements)*/
 
+	const struct media_entity_operations *ops;	/* Entity operations */
+
+	int use_count;			/* Use count for the entity. */
+
 	union {
 		/* Node specifications */
 		struct {
@@ -103,9 +111,16 @@ void media_entity_cleanup(struct media_entity *entity);
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 
+struct media_entity *media_entity_get(struct media_entity *entity);
+void media_entity_put(struct media_entity *entity);
+
 void media_entity_graph_walk_start(struct media_entity_graph *graph,
 		struct media_entity *entity);
 struct media_entity *
 media_entity_graph_walk_next(struct media_entity_graph *graph);
 
+#define media_entity_call(entity, operation, args...)			\
+	(((entity)->ops && (entity)->ops->operation) ?			\
+	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
+
 #endif
-- 
1.7.1

