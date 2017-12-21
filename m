Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:39648 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756731AbdLUAZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 19:25:49 -0500
Received: by mail-lf0-f66.google.com with SMTP id m20so12868444lfi.6
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 16:25:48 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 21 Dec 2017 01:25:45 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v9 18/28] rcar-vin: break out format alignment and
 checking
Message-ID: <20171221002545.GH32148@bigcity.dyn.berto.se>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-19-niklas.soderlund+renesas@ragnatech.se>
 <5606133.RJMpssMBTL@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5606133.RJMpssMBTL@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your comments.

On 2017-12-08 12:01:08 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:32 EET Niklas Söderlund wrote:
> > Part of the format alignment and checking can be shared with the Gen3
> > format handling. Break that part out to its own function. While doing
> > this clean up the checking and add more checks.
> 
> I'd split that in two patches, they are unrelated and should be reviewed 
> separately.

Good point, I will do so. In fact I will split this in to three patches.
- Move things to a separate new function
- Deal with the update bytesperline and sizeimage calculation
- Add the new check on pixelformat

> 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 98 +++++++++++++------------
> >  1 file changed, 51 insertions(+), 47 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > 56c5183f55922e1d..0ffbf0c16fb7b00e 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -86,6 +86,56 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format
> > *pix) return pix->bytesperline * pix->height;
> >  }
> > 
> > +static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format
> > *pix)
> > +{
> > +	u32 walign;
> > +
> > +	/* If requested format is not supported fallback to the default */
> > +	if (!rvin_format_from_pixel(pix->pixelformat)) {
> > +		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> > +			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> > +		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> > +	}
> > +
> > +	switch (pix->field) {
> > +	case V4L2_FIELD_TOP:
> > +	case V4L2_FIELD_BOTTOM:
> > +	case V4L2_FIELD_NONE:
> > +	case V4L2_FIELD_INTERLACED_TB:
> > +	case V4L2_FIELD_INTERLACED_BT:
> > +	case V4L2_FIELD_INTERLACED:
> > +		break;
> > +	default:
> > +		pix->field = V4L2_FIELD_NONE;
> > +		break;
> > +	}
> > +
> > +	/* Check that colorspace is reasonable, if not keep current */
> > +	if (!pix->colorspace || pix->colorspace >= 0xff)
> 
> Where does 0xff come from ? It seems a bit random to me.

It comes from v4l2-compliance source code, is that not how we are 
suppose to pass a compliance test? :-) Exact location is 
testColorspace() in utils/v4l2-compliance/v4l2-test-formats.cpp.  

The only other way I can think of is to list all formats from enum 
v4l2_colorspace in a swtich statement, but then if a new colorspace is 
added this will fall behind.  Other drivers just check for 
!pix->colorspace but that is not enough to pass the test.

On Gen2 this is not an issue as as you describe bellow the colorspace is 
always set to that of the source. But on Gen3 it's up to the user to set 
to colorspace if the default one is not right. Then this check is needed 
to not freak out v4l2-compliance.

I will keep this for now, and if I can think of something better I will 
switch to that. But I need to think more on this, in the mean time break 
it out to a separate patch.

> 
> > +		pix->colorspace = vin->format.colorspace;
> 
> I don't think that's a good idea. You should pick a default if the colorspace 
> can't be supported. Beside, what's the point in accepting colorspaces if 
> they're not handled by the driver ? Why don't you just set a fixed value based 
> on the colorspace reported by the source ?

Yes here I agree, it should set it to a default colorspace.

> 
> > +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> > +	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> > +
> > +	/* Limit to VIN capabilities */
> > +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> > +			      &pix->height, 4, vin->info->max_height, 2, 0);
> > +
> > +	pix->bytesperline = rvin_format_bytesperline(pix);
> > +	pix->sizeimage = rvin_format_sizeimage(pix);
> 
> You're now hardcoding those values instead of only enforcing a minimum. Why is 
> that ?

Hum I don't understand this comment I think. I checked other drivers and 
this looks like how most of them are calculating this (vimc, xilinx, 
etc).  This change is mostly to get rid of things that never should have 
made it out of soc_camera. It worked for Gen2 as bytesperline and 
sizeimage where updated when querying the sensor. While on Gen3 this 
will break as there is no sensor to update this and it is therefore 
impossible to reduce these values.

> 
> > +
> > +	if (vin->info->chip == RCAR_M1 &&
> > +	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> > +		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> > +		return -EINVAL;
> > +	}
> 
> You should move this with the other format check at the beginning of the 
> function. and selecting the default format instead of returning an error.

Yes will do.

> 
> > +	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> > +		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> > ---------------------------------------------------------------------------
> > -- * V4L2
> >   */
> > @@ -191,64 +241,18 @@ static int __rvin_try_format_source(struct rvin_dev
> > *vin, static int __rvin_try_format(struct rvin_dev *vin,
> >  			     u32 which, struct v4l2_pix_format *pix)
> >  {
> > -	u32 walign;
> >  	int ret;
> > 
> >  	/* Keep current field if no specific one is asked for */
> >  	if (pix->field == V4L2_FIELD_ANY)
> >  		pix->field = vin->format.field;
> > 
> > -	/* If requested format is not supported fallback to the default */
> > -	if (!rvin_format_from_pixel(pix->pixelformat)) {
> > -		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",
> > -			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> > -		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> > -	}
> > -
> > -	/* Always recalculate */
> > -	pix->bytesperline = 0;
> > -	pix->sizeimage = 0;
> > -
> >  	/* Limit to source capabilities */
> >  	ret = __rvin_try_format_source(vin, which, pix);
> >  	if (ret)
> >  		return ret;
> > 
> > -	switch (pix->field) {
> > -	case V4L2_FIELD_TOP:
> > -	case V4L2_FIELD_BOTTOM:
> > -	case V4L2_FIELD_NONE:
> > -	case V4L2_FIELD_INTERLACED_TB:
> > -	case V4L2_FIELD_INTERLACED_BT:
> > -	case V4L2_FIELD_INTERLACED:
> > -		break;
> > -	default:
> > -		pix->field = V4L2_FIELD_NONE;
> > -		break;
> > -	}
> > -
> > -	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> > -	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> > -
> > -	/* Limit to VIN capabilities */
> > -	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> > -			      &pix->height, 4, vin->info->max_height, 2, 0);
> > -
> > -	pix->bytesperline = max_t(u32, pix->bytesperline,
> > -				  rvin_format_bytesperline(pix));
> > -	pix->sizeimage = max_t(u32, pix->sizeimage,
> > -			       rvin_format_sizeimage(pix));
> > -
> > -	if (vin->info->chip == RCAR_M1 &&
> > -	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> > -		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> > -		return -EINVAL;
> > -	}
> > -
> > -	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> > -		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> > -
> > -	return 0;
> > +	return rvin_format_align(vin, pix);
> >  }
> > 
> >  static int rvin_querycap(struct file *file, void *priv,
> 
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund
