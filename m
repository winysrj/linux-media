Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59440 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbbHXJSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 05:18:17 -0400
Date: Mon, 24 Aug 2015 06:18:11 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v6 3/8] [media] media: use media_gobj inside entities
Message-ID: <20150824061811.13d5358c@recife.lan>
In-Reply-To: <1912893.Q3rk0pZ5kO@avalon>
References: <cover.1439981515.git.mchehab@osg.samsung.com>
	<110787800.OoCXmhqZpK@avalon>
	<20150821180131.701b509e@recife.lan>
	<1912893.Q3rk0pZ5kO@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 22 Aug 2015 01:47:37 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Friday 21 August 2015 18:01:31 Mauro Carvalho Chehab wrote:
> > Em Fri, 21 Aug 2015 20:51:10 +0300 Laurent Pinchart escreveu:
> > > On Friday 21 August 2015 07:09:44 Mauro Carvalho Chehab wrote:
> > >> Em Fri, 21 Aug 2015 04:10:03 +0300 Laurent Pinchart escreveu:
> > >>> On Wednesday 19 August 2015 08:01:50 Mauro Carvalho Chehab wrote:
> > >>>> As entities are graph elements, let's embed media_gobj
> > >>>> on it. That ensures an unique ID for entities that can be
> > >>>> global along the entire media controller.
> > >>>> 
> > >>>> For now, we'll keep the already existing entity ID. Such
> > >>>> field need to be dropped at some point, but for now, let's
> > >>>> not do this, to avoid needing to review all drivers and
> > >>>> the userspace apps.
> > >>>> 
> > >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > >>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >>>> 
> > >>>> diff --git a/drivers/media/media-device.c
> > >>>> b/drivers/media/media-device.c
> > >>>> index e429605ca2c3..81d6a130efef 100644
> > >>>> --- a/drivers/media/media-device.c
> > >>>> +++ b/drivers/media/media-device.c
> > >>>> @@ -379,7 +379,6 @@ int __must_check __media_device_register(struct
> > >>>> media_device *mdev,
> > >>>> 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
> > >>>>  		return -EINVAL;
> > >>>> 
> > >>>> -	mdev->entity_id = 1;
> > >>>>  	INIT_LIST_HEAD(&mdev->entities);
> > >>>>  	spin_lock_init(&mdev->lock);
> > >>>>  	mutex_init(&mdev->graph_mutex);
> > >>>> @@ -433,10 +432,8 @@ int __must_check 
> > >>>> media_device_register_entity(struct media_device *mdev,
> > >>>> 
> > >>>> 	entity->parent = mdev;
> > >>>> 	
> > >>>>  	spin_lock(&mdev->lock);
> > >>>> 
> > >>>> -	if (entity->id == 0)
> > >>>> -		entity->id = mdev->entity_id++;
> > >>>> -	else
> > >>>> -		mdev->entity_id = max(entity->id + 1, mdev->entity_id);
> > >>>> +	/* Initialize media_gobj embedded at the entity */
> > >>>> +	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
> > >>> 
> > >>> Graph object initialization should be moved to media_entity_init() to
> > >>> keep initialization separate from registration.
> > >> 
> > >> Won't work. I tried. My first RFC patches were doing that.
> > >> 
> > >> The problem is that media_entity_init() is currently called too early
> > >> at the V4L2 drivers, before having mdev assigned.
> > > 
> > > That looks like a problem that should be fixed in the drivers then. The
> > > initialization of media devices and entities hasn't been thought of
> > > correctly, let's not carry mistakes forward.
> > 
> > In this particular case, calling media_gobj_init() during
> > media_entity_register() won't cause any troubles, and moving it latter
> > to media_entity_init() is a two lines patch, once drivers got fixed
> > by the drivers maintainers.
> 
> It's the "once drivers got fixed by the drivers maintainers" that worries me. 
> We all know it unfortunately doesn't happen by itself, and I believe it will 
> become more and more difficult as time goes by and more drivers use the MC 
> framework. We're trying to refactor, clean up and extend MC, both in-kernel 
> and towards userspace, to correct design and implementation mistakes. I'm 
> worried that we'll make different but similarly painful mistakes if we don't 
> take a bit of time to do things properly now. And while it will require a 
> couple more patches, I don't think we're looking at months of work either.
> 
> It might be that assigning an ID to objects can only be done at at 
> registration time, especially for standalone subdev drivers (I'm thinking 
> about the I2C camera sensors in particular). Still, calling media_gobj_init() 
> in media_device_register_entity() doesn't sound right. Maybe the solution is 
> to use media_gobj_init() for init-time initialization, and creating a 
> media_gobj_assign_id() (or similarly-named) function to call at registration 
> time. What I'd really like to see is clear explicit rules regarding how 
> init/cleanup and register/unregister interact and how they should be used by 
> drivers. The current mess is partly caused by not having thought this out 
> properly to start with.

See the latest patch series, as it now has the big picture. What
media_gobj_init() is meant to be (and it does) is to register a graph
object at the media device. This can only be done if mdev is known.
And media_gobj_remove() does the opposite.

Ok, perhaps we can rename it to media_gobj_register() and 
media_gobj_unregister(), but the right place for it to be called
is when the object is ready to be registered, and not before.

> 
> I also have a feeling that we'll realize changes are required when 
> implementing support for dynamic changes.

You're probably right here: we'll likely need to change the drivers
for them to create things only when the media_device is known, and
splitting entity creation from pads creation.

> 
> > >> Also, objects without PADs don't call media_entity_init(). At long
> > >> term, this function may even disappear, as it only exists today to
> > >> allocate arrays for pads/links. If we get rid of the pads array, it
> > >> will make no sense to keep it.
> > > 
> > > I wouldn't do that, as if we later add a field to media_entity that
> > > requires an initialization function to be called we would need to go and
> > > patch all the code that instantiates media_entity to add init calls. I'd
> > > prefer keeping the media_entity_init function even if all it does is call
> > > media_gobj_init.
> >
> > OK.
> > 
> > >>>>  	list_add_tail(&entity->list, &mdev->entities);
> > >>>>  	spin_unlock(&mdev->lock);
> > >>>> 
> 
