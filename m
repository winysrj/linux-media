Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38197 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032AbbDPUWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 16:22:22 -0400
Date: Thu, 16 Apr 2015 23:22:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sebastian Reichel <sre@kernel.org>
Cc: pavel@ucw.cz, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150416202215.GH27451@valkosipuli.retiisi.org.uk>
References: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
 <20150416052442.GA31095@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150416052442.GA31095@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastian,

On Thu, Apr 16, 2015 at 07:24:42AM +0200, Sebastian Reichel wrote:
> Hi Sakari,
> 
> Since this driver won't make it into 4.1 anyways, I have one more
> comment:
> 
> On Thu, Apr 16, 2015 at 02:37:13AM +0300, Sakari Ailus wrote:
...
> > @@ -308,16 +311,28 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
> >  {
> >  	int ret;
> >  
> > -	ret = flash->platform_data->power(&flash->subdev, on);
> > -	if (ret < 0)
> > -		return ret;
> > +	if (flash->platform_data->power) {
> > +		ret = flash->platform_data->power(&flash->subdev, on);
> > +		if (ret < 0)
> > +			return ret;
> > +	} else {
> > +		gpiod_set_value(flash->platform_data->enable_gpio, on);
> > +		if (on)
> > +			/* Some delay is apparently required. */
> > +			udelay(20);
> > +	}
> 
> I suggest to remove the power callback from platform data. Instead
> you can require to setup a gpiod lookup table in the boardcode, if
> platform data based initialization is used (see for example si4713
> initialization in board-rx51-periphals.c).
> 
> This will reduce complexity in the driver and should be fairly easy
> to implement, since there is no adp1653 platform code user in the
> mainline kernel anyways.

There are a couple of out-of-tree users perhaps. I think that I'd rather
remove platform data support altogether than trying to polish it.

The timeline could be about the same than with the omap3isp driver, that
shouldn't be too many minor kernel versions either.

What do you think?

...

> > diff --git a/include/media/adp1653.h b/include/media/adp1653.h
> > index 1d9b48a..9779c85 100644
> > --- a/include/media/adp1653.h
> > +++ b/include/media/adp1653.h
> > @@ -100,9 +100,11 @@ struct adp1653_platform_data {
> >  	int (*power)(struct v4l2_subdev *sd, int on);
> >  
> >  	u32 max_flash_timeout;		/* flash light timeout in us */
> > -	u32 max_flash_intensity;	/* led intensity, flash mode */
> > -	u32 max_torch_intensity;	/* led intensity, torch mode */
> > -	u32 max_indicator_intensity;	/* indicator led intensity */
> > +	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
> > +	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
> > +	u32 max_indicator_intensity;	/* indicator led intensity, uA */
> > +
> > +	struct gpio_desc *enable_gpio;	/* for device-tree based boot */
> 
> IMHO this should become part of "struct adp1653_flash", so that
> adp1653_platform_data only contains variables, which should be
> filled by boardcode / manual DT parsing code.

We'll get rid of the whole header with platform data support removal. :-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
