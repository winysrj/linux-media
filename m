Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40094 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 03/16] media: add functions to inialize media_graph_obj
Date: Fri,  7 Aug 2015 11:20:01 -0300
Message-Id: <aa98d5399a89dae2f27bb622b10fe179817d3e42.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to initialize the common media_graph_obj that
it is now embedded inside each media controller object.

Latter patches will use those functions to ensure that
the object will be properly initialized.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c7b1b2..19ad316f2f33 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -27,6 +27,44 @@
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
+	INIT_LIST_HEAD(&gobj->list);
+
+	list_add_tail(&gobj->list, &mdev->object_list);
+	gobj->obj_id = atomic_inc_return(&mdev->last_obj_id);
+	gobj->type = type;
+	gobj->mdev = mdev;
+}
+
+/**
+ *  graph_obj_remove - Stop using a graph object on a media device
+ *
+ * @graph_obj:	Pointer to the object
+ *
+ * This is called at media_device_unregister_*() routines, and removes a
+ * graph object from the mdev object lists.
+ */
+void graph_obj_remove(struct media_graph_obj *gobj)
+{
+	list_del(&gobj->list);
+}
+
+/**
  * media_entity_init - Initialize a media entity
  *
  * @num_pads: Total number of sink and source pads.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 051aa3f8bbfe..738e1d5d25dc 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -168,6 +168,14 @@ struct media_entity_graph {
 	int top;
 };
 
+#define gobj_to_entity(gobj) \
+		container_of(gobj, struct media_entity, graph_obj)
+
+void graph_obj_init(struct media_device *mdev,
+		    enum media_graph_type type,
+		    struct media_graph_obj *gobj);
+void graph_obj_remove(struct media_graph_obj *gobj);
+
 int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads, u16 extra_links);
 void media_entity_cleanup(struct media_entity *entity);
-- 
2.4.3

