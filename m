Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46192 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751342AbbIIIEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Sep 2015 04:04:08 -0400
Date: Wed, 9 Sep 2015 11:03:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v8 18/55] [media] omap3isp: create links after all
 subdevs have been bound
Message-ID: <20150909080333.GL3175@valkosipuli.retiisi.org.uk>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <6e78f34ad454da44d68720a114f0f8e872560e8e.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e78f34ad454da44d68720a114f0f8e872560e8e.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier and Mauro,

On Sun, Aug 30, 2015 at 12:06:29AM -0300, Mauro Carvalho Chehab wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> The omap3isp driver parses the graph endpoints to know how many subdevices
> needs to be registered async and register notifiers callbacks for to know
> when these are bound and when the async registrations are completed.
> 
> Currently the entities pad are linked with the correct ISP input interface
> when the subdevs are bound but it happens before entitities are registered
> with the media device so that won't work now that the entity links list is
> initialized on device registration.
> 
> So instead creating the pad links when the subdevice is bound, create them
> on the complete callback once all the subdevices have been bound but only
> try to create for the ones that have a bus configuration set during bound.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index b8f6f81d2db2..69e7733d36cd 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2321,26 +2321,33 @@ static int isp_subdev_notifier_bound(struct v4l2_async_notifier *async,
>  				     struct v4l2_subdev *subdev,
>  				     struct v4l2_async_subdev *asd)
>  {
> -	struct isp_device *isp = container_of(async, struct isp_device,
> -					      notifier);
>  	struct isp_async_subdev *isd =
>  		container_of(asd, struct isp_async_subdev, asd);
> -	int ret;
> -
> -	ret = isp_link_entity(isp, &subdev->entity, isd->bus.interface);
> -	if (ret < 0)
> -		return ret;
>  
>  	isd->sd = subdev;
>  	isd->sd->host_priv = &isd->bus;
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
>  {
>  	struct isp_device *isp = container_of(async, struct isp_device,
>  					      notifier);
> +	struct v4l2_device *v4l2_dev = &isp->v4l2_dev;
> +	struct v4l2_subdev *sd;
> +	struct isp_bus_cfg *bus;
> +	int ret;
> +
> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> +		/* Only try to link entities whose interface was set on bound */
> +		if (sd->host_priv) {
> +			bus = (struct isp_bus_cfg *)sd->host_priv;
> +			ret = isp_link_entity(isp, &sd->entity, bus->interface);
> +			if (ret < 0)
> +				return ret;
> +		}
> +	}
>  
>  	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
>  }

I think you're working around a problem here, not really fixing it.

This change will create the links only after the media device is registered,
which means the user may obtain a partial enumeration of links if the
enumeration is performed too early.

Before this set, the problem also was that the media device was registered
before the async entities were bound, again making it possible to obtain a
partial enumeration of entities.

What I'd suggest instead is that we split media device initialisation and
registration to the system; that way the media device can be prepared
(entities registered and links created) before it becomes visible to the
user space. I can write a patch for that if you like.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
