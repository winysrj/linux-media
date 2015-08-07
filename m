Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 02/16] media: Add a common embeed struct for all media graph objects
Date: Fri,  7 Aug 2015 11:20:00 -0300
Message-Id: <10ca5f9841d48380defba6ada5f6390b42d73aa6.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the MC API proposed changes, we'll need to:
	- have an unique object ID for all graph objects;
	- be able to dynamically create/remove objects;
	- be able to group objects;
	- keep the object in memory until we stop use it.

Due to that, create a struct media_graph_obj and put there the
common elements that all media objects will have in common.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d817493..051aa3f8bbfe 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -28,10 +28,50 @@
 #include <linux/list.h>
 #include <linux/media.h>
 
+/* Enums used internally at the media controller to represent graphs */
+
+/**
+ * enum media_graph_type - type of a graph element
+ *
+ * @MEDIA_GRAPH_ENTITY:		Identify a media entity
+ * @MEDIA_GRAPH_PAD:		Identify a media PAD
+ * @MEDIA_GRAPH_LINK:		Identify a media link
+ */
+enum media_graph_type {
+	MEDIA_GRAPH_ENTITY,
+	MEDIA_GRAPH_PAD,
+	MEDIA_GRAPH_LINK,
+};
+
+
+/* Structs to represent the objects that belong to a media graph */
+
+/**
+ * struct media_graph_obj - Define a graph object.
+ *
+ * @list:		List of media graph objects
+ * @obj_id:		Non-zero object ID identifier. The ID should be unique
+ *			inside a media_device
+ * @type:		Type of the graph object
+ * @mdev:		Media device that contains the object
+ *			object before stopping using it
+ *
+ * All elements on the media graph should have this struct embedded
+ */
+struct media_graph_obj {
+	struct list_head	list;
+	struct list_head	group;
+	u32			obj_id;
+	enum media_graph_type	type;
+	struct media_device	*mdev;
+};
+
+
 struct media_pipeline {
 };
 
 struct media_link {
+	struct media_graph_obj			graph_obj;
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
 	struct media_link *reverse;	/* Link in the reverse direction */
@@ -39,6 +79,7 @@ struct media_link {
 };
 
 struct media_pad {
+	struct media_graph_obj			graph_obj;
 	struct media_entity *entity;	/* Entity this pad belongs to */
 	u16 index;			/* Pad index in the entity pads array */
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
@@ -61,6 +102,7 @@ struct media_entity_operations {
 };
 
 struct media_entity {
+	struct media_graph_obj			graph_obj;
 	struct list_head list;
 	struct media_device *parent;	/* Media device this entity belongs to*/
 	u32 id;				/* Entity ID, unique in the parent media
-- 
2.4.3

