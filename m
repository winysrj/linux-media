Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbHRUE2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:04:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v5 2/8] [media] media: add a common struct to be embed on media graph objects
Date: Tue, 18 Aug 2015 17:04:15 -0300
Message-Id: <9c2b29164f11d96c5c437165fb3f013aec8715fe.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the MC API proposed changes, we'll need to have an unique
object ID for all graph objects, and have some shared fields
that will be common on all media graph objects.

Right now, the only common object is the object ID, but other
fields will be added later on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index cb0ac4e0dfa5..4834172bf6f8 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -27,6 +27,38 @@
 #include <media/media-device.h>
 
 /**
+ *  media_gobj_init - Initialize a graph object
+ *
+ * @mdev:	Pointer to the media_device that contains the object
+ * @type:	Type of the object
+ * @gobj:	Pointer to the object
+ *
+ * This routine initializes the embedded struct media_gobj inside a
+ * media graph object. It is called automatically if media_*_create()
+ * calls are used. However, if the object (entity, link, pad, interface)
+ * is embedded on some other object, this function should be called before
+ * registering the object at the media controller.
+ */
+void media_gobj_init(struct media_device *mdev,
+			   enum media_gobj_type type,
+			   struct media_gobj *gobj)
+{
+	/* For now, nothing to do */
+}
+
+/**
+ *  media_gobj_remove - Stop using a graph object on a media device
+ *
+ * @graph_obj:	Pointer to the object
+ *
+ * This should be called at media_device_unregister_*() routines
+ */
+void media_gobj_remove(struct media_gobj *gobj)
+{
+	/* For now, nothing to do */
+}
+
+/**
  * media_entity_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0a66fc225559..762593c7424f 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -28,6 +28,37 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+/* Enums used internally at the media controller to represent graphs */
+
+/**
+ * enum media_gobj_type - type of a graph element
+ *
+ */
+enum media_gobj_type {
+	 /* FIXME: add the types here, as we embed media_gobj */
+	MEDIA_GRAPH_NONE
+};
+
+#define BITS_PER_TYPE		8
+#define BITS_PER_LOCAL_ID	(32 - BITS_PER_TYPE)
+
+/* Structs to represent the objects that belong to a media graph */
+
+/**
+ * struct media_gobj - Define a graph object.
+ *
+ * @id:		Non-zero object ID identifier. The ID should be unique
+ *		inside a media_device, as it is composed by
+ *		BITS_PER_TYPE to store the type plus BITS_PER_LOCAL_ID
+ *		to store a per-type ID (called as "local ID").
+ *
+ * All elements on the media graph should have this struct embedded
+ */
+struct media_gobj {
+	u32			id;
+};
+
+
 struct media_pipeline {
 };
 
@@ -118,6 +149,26 @@ static inline u32 media_entity_id(struct media_entity *entity)
 	return entity->id;
 }
 
+static inline enum media_gobj_type media_type(struct media_gobj *gobj)
+{
+	return gobj->id >> BITS_PER_LOCAL_ID;
+}
+
+static inline u32 media_localid(struct media_gobj *gobj)
+{
+	return gobj->id & GENMASK(BITS_PER_LOCAL_ID - 1, 0);
+}
+
+static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
+{
+	u32 id;
+
+	id = type << BITS_PER_LOCAL_ID;
+	id |= GENMASK(BITS_PER_LOCAL_ID - 1, 0) & local_id;
+
+	return id;
+}
+
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 #define MEDIA_ENTITY_ENUM_MAX_ID	64
 
@@ -131,6 +182,14 @@ struct media_entity_graph {
 	int top;
 };
 
+#define gobj_to_entity(gobj) \
+		container_of(gobj, struct media_entity, graph_obj)
+
+void media_gobj_init(struct media_device *mdev,
+		    enum media_gobj_type type,
+		    struct media_gobj *gobj);
+void media_gobj_remove(struct media_gobj *gobj);
+
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.3

