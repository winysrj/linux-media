Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Akihiro Tsukada <tskd08@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tina Ruchandani <ruchandani.tina@gmail.com>
Subject: [PATCH RFC v3 09/16] media: use media_graph_obj for link endpoints
Date: Wed, 12 Aug 2015 17:14:53 -0300
Message-Id: <b118a6801c9c35ffe1e253b5ad1c89f5939feaab.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we'll need to create links between entities and interfaces,
we need to identify the link endpoints by the media_graph_obj.

Please note that, while we're now using graph_obj to reference
the link endpoints, we're still assuming that all endpoints are
pads at the existing drivers. This is true for all existing links,
so no problems are expected so far.

Yet, as we introduce links between entities and interfaces,
we may need to change some existing code to work with links
that aren't pad to pad.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 842b9c8f80c6..3c97ebdf9f2a 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -635,6 +635,8 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 
 	for (i = 0; i < entity->num_links; i++) {
 		link = &entity->links[i];
+		if (link->port1.type != MEDIA_GRAPH_PAD)
+			continue;
 		if (link->sink->entity == entity) {
 			found_link = link;
 			n_links++;
@@ -665,6 +667,8 @@ static int dvb_enable_media_tuner(struct dvb_frontend *fe)
 		int flags = 0;
 
 		link = &source->links[i];
+		if (link->port1.type != MEDIA_GRAPH_PAD)
+			continue;
 		sink = link->sink->entity;
 
 		if (sink == entity)
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a95ca981aabb..b4bd718ad736 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -155,6 +155,10 @@ static long __media_device_enum_links(struct media_device *mdev,
 		list_for_each_entry(ent_link, &entity->links, list) {
 			struct media_link_desc link;
 
+			/* Only PAD to PAD links should be enumerated with legacy API */
+			if (ent_link->port0->type != MEDIA_GRAPH_PAD ||
+			    ent_link->port1->type != MEDIA_GRAPH_PAD)
+				continue;
 			/* Ignore backlinks. */
 			if (ent_link->source->entity != entity)
 				continue;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 333c49aa0974..fc2e4886c830 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -121,6 +121,10 @@ EXPORT_SYMBOL_GPL(media_entity_cleanup);
 static struct media_entity *
 media_entity_other(struct media_entity *entity, struct media_link *link)
 {
+	/* For now, we only do graph traversal with PADs */
+	if (link->port0->type != MEDIA_GRAPH_PAD ||
+	    link->port1->type != MEDIA_GRAPH_PAD)
+		return NULL;
 	if (link->source->entity == entity)
 		return link->sink->entity;
 	else
@@ -217,6 +221,10 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
+		if (!next) {
+			list_rotate_left(&link_top(graph));
+			continue;
+		}
 		if (WARN_ON(next->id >= MEDIA_ENTITY_ENUM_MAX_ID))
 			return NULL;
 
@@ -285,8 +293,14 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 		bitmap_fill(has_no_links, entity->num_pads);
 
 		list_for_each_entry(link, &entity->links, list) {
-			struct media_pad *pad = link->sink->entity == entity
-						? link->sink : link->source;
+			struct media_pad *pad;
+
+			/* For now, ignore interface<->entity links */
+			if (link->port0->type != MEDIA_GRAPH_PAD)
+				continue;
+
+			pad = link->sink->entity == entity
+				? link->sink : link->source;
 
 			/* Mark that a pad is connected by a link. */
 			bitmap_clear(has_no_links, pad->index, 1);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 403019035424..a6464499902e 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -43,6 +43,17 @@ enum media_graph_type {
 	MEDIA_GRAPH_LINK,
 };
 
+/**
+ * enum media_graph_link_dir - direction of a link
+ *
+ * @MEDIA_LINK_DIR_BIDIRECTIONAL	Link is bidirectional
+ * @MEDIA_LINK_DIR_PORT0_TO_PORT1	Link is unidirectional,
+ *					from port 0 to port 1
+ */
+enum media_graph_link_dir {
+	MEDIA_LINK_DIR_BIDIRECTIONAL,
+	MEDIA_LINK_DIR_PORT0_TO_PORT1,
+};
 
 /* Structs to represent the objects that belong to a media graph */
 
@@ -71,16 +82,25 @@ struct media_pipeline {
 };
 
 struct media_link {
+	struct media_graph_obj		graph_obj;	/* should be the first element */
 	struct list_head list;
-	struct media_graph_obj			graph_obj;
-	struct media_pad *source;	/* Source pad */
-	struct media_pad *sink;		/* Sink pad  */
+	enum media_graph_link_dir	dir;
+	union {
+		struct media_graph_obj *port0;
+		struct media_pad *source;
+		struct media_interface *port0_intf;
+	};
+	union {
+		struct media_graph_obj *port1;
+		struct media_pad *sink;
+		struct media_entity *port1_entity;
+	};
 	struct media_link *reverse;	/* Link in the reverse direction */
 	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
 };
 
 struct media_pad {
-	struct media_graph_obj			graph_obj;
+	struct media_graph_obj graph_obj; /* should be the first element */
 	struct media_entity *entity;	/* Entity this pad belongs to */
 	u16 index;			/* Pad index in the entity pads array */
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
@@ -103,7 +123,7 @@ struct media_entity_operations {
 };
 
 struct media_entity {
-	struct media_graph_obj			graph_obj;
+	struct media_graph_obj	graph_obj; /* should be the first element */
 	struct list_head list;
 	struct media_device *parent;	/* Media device this entity belongs to*/
 	u32 id;				/* Entity ID, unique in the parent media
@@ -115,6 +135,11 @@ struct media_entity {
 	u32 group_id;			/* Entity group ID */
 
 	u16 num_pads;			/* Number of sink and source pads */
+
+	/*
+	 * Both num_links and num_backlinks are used only to report
+	 * the number of links via MEDIA_IOC_ENUM_ENTITIES at media_device.c
+	 */
 	u16 num_links;			/* Number of existing links, both
 					 * enabled and disabled */
 	u16 num_backlinks;		/* Number of backlinks */
@@ -171,6 +196,12 @@ struct media_entity_graph {
 #define gobj_to_entity(gobj) \
 		container_of(gobj, struct media_entity, graph_obj)
 
+#define gobj_to_link(gobj) \
+		container_of(gobj, struct media_link, graph_obj)
+
+#define gobj_to_pad(gobj) \
+		container_of(gobj, struct media_pad, graph_obj)
+
 void graph_obj_init(struct media_device *mdev,
 		    enum media_graph_type type,
 		    struct media_graph_obj *gobj);
-- 
2.4.3

