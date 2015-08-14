Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47206 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940AbbHNVZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 17:25:16 -0400
Date: Sat, 15 Aug 2015 00:25:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 3/6] media: add a common struct to be embed on media
 graph objects
Message-ID: <20150814212514.GB28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
 <02ddd65348f36f5499acd338e692397baf92b045.1439563682.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02ddd65348f36f5499acd338e692397baf92b045.1439563682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 14, 2015 at 11:56:40AM -0300, Mauro Carvalho Chehab wrote:
> Due to the MC API proposed changes, we'll need to have an unique
> object ID for all graph objects, and have some shared fields
> that will be common on all media graph objects.
> 
> Right now, the only common object is the object ID, but other
> fields will be added latter on.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index b8102bda664d..046f1fe40b50 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -27,6 +27,39 @@
>  #include <media/media-device.h>
>  
>  /**
> + *  graph_obj_init - Initialize a graph object
> + *
> + * @mdev:	Pointer to the media_device that contains the object
> + * @type:	Type of the object
> + * @gobj:	Pointer to the object
> + *
> + * This routine initializes the embedded struct media_graph_obj inside a
> + * media graph object. It is called automatically if media_*_create()
> + * calls are used. However, if the object (entity, link, pad, interface)
> + * is embedded on some other object, this function should be called before
> + * registering the object at the media controller.
> + */
> +void graph_obj_init(struct media_device *mdev,
> +			   enum media_graph_type type,
> +			   struct media_graph_obj *gobj)
> +{
> +	/* An unique object ID will be provided on next patches */
> +	gobj->id = type << 24;

Ugh. This will mean the object IDs are going to be huge to begin with,
ending up being a nuisance to work with as you often write them by hand. Do
we win anything by doing so?

> +}
> +
> +/**
> + *  graph_obj_remove - Stop using a graph object on a media device
> + *
> + * @graph_obj:	Pointer to the object
> + *
> + * This should be called at media_device_unregister_*() routines
> + */
> +void graph_obj_remove(struct media_graph_obj *gobj)
> +{
> +	/* For now, nothing to do */
> +}
> +
> +/**
>   * media_entity_init - Initialize a media entity
>   *
>   * @num_pads: Total number of sink and source pads.
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 478d5cd56be9..58938bb980fe 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -28,6 +28,33 @@
>  #include <linux/list.h>
>  #include <linux/media.h>
>  
> +/* Enums used internally at the media controller to represent graphs */
> +
> +/**
> + * enum media_graph_type - type of a graph element
> + *
> + */
> +enum media_graph_type {
> +	 /* FIXME: add the types here, as we embeed media_graph_obj */
> +	MEDIA_GRAPH_NONE
> +};
> +
> +
> +/* Structs to represent the objects that belong to a media graph */
> +
> +/**
> + * struct media_graph_obj - Define a graph object.
> + *
> + * @id:		Non-zero object ID identifier. The ID should be unique
> + *		inside a media_device
> + *
> + * All elements on the media graph should have this struct embedded
> + */
> +struct media_graph_obj {
> +	u32			id;
> +};
> +
> +
>  struct media_pipeline {
>  };
>  
> @@ -128,6 +155,14 @@ struct media_entity_graph {
>  
>  #define entity_id(entity) ((entity)->id)
>  
> +#define gobj_to_entity(gobj) \
> +		container_of(gobj, struct media_entity, graph_obj)
> +
> +void graph_obj_init(struct media_device *mdev,
> +		    enum media_graph_type type,
> +		    struct media_graph_obj *gobj);
> +void graph_obj_remove(struct media_graph_obj *gobj);
> +
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		struct media_pad *pads);
>  void media_entity_cleanup(struct media_entity *entity);

My previous comment on the naming applies on this patch as well. Please do
maintain the common prefix.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
