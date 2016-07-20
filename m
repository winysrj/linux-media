Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36586 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbcGTM3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 08:29:10 -0400
Received: by mail-lf0-f46.google.com with SMTP id g62so37114411lfe.3
        for <linux-media@vger.kernel.org>; Wed, 20 Jul 2016 05:29:09 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Wed, 20 Jul 2016 14:29:07 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com, lars@metafoo.de, hans.verkuil@cisco.com,
	mchehab@kernel.org
Subject: Re: [PATCH] [media] rcar-vin: add legacy mode for wrong media bus
 formats
Message-ID: <20160720122907.GC20569@bigcity.dyn.berto.se>
References: <20160708104327.6329-1-niklas.soderlund+renesas@ragnatech.se>
 <4776c0f7-22da-6e72-f0c8-c02fc07b38dc@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4776c0f7-22da-6e72-f0c8-c02fc07b38dc@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your feedback.

On 2016-07-20 11:48:40 +0200, Hans Verkuil wrote:
> On 07/08/2016 12:43 PM, Niklas Söderlund wrote:
> > A recent bugfix to adv7180 brought to light that the rcar-vin driver are
> > looking for the wrong media bus format. It was looking for a YUVU format
> > but then expecting UYVY data. The bugfix for adv7180 will break the
> > usage of rcar-vin together with a adv7180 as found on Renesas R-Car2
> > Koelsch boards for example.
> > 
> > This patch fix the rcar-vin driver to look for the correct UYVU formats
> > and adds a legacy mode. The legacy mode is needed since I don't know if
> > other devices provide a incorrect media bus format and I don't want to
> > break any working configurations. Hopefully the legacy mode can be
> > removed sometime in the future.
> 
> I'd rather have a version without the legacy code. You have to assume that
> subdevs return correct values otherwise what's the point of the mediabus
> formats?
> 
> So this is simply an adv7180 bug fix + this r-car fix to stay consistent
> with the adv7180.

On principal I agree with you. My goal with this patch is just to make 
sure there is no case where the rcar-vin driver won't work with the 
adv7180. The plan was to drop the legacy mode in a separate patch after 
both the adv7182 and rcar-vin patches where picked up.

I'm happy to drop the 'legacy support' for the wrong formats from this 
patch as long as I can be sure that there is no breaking. Should I 
rewrite this patch to drop the wrong formats and submit it as a series 
together with the adv7180 patch so they can be picked up together? Or do 
you know of a better way?

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-core.c | 39 +++++++++++++++++++++++++++--
> >  drivers/media/platform/rcar-vin/rcar-dma.c  |  4 +--
> >  2 files changed, 39 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > index 4b2007b..481d82a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > @@ -37,6 +37,7 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
> >  	struct v4l2_subdev_mbus_code_enum code = {
> >  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> >  	};
> > +	bool found;
> >  
> >  	sd = vin_to_source(vin);
> >  
> > @@ -45,8 +46,8 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
> >  		code.index++;
> >  		switch (code.code) {
> >  		case MEDIA_BUS_FMT_YUYV8_1X16:
> > -		case MEDIA_BUS_FMT_YUYV8_2X8:
> > -		case MEDIA_BUS_FMT_YUYV10_2X10:
> > +		case MEDIA_BUS_FMT_UYVY8_2X8:
> > +		case MEDIA_BUS_FMT_UYVY10_2X10:
> >  		case MEDIA_BUS_FMT_RGB888_1X24:
> >  			vin->source.code = code.code;
> >  			vin_dbg(vin, "Found supported media bus format: %d\n",
> > @@ -57,6 +58,40 @@ static int rvin_mbus_supported(struct rvin_dev *vin)
> >  		}
> >  	}
> >  
> > +	/*
> > +	 * Older versions where looking for the wrong media bus format.
> > +	 * It where looking for a YUVY format but then treated it as a
> > +	 * UYVY format. This was not noticed since atlest one subdevice
> > +	 * used for testing (adv7180) reported a YUVY media bus format
> > +	 * but provided UYVY data. There might be other unknown subdevices
> > +	 * which also do this, to not break compatibility try to use them
> > +	 * in legacy mode.
> > +	 */
> > +	found = false;
> > +	code.index = 0;
> > +	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
> > +		code.index++;
> > +		switch (code.code) {
> > +		case MEDIA_BUS_FMT_YUYV8_2X8:
> > +			vin->source.code = MEDIA_BUS_FMT_UYVY8_2X8;
> > +			found = true;
> > +			break;
> > +		case MEDIA_BUS_FMT_YUYV10_2X10:
> > +			vin->source.code = MEDIA_BUS_FMT_UYVY10_2X10;
> > +			found = true;
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +
> > +		if (found) {
> > +			vin_err(vin,
> > +				"media bus %d not supported, trying legacy mode %d\n",
> > +				code.code, vin->source.code);
> > +			return true;
> > +		}
> > +	}
> > +
> >  	return false;
> >  }
> >  
> > diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> > index dad3b03..0836b15 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> > @@ -169,7 +169,7 @@ static int rvin_setup(struct rvin_dev *vin)
> >  		vnmc |= VNMC_INF_YUV16;
> >  		input_is_yuv = true;
> >  		break;
> > -	case MEDIA_BUS_FMT_YUYV8_2X8:
> > +	case MEDIA_BUS_FMT_UYVY8_2X8:
> >  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> >  		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
> >  			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> > @@ -178,7 +178,7 @@ static int rvin_setup(struct rvin_dev *vin)
> >  	case MEDIA_BUS_FMT_RGB888_1X24:
> >  		vnmc |= VNMC_INF_RGB888;
> >  		break;
> > -	case MEDIA_BUS_FMT_YUYV10_2X10:
> > +	case MEDIA_BUS_FMT_UYVY10_2X10:
> >  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> >  		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
> >  			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> > 

-- 
Regards,
Niklas Söderlund
