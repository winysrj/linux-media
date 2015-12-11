Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbbLKOR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 09:17:28 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] media_entity: rename media_obj functions to *_create *_destroy
Date: Fri, 11 Dec 2015 12:17:13 -0200
Message-Id: <faaf893f35d36170424cfc665546b423e3e6978f.1449843430.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those media_obj_* functions are actually creating/destroying
media graph objects. So, rename them to better represent
what they're actually doing.

No functional changes.

This was created via this small shell script:

	for i in $(git grep -l media_gobj_init); do sed s,media_gobj_init,media_gobj_create,g <$i >a && mv a $i; done
	for i in $(git grep -l media_gobj_remove); do sed s,media_gobj_remove,media_gobj_destroy,g <$i >a && mv a $i; done

Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 10 +++++-----
 drivers/media/media-entity.c | 26 +++++++++++++-------------
 include/media/media-entity.h |  4 ++--
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 537160bb461e..f09f3a6f9c50 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -591,7 +591,7 @@ void media_device_unregister(struct media_device *mdev)
 	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
 				 graph_obj.list) {
 		__media_remove_intf_links(intf);
-		media_gobj_remove(&intf->graph_obj);
+		media_gobj_destroy(&intf->graph_obj);
 		kfree(intf);
 	}
 	spin_unlock(&mdev->lock);
@@ -628,11 +628,11 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 
 	spin_lock(&mdev->lock);
 	/* Initialize media_gobj embedded at the entity */
-	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
+	media_gobj_create(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
 	/* Initialize objects at the pads */
 	for (i = 0; i < entity->num_pads; i++)
-		media_gobj_init(mdev, MEDIA_GRAPH_PAD,
+		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
 	spin_unlock(&mdev->lock);
@@ -673,10 +673,10 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	/* Remove all pads that belong to this entity */
 	for (i = 0; i < entity->num_pads; i++)
-		media_gobj_remove(&entity->pads[i].graph_obj);
+		media_gobj_destroy(&entity->pads[i].graph_obj);
 
 	/* Remove the entity */
-	media_gobj_remove(&entity->graph_obj);
+	media_gobj_destroy(&entity->graph_obj);
 
 	spin_unlock(&mdev->lock);
 	entity->graph_obj.mdev = NULL;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 57de11281af1..861c8e7b8773 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -134,7 +134,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 }
 
 /**
- *  media_gobj_init - Initialize a graph object
+ *  media_gobj_create - Initialize a graph object
  *
  * @mdev:	Pointer to the media_device that contains the object
  * @type:	Type of the object
@@ -146,7 +146,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
  * is embedded on some other object, this function should be called before
  * registering the object at the media controller.
  */
-void media_gobj_init(struct media_device *mdev,
+void media_gobj_create(struct media_device *mdev,
 			   enum media_gobj_type type,
 			   struct media_gobj *gobj)
 {
@@ -180,13 +180,13 @@ void media_gobj_init(struct media_device *mdev,
 }
 
 /**
- *  media_gobj_remove - Stop using a graph object on a media device
+ *  media_gobj_destroy - Stop using a graph object on a media device
  *
  * @graph_obj:	Pointer to the object
  *
  * This should be called at media_device_unregister_*() routines
  */
-void media_gobj_remove(struct media_gobj *gobj)
+void media_gobj_destroy(struct media_gobj *gobj)
 {
 	dev_dbg_obj(__func__, gobj);
 
@@ -235,7 +235,7 @@ media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 		pads[i].entity = entity;
 		pads[i].index = i;
 		if (mdev)
-			media_gobj_init(mdev, MEDIA_GRAPH_PAD,
+			media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 					&entity->pads[i].graph_obj);
 	}
 
@@ -607,14 +607,14 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 		/* Remove the remote link */
 		list_del(&rlink->list);
-		media_gobj_remove(&rlink->graph_obj);
+		media_gobj_destroy(&rlink->graph_obj);
 		kfree(rlink);
 
 		if (--remote->num_links == 0)
 			break;
 	}
 	list_del(&link->list);
-	media_gobj_remove(&link->graph_obj);
+	media_gobj_destroy(&link->graph_obj);
 	kfree(link);
 }
 
@@ -638,7 +638,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
-	media_gobj_init(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
+	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
 			&link->graph_obj);
 
 	/* Create the backlink. Backlinks are used to help graph traversal and
@@ -656,7 +656,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	backlink->is_backlink = true;
 
 	/* Initialize graph object embedded at the new link */
-	media_gobj_init(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
+	media_gobj_create(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
 			&backlink->graph_obj);
 
 	link->reverse = backlink;
@@ -852,7 +852,7 @@ static void media_interface_init(struct media_device *mdev,
 	intf->flags = flags;
 	INIT_LIST_HEAD(&intf->links);
 
-	media_gobj_init(mdev, gobj_type, &intf->graph_obj);
+	media_gobj_create(mdev, gobj_type, &intf->graph_obj);
 }
 
 /* Functions related to the media interface via device nodes */
@@ -880,7 +880,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
 void media_devnode_remove(struct media_intf_devnode *devnode)
 {
 	media_remove_intf_links(&devnode->intf);
-	media_gobj_remove(&devnode->intf.graph_obj);
+	media_gobj_destroy(&devnode->intf.graph_obj);
 	kfree(devnode);
 }
 EXPORT_SYMBOL_GPL(media_devnode_remove);
@@ -900,7 +900,7 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
 	link->flags = flags;
 
 	/* Initialize graph object embedded at the new link */
-	media_gobj_init(intf->graph_obj.mdev, MEDIA_GRAPH_LINK,
+	media_gobj_create(intf->graph_obj.mdev, MEDIA_GRAPH_LINK,
 			&link->graph_obj);
 
 	return link;
@@ -910,7 +910,7 @@ EXPORT_SYMBOL_GPL(media_create_intf_link);
 void __media_remove_intf_link(struct media_link *link)
 {
 	list_del(&link->list);
-	media_gobj_remove(&link->graph_obj);
+	media_gobj_destroy(&link->graph_obj);
 	kfree(link);
 }
 EXPORT_SYMBOL_GPL(__media_remove_intf_link);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 51a7353effd0..1b954fb88def 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -338,10 +338,10 @@ struct media_entity_graph {
 #define intf_to_devnode(intf) \
 		container_of(intf, struct media_intf_devnode, intf)
 
-void media_gobj_init(struct media_device *mdev,
+void media_gobj_create(struct media_device *mdev,
 		    enum media_gobj_type type,
 		    struct media_gobj *gobj);
-void media_gobj_remove(struct media_gobj *gobj);
+void media_gobj_destroy(struct media_gobj *gobj);
 
 /**
  * media_entity_pads_init() - Initialize the entity pads
-- 
2.5.0

