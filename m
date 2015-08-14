Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42852 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754158AbbHNNJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 09:09:06 -0400
Date: Fri, 14 Aug 2015 16:08:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v3 02/16] media: Add a common embeed struct for all
 media graph objects
Message-ID: <20150814130833.GD19840@valkosipuli.retiisi.org.uk>
References: <cover.1439410053.git.mchehab@osg.samsung.com>
 <10ca5f9841d48380defba6ada5f6390b42d73aa6.1439410053.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10ca5f9841d48380defba6ada5f6390b42d73aa6.1439410053.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patchset!

On Wed, Aug 12, 2015 at 05:14:46PM -0300, Mauro Carvalho Chehab wrote:
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
> index 0c003d817493..051aa3f8bbfe 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -28,10 +28,50 @@
>  #include <linux/list.h>
>  #include <linux/media.h>
>  
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
> + *			object before stopping using it
> + *
> + * All elements on the media graph should have this struct embedded
> + */
> +struct media_graph_obj {
> +	struct list_head	list;
> +	struct list_head	group;

What's group for?

> +	u32			obj_id;

I'd just call this "id".

> +	enum media_graph_type	type;
> +	struct media_device	*mdev;
> +};
> +
> +
>  struct media_pipeline {
>  };
>  
>  struct media_link {
> +	struct media_graph_obj			graph_obj;
>  	struct media_pad *source;	/* Source pad */
>  	struct media_pad *sink;		/* Sink pad  */
>  	struct media_link *reverse;	/* Link in the reverse direction */
> @@ -39,6 +79,7 @@ struct media_link {
>  };
>  
>  struct media_pad {
> +	struct media_graph_obj			graph_obj;
>  	struct media_entity *entity;	/* Entity this pad belongs to */
>  	u16 index;			/* Pad index in the entity pads array */
>  	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> @@ -61,6 +102,7 @@ struct media_entity_operations {
>  };
>  
>  struct media_entity {
> +	struct media_graph_obj			graph_obj;
>  	struct list_head list;
>  	struct media_device *parent;	/* Media device this entity belongs to*/
>  	u32 id;				/* Entity ID, unique in the parent media

Will entity id be different from the media_graph_obj obj_id of the object?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
