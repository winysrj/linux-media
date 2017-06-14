Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52274 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752626AbdFNWWM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 18:22:12 -0400
Date: Thu, 15 Jun 2017 01:21:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 6/8] leds: as3645a: Add LED flash class driver
Message-ID: <20170614222135.GT12407@valkosipuli.retiisi.org.uk>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-7-git-send-email-sakari.ailus@linux.intel.com>
 <20170614213941.GC10200@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170614213941.GC10200@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the review!

On Wed, Jun 14, 2017 at 11:39:41PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> That address no longer works, right?

Why wouldn't it work? Or... do you know something I don't? :-)

> 
> > Add a LED flash class driver for the as3654a flash controller. A V4L2 flash
> > driver for it already exists (drivers/media/i2c/as3645a.c), and this driver
> > is based on that.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> > + * Based on drivers/media/i2c/as3645a.c.
> > + *
> > + * Contact: Sakari Ailus <sakari.ailus@iki.fi>
> 
> So I believe it should not be here.
> 
> > +/*
> > + * as3645a_set_config - Set flash configuration registers
> > + * @flash: The flash
> > + *
> 
> /** for linuxdoc? 

Fixed.

> 
> > +	struct as3645a *flash = fled_to_as3645a(fled);
> > +	int rval;
> > +
> > +	/* NOTE: reading register clear fault status */
> 
> clears.

Fixed.

> 
> > +static unsigned int as3645a_current_to_reg(struct as3645a *flash, bool is_flash,
> > +					   unsigned int ua)
> > +{
> > +	struct {
> > +		unsigned int min;
> > +		unsigned int max;
> > +		unsigned int step;
> > +	} __mms[] = {
> > +		{
> > +			AS_TORCH_INTENSITY_MIN,
> > +			flash->cfg.assist_max_ua,
> > +			AS_TORCH_INTENSITY_STEP
> > +		},
> > +		{
> > +			AS_FLASH_INTENSITY_MIN,
> > +			flash->cfg.flash_max_ua,
> > +			AS_FLASH_INTENSITY_STEP
> > +		},
> > +	}, *mms = &__mms[is_flash];
> > +
> > +	if (ua < mms->min)
> > +		ua = mms->min;
> 
> That's some... seriously interesting code. And you are forcing gcc to
> create quite interesting structure on stack. Would it be easier to do
> normal if()... without this magic?
> 
> > +	struct v4l2_flash_config cfg = {
> > +		.torch_intensity = {
> > +			.min = AS_TORCH_INTENSITY_MIN,
> > +			.max = flash->cfg.assist_max_ua,
> > +			.step = AS_TORCH_INTENSITY_STEP,
> > +			.val = flash->cfg.assist_max_ua,
> > +		},
> > +		.indicator_intensity = {
> > +			.min = AS_INDICATOR_INTENSITY_MIN,
> > +			.max = flash->cfg.indicator_max_ua,
> > +			.step = AS_INDICATOR_INTENSITY_STEP,
> > +			.val = flash->cfg.indicator_max_ua,
> > +		},
> > +	};
> 
> Ugh. And here you have copy of the above struct, + .val. Can it be
> somehow de-duplicated?

The flash_brightness_set callback uses micro-Amps as the unit and the driver
needs to convert that to its own specific units. Yeah, there would be
probably an easier way, too. But that'd likely require changes to the LED
flash class.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
