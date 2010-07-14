Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51140 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100Ab0GNN3Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jul 2010 09:29:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH 07/10] media: Links setup
Date: Wed, 14 Jul 2010 15:30:16 +0200
Message-Id: <1279114219-27389-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279114219-27389-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create the following ioctl and implement it at the media device level to
setup links.

- MEDIA_IOC_SETUP_LINK: Modify the properties of a given link

The only property that can currently be modified is the ACTIVE link flag
to activate/deactivate a link. Links marked with the IMMUTABLE link flag
can not be activated or deactivated.

Activating and deactivating a link has effects on entities' use count.
Those changes are automatically propagated through the graph.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/media-framework.txt |   83 +++++++++++++++++-
 drivers/media/media-device.c      |   45 ++++++++++
 drivers/media/media-entity.c      |  167 +++++++++++++++++++++++++++++++++++++
 include/linux/media.h             |    1 +
 include/media/media-entity.h      |    9 ++
 5 files changed, 301 insertions(+), 4 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 0f3d720..80a332d 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -231,6 +231,16 @@ When the graph traversal is complete the function will return NULL.
 Graph traversal can be interrupted at any moment. No cleanup function call is
 required and the graph structure can be freed normally.
 
+Helper functions can be used to find a link between two given pads, or a pad
+connected to another pad through an active link
+
+	media_entity_find_link(struct media_entity_pad *source,
+			       struct media_entity_pad *sink);
+
+	media_entity_remote_pad(struct media_entity_pad *pad);
+
+Refer to the kerneldoc documentation for more information.
+
 
 Reference counting and power handling
 -------------------------------------
@@ -269,11 +279,51 @@ is allowed to fail when turning power on, in which case the media_entity_get
 function will return NULL.
 
 
+Links setup
+-----------
+
+Link properties can be modified at runtime by calling
+
+	media_entity_setup_link(struct media_entity_link *link, u32 flags);
+
+The flags argument contains the requested new link flags.
+
+The only configurable property is the ACTIVE link flag to activate/deactivate
+a link. Links marked with the IMMUTABLE link flag can not be activated or
+deactivated.
+
+When a link is activated or deactivated, the media framework calls the
+link_setup operation for the two entities at the source and sink of the link,
+in that order. If the second link_setup call fails, another link_setup call is
+made on the first entity to restore the original link flags.
+
+Entity drivers must implement the link_setup operation if any of their links
+is non-immutable. The operation must either configure the hardware or store
+the configuration information to be applied later.
+
+Link activation must not have any side effect on other links. If an active
+link at a sink pad prevents another link at the same pad from being
+deactivated, the link_setup operation must return -EBUSY and can't implicitly
+deactivate the first active link.
+
+Activating and deactivating a link has effects on entities' reference counts.
+When two sub-graphs are connected, the reference count of each of them is
+incremented by the total reference count of all node entities in the other
+sub-graph. When two sub-graphs are disconnected, the reverse operation is
+performed. In both cases the set_power operations are called accordingly,
+ensuring that the link_setup calls are made with power active on the source
+and sink entities.
+
+In other words, activating or deactivating a link propagates reference count
+changes through the graph, and the final state is identical to what it would
+have been if the link had been active or inactive from the start.
+
+
 Userspace application API
 -------------------------
 
 Media devices offer an API to userspace application to discover the device
-internal topology through ioctls.
+internal topology and setup links through ioctls.
 
 	MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
 	-----------------------------------------------------------------
@@ -346,9 +396,6 @@ For MEDIA_ENTITY_TYPE_SUBDEV entities, valid entity subtypes are
 
 	ioctl(int fd, int request, struct media_user_links *argp);
 
-Only forward links that originate at one of the entity's source pads are
-returned during the enumeration process.
-
 To enumerate pads and/or links for a given entity, applications set the entity
 field of a media_user_links structure and initialize the media_user_pad and
 media_user_link structure arrays pointed by the pads and links fields. They
@@ -364,6 +411,9 @@ information about the entity's outbound links. The array must have enough room
 to store all the entity's outbound links. The number of outbound links can be
 retrieved with the MEDIA_IOC_ENUM_ENTITIES ioctl.
 
+Only outbound (forward) links that originate at one of the entity's source
+pads are returned during the enumeration process.
+
 The media_user_pad, media_user_link and media_user_links structure are defined
 as
 
@@ -402,3 +452,28 @@ struct media_user_pad	*pads	Pointer to a pads array allocated by the
 struct media_user_link	*links	Pointer to a links array allocated by the
 				application. Ignored if NULL.
 
