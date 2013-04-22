Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52575 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3DVMj7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:39:59 -0400
Date: Mon, 22 Apr 2013 14:39:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 23/24] V4L2: mt9p031: add struct v4l2_subdev_platform_data
 to platform data
In-Reply-To: <1621615.OUnKCBbkfO@avalon>
Message-ID: <Pine.LNX.4.64.1304221435540.23906@axis700.grange>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-24-git-send-email-g.liakhovetski@gmx.de>
 <Pine.LNX.4.64.1304182346060.28933@axis700.grange> <1621615.OUnKCBbkfO@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Apr 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday 18 April 2013 23:47:26 Guennadi Liakhovetski wrote:
> > On Thu, 18 Apr 2013, Guennadi Liakhovetski wrote:
> > > Adding struct v4l2_subdev_platform_data to mt9p031's platform data allows
> > > the driver to use generic functions to manage sensor power supplies.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > A small addition to this one too: to be absolutely honest, I also had to
> > replace 12-bit formats with their 8-bit counterparts, because only 8 data
> > lanes are connected to my camera host. We'll need to somehow properly
> > solve this too.
> 
> That information should be conveyed by platform/DT data for the host, and be 
> used to convert the 12-bit media bus code into a 8-bit media bus code in the 
> host (a core helper function would probably be helpful).

Yes, and we discussed this before too, I think. I proposed based then to 
implement some compatibility table of "trivial" transformations, like a 
12-bit Bayer, right-shifted by 4 bits, produces a respective 8-bit Bayer 
etc. Such transformations would fit nicely in soc_mediabus.c ;-) This just 
needs to be implemented...

Sure, I'd be happy to move soc_mediabus.c to 
drivers/media/v4l2-core/v4l2-mediabus.c.

Thanks
Guennadi

> > > ---
> > > 
> > >  drivers/media/i2c/mt9p031.c |    1 +
> > >  include/media/mt9p031.h     |    3 +++
> > >  2 files changed, 4 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> > > index 70f4525..ca2cc6e 100644
> > > --- a/drivers/media/i2c/mt9p031.c
> > > +++ b/drivers/media/i2c/mt9p031.c
> > > @@ -1048,6 +1048,7 @@ static int mt9p031_probe(struct i2c_client *client,
> > >  		goto done;
> > >  	
> > >  	mt9p031->subdev.dev = &client->dev;
> > > +	mt9p031->subdev.pdata = &pdata->sd_pdata;
> > >  	ret = v4l2_async_register_subdev(&mt9p031->subdev);
> > >  
> > >  done:
> > > diff --git a/include/media/mt9p031.h b/include/media/mt9p031.h
> > > index 0c97b19..7bf7b53 100644
> > > --- a/include/media/mt9p031.h
> > > +++ b/include/media/mt9p031.h
> > > @@ -1,6 +1,8 @@
> > >  #ifndef MT9P031_H
> > >  #define MT9P031_H
> > > 
> > > +#include <media/v4l2-subdev.h>
> > > +
> > >  struct v4l2_subdev;
> > >  /*
> > > @@ -15,6 +17,7 @@ struct mt9p031_platform_data {
> > >  	int reset;
> > >  	int ext_freq;
> > >  	int target_freq;
> > > +	struct v4l2_subdev_platform_data sd_pdata;
> > >  };
> > >  
> > >  #endif
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
