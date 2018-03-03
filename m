Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33835 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751898AbeCCQLp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Mar 2018 11:11:45 -0500
Received: by mail-lf0-f65.google.com with SMTP id l191so17409732lfe.1
        for <linux-media@vger.kernel.org>; Sat, 03 Mar 2018 08:11:44 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 3 Mar 2018 17:11:42 +0100
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v11 15/32] rcar-vin: break out format alignment and
 checking
Message-ID: <20180303161142.GJ12470@bigcity.dyn.berto.se>
References: <20180302015751.25596-1-niklas.soderlund+renesas@ragnatech.se>
 <20180302015751.25596-16-niklas.soderlund+renesas@ragnatech.se>
 <6918564.MduWiIMA4x@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6918564.MduWiIMA4x@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your feedback.

On 2018-03-02 11:53:54 +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 2 March 2018 03:57:34 EET Niklas Söderlund wrote:
> > Part of the format alignment and checking can be shared with the Gen3
> > format handling. Break that part out to a separate function.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/platform/rcar-vin/rcar-v4l2.c | 96 +++++++++++++++-----------
> >  1 file changed, 54 insertions(+), 42 deletions(-)
> > 
> > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
> > b94ca9ffb1d3b323..3290e603b44cdf3a 100644
> > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > @@ -87,6 +87,59 @@ static u32 rvin_format_sizeimage(struct v4l2_pix_format
> > *pix) return pix->bytesperline * pix->height;
> >  }
> > 
> > +static int rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format
> > *pix)
> > +{
> > +	u32 walign;
> > +
> > +	if (!rvin_format_from_pixel(pix->pixelformat) ||
> > +	    (vin->info->model == RCAR_M1 &&
> > +	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
> > +		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> > +
> > +	switch (pix->field) {
> > +	case V4L2_FIELD_TOP:
> > +	case V4L2_FIELD_BOTTOM:
> > +	case V4L2_FIELD_NONE:
> > +	case V4L2_FIELD_INTERLACED_TB:
> > +	case V4L2_FIELD_INTERLACED_BT:
> > +	case V4L2_FIELD_INTERLACED:
> > +		break;
> > +	case V4L2_FIELD_ALTERNATE:
> > +		/*
> > +		 * Driver do not (yet) support outputting ALTERNATE to a
> > +		 * userspace. It does support outputting INTERLACED so use
> > +		 * the VIN hardware to combine the two fields.
> > +		 */
> > +		pix->field = V4L2_FIELD_INTERLACED;
> > +		pix->height *= 2;
> > +		break;
> > +	default:
> > +		pix->field = RVIN_DEFAULT_FIELD;
> > +		break;
> > +	}
> > +
> > +	/* HW limit width to a multiple of 32 (2^5) for NV16 else 2 (2^1) */
> > +	walign = vin->format.pixelformat == V4L2_PIX_FMT_NV16 ? 5 : 1;
> > +
> > +	/* Limit to VIN capabilities */
> > +	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
> > +			      &pix->height, 4, vin->info->max_height, 2, 0);
> > +
> > +	pix->bytesperline = rvin_format_bytesperline(pix);
> > +	pix->sizeimage = rvin_format_sizeimage(pix);
> > +
> > +	if (vin->info->model == RCAR_M1 &&
> > +	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> > +		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
> > +		return -EINVAL;
> > +	}
> 
> This can't happen as you set the pixel format to the default earlier in the 
> same case.

This is the result of a bad re-ordering of the patches for v11 and 
should be removed. Thanks for spotting this! Sometime I get blind to my 
own code.

> 
> > +	vin_dbg(vin, "Format %ux%u bpl: %d size: %d\n",
> > +		pix->width, pix->height, pix->bytesperline, pix->sizeimage);
> 
> While at it you could use %u for bpl and size.

Thanks.

> 
> > +
> > +	return 0;
> > +}
> > +
> >  /* ------------------------------------------------------------------------
> >   * V4L2
> >   */
> > @@ -184,55 +237,14 @@ static int __rvin_try_format(struct rvin_dev *vin,
> >  			     struct v4l2_pix_format *pix,
> >  			     struct rvin_source_fmt *source)
> >  {
> > -	u32 walign;
> >  	int ret;
> > 
> > -	if (!rvin_format_from_pixel(pix->pixelformat) ||
> > -	    (vin->info->model == RCAR_M1 &&
> > -	     pix->pixelformat == V4L2_PIX_FMT_XBGR32))
> > -		pix->pixelformat = RVIN_DEFAULT_FORMAT;
> > -
> >  	/* Limit to source capabilities */
> >  	ret = __rvin_try_format_source(vin, which, pix, source);
> 
> This functions uses the pixel format. Isn't it a problem that you don't first 
> set it to the default if the requested pixel format isn't supported ?

Hum, yes it might be! I never thought about it but yes it's probably 
best to keep this check here. Thanks!

> 
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
> > -	case V4L2_FIELD_ALTERNATE:
> > -		/*
> > -		 * Driver do not (yet) support outputting ALTERNATE to a
> > -		 * userspace. It does support outputting INTERLACED so use
> > -		 * the VIN hardware to combine the two fields.
> > -		 */
> > -		pix->field = V4L2_FIELD_INTERLACED;
> > -		pix->height *= 2;
> > -		break;
> > -	default:
> > -		pix->field = RVIN_DEFAULT_FIELD;
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
> > -	pix->bytesperline = rvin_format_bytesperline(pix);
> > -	pix->sizeimage = rvin_format_sizeimage(pix);
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
