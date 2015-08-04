Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933087AbbHDLlT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 07:41:19 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH_RFC_v1 3/4] media: add functions to create/remove entities
Date: Tue,  4 Aug 2015 08:41:08 -0300
Message-Id: <ef220169aeb424f4298256726fb504bda3648567.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438687440.git.mchehab@osg.samsung.com>
References: <cover.1438687440.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to be able to safely create/remove entities
dynamically, we need to use krefs in a way that the
entity memory will only be freed when nobody is using
it anymore.

So, instead of just using kmalloc/kfree, we need to map
those into two functions that will use krefs to protect
memory.

Of course, we need to change all drivers to use the new way,
but they should keep work without such change.
So, let's postpone the driver changes to a separate patch,
in order to be easier for review.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c7b1b2..d6ad6c3fe800 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -27,6 +27,105 @@
 #include <media/media-device.h>
 
 /**
+ *  graph_obj_init - Initialize a graph object
+ *
+ * @mdev:	Pointer to the media_device that contains the object
+ * @type:	Type of the object
+ * @gobj:	Pointer to the object
+*/
+static void graph_obj_init(struct media_device *mdev,
+			   enum media_graph_type type,
+			   struct media_graph_obj *gobj)
+{
+	INIT_LIST_HEAD(&gobj->list);
+
+	list_add_tail(&gobj->list, &mdev->object_list);
+	gobj->obj_id = atomic_inc_return(&mdev->last_obj_id);
+	gobj->type = type;
+	gobj->mdev = mdev;
+	kref_init(&gobj->kref);
+}
+
+/**
+ *  graph_obj_remove - De-initialize a graph object
+ *
+ * @graph_obj:	Pointer to the object
+*/
+static void graph_obj_remove(struct media_graph_obj *gobj)
+{
+	list_del(&gobj->list);
+}
+
+/**
+ *  media_entity_create - Allocates memory and create a media entity
+ *
+ * @mdev:	Pointer to the media_device that contains the object
+ * @name:	Name of the media entity
+ * @flags:	Flags to be used at the media_entity
+ * @ops:	Media entity operations pointer
+ * @gfp_flags:	Flags to be used by kzalloc. Typically: GFP_KERNEL
+*/
+struct media_entity
+*media_entity_create(struct media_device *mdev,
+		     const char *name,
+		     unsigned long flags,
+		     const struct media_entity_operations *ops,
+		     gfp_t gfp_flags)
+{
+	struct media_entity *entity;
+
+	entity = kzalloc(sizeof(*entity), gfp_flags);
+	if (!entity)
+		return NULL;
+
+	/*
+	 * Let's create a copy of the string here, as we should keep a
+	 * reference for the entity until kref count is zero. So, we can't
+	 * rely that the caller will not be freed earlier.
+	 */
+	entity->name = kstrdup(name, gfp_flags);
+	if (!entity)
+		return NULL;
+
+	entity->flags = flags;
+	entity->ops = ops;
+
+	graph_obj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
+
+	return entity;
+}
+
+/**
+ *  media_entity_free - Frees media_entity memory
+ *
+ * @kref:	Kernel reference pointer
+ *
+ * This routine should never be called directly
+ */
+static void media_entity_free(struct kref *ref)
+{
+	struct media_graph_obj *gobj = kref_to_gobj(ref);
+	struct media_entity *entity = gobj_to_entity(gobj);
+
+	graph_obj_remove(gobj);
+	kfree(entity->name);
+	kfree(entity);
+}
+
+/**
+ *  media_entity_remove - Removes a media_entity reference
+ *
+ * @entity:	Pointer to the media entity that will not be used anymore
+ *
+ * This routine decreases the reference for a media entity. When the
+ * reference count is zero, the memory will be freed.
+ */
+void media_entity_remove(struct media_entity *entity)
+{
+	kref_put(&entity->graph_obj.kref, media_entity_free);
+}
+
+/**
  * media_entity_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index faead169fe32..5f073a8351c1 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -171,6 +171,19 @@ struct media_entity_graph {
 	int top;
 };
 
+#define kref_to_gobj(r) container_of(r, struct media_graph_obj, kref)
+
+#define gobj_to_entity(gobj) \
+		container_of(gobj, struct media_entity, graph_obj)
+
+struct media_entity
+*media_entity_create(struct media_device *mdev,
+		     const char *name,
+		     unsigned long flags,
+		     const struct media_entity_operations *ops,
+		     gfp_t gfp_flags);
+void media_entity_remove(struct media_entity *entity);
+
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.3

