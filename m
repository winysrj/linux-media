Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45734 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbeCZW32 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 18:29:28 -0400
Date: Tue, 27 Mar 2018 02:59:21 +0430
From: Nasser <afshin.nasser@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: p.zabel@pengutronix.de, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, bparrot@ti.com, garsilva@embeddedor.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: tvp5150: fix color burst lock instability on
 some hardware
Message-ID: <20180326222921.GA5373@smart-ThinkPad-T410>
References: <20180325225633.5899-1-Afshin.Nasser@gmail.com>
 <20180326064353.187f752c@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180326064353.187f752c@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2018 at 06:43:53AM -0300, Mauro Carvalho Chehab wrote:
> Hi Nasser,
> 
> Em Mon, 26 Mar 2018 03:26:33 +0430
> Nasser Afshin <afshin.nasser@gmail.com> escreveu:
> 
> > According to the datasheet, INTREQ/GPCL/VBLK should have a pull-up/down
> > resistor if it's been disabled. On hardware that does not have such
> > resistor, we should use the default output enable value.
> > This prevents the color burst lock instability problem.
>

Color burst lock instability is just a side effect of not using the
recommended value for this bit. If we use the recommended setting, we
will support more hardware while not breaking anything.

> If this is hardware-dependent, you should instead store it at
> OF (for SoC) or pass via platform_data (for PCI/USB devices).
>

We have used the recommended value for this bit (as the datasheet
suggests) while we are in tvp5150_init_enable but in tvp5150_s_stream
we are using the wrong value.

Also we have this comment at line 319:
    /* Default values as sugested at TVP5150AM1 datasheet */
But as you see, TVP5150_MISC_CTL is not set to its suggested default
value.
 
> > 
> > Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
> > ---
> >  drivers/media/i2c/tvp5150.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > index 2476d812f669..0e9713814816 100644
> > --- a/drivers/media/i2c/tvp5150.c
> > +++ b/drivers/media/i2c/tvp5150.c
> > @@ -328,7 +328,7 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
> >  		TVP5150_OP_MODE_CTL,0x00
> >  	},
> >  	{ /* 0x03 */
> > -		TVP5150_MISC_CTL,0x01
> > +		TVP5150_MISC_CTL,0x21
> >  	},
> >  	{ /* 0x06 */
> >  		TVP5150_COLOR_KIL_THSH_CTL,0x10
> > @@ -1072,7 +1072,8 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> >  		 * Enable the YCbCr and clock outputs. In discrete sync mode
> >  		 * (non-BT.656) additionally enable the the sync outputs.
> >  		 */
> > -		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
> > +		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE |
> > +			TVP5150_MISC_CTL_INTREQ_OE;
> >  		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> >  			val |= TVP5150_MISC_CTL_SYNC_OE;
> >  	}
> 
> 
> 
> Thanks,
> Mauro
