Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54949 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbeGaHl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 03:41:27 -0400
Date: Tue, 31 Jul 2018 08:02:40 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 13/22] [media] tvp5150: disable output while signal not
 locked
Message-ID: <20180731060240.wd4lexhpje2phb5z@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-14-m.felsch@pengutronix.de>
 <20180730150058.30563d0f@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180730150058.30563d0f@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

thanks for your feedback.

On 18-07-30 15:00, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Jun 2018 18:20:45 +0200
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
> > From: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > To avoid short frames on stream start, keep output pins at high impedance
> > while we are not properly locked onto the input signal.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  drivers/media/i2c/tvp5150.c | 39 ++++++++++++++++++++++++++-----------
> >  1 file changed, 28 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index d8bdbedd8826..27cfd08be3d2 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -60,6 +60,7 @@ struct tvp5150 {
> >  	v4l2_std_id detected_norm;
> >  	u32 input;
> >  	u32 output;
> > +	u32 oe;
> >  	int enable;
> >  	bool lock;
> >  
> > @@ -799,14 +800,20 @@ static irqreturn_t tvp5150_isr(int irq, void *dev_id)
> >  {
> >  	struct tvp5150 *decoder = dev_id;
> >  	struct regmap *map = decoder->regmap;
> > -	unsigned int active = 0, status = 0;
> > +	unsigned int mask, active = 0, status = 0;
> > +
> > +	mask = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_SYNC_OE |
> > +	       TVP5150_MISC_CTL_CLOCK_OE;
> >  
> >  	regmap_read(map, TVP5150_INT_STATUS_REG_A, &status);
> >  	if (status) {
> >  		regmap_write(map, TVP5150_INT_STATUS_REG_A, status);
> >  
> > -		if (status & TVP5150_INT_A_LOCK)
> > +		if (status & TVP5150_INT_A_LOCK) {
> >  			decoder->lock = !!(status & TVP5150_INT_A_LOCK_STATUS);
> > +			regmap_update_bits(map, TVP5150_MISC_CTL, mask,
> > +					   decoder->lock ? decoder->oe : 0);
> > +		}
> >  
> >  		return IRQ_HANDLED;
> >  	}
> > @@ -872,10 +879,26 @@ static int tvp5150_enable(struct v4l2_subdev *sd)
> >  	/* Disable autoswitch mode */
> >  	tvp5150_set_std(sd, std);
> >  
> > -	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> > +	/*
> > +	 * Enable the YCbCr and clock outputs. In discrete sync mode
> > +	 * (non-BT.656) additionally enable the the sync outputs.
> > +	 */
> > +	switch (decoder->mbus_type) {
> > +	case V4L2_MBUS_PARALLEL:
> >  		/* 8-bit 4:2:2 YUV with discrete sync output */
> >  		regmap_update_bits(decoder->regmap, TVP5150_DATA_RATE_SEL,
> >  				   0x7, 0x0);
> > +		decoder->oe = TVP5150_MISC_CTL_YCBCR_OE |
> > +			      TVP5150_MISC_CTL_CLOCK_OE |
> > +			      TVP5150_MISC_CTL_SYNC_OE;
> > +		break;
> > +	case V4L2_MBUS_BT656:
> > +		decoder->oe = TVP5150_MISC_CTL_YCBCR_OE |
> > +			      TVP5150_MISC_CTL_CLOCK_OE;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> >  
> >  	return 0;
> >  };
> > @@ -1190,14 +1213,8 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> >  	if (enable) {
> >  		tvp5150_enable(sd);
> >  
> > -		/*
> > -		 * Enable the YCbCr and clock outputs. In discrete sync mode
> > -		 * (non-BT.656) additionally enable the the sync outputs.
> > -		 */
> > -		val = TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
> > -		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> > -			val |= TVP5150_MISC_CTL_SYNC_OE;
> > -
> > +		/* Enable outputs if decoder is locked */
> > +		val = decoder->lock ? decoder->oe : 0;
> 
> Hmm... this only works if the tvp5150 has the interrupts enabled.
> 
> The code should be, instead:
> 
> 	if (c->irq)
> 		val = decoder->lock ? decoder->oe : 0;
> 	else
> 		val = decoder->oe;

The previous patch "[media] tvp5150: Add sync lock interrupt handling"
adds the look mechanism. As you can see the lock will be always true
if there is no interrupt support during probe():

core->irq = c->irq;
tvp5150_reset(sd, 0);   /* Calls v4l2_ctrl_handler_setup() */
if (c->irq) {
	res = devm_request_threaded_irq(&c->dev, c->irq,
			NULL,
			tvp5150_isr,
			IRQF_TRIGGER_HIGH |
			IRQF_ONESHOT,
			"tvp5150", core);
	if (res)
		return res;
} else {
	core->lock = true;
}

I'am with you that your s_stream version looks a bit nicer but adds the
check again.

Regards,
Marco

> 
> >  		int_val = TVP5150_INT_A_LOCK;
> >  	}
> >  
> 
> 
> 
> Thanks,
> Mauro
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
