Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:56629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbbIKKLS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:18 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 3/9] media: Add an API to manage entity enumerations
Date: Fri, 11 Sep 2015 13:09:06 +0300
Message-Id: <1441966152-28444-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is useful in e.g. knowing whether certain operations have already
been performed for an entity. The users include the framework itself (for
graph walking) and a number of drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/media/media-entity.h | 45 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2c56027..17ec205 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -23,7 +23,7 @@
 #ifndef _MEDIA_ENTITY_H
 #define _MEDIA_ENTITY_H
 
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/media.h>
@@ -309,6 +309,49 @@ static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 #define MEDIA_ENTITY_MAX_LOW_ID	64
 
+#define DECLARE_MEDIA_ENTITY_ENUM(name)		\
+	DECLARE_BITMAP(name, MEDIA_ENTITY_MAX_LOW_ID)
+
+static inline void media_entity_enum_init(unsigned long *e)
+{
+	bitmap_zero(e, MEDIA_ENTITY_MAX_LOW_ID);
+}
+
+static inline void media_entity_enum_set(unsigned long *e,
+					 struct media_entity *entity)
+{
+	__set_bit(entity->low_id, e);
+}
+
+static inline void media_entity_enum_clear(unsigned long *e,
+					   struct media_entity *entity)
+{
+	__clear_bit(entity->low_id, e);
+}
+
+static inline bool media_entity_enum_test(unsigned long *e,
+					  struct media_entity *entity)
+{
+	return test_bit(entity->low_id, e);
+}
+
+static inline bool media_entity_enum_test_and_set(unsigned long *e,
+						  struct media_entity *entity)
+{
+	return __test_and_set_bit(entity->low_id, e);
+}
+
+static inline bool media_entity_enum_empty(unsigned long *e)
+{
+	return bitmap_empty(e, MEDIA_ENTITY_MAX_LOW_ID);
+}
+
+static inline bool media_entity_enum_intersects(unsigned long *e,
+						unsigned long *f)
+{
+	return bitmap_intersects(e, f, MEDIA_ENTITY_MAX_LOW_ID);
+}
+
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-- 
2.1.0.231.g7484e3b

