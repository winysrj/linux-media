Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 07/44] [media] media: use media_gobj inside links
Date: Sun, 23 Aug 2015 17:17:24 -0300
Message-Id: <8fb52e8c4f3585ef7781d0d3a900ef761ef434dd.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like entities and pads, links also need to have unique
Object IDs along a given media controller.

So, let's add a media_gobj inside it and initialize
the object then a new link is created.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 3bdda16584fe..065f6f08da37 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -438,6 +438,13 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 	list_add_tail(&entity->list, &mdev->entities);
 
+	/*
+	 * Initialize objects at the links
+	 * in the case where links got created before entity register
+	 */
+	for (i = 0; i < entity->num_links; i++)
+		media_gobj_init(mdev, MEDIA_GRAPH_LINK,
+				&entity->links[i].graph_obj);
 	/* Initialize objects at the pads */
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
@@ -465,6 +472,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 		return;
 
 	spin_lock(&mdev->lock);
+	for (i = 0; i < entity->num_links; i++)
+		media_gobj_remove(&entity->links[i].graph_obj);
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_remove(&entity->pads[i].graph_obj);
 	media_gobj_remove(&entity->graph_obj);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 377c6655c5d0..36d725ec5f3d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -51,6 +51,9 @@ void media_gobj_init(struct media_device *mdev,
 	case MEDIA_GRAPH_PAD:
 		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
 		break;
+	case MEDIA_GRAPH_LINK:
+		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
+		break;
 	}
 }
 
@@ -491,6 +494,9 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	link->sink = &sink->pads[sink_pad];
 	link->flags = flags;
 
+	/* Initialize graph object embedded at the new link */
+	media_gobj_init(source->parent, MEDIA_GRAPH_LINK, &link->graph_obj);
+
 	/* Create the backlink. Backlinks are used to help graph traversal and
 	 * are not reported to userspace.
 	 */
@@ -504,6 +510,9 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 	backlink->sink = &sink->pads[sink_pad];
 	backlink->flags = flags;
 
+	/* Initialize graph object embedded at the new link */
+	media_gobj_init(sink->parent, MEDIA_GRAPH_LINK, &backlink->graph_obj);
+
 	link->reverse = backlink;
 	backlink->reverse = link;
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 9493721f630e..05414e351f8e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -43,6 +43,7 @@ struct device;
  * @driver_version: Device driver version
  * @entity_id:	Unique ID used on the last entity registered
  * @pad_id:	Unique ID used on the last pad registered
+ * @link_id:	Unique ID used on the last link registered
  * @entities:	List of registered entities
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
@@ -71,6 +72,7 @@ struct media_device {
 
 	u32 entity_id;
 	u32 pad_id;
+	u32 link_id;
 
 	struct list_head entities;
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index ce4c654486d6..cd08a96bfbaa 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -35,10 +35,12 @@
  *
  * @MEDIA_GRAPH_ENTITY:		Identify a media entity
  * @MEDIA_GRAPH_PAD:		Identify a media pad
+ * @MEDIA_GRAPH_LINK:		Identify a media link
  */
 enum media_gobj_type {
 	MEDIA_GRAPH_ENTITY,
 	MEDIA_GRAPH_PAD,
+	MEDIA_GRAPH_LINK,
 };
 
 #define MEDIA_BITS_PER_TYPE		8
@@ -67,6 +69,7 @@ struct media_pipeline {
 };
 
 struct media_link {
+	struct media_gobj graph_obj;
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
 	struct media_link *reverse;	/* Link in the reverse direction */
-- 
2.4.3

