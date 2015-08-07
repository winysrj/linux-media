Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbbHGOUX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:23 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 16/16] media: add functions to allow creating interfaces
Date: Fri,  7 Aug 2015 11:20:14 -0300
Message-Id: <d34a30c10ed3c6a0e2e850e2cd0ce123f4546e35.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interfaces are different than entities: they represent a
Kernel<->userspace interaction, while entities represent a
piece of hardware/firmware/software that executes a function.

Let's distinguish them by creating a separate structure to
store the interfaces.

Latter patches should change the existing drivers and logic
to split the current interface embedded inside the entity
structure (device nodes) into a separate object of the graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5c0d197fa072..bc806958815e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -741,3 +741,59 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
 
 }
 EXPORT_SYMBOL_GPL(media_entity_remote_pad);
+
+
+/* Functions related to the media interface via device nodes */
+
+struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
+						u32 major, u32 minor,
+						gfp_t gfp_flags)
+{
+	struct media_intf_devnode *devnode;
+
+	devnode = kzalloc(sizeof(*devnode), gfp_flags);
+	if (!devnode)
+		return NULL;
+
+	devnode->major = major;
+	devnode->minor = minor;
+	INIT_LIST_HEAD(&devnode->intf.entity_links);
+
+	graph_obj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
+		       &devnode->intf.graph_obj);
+
+	return devnode;
+}
+EXPORT_SYMBOL_GPL(media_devnode_create);
+
+void media_devnode_remove(struct media_intf_devnode *devnode)
+{
+	graph_obj_remove(&devnode->intf.graph_obj);
+	kfree(devnode);
+}
+EXPORT_SYMBOL_GPL(media_devnode_remove);
+
+struct media_link *media_create_intf_link(struct media_entity *entity,
+					  struct media_graph_obj *gobj,
+					  u32 flags)
+{
+	struct media_link *link;
+
+	/* Only accept links between entity<==>interface */
+	if (gobj->type != MEDIA_GRAPH_INTF_DEVNODE)
+		return NULL;
+
+	link = __media_create_link(entity->parent,
+				   MEDIA_LINK_DIR_BIDIRECTIONAL,
+			           &entity->graph_obj,
+				   gobj,
+				   flags, &entity->intf_links);
+	if (link == NULL)
+		return NULL;
+
+	/* Create the link at the interface */
+	list_add(&gobj_to_interface(gobj)->entity_links, &link->list);
+
+	return link;
+}
+EXPORT_SYMBOL_GPL(media_create_intf_link);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 5f080ab88399..1faeb74f8489 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -36,11 +36,14 @@
  * @MEDIA_GRAPH_ENTITY:		Identify a media entity
  * @MEDIA_GRAPH_PAD:		Identify a media PAD
  * @MEDIA_GRAPH_LINK:		Identify a media link
+ * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
+ * 				a device node
  */
 enum media_graph_type {
 	MEDIA_GRAPH_ENTITY,
 	MEDIA_GRAPH_PAD,
 	MEDIA_GRAPH_LINK,
+	MEDIA_GRAPH_INTF_DEVNODE,
 };
 
 /**
@@ -136,7 +139,9 @@ struct media_entity {
 	u16 num_backlinks;		/* Number of backlinks */
 
 	struct media_pad *pads;		/* Pads array (num_pads elements) */
-	struct list_head links;		/* Links list */
+	struct list_head links;		/* PAD links list */
+
+	struct list_head intf_links;	/* Interface links list */
 
 	const struct media_entity_operations *ops;	/* Entity operations */
 
@@ -161,6 +166,30 @@ struct media_entity {
 	} info;
 };
 
+/**
+ * struct media_intf_devnode - Define a Kernel API interface
+ *
+ * @graph_obj:		embedded graph object
+ * @ent_links:		List of links pointing to graph entities
+ */
+struct media_interface {
+	struct media_graph_obj		graph_obj;
+	struct list_head		entity_links;
+};
+
+/**
+ * struct media_intf_devnode - Define a Kernel API interface via a device node
+ *
+ * @intf:	embedded interface object
+ * @major:	Major number of a device node
+ * @minor:	Minor number of a device node
+ */
+struct media_intf_devnode {
+	struct media_interface		intf;
+	u32				major;
+	u32				minor;
+};
+
 static inline u32 media_entity_type(struct media_entity *entity)
 {
 	return entity->type & MEDIA_ENT_TYPE_MASK;
@@ -193,6 +222,9 @@ struct media_entity_graph {
 #define gobj_to_pad(gobj) \
 		container_of(gobj, struct media_pad, graph_obj)
 
+#define gobj_to_interface(gobj) \
+		container_of(gobj, struct media_interface, graph_obj)
+
 void graph_obj_init(struct media_device *mdev,
 		    enum media_graph_type type,
 		    struct media_graph_obj *gobj);
@@ -224,6 +256,14 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 					     struct media_pipeline *pipe);
 void media_entity_pipeline_stop(struct media_entity *entity);
 
+struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
+						u32 major, u32 minor,
+						gfp_t gfp_flags);
+void media_devnode_remove(struct media_intf_devnode *devnode);
+struct media_link *media_create_intf_link(struct media_entity *entity,
+					   struct media_graph_obj *gobj,
+					   u32 flags);
+
 #define media_entity_call(entity, operation, args...)			\
 	(((entity)->ops && (entity)->ops->operation) ?			\
 	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
-- 
2.4.3

