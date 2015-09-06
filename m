Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54591 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbbIFMDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 26/55] [media] media: add a linked list to track interfaces by mdev
Date: Sun,  6 Sep 2015 09:02:54 -0300
Message-Id: <319de8defe1d6351b0fe58b426d7e80973318777.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <6a5d75004723fe0a822ef389247ae9656d681ca1.1440902901.git.mchehab@osg.samsung.com>
References: <6a5d75004723fe0a822ef389247ae9656d681ca1.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device should list the interface objects, so add a linked list
for those interfaces in struct media_device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 3e649cacfc07..659507bce63f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -381,6 +381,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&mdev->entities);
+	INIT_LIST_HEAD(&mdev->interfaces);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 74aaa5a5d5bc..d8038a53f945 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -861,6 +861,8 @@ static void media_interface_init(struct media_device *mdev,
 	INIT_LIST_HEAD(&intf->links);
 
 	media_gobj_init(mdev, gobj_type, &intf->graph_obj);
+
+	list_add_tail(&intf->list, &mdev->interfaces);
 }
 
 /* Functions related to the media interface via device nodes */
@@ -889,6 +891,7 @@ EXPORT_SYMBOL_GPL(media_devnode_create);
 void media_devnode_remove(struct media_intf_devnode *devnode)
 {
 	media_gobj_remove(&devnode->intf.graph_obj);
+	list_del(&devnode->intf.list);
 	kfree(devnode);
 }
 EXPORT_SYMBOL_GPL(media_devnode_remove);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 3b14394d5701..51807efa505b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -46,6 +46,7 @@ struct device;
  * @link_id:	Unique ID used on the last link registered
  * @intf_devnode_id: Unique ID used on the last interface devnode registered
  * @entities:	List of registered entities
+ * @interfaces:	List of registered interfaces
  * @lock:	Entities list lock
  * @graph_mutex: Entities graph operation lock
  * @link_notify: Link state change notification callback
@@ -77,6 +78,7 @@ struct media_device {
 	u32 intf_devnode_id;
 
 	struct list_head entities;
+	struct list_head interfaces;
 
 	/* Protects the entities list */
 	spinlock_t lock;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index f67c01419268..4e36b1f2b2d7 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -156,6 +156,8 @@ struct media_entity {
  * struct media_intf_devnode - Define a Kernel API interface
  *
  * @graph_obj:		embedded graph object
+ * @list:		Linked list used to find other interfaces that belong
+ *			to the same media controller
  * @links:		List of links pointing to graph entities
  * @type:		Type of the interface as defined at the
  *			uapi/media/media.h header, e. g.
@@ -164,6 +166,7 @@ struct media_entity {
  */
 struct media_interface {
 	struct media_gobj		graph_obj;
+	struct list_head		list;
 	struct list_head		links;
 	u32				type;
 	u32				flags;
-- 
2.4.3


