Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbIFMD6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:58 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 52/55] [media] media-device: remove interfaces and interface links
Date: Sun,  6 Sep 2015 09:03:12 -0300
Message-Id: <fcb7fe56b016191b35dfc9fbc007ba1a1f35e837.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <e5eba1a99757919c9bda78401b30bcad823200c0.1440902901.git.mchehab@osg.samsung.com>
References: <e5eba1a99757919c9bda78401b30bcad823200c0.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like what's done with entities, when the media controller is
unregistered, release any interface and interface links that
might still be there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7c37aeab05bb..0238885fcc74 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -574,6 +574,22 @@ void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
 	struct media_entity *next;
+	struct media_link *link, *tmp_link;
+	struct media_interface *intf, *tmp_intf;
+
+	/* Remove interface links from the media device */
+	list_for_each_entry_safe(link, tmp_link, &mdev->links,
+				 graph_obj.list) {
+		media_gobj_remove(&link->graph_obj);
+		kfree(link);
+	}
+
+	/* Remove all interfaces from the media device */
+	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
+				 graph_obj.list) {
+		media_gobj_remove(&intf->graph_obj);
+		kfree(intf);
+	}
 
 	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
 		media_device_unregister_entity(entity);
@@ -651,7 +667,6 @@ void media_device_unregister_entity(struct media_entity *entity)
 	/* Remove all data links that belong to this entity */
 	list_for_each_entry_safe(link, tmp, &entity->links, list) {
 		media_gobj_remove(&link->graph_obj);
-		list_del(&link->list);
 		kfree(link);
 	}
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a37ccd2edfd5..cd4d767644df 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -206,6 +206,10 @@ void media_gobj_remove(struct media_gobj *gobj)
 
 	/* Remove the object from mdev list */
 	list_del(&gobj->list);
+
+	/* Links have their own list - we need to drop them there too */
+	if (media_type(gobj) == MEDIA_GRAPH_LINK)
+		list_del(&gobj_to_link(gobj)->list);
 }
 
 /**
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index ca4a4f23362f..fb5f0e21f137 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -153,7 +153,7 @@ struct media_entity {
 };
 
 /**
- * struct media_intf_devnode - Define a Kernel API interface
+ * struct media_interface - Define a Kernel API interface
  *
  * @graph_obj:		embedded graph object
  * @list:		Linked list used to find other interfaces that belong
@@ -163,6 +163,11 @@ struct media_entity {
  *			uapi/media/media.h header, e. g.
  *			MEDIA_INTF_T_*
  * @flags:		Interface flags as defined at uapi/media/media.h
+ *
+ * NOTE: As media_device_unregister() will free the address of the
+ *	 media_interface, this structure should be embedded as the first
+ *	 element of the derived functions, in order for the address to be
+ *	 the same.
  */
 struct media_interface {
 	struct media_gobj		graph_obj;
@@ -179,11 +184,11 @@ struct media_interface {
  * @minor:	Minor number of a device node
  */
 struct media_intf_devnode {
-	struct media_interface		intf;
+	struct media_interface	intf; /* must be first field in struct */
 
 	/* Should match the fields at media_v2_intf_devnode */
-	u32				major;
-	u32				minor;
+	u32			major;
+	u32			minor;
 };
 
 static inline u32 media_entity_id(struct media_entity *entity)
-- 
2.4.3


