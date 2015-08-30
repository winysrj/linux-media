Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48500 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbbH3DHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 23/55] [media] media: add support to link interfaces and entities
Date: Sun, 30 Aug 2015 00:06:34 -0300
Message-Id: <cf99e5eca15f107a14b02dad55fb812525345627.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have a new graph object called "interfaces", we
need to be able to link them to the entities.

Add a linked list to the interfaces to allow them to be
linked to the entities.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 973d1be427c5..08239128fbc4 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -869,6 +869,7 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
 
 	intf->type = type;
 	intf->flags = flags;
+	INIT_LIST_HEAD(&intf->links);
 
 	devnode->major = major;
 	devnode->minor = minor;
@@ -886,3 +887,40 @@ void media_devnode_remove(struct media_intf_devnode *devnode)
 	kfree(devnode);
 }
 EXPORT_SYMBOL_GPL(media_devnode_remove);
+
+struct media_link *media_create_intf_link(struct media_entity *entity,
+					    struct media_interface *intf,
+					    u32 flags)
+{
+	struct media_link *link;
+
+	link = media_add_link(&intf->links);
+	if (link == NULL)
+		return NULL;
+
+	link->intf = intf;
+	link->entity = entity;
+	link->flags = flags;
+
+	/* Initialize graph object embedded at the new link */
+	media_gobj_init(intf->graph_obj.mdev, MEDIA_GRAPH_LINK,
+			&link->graph_obj);
+
+	return link;
+}
+EXPORT_SYMBOL_GPL(media_create_intf_link);
+
+
+static void __media_remove_intf_link(struct media_link *link)
+{
+	media_gobj_remove(&link->graph_obj);
+	kfree(link);
+}
+
+void media_remove_intf_link(struct media_link *link)
+{
+	mutex_lock(&link->graph_obj.mdev->graph_mutex);
+	__media_remove_intf_link(link);
+	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_remove_intf_link);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b4923a24efd5..423ff804e686 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -78,10 +78,12 @@ struct media_link {
 	union {
 		struct media_gobj *gobj0;
 		struct media_pad *source;
+		struct media_interface *intf;
 	};
 	union {
 		struct media_gobj *gobj1;
 		struct media_pad *sink;
+		struct media_entity *entity;
 	};
 	struct media_link *reverse;	/* Link in the reverse direction */
 	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
@@ -154,6 +156,7 @@ struct media_entity {
  * struct media_intf_devnode - Define a Kernel API interface
  *
  * @graph_obj:		embedded graph object
+ * @links:		List of links pointing to graph entities
  * @type:		Type of the interface as defined at the
  *			uapi/media/media.h header, e. g.
  *			MEDIA_INTF_T_*
@@ -161,6 +164,7 @@ struct media_entity {
  */
 struct media_interface {
 	struct media_gobj		graph_obj;
+	struct list_head		links;
 	u32				type;
 	u32				flags;
 };
@@ -283,6 +287,11 @@ struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
 						u32 major, u32 minor,
 						gfp_t gfp_flags);
 void media_devnode_remove(struct media_intf_devnode *devnode);
+struct media_link *media_create_intf_link(struct media_entity *entity,
+					    struct media_interface *intf,
+					    u32 flags);
+void media_remove_intf_link(struct media_link *link);
+
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
 	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
-- 
2.4.3

