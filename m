Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbHLUPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 16:15:09 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v3 13/16] media: make the internal function to create links more generic
Date: Wed, 12 Aug 2015 17:14:57 -0300
Message-Id: <0bfcb1f6134c7c9b7c1a90388db646723e118a82.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439410053.git.mchehab@osg.samsung.com>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation to add a public function to add links, let's
make the internal function that creates link more generic.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index eafd26a741e5..b8991d38c565 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -457,7 +457,12 @@ EXPORT_SYMBOL_GPL(media_entity_put);
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
 
@@ -465,12 +470,16 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 	if (link == NULL)
 		return NULL;
 
+	link->dir = dir;
+	link->port0 = port0;
+	link->port1 = port1;
+	link->flags = flags;
+
 	INIT_LIST_HEAD(&link->list);
-	list_add(&entity->links, &link->list);
+	list_add(list, &link->list);
 
 	/* Initialize graph object embedded at the new link */
-	graph_obj_init(entity->parent, MEDIA_GRAPH_LINK,
-			&link->graph_obj);
+	graph_obj_init(mdev, MEDIA_GRAPH_LINK, &link->graph_obj);
 
 	return link;
 }
@@ -509,7 +518,7 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
-			 struct media_entity *sink, u16 sink_pad, u32 flags)
+		      struct media_entity *sink, u16 sink_pad, u32 flags)
 {
 	struct media_link *link;
 	struct media_link *backlink;
@@ -518,27 +527,27 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
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
 
-	link->pad0_source = &source->pads[source_pad];
-	link->pad1_sink = &sink->pads[sink_pad];
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
 
-	backlink->pad0_source = &source->pads[source_pad];
-	backlink->pad1_sink = &sink->pads[sink_pad];
-	backlink->flags = flags;
-
 	link->reverse = backlink;
 	backlink->reverse = link;
 
-- 
2.4.3

