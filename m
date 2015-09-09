Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35090 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbbIIK2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 06:28:52 -0400
Date: Wed, 9 Sep 2015 07:28:47 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v8 18/55] [media] omap3isp: create links after all
 subdevs have been bound
Message-ID: <20150909072847.5a1c7f78@recife.lan>
In-Reply-To: <20150909080333.GL3175@valkosipuli.retiisi.org.uk>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<6e78f34ad454da44d68720a114f0f8e872560e8e.1440902901.git.mchehab@osg.samsung.com>
	<20150909080333.GL3175@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Wed, 09 Sep 2015 11:03:33 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Javier and Mauro,
> 
> On Sun, Aug 30, 2015 at 12:06:29AM -0300, Mauro Carvalho Chehab wrote:
> > From: Javier Martinez Canillas <javier@osg.samsung.com>
> > 
> > The omap3isp driver parses the graph endpoints to know how many subdevices
> > needs to be registered async and register notifiers callbacks for to know
> > when these are bound and when the async registrations are completed.
> > 
> > Currently the entities pad are linked with the correct ISP input interface
> > when the subdevs are bound but it happens before entitities are registered
> > with the media device so that won't work now that the entity links list is
> > initialized on device registration.
> > 
> > So instead creating the pad links when the subdevice is bound, create them
> > on the complete callback once all the subdevices have been bound but only
> > try to create for the ones that have a bus configuration set during bound.
> > 
> > Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index b8f6f81d2db2..69e7733d36cd 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2321,26 +2321,33 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
> >  				     struct v4l2_subdev *subdev,
> >  				     struct v4l2_async_subdev *asd)
> >  {
> > -	struct isp_device *isp = container_of(async, struct isp_device,
> > -					      notifier);
> >  	struct isp_async_subdev *isd =
> >  		container_of(asd, struct isp_async_subdev, asd);
> > -	int ret;
> > -
> > -	ret = isp_link_entity(isp, &subdev->entity, isd->bus.interface);
> > -	if (ret < 0)
> > -		return ret;
> >  
> >  	isd->sd = subdev;
> >  	isd->sd->host_priv = &isd->bus;
> >  
> > -	return ret;
> > +	return 0;
> >  }
> >  
> >  static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
> >  {
> >  	struct isp_device *isp = container_of(async, struct isp_device,
> >  					      notifier);
> > +	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
> > +	struct v4l2_subdev *sd;
> > +	struct isp_bus_cfg *bus;
> > +	int ret;
> > +
> > +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> > +		/* Only try to link entities whose interface was set on bound */
> > +		if (sd->host_priv) {
> > +			bus = (struct isp_bus_cfg *)sd->host_priv;
> > +			ret = isp_link_entity(isp, &sd->entity, bus->interface);
> > +			if (ret < 0)
> > +				return ret;
> > +		}
> > +	}
> >  
> >  	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
> >  }
> 
> I think you're working around a problem here, not really fixing it.
> 
> This change will create the links only after the media device is registered,
> which means the user may obtain a partial enumeration of links if the
> enumeration is performed too early.
> 
> Before this set, the problem also was that the media device was registered
> before the async entities were bound, again making it possible to obtain a
> partial enumeration of entities.

Before of after this series, if userspace tries to read the topology too
early, it will get a partial topology. Before this series, it may lose
entities and links; after this series, it may lose any object.

In any case, userspace won't do the right thing, whatever order we
initialize.

The patches on this series is not meant to solve this issue.

The rationale for this patch is due to a different reason. You should 
notice that, due to the G_TOPOLOGY ioctl requirements, all objects
should have their ID assigned and should be added at the mdev linked
lists, as those are used by G_TOPOLOGY loops that copy the object
data to userspace.

So, before registering/creating any object, the media_device struct
need to exist internally at Kernelspace.

> 
> What I'd suggest instead is that we split media device initialisation and
> registration to the system; that way the media device can be prepared
> (entities registered and links created) before it becomes visible to the
> user space. I can write a patch for that if you like.

Yes, we can split the internal media register stuff from the
creation of the /dev/media0 device node, doing that only after
having everything set in Kernel, as the patch that Javier proposed
on IRC.

Another alternative would be to add a "busy" flag at media_device,
making all ioctl's at /dev/mdeia0 to return -EBUSY during massive
graph changes.

Such flag would be rised at media_device registration and dropped
at the end of the device probe routine.

The advantage of using such flags is that this could be used,
for example, on ARA project, when a module is removed or inserted.

The disadvantage is that current userspace apps may not be prepared
to receive -EBUSY.

I'm OK with both strategies.

Regards,
Mauro
