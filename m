Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35085 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbbIIKAQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 06:00:16 -0400
Date: Wed, 9 Sep 2015 07:00:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 14/55] [media] media: add functions to allow creating
 interfaces
Message-ID: <20150909070010.519e48ec@recife.lan>
In-Reply-To: <20150909073405.GJ3175@valkosipuli.retiisi.org.uk>
References: <510dc75bdef5462b55215ba8aed120b1b7c4997d.1440902901.git.mchehab@osg.samsung.com>
	<ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
	<20150909073405.GJ3175@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Sep 2015 10:34:05 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Sun, Sep 06, 2015 at 09:02:45AM -0300, Mauro Carvalho Chehab wrote:
> > Interfaces are different than entities: they represent a
> > Kernel<->userspace interaction, while entities represent a
> > piece of hardware/firmware/software that executes a function.
> > 
> > Let's distinguish them by creating a separate structure to
> > store the interfaces.
> > 
> > Later patches should change the existing drivers and logic
> > to split the current interface embedded inside the entity
> > structure (device nodes) into a separate object of the graph.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index a23c93369a04..dc679dfe8ade 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -44,11 +44,41 @@ static inline const char *gobj_type(enum media_gobj_type type)
> >  		return "pad";
> >  	case MEDIA_GRAPH_LINK:
> >  		return "link";
> > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > +		return "intf-devnode";
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
> 
> Do you think the user might want to specify something else then GFP_KERNEL
> as gfp_flags? If not, I'd keep this internal to the function. It can also be
> added later if needed.

Yeah, hardly interfaces would need something different than GFP_KERNEL.

I'll change it.

> 
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
> 
> What's your plan with the graph object IDs? Now we have several ID spaces,
> one for each object type. Should we export these to the user space, it would
> have to come together with an object type, or make the IDs unique.

The IDs are always unique, as they're created with 8 bits for type and
24 bits for the per-range ID.

> I think I'd favour a flat ID space for all objects; they are reported
> separately by G_TOPOLOGY IOCTL so the user will gain the type information
> with the object IDs anyway.

Actually, we still need to pass the type somehow to userspace, as we're
actually grouping different object ID types at G_TOPOLOGY IOCTL:

- we're grouping different interface types together (currently, only
  devnode interfaces are there, but we'll add sysfs interfaces and
  maybe more in the future);

- we're passing data and control links together;

- we're passing connectors and entities together (ok, I used a flag
  for connectors, but Hans RFC proposed to use a different type for
  connectors).

> This way, if there's a need to pass the objects back to the kernel, just the
> ID will be sufficient. Depending on how the API will develop in the future,
> the kernel may continue to keep a single data structure of graph objects or
> several data structures.

As I explained earlier, an unique object ID range would break the
graph traversal algorithm at the Kernelspace. Several drivers rely on
the fact that the entities ID will always be below 32. The graph
traversal algorithm assumes that the entity ID will always be below
64. I won't doubt that userspace would also have the same assumption.

So, at least the entity ID should have a separate range than the other
objects.

So, we actually have two alternatives only:

1) two ranges:
	entity_id;
	non_entities_id;

I think it is really ugly to call it as "non_entities_id" and I can't
find any nice name for such range.

2) one range per type, as proposed.

The drawback of one range per type is that mdev will have 4 ranges, so
it will be spending 8 more bytes. It is not much, as we have just one
media_device struct per machine.

There are some advantages of using one range per type: all object
types will start on 1 and will have sequencial numbers. That makes
easier for humans to read. See:

$ ./mc_nextgen_test -i
interface intf_devnode#1: video /dev/video0
interface intf_devnode#2: vbi /dev/vbi0
interface intf_devnode#3: v4l2-subdev /dev/v4l-subdev0
interface intf_devnode#4: frontend /dev/dvb/adapter0/frontend0
interface intf_devnode#5: demux /dev/dvb/adapter0/demux0
interface intf_devnode#6: DVR /dev/dvb/adapter0/dvr0
interface intf_devnode#7: dvbnet /dev/dvb/adapter0/net0

