Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2354 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab0HAL7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 07:59:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v3 06/10] media: Entities, pads and links enumeration
Date: Sun, 1 Aug 2010 13:58:20 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1280419616-7658-1-git-send-email-laurent.pinchart@ideasonboard.com> <1280419616-7658-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1280419616-7658-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201008011358.20459.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 29 July 2010 18:06:39 Laurent Pinchart wrote:
> Create the following two ioctls and implement them at the media device
> level to enumerate entities, pads and links.
> 
> - MEDIA_IOC_ENUM_ENTITIES: Enumerate entities and their properties
> - MEDIA_IOC_ENUM_LINKS: Enumerate all pads and links for a given entity
> 
> Entity IDs can be non-contiguous. Userspace applications should
> enumerate entities using the MEDIA_ENTITY_ID_FLAG_NEXT flag. When the
> flag is set in the entity ID, the MEDIA_IOC_ENUM_ENTITIES will return
> the next entity with an ID bigger than the requested one.
> 
> Only forward links that originate at one of the entity's source pads are
> returned during the enumeration process.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  Documentation/media-framework.txt |  131 +++++++++++++++++++++++++++++++
>  drivers/media/media-device.c      |  152 +++++++++++++++++++++++++++++++++++++
>  include/linux/media.h             |   77 +++++++++++++++++++
>  include/media/media-device.h      |    3 +
>  include/media/media-entity.h      |   18 +----
>  5 files changed, 364 insertions(+), 17 deletions(-)
>  create mode 100644 include/linux/media.h
> 
> diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
> index 6d680c6..1192feb 100644
> --- a/Documentation/media-framework.txt
> +++ b/Documentation/media-framework.txt
> @@ -273,3 +273,134 @@ required, drivers don't need to provide a set_power operation. The operation
>  is allowed to fail when turning power on, in which case the media_entity_get
>  function will return NULL.
>  
> +
> +Userspace application API
> +-------------------------
> +
> +Media devices offer an API to userspace application to discover the device
> +internal topology through ioctls.
> +
> +	MEDIA_IOC_ENUM_ENTITIES - Enumerate entities and their properties
> +	-----------------------------------------------------------------
> +
> +	ioctl(int fd, int request, struct media_entity_desc *argp);
> +
> +To query the attributes of an entity, applications set the id field of a
> +media_entity_desc structure and call the MEDIA_IOC_ENUM_ENTITIES ioctl with a
> +pointer to this structure. The driver fills the rest of the structure or
> +returns a EINVAL error code when the id is invalid.
> +
> +Entities can be enumerated by or'ing the id with the MEDIA_ENTITY_ID_FLAG_NEXT
> +flag. The driver will return information about the entity with the smallest id
> +strictly larger than the requested one ('next entity'), or EINVAL if there is
> +none.
> +
> +Entity IDs can be non-contiguous. Applications must *not* try to enumerate
> +entities by calling MEDIA_IOC_ENUM_ENTITIES with increasing id's until they
> +get an error.
> +
> +The media_entity_desc structure is defined as
> +
> +- struct media_entity_desc
> +
> +__u32	id		Entity id, set by the application. When the id is
> +			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
> +			clears the flag and returns the first entity with a
> +			larger id.
> +char	name[32]	Entity name. UTF-8 NULL-terminated string.
> +__u32	type		Entity type.
> +__u8	pads		Number of pads.

Should be u16.

