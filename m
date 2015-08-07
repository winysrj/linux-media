Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbbHGOUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:23 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH RFC v2 08/16] media: convert links from array to list
Date: Fri,  7 Aug 2015 11:20:06 -0300
Message-Id: <65340c7d01bdfcadbb82f92d63a3571871d07930.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using memory realloc to increase the size of an array
is complex and makes harder to remove links. Also, by
embedding the link inside an array at the entity makes harder
to change the code to add interfaces, as interfaces will
also need to use links.

So, convert the links from arrays to lists.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 9fb3f8958265..a95ca981aabb 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -25,6 +25,7 @@
 #include <linux/ioctl.h>
 #include <linux/media.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -148,22 +149,22 @@ static long __media_device_enum_links(struct media_device *mdev,
 	}
 
 	if (links->links) {
-		struct media_link_desc __user *ulink;
-		unsigned int l;
+		struct media_link *ent_link;
+		struct media_link_desc __user *ulink = links->links;
 
-		for (l = 0, ulink = links->links; l < entity->num_links; l++) {
+		list_for_each_entry(ent_link, &entity->links, list) {
 			struct media_link_desc link;
 
 			/* Ignore backlinks. */
-			if (entity->links[l].source->entity != entity)
+			if (ent_link->source->entity != entity)
 				continue;
 
 			memset(&link, 0, sizeof(link));
-			media_device_kpad_to_upad(entity->links[l].source,
+			media_device_kpad_to_upad(ent_link->source,
 						  &link.source);
-			media_device_kpad_to_upad(entity->links[l].sink,
+			media_device_kpad_to_upad(ent_link->sink,
 						  &link.sink);
-			link.flags = entity->links[l].flags;
+			link.flags = ent_link->flags;
 			if (copy_to_user(ulink, &link, sizeof(*ulink)))
 				return -EFAULT;
 			ulink++;
@@ -471,6 +472,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 {
 	int i;
 	struct media_device *mdev = entity->parent;
+	struct media_link *link, *tmp;
 
 	if (mdev == NULL)
 		return;
@@ -479,8 +481,11 @@ void media_device_unregister_entity(struct media_entity *entity)
 	graph_obj_remove(&entity->graph_obj);
 	for (i = 0; entity->num_pads; i++)
 		graph_obj_remove(&entity->pads[i].graph_obj);
-	for (i = 0; entity->num_links; i++)
-		graph_obj_remove(&entity->links[i].graph_obj);
+	list_for_each_entry_safe(link, tmp, &entity->links, list) {
+		graph_obj_remove(&link->graph_obj);
+		list_del(&link->list);
+		kfree(link);
+	}
 	list_del(&entity->list);
 	spin_unlock(&mdev->lock);
 	entity->parent = NULL;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e8451a4a403b..4a42ccfeffab 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -76,14 +76,6 @@ void graph_obj_remove(struct media_graph_obj *gobj)
  * use cases the entity driver can guess the number of links which can safely
  * be assumed to be equal to or larger than the number of pads.
  *
- * For those reasons the links array can be preallocated based on the entity
- * driver guess and will be reallocated later if extra links need to be
- * created.
- *
- * This function allocates a links array with enough space to hold at least
- * 'num_pads' + 'extra_links' elements. The media_entity::max_links field will
- * be set to the number of allocated elements.
- *
  * The pads array is managed by the entity driver and passed to
  * media_entity_init() where its pointer will be stored in the entity structure.
  */
@@ -91,21 +83,14 @@ int
 media_entity_init(struct media_entity *entity, u16 num_pads,
 		  struct media_pad *pads)
 {
-	struct media_link *links;
-	unsigned int max_links = num_pads;
 	unsigned int i;
 
-	links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
-	if (links == NULL)
-		return -ENOMEM;
-
 	entity->group_id = 0;
-	entity->max_links = max_links;
 	entity->num_links = 0;
 	entity->num_backlinks = 0;
 	entity->num_pads = num_pads;
 	entity->pads = pads;
-	entity->links = links;
+	INIT_LIST_HEAD(&entity->links);
 
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
@@ -119,7 +104,13 @@ EXPORT_SYMBOL_GPL(media_entity_init);
 void
 media_entity_cleanup(struct media_entity *entity)
 {
-	kfree(entity->links);
+	struct media_link *link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &entity->links, list) {
+		graph_obj_remove(&link->graph_obj);
+		list_del(&link->list);
+		kfree(link);
+	}
 }
 EXPORT_SYMBOL_GPL(media_entity_cleanup);
 
@@ -145,7 +136,7 @@ static void stack_push(struct media_entity_graph *graph,
 		return;
 	}
 	graph->top++;
-	graph->stack[graph->top].link = 0;
+	graph->stack[graph->top].link = entity->links;
 	graph->stack[graph->top].entity = entity;
 }
 
@@ -187,6 +178,7 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 
+
 /**
  * media_entity_graph_walk_next - Get the next entity in the graph
  * @graph: Media graph structure
@@ -210,14 +202,16 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 	 * top of the stack until no more entities on the level can be
 	 * found.
 	 */
-	while (link_top(graph) < stack_top(graph)->num_links) {
+	while (list_is_last(&link_top(graph), &(stack_top(graph)->links))) {
 		struct media_entity *entity = stack_top(graph);
-		struct media_link *link = &entity->links[link_top(graph)];
+		struct media_link *link;
 		struct media_entity *next;
 
+		link = list_last_entry(&link_top(graph), typeof(*link), list);
+
 		/* The link is not enabled so we do not follow. */
 		if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
-			link_top(graph)++;
+			list_rotate_left(&link_top(graph));
 			continue;
 		}
 
@@ -228,12 +222,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Has the entity already been visited? */
 		if (__test_and_set_bit(next->id, graph->entities)) {
-			link_top(graph)++;
+			list_rotate_left(&link_top(graph));
 			continue;
 		}
 
 		/* Push the new entity to stack and start over. */
-		link_top(graph)++;
+		list_rotate_left(&link_top(graph));
 		stack_push(graph, next);
 	}
 
@@ -265,6 +259,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_device *mdev = entity->parent;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
+	struct media_link *link;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -274,7 +269,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		DECLARE_BITMAP(active, entity->num_pads);
 		DECLARE_BITMAP(has_no_links, entity->num_pads);
-		unsigned int i;
 
 		entity->stream_count++;
 		WARN_ON(entity->pipe && entity->pipe != pipe);
@@ -290,8 +284,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		bitmap_zero(active, entity->num_pads);
 		bitmap_fill(has_no_links, entity->num_pads);
 
-		for (i = 0; i < entity->num_links; i++) {
-			struct media_link *link = &entity->links[i];
+		list_for_each_entry(link, &entity->links, list) {
 			struct media_pad *pad = link->sink->entity == entity
 						? link->sink : link->source;
 
@@ -452,27 +445,21 @@ EXPORT_SYMBOL_GPL(media_entity_put);
 
 static struct media_link *media_entity_add_link(struct media_entity *entity)
 {
-	if (entity->num_links >= entity->max_links) {
-		struct media_link *links = entity->links;
-		unsigned int max_links = entity->max_links + 2;
-		unsigned int i;
+	struct media_link *link;
 
-		links = krealloc(links, max_links * sizeof(*links), GFP_KERNEL);
-		if (links == NULL)
-			return NULL;
+	link = kzalloc(sizeof(*link), GFP_KERNEL);
+	if (link == NULL)
+		return NULL;
 
-		for (i = 0; i < entity->num_links; i++)
-			links[i].reverse->reverse = &links[i];
-
-		entity->max_links = max_links;
-		entity->links = links;
-	}
+	link->reverse->reverse = link;
+	INIT_LIST_HEAD(&link->list);
+	list_add(&entity->links, &link->list);
 
 	/* Initialize graph object embedded at the new link */
 	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
-			&entity->links[entity->num_links].graph_obj);
+			&link->graph_obj);
 
-	return &entity->links[entity->num_links++];
+	return link;
 }
 
 int
@@ -516,38 +503,44 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_entity_create_link);
 
-void __media_entity_remove_links(struct media_entity *entity)
+static void __media_entity_remove_link(struct media_entity *entity,
+				       struct media_link *link)
 {
-	unsigned int i;
+	struct media_link *rlink, *tmp;
+	struct media_entity *remote;
+	unsigned int r = 0;
 
-	for (i = 0; i < entity->num_links; i++) {
-		struct media_link *link = &entity->links[i];
-		struct media_entity *remote;
-		unsigned int r = 0;
+	if (link->source->entity == entity)
+		remote = link->sink->entity;
+	else
+		remote = link->source->entity;
+
+	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
+		if (rlink != link->reverse) {
+			r++;
+			continue;
+		}
 
 		if (link->source->entity == entity)
-			remote = link->sink->entity;
-		else
-			remote = link->source->entity;
+			remote->num_backlinks--;
 
-		while (r < remote->num_links) {
-			struct media_link *rlink = &remote->links[r];
+		if (--remote->num_links == 0)
+			break;
 
-			if (rlink != link->reverse) {
-				r++;
-				continue;
-			}
-
-			if (link->source->entity == entity)
-				remote->num_backlinks--;
-
-			if (--remote->num_links == 0)
-				break;
-
-			/* Insert last entry in place of the dropped link. */
-			*rlink = remote->links[remote->num_links];
-		}
+		/* Remove the remote link */
+		list_del(&rlink->list);
+		kfree(rlink);
 	}
+	list_del(&link->list);
+	kfree(link);
+}
+
+void __media_entity_remove_links(struct media_entity *entity)
+{
+	struct media_link *link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &entity->links, list)
+		__media_entity_remove_link(entity, link);
 
 	entity->num_links = 0;
 	entity->num_backlinks = 0;
@@ -672,11 +665,8 @@ struct media_link *
 media_entity_find_link(struct media_pad *source, struct media_pad *sink)
 {
 	struct media_link *link;
-	unsigned int i;
-
-	for (i = 0; i < source->entity->num_links; ++i) {
-		link = &source->entity->links[i];
 
+	list_for_each_entry(link, &source->entity->links, list) {
 		if (link->source->entity == source->entity &&
 		    link->source->index == source->index &&
 		    link->sink->entity == sink->entity &&
@@ -700,11 +690,9 @@ EXPORT_SYMBOL_GPL(media_entity_find_link);
  */
 struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 {
-	unsigned int i;
-
-	for (i = 0; i < pad->entity->num_links; i++) {
-		struct media_link *link = &pad->entity->links[i];
+	struct media_link *link;
 
+	list_for_each_entry(link, &pad->entity->links, list) {
 		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
 			continue;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 8f04b125486f..e8baff4d6290 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -106,7 +106,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity  *entity, *decoder = NULL, *source;
 	struct media_link *link, *found_link = NULL;
-	int i, ret, active_links = 0;
+	int ret, active_links = 0;
 
 	if (!mdev)
 		return 0;
@@ -127,8 +127,7 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 	if (!decoder)
 		return 0;
 
-	for (i = 0; i < decoder->num_links; i++) {
-		link = &decoder->links[i];
+	list_for_each_entry(link, &decoder->links, list) {
 		if (link->sink->entity == decoder) {
 			found_link = link;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
@@ -141,11 +140,10 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
 		return 0;
 
 	source = found_link->source->entity;
-	for (i = 0; i < source->num_links; i++) {
+	list_for_each_entry(link, &source->links, list) {
 		struct media_entity *sink;
 		int flags = 0;
 
-		link = &source->links[i];
 		sink = link->sink->entity;
 
 		if (sink == entity)
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index be6885e7c8ed..403019035424 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -71,6 +71,7 @@ struct media_pipeline {
 };
 
 struct media_link {
+	struct list_head list;
 	struct media_graph_obj			graph_obj;
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
@@ -117,10 +118,9 @@ struct media_entity {
 	u16 num_links;			/* Number of existing links, both
 					 * enabled and disabled */
 	u16 num_backlinks;		/* Number of backlinks */
-	u16 max_links;			/* Maximum number of links */
 
 	struct media_pad *pads;		/* Pads array (num_pads elements) */
-	struct media_link *links;	/* Links array (max_links elements)*/
+	struct list_head links;		/* Links list */
 
 	const struct media_entity_operations *ops;	/* Entity operations */
 
@@ -161,7 +161,7 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-		int link;
+		struct list_head link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
 	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
@@ -177,7 +177,7 @@ void graph_obj_init(struct media_device *mdev,
 void graph_obj_remove(struct media_graph_obj *gobj);
 
 int media_entity_init(struct media_entity *entity, u16 num_pads,
-		struct media_pad *pads);
+		      struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
 
 int media_entity_create_link(struct media_entity *source, u16 source_pad,
-- 
2.4.3