$ ./mc_nextgen_test -e
entity entity#1: 'ATV decoder' au8522 5-0047, 3 pad(s), 1 sink(s), 2 source(s)
entity entity#2: 'tuner' Xceive XC5000, 2 pad(s), 1 sink(s), 1 source(s)
entity entity#3: 'RF connector' Television, 1 pad(s), 1 source(s)
entity entity#4: 'Composite connector' Composite, 1 pad(s), 1 source(s)
entity entity#5: 'S-Video connector' S-Video, 1 pad(s), 1 source(s)
entity entity#6: 'I/O' au0828a video, 1 pad(s), 1 sink(s)
entity entity#7: 'I/O' au0828a vbi, 1 pad(s), 1 sink(s)
entity entity#8: 'DTV demod' Auvitek AU8522 QAM/8VSB Frontend, 2 pad(s), 1 sink(s), 1 source(s)
entity entity#9: 'I/O' demux-tsout #0, 1 pad(s), 1 sink(s)
entity entity#10: 'I/O' demux-tsout #1, 1 pad(s), 1 sink(s)
entity entity#11: 'I/O' demux-tsout #2, 1 pad(s), 1 sink(s)
entity entity#12: 'I/O' demux-tsout #3, 1 pad(s), 1 sink(s)
entity entity#13: 'I/O' demux-tsout #4, 1 pad(s), 1 sink(s)
entity entity#14: 'MPEG-TS demux' dvb-demux, 6 pad(s), 1 sink(s), 5 source(s)
entity entity#15: 'I/O' dvr-tsout #0, 1 pad(s), 1 sink(s)
entity entity#16: 'I/O' dvr-tsout #1, 1 pad(s), 1 sink(s)
entity entity#17: 'I/O' dvr-tsout #2, 1 pad(s), 1 sink(s)
entity entity#18: 'I/O' dvr-tsout #3, 1 pad(s), 1 sink(s)
entity entity#19: 'I/O' dvr-tsout #4, 1 pad(s), 1 sink(s)

 $ ./mc_nextgen_test -l -I
interface link link#1: intf_devnode#1 <=> entity#6 [ENABLED]
interface link link#2: intf_devnode#2 <=> entity#7 [ENABLED]
interface link link#3: intf_devnode#3 <=> entity#2 [ENABLED]
interface link link#4: intf_devnode#4 <=> entity#8 [ENABLED]
interface link link#5: intf_devnode#5 <=> entity#14 [ENABLED]
data link link#6: pad#5 => pad#11 [ENABLED]
data link link#8: pad#12 => pad#18 [ENABLED]
data link link#10: pad#19 => pad#13
data link link#12: pad#20 => pad#14
data link link#14: pad#21 => pad#15
data link link#16: pad#22 => pad#16
data link link#18: pad#23 => pad#17
data link link#20: pad#19 => pad#24
data link link#22: pad#20 => pad#25
data link link#24: pad#21 => pad#26
data link link#26: pad#22 => pad#27
data link link#28: pad#23 => pad#28
interface link link#30: intf_devnode#4 <=> entity#2 [ENABLED]
interface link link#31: intf_devnode#5 <=> entity#9 [ENABLED]
interface link link#32: intf_devnode#5 <=> entity#10 [ENABLED]
interface link link#33: intf_devnode#5 <=> entity#11 [ENABLED]
interface link link#34: intf_devnode#5 <=> entity#12 [ENABLED]
interface link link#35: intf_devnode#5 <=> entity#13 [ENABLED]
interface link link#36: intf_devnode#6 <=> entity#15 [ENABLED]
interface link link#37: intf_devnode#6 <=> entity#16 [ENABLED]
interface link link#38: intf_devnode#6 <=> entity#17 [ENABLED]
interface link link#39: intf_devnode#6 <=> entity#18 [ENABLED]
interface link link#40: intf_devnode#6 <=> entity#19 [ENABLED]
data link link#41: pad#5 => pad#1 [ENABLED]
data link link#43: pad#2 => pad#9 [ENABLED]
data link link#45: pad#3 => pad#10 [ENABLED]
data link link#47: pad#6 => pad#4 [ENABLED]
data link link#49: pad#7 => pad#1
data link link#51: pad#8 => pad#1

That, IMHO, makes easier for humans to read and if they need, for example,
to refer to an interface, use intf#5.

Anyway, I wouldn't mind to change to two ranges, if this is the only
way for us to move forward.

> 
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
> 
> How about media_gobj_to_link() etc.?

I already answered that to a previous e-mail series:

If you do a check at the global defines with:

$ git grep -B1 container_of include/

you'll see that there are two namespaces used for those container_of
macros:
	1) to_bar
	2) foo_to_bar

Those defines are meant to be short, to avoid needing to break long
lines whenever those macros are used.

(1) is used when the origin type is always the same.
(2) is used when you might have more than one origin type, as we'll
    have on interfaces.

I opted for the longest form (2).

Adding "media_" on those macros would require to re-check all lines where
those macros are used, breaking several of them into two lines for no
good reason, as the only symbols that usually have the "_to_" sub-string
inside Kernel are those container_of macros.

I really hate typing long names. Ok, I do when needed, but this is not
needed here: there's no namespace conflict. I checked, as everything
compiled fine both with allyesconfig/allmodconfig and building for all
arm sub-arch that have media drivers.

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
> 
