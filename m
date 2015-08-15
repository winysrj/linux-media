Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57951 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbbHOO4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2015 10:56:24 -0400
Date: Sat, 15 Aug 2015 11:56:18 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 3/6] media: add a common struct to be embed on media
 graph objects
Message-ID: <20150815115618.7af73c68@recife.lan>
In-Reply-To: <20150814212514.GB28370@valkosipuli.retiisi.org.uk>
References: <cover.1439563682.git.mchehab@osg.samsung.com>
	<02ddd65348f36f5499acd338e692397baf92b045.1439563682.git.mchehab@osg.samsung.com>
	<20150814212514.GB28370@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Aug 2015 00:25:15 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Fri, Aug 14, 2015 at 11:56:40AM -0300, Mauro Carvalho Chehab wrote:
> > Due to the MC API proposed changes, we'll need to have an unique
> > object ID for all graph objects, and have some shared fields
> > that will be common on all media graph objects.
> > 
> > Right now, the only common object is the object ID, but other
> > fields will be added latter on.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> > index b8102bda664d..046f1fe40b50 100644
> > --- a/drivers/media/media-entity.c
> > +++ b/drivers/media/media-entity.c
> > @@ -27,6 +27,39 @@
> >  #include <media/media-device.h>
> >  
> >  /**
> > + *  graph_obj_init - Initialize a graph object
> > + *
> > + * @mdev:	Pointer to the media_device that contains the object
> > + * @type:	Type of the object
> > + * @gobj:	Pointer to the object
> > + *
> > + * This routine initializes the embedded struct media_graph_obj inside a
> > + * media graph object. It is called automatically if media_*_create()
> > + * calls are used. However, if the object (entity, link, pad, interface)
> > + * is embedded on some other object, this function should be called before
> > + * registering the object at the media controller.
> > + */
> > +void graph_obj_init(struct media_device *mdev,
> > +			   enum media_graph_type type,
> > +			   struct media_graph_obj *gobj)
> > +{
> > +	/* An unique object ID will be provided on next patches */
> > +	gobj->id = type << 24;
> 
> Ugh. This will mean the object IDs are going to be huge to begin with,
> ending up being a nuisance to work with as you often write them by hand. Do
> we win anything by doing so?

There is a problem on the current implementation of the graph: it uses
a bitmap in order to detect if the graph traversal entered inside a loop.
Also, one of the drivers (vsp1, I think) assumes that the maximum ID
for an entity is 31 (as it uses 1 << entity->id).

Due to that, we should have a separate range for entities starting from
0. 

That should not affect neither debug printks or userspace, provided that
the object type is known, as one could always do:

#define gobj_id(gobj) ( (gobj)->id & ( (1 << 25) - 1) )

dev_dbg(mdev->dev, "MC create: %s#%d\n",
        gobj_type[media_gobj_type(gobj)],
        gobj_id(gobj));


in order to report the ID into a reasonable range.

I'm actually doing that on some debug patches I'm writing right now
in order to allow me to test object creation/removal.

Regards,
Mauro
