Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:33213 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeINXgl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:36:41 -0400
Date: Fri, 14 Sep 2018 20:20:46 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        kernel@pengutronix.de, devicetree@vger.kernel.org,
        p.zabel@pengutronix.de, javierm@redhat.com,
        laurent.pinchart@ideasonboard.com, afshin.nasser@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] [media] tvp5150: add s_power callback
Message-ID: <20180914182046.y73rpgdwxfm2uchu@pengutronix.de>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
 <20180813092508.1334-8-m.felsch@pengutronix.de>
 <20180914132352.ta2g64slkttr5bdo@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180914132352.ta2g64slkttr5bdo@paasikivi.fi.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 18-09-14 16:23, Sakari Ailus wrote:
> Hi Marco,
> 
> On Mon, Aug 13, 2018 at 11:25:08AM +0200, Marco Felsch wrote:
> > Don't en-/disable the interrupts during s_stream because someone can
> > disable the stream but wants to get informed if the stream is locked
> > again. So keep the interrupts enabled the whole time the pipeline is
> > opened.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  drivers/media/i2c/tvp5150.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index e736f609fecd..e296f5bfae21 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -1389,11 +1389,26 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
> >  /****************************************************************************
> >  			I2C Command
> >   ****************************************************************************/
> > +static int tvp5150_s_power(struct  v4l2_subdev *sd, int on)
> > +{
> > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > +	unsigned int val = 0;
> > +
> > +	if (on)
> > +		val = TVP5150_INT_A_LOCK;
> > +
> > +	if (decoder->irq)
> > +		/* Enable / Disable lock interrupt */
> > +		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
> > +				   TVP5150_INT_A_LOCK, val);
> 
> Could you use runtime PM instead?

I will test it next monday. What's the different between s_power and
runtime PM?

> 
> For an example, the dw9714 driver does this: drivers/media/i2c/dw9714.c .

Hopefully I got you right, should I use the
v4l2_subdev_internal_ops.open/close and call the pm_runtime_put/get
there or did you mean the driver.pm callbacks? I'm not that familiar
with the pm ops at the moment, sorry.

Regards,
Marco

> > +
> > +	return 0;
> > +}
> >  
> >  static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> >  {
> >  	struct tvp5150 *decoder = to_tvp5150(sd);
> > -	unsigned int mask, val = 0, int_val = 0;
> > +	unsigned int mask, val = 0;
> >  
> >  	mask = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
> >  	       TVP5150_MISC_CTL_CLOCK_OE;
> > @@ -1406,15 +1421,10 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> >  			val = decoder->lock ? decoder->oe : 0;
> >  		else
> >  			val = decoder->oe;
> > -		int_val = TVP5150_INT_A_LOCK;
> >  		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
> >  	}
> >  
> >  	regmap_update_bits(decoder->regmap, TVP5150_MISC_CTL, mask, val);
> > -	if (decoder->irq)
> > -		/* Enable / Disable lock interrupt */
> > -		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
> > -				   TVP5150_INT_A_LOCK, int_val);
> >  
> >  	return 0;
> >  }
> > @@ -1616,6 +1626,7 @@ static const struct v4l2_subdev_core_ops tvp5150_core_ops = {
> >  	.g_register = tvp5150_g_register,
> >  	.s_register = tvp5150_s_register,
> >  #endif
> > +	.s_power = tvp5150_s_power,
> >  };
> >  
> >  static const struct v4l2_subdev_tuner_ops tvp5150_tuner_ops = {
> 
> -- 
> Kind regards,
> 
> Sakari Ailus
> sakari.ailus@linux.intel.com
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
