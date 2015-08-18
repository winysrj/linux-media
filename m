Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54408 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbHRUE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:04:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v5 5/8] [media] media: use media_gobj inside links
Date: Tue, 18 Aug 2015 17:04:18 -0300
Message-Id: <86e21f1449e1c83b62e0b9c795d86bdae3e8de28.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like entities and pads, links also need to have unique
Object IDs along a given media controller.

So, let's add a media_gobj inside it and initialize
the object then a new link is created.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 24551d4ddfb8..7f512223249b 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -436,6 +436,13 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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
@@ -463,6 +470,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 		return;
 
 	spin_lock(&mdev->lock);
+	for (i = 0; i < entity->num_links; i++)
+		media_gobj_remove(&entity->links[i].graph_obj);
 	for (i = 0; i < entity->num_pads; i++)
 		media_gobj_remove(&entity->pads[i].graph_obj);
 	media_gobj_remove(&entity->graph_obj);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 377c6655c5d0..a6be50e04736 100644
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
 
@@ -469,6 +472,13 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 		entity->links = links;
 	}
 
+	/* Initialize graph object embedded at the new link */
+	if (entity->parent)
+		media_gobj_init(entity->parent, MEDIA_GRAPH_LINK,
+				&entity->links[entity->num_links].graph_obj);
+	else
+		pr_warn("Link created before entity register!\n");
+
 	return &entity->links[entity->num_links++];
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 4b5d1ee2b67e..e0f63c0da2dd 100644
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
index 01ae1e320e36..2ffe015629fa 100644
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
 
 #define BITS_PER_TYPE		8
@@ -65,6 +67,7 @@ struct media_pipeline {
 };
 
 struct media_link {
+	struct media_gobj graph_obj;
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
 	struct media_link *reverse;	/* Link in the reverse direction */
-- 
2.4.3

