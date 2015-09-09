Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46059 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753335AbbIIHej (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 03:34:39 -0400
Date: Wed, 9 Sep 2015 10:34:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating
 interfaces
Message-ID: <20150909073405.GJ3175@valkosipuli.retiisi.org.uk>
References: <510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com>
 <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, Sep 06, 2015 at 09:02:45AM -0300, Mauro Carvalho Chehab wrote:
> Interfaces are different than entities: they represent a
> Kernel<->userspace interaction, while entities represent a
> piece of hardware/firmware/software that executes a function.
> 
> Let's distinguish them by creating a separate structure to
> store the interfaces.
> 
> Later patches should change the existing drivers and logic
> to split the current interface embedded inside the entity
> structure (device nodes) into a separate object of the graph.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index a23c93369a04..dc679dfe8ade 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -44,11 +44,41 @@ static inline const char *gobj_type(enum media_gobj_type type)
>  		return "pad";
>  	case MEDIA_GRAPH_LINK:
>  		return "link";
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		return "intf-devnode";
>  	default:
>  		return "unknown";
>  	}
>  }
>  
> +static inline const char *intf_type(struct media_interface *intf)
> +{
> +	switch (intf->type) {
> +	case MEDIA_INTF_T_DVB_FE:
> +		return "frontend";
> +	case MEDIA_INTF_T_DVB_DEMUX:
> +		return "demux";
> +	case MEDIA_INTF_T_DVB_DVR:
> +		return "DVR";
> +	case MEDIA_INTF_T_DVB_CA:
> +		return  "CA";
> +	case MEDIA_INTF_T_DVB_NET:
> +		return "dvbnet";
> +	case MEDIA_INTF_T_V4L_VIDEO:
> +		return "video";
> +	case MEDIA_INTF_T_V4L_VBI:
> +		return "vbi";
> +	case MEDIA_INTF_T_V4L_RADIO:
> +		return "radio";
> +	case MEDIA_INTF_T_V4L_SUBDEV:
> +		return "v4l2-subdev";
> +	case MEDIA_INTF_T_V4L_SWRADIO:
> +		return "swradio";
> +	default:
> +		return "unknown-intf";
> +	}
> +};
> +
>  static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  {
>  #if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> @@ -84,6 +114,19 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  			"%s: id 0x%08x pad#%d: '%s':%d\n",
>  			event_name, gobj->id, media_localid(gobj),
>  			pad->entity->name, pad->index);
> +		break;
> +	}
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +	{
> +		struct media_interface *intf = gobj_to_intf(gobj);
> +		struct media_intf_devnode *devnode = intf_to_devnode(intf);
> +
> +		dev_dbg(gobj->mdev->dev,
> +			"%s: id 0x%08x intf_devnode#%d: %s - major: %d, minor: %d\n",
> +			event_name, gobj->id, media_localid(gobj),
> +			intf_type(intf),
> +			devnode->major, devnode->minor);
> +		break;
>  	}
>  	}
>  #endif
> @@ -119,6 +162,9 @@ void media_gobj_init(struct media_device *mdev,
>  	case MEDIA_GRAPH_LINK:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
>  		break;
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> +		break;
>  	}
>  	dev_dbg_obj(__func__, gobj);
>  }
> @@ -793,3 +839,40 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
>  
>  }
>  EXPORT_SYMBOL_GPL(media_entity_remote_pad);
> +
> +
> +/* Functions related to the media interface via device nodes */
> +
> +struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
> +						u32 type, u32 flags,
> +						u32 major, u32 minor,
> +						gfp_t gfp_flags)
> +{
> +	struct media_intf_devnode *devnode;
> +	struct media_interface *intf;
> +
> +	devnode = kzalloc(sizeof(*devnode), gfp_flags);

Do you think the user might want to specify something else then GFP_KERNEL
as gfp_flags? If not, I'd keep this internal to the function. It can also be
added later if needed.

> +	if (!devnode)
> +		return NULL;
> +
> +	intf = &devnode->intf;
> +
> +	intf->type = type;
> +	intf->flags = flags;
> +
> +	devnode->major = major;
> +	devnode->minor = minor;
> +
> +	media_gobj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
> +		       &devnode->intf.graph_obj);
> +
> +	return devnode;
> +}
> +EXPORT_SYMBOL_GPL(media_devnode_create);
> +
> +void media_devnode_remove(struct media_intf_devnode *devnode)
> +{
> +	media_gobj_remove(&devnode->intf.graph_obj);
> +	kfree(devnode);
> +}
> +EXPORT_SYMBOL_GPL(media_devnode_remove);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 05414e351f8e..3b14394d5701 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -44,6 +44,7 @@ struct device;
>   * @entity_id:	Unique ID used on the last entity registered
>   * @pad_id:	Unique ID used on the last pad registered
>   * @link_id:	Unique ID used on the last link registered
> + * @intf_devnode_id: Unique ID used on the last interface devnode registered

