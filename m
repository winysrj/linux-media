Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33063 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbbHaKtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 06:49:14 -0400
Date: Mon, 31 Aug 2015 07:49:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating
 interfaces
Message-ID: <20150831074909.3ff468b6@recife.lan>
In-Reply-To: <55E42A7B.5040505@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com>
	<55E42A7B.5040505@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 12:20:43 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> > Interfaces are different than entities: they represent a
> > Kernel<->userspace interaction, while entities represent a
> > piece of hardware/firmware/software that executes a function.
> > 
> > Let's distinguish them by creating a separate structure to
> > store the interfaces.
> > 
> > Latter patches should change the existing drivers and logic
> 
> s/Latter/Later/
> 
> FYI: you almost never use 'latter' in English texts. The only common use
> of 'latter' is in the phrase "the latter of two options" where 'latter' means
> 'second'.

I did a global replace on the patches, but perhaps the regex
expression I used didn't got this one.

> 
> > to split the current interface embedded inside the entity
> > structure (device nodes) into a separate object of the graph.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a23c93369a04..583666e2cc25 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -44,11 +44,41 @@ static inline const char *gobj_type(enum media_gobj_type type)
> >  		return "pad";
> >  	case MEDIA_GRAPH_LINK:
> >  		return "link";
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		return "intf_devnode";
> 
> You use '-' below for 'v4l-subdev' and 'unknown-intf', so I think this too should
> use '-'. My opinion though.

Gah, forgot this one ;)

