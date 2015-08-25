Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbbHYKAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 06:00:38 -0400
Date: Tue, 25 Aug 2015 07:00:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v7 14/44] [media] media: add functions to allow creating
 interfaces
Message-ID: <20150825070032.0e6f0ae3@recife.lan>
In-Reply-To: <20150825065742.0369f2ea@recife.lan>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
	<cf82882b9cb0ab84189c6e5e4f5526165714fa2e.1440359643.git.mchehab@osg.samsung.com>
	<55DC1C61.7090001@xs4all.nl>
	<20150825065742.0369f2ea@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Aug 2015 06:57:42 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Tue, 25 Aug 2015 09:42:25 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> > > Interfaces are different than entities: they represent a
> > > Kernel<->userspace interaction, while entities represent a
> > > piece of hardware/firmware/software that executes a function.
> > > 
> > > Let's distinguish them by creating a separate structure to
> > > store the interfaces.
> > > 
> > > Latter patches should change the existing drivers and logic
> > > to split the current interface embedded inside the entity
> > > structure (device nodes) into a separate object of the graph.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > > index a23c93369a04..d606e312786a 100644
> > > --- a/drivers/media/media-entity.c
> > > +++ b/drivers/media/media-entity.c
> > > @@ -44,11 +44,53 @@ static inline const char *gobj_type(enum media_gobj_type type)
> > >  		return "pad";
> > >  	case MEDIA_GRAPH_LINK:
> > >  		return "link";
> > > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > > +		return "intf_devnode";
> > >  	default:
> > >  		return "unknown";
> > >  	}
> > >  }
> > >  
> > > +static inline const char *intf_type(struct media_interface *intf)
> > > +{
> > > +	switch (intf->type) {
> > > +	case MEDIA_INTF_T_DVB_FE:
> > > +		return "frontend";
> > > +	case MEDIA_INTF_T_DVB_DEMUX:
> > > +		return "demux";
> > > +	case MEDIA_INTF_T_DVB_DVR:
> > > +		return "DVR";
> > > +	case MEDIA_INTF_T_DVB_CA:
> > > +		return  "CA";
> > > +	case MEDIA_INTF_T_DVB_NET:
> > > +		return "dvbnet";
> > > +	case MEDIA_INTF_T_V4L_VIDEO:
> > > +		return "video";
> > > +	case MEDIA_INTF_T_V4L_VBI:
> > > +		return "vbi";
> > > +	case MEDIA_INTF_T_V4L_RADIO:
> > > +		return "radio";
> > > +	case MEDIA_INTF_T_V4L_SUBDEV:
> > > +		return "v4l2_subdev";
> > > +	case MEDIA_INTF_T_V4L_SWRADIO:
> > > +		return "swradio";
> > > +	case MEDIA_INTF_T_ALSA_PCM_CAPTURE:
> > > +		return "pcm_capture";
> > > +	case MEDIA_INTF_T_ALSA_PCM_PLAYBACK:
> > > +		return "pcm_playback";
> > > +	case MEDIA_INTF_T_ALSA_CONTROL:
> > > +		return "alsa_control";
> > > +	case MEDIA_INTF_T_ALSA_COMPRESS:
> > > +		return "compress";
> > > +	case MEDIA_INTF_T_ALSA_RAWMIDI:
> > > +		return "rawmidi";
> > > +	case MEDIA_INTF_T_ALSA_HWDEP:
> > > +		return "hwdep";
> > > +	default:
> > > +		return "unknown_intf";
> > > +	}
> > > +};
> > > +
> > >  static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> > >  {
> > >  #if defined(DEBUG) || defined (CONFIG_DYNAMIC_DEBUG)
> > > @@ -84,6 +126,19 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
> > >  			"%s: id 0x%08x pad#%d: '%s':%d\n",
> > >  			event_name, gobj->id, media_localid(gobj),
> > >  			pad->entity->name, pad->index);
> > > +		break;
> > > +	}
> > > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > > +	{
> > > +		struct media_interface *intf = gobj_to_intf(gobj);
> > > +		struct media_intf_devnode *devnode = intf_to_devnode(intf);
> > > +
> > > +		dev_dbg(gobj->mdev->dev,
> > > +			"%s: id 0x%08x intf_devnode#%d: %s - major: %d, minor: %d\n",
> > > +			event_name, gobj->id, media_localid(gobj),
> > > +			intf_type(intf),
> > > +			devnode->major, devnode->minor);
> > > +		break;
> > >  	}
> > >  	}
> > >  #endif
> > > @@ -119,6 +174,9 @@ void media_gobj_init(struct media_device *mdev,
> > >  	case MEDIA_GRAPH_LINK:
> > >  		gobj->id = media_gobj_gen_id(type, ++mdev->link_id);
> > >  		break;
> > > +	case MEDIA_GRAPH_INTF_DEVNODE:
> > > +		gobj->id = media_gobj_gen_id(type, ++mdev->intf_devnode_id);
> > > +		break;
> > >  	}
> > >  	dev_dbg_obj(__func__, gobj);
> > >  }
> > > @@ -793,3 +851,41 @@ struct media_pad *media_entity_remote_pad(struct media_pad *pad)
> > >  
> > >  }
> > >  EXPORT_SYMBOL_GPL(media_entity_remote_pad);
> > > +
> > > +
> > > +/* Functions related to the media interface via device nodes */
> > > +
> > > +struct media_intf_devnode *media_devnode_create(struct media_device *mdev,
> > > +						u32 type, u32 flags,
> > > +						u32 major, u32 minor,
> > > +						gfp_t gfp_flags)
> > > +{
> > > +	struct media_intf_devnode *devnode;
> > > +	struct media_interface *intf;
> > > +
> > > +	devnode = kzalloc(sizeof(*devnode), gfp_flags);
> > > +	if (!devnode)
> > > +		return NULL;
> > > +
> > > +	intf = &devnode->intf;
> > > +
> > > +	intf->type = type;
> > > +	intf->flags = flags;
> > 
> > After looking at patch 20 I think you want to create a media_interface_init()
> > helper function to set type and flags and later (in patch 20) init the 'links'
> > list.
> > 
> > This initialization will be shared with e.g. network or sysfs interfaces, so
> > doing this in a helper function would make sense.
> 
> We could move the common stuff to a helper function, but I actually prefer
> to do that when we add other interface types. It will take some time
> until we get there, and the logic may change until then.
>
> See the comment
> I'm writing for patch 20.

Please ignore this. I misread your comment there.

I'll write a patch at the end of the series moving the common
interface init to a media_interface_init() helper function.

Regards,
Mauro