+
+	MEDIA_IOC_SETUP_LINK - Modify the properties of a link
+	------------------------------------------------------
+
+	ioctl(int fd, int request, struct media_user_link *argp);
+
+To change link properties applications fill a media_user_link structure with
+link identification information (source and sink pad) and the new requested
+link flags. They then call the MEDIA_IOC_SETUP_LINK ioctl with a pointer to
+that structure.
+
+The only configurable property is the ACTIVE link flag to activate/deactivate
+a link. Links marked with the IMMUTABLE link flag can not be activated or
+deactivated.
+
+Link activation has no side effect on other links. If an active link at the
+sink pad prevents the link from being activated, the driver returns with a
+EBUSY error code.
+
+If the specified link can't be found the driver returns with a EINVAL error
+code.
+
+The media_user_pad and media_user_link structures are described in the
+MEDIA_IOC_ENUM_LINKS ioctl documentation.
+
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 539f4b9..5825e67 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -145,6 +145,44 @@ static long media_device_enum_links(struct media_device *mdev,
 	return 0;
 }
 
+static long media_device_setup_link(struct media_device *mdev,
+				    struct media_user_link __user *_ulink)
+{
+	struct media_entity_link *link = NULL;
+	struct media_user_link ulink;
+	struct media_entity *source;
+	struct media_entity *sink;
+	int ret;
+
+	if (copy_from_user(&ulink, _ulink, sizeof(ulink)))
+		return -EFAULT;
+
+	/* Find the source and sink entities and link.
+	 */
+	source = find_entity(mdev, ulink.source.entity);
+	sink = find_entity(mdev, ulink.sink.entity);
+
+	if (source == NULL || sink == NULL)
+		return -EINVAL;
+
+	if (ulink.source.index >= source->num_pads ||
+	    ulink.sink.index >= sink->num_pads)
+		return -EINVAL;
+
+	link = media_entity_find_link(&source->pads[ulink.source.index],
+				      &sink->pads[ulink.sink.index]);
+	if (link == NULL)
+		return -EINVAL;
+
+	/* Setup the link on both entities. */
+	ret = __media_entity_setup_link(link, ulink.flags);
+
+	if (copy_to_user(_ulink, &ulink, sizeof(ulink)))
+		return -EFAULT;
+
+	return ret;
+}
+
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
@@ -165,6 +203,13 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		mutex_unlock(&dev->graph_mutex);
 		break;
 
+	case MEDIA_IOC_SETUP_LINK:
+		mutex_lock(&dev->graph_mutex);
+		ret = media_device_setup_link(dev,
+				(struct media_user_link __user *)arg);
+		mutex_unlock(&dev->graph_mutex);
+		break;
+
 	default:
 		ret = -ENOIOCTLCMD;
 	}
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a597cd5..e9a8d30 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -449,3 +449,170 @@ media_entity_create_link(struct media_entity *source, u8 source_pad,
 	return 0;
 }
 EXPORT_SYMBOL(media_entity_create_link);
