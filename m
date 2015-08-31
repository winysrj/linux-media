Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43066 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbbHaLc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:32:29 -0400
Message-ID: <55E43B14.9050506@xs4all.nl>
Date: Mon, 31 Aug 2015 13:31:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 31/55] [media] media: add macros to check if subdev
 or V4L2 DMA
References: <cover.1440902901.git.mchehab@osg.samsung.com> <eeff62ccee9a5f9ad0c92e6da2953900ad7f7c03.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <eeff62ccee9a5f9ad0c92e6da2953900ad7f7c03.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> As we'll be removing entity subtypes from the Kernel, we need
> to provide a way for drivers and core to check if a given
> entity is represented by a V4L2 subdev or if it is an V4L2
> I/O entity (typically with DMA).

This needs more discussion. The plan (as I understand it) is to have properties
that describe the entity's functionalities.

The existing entity subtypes will exist only as backwards compat types, but in
the future properties should be used to describe the functionalities.

This raises the question if we shouldn't use MEDIA_ENT_T_V4L2_SUBDEV to tell
userspace that this is a subdev-controlled entity, and let userspace look at
the properties to figure out what it is exactly?

It could be that this is a transitional patch, and this will be fixed later.
If so, this should be mentioned in the commit message.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e7b20bdc735d..b0cfbc0dffc7 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -220,6 +220,39 @@ static inline u32 media_gobj_gen_id(enum media_gobj_type type, u32 local_id)
>  	return id;
>  }
>  
> +static inline bool is_media_entity_v4l2_io(struct media_entity *entity)
> +{
> +	if (!entity)
> +		return false;
> +
> +	switch (entity->type) {
> +	case MEDIA_ENT_T_V4L2_VIDEO:
> +	case MEDIA_ENT_T_V4L2_VBI:
> +	case MEDIA_ENT_T_V4L2_SWRADIO:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static inline bool is_media_entity_v4l2_subdev(struct media_entity *entity)
> +{
> +	if (!entity)
> +		return false;
> +
> +	switch (entity->type) {
> +	case MEDIA_ENT_T_V4L2_SUBDEV_SENSOR:
> +	case MEDIA_ENT_T_V4L2_SUBDEV_FLASH:
> +	case MEDIA_ENT_T_V4L2_SUBDEV_LENS:
> +	case MEDIA_ENT_T_V4L2_SUBDEV_DECODER:
> +	case MEDIA_ENT_T_V4L2_SUBDEV_TUNER:
> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
>  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>  #define MEDIA_ENTITY_ENUM_MAX_ID	64
>  
> 

