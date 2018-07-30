Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57444 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731706AbeG3TnA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 15:43:00 -0400
Date: Mon, 30 Jul 2018 15:06:40 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 13/22] [media] tvp5150: disable output while signal not
 locked
Message-ID: <20180730150640.3503934d@coco.lan>
In-Reply-To: <20180730150058.30563d0f@coco.lan>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
        <20180628162054.25613-14-m.felsch@pengutronix.de>
        <20180730150058.30563d0f@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Jul 2018 15:00:58 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:

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
> 
> 
> >  		int_val = TVP5150_INT_A_LOCK;
> >  	}
> >  

In other words, I believe we need the enclosed patch to avoid causing
regressions on existing drivers.

I intend to run a test here with this tvp5150 series before merging,
in order to be sure that em28xx+tvp5150 devices will keep working.

Regards,
Mauro


[PATCH] tvp5150: if IRQ is not enabled, don't disable inputs at s_stream

The new IRQ logic sets decoder->lock if signal is locked.
That should work fine when IRQ is used, but not all tvp5150
clients set it.

So, keep the previous logic if IRQ is not enabled for tvp5150.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index f7c9203a3923..777e0e16787e 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1214,7 +1214,10 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 		tvp5150_enable(sd);
 
 		/* Enable outputs if decoder is locked */
-		val = decoder->lock ? decoder->oe : 0;
+		if (decoder->irq)
+			val = decoder->lock ? decoder->oe : 0;
+		else
+			val = decoder->oe;
 		int_val = TVP5150_INT_A_LOCK;
 	}
 


Thanks,
Mauro
