Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47244 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbbHOQmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2015 12:42:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 3/6] media: add a common struct to be embed on media graph objects
Date: Sat, 15 Aug 2015 19:42:59 +0300
Message-ID: <1623419.sEUamBU9MU@avalon>
In-Reply-To: <20150815115618.7af73c68@recife.lan>
References: <cover.1439563682.git.mchehab@osg.samsung.com> <20150814212514.GB28370@valkosipuli.retiisi.org.uk> <20150815115618.7af73c68@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Saturday 15 August 2015 11:56:18 Mauro Carvalho Chehab wrote:
> Em Sat, 15 Aug 2015 00:25:15 +0300 Sakari Ailus escreveu:
> > On Fri, Aug 14, 2015 at 11:56:40AM -0300, Mauro Carvalho Chehab wrote:
> > > Due to the MC API proposed changes, we'll need to have an unique
> > > object ID for all graph objects, and have some shared fields
> > > that will be common on all media graph objects.
> > > 
> > > Right now, the only common object is the object ID, but other
> > > fields will be added latter on.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > > index b8102bda664d..046f1fe40b50 100644
> > > --- a/drivers/media/media-entity.c
> > > +++ b/drivers/media/media-entity.c
> > > @@ -27,6 +27,39 @@
> > > 
> > >  #include <media/media-device.h>
> > >  
> > >  /**
> > > + *  graph_obj_init - Initialize a graph object
> > > + *
> > > + * @mdev:	Pointer to the media_device that contains the object
> > > + * @type:	Type of the object
> > > + * @gobj:	Pointer to the object
> > > + *
> > > + * This routine initializes the embedded struct media_graph_obj inside
> > > a
> > > + * media graph object. It is called automatically if media_*_create()
> > > + * calls are used. However, if the object (entity, link, pad,
> > > interface)
> > > + * is embedded on some other object, this function should be called
> > > before
> > > + * registering the object at the media controller.
> > > + */
> > > +void graph_obj_init(struct media_device *mdev,
> > > +			   enum media_graph_type type,
> > > +			   struct media_graph_obj *gobj)
> > > +{
> > > +	/* An unique object ID will be provided on next patches */
> > > +	gobj->id = type << 24;
> > 
> > Ugh. This will mean the object IDs are going to be huge to begin with,
> > ending up being a nuisance to work with as you often write them by hand.
> > Do we win anything by doing so?
> 
> There is a problem on the current implementation of the graph: it uses
> a bitmap in order to detect if the graph traversal entered inside a loop.
> Also, one of the drivers (vsp1, I think) assumes that the maximum ID
> for an entity is 31 (as it uses 1 << entity->id).

If core code or drivers do the wrong thing they should be fixed instead of 
working around the problem.

A fixed bitmap in the graph walk will just not scale when we'll add support 
for dynamically adding or removing entities. We thus need to change the 
algorithm anyway.

The OMAP3 ISP and VSP1 drivers could use fixed size bitmaps as they won't 
support dynamic addition or removal of entities, so the maximum ID will be 
known at init time.

For other drivers that have similar needs core helper functions would probably 
be helpful.

> Due to that, we should have a separate range for entities starting from
> 0.
> 
> That should not affect neither debug printks or userspace, provided that
> the object type is known, as one could always do:
> 
> #define gobj_id(gobj) ( (gobj)->id & ( (1 << 25) - 1) )
> 
> dev_dbg(mdev->dev, "MC create: %s#%d\n",
>         gobj_type[media_gobj_type(gobj)],
>         gobj_id(gobj));
> 
> 
> in order to report the ID into a reasonable range.
> 
> I'm actually doing that on some debug patches I'm writing right now
> in order to allow me to test object creation/removal.

-- 
Regards,

Laurent Pinchart

