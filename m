Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51333 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614Ab0GUOfm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:35:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Wed, 21 Jul 2010 16:35:31 +0200
Message-Id: <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create the following two ioctls and implement them at the media device
level to enumerate entities, pads and links.

- MEDIA_IOC_ENUM_ENTITIES: Enumerate entities and their properties
- MEDIA_IOC_ENUM_LINKS: Enumerate all pads and links for a given entity

Entity IDs can be non-contiguous. Userspace applications should
enumerate entities using the MEDIA_ENTITY_ID_FLAG_NEXT flag. When the
flag is set in the entity ID, the MEDIA_IOC_ENUM_ENTITIES will return
the next entity with an ID bigger than the requested one.

Only forward links that originate at one of the entity's source pads are
returned during the enumeration process.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/media-framework.txt |  134 ++++++++++++++++++++++++++++++++
 drivers/media/media-device.c      |  153 +++++++++++++++++++++++++++++++++++++
 include/linux/media.h             |   73 ++++++++++++++++++
 include/media/media-device.h      |    3 +
 include/media/media-entity.h      |   19 +-----
 5 files changed, 364 insertions(+), 18 deletions(-)
 create mode 100644 include/linux/media.h

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 3acc62b..16c0177 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -270,3 +270,137 @@ required, drivers don't need to provide a set_power operation. The operation
 is allowed to fail when turning power on, in which case the media_entity_get
 function will return NULL.
 
