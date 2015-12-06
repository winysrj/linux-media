Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56307 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbLFCU0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 21:20:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 31/55] [media] media: add macros to check if subdev or V4L2 DMA
Date: Sun, 06 Dec 2015 04:20:38 +0200
Message-ID: <24575825.N6z5OZzxrl@avalon>
In-Reply-To: <a811ed07aab2bf1410ffe4c438fcbd4149581290.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <a811ed07aab2bf1410ffe4c438fcbd4149581290.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 09:02:57 Mauro Carvalho Chehab wrote:
> As we'll be removing entity subtypes from the Kernel, we need
> to provide a way for drivers and core to check if a given
> entity is represented by a V4L2 subdev or if it is an V4L2
> I/O entity (typically with DMA).
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 4e36b1f2b2d7..220864319d21 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -220,6 +220,39 @@ static inline u32 media_gobj_gen_id(enum
> media_gobj_type type, u32 local_id) return id;
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

I'm sorry but this simply won't scale. We need a better way to determine the 
entity type, and this could be a valid use case to actually retain an entity 
type field separate from the function, at least inside the kernel.

> +		return true;
> +
> +	default:
> +		return false;
> +	}
> +}
> +
>  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
>  #define MEDIA_ENTITY_ENUM_MAX_ID	64

-- 
Regards,

Laurent Pinchart

