Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46926 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbbHNO6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 10:58:31 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 3/6] media: add a common struct to be embed on media graph objects
Date: Fri, 14 Aug 2015 11:56:40 -0300
Message-Id: <02ddd65348f36f5499acd338e692397baf92b045.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1439563682.git.mchehab@osg.samsung.com>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the MC API proposed changes, we'll need to have an unique
object ID for all graph objects, and have some shared fields
that will be common on all media graph objects.

Right now, the only common object is the object ID, but other
fields will be added latter on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index b8102bda664d..046f1fe40b50 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -27,6 +27,39 @@
 #include <media/media-device.h>
 
 /**
+ *  graph_obj_init - Initialize a graph object
+ *
+ * @mdev:	Pointer to the media_device that contains the object
+ * @type:	Type of the object
+ * @gobj:	Pointer to the object
+ *
+ * This routine initializes the embedded struct media_graph_obj inside a
+ * media graph object. It is called automatically if media_*_create()
+ * calls are used. However, if the object (entity, link, pad, interface)
+ * is embedded on some other object, this function should be called before
+ * registering the object at the media controller.
+ */
+void graph_obj_init(struct media_device *mdev,
+			   enum media_graph_type type,
+			   struct media_graph_obj *gobj)
+{
+	/* An unique object ID will be provided on next patches */
+	gobj->id = type << 24;
+}
+
+/**
+ *  graph_obj_remove - Stop using a graph object on a media device
+ *
+ * @graph_obj:	Pointer to the object
+ *
+ * This should be called at media_device_unregister_*() routines
+ */
+void graph_obj_remove(struct media_graph_obj *gobj)
+{
+	/* For now, nothing to do */
+}
+
+/**
  * media_entity_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 478d5cd56be9..58938bb980fe 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -28,6 +28,33 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+/* Enums used internally at the media controller to represent graphs */
+
+/**
+ * enum media_graph_type - type of a graph element
+ *
+ */
+enum media_graph_type {
+	 /* FIXME: add the types here, as we embeed media_graph_obj */
+	MEDIA_GRAPH_NONE
+};
+
+
+/* Structs to represent the objects that belong to a media graph */
+
+/**
+ * struct media_graph_obj - Define a graph object.
+ *
+ * @id:		Non-zero object ID identifier. The ID should be unique
+ *		inside a media_device
+ *
+ * All elements on the media graph should have this struct embedded
+ */
+struct media_graph_obj {
+	u32			id;
+};
+
+
 struct media_pipeline {
 };
 
@@ -128,6 +155,14 @@ struct media_entity_graph {
 
 #define entity_id(entity) ((entity)->id)
 
+#define gobj_to_entity(gobj) \
+		container_of(gobj, struct media_entity, graph_obj)
+
+void graph_obj_init(struct media_device *mdev,
+		    enum media_graph_type type,
+		    struct media_graph_obj *gobj);
+void graph_obj_remove(struct media_graph_obj *gobj);
+
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.3