+
+Userspace application API
+-------------------------
+
+Media devices offer an API to userspace application to discover the device
+internal topology through ioctls.
+
+	MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
+	-----------------------------------------------------------------
+
+	ioctl(int fd, int request, struct media_user_entity *argp);
+
+To query the attributes of an entity, applications set the id field of a
+media_user_entity structure and call the MEDIA_IOC_ENUM_ENTITIES ioctl with a
+pointer to this structure. The driver fills the rest of the structure or
+returns a EINVAL error code when the id is invalid.
+
+Entities can be enumerated by or'ing the id with the MEDIA_ENTITY_ID_FLAG_NEXT
+flag. The driver will return information about the entity with the smallest id
+strictly larger than the requested one ('next entity'), or EINVAL if there is
+none.
+
+Entity IDs can be non-contiguous. Applications must *not* try to enumerate
+entities by calling MEDIA_IOC_ENUM_ENTITIES with increasing id's until they
+get an error.
+
+The media_user_entity structure is defined as
+
+- struct media_user_entity
+
+__u32	id		Entity id, set by the application. When the id is
+			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
+			clears the flag and returns the first entity with a
+			larger id.
+char	name[32]	Entity name. UTF-8 NULL-terminated string.
+__u32	type		Entity type.
+__u32	subtype		Entity subtype.
+__u8	pads		Number of pads.
+__u32	links		Total number of outbound links. Inbound links are not
+			counted in this field.
+/* union */
+	/* struct v4l, Valid for V4L sub-devices and nodes only */
+__u32	major		V4L device node major number. For V4L sub-devices with
+			no device node, set by the driver to 0.
+__u32	minor		V4L device node minor number. For V4L sub-devices with
+			no device node, set by the driver to 0.
+	/* struct fb, Valid for frame buffer nodes only */
+__u32	major		FB device node major number
+__u32	minor		FB device node minor number
+	/* Valid for ALSA devices only */
+int	alsa		ALSA card number
+	/* Valid for DVB devices only */
+int	dvb		DVB card number
+
+Valid entity types are
+
+	MEDIA_ENTITY_TYPE_NODE - V4L, FB, ALSA or DVB device
+	MEDIA_ENTITY_TYPE_SUBDEV - V4L sub-device
+
+For MEDIA_ENTITY_TYPE_NODE entities, valid entity subtypes are
+
+	MEDIA_ENTITY_SUBTYPE_NODE_V4L - V4L video, radio or vbi device node
+	MEDIA_ENTITY_SUBTYPE_NODE_FB - Frame buffer device node
+	MEDIA_ENTITY_SUBTYPE_NODE_ALSA - ALSA card
+	MEDIA_ENTITY_SUBTYPE_NODE_DVB - DVB card
+
+For MEDIA_ENTITY_TYPE_SUBDEV entities, valid entity subtypes are
+
+	MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER - Video decoder
+	MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER - Video encoder
+	MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC - Unspecified entity subtype
+
+
+	MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
+	----------------------------------------------------------------------
+
+	ioctl(int fd, int request, struct media_user_links *argp);
+
+Only forward links that originate at one of the entity's source pads are
+returned during the enumeration process.
+
+To enumerate pads and/or links for a given entity, applications set the entity
+field of a media_user_links structure and initialize the media_user_pad and
+media_user_link structure arrays pointed by the pads and links fields. They
+then call the MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
+
+If the pads field is not NULL, the driver fills the pads array with
+information about the entity's pads. The array must have enough room to store
+all the entity's pads. The number of pads can be retrieved with the
+MEDIA_IOC_ENUM_ENTITIES ioctl.
+
+If the links field is not NULL, the driver fills the links array with
+information about the entity's outbound links. The array must have enough room
+to store all the entity's outbound links. The number of outbound links can be
+retrieved with the MEDIA_IOC_ENUM_ENTITIES ioctl.
+
+The media_user_pad, media_user_link and media_user_links structure are defined
+as
+
+- struct media_user_pad
+
+__u32		entity		ID of the entity this pad belongs to.
+__8		index		0-based pad index.
+__u32		direction	Pad direction.
+
+Valid pad directions are
+
+	MEDIA_PAD_DIR_INPUT -	Input pad, relative to the entity. Input pads
+				sink data and are targets of links.
+	MEDIA_PAD_DIR_OUTPUT -	Output pad, relative to the entity. Output
+				pads source data and are origins of links.
+
+- struct media_user_link
+
+struct media_user_pad	source	Pad at the origin of this link.
+struct media_user_pad	sink	Pad at the target of this link.
+__u32			flags	Link flags.
+
+Valid link flags are
+
+	MEDIA_LINK_FLAG_ACTIVE - The link is active and can be used to
+		transfer media data. When two or more links target a sink pad,
+		only one of them can be active at a time.
+	MEDIA_LINK_FLAG_IMMUTABLE - The link active state can't be modified at
+		runtime. An immutable link is always active.
+
+- struct media_user_links
+
+__u32			entity	Entity id, set by the application.
+struct media_user_pad	*pads	Pointer to a pads array allocated by the
+				application. Ignored if NULL.
+struct media_user_link	*links	Pointer to a links array allocated by the
+				application. Ignored if NULL.
+
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 097419b..976a8df 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,13 +20,163 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/media.h>
 
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+static int media_device_open(struct file *filp)
+{
+	return 0;
+}
+
+static int media_device_close(struct file *filp)
+{
+	return 0;
+}
+
+static struct media_entity *find_entity(struct media_device *mdev, u32 id)
+{
+	struct media_entity *entity;
+	int next = id & MEDIA_ENTITY_ID_FLAG_NEXT;
+
+	id &= ~MEDIA_ENTITY_ID_FLAG_NEXT;
+
+	spin_lock(&mdev->lock);
+
+	media_device_for_each_entity(entity, mdev) {
+		if ((entity->id == id && !next) ||
+		    (entity->id > id && next)) {
+			spin_unlock(&mdev->lock);
+			return entity;
+		}
+	}
+
+	spin_unlock(&mdev->lock);
+
+	return NULL;
+}
+
+static long media_device_enum_entities(struct media_device *mdev,
+				       struct media_user_entity __user *uent)
+{
+	struct media_entity *ent;
+	struct media_user_entity u_ent;
+
+	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
+		return -EFAULT;
+
+	ent = find_entity(mdev, u_ent.id);
+
+	if (ent == NULL)
+		return -EINVAL;
+
+	u_ent.id = ent->id;
+	u_ent.name[0] = '\0';
+	if (ent->name)
+		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
+	u_ent.type = ent->type;
+	u_ent.subtype = ent->subtype;
+	u_ent.pads = ent->num_pads;
+	u_ent.links = ent->num_links - ent->num_backlinks;
+	u_ent.v4l.major = ent->v4l.major;
+	u_ent.v4l.minor = ent->v4l.minor;
+	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
+		return -EFAULT;
+	return 0;
+}
+
+static void media_device_kpad_to_upad(const struct media_entity_pad *kpad,
+				      struct media_user_pad *upad)
+{
+	upad->entity = kpad->entity->id;
+	upad->index = kpad->index;
+	upad->direction = kpad->direction;
+}
+
+static long media_device_enum_links(struct media_device *mdev,
+				    struct media_user_links __user *ulinks)
+{
+	struct media_entity *entity;
+	struct media_user_links links;
+
+	if (copy_from_user(&links, ulinks, sizeof(links)))
+		return -EFAULT;
+
+	entity = find_entity(mdev, links.entity);
+	if (entity == NULL)
+		return -EINVAL;
+
+	if (links.pads) {
+		unsigned int p;
+
+		for (p = 0; p < entity->num_pads; p++) {
+			struct media_user_pad pad;
+			media_device_kpad_to_upad(&entity->pads[p], &pad);
+			if (copy_to_user(&links.pads[p], &pad, sizeof(pad)))
+				return -EFAULT;
+		}
+	}
+
+	if (links.links) {
+		struct media_user_link __user *ulink;
+		unsigned int l;
+
+		for (l = 0, ulink = links.links; l < entity->num_links; l++) {
+			struct media_user_link link;
+
+			/* Ignore backlinks. */
+			if (entity->links[l].source->entity != entity)
+				continue;
+
+			media_device_kpad_to_upad(entity->links[l].source,
+						  &link.source);
+			media_device_kpad_to_upad(entity->links[l].sink,
+						  &link.sink);
+			link.flags = entity->links[l].flags;
+			if (copy_to_user(ulink, &link, sizeof(*ulink)))
+				return -EFAULT;
+			ulink++;
+		}
+	}
+	if (copy_to_user(ulinks, &links, sizeof(*ulinks)))
+		return -EFAULT;
+	return 0;
+}
+
+static long media_device_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct media_devnode *devnode = media_devnode_data(filp);
+	struct media_device *dev = to_media_device(devnode);
+	long ret;
+
+	switch (cmd) {
+	case MEDIA_IOC_ENUM_ENTITIES:
+		ret = media_device_enum_entities(dev,
+				(struct media_user_entity __user *)arg);
+		break;
+
+	case MEDIA_IOC_ENUM_LINKS:
+		mutex_lock(&dev->graph_mutex);
+		ret = media_device_enum_links(dev,
+				(struct media_user_links __user *)arg);
+		mutex_unlock(&dev->graph_mutex);
+		break;
+
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
 static const struct media_file_operations media_device_fops = {
 	.owner = THIS_MODULE,
+	.open = media_device_open,
+	.unlocked_ioctl = media_device_ioctl,
+	.release = media_device_close,
 };
 
 static void media_device_release(struct media_devnode *mdev)
@@ -100,6 +250,9 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	WARN_ON(entity->parent != NULL);
 	entity->parent = mdev;
 
+	/* find_entity() relies on entities being stored in increasing IDs
+	 * order. Don't change that without modifying find_entity().
+	 */
 	spin_lock(&mdev->lock);
 	entity->id = mdev->entity_id++;
 	list_add_tail(&entity->list, &mdev->entities);
diff --git a/include/linux/media.h b/include/linux/media.h
new file mode 100644
index 0000000..746bdda
--- /dev/null
+++ b/include/linux/media.h
@@ -0,0 +1,73 @@
+#ifndef __LINUX_MEDIA_H
+#define __LINUX_MEDIA_H
+
+#define MEDIA_ENTITY_TYPE_NODE				1
+#define MEDIA_ENTITY_TYPE_SUBDEV			2
+
+#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
+#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
+#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
+#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
+
+#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
+#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
+#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3
+
+#define MEDIA_PAD_DIR_INPUT				1
+#define MEDIA_PAD_DIR_OUTPUT				2
+
+#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
+#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
+
+#define MEDIA_ENTITY_ID_FLAG_NEXT	(1 << 31)
+
+struct media_user_pad {
+	__u32 entity;		/* entity ID */
+	__u8 index;		/* pad index */
+	__u32 direction;	/* pad direction */
+};
+
+struct media_user_entity {
+	__u32 id;
+	char name[32];
+	__u32 type;
+	__u32 subtype;
+	__u8 pads;
+	__u32 links;
+
+	union {
+		/* Node specifications */
+		struct {
+			__u32 major;
+			__u32 minor;
+		} v4l;
+		struct {
+			__u32 major;
+			__u32 minor;
+		} fb;
+		int alsa;
+		int dvb;
+
+		/* Sub-device specifications */
+		/* Nothing needed yet */
+	};
+};
+
+struct media_user_link {
+	struct media_user_pad source;
+	struct media_user_pad sink;
+	__u32 flags;
+};
+
+struct media_user_links {
+	__u32 entity;
+	/* Should have enough room for pads elements */
+	struct media_user_pad __user *pads;
+	/* Should have enough room for links elements */
+	struct media_user_link __user *links;
+};
+
+#define MEDIA_IOC_ENUM_ENTITIES		_IOWR('M', 1, struct media_user_entity)
+#define MEDIA_IOC_ENUM_LINKS		_IOWR('M', 2, struct media_user_links)
+
+#endif /* __LINUX_MEDIA_H */
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 4d3ad0e..087e788 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -58,6 +58,9 @@ struct media_device {
 	char name[MEDIA_DEVICE_NAME_SIZE];
 };
 
+/* media_devnode to media_device */
+#define to_media_device(node) container_of(node, struct media_device, devnode)
+
 int __must_check media_device_register(struct media_device *mdev);
 void media_device_unregister(struct media_device *mdev);
 
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 63c30a0..f51128d 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -2,24 +2,7 @@
 #define _MEDIA_ENTITY_H
 
 #include <linux/list.h>
-
-#define MEDIA_ENTITY_TYPE_NODE				1
-#define MEDIA_ENTITY_TYPE_SUBDEV			2
-
-#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
-#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
-#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
-#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
-
-#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
-#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
-#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3
-
-#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
-#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
-
-#define MEDIA_PAD_DIR_INPUT				1
-#define MEDIA_PAD_DIR_OUTPUT				2
+#include <linux/media.h>
 
 struct media_entity_link {
 	struct media_entity_pad *source;/* Source pad */
-- 
1.7.1

