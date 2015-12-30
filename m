Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52492 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbbL3Nti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:38 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/6] [media] media-entitiy: add a function to create multiple links
Date: Wed, 30 Dec 2015 11:48:54 -0200
Message-Id: <9c5e0deaa4e22f04ed026e4905950c450cfcb06a.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, it is desired to create 1:n and n:1 or even
n:n links between different entities with the same
function.

This is actually needed to support DVB devices that
have multiple frontends. While we could do a function
like that internally at the DVB core, such function is
generic enough to be at media-entity, and it could be
useful on some other places.

So, add such function.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 65 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/media-entity.h | 51 ++++++++++++++++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index eb38bc35320a..e89d85a7d31b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -625,6 +625,71 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
 
+int media_create_pad_links(const struct media_device *mdev,
+			   const u32 source_function,
+			   struct media_entity *source,
+			   const u16 source_pad,
+			   const u32 sink_function,
+			   struct media_entity *sink,
+			   const u16 sink_pad,
+			   u32 flags,
+			   const bool allow_both_undefined)
+{
+	struct media_entity *entity;
+	unsigned function;
+	int ret;
+
+	/* Trivial case: 1:1 relation */
+	if (source && sink)
+		return media_create_pad_link(source, source_pad,
+					     sink, sink_pad, flags);
+
+	/* Worse case scenario: n:n relation */
+	if (!source && !sink) {
+		if (!allow_both_undefined)
+			return 0;
+		media_device_for_each_entity(source, mdev) {
+			if (source->function != source_function)
+				continue;
+			media_device_for_each_entity(sink, mdev) {
+				if (sink->function != sink_function)
+					continue;
+				ret = media_create_pad_link(source, source_pad,
+							    sink, sink_pad,
+							    flags);
+				if (ret)
+					return ret;
+				flags &= ~(MEDIA_LNK_FL_ENABLED |
+					   MEDIA_LNK_FL_IMMUTABLE);
+			}
+		}
+		return 0;
+	}
+
+	/* Handle 1:n and n:1 cases */
+	if (source)
+		function = sink_function;
+	else
+		function = source_function;
+
+	media_device_for_each_entity(entity, mdev) {
+		if (entity->function != function)
+			continue;
+
+		if (source)
+			ret = media_create_pad_link(source, source_pad,
+						    entity, sink_pad, flags);
+		else
+			ret = media_create_pad_link(entity, source_pad,
+						    sink, sink_pad, flags);
+		if (ret)
+			return ret;
+		flags &= ~(MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_create_pad_links);
+
 void __media_entity_remove_links(struct media_entity *entity)
 {
 	struct media_link *link, *tmp;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 79dd81fd463e..fe485d367985 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -613,6 +613,57 @@ static inline void media_entity_cleanup(struct media_entity *entity) {};
 __must_check int media_create_pad_link(struct media_entity *source,
 			u16 source_pad, struct media_entity *sink,
 			u16 sink_pad, u32 flags);
+
+/**
+ * media_create_pad_links() - creates a link between two entities.
+ *
+ * @mdev: Pointer to the media_device that contains the object
+ * @source_function: Function of the source entities. Used only if @source is
+ *	NULL.
+ * @source: pointer to &media_entity of the source pad. If NULL, it will use
+ * 	all entities that matches the @sink_function.
+ * @source_pad: number of the source pad in the pads array
+ * @sink_function: Function of the sink entities. Used only if @sink is NULL.
+ * @sink: pointer to &media_entity of the sink pad. If NULL, it will use
+ * 	all entities that matches the @sink_function.
+ * @sink_pad: number of the sink pad in the pads array.
+ * @flags: Link flags, as defined in include/uapi/linux/media.h.
+ * @allow_both_undefined: if true, then both @source and @sink can be NULL.
+ *	In such case, it will create a crossbar between all entities that
+ *	matches @source_function to all entities that matches @sink_function.
+ *	If false, it will return 0 and won't create any link if both @source
+ *	and @sink are NULL.
+ *
+ * Valid values for flags:
+ * A %MEDIA_LNK_FL_ENABLED flag indicates that the link is enabled and can be
+ *	used to transfer media data. If multiple links are created and this
+ *	flag is passed as an argument, only the first created link will have
+ *	this flag.
+ *
+ * A %MEDIA_LNK_FL_IMMUTABLE flag indicates that the link enabled state can't
+ *	be modified at runtime. If %MEDIA_LNK_FL_IMMUTABLE is set, then
+ *	%MEDIA_LNK_FL_ENABLED must also be set since an immutable link is
+ *	always enabled.
+ *
+ * It is common for some devices to have multiple source and/or sink entities
+ * of the same type that should be linked. While media_create_pad_link()
+ * creates link by link, this function is meant to allow 1:n, n:1 and even
+ * cross-bar (n:n) links.
+ *
+ * NOTE: Before calling this function, media_entity_pads_init() and
+ * media_device_register_entity() should be called previously for the entities
+ * to be linked.
+ */
+int media_create_pad_links(const struct media_device *mdev,
+			   const u32 source_function,
+			   struct media_entity *source,
+			   const u16 source_pad,
+			   const u32 sink_function,
+			   struct media_entity *sink,
+			   const u16 sink_pad,
+			   u32 flags,
+			   const bool allow_both_undefined);
+
 void __media_entity_remove_links(struct media_entity *entity);
 
 /**
-- 
2.5.0


