Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45818 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbeC2PCr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 11:02:47 -0400
Date: Thu, 29 Mar 2018 12:02:40 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Nasser <afshin.nasser@gmail.com>
Cc: p.zabel@pengutronix.de, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, bparrot@ti.com, garsilva@embeddedor.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: tvp5150: fix color burst lock instability
 on some hardware
Message-ID: <20180329120240.169a5f33@vento.lan>
In-Reply-To: <20180329143435.GA4392@smart-ThinkPad-T410>
References: <20180325225633.5899-1-Afshin.Nasser@gmail.com>
        <20180326064353.187f752c@vento.lan>
        <20180326222921.GA5373@smart-ThinkPad-T410>
        <20180329143435.GA4392@smart-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 29 Mar 2018 19:04:35 +0430
Nasser <afshin.nasser@gmail.com> escreveu:

> On Tue, Mar 27, 2018 at 02:59:21AM +0430, Nasser wrote:
> Hi Mauro,
> 
> Thank you for taking time to review my patch.
> 
> May be I should rephrase the commit message to something like:
> 	Use the default register values as suggested in TVP5150AM1 datasheet
> 
> As this is not a hardware-dependent issue. Am I missing something?

It is not a matter of rephasing, but, instead, to be sure that it won't
cause regressions on existing hardware.

Yet, it would worth if you could describe at the patch what hardware
did you test it, and if VBI was tested too.

Anyway, I'll try to find some time to run some tests on the hardware
I have with tvp5150 too.

Regards,
Mauro

> 
> > On Mon, Mar 26, 2018 at 06:43:53AM -0300, Mauro Carvalho Chehab wrote:  
> > > Hi Nasser,
> > > 
> > > Em Mon, 26 Mar 2018 03:26:33 +0430
> > > Nasser Afshin <afshin.nasser@gmail.com> escreveu:
> > >   
> > > > According to the datasheet, INTREQ/GPCL/VBLK should have a pull-up/down
> > > > resistor if it's been disabled. On hardware that does not have such
> > > > resistor, we should use the default output enable value.
> > > > This prevents the color burst lock instability problem.  
> > >  
> > 
> > Color burst lock instability is just a side effect of not using the
> > recommended value for this bit. If we use the recommended setting, we
> > will support more hardware while not breaking anything.
> >   
> > > If this is hardware-dependent, you should instead store it at
> > > OF (for SoC) or pass via platform_data (for PCI/USB devices).
> > >  
> > 
> > We have used the recommended value for this bit (as the datasheet
> > suggests) while we are in tvp5150_init_enable but in tvp5150_s_stream
> > we are using the wrong value.
> > 
> > Also we have this comment at line 319:
> >     /* Default values as sugested at TVP5150AM1 datasheet */
> > But as you see, TVP5150_MISC_CTL is not set to its suggested default
> > value.
> >    
> > > > 
> > > > Signed-off-by: Nasser Afshin <Afshin.Nasser@gmail.com>
> > > > ---
> > > >  drivers/media/i2c/tvp5150.c | 5 +++--
> > > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > > index 2476d812f669..0e9713814816 100644
> > > > --- a/drivers/media/i2c/tvp5150.c
> > > > +++ b/drivers/media/i2c/tvp5150.c
> > > > @@ -328,7 +328,7 @@ static const struct i2c_reg_value tvp5150_init_default[] = {
> > > >  		TVP5150_OP_MODE_CTL,0x00
> > > >  	},
> > > >  	{ /* 0x03 */
> > > > -		TVP5150_MISC_CTL,0x01
> > > > +		TVP5150_MISC_CTL,0x21
> > > >  	},
> > > >  	{ /* 0x06 */
> > > >  		TVP5150_COLOR_KIL_THSH_CTL,0x10
> > > > @@ -1072,7 +1072,8 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> > > >  		 * Enable the YCbCr and clock outputs. In discrete sync mode
> > > >  		 * (non-BT.656) additionally enable the the sync outputs.
> > > >  		 */
> > > > -		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE;
> > > > +		val |= TVP5150_MISC_CTL_YCBCR_OE | TVP5150_MISC_CTL_CLOCK_OE |
> > > > +			TVP5150_MISC_CTL_INTREQ_OE;
> > > >  		if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
> > > >  			val |= TVP5150_MISC_CTL_SYNC_OE;
> > > >  	}  
> > > 
> > > 
> > > 
> > > Thanks,
> > > Mauro  
> 
> Thanks,
> Nasser



Thanks,
Mauro
