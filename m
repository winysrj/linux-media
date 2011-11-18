Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40608 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165Ab1KRPI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Nov 2011 10:08:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v5 2/2] as3645a: Add driver for LED flash controller
Date: Fri, 18 Nov 2011 16:09:09 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1321452657-24424-1-git-send-email-laurent.pinchart@ideasonboard.com> <1321452657-24424-3-git-send-email-laurent.pinchart@ideasonboard.com> <1321454118.30587.39.camel@smile>
In-Reply-To: <1321454118.30587.39.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181609.12462.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Wednesday 16 November 2011 15:35:18 Andy Shevchenko wrote:
> On Wed, 2011-11-16 at 15:10 +0100, Laurent Pinchart wrote:
> > This patch adds the driver for the as3645a LED flash controller. This
> > controller supports a high power led in flash and torch modes and an
> > indicator light, sometimes also called privacy light.
> 
> Just few nitpicks.
> 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 4e8a0c4..9617c05 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -533,6 +533,13 @@ config VIDEO_ADP1653
> > 
> >  	  This is a driver for the ADP1653 flash controller. It is used for
> >  	  example in Nokia N900.
> > 
> > +config VIDEO_AS3645A
> > +	tristate "AS3645A flash driver support"
> > +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> > +	---help---
> > +	  This is a driver for the AS3645A and LM3555 flash controllers. It has
> > +	  build in control for Flash, Torch and Indicator LEDs.
> 
> Probably we might use uncapitalized words "for flash, torch and
> indicator"

OK. I'll fix that in the pull request.

> > diff --git a/drivers/media/video/as3645a.c
> > b/drivers/media/video/as3645a.c new file mode 100644
> > index 0000000..d583a9c
> > --- /dev/null
> > +++ b/drivers/media/video/as3645a.c
> > 
> > +static int as3645a_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *devid)
> > +{
> 
> To be consistent with remove()

As discussed on Jabber, the mutex is initialized as one of the last probe() 
operations, and we're guaranteed not to fail then. There's thus no problem 
with this.

> + mutex_init(&flash->power_lock);
> 
> > +	ret = as3645a_init_controls(flash);
> > +	if (ret < 0)
> > +		goto done;
> > +
> > +	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> > +	if (ret < 0)
> > +		goto done;
> > +
> > +	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> > 
> > +	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> > +
> > +done:
> > +	if (ret < 0) {
> 
> + mutex_destroy(&flash->power_lock);
> 
> > + v4l2_ctrl_handler_free(&flash->ctrls);
> > +		kfree(flash);
> > +	}
> > +
> > +	return ret;
> > +}

-- 
Regards,

Laurent Pinchart
