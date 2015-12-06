Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56212 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbLFBDN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 20:03:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v8 39/55] [media] media controller: get rid of entity subtype on Kernel
Date: Sun, 06 Dec 2015 03:03:26 +0200
Message-ID: <1534300.8hW6ASM2EE@avalon>
In-Reply-To: <728826957177ee11793b6b28b4e61e94b2d3068c.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <728826957177ee11793b6b28b4e61e94b2d3068c.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 06 September 2015 09:02:59 Mauro Carvalho Chehab wrote:
> Don't use anymore the type/subtype entity data/macros
> inside the Kernel.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 220864319d21..7320cdc45833 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -185,16 +185,6 @@ struct media_intf_devnode {
>  	u32				minor;
>  };
> 
> -static inline u32 media_entity_type(struct media_entity *entity)
> -{
> -	return entity->type & MEDIA_ENT_TYPE_MASK;
> -}
> -
> -static inline u32 media_entity_subtype(struct media_entity *entity)
> -{
> -	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
> -}
> -
>  static inline u32 media_entity_id(struct media_entity *entity)
>  {
>  	return entity->graph_obj.id;
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 3d6210095336..f90147cb9b57 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,8 +42,6 @@ struct media_device_info {
> 
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
> 
> -/* Used values for media_entity_desc::type */
> -
>  /*
>   * Initial value to be used when a new entity is created
>   * Drivers should change it to something useful

-- 
Regards,

Laurent Pinchart

