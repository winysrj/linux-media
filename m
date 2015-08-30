Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbbH3DHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v8 19/55] [media] media: convert links from array to list
Date: Sun, 30 Aug 2015 00:06:30 -0300
Message-Id: <2547965181e69b3e0e8c4c1aed67668d580a8e58.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The entire logic that represent graph links were developed on a
time where there were no needs to dynamic remove links. So,
although links are created/removed one by one via some
functions, they're stored as an array inside the entity struct.

As the array may grow, there's a logic inside the code that
checks if the amount of space is not enough to store
the needed links. If it isn't the core uses krealloc()
to change the size of the link, with is bad, as it
leaves the memory fragmented.

So, convert links into a list.

Also, currently,  both source and sink entities need the link
at the graph traversal logic inside media_entity. So there's
a logic duplicating all links. That makes it to spend
twice the memory needed. This is not a big deal for today's
usage, where the number of links are not big.

Yet, if during the MC workshop discussions, it was said that
IIO graphs could have up to 4,000 entities. So, we may
want to remove the duplication on some future. The problem
is that it would require a separate linked list to store
the backlinks inside the entity, or to use a more complex
algorithm to do graph backlink traversal, with is something
that the current graph traversal inside the core can't cope
with. So, let's postpone a such change if/when it is actually
needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c38ef1a72b4a..2d06bcff0946 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -622,7 +622,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 	struct media_device *mdev = adapter->mdev;
 	struct media_entity  *entity, *source;
 	struct media_link *link, *found_link = NULL;
-	int i, ret, n_links = 0, active_links = 0;
+	int ret, n_links = 0, active_links = 0;
 
 	fepriv->pipe_start_entity = NULL;
 
@@ -632,8 +632,7 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 	entity = fepriv->dvbdev->entity;
 	fepriv->pipe_start_entity = entity;
 
-	for (i = 0; i < entity->num_links; i++) {
-		link = &entity->links[i];
+	list_for_each_entry(link, &entity->links, list) {
 		if (link->sink->entity == entity) {
 			found_link = link;
 			n_links++;
@@ -659,13 +658,11 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 
 	source = found_link->source->entity;
 	fepriv->pipe_start_entity = source;
-	for (i = 0; i < source->num_links; i++) {
+	list_for_each_entry(link, &source->links, list) {
 		struct media_entity *sink;
 		int flags = 0;
 
-		link = &source->links[i];
 		sink = link->sink->entity;
-
 		if (sink == entity)
 			flags = MEDIA_LNK_FL_ENABLED;
 
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 0d85c6c28004..3e649cacfc07 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -25,6 +25,7 @@
 #include <linux/ioctl.h>
 #include <linux/media.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
@@ -150,22 +151,21 @@ static long __media_device_enum_links(struct media_device *mdev,
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
-
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
@@ -437,6 +437,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->graph_obj.mdev != NULL);
 	entity->graph_obj.mdev = mdev;
+	INIT_LIST_HEAD(&entity->links);
 
 	spin_lock(&mdev->lock);
 	/* Initialize media_gobj embedded at the entity */
@@ -465,13 +466,17 @@ void media_device_unregister_entity(struct media_entity *entity)
 {
 	int i;
 	struct media_device *mdev = entity->graph_obj.mdev;
+	struct media_link *link, *tmp;
 
 	if (mdev == NULL)
 		return;
 
 	spin_lock(&mdev->lock);
-	for (i = 0; i < entity->num_links; i++)
-		media_gobj_remove(&entity->links[i].graph_obj);
+	list_for_each_entry_safe(link, tmp, &entity->links, list) {
+		media_gobj_remove(&link->graph_obj);
+		list_del(&link->list);
+		kfree(link);
+	}
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_remove(&entity->pads[i].graph_obj);
 	media_gobj_remove(&entity->graph_obj);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 9f8e0145db7a..ff63201443d7 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -221,21 +221,13 @@ int
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
 
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
@@ -249,7 +241,13 @@ EXPORT_SYMBOL_GPL(media_entity_init);
 void
 media_entity_cleanup(struct media_entity *entity)
 {
-	kfree(entity->links);
+	struct media_link *link, *tmp;
+
+	list_for_each_entry_safe(link, tmp, &entity->links, list) {
+		media_gobj_remove(&link->graph_obj);
+		list_del(&link->list);
+		kfree(link);
+	}
 }
 EXPORT_SYMBOL_GPL(media_entity_cleanup);
 
@@ -275,7 +273,7 @@ static void stack_push(struct media_entity_graph *graph,
 		return;
 	}
 	graph->top++;
-	graph->stack[graph->top].link = 0;
+	graph->stack[graph->top].link = entity->links;
 	graph->stack[graph->top].entity = entity;
 }
 
@@ -317,6 +315,7 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 }
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 
+
 /**
  * media_entity_graph_walk_next - Get the next entity in the graph
  * @graph: Media graph structure
@@ -340,14 +339,16 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
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
 
@@ -358,12 +359,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Has the entity already been visited? */
 		if (__test_and_set_bit(media_entity_id(next), graph->entities)) {
-			link_top(graph)++;
+			list_rotate_left(&link_top(graph));
 			continue;
 		}
 
 		/* Push the new entity to stack and start over. */
-		link_top(graph)++;
+		list_rotate_left(&link_top(graph));
 		stack_push(graph, next);
 	}
 
@@ -395,6 +396,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	struct media_device *mdev = entity->graph_obj.mdev;
 	struct media_entity_graph graph;
 	struct media_entity *entity_err = entity;
+	struct media_link *link;
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
@@ -404,7 +406,6 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	while ((entity = media_entity_graph_walk_next(&graph))) {
 		DECLARE_BITMAP(active, entity->num_pads);
 		DECLARE_BITMAP(has_no_links, entity->num_pads);
-		unsigned int i;
 
 		entity->stream_count++;
 		WARN_ON(entity->pipe && entity->pipe != pipe);
@@ -420,8 +421,7 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		bitmap_zero(active, entity->num_pads);
 		bitmap_fill(has_no_links, entity->num_pads);
 
-		for (i = 0; i < entity->num_links; i++) {
-			struct media_link *link = &entity->links[i];
+		list_for_each_entry(link, &entity->links, list) {
 			struct media_pad *pad = link->sink->entity == entity
 						? link->sink : link->source;
 
@@ -582,25 +582,20 @@ EXPORT_SYMBOL_GPL(media_entity_put);
 
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
+	list_add_tail(&link->list, &entity->links);
 
-		entity->max_links = max_links;
-		entity->links = links;
-	}
-
-	return &entity->links[entity->num_links++];
+	return link;
 }
 
+static void __media_entity_remove_link(struct media_entity *entity,
+				       struct media_link *link);
+
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
 			 struct media_entity *sink, u16 sink_pad, u32 flags)
@@ -629,7 +624,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	 */
 	backlink = media_entity_add_link(sink);
 	if (backlink == NULL) {
-		source->num_links--;
+		__media_entity_remove_link(source, link);
 		return -ENOMEM;
 	}
 
@@ -645,43 +640,51 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	backlink->reverse = link;
 
 	sink->num_backlinks++;
+	sink->num_links++;
+	source->num_links++;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
 
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
@@ -806,11 +809,8 @@ struct media_link *
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
@@ -834,11 +834,9 @@ EXPORT_SYMBOL_GPL(media_entity_find_link);
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
 
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index a55eb524ea21..7f645bcb7463 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -261,13 +261,11 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 
 	if (tuner)
 		media_create_pad_link(tuner, 0, decoder, 0,
-					 MEDIA_LNK_FL_ENABLED);
-	if (dev->vdev.entity.links)
-		media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
-	if (dev->vbi_dev.entity.links)
-		media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
-				 MEDIA_LNK_FL_ENABLED);
+				      MEDIA_LNK_FL_ENABLED);
+	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
+			      MEDIA_LNK_FL_ENABLED);
+	media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
+			      MEDIA_LNK_FL_ENABLED);
 #endif
 }
 
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 2c040056d4eb..4511e2893282 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -643,7 +643,7 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 	struct media_device *mdev = dev->media_dev;
 	struct media_entity *source;
 	struct media_link *link, *found_link = NULL;
