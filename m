Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58991 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbbHWUSL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 42/44] [media] media-device: add pads and links to media_device
Date: Sun, 23 Aug 2015 17:17:59 -0300
Message-Id: <cbdfe091da93c230af21f4064985fe790fc6df34.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MC next gen API sends objects to userspace grouped by
their types.

In the case of pads and links, in order to improve performance
and have a simpler code, the best is to store them also on
separate linked lists at MC.

If we don't do that, we would need this kind of interaction
to send data to userspace (code is in structured english):

	for each entity:
		for each pad:
			store pads

	for each entity:
		for each link:
			store link

	for each interface:
		for each link:
			store link

With would require one nexted loop for pads and two nested
loops for links. By using  separate linked lists for them,
just one loop would be enough.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 01cd014963d6..2de65a621b93 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -382,6 +382,8 @@ int __must_check __media_device_register(struct media_device *mdev,
 
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->interfaces);
+	INIT_LIST_HEAD(&mdev->pads);
+	INIT_LIST_HEAD(&mdev->links);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
@@ -474,7 +476,6 @@ void media_device_unregister_entity(struct media_entity *entity)
 	spin_lock(&mdev->lock);
 	list_for_each_entry_safe(link, tmp, &entity->links, graph_obj.list) {
 		media_gobj_remove(&link->graph_obj);
-		list_del(&link->list);
 		kfree(link);
 	}
 	for (i = 0; i < entity->num_pads; i++)
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 17f2f7555d42..ef26c01a5a9a 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -172,9 +172,11 @@ void media_gobj_init(struct media_device *mdev,
 		break;
 	case MEDIA_GRAPH_PAD:
 		gobj->id = media_gobj_gen_id(type, ++mdev->pad_id);
+		list_add_tail(&gobj->list, &mdev->pads);
 		break;
 	case MEDIA_GRAPH_LINK:
 		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
+		list_add_tail(&gobj->list, &mdev->links);
 		break;
 	case MEDIA_GRAPH_INTF_DEVNODE:
 		list_add_tail(&gobj->list, &mdev->interfaces);
@@ -194,13 +196,7 @@ void media_gobj_init(struct media_device *mdev,
 void media_gobj_remove(struct media_gobj *gobj)
 {
 	/* Remove the object from mdev list */
-	switch (media_type(gobj)) {
-	case MEDIA_GRAPH_ENTITY:
-	case MEDIA_GRAPH_INTF_DEVNODE:
-		list_del(&gobj->list);
-	default:
-		break;
-	}
+	list_del(&gobj->list);
 
 	dev_dbg_obj(__func__, gobj);
 }
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 85fa302047bd..0d1b9c687454 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -47,6 +47,8 @@ struct device;
  * @intf_devnode_id: Unique ID used on the last interface devnode registered
  * @entities:	List of registered entities
  * @interfaces:	List of registered interfaces
+ * @pads:	List of registered pads
+ * @links:	List of registered links
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
  * @link_notify: Link state change notification callback
@@ -79,6 +81,8 @@ struct media_device {
 
 	struct list_head entities;
 	struct list_head interfaces;
+	struct list_head pads;
+	struct list_head links;
 
 	/* Protects the entities list */
 	spinlock_t lock;
@@ -117,6 +121,14 @@ struct media_device *media_device_find_devres(struct device *dev);
 #define media_device_for_each_intf(intf, mdev)			\
 	list_for_each_entry(intf, &(mdev)->interfaces, graph_obj.list)
 
+/* Iterate over all pads. */
+#define media_device_for_each_pad(pad, mdev)			\
+	list_for_each_entry(pad, &(mdev)->pads, graph_obj.list)
+
+/* Iterate over all links. */
+#define media_device_for_each_link(link, mdev)			\
+	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
+
 
 #else
 static inline int media_device_register(struct media_device *mdev)
-- 
2.4.3

