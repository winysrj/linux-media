Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39223 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbbLLPMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 10:12:30 -0500
Date: Sat, 12 Dec 2015 13:12:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com
Subject: Re: [PATCH v2 04/22] media: Move struct media_entity_graph
 definition up
Message-ID: <20151212131225.30fc30ba@recife.lan>
In-Reply-To: <1448824823-10372-5-git-send-email-sakari.ailus@iki.fi>
References: <1448824823-10372-1-git-send-email-sakari.ailus@iki.fi>
	<1448824823-10372-5-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 29 Nov 2015 21:20:05 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> It will be needed in struct media_pipeline shortly.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/media-entity.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 5a0339a..2601bb0 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -95,6 +95,16 @@ struct media_entity_enum {
>  	int idx_max;
>  };
>  
> +struct media_entity_graph {
> +	struct {
> +		struct media_entity *entity;
> +		struct list_head *link;
> +	} stack[MEDIA_ENTITY_ENUM_MAX_DEPTH];

The best would be to use a pointer here, and allocate the exact
size only when using it.

> +
> +	DECLARE_BITMAP(entities, MEDIA_ENTITY_ENUM_MAX_ID);

Same here.

Ok, this patch is just moving things around, but some patch in
the series should be doing dynamic allocation of those.

> +	int top;
> +};
> +
>  struct media_pipeline {
>  };
>  
> @@ -437,16 +447,6 @@ static inline bool media_entity_enum_intersects(struct media_entity_enum *e,
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