-	int i, ret, active_links = 0;
+	int ret, active_links = 0;
 
 	if (!mdev || !dev->decoder)
 		return 0;
@@ -655,8 +655,7 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 	 * do DVB streaming while the DMA engine is being used for V4L2,
 	 * this should be enough for the actual needs.
 	 */
-	for (i = 0; i < dev->decoder->num_links; i++) {
-		link = &dev->decoder->links[i];
+	list_for_each_entry(link, &dev->decoder->links, list) {
 		if (link->sink->entity == dev->decoder) {
 			found_link = link;
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
@@ -669,11 +668,10 @@ static int au0828_enable_analog_tuner(struct au0828_dev *dev)
 		return 0;
 
 	source = found_link->source->entity;
-	for (i = 0; i < source->num_links; i++) {
+	list_for_each_entry(link, &source->links, list) {
 		struct media_entity *sink;
 		int flags = 0;
 
-		link = &source->links[i];
 		sink = link->sink->entity;
 
 		if (sink == dev->decoder)
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
index 7df8836f4eef..bb89cedb0c40 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -74,6 +74,7 @@ struct media_pipeline {
 
 struct media_link {
 	struct media_gobj graph_obj;
+	struct list_head list;
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
 	struct media_link *reverse;	/* Link in the reverse direction */
@@ -116,10 +117,9 @@ struct media_entity {
 	u16 num_links;			/* Number of existing links, both
 					 * enabled and disabled */
 	u16 num_backlinks;		/* Number of backlinks */
-	u16 max_links;			/* Maximum number of links */
 
-	struct media_pad *pads;		/* Pads array (num_pads elements) */
-	struct media_link *links;	/* Links array (max_links elements)*/
+	struct media_pad *pads;		/* Pads array (num_pads objects) */
+	struct list_head links;		/* Links list */
 
 	const struct media_entity_operations *ops;	/* Entity operations */
 
@@ -213,7 +213,7 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-		int link;
+		struct list_head link;
 	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
 
 	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
@@ -247,7 +247,7 @@ void media_gobj_init(struct media_device *mdev,
 void media_gobj_remove(struct media_gobj *gobj);
 
 int media_entity_init(struct media_entity *entity, u16 num_pads,
-		struct media_pad *pads);
+		      struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
 
 int media_create_pad_link(struct media_entity *source, u16 source_pad,
-- 
2.4.3

