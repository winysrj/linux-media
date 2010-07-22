Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54207 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0GVP1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 11:27:00 -0400
Message-ID: <4C48633F.9020001@maxwell.research.nokia.com>
Date: Thu, 22 Jul 2010 18:26:55 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC/PATCH v2 06/10] media: Entities, pads and links enumeration
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com> <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Laurent Pinchart wrote:
...
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

Another small comment, I think you mentioned it yourself some time back
:-): how about some reserved fields to these structures?

> +struct media_user_entity {
> +	__u32 id;
> +	char name[32];
> +	__u32 type;
> +	__u32 subtype;
> +	__u8 pads;
> +	__u32 links;
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
> +	};
> +};
> +
> +struct media_user_link {
> +	struct media_user_pad source;
> +	struct media_user_pad sink;
> +	__u32 flags;
> +};
> +
> +struct media_user_links {
> +	__u32 entity;
> +	/* Should have enough room for pads elements */
> +	struct media_user_pad __user *pads;
> +	/* Should have enough room for links elements */
> +	struct media_user_link __user *links;
> +};

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
