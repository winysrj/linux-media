Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59877 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbbHYH3m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 03:29:42 -0400
Message-ID: <55DC1937.80606@xs4all.nl>
Date: Tue, 25 Aug 2015 09:28:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 18/44] [media] media: make media_link more generic
 to handle interace links
References: <cover.1440359643.git.mchehab@osg.samsung.com> <cec7a29d26c1abc95bd0df9ca6a92910ec1561ad.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cec7a29d26c1abc95bd0df9ca6a92910ec1561ad.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> By adding an union at media_link, we get for free a way to
> represent interface->entity links.
> 
> No need to change anything at the code, just at the internal
> header file.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 17bb5cbbd67d..f6e8fa801cf9 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -75,14 +75,20 @@ struct media_pipeline {
>  struct media_link {
>  	struct media_gobj graph_obj;
>  	struct list_head list;
> -	struct media_pad *source;	/* Source pad */
> -	struct media_pad *sink;		/* Sink pad  */
> +	union {
> +		struct media_gobj *port0;
> +		struct media_pad *source;
> +	};
> +	union {
> +		struct media_gobj *port1;
> +		struct media_pad *sink;
> +	};
>  	struct media_link *reverse;	/* Link in the reverse direction */
>  	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
>  };
>  
>  struct media_pad {
> -	struct media_gobj graph_obj;
> +	struct media_gobj graph_obj;	/* should be the first object */
>  	struct media_entity *entity;	/* Entity this pad belongs to */
>  	u16 index;			/* Pad index in the entity pads array */
>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> @@ -105,7 +111,7 @@ struct media_entity_operations {
>  };
>  
>  struct media_entity {
> -	struct media_gobj graph_obj;
> +	struct media_gobj graph_obj;	/* should be the first object */

Does adding these "/* should be the first object */" comments in media_entity
and media_pad belong to this patch? It doesn't seem to be related to the union
change.

I would also suggest that "/* must be first field in struct */" is a better
phrase.

Regards,

	Hans

>  	struct list_head list;
>  	const char *name;		/* Entity name */
>  	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
> @@ -119,7 +125,7 @@ struct media_entity {
>  	u16 num_backlinks;		/* Number of backlinks */
>  
>  	struct media_pad *pads;		/* Pads array (num_pads objects) */
> -	struct list_head links;		/* Links list */
> +	struct list_head links;		/* Pad-to-pad links list */
>  
>  	const struct media_entity_operations *ops;	/* Entity operations */
>  
> 

