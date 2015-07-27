Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbbG0BcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2015 21:32:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH_RFC 1/2] media: add support for control entities/links/pads at MC
Date: Sun, 26 Jul 2015 22:32:05 -0300
Message-Id: <4c03f73052960e512f2daa4a9ec1c7d11cfc1fe6.1437960099.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1437960099.git.mchehab@osg.samsung.com>
References: <cover.1437960099.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1437960099.git.mchehab@osg.samsung.com>
References: <cover.1437960099.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to represent entities and links for control-only
device nodes, as such kind of devices happen on several media
devices, like radio and digital TV.

While we might fork almost everything at the MC in order to
support such entities, it is easier to just change the internal
representation, being sure that the existing ioctls will keep
showing only the data links.

We can then add latter additional ioctls that will navegate at
the data links.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7b39440192d6..2cfd385638f4 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -65,7 +65,8 @@ static int media_device_get_info(struct media_device *dev,
 	return 0;
 }
 
-static struct media_entity *find_entity(struct media_device *mdev, u32 id)
+static struct media_entity *find_entity(struct media_device *mdev, u32 id,
+					bool is_data)
 {
 	struct media_entity *entity;
 	int next = id & MEDIA_ENT_ID_FLAG_NEXT;
@@ -75,6 +76,11 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 	spin_lock(&mdev->lock);
 
 	media_device_for_each_entity(entity, mdev) {
+		/* Discard entities that don't match the plane (data/control) */
+		if (is_data && !media_entity_is_data(entity))
+			continue;
+		else if (!media_entity_is_control(entity))
+			continue;
 		if ((entity->id == id && !next) ||
 		    (entity->id > id && next)) {
 			spin_unlock(&mdev->lock);
@@ -87,8 +93,9 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 	return NULL;
 }
 
-static long media_device_enum_entities(struct media_device *mdev,
-				       struct media_entity_desc __user *uent)
+static long
+media_device_enum_data_entities(struct media_device *mdev,
+				struct media_entity_desc __user *uent)
 {
 	struct media_entity *ent;
 	struct media_entity_desc u_ent;
@@ -97,7 +104,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
 		return -EFAULT;
 
-	ent = find_entity(mdev, u_ent.id);
+	ent = find_entity(mdev, u_ent.id, true);
 
 	if (ent == NULL)
 		return -EINVAL;
@@ -126,20 +133,28 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
 }
 
 static long __media_device_enum_links(struct media_device *mdev,
-				      struct media_links_enum *links)
+				      struct media_links_enum *links,
+				      bool is_data)
 {
 	struct media_entity *entity;
+	enum media_plane plane;
 
-	entity = find_entity(mdev, links->entity);
+	entity = find_entity(mdev, links->entity, is_data);
 	if (entity == NULL)
 		return -EINVAL;
 
+	plane = is_data ? MEDIA_ENT_P_DATA : MEDIA_ENT_P_CONTROL;
+
 	if (links->pads) {
 		unsigned int p;
 
 		for (p = 0; p < entity->num_pads; p++) {
 			struct media_pad_desc pad;
 
+			/* Ignore PADs that don't match the seek plane */
+			if (entity->pads[p].plane != plane)
+				continue;
+
 			memset(&pad, 0, sizeof(pad));
 			media_device_kpad_to_upad(&entity->pads[p], &pad);
 			if (copy_to_user(&links->pads[p], &pad, sizeof(pad)))
@@ -154,6 +169,10 @@ static long __media_device_enum_links(struct media_device *mdev,
 		for (l = 0, ulink = links->links; l < entity->num_links; l++) {
 			struct media_link_desc link;
 
+			/* Ignore links that don't match the seek plane */
+			if (entity->links[l].plane != plane)
+				continue;
+
 			/* Ignore backlinks. */
 			if (entity->links[l].source->entity != entity)
 				continue;
@@ -173,8 +192,8 @@ static long __media_device_enum_links(struct media_device *mdev,
 	return 0;
 }
 
-static long media_device_enum_links(struct media_device *mdev,
-				    struct media_links_enum __user *ulinks)
+static long media_device_enum_data_links(struct media_device *mdev,
+				         struct media_links_enum __user *ulinks)
 {
 	struct media_links_enum links;
 	int rval;
@@ -182,7 +201,7 @@ static long media_device_enum_links(struct media_device *mdev,
 	if (copy_from_user(&links, ulinks, sizeof(links)))
 		return -EFAULT;
 
-	rval = __media_device_enum_links(mdev, &links);
+	rval = __media_device_enum_links(mdev, &links, true);
 	if (rval < 0)
 		return rval;
 
@@ -192,8 +211,8 @@ static long media_device_enum_links(struct media_device *mdev,
 	return 0;
 }
 
-static long media_device_setup_link(struct media_device *mdev,
-				    struct media_link_desc __user *_ulink)
+static long media_device_setup_data_link(struct media_device *mdev,
+				         struct media_link_desc __user *_ulink)
 {
 	struct media_link *link = NULL;
 	struct media_link_desc ulink;
@@ -204,10 +223,9 @@ static long media_device_setup_link(struct media_device *mdev,
 	if (copy_from_user(&ulink, _ulink, sizeof(ulink)))
 		return -EFAULT;
 
-	/* Find the source and sink entities and link.
-	 */
-	source = find_entity(mdev, ulink.source.entity);
-	sink = find_entity(mdev, ulink.sink.entity);
+	/* Find the source and sink data entities and link. */
+	source = find_entity(mdev, ulink.source.entity, true);
+	sink = find_entity(mdev, ulink.sink.entity, true);
 
 	if (source == NULL || sink == NULL)
 		return -EINVAL;
@@ -244,20 +262,20 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case MEDIA_IOC_ENUM_ENTITIES:
-		ret = media_device_enum_entities(dev,
+		ret = media_device_enum_data_entities(dev,
 				(struct media_entity_desc __user *)arg);
 		break;
 
 	case MEDIA_IOC_ENUM_LINKS:
 		mutex_lock(&dev->graph_mutex);
-		ret = media_device_enum_links(dev,
+		ret = media_device_enum_data_links(dev,
 				(struct media_links_enum __user *)arg);
 		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	case MEDIA_IOC_SETUP_LINK:
 		mutex_lock(&dev->graph_mutex);
-		ret = media_device_setup_link(dev,
+		ret = media_device_setup_data_link(dev,
 				(struct media_link_desc __user *)arg);
 		mutex_unlock(&dev->graph_mutex);
 		break;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c7b1b2..e2ee974568ba 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -151,10 +151,10 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 EXPORT_SYMBOL_GPL(media_entity_graph_walk_start);
 
 /**
- * media_entity_graph_walk_next - Get the next entity in the graph
+ * media_entity_graph_walk_next - Get the next entity in the data graph
  * @graph: Media graph structure
  *
- * Perform a depth-first traversal of the given media entities graph.
+ * Perform a depth-first traversal of the given media entities data graph.
  *
  * The graph structure must have been previously initialized with a call to
  * media_entity_graph_walk_start().
@@ -184,6 +184,12 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 			continue;
 		}
 
+		/* The link is not data so we do not follow. */
+		if (!(link->plane != MEDIA_ENT_P_DATA)) {
+			link_top(graph)++;
+			continue;
+		}
+
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
 		if (WARN_ON(next->id >= MEDIA_ENTITY_ENUM_MAX_ID))
@@ -258,6 +264,11 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 			struct media_pad *pad = link->sink->entity == entity
 						? link->sink : link->source;
 
+			/* The pad is not data so don't touch it */
+			if (!(pad->plane != MEDIA_ENT_P_DATA)) {
+				continue;
+			}
+
 			/* Mark that a pad is connected by a link. */
 			bitmap_clear(has_no_links, pad->index, 1);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d817493..42717d45246b 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -31,17 +31,47 @@
 struct media_pipeline {
 };
 
+/**
+ * enum media_plane - Specify if an entity/link/pad is for control or data
+ *
+ * @MEDIA_ENT_P_DATA:		The MC element belongs to the data plane,
+ *				e. g. the data traffic passes though this
+ *				link/pad/entity
+ *
+ * @MEDIA_ENT_P_CONTROL:	The MC element belongs to the control plane,
+ *				e. g. the link/pad/entity is used to control
+ *				the entities by setting registers, powering
+ *				on/off the entity, putting it to sleep/wake,
+ *				etc. This should be used by device node
+ *				entities that don't pass data.
+ *				Control links should always be connecting a
+ *				controlentity with some other entity.
+ * @MEDIA_ENT_P_CONTROL_DATA:	Used only for entities. This should be used
+ *				by entities that are device nodes and also
+ *				have data passed though it, like V4L2 most
+ *				subdevice entities.
+ */
+enum media_plane {
+    MEDIA_ENT_P_DATA = 0,
+    MEDIA_ENT_P_CONTROL,
+    MEDIA_ENT_P_CONTROL_DATA
+};
+
 struct media_link {
 	struct media_pad *source;	/* Source pad */
 	struct media_pad *sink;		/* Sink pad  */
 	struct media_link *reverse;	/* Link in the reverse direction */
 	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
+
+	enum media_plane plane;		/* Link is data and or control */
 };
 
 struct media_pad {
 	struct media_entity *entity;	/* Entity this pad belongs to */
 	u16 index;			/* Pad index in the entity pads array */
 	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
+
+	enum media_plane plane;		/* Pad is data or control */
 };
 
 /**
@@ -91,6 +121,8 @@ struct media_entity {
 
 	struct media_pipeline *pipe;	/* Pipeline this entity belongs to. */
 
+	enum media_plane plane;		/* Entity is data and/or control */
+
 	union {
 		/* Node specifications */
 		struct {
@@ -113,6 +145,26 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
 	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
 }
 
+static inline bool media_entity_is_data(struct media_entity *entity)
+{
+	if (entity->plane == MEDIA_ENT_P_DATA)
+		return true;
+	if (entity->plane == MEDIA_ENT_P_CONTROL_DATA)
+		return true;
+
+	return false;
+}
+
+static inline bool media_entity_is_control(struct media_entity *entity)
+{
+	if (entity->plane == MEDIA_ENT_P_CONTROL)
+		return true;
+	if (entity->plane == MEDIA_ENT_P_CONTROL_DATA)
+		return true;
+
+	return false;
+}
+
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 #define MEDIA_ENTITY_ENUM_MAX_ID	64
 
-- 
2.4.3

