Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53370 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbJ1Agz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 20:36:55 -0400
Date: Wed, 28 Oct 2015 09:36:50 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 04/19] media: Move struct media_entity_graph definition
 up
Message-ID: <20151028093650.67648946@concha.lan>
In-Reply-To: <1445900510-1398-5-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-5-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:35 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> It will be needed in struct media_pipeline shortly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
(but see below)

> ---
>  include/media/media-entity.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index fc54192..dde9a5f 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -87,6 +87,16 @@ struct media_entity_enum {
>  	int idx_max;
>  };
>  
> +struct media_entity_graph {

Not a problem on this patch itself, but since you're touching this
struct, it would be nice to take the opportunity and document it ;)

Regards,
Mauro

> +	struct {
> +		struct media_entity *entity;
> +		struct list_head *link;
> +	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> +
> +	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
> +	int top;
> +};
> +
>  struct media_pipeline {
>  };
>  
> @@ -429,16 +439,6 @@ static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
>  	return bitmap_intersects(e->e, f->e, min(e->idx_max, f->idx_max));
>  }
>  
> -struct media_entity_graph {
> -	struct {
> -		struct media_entity *entity;
> -		struct list_head *link;
> -	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];
> -
> -	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);
> -	int top;
> -};
> -
>  #define gobj_to_entity(gobj) \
>  		container_of(gobj, struct media_entity, graph_obj)
>  


-- 

Cheers,
Mauro