What's your plan with the graph object IDs? Now we have several ID spaces,
one for each object type. Should we export these to the user space, it would
have to come together with an object type, or make the IDs unique.

I think I'd favour a flat ID space for all objects; they are reported
separately by G_TOPOLOGY IOCTL so the user will gain the type information
with the object IDs anyway.

This way, if there's a need to pass the objects back to the kernel, just the
ID will be sufficient. Depending on how the API will develop in the future,
the kernel may continue to keep a single data structure of graph objects or
several data structures.

>   * @entities:	List of registered entities
>   * @lock:	Entities list lock
>   * @graph_mutex: Entities graph operation lock
> @@ -73,6 +74,7 @@ struct media_device {
>  	u32 entity_id;
>  	u32 pad_id;
>  	u32 link_id;
> +	u32 intf_devnode_id;
>  
>  	struct list_head entities;
>  
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 239c4ec30ef6..7df8836f4eef 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -36,11 +36,14 @@
>   * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>   * @MEDIA_GRAPH_PAD:		Identify a media pad
>   * @MEDIA_GRAPH_LINK:		Identify a media link
> + * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
> + *				a device node
>   */
>  enum media_gobj_type {
>  	MEDIA_GRAPH_ENTITY,
>  	MEDIA_GRAPH_PAD,
>  	MEDIA_GRAPH_LINK,
> +	MEDIA_GRAPH_INTF_DEVNODE,
>  };
>  
>  #define MEDIA_BITS_PER_TYPE		8
> @@ -141,6 +144,34 @@ struct media_entity {
>  	} info;
>  };
>  
> +/**
> + * struct media_intf_devnode - Define a Kernel API interface
> + *
> + * @graph_obj:		embedded graph object
> + * @type:		Type of the interface as defined at the
> + *			uapi/media/media.h header, e. g.
> + *			MEDIA_INTF_T_*
> + * @flags:		Interface flags as defined at uapi/media/media.h
> + */
> +struct media_interface {
> +	struct media_gobj		graph_obj;
> +	u32				type;
> +	u32				flags;
> +};
> +
> +/**
> + * struct media_intf_devnode - Define a Kernel API interface via a device node
> + *
> + * @intf:	embedded interface object
> + * @major:	Major number of a device node
> + * @minor:	Minor number of a device node
> + */
> +struct media_intf_devnode {
> +	struct media_interface		intf;
> +	u32				major;
> +	u32				minor;
> +};
> +
>  static inline u32 media_entity_type(struct media_entity *entity)
>  {
>  	return entity->type & MEDIA_ENT_TYPE_MASK;
> @@ -198,6 +229,18 @@ struct media_entity_graph {
>  #define gobj_to_link(gobj) \
>  		container_of(gobj, struct media_link, graph_obj)
>  
> +#define gobj_to_link(gobj) \
> +		container_of(gobj, struct media_link, graph_obj)

How about media_gobj_to_link() etc.?

> +
> +#define gobj_to_pad(gobj) \
> +		container_of(gobj, struct media_pad, graph_obj)
> +
> +#define gobj_to_intf(gobj) \
> +		container_of(gobj, struct media_interface, graph_obj)
> +
> +#define intf_to_devnode(intf) \
> +		container_of(intf, struct media_intf_devnode, intf)
> +
>  void media_gobj_init(struct media_device *mdev,
>  		    enum media_gobj_type type,
>  		    struct media_gobj *gobj);
> @@ -229,6 +272,11 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>  					     struct media_pipeline *pipe);
>  void media_entity_pipeline_stop(struct media_entity *entity);
>  
> +struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
> +						u32 type, u32 flags,
> +						u32 major, u32 minor,
> +						gfp_t gfp_flags);
> +void media_devnode_remove(struct media_intf_devnode *devnode);
>  #define media_entity_call(entity, operation, args...)			\
>  	(((entity)->ops && (entity)->ops->operation) ?			\
>  	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
