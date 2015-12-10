Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbLJKvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:51:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] media-entity: protect object creation/removal using spin lock
Date: Thu, 10 Dec 2015 08:51:38 -0200
Message-Id: <72d33f06a1e18b0448a9eb94cb58557b46cf928d.1449744671.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some parts of the media controller are using mutexes while
others are using spin locks in order to protect creation
and removal of elements in the graph. That's wrong!

Also, the V4L2 core can remove graph elements on non-interactive
context:
	BUG: sleeping function called from invalid context at include/linux/sched.h:2776

Fix it by always using spin locks for graph element addition/removal,
just like entity creation/removal is protected at media-device.c

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---

PS.: I'm adding this patch just after "media-device: remove interfaces and interface links".

It prevents some troubles with DEBUG_KMEMLEAK and KASAN, with makes
them to hang the Kernel during physical device removal (or device driver
removal). Without this, we get this error:

	kasan: GPF could be caused by NULL-ptr deref or user memory accessgeneral protection fault: 0000 [#1] SMP KASAN

 drivers/media/media-entity.c | 16 ++++++++--------
 include/media/media-device.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ee0f81364960..b1390d843909 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -700,9 +700,9 @@ void media_entity_remove_links(struct media_entity *entity)
 	if (entity->graph_obj.mdev == NULL)
 		return;
 
-	mutex_lock(&entity->graph_obj.mdev->graph_mutex);
+	spin_lock(&entity->graph_obj.mdev->lock);
 	__media_entity_remove_links(entity);
-	mutex_unlock(&entity->graph_obj.mdev->graph_mutex);
+	spin_unlock(&entity->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -792,9 +792,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	mutex_lock(&link->source->entity->graph_obj.mdev->graph_mutex);
+	spin_lock(&link->source->entity->graph_obj.mdev->lock);
 	ret = __media_entity_setup_link(link, flags);
-	mutex_unlock(&link->source->entity->graph_obj.mdev->graph_mutex);
+	spin_unlock(&link->source->entity->graph_obj.mdev->lock);
 
 	return ret;
 }
@@ -932,9 +932,9 @@ EXPORT_SYMBOL_GPL(__media_remove_intf_link);
 
 void media_remove_intf_link(struct media_link *link)
 {
-	mutex_lock(&link->graph_obj.mdev->graph_mutex);
+	spin_lock(&link->graph_obj.mdev->lock);
 	__media_remove_intf_link(link);
-	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
+	spin_unlock(&link->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
 
@@ -954,8 +954,8 @@ void media_remove_intf_links(struct media_interface *intf)
 	if (intf->graph_obj.mdev == NULL)
 		return;
 
-	mutex_lock(&intf->graph_obj.mdev->graph_mutex);
+	spin_lock(&intf->graph_obj.mdev->lock);
 	__media_remove_intf_links(intf);
-	mutex_unlock(&intf->graph_obj.mdev->graph_mutex);
+	spin_unlock(&intf->graph_obj.mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_links);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 1b12774a9ab4..87ff299e1265 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -88,7 +88,7 @@ struct media_device {
 	struct list_head pads;
 	struct list_head links;
 
-	/* Protects the entities list */
+	/* Protects the graph objects creation/removal */
 	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
-- 
2.5.0


