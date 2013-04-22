Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3DVMdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:33:05 -0400
Date: Mon, 22 Apr 2013 14:33:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 18/24] V4L2: mt9p031: power down the sensor if no supported
 device has been detected
In-Reply-To: <1756723.mDdT6UkUyR@avalon>
Message-ID: <Pine.LNX.4.64.1304221432080.23906@axis700.grange>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
 <1366320945-21591-19-git-send-email-g.liakhovetski@gmx.de> <1756723.mDdT6UkUyR@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Mon, 22 Apr 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Thursday 18 April 2013 23:35:39 Guennadi Liakhovetski wrote:
> > The mt9p031 driver first accesses the I2C device in its .registered()
> > method. While doing that it furst powers the device up, but if probing
> 
> s/furst/first/
> 
> > fails, it doesn't power the chip back down. This patch fixes that bug.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >
> > ---
> >  drivers/media/i2c/mt9p031.c |   10 ++++++----
> >  1 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> > index eb2de22..70f4525 100644
> > --- a/drivers/media/i2c/mt9p031.c
> > +++ b/drivers/media/i2c/mt9p031.c
> > @@ -844,7 +844,7 @@ static int mt9p031_registered(struct v4l2_subdev
> > *subdev) ret = mt9p031_power_on(mt9p031);
> >  	if (ret < 0) {
> >  		dev_err(&client->dev, "MT9P031 power up failed\n");
> > -		return ret;
> > +		goto done;
> 
> Not here. If power on fails, there's no need to power off.

Oops, right.

> >  	}
> > 
> >  	/* Read out the chip version register */
> > @@ -852,13 +852,15 @@ static int mt9p031_registered(struct v4l2_subdev
> > *subdev) if (data != MT9P031_CHIP_VERSION_VALUE) {
> >  		dev_err(&client->dev, "MT9P031 not detected, wrong version "
> >  			"0x%04x\n", data);
> > -		return -ENODEV;
> > +		ret = -ENODEV;
> >  	}
> > 
> > +done:
> >  	mt9p031_power_off(mt9p031);
> > 
> > -	dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
> > -		 client->addr);
> > +	if (!ret)
> > +		dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
> > +			 client->addr);
> > 
> >  	return ret;
> >  }
> 
> It would be easier to just move the power off line right after the 
> mt9p031_read() call and leave the rest unchanged.

Sure, please, do.

Thanks
Guennadi

> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 28cf95b..8de84c0 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -849,18 +849,18 @@ static int mt9p031_registered(struct v4l2_subdev 
> *subdev)
>  
>         /* Read out the chip version register */
>         data = mt9p031_read(client, MT9P031_CHIP_VERSION);
> +       mt9p031_power_off(mt9p031);
> +
>         if (data != MT9P031_CHIP_VERSION_VALUE) {
>                 dev_err(&client->dev, "MT9P031 not detected, wrong version "
>                         "0x%04x\n", data);
>                 return -ENODEV;
>         }
>  
> -       mt9p031_power_off(mt9p031);
> -
>         dev_info(&client->dev, "MT9P031 detected at address 0x%02x\n",
>                  client->addr);
>  
> -       return ret;
> +       return 0;
>  }
>  
>  static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh 
> *fh)
> 
> If you're happy with that there's no need to resubmit, I'll apply the patch to 
> my tree for v3.11.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
