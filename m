Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57802 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbbHNQPd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 12:15:33 -0400
Date: Fri, 14 Aug 2015 13:15:27 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 6/6] media: use media_graph_obj inside links
Message-ID: <20150814131527.18c06c06@recife.lan>
In-Reply-To: <55CE06C4.7080100@xs4all.nl>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
	<b7b0a4f38b7ae2bb3bd69aeaf3476250f489d50a.1439563682.git.mchehab@osg.samsung.com>
	<55CE06C4.7080100@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Aug 2015 17:18:28 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/14/2015 04:56 PM, Mauro Carvalho Chehab wrote:
> > Just like entities and pads, links also need to have unique
> > Object IDs along a given media controller.
> > 
> > So, let's add a media_graph_obj inside it and initialize
> > the object then a new link is created.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 3ac5803b327e..9f02939c2864 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -466,6 +466,8 @@ void media_device_unregister_entity(struct media_entity *entity)
> >  	graph_obj_remove(&entity->graph_obj);
> >  	for (i = 0; i < entity->num_pads; i++)
> >  		graph_obj_remove(&entity->pads[i].graph_obj);
> > +	for (i = 0; entity->num_links; i++)
> > +		graph_obj_remove(&entity->links[i].graph_obj);
> >  	list_del(&entity->list);
> >  	spin_unlock(&mdev->lock);
> >  	entity->parent = NULL;
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index d3dee6fc79d7..4f18bd10b162 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -50,6 +50,8 @@ void graph_obj_init(struct media_device *mdev,
> >  		gobj->id |= ++mdev->entity_id;
> >  	case MEDIA_GRAPH_PAD:
> >  		gobj->id |= ++mdev->pad_id;
> > +	case MEDIA_GRAPH_LINK:
> > +		gobj->id |= ++mdev->pad_id;
> 
> Same issue with missing breaks. Also for links you want to use link_id, not
> pad_id. Clearly a copy-and-paste mistake.

Fixed.

> A bigger question is whether you actually need graph_obj for a link? Links are
> *between* graph objects, but are they really graph objects in their own right?

Yes, a link is a graph object. See any CAD/CAM program and you'll see that
they're mapping as such on all I'm aware of. If we either need it here or not,
see below.

> Currently a link is identified by the source/sink objects and I think that is
> all you need. I didn't realize that when reviewing the v3 patch series, but I'm
> now wondering about it.
> 
> If you *don't* make links a graph_obj, will anything break or become difficult
> to use? I don't think so, but let me know if I am overlooking something.

There are several reasons why we want links to have a common object and
an unique ID. 

By having an unique ID, whenever we need to pass the link to, we can
use the ID (or, actually, a pointer to the common object).

Also, please remember that the type is now embedded with the ID.
So, in order to be able to check what graph element are used, we need
either the type or the ID.

A real case, Shuah mentioned via email is that, in order to properly lock
between ALSA, V4L and DVB, the pertinent drivers need to be notified when
some links, entities (and maybe interfaces) are created (or removed),
as the graph creation will be handle by multiple, indepentent drivers.

If we use an unique ID for the links, a single notify function can be
used to report if a new graph element is added.

For example, where both entities and link creation needs to be tracked,
such function would do be like:

static void notify_topology_change(struct media_graph_obj *gobj)
{
	enum media_graph_type type = gobj->id >> 24;

	switch (type) {
	case MEDIA_GRAPH_ENTITY:
	{
		struct media_entity *entity = gobj_to_entity(gobj);
		/* something */
		break;
	}
	case MEDIA_GRAPH_LINK:
	{
		struct media_link *link = gobj_to_link(gobj);
		/* something else */
		break;
	}
	default:
		/* do nothing */
	}
}

That's just the initial usecase. I'm pretty sure we'll need it when
we add support for dynamic creation/removal and, eventually, even
at the userspace API, but let's go by parts.

Regards,
Mauro
