Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53464 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbbJ1CKS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 22:10:18 -0400
Date: Wed, 28 Oct 2015 11:10:14 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 19/19] media: Rename MEDIA_ENTITY_ENUM_MAX_ID as
 MEDIA_ENTITY_ENUM_STACK_ALLOC
Message-ID: <20151028111014.20f99a43@concha.lan>
In-Reply-To: <1445900510-1398-20-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-20-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:50 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> The purpose of the macro has changed, rename it accordingly. It is not and
> should no longer be used in drivers directly, but only for the purpose for
> defining how many bits can be allocated from the stack for entity
> enumerations.

See my comments on patch 03/19.

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 2 +-
>  include/media/media-entity.h | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 137aa09d..feca976 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -222,7 +222,7 @@ void media_gobj_remove(struct media_gobj *gobj)
>   */
>  int __media_entity_enum_init(struct media_entity_enum *e, int idx_max)
>  {
> -	if (idx_max > MEDIA_ENTITY_ENUM_MAX_ID) {
> +	if (idx_max > MEDIA_ENTITY_ENUM_STACK_ALLOC) {
>  		e->e = kcalloc(DIV_ROUND_UP(idx_max, BITS_PER_LONG),
>  			       sizeof(long), GFP_KERNEL);
>  		if (!e->e)
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index cc01e08..5cab165 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -72,17 +72,17 @@ struct media_gobj {
>  };
>  
>  #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
> -#define MEDIA_ENTITY_ENUM_MAX_ID	64
> +#define MEDIA_ENTITY_ENUM_STACK_ALLOC	64
>  
>  /*
>   * The number of pads can't be bigger than the number of entities,
>   * as the worse-case scenario is to have one entity linked up to
> - * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
> + * MEDIA_ENTITY_ENUM_STACK_ALLOC - 1 entities.
>   */
> -#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
> +#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_STACK_ALLOC - 1)
>  
>  struct media_entity_enum {
> -	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_MAX_ID);
> +	DECLARE_BITMAP(__e, MEDIA_ENTITY_ENUM_STACK_ALLOC);
>  	unsigned long *e;
>  	int idx_max;
>  };


-- 

Cheers,
Mauro
