Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53201 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1ATOhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 09:37:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: martin@neutronstar.dyndns.org
Subject: Re: [PATCH V2] v4l: OMAP3 ISP CCDC: Add support for 8bit greyscale sensors
Date: Thu, 20 Jan 2011 15:37:50 +0100
Cc: linux-media@vger.kernel.org
References: <1295386062-10618-1-git-send-email-martin@neutronstar.dyndns.org> <201101190027.19904.laurent.pinchart@ideasonboard.com> <20110119174759.GA13173@neutronstar.dyndns.org>
In-Reply-To: <20110119174759.GA13173@neutronstar.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101201537.50841.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Martin,

On Wednesday 19 January 2011 18:47:59 martin@neutronstar.dyndns.org wrote:
> On Wed, Jan 19, 2011 at 12:27:19AM +0100, Laurent Pinchart wrote:
> > On Tuesday 18 January 2011 22:27:42 Martin Hostettler wrote:
> > > Adds support for V4L2_MBUS_FMT_Y8_1X8 format and 8bit data width in
> > > synchronous interface.
> > > 
> > > When in 8bit mode don't apply DC substraction of 64 per default as this
> > > would remove 1/4 of the sensor range.
> > > 
> > > When using V4L2_MBUS_FMT_Y8_1X8 (or possibly another 8bit per pixel)
> > > mode set the CDCC to output 8bit per pixel instead of 16bit.
> > > 
> > > Signed-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > > ---
> > > 
> > >  drivers/media/video/isp/ispccdc.c  |   22 ++++++++++++++++++----
> > >  drivers/media/video/isp/ispvideo.c |    2 ++
> > >  2 files changed, 20 insertions(+), 4 deletions(-)
> > > 
> > > Changes since first version:
> > > 	- forward ported to current media.git
> > > 
> > > diff --git a/drivers/media/video/isp/ispccdc.c
> > > b/drivers/media/video/isp/ispccdc.c index 578c8bf..c7397c9 100644
> 
> [...]
> 
> > > @@ -2244,7 +2253,12 @@ int isp_ccdc_init(struct isp_device *isp)
> > > 
> > >  	ccdc->syncif.vdpol = 0;
> > >  	
> > >  	ccdc->clamp.oblen = 0;
> > > 
> > > -	ccdc->clamp.dcsubval = 64;
> > > +
> > > +	if (isp->pdata->subdevs->interface == ISP_INTERFACE_PARALLEL
> > > +	    && isp->pdata->subdevs->bus.parallel.width <= 8)
> > > +		ccdc->clamp.dcsubval = 0;
> > > +	else
> > > +		ccdc->clamp.dcsubval = 64;
> > 
> > I don't like this too much. What happens if you have several sensors
> > connected to the system with different bus width ?
> 
> Yes, you're right of course, the current code is semantically broken.
> 
> But the only clean solution i can think of is setting it to 0
> unconditionally.
> I'm not sure what this default should acomplish, so maybe i'm missing
> something here, but i think the right value if dc substraction is needed
> would be highly sensor specific?
> I think all other of these postprocessing features for the CCDC default to
> off, so it would make sense to default this to off too.
> 
> The overenginered solution would be to maintain a different value for each
> bus width and let the user change the setting for the buswidth of the
> currently linked sensor. In a way this would make sense,
> because the DC substraction is fundamentally dependent on the bus size i
> think. But i don't think anyone would want such complexity.
> 
> But i think it wouldn't be nice if every user of an 8bit sensor needs to
> set this manually just to get the sensor working in a sane way (for 8bit
> substracting 64 is insane, for wider buses it's different)
> 
> So how to proceed with this?

My personal opinion (at least for now) is that we should set the default value 
to 0. I'll see if I can convince people at Nokia that it would be the right 
way to go. If so I'll apply a patch for that.

-- 
Regards,

Laurent Pinchart
