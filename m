Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59940 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdCBSkT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 13:40:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2: device_register_subdev_nodes: allow calling multiple times)
Date: Thu, 02 Mar 2017 20:39:51 +0200
Message-ID: <2358884.6crJRnJuOY@avalon>
In-Reply-To: <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz> <20170302090727.GC27818@amd> <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 02 Mar 2017 16:16:17 Sakari Ailus wrote:
> On Thu, Mar 02, 2017 at 10:07:27AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > Making the sub-device bus configuration a pointer should be in a
> > > separate patch. It makes sense since the entire configuration is not
> > > valid for all sub-devices attached to the ISP anymore. I think it
> > > originally was a separate patch, but they probably have been merged at
> > > some point. I can'tfind it right now anyway.
> > 
> > Something like this?
> > 
> > 									Pavel
> > 
> > commit df9141c66678b549fac9d143bd55ed0b242cf36e
> > Author: Pavel <pavel@ucw.cz>
> > Date:   Wed Mar 1 13:27:56 2017 +0100
> > 
> >     Turn bus in struct isp_async_subdev into pointer; some of our subdevs
> >     (flash, focus) will not need bus configuration.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> I applied this to the ccp2 branch with an improved patch description.
> 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 8a456d4..36bd359 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2030,12 +2030,18 @@ enum isp_of_phy {
> > 
> >  static int isp_fwnode_parse(struct device *dev, struct fwnode_handle
> >  *fwn,
> >  
> >  			    struct isp_async_subdev *isd)
> >  
> >  {
> > 
> > -	struct isp_bus_cfg *buscfg = &isd->bus;
> > +	struct isp_bus_cfg *buscfg;
> > 
> >  	struct v4l2_fwnode_endpoint vfwn;
> >  	unsigned int i;
> >  	int ret;
> >  	bool csi1 = false;
> > 
> > +	buscfg = devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);

Given that you recently get rid of devm_kzalloc() in the driver, let's not 
introduce a new one here.

> > +	if (!buscfg)
> > +		return -ENOMEM;
> > +
> > +	isd->bus = buscfg;
> > +
> >  	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
> >  	if (ret)
> >  	
> >  		return ret;
> > 

[snip]

-- 
Regards,

Laurent Pinchart
