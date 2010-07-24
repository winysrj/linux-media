Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1996 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0GXMpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 08:45:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
Date: Sat, 24 Jul 2010 14:45:39 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201007241445.40062.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 21 July 2010 16:35:31 Laurent Pinchart wrote:
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
>  Documentation/media-framework.txt |  134 ++++++++++++++++++++++++++++++++
>  drivers/media/media-device.c      |  153 +++++++++++++++++++++++++++++++++++++
>  include/linux/media.h             |   73 ++++++++++++++++++
>  include/media/media-device.h      |    3 +
>  include/media/media-entity.h      |   19 +-----
>  5 files changed, 364 insertions(+), 18 deletions(-)
>  create mode 100644 include/linux/media.h

<snip>

> diff --git a/include/linux/media.h b/include/linux/media.h
> new file mode 100644
> index 0000000..746bdda
> --- /dev/null
> +++ b/include/linux/media.h
> @@ -0,0 +1,73 @@
> +#ifndef __LINUX_MEDIA_H
> +#define __LINUX_MEDIA_H
> +
> +#define MEDIA_ENTITY_TYPE_NODE				1
> +#define MEDIA_ENTITY_TYPE_SUBDEV			2
> +
> +#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
> +#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
> +#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
> +#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
> +
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
> +#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3
> +
> +#define MEDIA_PAD_DIR_INPUT				1
> +#define MEDIA_PAD_DIR_OUTPUT				2
> +
> +#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
> +#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
> +
> +#define MEDIA_ENTITY_ID_FLAG_NEXT	(1 << 31)
> +
> +struct media_user_pad {
> +	__u32 entity;		/* entity ID */
> +	__u8 index;		/* pad index */
> +	__u32 direction;	/* pad direction */
> +};

How about:

struct media_pad {
	__u32 entity;		/* entity ID */
	__u16 index;		/* pad index */
	__u16 flags;		/* pad flags (includes direction) */
	u32 reserved;
};

I think u16 for the number of pads might be safer than a u8.

> +
> +struct media_user_entity {
> +	__u32 id;
> +	char name[32];
> +	__u32 type;
> +	__u32 subtype;
> +	__u8 pads;
> +	__u32 links;

Need reserved fields.

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

Add something like:

		__u8 raw[64];

> +	};
> +};
> +
> +struct media_user_link {
> +	struct media_user_pad source;
> +	struct media_user_pad sink;
> +	__u32 flags;

Add a single __u32 reserved.

> +};
> +
> +struct media_user_links {
> +	__u32 entity;
> +	/* Should have enough room for pads elements */
> +	struct media_user_pad __user *pads;
> +	/* Should have enough room for links elements */
> +	struct media_user_link __user *links;

Add a  __u32 reserved[4].

> +};
> +
> +#define MEDIA_IOC_ENUM_ENTITIES		_IOWR('M', 1, struct media_user_entity)
> +#define MEDIA_IOC_ENUM_LINKS		_IOWR('M', 2, struct media_user_links)

We also need a MEDIA_IOC_QUERYCAP or MEDIA_IOC_VERSION or something like that.

> +
> +#endif /* __LINUX_MEDIA_H */
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 4d3ad0e..087e788 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -58,6 +58,9 @@ struct media_device {
>  	char name[MEDIA_DEVICE_NAME_SIZE];
>  };
>  
> +/* media_devnode to media_device */
> +#define to_media_device(node) container_of(node, struct media_device, devnode)
> +
>  int __must_check media_device_register(struct media_device *mdev);
>  void media_device_unregister(struct media_device *mdev);
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 63c30a0..f51128d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -2,24 +2,7 @@
>  #define _MEDIA_ENTITY_H
>  
>  #include <linux/list.h>
> -
> -#define MEDIA_ENTITY_TYPE_NODE				1
> -#define MEDIA_ENTITY_TYPE_SUBDEV			2
> -
> -#define MEDIA_ENTITY_SUBTYPE_NODE_V4L			1
> -#define MEDIA_ENTITY_SUBTYPE_NODE_FB			2
> -#define MEDIA_ENTITY_SUBTYPE_NODE_ALSA			3
> -#define MEDIA_ENTITY_SUBTYPE_NODE_DVB			4
> -
> -#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER		1
> -#define MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER		2
> -#define MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC		3
> -
> -#define MEDIA_LINK_FLAG_ACTIVE				(1 << 0)
> -#define MEDIA_LINK_FLAG_IMMUTABLE			(1 << 1)
> -
> -#define MEDIA_PAD_DIR_INPUT				1
> -#define MEDIA_PAD_DIR_OUTPUT				2
> +#include <linux/media.h>
>  
>  struct media_entity_link {
>  	struct media_entity_pad *source;/* Source pad */
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
