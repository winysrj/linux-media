Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42651 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbeHBJvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2018 05:51:12 -0400
Date: Thu, 2 Aug 2018 10:01:01 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        p.zabel@pengutronix.de, afshin.nasser@gmail.com,
        javierm@redhat.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 16/22] [media] tvp5150: add querystd
Message-ID: <20180802080101.b3en5xcjclcyopfa@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-17-m.felsch@pengutronix.de>
 <20180730150945.3301864f@coco.lan>
 <20180801132125.j4725kthupcc7fnd@pengutronix.de>
 <20180801112212.4f450528@coco.lan>
 <20180801144926.ijqotetin4uhtxw6@pengutronix.de>
 <20180801125056.5d0b14c7@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801125056.5d0b14c7@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 18-08-01 12:50, Mauro Carvalho Chehab wrote:
> Em Wed, 1 Aug 2018 16:49:26 +0200
> Marco Felsch <m.felsch@pengutronix.de> escreveu:
> 
> > Hi Mauro,
> > 
> > On 18-08-01 11:22, Mauro Carvalho Chehab wrote:
> > > Em Wed, 1 Aug 2018 15:21:25 +0200
> > > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On 18-07-30 15:09, Mauro Carvalho Chehab wrote:  
> > > > > Em Thu, 28 Jun 2018 18:20:48 +0200
> > > > > Marco Felsch <m.felsch@pengutronix.de> escreveu:
> > > > >     
> > > > > > From: Philipp Zabel <p.zabel@pengutronix.de>
> > > > > > 
> > > > > > Add the querystd video_op and make it return V4L2_STD_UNKNOWN while the
> > > > > > TVP5150 is not locked to a signal.
> > > > > > 
> > > > > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > > > ---
> > > > > >  drivers/media/i2c/tvp5150.c | 10 ++++++++++
> > > > > >  1 file changed, 10 insertions(+)
> > > > > > 
> > > > > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > > > > index 99d887936ea0..1990aaa17749 100644
> > > > > > --- a/drivers/media/i2c/tvp5150.c
> > > > > > +++ b/drivers/media/i2c/tvp5150.c
> > > > > > @@ -796,6 +796,15 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
> > > > > >  	}
> > > > > >  }
> > > > > >  
> > > > > > +static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
> > > > > > +{
> > > > > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > > > > +
> > > > > > +	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;    
> > > > > 
> > > > > This patch requires rework. What happens when a device doesn't have
> > > > > IRQ enabled? Perhaps it should, instead, read some register in order
> > > > > to check for the locking status, as this would work on both cases.    
> > > > 
> > > > If IRQ isn't enabled, decoder->lock is set to always true during
> > > > probe(). So this case should be fine.  
> > > 
> > > Not sure if tvp5150_read_std() will do the right thing. If it does,
> > > the above could simply be:
> > > 	std_id = tvp5150_read_std(sd);
> > > 
> > > But, as there are 3 variants of this chipset, it sounds safer to check
> > > if the device is locked before calling tvp5150_read_std().  
> > 
> > Yes, I'm with you.
> > 
> > > 
> > > IMHO, the best would be to have a patch like the one below.
> > > 
> > > Regards,
> > > Mauro
> > > 
> > > [PATCH] media: tvp5150: implement decoder lock when irq is not used
> > > 
> > > When irq is used, the lock is set via IRQ code. When it isn't,
> > > the driver just assumes it is always locked. Instead, read the
> > > lock status from the status register.  
> > 
> > Yes, that is a better solution.
> > 
> > > 
> > > Compile-tested only.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > 
> > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > index 75e5ffc6573d..e07020d4053d 100644
> > > --- a/drivers/media/i2c/tvp5150.c
> > > +++ b/drivers/media/i2c/tvp5150.c
> > > @@ -811,11 +811,24 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
> > >  	}
> > >  }
> > >  
> > > +static int query_lock(struct v4l2_subdev *sd)
> > > +{
> > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > +	int status;
> > > +
> > > +	if (decoder->irq)
> > > +		return decoder->lock;
> > > +
> > > +	regmap_read(map, TVP5150_INT_STATUS_REG_A, &status);
> > > +
> > > +	return (status & 0x06) == 0x06;  
> > 
> > Typo? It should be 0x80, as described in the datasheet (SLES209E) or
> > just use the TVP5150_INT_A_LOCK_STATUS define. This avoid datasheet
> > cross check during reading.
> 
> Yes, it is a typo, but at the other line... I meant to use the register
> 0x88, e. g.:
> 
> 	regmap_read(decoder->regmap, TVP5150_STATUS_REG_1, &status);

During my development I tried this status register too, as descibed on
the community website [1]. But that wasn't that good, because the look
will be lost very often. Bit7 of Interrupt Status Reg A (0xc0) is more
robust for that kind of work, since it covers the whole signal.

[1] http://e2e.ti.com/support/data_converters/videoconverters/f/918/p/ \
	617120/2273276?keyMatch=tvp5150%20lock%20lost&tisearch=Search-EN-Support
> 
> I ran some tests here: the int status reg is not updated.
> 
> Also, after thinking a little bit, I opted to not use the query_lock()
> at s_stream. It makes no sense there without adding a status polling
> logic. I also opted to remove initializing decoder->lock to true, as
> this is very counter-intuitive. Instead, I'm adding a test at s_stream
> if decoder->irq is set. This makes easier to understand the code.

Yes, you're right.

> Btw, on my tests here, I noticed a problem with S-Video... at least with
> AV-350 grabber, composite is only working when S-Video is connected.

Unfortunately I have only a custom board with one composite connection.

> 
> This bug also happens before your patchset, so this is not a regression
> caused by your patches.
> 
> Anyway, patch enclosed. I added it together with my patch series at:
> 
> 	https://git.linuxtv.org/mchehab/experimental.git/log/?h=tvp5150-2

Did you drop the DT of_graph support patch? It was there on your first
tvp5150 branch. 

> 
> I'll keep doing more tests here.
> 
> > 
> > > +}
> > > +
> > >  static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
> > >  {
> > >  	struct tvp5150 *decoder = to_tvp5150(sd);
> > >  
> > > -	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
> > > +	*std_id = query_lock(sd) ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
> > >  
> > >  	return 0;
> > >  }
> > > @@ -1247,7 +1260,7 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
> > >  		tvp5150_enable(sd);
> > >  
> > >  		/* Enable outputs if decoder is locked */
> > > -		val = decoder->lock ? decoder->oe : 0;
> > > +		val = query_lock(sd) ? decoder->oe : 0;
> > >  		int_val = TVP5150_INT_A_LOCK;
> > >  		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
> > >  	}
> > > @@ -1816,8 +1829,6 @@ static int tvp5150_probe(struct i2c_client *c,
> > >  						IRQF_ONESHOT, "tvp5150", core);
> > >  		if (res)
> > >  			return res;
> > > -	} else {
> > > -		core->lock = true;
> > >  	}
> > >  
> > >  	res = v4l2_async_register_subdev(sd);
> > > 
> > > 
> > >   
> 
> [PATCH] media: tvp5150: implement decoder lock when irq is not used
> 
> When irq is used, the lock is set via IRQ code. When it isn't,
> the driver just assumes it is always locked. Instead, read the
> lock status from the status register.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index efc441df7cac..e74af68be2eb 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -810,11 +810,25 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
>  	}
>  }
>  
> +static int query_lock(struct v4l2_subdev *sd)
> +{
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +	int status;
> +
> +	if (decoder->irq)
> +		return decoder->lock;
> +
> +	regmap_read(decoder->regmap, TVP5150_STATUS_REG_1, &status);
> +
> +	/* For standard detection, we need the 3 locks */
> +	return (status & 0x0e) == 0x0e;
> +}
> +
>  static int tvp5150_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
>  {
>  	struct tvp5150 *decoder = to_tvp5150(sd);

We should drop the decoder var here and not in the cleanup patch "media:
tvp5150: get rid of some warnings". There are always two version of the
patch that remove the 'static' warning [2,3].

[2] https://www.spinics.net/lists/linux-media/msg138318.html
[3] https://www.spinics.net/lists/linux-media/msg138363.html

Regards,
Marco
>  
> -	*std_id = decoder->lock ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
> +	*std_id = query_lock(sd) ? tvp5150_read_std(sd) : V4L2_STD_UNKNOWN;
>  
>  	return 0;
>  }
> @@ -1208,7 +1222,10 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
>  		tvp5150_enable(sd);
>  
>  		/* Enable outputs if decoder is locked */
> -		val = decoder->lock ? decoder->oe : 0;
> +		if (decoder->irq)
> +			val = decoder->lock ? decoder->oe : 0;
> +		else
> +			val = decoder->oe;
>  		int_val = TVP5150_INT_A_LOCK;
>  		v4l2_subdev_notify_event(&decoder->sd, &tvp5150_ev_fmt);
>  	}
> @@ -1777,8 +1794,6 @@ static int tvp5150_probe(struct i2c_client *c,
>  						IRQF_ONESHOT, "tvp5150", core);
>  		if (res)
>  			return res;
> -	} else {
> -		core->lock = true;
>  	}
>  
>  	res = v4l2_async_register_subdev(sd);
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