> +__u32	links		Total number of outbound links. Inbound links are not
> +			counted in this field.
> +/* union */
> +	/* struct v4l, Valid for V4L sub-devices and nodes only */
> +__u32	major		V4L device node major number. For V4L sub-devices with
> +			no device node, set by the driver to 0.
> +__u32	minor		V4L device node minor number. For V4L sub-devices with
> +			no device node, set by the driver to 0.
> +	/* struct fb, Valid for frame buffer nodes only */
> +__u32	major		FB device node major number
> +__u32	minor		FB device node minor number
> +	/* Valid for ALSA devices only */
> +int	alsa		ALSA card number
> +	/* Valid for DVB devices only */
> +int	dvb		DVB card number
> +
> +Valid entity types are
> +
> +	MEDIA_ENTITY_TYPE_NODE - Unknown device node
> +	MEDIA_ENTITY_TYPE_NODE_V4L - V4L video, radio or vbi device node
> +	MEDIA_ENTITY_TYPE_NODE_FB - Frame buffer device node
> +	MEDIA_ENTITY_TYPE_NODE_ALSA - ALSA card
> +	MEDIA_ENTITY_TYPE_NODE_DVB - DVB card
> +
> +	MEDIA_ENTITY_TYPE_SUBDEV - Unknown V4L sub-device
> +	MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER - Video decoder
> +	MEDIA_ENTITY_TYPE_SUBDEV_VID_ENCODER - Video encoder
> +	MEDIA_ENTITY_TYPE_SUBDEV_MISC - Unspecified entity subtype
> +
> +
> +	MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
> +	----------------------------------------------------------------------
> +
> +	ioctl(int fd, int request, struct media_links_enum *argp);
> +
> +Only forward links that originate at one of the entity's source pads are
> +returned during the enumeration process.
> +
> +To enumerate pads and/or links for a given entity, applications set the entity
> +field of a media_links_enum structure and initialize the media_pad_desc and
> +media_link_desc structure arrays pointed by the pads and links fields. They then
> +call the MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
> +
> +If the pads field is not NULL, the driver fills the pads array with
> +information about the entity's pads. The array must have enough room to store
> +all the entity's pads. The number of pads can be retrieved with the
> +MEDIA_IOC_ENUM_ENTITIES ioctl.
> +
> +If the links field is not NULL, the driver fills the links array with
> +information about the entity's outbound links. The array must have enough room
> +to store all the entity's outbound links. The number of outbound links can be
> +retrieved with the MEDIA_IOC_ENUM_ENTITIES ioctl.
> +
> +The media_pad_desc, media_link_desc and media_links_enum structures are defined
> +as
> +
> +- struct media_pad_desc
> +
> +__u32		entity		ID of the entity this pad belongs to.
> +__u16		index		0-based pad index.
> +__u32		flags		Pad flags.
> +
> +Valid pad flags are
> +
> +	MEDIA_PAD_FLAG_INPUT -	Input pad, relative to the entity. Input pads
> +				sink data and are targets of links.
> +	MEDIA_PAD_FLAG_OUTPUT -	Output pad, relative to the entity. Output
> +				pads source data and are origins of links.
> +
> +One and only one of MEDIA_PAD_FLAG_INPUT and MEDIA_PAD_FLAG_OUTPUT must be set
> +for every pad.
> +
> +- struct media_link_desc
> +
> +struct media_pad_desc	source	Pad at the origin of this link.
> +struct media_pad_desc	sink	Pad at the target of this link.
> +__u32			flags	Link flags.
> +
> +Valid link flags are
> +
> +	MEDIA_LINK_FLAG_ACTIVE - The link is active and can be used to
> +		transfer media data. When two or more links target a sink pad,
> +		only one of them can be active at a time.
> +	MEDIA_LINK_FLAG_IMMUTABLE - The link active state can't be modified at
> +		runtime. An immutable link is always active.
> +
> +- struct media_links_enum
> +
> +__u32			entity	Entity id, set by the application.
> +struct media_pad_desc	*pads	Pointer to a pads array allocated by the
> +				application. Ignored if NULL.
> +struct media_link_desc	*links	Pointer to a links array allocated by the
> +				application. Ignored if NULL.
> +
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 6fb2e26..b32c308 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -20,13 +20,162 @@
>  
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/media.h>
>  
>  #include <media/media-device.h>
>  #include <media/media-devnode.h>
>  #include <media/media-entity.h>
>  
> +static int media_device_open(struct file *filp)
> +{
> +	return 0;
> +}
> +
> +static int media_device_close(struct file *filp)
> +{
> +	return 0;
> +}
> +
> +static struct media_entity *find_entity(struct media_device *mdev, u32 id)
> +{
> +	struct media_entity *entity;
> +	int next = id & MEDIA_ENTITY_ID_FLAG_NEXT;
> +
> +	id &= ~MEDIA_ENTITY_ID_FLAG_NEXT;
> +
> +	spin_lock(&mdev->lock);
> +
> +	media_device_for_each_entity(entity, mdev) {
> +		if ((entity->id == id && !next) ||
> +		    (entity->id > id && next)) {
> +			spin_unlock(&mdev->lock);
> +			return entity;
> +		}
> +	}
> +
> +	spin_unlock(&mdev->lock);
> +
> +	return NULL;
> +}
> +
> +static long media_device_enum_entities(struct media_device *mdev,
> +				       struct media_entity_desc __user *uent)
> +{
> +	struct media_entity *ent;
> +	struct media_entity_desc u_ent;
> +
> +	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
> +		return -EFAULT;
> +
> +	ent = find_entity(mdev, u_ent.id);
> +
> +	if (ent == NULL)
> +		return -EINVAL;
> +
> +	u_ent.id = ent->id;
> +	u_ent.name[0] = '\0';
> +	if (ent->name)
> +		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
> +	u_ent.type = ent->type;
> +	u_ent.pads = ent->num_pads;
> +	u_ent.links = ent->num_links - ent->num_backlinks;
> +	u_ent.v4l.major = ent->v4l.major;
> +	u_ent.v4l.minor = ent->v4l.minor;
> +	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static void media_device_kpad_to_upad(const struct media_pad *kpad,
> +				      struct media_pad_desc *upad)
> +{
> +	upad->entity = kpad->entity->id;
> +	upad->index = kpad->index;
> +	upad->flags = kpad->flags;
> +}
> +
> +static long media_device_enum_links(struct media_device *mdev,
> +				    struct media_links_enum __user *ulinks)
> +{
> +	struct media_entity *entity;
> +	struct media_links_enum links;
> +
> +	if (copy_from_user(&links, ulinks, sizeof(links)))
> +		return -EFAULT;
> +
> +	entity = find_entity(mdev, links.entity);
> +	if (entity == NULL)
> +		return -EINVAL;
> +
> +	if (links.pads) {
> +		unsigned int p;
> +
> +		for (p = 0; p < entity->num_pads; p++) {
> +			struct media_pad_desc pad;
> +			media_device_kpad_to_upad(&entity->pads[p], &pad);
> +			if (copy_to_user(&links.pads[p], &pad, sizeof(pad)))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	if (links.links) {
> +		struct media_link_desc __user *ulink;
> +		unsigned int l;
> +
> +		for (l = 0, ulink = links.links; l < entity->num_links; l++) {
> +			struct media_link_desc link;
> +
> +			/* Ignore backlinks. */
> +			if (entity->links[l].source->entity != entity)
> +				continue;
> +
> +			media_device_kpad_to_upad(entity->links[l].source,
> +						  &link.source);
> +			media_device_kpad_to_upad(entity->links[l].sink,
> +						  &link.sink);
> +			link.flags = entity->links[l].flags;
> +			if (copy_to_user(ulink, &link, sizeof(*ulink)))
> +				return -EFAULT;
> +			ulink++;
> +		}
> +	}
> +	if (copy_to_user(ulinks, &links, sizeof(*ulinks)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static long media_device_ioctl(struct file *filp, unsigned int cmd,
> +			       unsigned long arg)
> +{
> +	struct media_devnode *devnode = media_devnode_data(filp);
> +	struct media_device *dev = to_media_device(devnode);
> +	long ret;
> +
> +	switch (cmd) {
> +	case MEDIA_IOC_ENUM_ENTITIES:
> +		ret = media_device_enum_entities(dev,
> +				(struct media_entity_desc __user *)arg);
> +		break;
> +
> +	case MEDIA_IOC_ENUM_LINKS:
> +		mutex_lock(&dev->graph_mutex);
> +		ret = media_device_enum_links(dev,
> +				(struct media_links_enum __user *)arg);
> +		mutex_unlock(&dev->graph_mutex);
> +		break;
> +
> +	default:
> +		ret = -ENOIOCTLCMD;
> +	}
> +
> +	return ret;
> +}
> +
>  static const struct media_file_operations media_device_fops = {
>  	.owner = THIS_MODULE,
> +	.open = media_device_open,
> +	.unlocked_ioctl = media_device_ioctl,
> +	.release = media_device_close,
>  };
>  
>  static void media_device_release(struct media_devnode *mdev)
> @@ -99,6 +248,9 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	WARN_ON(entity->parent != NULL);
>  	entity->parent = mdev;
>  
> +	/* find_entity() relies on entities being stored in increasing IDs
> +	 * order. Don't change that without modifying find_entity().
> +	 */
>  	spin_lock(&mdev->lock);
>  	entity->id = mdev->entity_id++;
>  	list_add_tail(&entity->list, &mdev->entities);
> diff --git a/include/linux/media.h b/include/linux/media.h
> new file mode 100644
> index 0000000..9b8acc0
> --- /dev/null
> +++ b/include/linux/media.h
> @@ -0,0 +1,77 @@
> +#ifndef __LINUX_MEDIA_H
> +#define __LINUX_MEDIA_H
> +
> +#define MEDIA_ENTITY_TYPE_NODE			(1 << 16)
> +#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> +#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> +#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> +#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> +
> +#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << 16)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER	(MEDIA_ENTITY_TYPE_SUBDEV + 1)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_VID_ENCODER	(MEDIA_ENTITY_TYPE_SUBDEV + 2)
> +#define MEDIA_ENTITY_TYPE_SUBDEV_MISC		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
> +
> +#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
> +#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
> +
> +#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
> +#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
> +
> +#define MEDIA_ENTITY_ID_FLAG_NEXT		(1 << 31)
> +
> +struct media_pad_desc {
> +	__u32 entity;		/* entity ID */
> +	__u16 index;		/* pad index */
> +	__u32 flags;		/* pad flags */
> +	__u32 reserved[2];
> +};
> +
> +struct media_entity_desc {
> +	__u32 id;
> +	char name[32];
> +	__u32 type;
> +	__u8 pads;

u16.

> +	__u32 links;
> +
> +	__u32 reserved[4];
> +
> +	union {
> +		/* Node specifications */
> +		struct {
> +			__u32 major;
> +			__u32 minor;
> +		} v4l;
> +		struct {
> +			__u32 major;
> +			__u32 minor;
> +		} fb;
> +		int alsa;
> +		int dvb;
> +
> +		/* Sub-device specifications */
> +		/* Nothing needed yet */
> +		__u8 raw[64];
> +	};
> +};

Would there be anything else that we want to describe with these pad_desc and
entity_desc structs?

For subdevs you want to return a chip ident and revision field (same as
VIDIOC_DBG_G_CHIP_IDENT does).

Should we allow (possibly optional) names for pads? Or 'tooltip'-type descriptions
that can be a lot longer than 32 chars? (Just brainstorming here).

I am of course thinking of apps where the user can setup the media flow using a
GUI. If the driver can provide more extensive descriptions of the various
entities/pads, then that would make it much easier for the user to experiment.

Note that I also think that obtaining such detailed information might be better
done through separate ioctls (e.g. MEDIA_IOC_G_PAD_INFO, etc.).

What is definitely missing and *must* be added is a QUERYCAP type ioctl that
provides driver/versioning info.

Another thing that we need to figure out is how to tell the application which
audio and video nodes belong together. Not only that, but we need to be able
to inform the driver how audio is hooked up: through an audio loopback cable,
an alsa device, part of an mpeg stream, or as a V4L2 audio device (ivtv can do
that, and I think pvrusb2 does the same for radio). I'm not entirely sure we
want to expose that last option as it is not really spec compliant.

Other things we may want to expose: is the video stream raw or compressed? What
are the default video/audio/vbi streams? (That allows an app to find the default
video device node if a driver has lots of them).

Some of this information should perhaps be exposed through the v4l2 API, but
other parts definitely belong here.

I've not thought about this in detail, but we need to set some time aside to
brainstorm on how to provide this information in a logical and consistent manner.

Regards,

	Hans

> +
> +struct media_link_desc {
> +	struct media_pad_desc source;
> +	struct media_pad_desc sink;
> +	__u32 flags;
> +	__u32 reserved[2];
> +};
> +
> +struct media_links_enum {
> +	__u32 entity;
> +	/* Should have enough room for pads elements */
> +	struct media_pad_desc __user *pads;
> +	/* Should have enough room for links elements */
> +	struct media_link_desc __user *links;
> +	__u32 reserved[4];
> +};
> +
> +#define MEDIA_IOC_ENUM_ENTITIES		_IOWR('M', 1, struct media_entity_desc)
> +#define MEDIA_IOC_ENUM_LINKS		_IOWR('M', 2, struct media_links_enum)
> +
> +#endif /* __LINUX_MEDIA_H */
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 39a437c..7b09332 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -53,6 +53,9 @@ struct media_device {
>  	struct mutex graph_mutex;
>  };
>  
> +/* media_devnode to media_device */
> +#define to_media_device(node) container_of(node, struct media_device, devnode)
> +
>  int __must_check media_device_register(struct media_device *mdev);
>  void media_device_unregister(struct media_device *mdev);
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 2205cbc..fe8a650 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -2,23 +2,7 @@
>  #define _MEDIA_ENTITY_H
>  
>  #include <linux/list.h>
> -
> -#define MEDIA_ENTITY_TYPE_NODE			(1 << 16)
> -#define MEDIA_ENTITY_TYPE_NODE_V4L		(MEDIA_ENTITY_TYPE_NODE + 1)
> -#define MEDIA_ENTITY_TYPE_NODE_FB		(MEDIA_ENTITY_TYPE_NODE + 2)
> -#define MEDIA_ENTITY_TYPE_NODE_ALSA		(MEDIA_ENTITY_TYPE_NODE + 3)
> -#define MEDIA_ENTITY_TYPE_NODE_DVB		(MEDIA_ENTITY_TYPE_NODE + 4)
> -
> -#define MEDIA_ENTITY_TYPE_SUBDEV		(2 << 16)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_VID_DECODER	(MEDIA_ENTITY_TYPE_SUBDEV + 1)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_VID_ENCODER	(MEDIA_ENTITY_TYPE_SUBDEV + 2)
> -#define MEDIA_ENTITY_TYPE_SUBDEV_MISC		(MEDIA_ENTITY_TYPE_SUBDEV + 3)
> -
> -#define MEDIA_LINK_FLAG_ACTIVE			(1 << 0)
> -#define MEDIA_LINK_FLAG_IMMUTABLE		(1 << 1)
> -
> -#define MEDIA_PAD_FLAG_INPUT			(1 << 0)
> -#define MEDIA_PAD_FLAG_OUTPUT			(1 << 1)
> +#include <linux/media.h>
>  
>  struct media_link {
>  	struct media_pad *source;	/* Source pad */
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
