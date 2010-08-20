Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:40628 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0HTP3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Aug 2010 11:29:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v4 07/11] media: Entities, pads and links enumeration
Date: Fri, 20 Aug 2010 17:29:09 +0200
Message-Id: <1282318153-18885-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1282318153-18885-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

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
 Documentation/media-framework.txt |  142 ++++++++++++++++++++++++++++++++++++-
 drivers/media/media-device.c      |  123 ++++++++++++++++++++++++++++++++
 include/linux/media.h             |   81 +++++++++++++++++++++
 include/media/media-entity.h      |   24 +------
 4 files changed, 346 insertions(+), 24 deletions(-)

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 66f7f6c..74a137d 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -320,7 +320,7 @@ Userspace application API
 -------------------------
 
 Media devices offer an API to userspace application to query device information
-through ioctls.
+and discover the device internal topology through ioctls.
 
 	MEDIA_IOC_DEVICE_INFO - Get device information
 	----------------------------------------------
@@ -357,3 +357,143 @@ instances of otherwise identical hardware. The serial number takes precedence
 when provided and can be assumed to be unique. If the serial number is an
 empty string, the bus_info field can be used instead. The bus_info field is
 guaranteed to be unique, but can vary across reboots or device unplug/replug.
+
+
+	MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
+	-----------------------------------------------------------------
+
+	ioctl(int fd, int request, struct media_entity_desc *argp);
+
+To query the attributes of an entity, applications set the id field of a
+media_entity_desc structure and call the MEDIA_IOC_ENUM_ENTITIES ioctl with a
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
+Two or more entities that share a common non-zero group_id value are
+considered as logically grouped. Groups are used to report
+
+	- ALSA, VBI and video nodes that carry the same media stream
+	- lens and flash controllers associated with a sensor
+
+The media_entity_desc structure is defined as
+
+- struct media_entity_desc
+
+__u32	id		Entity id, set by the application. When the id is
+			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
+			clears the flag and returns the first entity with a
+			larger id.
+char	name[32]	Entity name. UTF-8 NULL-terminated string.
+__u32	type		Entity type.
+__u32	revision	Entity revision in a driver/hardware specific format.
+__u32	flags		Entity flags.
+__u32	group_id	Entity group ID.
+__u16	pads		Number of pads.
+__u16	links		Total number of outbound links. Inbound links are not
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
+	MEDIA_ENTITY_TYPE_NODE - Unknown device node
+	MEDIA_ENTITY_TYPE_NODE_V4L - V4L video, radio or vbi device node
+	MEDIA_ENTITY_TYPE_NODE_FB - Frame buffer device node
+	MEDIA_ENTITY_TYPE_NODE_ALSA - ALSA card
+	MEDIA_ENTITY_TYPE_NODE_DVB - DVB card
+
+	MEDIA_ENTITY_TYPE_SUBDEV - Unknown V4L sub-device
+	MEDIA_ENTITY_TYPE_SUBDEV_SENSOR - Video sensor
+	MEDIA_ENTITY_TYPE_SUBDEV_FLASH - Flash controller
+	MEDIA_ENTITY_TYPE_SUBDEV_LENS - Lens controller
+
+Valid entity flags are
+
+	MEDIA_ENTITY_FLAG_DEFAULT - Default entity for its type. Used to
+		discover the default audio, VBI and video devices, the default
+		camera sensor, ...
+
+
+	MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
+	----------------------------------------------------------------------
+
+	ioctl(int fd, int request, struct media_links_enum *argp);
+
+Only forward links that originate at one of the entity's source pads are
+returned during the enumeration process.
+
+To enumerate pads and/or links for a given entity, applications set the entity
+field of a media_links_enum structure and initialize the media_pad_desc and
+media_link_desc structure arrays pointed by the pads and links fields. They then
+call the MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
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
+The media_pad_desc, media_link_desc and media_links_enum structures are defined
+as
+
+- struct media_pad_desc
+
+__u32		entity		ID of the entity this pad belongs to.
+__u16		index		0-based pad index.
+__u32		flags		Pad flags.
+
+Valid pad flags are
+
+	MEDIA_PAD_FLAG_INPUT -	Input pad, relative to the entity. Input pads
+				sink data and are targets of links.
+	MEDIA_PAD_FLAG_OUTPUT -	Output pad, relative to the entity. Output
+				pads source data and are origins of links.
+
+One and only one of MEDIA_PAD_FLAG_INPUT and MEDIA_PAD_FLAG_OUTPUT must be set
+for every pad.
+
+- struct media_link_desc
+
+struct media_pad_desc	source	Pad at the origin of this link.
+struct media_pad_desc	sink	Pad at the target of this link.
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
+- struct media_links_enum
+
+__u32			entity	Entity id, set by the application.
+struct media_pad_desc	*pads	Pointer to a pads array allocated by the
+				application. Ignored if NULL.
+struct media_link_desc	*links	Pointer to a links array allocated by the
+				application. Ignored if NULL.
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1415ebd..7e020f9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -59,6 +59,117 @@ static int media_device_get_info(struct media_device *dev,
 	return copy_to_user(__info, &info, sizeof(*__info));
 }
 
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
+				       struct media_entity_desc __user *uent)
+{
+	struct media_entity *ent;
+	struct media_entity_desc u_ent;
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
+	u_ent.revision = ent->revision;
+	u_ent.flags = ent->flags;
+	u_ent.group_id = ent->group_id;
+	u_ent.pads = ent->num_pads;
+	u_ent.links = ent->num_links - ent->num_backlinks;
+	u_ent.v4l.major = ent->v4l.major;
+	u_ent.v4l.minor = ent->v4l.minor;
+	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
+		return -EFAULT;
+	return 0;
+}
+
+static void media_device_kpad_to_upad(const struct media_pad *kpad,
+				      struct media_pad_desc *upad)
+{
+	upad->entity = kpad->entity->id;
+	upad->index = kpad->index;
+	upad->flags = kpad->flags;
+}
+
+static long media_device_enum_links(struct media_device *mdev,
+				    struct media_links_enum __user *ulinks)
+{
+	struct media_entity *entity;
+	struct media_links_enum links;
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
+			struct media_pad_desc pad;
+			media_device_kpad_to_upad(&entity->pads[p], &pad);
+			if (copy_to_user(&links.pads[p], &pad, sizeof(pad)))
+				return -EFAULT;
+		}
+	}
+
+	if (links.links) {
+		struct media_link_desc __user *ulink;
+		unsigned int l;
+
+		for (l = 0, ulink = links.links; l < entity->num_links; l++) {
+			struct media_link_desc link;
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
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
@@ -72,6 +183,18 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 				(struct media_device_info __user *)arg);
 		break;
 
+	case MEDIA_IOC_ENUM_ENTITIES:
+		ret = media_device_enum_entities(dev,
+				(struct media_entity_desc __user *)arg);
+		break;
+
+	case MEDIA_IOC_ENUM_LINKS:
+		mutex_lock(&dev->graph_mutex);
+		ret = media_device_enum_links(dev,
+				(struct media_links_enum __user *)arg);
+		mutex_unlock(&dev->graph_mutex);
+		break;
+
 	default:
 		ret = -ENOIOCTLCMD;
 	}