> 
> It's a nitpick, so I give my Ack anyway:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Regards,
> 
> 	Hans
> 
> >  	default:
> >  		return "unknown";
> >  	}
> >  }
> >  
> > +static inline const char *intf_type(struct media_interface *intf)
> > +{
> > +	switch (intf->type) {
> > +	case MEDIA_INTF_T_DVB_FE:
> > +		return "frontend";
> > +	case MEDIA_INTF_T_DVB_DEMUX:
> > +		return "demux";
> > +	case MEDIA_INTF_T_DVB_DVR:
> > +		return "DVR";
> > +	case MEDIA_INTF_T_DVB_CA:
> > +		return  "CA";
> > +	case MEDIA_INTF_T_DVB_NET:
> > +		return "dvbnet";
> > +	case MEDIA_INTF_T_V4L_VIDEO:
> > +		return "video";
> > +	case MEDIA_INTF_T_V4L_VBI:
> > +		return "vbi";
> > +	case MEDIA_INTF_T_V4L_RADIO:
> > +		return "radio";
> > +	case MEDIA_INTF_T_V4L_SUBDEV:
> > +		return "v4l2-subdev";
> > +	case MEDIA_INTF_T_V4L_SWRADIO:
> > +		return "swradio";
> > +	default:
> > +		return "unknown-intf";
> > +	}
> > +};
> > +
> >  static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> >  {
> >  #if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> > @@ -84,6 +114,19 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> >  			"%s: id 0x%08x pad#%d: '%s':%d\n",
> >  			event_name, gobj->id, media_localid(gobj),
> >  			pad->entity->name, pad->index);
> > +		break;
> > +	}
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +	{
> > +		struct media_interface *intf = gobj_to_intf(gobj);
> > +		struct media_intf_devnode *devnode = intf_to_devnode(intf);
> > +
> > +		dev_dbg(gobj->mdev->dev,
> > +			"%s: id 0x%08x intf_devnode#%d: %s - major: %d, minor: %d\n",
> > +			event_name, gobj->id, media_localid(gobj),
> > +			intf_type(intf),
> > +			devnode->major, devnode->minor);
> > +		break;
> >  	}
> >  	}
> >  #endif
> > @@ -119,6 +162,9 @@ void media_gobj_init(struct media_device *mdev,
> >  	case MEDIA_GRAPH_LINK:
> >  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> >  		break;
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> > +		break;
> >  	}
> >  	dev_dbg_obj(__func__, gobj);
> >  }
> > @@ -793,3 +839,40 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
> >  
> >  }
> >  EXPORT_SYMBOL_GPL(media_entity_remote_pad);
> > +
> > +
> > +/* Functions related to the media interface via device nodes */
> > +
> > +struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
> > +						u32 type, u32 flags,
> > +						u32 major, u32 minor,
> > +						gfp_t gfp_flags)
> > +{
> > +	struct media_intf_devnode *devnode;
> > +	struct media_interface *intf;
> > +
> > +	devnode = kzalloc(sizeof(*devnode), gfp_flags);
> > +	if (!devnode)
> > +		return NULL;
> > +
> > +	intf = &devnode->intf;
> > +
> > +	intf->type = type;
> > +	intf->flags = flags;
> > +
> > +	devnode->major = major;
> > +	devnode->minor = minor;
> > +
> > +	media_gobj_init(mdev, MEDIA_GRAPH_INTF_DEVNODE,
> > +		       &devnode->intf.graph_obj);
> > +
> > +	return devnode;
> > +}
> > +EXPORT_SYMBOL_GPL(media_devnode_create);
> > +
> > +void media_devnode_remove(struct media_intf_devnode *devnode)
> > +{
> > +	media_gobj_remove(&devnode->intf.graph_obj);
> > +	kfree(devnode);
> > +}
> > +EXPORT_SYMBOL_GPL(media_devnode_remove);
> > diff --git a/include/media/media-device.h b/include/media/media-device.h
> > index 05414e351f8e..3b14394d5701 100644
> > --- a/include/media/media-device.h
> > +++ b/include/media/media-device.h
> > @@ -44,6 +44,7 @@ struct device;
> >   * @entity_id:	Unique ID used on the last entity registered
> >   * @pad_id:	Unique ID used on the last pad registered
> >   * @link_id:	Unique ID used on the last link registered
> > + * @intf_devnode_id: Unique ID used on the last interface devnode registered
> >   * @entities:	List of registered entities
> >   * @lock:	Entities list lock
> >   * @graph_mutex: Entities graph operation lock
> > @@ -73,6 +74,7 @@ struct media_device {
> >  	u32 entity_id;
> >  	u32 pad_id;
> >  	u32 link_id;
> > +	u32 intf_devnode_id;
> >  
> >  	struct list_head entities;
> >  
> > diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> > index 239c4ec30ef6..7df8836f4eef 100644
> > --- a/include/media/media-entity.h
> > +++ b/include/media/media-entity.h
> > @@ -36,11 +36,14 @@
> >   * @MEDIA_GRAPH_ENTITY:		Identify a media entity
> >   * @MEDIA_GRAPH_PAD:		Identify a media pad
> >   * @MEDIA_GRAPH_LINK:		Identify a media link
> > + * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
> > + *				a device node
> >   */
> >  enum media_gobj_type {
> >  	MEDIA_GRAPH_ENTITY,
> >  	MEDIA_GRAPH_PAD,
> >  	MEDIA_GRAPH_LINK,
> > +	MEDIA_GRAPH_INTF_DEVNODE,
> >  };
> >  
> >  #define MEDIA_BITS_PER_TYPE		8
> > @@ -141,6 +144,34 @@ struct media_entity {
> >  	} info;
> >  };
> >  
> > +/**
> > + * struct media_intf_devnode - Define a Kernel API interface
> > + *
> > + * @graph_obj:		embedded graph object
> > + * @type:		Type of the interface as defined at the
> > + *			uapi/media/media.h header, e. g.
> > + *			MEDIA_INTF_T_*
> > + * @flags:		Interface flags as defined at uapi/media/media.h
> > + */
> > +struct media_interface {
> > +	struct media_gobj		graph_obj;
> > +	u32				type;
> > +	u32				flags;
> > +};
> > +
> > +/**
> > + * struct media_intf_devnode - Define a Kernel API interface via a device node
> > + *
> > + * @intf:	embedded interface object
> > + * @major:	Major number of a device node
> > + * @minor:	Minor number of a device node
> > + */
> > +struct media_intf_devnode {
> > +	struct media_interface		intf;
> > +	u32				major;
> > +	u32				minor;
> > +};
> > +
> >  static inline u32 media_entity_type(struct media_entity *entity)
> >  {
> >  	return entity->type & MEDIA_ENT_TYPE_MASK;
> > @@ -198,6 +229,18 @@ struct media_entity_graph {
> >  #define gobj_to_link(gobj) \
> >  		container_of(gobj, struct media_link, graph_obj)
> >  
> > +#define gobj_to_link(gobj) \
> > +		container_of(gobj, struct media_link, graph_obj)
> > +
> > +#define gobj_to_pad(gobj) \
> > +		container_of(gobj, struct media_pad, graph_obj)
> > +
> > +#define gobj_to_intf(gobj) \
> > +		container_of(gobj, struct media_interface, graph_obj)
> > +
> > +#define intf_to_devnode(intf) \
> > +		container_of(intf, struct media_intf_devnode, intf)
> > +
> >  void media_gobj_init(struct media_device *mdev,
> >  		    enum media_gobj_type type,
> >  		    struct media_gobj *gobj);
> > @@ -229,6 +272,11 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
> >  					     struct media_pipeline *pipe);
> >  void media_entity_pipeline_stop(struct media_entity *entity);
> >  
> > +struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
> > +						u32 type, u32 flags,
> > +						u32 major, u32 minor,
> > +						gfp_t gfp_flags);
> > +void media_devnode_remove(struct media_intf_devnode *devnode);
> >  #define media_entity_call(entity, operation, args...)			\
> >  	(((entity)->ops && (entity)->ops->operation) ?			\
> >  	 (entity)->ops->operation((entity) , ##args) : -ENOIOCTLCMD)
> > 
> 
