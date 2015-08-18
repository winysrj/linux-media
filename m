Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbbHRUE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:04:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v5 7/8] [media] media: add a debug message to warn about gobj creation/removal
Date: Tue, 18 Aug 2015 17:04:20 -0300
Message-Id: <b45fb12d0c6c2d45a55522ab7cbcdcd746155528.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It helps to check if the media controller is doing the
right thing with the object creation and removal.

No extra code/data will be produced if DEBUG or
CONFIG_DYNAMIC_DEBUG is not enabled.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a6be50e04736..9e5ebc83ff76 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -27,6 +27,67 @@
 #include <media/media-device.h>
 
 /**
+ *  dev_dbg_obj - Prints in debug mode a change on some object
+ *
+ * @event_name:	Name of the event to report. Could be __func__
+ * @gobj:	Pointer to the object
+ *
+ * Enabled only if DEBUG or CONFIG_DYNAMIC_DEBUG. Otherwise, it
+ * won't produce any code.
+ */
+static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
+{
+#if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
+	static const char *gobj_type[] = {
+		[MEDIA_GRAPH_ENTITY] = "entity",
+		[MEDIA_GRAPH_PAD] = "pad",
+		[MEDIA_GRAPH_LINK] = "link",
+	};
+
+	switch (media_type(gobj)) {
+	case MEDIA_GRAPH_ENTITY:
+		dev_dbg(gobj->mdev->dev,
+			"%s: id 0x%08x %s#%d '%s'\n",
+			event_name, gobj->id,
+			gobj_type[media_type(gobj)],
+			media_localid(gobj),
+			gobj_to_entity(gobj)->name);
+		break;
+	case MEDIA_GRAPH_LINK:
+	{
+		struct media_link *link = gobj_to_link(gobj);
+
+		dev_dbg(gobj->mdev->dev,
+			"%s: id 0x%08x %s#%d: '%s' %s#%d ==> '%s' %s#%d\n",
+			event_name, gobj->id,
+			gobj_type[media_type(gobj)],
+			media_localid(gobj),
+
+			link->source->entity->name,
+			gobj_type[media_type(&link->source->graph_obj)],
+			media_localid(&link->source->graph_obj),
+
+			link->sink->entity->name,
+			gobj_type[media_type(&link->sink->graph_obj)],
+			media_localid(&link->sink->graph_obj));
+		break;
+	}
+	case MEDIA_GRAPH_PAD:
+	{
+		struct media_pad *pad = gobj_to_pad(gobj);
+
+		dev_dbg(gobj->mdev->dev,
+			"%s: id 0x%08x %s %s#%d\n",
+			event_name, gobj->id,
+			pad->entity->name,
+			gobj_type[media_type(gobj)],
+			media_localid(gobj));
+	}
+	}
+#endif
+}
+
+/**
  *  media_gobj_init - Initialize a graph object
  *
  * @mdev:	Pointer to the media_device that contains the object
@@ -43,6 +104,8 @@ void media_gobj_init(struct media_device *mdev,
 			   enum media_gobj_type type,
 			   struct media_gobj *gobj)
 {
+	gobj->mdev = mdev;
+
 	/* Create a per-type unique object ID */
 	switch (type) {
 	case MEDIA_GRAPH_ENTITY:
@@ -55,6 +118,7 @@ void media_gobj_init(struct media_device *mdev,
 		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
 		break;
 	}
+	dev_dbg_obj(__func__, gobj);
 }
 
 /**
@@ -66,7 +130,7 @@ void media_gobj_init(struct media_device *mdev,
  */
 void media_gobj_remove(struct media_gobj *gobj)
 {
-	/* For now, nothing to do */
+	dev_dbg_obj(__func__, gobj);
 }
 
 /**
@@ -472,13 +536,6 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 		entity->links = links;
 	}
 
-	/* Initialize graph object embedded at the new link */
-	if (entity->parent)
-		media_gobj_init(entity->parent, MEDIA_GRAPH_LINK,
-				&entity->links[entity->num_links].graph_obj);
-	else
-		pr_warn("Link created before entity register!\n");
-
 	return &entity->links[entity->num_links++];
 }
 
@@ -501,6 +558,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	link->sink = &sink->pads[sink_pad];
 	link->flags = flags;
 
+	media_gobj_init(source->parent, MEDIA_GRAPH_LINK, &link->graph_obj);
+
 	/* Create the backlink. Backlinks are used to help graph traversal and
 	 * are not reported to userspace.
 	 */
@@ -514,6 +573,8 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	backlink->sink = &sink->pads[sink_pad];
 	backlink->flags = flags;
 
+	media_gobj_init(sink->parent, MEDIA_GRAPH_LINK, &backlink->graph_obj);
+
 	link->reverse = backlink;
 	backlink->reverse = link;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2ffe015629fa..db1f54f09723 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -59,6 +59,7 @@ enum media_gobj_type {
  * All elements on the media graph should have this struct embedded
  */
 struct media_gobj {
+	struct media_device	*mdev;
 	u32			id;
 };
 
@@ -190,6 +191,12 @@ struct media_entity_graph {
 #define gobj_to_entity(gobj) \
 		container_of(gobj, struct media_entity, graph_obj)
 
+#define gobj_to_pad(gobj) \
+		container_of(gobj, struct media_pad, graph_obj)
+
+#define gobj_to_link(gobj) \
+		container_of(gobj, struct media_link, graph_obj)
+
 void media_gobj_init(struct media_device *mdev,
 		    enum media_gobj_type type,
 		    struct media_gobj *gobj);
-- 
2.4.3