diff --git a/include/linux/media.h b/include/linux/media.h
index bca08a7..542509b 100644
--- a/include/linux/media.h
+++ b/include/linux/media.h
@@ -18,6 +18,87 @@ struct media_device_info {
 	__u32 reserved[5];
 };
 
+#define MEDIA_ENTITY_ID_FLAG_NEXT		(1 << 31)
+
+#define MEDIA_ENTITY_TYPE_SHIFT			16
+#define MEDIA_ENTITY_TYPE_MASK			0x00ff0000
+#define MEDIA_ENTITY_SUBTYPE_MASK		0x0000ffff
+
+#define MEDIA_ENTITY_TYPE_NODE			(1 << MEDIA_ENTITY_TYPE_SHIFT)
+#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
+#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
+#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
+#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
+
+#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
+#define MEDIA_ENTITY_TYPE_SUBDEV_SENSOR		(MEDIA_ENTITY_TYPE_SUBDEV + 1)
+#define MEDIA_ENTITY_TYPE_SUBDEV_FLASH		(MEDIA_ENTITY_TYPE_SUBDEV + 2)
+#define MEDIA_ENTITY_TYPE_SUBDEV_LENS		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
+
+#define MEDIA_ENTITY_FLAG_DEFAULT		(1 << 0)
+
+struct media_entity_desc {
+	__u32 id;
+	char name[32];
+	__u32 type;
+	__u32 revision;
+	__u32 flags;
+	__u32 group_id;
+	__u16 pads;
+	__u16 links;
+
+	__u32 reserved[4];
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
+		__u8 raw[64];
+	};
+};
+
+#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
+#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
+
+struct media_pad_desc {
+	__u32 entity;		/* entity ID */
+	__u16 index;		/* pad index */
+	__u32 flags;		/* pad flags */
+	__u32 reserved[2];
+};
+
+#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
+#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
+
+struct media_link_desc {
+	struct media_pad_desc source;
+	struct media_pad_desc sink;
+	__u32 flags;
+	__u32 reserved[2];
+};
+
+struct media_links_enum {
+	__u32 entity;
+	/* Should have enough room for pads elements */
+	struct media_pad_desc __user *pads;
+	/* Should have enough room for links elements */
+	struct media_link_desc __user *links;
+	__u32 reserved[4];
+};
+
 #define MEDIA_IOC_DEVICE_INFO		_IOWR('M', 1, struct media_device_info)
+#define MEDIA_IOC_ENUM_ENTITIES		_IOWR('M', 2, struct media_entity_desc)
+#define MEDIA_IOC_ENUM_LINKS		_IOWR('M', 3, struct media_links_enum)
 
 #endif /* __LINUX_MEDIA_H */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index edcafeb..8c40d5e 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -2,29 +2,7 @@
 #define _MEDIA_ENTITY_H
 
 #include <linux/list.h>
-
-#define MEDIA_ENTITY_TYPE_SHIFT			16
-#define MEDIA_ENTITY_TYPE_MASK			0x00ff0000
-#define MEDIA_ENTITY_SUBTYPE_MASK		0x0000ffff
-
-#define MEDIA_ENTITY_TYPE_NODE			(1 << MEDIA_ENTITY_TYPE_SHIFT)
-#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
-#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
-#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
-#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
-
-#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << MEDIA_ENTITY_TYPE_SHIFT)
-#define MEDIA_ENTITY_TYPE_SUBDEV_SENSOR		(MEDIA_ENTITY_TYPE_SUBDEV + 1)
-#define MEDIA_ENTITY_TYPE_SUBDEV_FLASH		(MEDIA_ENTITY_TYPE_SUBDEV + 2)
-#define MEDIA_ENTITY_TYPE_SUBDEV_LENS		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
-
-#define MEDIA_ENTITY_FLAG_DEFAULT		(1 << 0)
-
-#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
-#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
-
-#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
-#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
+#include <linux/media.h>
 
 struct media_link {
 	struct media_pad *source;	/* Source pad */
-- 
1.7.1

