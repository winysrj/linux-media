Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:33679 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756047AbbHDM0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2015 08:26:15 -0400
Message-ID: <55C0AF5C.1050307@xs4all.nl>
Date: Tue, 04 Aug 2015 14:26:04 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH_RFC_v1 2/4] media: Add a common embeed struct for all
 media graph objects
References: <cover.1438687440.git.mchehab@osg.samsung.com> <3e0cf7e0a2feed17220b7580df2419d073fe8098.1438687440.git.mchehab@osg.samsung.com>
In-Reply-To: <3e0cf7e0a2feed17220b7580df2419d073fe8098.1438687440.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/04/2015 01:41 PM, Mauro Carvalho Chehab wrote:
> Due to the MC API proposed changes, we'll need to:
> 	- have an unique object ID for all graph objects;
> 	- be able to dynamically create/remove objects;
> 	- be able to group objects;
> 	- keep the object in memory until we stop use it.
> 
> Due to that, create a struct media_graph_obj and put there the
> common elements that all media objects will have in common.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 0c003d817493..faead169fe32 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -27,11 +27,54 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/media.h>
> +#include <linux/kref.h>
> +
> +/* Enums used internally at the media controller to represent graphs */
> +
> +/**
> + * enum media_graph_type - type of a graph element
> + *
> + * @MEDIA_GRAPH_ENTITY:		Identify a media entity
> + * @MEDIA_GRAPH_PAD:		Identify a media PAD
> + * @MEDIA_GRAPH_LINK:		Identify a media link
> + */
> +enum media_graph_type {
> +	MEDIA_GRAPH_ENTITY,
> +	MEDIA_GRAPH_PAD,
> +	MEDIA_GRAPH_LINK,
> +};
> +
> +
> +/* Structs to represent the objects that belong to a media graph */
> +
> +/**
> + * struct media_graph_obj - Define a graph object.
> + *
> + * @list:		List of media graph objects
> + * @obj_id:		Non-zero object ID identifier. The ID should be unique
> + *			inside a media_device
> + * @type:		Type of the graph object
> + * @mdev:		Media device that contains the object
> + * @kref:		pointer to struct kref, used to avoid destroying the
> + *			object before stopping using it
> + *
> + * All elements on the media graph should have this struct embedded
> + */
> +struct media_graph_obj {
> +	struct list_head	list;
> +	struct list_head	group;
> +	u32			obj_id;
> +	enum media_graph_type	type;

I think that using the top 8 bits of the ID for the type and the lower 24 bits for
the ID is more efficient. I proposed this in my RFC.

The IDs are still unique, but you don't need to keep track of the type since that's
encoded in the ID. You'd need an array of MAX_TYPE atomics to get per-type unique IDs,
but that's trivial. It also avoid the need for a connector flag since that would be
a distinct type (although using the same media_entity struct).

This is not a blocker for me, but I'd like to hear what others think.

Otherwise this patch series looks OK.

Regards,

	Hans

> +	struct media_device	*mdev;
> +	struct kref		kref;
> +};
> +
>  
>  struct media_pipeline {
>  };
>  
>  struct media_link {
> +	struct media_graph_obj			graph_obj;
>  	struct media_pad *source;	/* Source pad */
>  	struct media_pad *sink;		/* Sink pad  */
>  	struct media_link *reverse;	/* Link in the reverse direction */
> @@ -39,6 +82,7 @@ struct media_link {
>  };
>  
>  struct media_pad {
> +	struct media_graph_obj			graph_obj;
>  	struct media_entity *entity;	/* Entity this pad belongs to */
>  	u16 index;			/* Pad index in the entity pads array */
>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> @@ -61,6 +105,7 @@ struct media_entity_operations {
>  };
>  
>  struct media_entity {
> +	struct media_graph_obj			graph_obj;
>  	struct list_head list;
>  	struct media_device *parent;	/* Media device this entity belongs to*/
>  	u32 id;				/* Entity ID, unique in the parent media
> 
