Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33400 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbbHYHKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 03:10:05 -0400
Message-ID: <55DC149E.2000202@xs4all.nl>
Date: Tue, 25 Aug 2015 09:09:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v7 14/44] [media] media: add functions to allow creating
 interfaces
References: <cover.1440359643.git.mchehab@osg.samsung.com> <cf82882b9cb0ab84189c6e5e4f5526165714fa2e.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cf82882b9cb0ab84189c6e5e4f5526165714fa2e.1440359643.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> Interfaces are different than entities: they represent a
> Kernel<->userspace interaction, while entities represent a
> piece of hardware/firmware/software that executes a function.
> 
> Let's distinguish them by creating a separate structure to
> store the interfaces.
> 
> Latter patches should change the existing drivers and logic

s/Latter/later/

> to split the current interface embedded inside the entity
> structure (device nodes) into a separate object of the graph.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index a23c93369a04..d606e312786a 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -44,11 +44,53 @@ static inline const char *gobj_type(enum media_gobj_type type)
>  		return "pad";
>  	case MEDIA_GRAPH_LINK:
>  		return "link";
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		return "intf_devnode";

Does this mean that you are planning different types for non-devnode interfaces
like a network interface?

I'm not necessarily opposed, but I would like to know your reasoning for making
this a type in the media object ID instead of part of the media_interface type
field.

It might become clearer to me as I work my way through this patch series.

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
> +		return "v4l2_subdev";
> +	case MEDIA_INTF_T_V4L_SWRADIO:
> +		return "swradio";
> +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
> +		return "pcm_capture";
> +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
> +		return "pcm_playback";
> +	case MEDIA_INTF_T_ALSA_CONTROL:
> +		return "alsa_control";

I prefer - over _, but that's a personal preference.

> +	case MEDIA_INTF_T_ALSA_COMPRESS:
> +		return "compress";
> +	case MEDIA_INTF_T_ALSA_RAWMIDI:
> +		return "rawmidi";
> +	case MEDIA_INTF_T_ALSA_HWDEP:
> +		return "hwdep";
> +	default:
> +		return "unknown_intf";
> +	}
> +};
> +
>  static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  {
>  #if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> @@ -84,6 +126,19 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
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
> @@ -119,6 +174,9 @@ void media_gobj_init(struct media_device *mdev,
>  	case MEDIA_GRAPH_LINK:
>  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
>  		break;
> +	case MEDIA_GRAPH_INTF_DEVNODE:
> +		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> +		break;
>  	}
>  	dev_dbg_obj(__func__, gobj);
>  }
> @@ -793,3 +851,41 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
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
> +
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 05414e351f8e..3b14394d5701 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -44,6 +44,7 @@ struct device;
>   * @entity_id:	Unique ID used on the last entity registered
>   * @pad_id:	Unique ID used on the last pad registered
>   * @link_id:	Unique ID used on the last link registered
> + * @intf_devnode_id: Unique ID used on the last interface devnode registered
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
> index 239c4ec30ef6..ddd8d610c357 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -36,11 +36,14 @@
>   * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>   * @MEDIA_GRAPH_PAD:		Identify a media pad
>   * @MEDIA_GRAPH_LINK:		Identify a media link
> + * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
> + * 				a device node
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
> 

Regards,

	Hans
