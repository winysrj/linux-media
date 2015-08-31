Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43841 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbbHaKpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 06:45:39 -0400
Message-ID: <55E4301A.4060505@xs4all.nl>
Date: Mon, 31 Aug 2015 12:44:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 21/55] [media] media: make media_link more generic
 to handle interace links
References: <cover.1440902901.git.mchehab@osg.samsung.com> <da1031f67533817988046d22a240b405fd30aebe.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <da1031f67533817988046d22a240b405fd30aebe.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> By adding an union at media_link, we get for free a way to
> represent interface->entity links.
> 
> No need to change anything at the code, just at the internal
> header file.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index bb89cedb0c40..b4923a24efd5 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -75,14 +75,20 @@ struct media_pipeline {
>  struct media_link {
>  	struct media_gobj graph_obj;
>  	struct list_head list;
> -	struct media_pad *source;	/* Source pad */
> -	struct media_pad *sink;		/* Sink pad  */
> +	union {
> +		struct media_gobj *gobj0;
> +		struct media_pad *source;
> +	};
> +	union {
> +		struct media_gobj *gobj1;
> +		struct media_pad *sink;
> +	};
>  	struct media_link *reverse;	/* Link in the reverse direction */
>  	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
>  };
>  
>  struct media_pad {
> -	struct media_gobj graph_obj;
> +	struct media_gobj graph_obj;	/* must be first field in struct */
>  	struct media_entity *entity;	/* Entity this pad belongs to */
>  	u16 index;			/* Pad index in the entity pads array */
>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> @@ -105,7 +111,7 @@ struct media_entity_operations {
>  };
>  
>  struct media_entity {
> -	struct media_gobj graph_obj;
> +	struct media_gobj graph_obj;	/* must be first field in struct */
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

