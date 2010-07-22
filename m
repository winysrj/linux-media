Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51096 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0GVPKL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 11:10:11 -0400
Message-ID: <4C485F49.2000703@maxwell.research.nokia.com>
Date: Thu, 22 Jul 2010 18:10:01 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heippa,

What a nice patch! :-)

Laurent Pinchart wrote:

...

> diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
> index 3acc62b..16c0177 100644
> --- a/Documentation/media-framework.txt
> +++ b/Documentation/media-framework.txt
> @@ -270,3 +270,137 @@ required, drivers don't need to provide a set_power operation. The operation
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
> +	ioctl(int fd, int request, struct media_user_entity *argp);
> +
> +To query the attributes of an entity, applications set the id field of a
> +media_user_entity structure and call the MEDIA_IOC_ENUM_ENTITIES ioctl with a
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
> +The media_user_entity structure is defined as
> +
> +- struct media_user_entity
> +
> +__u32	id		Entity id, set by the application. When the id is
> +			or'ed with MEDIA_ENTITY_ID_FLAG_NEXT, the driver
> +			clears the flag and returns the first entity with a
> +			larger id.
> +char	name[32]	Entity name. UTF-8 NULL-terminated string.
> +__u32	type		Entity type.
> +__u32	subtype		Entity subtype.
> +__u8	pads		Number of pads.
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
> +	MEDIA_ENTITY_TYPE_NODE - V4L, FB, ALSA or DVB device
> +	MEDIA_ENTITY_TYPE_SUBDEV - V4L sub-device
> +
> +For MEDIA_ENTITY_TYPE_NODE entities, valid entity subtypes are
> +
> +	MEDIA_ENTITY_SUBTYPE_NODE_V4L - V4L video, radio or vbi device node
> +	MEDIA_ENTITY_SUBTYPE_NODE_FB - Frame buffer device node
> +	MEDIA_ENTITY_SUBTYPE_NODE_ALSA - ALSA card
> +	MEDIA_ENTITY_SUBTYPE_NODE_DVB - DVB card
> +
> +For MEDIA_ENTITY_TYPE_SUBDEV entities, valid entity subtypes are
> +
> +	MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_DECODER - Video decoder
> +	MEDIA_ENTITY_SUBTYPE_SUBDEV_VID_ENCODER - Video encoder
> +	MEDIA_ENTITY_SUBTYPE_SUBDEV_MISC - Unspecified entity subtype
> +
> +
> +	MEDIA_IOC_ENUM_LINKS - Enumerate all pads and links for a given entity
> +	----------------------------------------------------------------------
> +
> +	ioctl(int fd, int request, struct media_user_links *argp);
> +
> +Only forward links that originate at one of the entity's source pads are
> +returned during the enumeration process.
> +
> +To enumerate pads and/or links for a given entity, applications set the entity
> +field of a media_user_links structure and initialize the media_user_pad and
> +media_user_link structure arrays pointed by the pads and links fields. They
> +then call the MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this structure.
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
> +The media_user_pad, media_user_link and media_user_links structure are defined
> +as

I have a comment on naming. These are user space structures, sure, but
do we want that fact to be visible in the names of the structures? I
would just drop the user_ out and make the naming as good as possible in
user space. That is much harder to change later than naming inside the
kernel.

That change causes a lot of clashes in naming since the equivalent
kernel structure is there as well. Those could have _k postfix, for
example, to differentiate them from user space names. I don't really
have a good suggestion how they should be called.

> +- struct media_user_pad
> +
> +__u32		entity		ID of the entity this pad belongs to.
> +__8		index		0-based pad index.

It's possible that 8 bits is enough (I think Hans commented this
already). The compiler will use 4 bytes in any case and I think it's a
good practice not to create holes in the structures, especially not to
the interface ones.

The OMAP 4 has a tiler, could it be that this kind of functionality
might introduce large numbers of pads in the future?

> +__u32		direction	Pad direction.
> +
> +Valid pad directions are
> +
> +	MEDIA_PAD_DIR_INPUT -	Input pad, relative to the entity. Input pads
> +				sink data and are targets of links.
> +	MEDIA_PAD_DIR_OUTPUT -	Output pad, relative to the entity. Output
> +				pads source data and are origins of links.
> +
> +- struct media_user_link
> +
> +struct media_user_pad	source	Pad at the origin of this link.
> +struct media_user_pad	sink	Pad at the target of this link.
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
> +- struct media_user_links
> +
> +__u32			entity	Entity id, set by the application.
> +struct media_user_pad	*pads	Pointer to a pads array allocated by the
> +				application. Ignored if NULL.
> +struct media_user_link	*links	Pointer to a links array allocated by the
> +				application. Ignored if NULL.
> +

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
