Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56357 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbbLFDFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 22:05:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 18/55] [media] omap3isp: create links after all subdevs have been bound
Date: Sun, 06 Dec 2015 05:05:25 +0200
Message-ID: <2092688.POBCcC9dJr@avalon>
In-Reply-To: <55EFF25D.5010905@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <20150909080333.GL3175@valkosipuli.retiisi.org.uk> <55EFF25D.5010905@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Thank you for the patch.

On Wednesday 09 September 2015 10:48:29 Javier Martinez Canillas wrote:
> On 09/09/2015 10:03 AM, Sakari Ailus wrote:
> > On Sun, Aug 30, 2015 at 12:06:29AM -0300, Mauro Carvalho Chehab wrote:
> >> From: Javier Martinez Canillas <javier@osg.samsung.com>
> >> 
> >> The omap3isp driver parses the graph endpoints to know how many
> >> subdevices needs to be registered async and register notifiers callbacks
> >> for to know when these are bound and when the async registrations are
> >> completed.
> >> 
> >> Currently the entities pad are linked with the correct ISP input
> >> interface when the subdevs are bound but it happens before entitities are
> >> registered with the media device so that won't work now that the entity
> >> links list is initialized on device registration.
> >> 
> >> So instead creating the pad links when the subdevice is bound, create
> >> them on the complete callback once all the subdevices have been bound but
> >> only try to create for the ones that have a bus configuration set during
> >> bound.
> >> 
> >> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >> 
> >> diff --git a/drivers/media/platform/omap3isp/isp.c
> >> b/drivers/media/platform/omap3isp/isp.c index b8f6f81d2db2..69e7733d36cd
> >> 100644
> >> --- a/drivers/media/platform/omap3isp/isp.c
> >> +++ b/drivers/media/platform/omap3isp/isp.c
> >> @@ -2321,26 +2321,33 @@ static int isp_subdev_notifier_bound(struct
> >> v4l2_async_notifier *async,
> >>  				     struct v4l2_subdev *subdev,
> >>  				     struct v4l2_async_subdev *asd)
> >>  {
> >> -	struct isp_device *isp = container_of(async, struct isp_device,
> >> -					      notifier);
> >>  	struct isp_async_subdev *isd =
> >>  		container_of(asd, struct isp_async_subdev, asd);
> >> -	int ret;
> >> -
> >> -	ret = isp_link_entity(isp, &subdev->entity, isd->bus.interface);
> >> -	if (ret < 0)
> >> -		return ret;
> >> 
> >>  	isd->sd = subdev;
> >>  	isd->sd->host_priv = &isd->bus;
> >> 
> >> -	return ret;
> >> +	return 0;
> >>  }
> >>  
> >>  static int isp_subdev_notifier_complete(struct v4l2_async_notifier
> >>  *async)
> >>  {
> >>  	struct isp_device *isp = container_of(async, struct isp_device,
> >>  					      notifier);
> >> +	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
> >> +	struct v4l2_subdev *sd;
> >> +	struct isp_bus_cfg *bus;
> >> +	int ret;
> >> +
> >> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> >> +		/* Only try to link entities whose interface was set on bound */
> >> +		if (sd->host_priv) {
> >> +			bus = (struct isp_bus_cfg *)sd->host_priv;
> >> +			ret = isp_link_entity(isp, &sd->entity, bus->interface);
> >> +			if (ret < 0)
> >> +				return ret;
> >> +		}
> >> +	}
> >>  	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
> >>  }
> > 
> > I think you're working around a problem here, not really fixing it.
> > 
> > This change will create the links only after the media device is
> > registered, which means the user may obtain a partial enumeration of
> > links if the enumeration is performed too early.
> > 
> > Before this set, the problem also was that the media device was registered
> > before the async entities were bound, again making it possible to obtain a
> > partial enumeration of entities.
> 
> You are absolutely correct but I think these are separate issues. The
> problem here is that v4l2_async_test_notify() [0] first invokes the bound
> notifier callback and then calls v4l2_device_register_subdev() that
> register the media entity with the media device.
> 
> Since now is a requirement that the entities must be registered prior
> creating pads links (because to init a MEDIA_GRAPH_LINK object a mdev has
> to be set), $SUBJECT is needed regardless of the race between subdev
> registration and the media dev node being available to user-space before
> everything is registered.
> > What I'd suggest instead is that we split media device initialisation and
> > registration to the system; that way the media device can be prepared
> > (entities registered and links created) before it becomes visible to the
> > user space. I can write a patch for that if you like.
> 
> Agreed, looking at the implementation it seems that
> __media_device_register() has to be split (possibly being renamed to
> __media_device_init) so it only contains the initialization logic and all
> the media device node registration logic moved to another function (that
> would become media_device_register).
> 
> I think the media dev node registration has to be made in the complete
> callback to make sure that happens when all the subdevs have been already
> registered.
> 
> Is that what you had in mind? I can also write such a patch if you want.

I think I've already commented on it in my review of another patch (but can't 
find it right now), I agree with you. We need to properly think about 
initialization (and, for that matter, cleanup as well) order, both for the 
media device and the entities. And, as a corollary, for subdevs too. The 
current media entity and subdevs initialization and registration code grew in 
an organic way without much design behind it, let's not repeat the same 
mistake.

> [0]:
> http://lxr.free-electrons.com/source/drivers/media/v4l2-core/v4l2-async.c#L
> 96 [1]:
> http://lxr.free-electrons.com/source/drivers/media/media-device.c#L372

-- 
Regards,

Laurent Pinchart

