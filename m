Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbbHGOUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:23 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 13/16] media: make the internal function to create links more generic
Date: Fri,  7 Aug 2015 11:20:11 -0300
Message-Id: <078d36a3aa5db1b692ae1b8910d0be0313bd03b9.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to add a public function to add links, let's
make the internal function that creates link more generic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 96d48aec8381..c68dc421b022 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -461,7 +461,12 @@ EXPORT_SYMBOL_GPL(media_entity_put);
  * Links management
  */
 
-static struct media_link *media_entity_add_link(struct media_entity *entity)
+static struct media_link *__media_create_link(struct media_device *mdev,
+					      enum media_graph_link_dir dir,
+					      struct media_graph_obj *port0,
+					      struct media_graph_obj *port1,
+					      u32 flags,
+					      struct list_head *list)
 {
 	struct media_link *link;
 
@@ -469,13 +474,17 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 	if (link == NULL)
 		return NULL;
 
+	link->dir = dir;
+	link->source = port0;
+	link->sink = port1;
+	link->flags = flags;
+
 	link->reverse->reverse = link;
 	INIT_LIST_HEAD(&link->list);
-	list_add(&entity->links, &link->list);
+	list_add(list, &link->list);
 
 	/* Initialize graph object embedded at the new link */
-	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
-			&link->graph_obj);
+	graph_obj_init(mdev, MEDIA_GRAPH_LINK, &link->graph_obj);
 
 	return link;
 }
@@ -514,7 +523,7 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
-			 struct media_entity *sink, u16 sink_pad, u32 flags)
+		      struct media_entity *sink, u16 sink_pad, u32 flags)
 {
 	struct media_link *link;
 	struct media_link *backlink;
@@ -523,27 +532,27 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	BUG_ON(source_pad >= source->num_pads);
 	BUG_ON(sink_pad >= sink->num_pads);
 
-	link = media_entity_add_link(source);
+	link = __media_create_link(source->parent,
+				   MEDIA_LINK_DIR_PORT0_TO_PORT1,
+			           &source->pads[source_pad].graph_obj,
+				   &sink->pads[sink_pad].graph_obj,
+				   flags, &source->links);
 	if (link == NULL)
 		return -ENOMEM;
 
-	link->source = &source->pads[source_pad].graph_obj;
-	link->sink = &sink->pads[sink_pad].graph_obj;
-	link->flags = flags;
-
 	/* Create the backlink. Backlinks are used to help graph traversal and
 	 * are not reported to userspace.
 	 */
-	backlink = media_entity_add_link(sink);
+	backlink = __media_create_link(sink->parent,
+				      MEDIA_LINK_DIR_PORT0_TO_PORT1,
+			              &source->pads[source_pad].graph_obj,
+				      &sink->pads[sink_pad].graph_obj,
+				      flags, &sink->links);
 	if (backlink == NULL) {
 		__media_entity_remove_link(source, link);
 		return -ENOMEM;
 	}
 
-	backlink->source = &source->pads[source_pad].graph_obj;
-	backlink->sink = &sink->pads[sink_pad].graph_obj;
-	backlink->flags = flags;
-
 	link->reverse = backlink;
 	backlink->reverse = link;
 
-- 
2.4.3