+
+static int __media_entity_setup_link_notify(struct media_entity_link *link,
+					    u32 flags)
+{
+	const u32 mask = MEDIA_LINK_FLAG_ACTIVE;
+	int ret;
+
+	/* Notify both entities. */
+	ret = media_entity_call(link->source->entity, link_setup,
+				link->source, link->sink, flags);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		return ret;
+
+	ret = media_entity_call(link->sink->entity, link_setup,
+				link->sink, link->source, flags);
+	if (ret < 0 && ret != -ENOIOCTLCMD) {
+		media_entity_call(link->source->entity, link_setup,
+				  link->source, link->sink, link->flags);
+		return ret;
+	}
+
+	link->flags = (link->flags & ~mask) | (flags & mask);
+	link->other->flags = link->flags;
+
+	return 0;
+}
+
+/**
+ * __media_entity_setup_link - Configure a media link
+ * @link: The link being configured
+ * @flags: Link configuration flags
+ *
+ * The bulk of link setup is handled by the two entities connected through the
+ * link. This function notifies both entities of the link configuration change.
+ *
+ * If the link is immutable or if the current and new configuration are
+ * identical, return immediately.
+ *
+ * The user is expected to hold link->source->parent->mutex. If not,
+ * media_entity_setup_link() should be used instead.
+ */
+int
+__media_entity_setup_link(struct media_entity_link *link, u32 flags)
+{
+	struct media_entity *source, *sink;
+	int ret = -EBUSY;
+
+	if (link == NULL)
+		return -EINVAL;
+
+	if (link->flags & MEDIA_LINK_FLAG_IMMUTABLE)
+		return link->flags == flags ? 0 : -EINVAL;
+
+	if (link->flags == flags)
+		return 0;
+
+	source = __media_entity_get(link->source->entity);
+	if (!source)
+		return ret;
+
+	sink = __media_entity_get(link->sink->entity);
+	if (!sink)
+		goto err___media_entity_get;
+
+	if (flags & MEDIA_LINK_FLAG_ACTIVE) {
+		ret = media_entity_power_connect(source, sink);
+		if (ret < 0)
+			goto err_media_entity_power_connect;
+	}
+
+	ret = __media_entity_setup_link_notify(link, flags);
+	if (ret < 0)
+		goto err___media_entity_setup_link_notify;
+
+	if (!(flags & MEDIA_LINK_FLAG_ACTIVE))
+		media_entity_power_disconnect(source, sink);
+
+	__media_entity_put(sink);
+	__media_entity_put(source);
+
+	return 0;
+
+err___media_entity_setup_link_notify:
+	if (flags & MEDIA_LINK_FLAG_ACTIVE)
+		media_entity_power_disconnect(source, sink);
+err_media_entity_power_connect:
+	__media_entity_put(sink);
+err___media_entity_get:
+	__media_entity_put(source);
+
+	return ret;
+}
+
+int media_entity_setup_link(struct media_entity_link *link, u32 flags)
+{
+	int ret;
+
+	mutex_lock(&link->source->entity->parent->graph_mutex);
+	ret = __media_entity_setup_link(link, flags);
+	mutex_unlock(&link->source->entity->parent->graph_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(media_entity_setup_link);
+
+/**
+ * media_entity_find_link - Find a link between two pads
+ * @source: Source pad
+ * @sink: Sink pad
+ *
+ * Return a pointer to the link between the two entities. If no such link
+ * exists, return NULL.
+ */
+struct media_entity_link *
+media_entity_find_link(struct media_entity_pad *source,
+		       struct media_entity_pad *sink)
+{
+	struct media_entity_link *link;
+	unsigned int i;
+
+	for (i = 0; i < source->entity->num_links; ++i) {
+		link = &source->entity->links[i];
+
+		if (link->source->entity == source->entity &&
+		    link->source->index == source->index &&
+		    link->sink->entity == sink->entity &&
+		    link->sink->index == sink->index)
+			return link;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(media_entity_find_link);
+
+/**
+ * media_entity_remote_pad - Locate the pad at the remote end of a link
+ * @entity: Local entity
+ * @pad: Pad at the local end of the link
+ *
+ * Search for a remote pad connected to the given pad by iterating over all
+ * links originating or terminating at that pad until an active link is found.
+ *
+ * Return a pointer to the pad at the remote end of the first found active link,
+ * or NULL if no active link has been found.
+ */
+struct media_entity_pad *
+media_entity_remote_pad(struct media_entity_pad *pad)
+{
+	unsigned int i;
+
+	for (i = 0; i < pad->entity->num_links; i++) {
+		struct media_entity_link *link = &pad->entity->links[i];
+
+		if (!(link->flags & MEDIA_LINK_FLAG_ACTIVE))
+			continue;
+
+		if (link->source == pad)
+			return link->sink;
+
+		if (link->sink == pad)
+			return link->source;
+	}
+
+	return NULL;
+
+}
+EXPORT_SYMBOL_GPL(media_entity_remote_pad);
diff --git a/include/linux/media.h b/include/linux/media.h
index 7739f07..c87b75b 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -69,5 +69,6 @@ struct media_user_links {
 
 #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('M', 1, struct media_user_entity)
 #define MEDIA_IOC_ENUM_LINKS		_IOWR('M', 2, struct media_user_links)
+#define MEDIA_IOC_SETUP_LINK		_IOWR('M', 3, struct media_user_link)
 
 #endif /* __LINUX_MEDIA_H */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index b9767cb..0f118b8 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -18,6 +18,9 @@ struct media_entity_pad {
 };
 
 struct media_entity_operations {
+	int (*link_setup)(struct media_entity *entity,
+			  const struct media_entity_pad *local,
+			  const struct media_entity_pad *remote, u32 flags);
 	int (*set_power)(struct media_entity *entity, int power);
 };
 
@@ -76,6 +79,12 @@ int media_entity_init(struct media_entity *entity, u8 num_pads,
 void media_entity_cleanup(struct media_entity *entity);
 int media_entity_create_link(struct media_entity *source, u8 source_pad,
 		struct media_entity *sink, u8 sink_pad, u32 flags);
+int __media_entity_setup_link(struct media_entity_link *link, u32 flags);
+int media_entity_setup_link(struct media_entity_link *link, u32 flags);
+struct media_entity_link *media_entity_find_link(
+		struct media_entity_pad *source, struct media_entity_pad *sink);
+struct media_entity_pad *media_entity_remote_pad(
+		struct media_entity_pad *pad);
 
 struct media_entity *media_entity_get(struct media_entity *entity);
 void media_entity_put(struct media_entity *entity);
-- 
1.7.1

