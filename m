Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbLMLB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 06:01:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/4] [media] media-entity.h: Document some ancillary functions
Date: Sun, 13 Dec 2015 09:01:40 -0200
Message-Id: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a basic documentation for most ancillary functions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-entity.h | 58 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index d073b205e6a6..81aca1f5a09a 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -238,11 +238,21 @@ struct media_intf_devnode {
 	u32				minor;
 };
 
+/**
+ * media_entity_id() - return the media entity graph object id
+ *
+ * @entity:	pointer to entity
+ */
 static inline u32 media_entity_id(struct media_entity *entity)
 {
 	return entity->graph_obj.id;
 }
 
+/**
+ * media_type() - return the media object type
+ *
+ * @gobj:	pointer to the media graph object
+ */
 static inline enum media_gobj_type media_type(struct media_gobj *gobj)
 {
 	return gobj->id >> MEDIA_BITS_PER_LOCAL_ID;
@@ -263,6 +273,15 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
 	return id;
 }
 
+/**
+ * is_media_entity_v4l2_io() - identify if the entity main function
+ *			       is a V4L2 I/O
+ *
+ * @entity:	pointer to entity
+ *
+ * Return: true if the entity main function is one of the V4L2 I/O types
+ *	(video, VBI or SDR radio); false otherwise.
+ */
 static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
 {
 	if (!entity)
@@ -278,6 +297,16 @@ static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
 	}
 }
 
+/**
+ * is_media_entity_v4l2_subdev - return true if the entity main function is
+ *				 associated with the V4L2 API subdev usage
+ *
+ * @entity:	pointer to entity
+ *
+ * This is an ancillary function used by subdev-based V4L2 drivers.
+ * It checks if the entity function is one of functions used by a V4L2 subdev,
+ * e. g. camera-relatef functions, analog TV decoder, TV tuner, V4L2 DSPs.
+ */
 static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 {
 	if (!entity)
@@ -652,16 +681,43 @@ struct media_link *
 __must_check media_create_intf_link(struct media_entity *entity,
 				    struct media_interface *intf,
 				    u32 flags);
+/**
+ * __media_remove_intf_link() - remove a single interface link
+ *
+ * @link:	pointer to &media_link.
+ *
+ * Note: this is an unlocked version of media_remove_intf_link()
+ */
 void __media_remove_intf_link(struct media_link *link);
+
+/**
+ * media_remove_intf_link() - remove a single interface link
+ *
+ * @link:	pointer to &media_link.
+ *
+ * Note: prefer to use this one, instead of __media_remove_intf_link()
+ */
 void media_remove_intf_link(struct media_link *link);
+
+/**
+ * __media_remove_intf_links() - remove all links associated with an interface
+ *
+ * @intf:	pointer to &media_interface
+ *
+ * Note: this is an unlocked version of media_remove_intf_links().
+ */
 void __media_remove_intf_links(struct media_interface *intf);
 /**
  * media_remove_intf_links() - remove all links associated with an interface
  *
  * @intf:	pointer to &media_interface
  *
- * Note: this is called automatically when an entity is unregistered via
+ * Notes:
+ *
+ * this is called automatically when an entity is unregistered via
  * media_device_register_entity() and by media_devnode_remove().
+ *
+ * Prefer to use this one, instead of __media_remove_intf_links().
  */
 void media_remove_intf_links(struct media_interface *intf);
 
-- 
2.5.0

